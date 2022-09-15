xmlport 8073322 "PWD Import Prod OSYS"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.06
    // OSYS-Int001.001:GR 18/10/2011 Connector integration
    //                               - Create Object
    // 
    // //>>ProdConnect2.00
    // OSYS-Int001.002:GR 19/06/2012   Connector integration
    //                                 - Fix in : T_ItemJournal - Import::OnAfterInitRecord()
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_PROD02.001: NI 06/12/2011:  Commentaire sur feuille production
    //                                           - Add New field F_CommentCode
    // 
    // //>>LAP2.01
    // FE_LAPIERRETTE_PROD11.001: GR 14/02/2012:  Conform Quality Control
    //                                           - Add New field F_ControlQuality
    // 
    // 
    // //>>LAP2.06
    // FE_LAPRIERRETTE_GP0004.001 :GR  23/05/13 C\AIL in T_ItemJournal - Import::OnBeforeInsertRecord()
    // 
    // //>>LAP2.06.01
    // FE_LAPRIERRETTE_GP0004.002 :GR  15/07/13  : - Add C\AL in  T_ItemJournal - Import::OnAfterInitRecord()
    // 
    // 
    // ------------------------------------------------------------------------------------------------------------------
    Encoding = UTF8;

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
                            if IntGPos > StrLen(F_ProdOrderNo) then
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
                            if IntGPos > StrLen(F_ItemNo) then
                                "PWD Item Jounal Line Buffer"."Variant Code" := CopyStr(F_ItemNo, IntGPos + 1);
                        end
                        else
                            "PWD Item Jounal Line Buffer"."Item No." := F_ItemNo;
                    end;
                }
                fieldelement(F_MachineNo; "PWD Item Jounal Line Buffer"."No.")
                {
                }
                fieldelement(F_OperationNo; "PWD Item Jounal Line Buffer"."Operation No.")
                {
                }
                fieldelement(F_SetupTime; "PWD Item Jounal Line Buffer"."Setup Time")
                {
                }
                fieldelement(F_RunTime; "PWD Item Jounal Line Buffer"."Run Time")
                {
                }
                textelement(F_Status)
                {

                    trigger OnAfterAssignVariable()
                    begin
                        if F_Status = '3' then
                            "PWD Item Jounal Line Buffer".Finished := true;
                    end;
                }
                fieldelement(F_ProdQty; "PWD Item Jounal Line Buffer"."Output Quantity")
                {
                }
                fieldelement(F_RejectedQty; "PWD Item Jounal Line Buffer"."Scrap Quantity")
                {
                }
                fieldelement(F_ScrapCode; "PWD Item Jounal Line Buffer"."Scrap Code")
                {
                }
                fieldelement(F_LotNo; "PWD Item Jounal Line Buffer"."Lot No.")
                {
                    // trigger OnAfterAssignField()
                    // begin
                    //     if "PWD Item Jounal Line Buffer"."Lot No." = '' then
                    //         "PWD Item Jounal Line Buffer"."Lot No." := F_ProdOrderNo;
                    // end;
                }
                fieldelement(F_SerialNo; "PWD Item Jounal Line Buffer"."Serial No.")
                {
                }
                fieldelement(F_CommentCode; "PWD Item Jounal Line Buffer"."Comment Code")
                {
                }
                fieldelement(F_ControlQuality; "PWD Item Jounal Line Buffer"."Conform quality control")
                {
                }

                trigger OnAfterInitRecord()
                var
                    RecLConnectorsActivation: Record "PWD OSYS Setup";
                    CduLOSYSParseData: Codeunit "PWD Connector OSYS Parse Data";
                    RefLRecordRef: RecordRef;
                    CodLItemNo: Code[20];
                begin
                    RefLRecordRef.GetTable("PWD Item Jounal Line Buffer");
                    CduGBufferManagement.FctNewBufferLine2(RefLRecordRef, RecGConnectorValues, 0);
                    RefLRecordRef.SetTable("PWD Item Jounal Line Buffer");

                    RecLConnectorsActivation.Get();
                    Clear(CodLItemNo);


                    //>>FE_LAPRIERRETTE_GP0004.002
                    //OLD :   "PWD Item Jounal Line Buffer"."Journal Batch Name"    := RecLConnectorsActivation."Journal Batch Name Prod";
                    //OLD :   "PWD Item Jounal Line Buffer"."Journal Template Name" := RecLConnectorsActivation."Journal Templ Name Prod";

                    if ("PWD Item Jounal Line Buffer"."Item No." <> '') then
                        CodLItemNo := CopyStr("PWD Item Jounal Line Buffer"."Item No.", 1, 20);

                    if CduLOSYSParseData.FctIsSteeItem(CodLItemNo) then begin
                        "PWD Item Jounal Line Buffer"."Journal Batch Name" := RecLConnectorsActivation."Journal Batch Name Prod";
                        "PWD Item Jounal Line Buffer"."Journal Template Name" := RecLConnectorsActivation."Journal Templ Name Prod";
                    end
                    else begin
                        "PWD Item Jounal Line Buffer"."Journal Batch Name" := RecLConnectorsActivation."Journal Batch Name Prod 1";
                        "PWD Item Jounal Line Buffer"."Journal Template Name" := RecLConnectorsActivation."Journal Templ Name Prod 1";

                    end;
                    //<<FE_LAPRIERRETTE_GP0004.002

                    "PWD Item Jounal Line Buffer"."Auto-Post Document" := RecGConnectorMessages."Auto-Post Document";
                    "PWD Item Jounal Line Buffer"."Entry Type" := "PWD Item Jounal Line Buffer"."Entry Type"::Output;
                    "PWD Item Jounal Line Buffer".Action := "PWD Item Jounal Line Buffer".Action::Insert;
                    "PWD Item Jounal Line Buffer".Type := "PWD Item Jounal Line Buffer".Type::"Machine Center";
                    RecGProdOrder.Reset();

                    //RecGOSYSItemJnlLineBuffer.INIT;
                    //RecGOSYSItemJnlLineBuffer."Entry No." := "PWD Item Jounal Line Buffer"."Entry No.";
                    //RecGOSYSItemJnlLineBuffer.INSERT;
                end;

                trigger OnBeforeInsertRecord()
                var
                    RecLMachine: Record "Machine Center";
                    RecLProdOrderLine: Record "Prod. Order Line";
                    RecLProdOrderRoutingLine: Record "Prod. Order Routing Line";
                    RecLConnectorsActivation: Record "PWD OSYS Setup";
                    CduLOSYSParseData: Codeunit "PWD Connector OSYS Parse Data";
                    CodLItemNo: Code[20];
                //"-LAP2.06.01-": Integer;
                begin
                    //>>OSYS-Int001.002
                    if "PWD Item Jounal Line Buffer"."No." = '' then
                        if RecLProdOrderLine.Get(RecLProdOrderLine.Status::Released, "PWD Item Jounal Line Buffer"."Prod. Order No.",
                                                  "PWD Item Jounal Line Buffer"."Prod. Order Line No.") then begin
                            RecLProdOrderRoutingLine.SetRange(Status, RecLProdOrderLine.Status);
                            RecLProdOrderRoutingLine.SetRange("Prod. Order No.", RecLProdOrderLine."Prod. Order No.");
                            RecLProdOrderRoutingLine.SetRange("Routing Reference No.", RecLProdOrderLine."Routing Reference No.");
                            RecLProdOrderRoutingLine.SetRange("Routing No.", RecLProdOrderLine."Routing No.");
                            RecLProdOrderRoutingLine.SetRange("Operation No.", "PWD Item Jounal Line Buffer"."Operation No.");
                            if not RecLProdOrderRoutingLine.IsEmpty then begin
                                RecLProdOrderRoutingLine.FindFirst();
                                if RecLMachine.Get(RecLProdOrderRoutingLine."No.") then
                                    "PWD Item Jounal Line Buffer"."No." := RecLMachine."No.";
                            end;
                        end;
                    //<<OSYS-Int001.002

                    //>>FE_LAPRIERRETTE_GP0004.001
                    "PWD Item Jounal Line Buffer".Quantity := Format("PWD Item Jounal Line Buffer"."Output Quantity");
                    //<<FE_LAPRIERRETTE_GP0004.001

                    //>>FE_LAPRIERRETTE_GP0004.002
                    RecLConnectorsActivation.Get();
                    if ("PWD Item Jounal Line Buffer"."Item No." <> '') then
                        CodLItemNo := CopyStr("PWD Item Jounal Line Buffer"."Item No.", 1, 20);

                    if CduLOSYSParseData.FctIsSteeItem(CodLItemNo) then begin
                        "PWD Item Jounal Line Buffer"."Journal Batch Name" := RecLConnectorsActivation."Journal Batch Name Prod";
                        "PWD Item Jounal Line Buffer"."Journal Template Name" := RecLConnectorsActivation."Journal Templ Name Prod";
                    end
                    else begin
                        "PWD Item Jounal Line Buffer"."Journal Batch Name" := RecLConnectorsActivation."Journal Batch Name Prod 1";
                        "PWD Item Jounal Line Buffer"."Journal Template Name" := RecLConnectorsActivation."Journal Templ Name Prod 1";

                    end;
                    //<<FE_LAPRIERRETTE_GP0004.002
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
        RecGProdOrder: Record "Production Order";
        RecGConnectorMessages: Record "PWD Connector Messages";
        RecGConnectorValues: Record "PWD Connector Values";
        RecGOSYSSetup: Record "PWD OSYS Setup";
        CduGBufferManagement: Codeunit "PWD Buffer Management";
        IntGPos: Integer;


    procedure FctInitXmlPort(RecPConnectorValues: Record "PWD Connector Values")
    begin
        RecGConnectorValues := RecPConnectorValues;
        RecGConnectorMessages.Get(RecPConnectorValues."Partner Code", RecPConnectorValues."Message Code", RecPConnectorValues.Direction);
    end;
}

