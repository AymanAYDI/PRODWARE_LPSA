xmlport 8073325 "PWD Items Export OSYS"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.06
    // OSYS-Int001.001:GR 18/10/2011   Connector integration
    //                                   - Create Object
    // 
    //     //>>ProdConnect1.07.02.02
    // OSYS-Int001.002:GR 07/02/2012   Connector integration
    //                                 - Add new Tag  : F_TrackingType
    //                                 - Add function : FctGetItemTrackingType
    //                                 - C\AL in FctInitXML
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_INT01.001: NI 06/12/2011:  Designation Article Quartis
    //                                           - C/AL changed in function FctInitXML()
    // 
    // TDL08.001:GR 27/03/2012: Merge correction
    // +----------------------------------------------------------------------------------------------------------------+

    Caption = 'Items Export OSYS';
    DefaultNamespace = 'urn:microsoft-dynamics-nav/xmlports/Items';
    Encoding = UTF8;

    schema
    {
        textelement(OSYS)
        {
            MinOccurs = Zero;
            tableelement("G/L Entry"; "G/L Entry")
            {
                LinkTableForceInsert = false;
                MinOccurs = Zero;
                XmlName = 'T_Item';
                UseTemporary = true;
                textelement(F_ItemNo)
                {

                    trigger OnBeforePassVariable()
                    var
                        RecLOSYSSetup: Record "PWD OSYS Setup";
                    begin
                        RecLOSYSSetup.Get();
                        if "G/L Entry"."Document No." <> '' then
                            F_ItemNo := "G/L Entry"."G/L Account No." + RecLOSYSSetup."Separator Character" + "G/L Entry"."Document No."
                        else
                            F_ItemNo := "G/L Entry"."G/L Account No.";
                    end;
                }
                fieldelement(F_Description; "G/L Entry".Description)
                {
                }
                fieldelement(F_TrackingCode; "G/L Entry"."Global Dimension 1 Code")
                {
                }
                fieldelement(F_TrackingType; "G/L Entry"."Reversed by Entry No.")
                {
                }
                fieldelement(F_Category; "G/L Entry"."Global Dimension 2 Code")
                {
                }
                fieldelement(F_SubCategory; "G/L Entry"."Bal. Account No.")
                {
                }
                textelement(F_Packaging)
                {

                    trigger OnBeforePassVariable()
                    begin
                        F_Packaging := Format("G/L Entry".Amount, 0, 2);
                    end;
                }
                textelement(F_Pallet)
                {

                    trigger OnBeforePassVariable()
                    begin
                        F_Pallet := Format("G/L Entry".Quantity, 0, 2);
                    end;
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


    procedure FctDefinePartner(RecPMessgae: Record "PWD Connector Messages")
    begin
        RecGMessgae := RecPMessgae;
    end;


    procedure FctInitXML(): Boolean
    var
        RecLItem: Record Item;
        RecLItem2: Record Item;
        RecLItemVariant: Record "Item Variant";
        RecLItemVariant2: Record "Item Variant";
        RecLOSYSSetup: Record "PWD OSYS Setup";
        CduLConnectorBufferMgtExport: Codeunit "Connector Buffer Mgt Export";
        RecordRef: RecordRef;
        RecordRef2: RecordRef;
        BooLResult: Boolean;
        IntLSequenceNo: Integer;
        IntLTrackingType: Integer;
    begin
        BooLResult := true;
        RecLOSYSSetup.Get();
        RecLOSYSSetup.TestField("Packaging Unit");
        RecLOSYSSetup.TestField("Pallet  Unit");
        IntLSequenceNo := 0;
        "G/L Entry".DeleteAll();
        CduLConnectorBufferMgtExport.FctInitValidateField(RecGMessgae."Partner Code", 0);
        RecordRef.Open(RecGMessgae."Table ID");
        if RecGMessgae."Export Option" = RecGMessgae."Export Option"::Partial then begin
            CduLConnectorBufferMgtExport.FctSetExportDateFilter(RecGMessgae, RecordRef);
            RecLItem.SetView(RecordRef.GetView());
            RecordRef.Close();
        end;
        Clear(RecordRef);
        if not RecLItem.IsEmpty then begin
            RecLItem.FindSet();
            repeat
                RecordRef.GetTable(RecLItem);
                if not CduLConnectorBufferMgtExport.FctCheckFields(RecordRef) then begin
                    RecordRef.SetTable(RecLItem2);
                    IntLSequenceNo += 1;
                    "G/L Entry".Init();
                    "G/L Entry"."Entry No." := IntLSequenceNo;
                    "G/L Entry"."G/L Account No." := RecLItem2."No.";

                    //>>FE_LAPIERRETTE_INT01.001
                    //STD "G/L Entry".Description         := RecLItem2.Description;
                    "G/L Entry".Description := RecLItem."PWD Quartis Description";
                    //<<FE_LAPIERRETTE_INT01.001

                    //>>OSYS-Int001.002
                    IntLTrackingType := FctGetItemTrackingType(RecLItem2."No.");
                    "G/L Entry"."Reversed by Entry No." := IntLTrackingType;
                    //<<OSYS-Int001.002

                    "G/L Entry"."Global Dimension 1 Code" := RecLItem2."Item Tracking Code";
                    "G/L Entry"."Global Dimension 2 Code" := RecLItem."Item Category Code";
                    //TODO: Field 'Product Group Code' is removed
                    //"G/L Entry"."Bal. Account No." := RecLItem."Product Group Code";
                    "G/L Entry".Amount := FctGetItemQtyPer(RecLItem."No.", RecLOSYSSetup."Packaging Unit");
                    "G/L Entry".Quantity := FctGetItemQtyPer(RecLItem."No.", RecLOSYSSetup."Pallet  Unit");
                    "G/L Entry".Insert();
                    RecLItemVariant.Reset();
                    RecLItemVariant.SetRange("Item No.", RecLItem."No.");
                    ;
                    if not RecLItemVariant.IsEmpty then begin
                        RecLItemVariant.FindSet();
                        repeat
                            RecordRef2.GetTable(RecLItemVariant);
                            if not CduLConnectorBufferMgtExport.FctCheckFields(RecordRef2) then begin
                                RecordRef2.SetTable(RecLItemVariant2);
                                IntLSequenceNo += 1;
                                "G/L Entry".Init();
                                "G/L Entry"."Entry No." := IntLSequenceNo;
                                "G/L Entry"."G/L Account No." := RecLItem2."No.";

                                //>>OSYS-Int001.002
                                "G/L Entry"."Reversed by Entry No." := IntLTrackingType;
                                //<<OSYS-Int001.002

                                "G/L Entry"."Document No." := RecLItemVariant2.Code;
                                "G/L Entry".Description := RecLItemVariant2.Description;
                                "G/L Entry"."Global Dimension 1 Code" := RecLItem2."Item Tracking Code";
                                "G/L Entry"."Global Dimension 2 Code" := RecLItem2."Item Category Code";
                                //TODO: Field 'Product Group Code' is removed
                                //"G/L Entry"."Bal. Account No." := RecLItem2."Product Group Code";
                                "G/L Entry".Amount := FctGetItemQtyPer(RecLItem."No.", RecLOSYSSetup."Packaging Unit");
                                "G/L Entry".Quantity := FctGetItemQtyPer(RecLItem."No.", RecLOSYSSetup."Pallet  Unit");
                                "G/L Entry".Insert();
                            end;
                        until RecLItemVariant.Next() = 0;
                    end;
                end;
            until RecLItem.Next() = 0;
        end
        else
            BooLResult := false;

        exit(BooLResult);
    end;

    local procedure FctGetItemQtyPer(CodPItemNo: Code[20]; CodPUOM: Code[10]): Decimal
    var
        RecLItemUnitOfMeasure: Record "Item Unit of Measure";
        DecLQtyPer: Decimal;
    begin
        if RecLItemUnitOfMeasure.Get(CodPItemNo, CodPUOM) then
            DecLQtyPer := RecLItemUnitOfMeasure."Qty. per Unit of Measure";
        exit(DecLQtyPer);
    end;


    procedure "---OSYS-Int001.002---"()
    begin
    end;


    procedure FctGetItemTrackingType(CodPItemNo: Code[20]): Integer
    var
        RecLItem: Record Item;
        RecLItemTrackingCode: Record "Item Tracking Code";
        BooLLotTracking: Boolean;
        BooLSNTracking: Boolean;
        IntLTrackingType: Integer;
    begin
        if RecLItem.Get(CodPItemNo) then
            if RecLItemTrackingCode.Get(RecLItem."Item Tracking Code") then begin
                BooLSNTracking := (RecLItemTrackingCode."SN Manuf. Inbound Tracking") or
                                   (RecLItemTrackingCode."SN Manuf. Outbound Tracking");
                BooLLotTracking := (RecLItemTrackingCode."Lot Manuf. Inbound Tracking") or
                                   (RecLItemTrackingCode."Lot Manuf. Outbound Tracking");
            end;

        if BooLSNTracking and BooLLotTracking then
            IntLTrackingType := 3;

        if not BooLSNTracking and BooLLotTracking then
            IntLTrackingType := 1;

        if BooLSNTracking and not BooLLotTracking then
            IntLTrackingType := 2;

        exit(IntLTrackingType);
    end;
}

