xmlport 8073324 "PWD Import Conso OSYS"
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
    // +----------------------------------------------------------------------------------------------------------------+

    Encoding = UTF8;
    FormatEvaluate = Legacy;

    schema
    {
        textelement(OSYS)
        {
            tableelement("PWD Item Jounal Line Buffer"; "PWD Item Jounal Line Buffer")
            {
                XmlName = 'T_ItemJournal';
                fieldelement(F_PostingDate; "PWD Item Jounal Line Buffer"."Posting Date")
                {
                }
                textelement(F_ProdOrderNo)
                {

                    trigger OnAfterAssignVariable()
                    begin
                        IntGPos := StrPos(F_ProdOrderNo, RecGOSYSSetup."Separator Character");
                        if IntGPos <> 0 then begin
                            "PWD Item Jounal Line Buffer"."Prod. Order No." := CopyStr(F_ProdOrderNo, 1, IntGPos - 1);
                            if IntGPos > ArrayLen(F_ProdOrderNo) then
                                Evaluate("PWD Item Jounal Line Buffer"."Prod. Order Line No.", CopyStr(F_ProdOrderNo, IntGPos + 1));
                        end
                        else
                            "PWD Item Jounal Line Buffer"."Prod. Order No." := F_ProdOrderNo;
                    end;
                }
                textelement(F_ItemNo)
                {

                    trigger OnAfterAssignVariable()
                    begin
                        IntGPos := StrPos(F_ItemNo, RecGOSYSSetup."Separator Character");
                        if IntGPos <> 0 then begin
                            "PWD Item Jounal Line Buffer"."Item No." := CopyStr(F_ItemNo, 1, IntGPos - 1);
                            if IntGPos > ArrayLen(F_ItemNo) then
                                "PWD Item Jounal Line Buffer"."Variant Code" := CopyStr(F_ItemNo, IntGPos + 1);
                        end
                        else
                            "PWD Item Jounal Line Buffer"."Item No." := F_ItemNo;
                    end;
                }
                fieldelement(F_OperationNo; "PWD Item Jounal Line Buffer"."Operation No.")
                {
                }
                fieldelement(F_Quantity; "PWD Item Jounal Line Buffer".Quantity)
                {
                }
                fieldelement(F_LotNo; "PWD Item Jounal Line Buffer"."Lot No.")
                {
                }
                fieldelement(F_SerialNo; "PWD Item Jounal Line Buffer"."Serial No.")
                {
                }

                trigger OnAfterInitRecord()
                var
                    RefLRecordRef: RecordRef;
                    RecLConnectorsActivation: Record "PWD OSYS Setup";
                begin
                    RefLRecordRef.GetTable("PWD Item Jounal Line Buffer");
                    CduGBufferManagement.FctNewBufferLine2(RefLRecordRef, RecGConnectorValues, 0);
                    RefLRecordRef.SetTable("PWD Item Jounal Line Buffer");

                    RecLConnectorsActivation.Get;
                    "PWD Item Jounal Line Buffer"."Journal Batch Name" := RecLConnectorsActivation."Journal Batch Name Cons";
                    "PWD Item Jounal Line Buffer"."Journal Template Name" := RecLConnectorsActivation."Journal Templ Name Cons";
                    "PWD Item Jounal Line Buffer"."Entry Type" := "PWD Item Jounal Line Buffer"."Entry Type"::Consumption;
                    "PWD Item Jounal Line Buffer".Action := "PWD Item Jounal Line Buffer".Action::Insert;
                    "PWD Item Jounal Line Buffer"."Auto-Post Document" := RecGConnectorMessages."Auto-Post Document";
                end;
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

    trigger OnPreXmlPort()
    begin
        RecGOSYSSetup.Get();
    end;

    var
        RecGConnectorValues: Record "PWD Connector Values";
        RecGOSYSSetup: Record "PWD OSYS Setup";
        RecGConnectorMessages: Record "PWD Connector Messages";
        CduGBufferManagement: Codeunit "Buffer Management";
        IntGPos: Integer;


    procedure FctInitXmlPort(RecPConnectorValues: Record "PWD Connector Values")
    begin
        RecGConnectorValues := RecPConnectorValues;
        RecGConnectorMessages.Get(RecPConnectorValues."Partner Code", RecPConnectorValues."Message Code", RecPConnectorValues.Direction);
    end;
}

