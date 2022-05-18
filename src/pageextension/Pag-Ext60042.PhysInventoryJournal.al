pageextension 60042 "PWD PhysInventoryJournal" extends "Phys. Inventory Journal"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>NDBI
    // LALE.PA : 13/04/2021 : P27818_001/P27818_002 DEMANDES DIVERSES suite TI525814
    //                   - Add C/AL Globals CstG001..CstG004
    //                   - Add Actions UpdateDim, CopyToBuffer, ResetQty
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    layout
    {
        addafter(Description)
        {
            field("PWD LPSA description 1"; Rec."PWD LPSA description 1")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter(CalculateCountingPeriod)
        {
            action("PWD UpdateDim")
            {
                Caption = 'Transfer Dimensions from the item';
                ApplicationArea = All;
                Image = Dimensions;
                trigger OnAction()
                var
                    RecLItemJournalLine: Record "Item Journal Line";
                begin
                    IF CONFIRM(CstG001, FALSE, Rec."Journal Template Name", Rec."Journal Batch Name") THEN BEGIN
                        RecLItemJournalLine.RESET();
                        RecLItemJournalLine.SETRANGE("Journal Template Name", Rec."Journal Template Name");
                        RecLItemJournalLine.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
                        IF RecLItemJournalLine.FINDFIRST() THEN
                            REPEAT
                                RecLItemJournalLine.CreateDim(
                                  DATABASE::Item, Rec."Item No.",
                                  DATABASE::"Salesperson/Purchaser", Rec."Salespers./Purch. Code",
                                  DATABASE::"Work Center", Rec."Work Center No.");

                            UNTIL RecLItemJournalLine.NEXT() = 0;
                    END ELSE
                        MESSAGE(CstG004);
                end;
            }
            action("PWD CopyToBuffer")
            {
                Caption = 'Copy journal to buffer';
                ApplicationArea = All;
                Image = Copy;
                trigger OnAction()
                var
                    RecLItemLedgerEntry: Record "Item Ledger Entry";
                    RecLItemJournalLine: Record "Item Journal Line";
                    RecLItemJnlLineBuffer: Record "PWD Item Jnl Line Buffer";
                    RecLItemLedgerEntryBuffer: Record "PWD Item Ledger Entry Buffer";
                    BooLProcess: Boolean;
                begin
                    BooLProcess := TRUE;

                    IF NOT CONFIRM(CstG002, FALSE, Rec."Journal Template Name", Rec."Journal Batch Name") THEN
                        BooLProcess := FALSE;

                    IF BooLProcess AND
                       ((NOT RecLItemJnlLineBuffer.ISEMPTY) OR (NOT RecLItemLedgerEntryBuffer.ISEMPTY)) THEN
                        IF NOT CONFIRM(CstG005, FALSE) THEN
                            BooLProcess := FALSE;

                    IF BooLProcess THEN BEGIN
                        RecLItemJnlLineBuffer.DELETEALL();
                        RecLItemLedgerEntryBuffer.DELETEALL();
                        RecLItemJournalLine.RESET();
                        RecLItemJournalLine.SETRANGE("Journal Template Name", Rec."Journal Template Name");
                        RecLItemJournalLine.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
                        IF RecLItemJournalLine.FINDFIRST() THEN
                            REPEAT
                                RecLItemJnlLineBuffer.TRANSFERFIELDS(RecLItemJournalLine);
                                RecLItemJnlLineBuffer.INSERT();

                                RecLItemLedgerEntry.RESET();
                                RecLItemLedgerEntry.SETRANGE("Item No.", RecLItemJournalLine."Item No.");
                                RecLItemLedgerEntry.SETRANGE("Variant Code", RecLItemJournalLine."Variant Code");
                                RecLItemLedgerEntry.SETRANGE("Location Code", RecLItemJournalLine."Location Code");
                                RecLItemLedgerEntry.SETRANGE(Open, TRUE);
                                IF RecLItemLedgerEntry.FINDFIRST() THEN
                                    REPEAT
                                        RecLItemLedgerEntry.CALCFIELDS("Cost Amount (Expected)");
                                        IF RecLItemLedgerEntry."Cost Amount (Expected)" <> 0 THEN
                                            ERROR(CstG007, RecLItemLedgerEntry."Item No.", RecLItemLedgerEntry."Document No.");
                                        RecLItemLedgerEntryBuffer.TRANSFERFIELDS(RecLItemLedgerEntry);
                                        RecLItemLedgerEntryBuffer.INSERT();
                                    UNTIL RecLItemLedgerEntry.NEXT() = 0;
                            UNTIL RecLItemJournalLine.NEXT() = 0;
                    END ELSE
                        MESSAGE(CstG004);
                end;
            }
            action("PWD ResetQty")
            {
                Caption = 'Reset Qty. (Phys. Inventory)';
                ApplicationArea = All;
                Image = PhysicalInventory;
                trigger OnAction()
                var
                    RecLItem: Record Item;
                    RecLItemJournalLine: Record "Item Journal Line";
                    RecLReservationEntry: Record "Reservation Entry";
                    RecLItemJnlLineBuffer: Record "PWD Item Jnl Line Buffer";
                    RecLItemLedgerEntryBuffer: Record "PWD Item Ledger Entry Buffer";
                    IntLEntryNoLast: Integer;
                begin
                    IF CONFIRM(CstG003, FALSE, Rec."Journal Template Name", Rec."Journal Batch Name") THEN BEGIN
                        IF RecLItemJnlLineBuffer.ISEMPTY AND RecLItemLedgerEntryBuffer.ISEMPTY THEN
                            ERROR(CstG006);
                        RecLItemJournalLine.RESET();
                        RecLItemJournalLine.SETRANGE("Journal Template Name", Rec."Journal Template Name");
                        RecLItemJournalLine.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
                        IF RecLItemJournalLine.FINDFIRST() THEN
                            REPEAT
                                RecLItemJournalLine.VALIDATE("Qty. (Phys. Inventory)", 0);
                                RecLItemJournalLine.MODIFY(TRUE);
                                // création Traçabilité de la ligne si besoin
                                RecLItem.GET(RecLItemJournalLine."Item No.");
                                IF RecLItem."Item Tracking Code" <> '' THEN BEGIN
                                    // On supprime les lignes de la T337 lié à la ligne de notre feuille
                                    RecLReservationEntry.RESET();
                                    RecLReservationEntry.SETRANGE("Source Type", 83);
                                    RecLReservationEntry.SETRANGE("Source ID", RecLItemJournalLine."Journal Template Name");
                                    RecLReservationEntry.SETRANGE("Source Batch Name", RecLItemJournalLine."Journal Batch Name");
                                    RecLReservationEntry.SETRANGE("Source Ref. No.", RecLItemJournalLine."Line No.");
                                    RecLReservationEntry.DELETEALL();

                                    RecLItemLedgerEntryBuffer.RESET();
                                    RecLItemLedgerEntryBuffer.SETRANGE("Item No.", RecLItemJournalLine."Item No.");
                                    RecLItemLedgerEntryBuffer.SETRANGE("Variant Code", RecLItemJournalLine."Variant Code");
                                    RecLItemLedgerEntryBuffer.SETRANGE("Location Code", RecLItemJournalLine."Location Code");
                                    RecLItemLedgerEntryBuffer.SETRANGE(Open, TRUE);
                                    IF RecLItemLedgerEntryBuffer.FindSet() THEN
                                        REPEAT
                                            RecLReservationEntry.RESET();
                                            RecLReservationEntry.FINDLAST();
                                            IntLEntryNoLast := RecLReservationEntry."Entry No.";
                                            RecLReservationEntry."Entry No." := IntLEntryNoLast + 1;
                                            IF RecLItemJournalLine."Entry Type" = RecLItemJournalLine."Entry Type"::"Positive Adjmt." THEN
                                                RecLReservationEntry.Positive := TRUE
                                            ELSE
                                                RecLReservationEntry.Positive := FALSE;
                                            RecLReservationEntry."Item No." := RecLItemJournalLine."Item No.";
                                            RecLReservationEntry."Location Code" := RecLItemJournalLine."Location Code";
                                            RecLReservationEntry."Reservation Status" := RecLReservationEntry."Reservation Status"::Prospect;
                                            RecLReservationEntry."Creation Date" := WORKDATE();
                                            RecLReservationEntry."Source Type" := DATABASE::"Item Journal Line";
                                            RecLReservationEntry."Source Subtype" := RecLItemJournalLine."Entry Type".AsInteger();
                                            RecLReservationEntry."Source ID" := RecLItemJournalLine."Journal Template Name";
                                            RecLReservationEntry."Source Batch Name" := RecLItemJournalLine."Journal Batch Name";
                                            RecLReservationEntry."Source Ref. No." := RecLItemJournalLine."Line No.";
                                            RecLReservationEntry."Shipment Date" := WORKDATE();
                                            RecLReservationEntry."Created By" := USERID;
                                            RecLReservationEntry."Qty. per Unit of Measure" := RecLItemJournalLine."Qty. per Unit of Measure";
                                            IF RecLItemJournalLine."Entry Type" = RecLItemJournalLine."Entry Type"::"Positive Adjmt." THEN
                                                RecLReservationEntry.VALIDATE("Quantity (Base)", ABS(RecLItemLedgerEntryBuffer."Remaining Quantity"))
                                            ELSE
                                                RecLReservationEntry.VALIDATE("Quantity (Base)", -ABS(RecLItemLedgerEntryBuffer."Remaining Quantity"));
                                            RecLReservationEntry."Variant Code" := RecLItemJournalLine."Variant Code";
                                            RecLReservationEntry."Source Prod. Order Line" := 0;
                                            RecLReservationEntry."Lot No." := RecLItemLedgerEntryBuffer."Lot No.";
                                            RecLReservationEntry."Serial No." := RecLItemLedgerEntryBuffer."Serial No.";
                                            RecLReservationEntry."Item Tracking" := RecLReservationEntry."Item Tracking"::"Lot No.";
                                            RecLReservationEntry.INSERT();
                                        UNTIL RecLItemLedgerEntryBuffer.NEXT() = 0;
                                END;
                            UNTIL RecLItemJournalLine.NEXT() = 0;
                    END ELSE
                        MESSAGE(CstG004);
                end;
            }
        }
    }

    var
        CstG001: Label 'Do you want to use the values of dimensions sections present on the item on the lines of the %1 sheet %2 ?';
        CstG002: Label 'Do you want to copy the lines from %1 sheet %2 to the Buffer?';
        CstG003: Label 'Do you want to reset the quantity observed for the lines of the %1 sheet %2 ?';
        CstG004: Label 'Process cancelled !';
        CstG005: Label 'Please note that the buffer tables for the inventory valuation mode mass change processing are not empty and will be emptied if you wish to continue. \ Are you sure you have completed all stages of this treatment?';
        CstG006: Label 'Reset stopped because the buffer tables to store the rows are empty!';
        CstG007: Label 'Attention pour l''article %1 l''écriture correspondant au document %2 n''a pas été entiérement facturée !\Traitement annulé !';
}

