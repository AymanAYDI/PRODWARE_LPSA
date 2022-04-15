xmlport 8073326 "PWD Stock Export OSYS"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.06
    // OSYS-Int001.001:GR 24/10/2011   Connector integration
    //                                   - Create Object
    // 
    // +----------------------------------------------------------------------------------------------------------------+

    Caption = 'Stock Export OSYS';
    Encoding = UTF8;

    schema
    {
        textelement(OSYS)
        {
            tableelement("Item Ledger Entry"; "Item Ledger Entry")
            {
                XmlName = 'T_ItemStock';
                UseTemporary = true;
                textelement(F_ItemNo)
                {

                    trigger OnBeforePassVariable()
                    var
                        RecLOSYSSetup: Record "PWD OSYS Setup";
                    begin
                        RecLOSYSSetup.Get();
                        if "Item Ledger Entry"."Variant Code" <> '' then
                            F_ItemNo := "Item Ledger Entry"."Item No." + RecLOSYSSetup."Separator Character" + "Item Ledger Entry"."Variant Code"
                        else
                            F_ItemNo := "Item Ledger Entry"."Item No.";

                        if not RecGItem.Get("Item Ledger Entry"."Item No.") then
                            RecGItem.Init();
                    end;
                }
                textelement(F_Quantity)
                {

                    trigger OnBeforePassVariable()
                    begin
                        F_Quantity := Format("Item Ledger Entry".Quantity, 0, 2);
                    end;
                }
                textelement(F_Unit)
                {

                    trigger OnBeforePassVariable()
                    begin
                        F_Unit := RecGItem."Base Unit of Measure";
                    end;
                }
                textelement(F_TrackingCode)
                {

                    trigger OnBeforePassVariable()
                    begin
                        F_TrackingCode := RecGItem."Item Tracking Code";
                    end;
                }
                fieldelement(F_LotNo; "Item Ledger Entry"."Lot No.")
                {
                }
                fieldelement(F_SerialNo; "Item Ledger Entry"."Serial No.")
                {
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    var
        RecGMessgae: Record "PWD Connector Messages";
        RecGItem: Record Item;


    procedure FctDefinePartner(RecPMessgae: Record "PWD Connector Messages")
    begin
        RecGMessgae := RecPMessgae;
    end;


    procedure FctInitXML(): Boolean
    var
        CduLConnectorBufferMgtExport: Codeunit "Connector Buffer Mgt Export";
        BooLResult: Boolean;
        RecordRef: RecordRef;
        RecLItemLedgerEntry: Record "Item Ledger Entry";
        RecLItemLedgerEntry2: Record "Item Ledger Entry";
        IntLSequenceNo: Integer;
        CodLLastItemNo: Code[20];
        CodLLastVariantCode: Code[10];
        CodLLastLotNo: Code[20];
        CodLLastSerialNo: Code[20];
    begin
        BooLResult := true;
        IntLSequenceNo := 0;
        CodLLastItemNo := '';
        CodLLastVariantCode := '';
        CodLLastLotNo := '';
        CodLLastSerialNo := '';
        "Item Ledger Entry".DeleteAll();
        CduLConnectorBufferMgtExport.FctInitValidateField(RecGMessgae."Partner Code", 0);
        RecLItemLedgerEntry.SetCurrentKey(Open, "Item Tracking", "Item No.", "Variant Code", "Lot No.", "Serial No.");
        RecLItemLedgerEntry.SetRange(Open, true);
        RecLItemLedgerEntry.SetFilter("Item Tracking", '<>%1', RecLItemLedgerEntry."Item Tracking"::None);
        if not RecLItemLedgerEntry.IsEmpty then begin
            RecLItemLedgerEntry.FindSet();
            repeat
                if FctNewRecord(RecLItemLedgerEntry, CodLLastItemNo, CodLLastVariantCode, CodLLastLotNo, CodLLastSerialNo) then begin
                    RecordRef.GetTable(RecLItemLedgerEntry);
                    if not CduLConnectorBufferMgtExport.FctCheckFields(RecordRef) then begin
                        RecordRef.SetTable(RecLItemLedgerEntry2);
                        IntLSequenceNo += 1;
                        "Item Ledger Entry".Init();
                        "Item Ledger Entry"."Entry No." := IntLSequenceNo;
                        "Item Ledger Entry"."Item No." := RecLItemLedgerEntry2."Item No.";
                        "Item Ledger Entry"."Variant Code" := RecLItemLedgerEntry2."Variant Code";
                        "Item Ledger Entry".Quantity := FctGetStock(RecLItemLedgerEntry);
                        "Item Ledger Entry"."Lot No." := RecLItemLedgerEntry2."Lot No.";
                        "Item Ledger Entry"."Serial No." := RecLItemLedgerEntry2."Serial No.";
                        "Item Ledger Entry".Insert();
                    end;

                end;
            until RecLItemLedgerEntry.Next() = 0;
        end
        else
            BooLResult := false;

        exit(BooLResult);
    end;

    local procedure FctGetStock(RecPItemLedgerEntry: Record "Item Ledger Entry"): Decimal
    var
        RecLItemLedgerEntry: Record "Item Ledger Entry";
        DecLStock: Decimal;
    begin
        RecLItemLedgerEntry.SetCurrentKey(Open, "Item Tracking", "Item No.", "Variant Code", "Lot No.", "Serial No.");
        RecLItemLedgerEntry.SetRange(Open, true);
        RecLItemLedgerEntry.SetFilter("Item Tracking", '<>%1', RecPItemLedgerEntry."Item Tracking"::None);
        RecLItemLedgerEntry.SetRange("Item No.", RecPItemLedgerEntry."Item No.");
        RecLItemLedgerEntry.SetRange("Variant Code", RecPItemLedgerEntry."Variant Code");
        RecLItemLedgerEntry.SetRange("Lot No.", RecPItemLedgerEntry."Lot No.");
        RecLItemLedgerEntry.SetRange("Serial No.", RecPItemLedgerEntry."Serial No.");
        RecLItemLedgerEntry.CalcSums("Remaining Quantity");
        DecLStock := RecLItemLedgerEntry."Remaining Quantity";
        exit(DecLStock);
    end;

    local procedure FctNewRecord(RecPItemLedgerEntry: Record "Item Ledger Entry"; var CodPLastItemNo: Code[20]; var CodPLastVariantCode: Code[10]; var CodPLastLotNo: Code[20]; var CodPLastSerialNo: Code[20]): Boolean
    begin
        if (CodPLastItemNo <> RecPItemLedgerEntry."Item No.") or
           (CodPLastVariantCode <> RecPItemLedgerEntry."Variant Code") or
           (CodPLastLotNo <> RecPItemLedgerEntry."Lot No.") or
           (CodPLastSerialNo <> RecPItemLedgerEntry."Serial No.") then begin
            CodPLastItemNo := RecPItemLedgerEntry."Item No.";
            CodPLastVariantCode := RecPItemLedgerEntry."Variant Code";
            CodPLastLotNo := RecPItemLedgerEntry."Lot No.";
            CodPLastSerialNo := RecPItemLedgerEntry."Serial No.";
            exit(true);
        end
        else
            exit(false);
    end;
}

