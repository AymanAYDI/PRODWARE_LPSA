report 50060 "PWD Inventory Recovery"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>NDBI
    // LALE.PA : 13/04/2021 : P27818_001/P27818_002 DEMANDES DIVERSES suite TI525814
    //                   - New report

    Caption = 'Inventory Recovery';
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Control1000000000)
                {
                    Caption = 'Inventory';
                    ShowCaption = false;
                    field(CodGDocNo; CodGDocNo)
                    {
                        Caption = 'Document No for Inventory Recovery';
                        ShowCaption = false;
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        RecLItem: Record Item;
        RecLReservationEntry: Record "Reservation Entry";
        IntLEntryNoLast: Integer;
        IntLineNo: Integer;
    begin
        if CodGDocNo = '' then
            Error(CstG006);

        if RecGItemJnlLineBuffer.IsEmpty and RecGItemLedgerEntryBuffer.IsEmpty then
            Error(CstG005);

        RecGItemJnlLineBuffer.FindFirst();
        CodGJnlTemplateName := RecGItemJnlLineBuffer."Journal Template Name";
        CodGJnlBatchName := RecGItemJnlLineBuffer."Journal Batch Name";

        BooGProcess := true;

        RecGItemJnlLine.Reset();
        RecGItemJnlLine.SetRange("Journal Template Name", CodGJnlTemplateName);
        RecGItemJnlLine.SetRange("Journal Batch Name", CodGJnlBatchName);
        if RecGItemJnlLine.IsEmpty then begin
            if not Confirm(CstG001, false, CodGJnlTemplateName, CodGJnlBatchName) then
                BooGProcess := false;
        end else
            if not Confirm(CstG002, false, CodGJnlTemplateName, CodGJnlBatchName) then
                BooGProcess := false;

        if BooGProcess then begin
            RecGItemJnlLine.Reset();
            RecGItemJnlLine.SetRange("Journal Template Name", CodGJnlTemplateName);
            RecGItemJnlLine.SetRange("Journal Batch Name", CodGJnlBatchName);
            if not RecGItemJnlLine.IsEmpty then
                RecGItemJnlLine.DeleteAll();

            IntLineNo := 10000;
            RecGItemJnlLineBuffer.Reset();
            if RecGItemJnlLineBuffer.FindFirst() then
                repeat
                    // pour la reprise de l'inventaire on crée une ligne par écriture article mémorisée pour chaque ligne feuille article mémorisée
                    // afin de reprendre le coût unitaire de l'écriture article
                    RecGItemLedgerEntryBuffer.Reset();
                    RecGItemLedgerEntryBuffer.SetRange("Item No.", RecGItemJnlLineBuffer."Item No.");
                    RecGItemLedgerEntryBuffer.SetRange("Variant Code", RecGItemJnlLineBuffer."Variant Code");
                    RecGItemLedgerEntryBuffer.SetRange("Location Code", RecGItemJnlLineBuffer."Location Code");
                    RecGItemLedgerEntryBuffer.SetRange(Open, true);
                    if RecGItemLedgerEntryBuffer.FindFirst() then
                        repeat
                            RecGItemJnlLine.TransferFields(RecGItemJnlLineBuffer);
                            RecGItemJnlLine."Qty. (Calculated)" := 0;
                            RecGItemJnlLine."Line No." := IntLineNo;
                            RecGItemJnlLine.Validate("Document No.", CodGDocNo);
                            if RecGItemJnlLine."Entry Type" = RecGItemJnlLine."Entry Type"::"Positive Adjmt." then
                                RecGItemJnlLine.Validate("Qty. (Phys. Inventory)", Abs(RecGItemLedgerEntryBuffer."Remaining Quantity"))
                            else
                                RecGItemJnlLine.Validate("Qty. (Phys. Inventory)", -Abs(RecGItemLedgerEntryBuffer."Remaining Quantity"));
                            RecGItemLedgerEntryBuffer.CalcFields("Cost Amount (Actual)");
                            RecGItemJnlLine.Validate("Unit Cost", RecGItemLedgerEntryBuffer."Cost Amount (Actual)" /
                                                                 RecGItemLedgerEntryBuffer."Invoiced Quantity");
                            RecGItemJnlLine.Insert();

                            IntLineNo += 10000;

                            // création Traçabilité de la ligne si besoin
                            RecLItem.Get(RecGItemJnlLine."Item No.");
                            if RecLItem."Item Tracking Code" <> '' then begin
                                // On supprime les lignes de la T337 lié à la ligne de notre feuille
                                RecLReservationEntry.Reset();
                                RecLReservationEntry.SetRange("Source Type", 83);
                                RecLReservationEntry.SetRange("Source ID", RecGItemJnlLine."Journal Template Name");
                                RecLReservationEntry.SetRange("Source Batch Name", RecGItemJnlLine."Journal Batch Name");
                                RecLReservationEntry.SetRange("Source Ref. No.", RecGItemJnlLine."Line No.");
                                RecLReservationEntry.DeleteAll();

                                RecLReservationEntry.Reset();
                                RecLReservationEntry.FindLast();
                                IntLEntryNoLast := RecLReservationEntry."Entry No.";
                                RecLReservationEntry."Entry No." := IntLEntryNoLast + 1;
                                if RecGItemJnlLine."Entry Type" = RecGItemJnlLine."Entry Type"::"Positive Adjmt." then
                                    RecLReservationEntry.Positive := true
                                else
                                    RecLReservationEntry.Positive := false;
                                RecLReservationEntry."Item No." := RecGItemJnlLine."Item No.";
                                RecLReservationEntry."Location Code" := RecGItemJnlLine."Location Code";
                                RecLReservationEntry."Reservation Status" := RecLReservationEntry."Reservation Status"::Prospect;
                                RecLReservationEntry."Creation Date" := WorkDate();
                                RecLReservationEntry."Source Type" := DATABASE::"Item Journal Line";
                                RecLReservationEntry."Source Subtype" := RecGItemJnlLine."Entry Type".AsInteger();
                                RecLReservationEntry."Source ID" := RecGItemJnlLine."Journal Template Name";
                                RecLReservationEntry."Source Batch Name" := RecGItemJnlLine."Journal Batch Name";
                                RecLReservationEntry."Source Ref. No." := RecGItemJnlLine."Line No.";
                                RecLReservationEntry."Shipment Date" := WorkDate();
                                RecLReservationEntry."Created By" := UserId;
                                RecLReservationEntry."Qty. per Unit of Measure" := RecGItemJnlLine."Qty. per Unit of Measure";
                                if RecGItemJnlLine."Entry Type" = RecGItemJnlLine."Entry Type"::"Positive Adjmt." then
                                    RecLReservationEntry.Validate("Quantity (Base)", Abs(RecGItemLedgerEntryBuffer."Remaining Quantity"))
                                else
                                    RecLReservationEntry.Validate("Quantity (Base)", -Abs(RecGItemLedgerEntryBuffer."Remaining Quantity"));
                                RecLReservationEntry."Variant Code" := RecGItemJnlLine."Variant Code";
                                RecLReservationEntry."Source Prod. Order Line" := 0;
                                RecLReservationEntry."Lot No." := RecGItemLedgerEntryBuffer."Lot No.";
                                RecLReservationEntry."Serial No." := RecGItemLedgerEntryBuffer."Serial No.";
                                RecLReservationEntry."Item Tracking" := RecLReservationEntry."Item Tracking"::"Lot No.";
                                RecLReservationEntry.Insert();

                            end;
                            RecGItemJnlLine.CreateDim(
                                                   DATABASE::Item, RecGItemJnlLine."Item No.",
                                                   DATABASE::"Salesperson/Purchaser", RecGItemJnlLine."Salespers./Purch. Code",
                                                   DATABASE::"Work Center", RecGItemJnlLine."Work Center No.");
                        until RecGItemLedgerEntryBuffer.Next() = 0;
                until RecGItemJnlLineBuffer.Next() = 0;

            /*
               RecGItemJnlLineBuffer.RESET;
               RecGItemJnlLineBuffer.DELETEALL;
               RecGItemLedgerEntryBuffer.RESET;
               RecGItemLedgerEntryBuffer.DELETEALL;
            */
            Message(CstG004);

        end else
            Error(CstG003);

    end;

    var
        RecGItemJnlLine: Record "Item Journal Line";
        RecGItemJnlLineBuffer: Record "PWD Item Jnl Line Buffer";
        RecGItemLedgerEntryBuffer: Record "PWD Item Ledger Entry Buffer";
        BooGProcess: Boolean;
        CodGJnlBatchName: Code[10];
        CodGJnlTemplateName: Code[10];
        CodGDocNo: Code[20];
        CstG001: Label 'Voulez-vous importer dans la feuille %1 %2, les lignes mémorisées ?';
        CstG002: Label 'Dans la feuille %1 %2, il existe des lignes, Voulez-vous qu''elles soient supprimer afin d''importer les lignes mémorisées ?';
        CstG003: Label 'Traitement annulé !';
        CstG004: Label 'Import Terminé ! Merci de valider la feuille %1 %2.';
        CstG005: Label 'Les tables Buffer sont vides, import impossible !';
        CstG006: Label 'Merci de préciser le N° de document pour la reprise d''inventaire.';
}

