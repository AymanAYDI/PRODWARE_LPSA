xmlport 50001 "PWD Import STOCK"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.22
    // P24578_009: RO : 12/12/2019 : cf Demande par mail
    //                   - New XMLPort
    // 
    // ------------------------------------------------------------------------------------------------------------------

    Encoding = UTF8;

    schema
    {
        textelement(LPSA)
        {
            tableelement("PWD Item Jounal Line Buffer"; "PWD Item Jounal Line Buffer")
            {
                XmlName = 'STOCK';
                fieldelement(DATE; "PWD Item Jounal Line Buffer"."Posting Date")
                {
                }
                textelement(ECRITURE)
                {

                    trigger OnAfterAssignVariable()
                    begin
                        case ECRITURE of
                            'Achat':
                                "PWD Item Jounal Line Buffer"."Entry Type" := "PWD Item Jounal Line Buffer"."Entry Type"::Purchase;
                            'Vente':
                                "PWD Item Jounal Line Buffer"."Entry Type" := "PWD Item Jounal Line Buffer"."Entry Type"::Sale;
                            'Positif (ajust.)':
                                "PWD Item Jounal Line Buffer"."Entry Type" := "PWD Item Jounal Line Buffer"."Entry Type"::"Positive Adjmt.";
                            'Négatif (ajust.)':
                                "PWD Item Jounal Line Buffer"."Entry Type" := "PWD Item Jounal Line Buffer"."Entry Type"::"Negative Adjmt.";
                            'Transfert':
                                "PWD Item Jounal Line Buffer"."Entry Type" := "PWD Item Jounal Line Buffer"."Entry Type"::Transfer;
                            'Consommation':
                                "PWD Item Jounal Line Buffer"."Entry Type" := "PWD Item Jounal Line Buffer"."Entry Type"::Consumption;
                            'Production':
                                "PWD Item Jounal Line Buffer"."Entry Type" := "PWD Item Jounal Line Buffer"."Entry Type"::Output;
                        end;
                    end;
                }
                fieldelement(ARTICLE; "PWD Item Jounal Line Buffer"."Item No.")
                {
                }
                fieldelement(DESIGNATION; "PWD Item Jounal Line Buffer".Description)
                {
                }
                fieldelement(CODE_MAG; "PWD Item Jounal Line Buffer"."Location Code")
                {
                }
                fieldelement(CODE_EMP; "PWD Item Jounal Line Buffer"."Bin Code")
                {
                }
                fieldelement(QUANTITE; "PWD Item Jounal Line Buffer".Quantity)
                {
                }
                fieldelement(CODE_MOTIF; "PWD Item Jounal Line Buffer"."Reason Code")
                {
                }
                fieldelement(CENTRE_COUT; "PWD Item Jounal Line Buffer"."Shortcut Dimension 1 Code")
                {
                }
                fieldelement(ATELIER; "PWD Item Jounal Line Buffer"."New Location Code")
                {
                }

                trigger OnAfterInitRecord()
                var
                    RefLRecordRef: RecordRef;
                    RecLConnectorsActivation: Record "PWD OSYS Setup";
                    RecLProdOrderRoutingLine: Record "Prod. Order Routing Line";
                    RecLProdOrderLine: Record "Prod. Order Line";
                    RecLMachine: Record "Machine Center";
                    "-LAP2.06.01-": Integer;
                    CduLOSYSParseData: Codeunit "Connector OSYS Parse Data";
                    CodLItemNo: Code[20];
                begin
                    RefLRecordRef.GetTable("PWD Item Jounal Line Buffer");
                    CduGBufferManagement.FctNewBufferLine2(RefLRecordRef, RecGConnectorValues, 0);
                    RefLRecordRef.SetTable("PWD Item Jounal Line Buffer");

                    RecLConnectorsActivation.Get;

                    "PWD Item Jounal Line Buffer"."Auto-Post Document" := RecGConnectorMessages."Auto-Post Document";
                    "PWD Item Jounal Line Buffer"."Entry Type" := "PWD Item Jounal Line Buffer"."Entry Type"::Output;
                    "PWD Item Jounal Line Buffer".Action := "PWD Item Jounal Line Buffer".Action::Insert;
                    "PWD Item Jounal Line Buffer".Type := "PWD Item Jounal Line Buffer".Type::"Machine Center";
                end;

                trigger OnBeforeInsertRecord()
                var
                    RecLProdOrderRoutingLine: Record "Prod. Order Routing Line";
                    RecLProdOrderLine: Record "Prod. Order Line";
                    RecLMachine: Record "Machine Center";
                    "-LAP2.06.01-": Integer;
                    CduLOSYSParseData: Codeunit "Connector OSYS Parse Data";
                    CodLItemNo: Code[20];
                    RecLConnectorsActivation: Record "PWD OSYS Setup";
                begin


                    RecLConnectorsActivation.Get;

                    if ECRITURE = 'Transfert' then begin
                        "PWD Item Jounal Line Buffer"."Journal Batch Name" := RecLConnectorsActivation."Journal Batch Name Stock TRF";
                        "PWD Item Jounal Line Buffer"."Journal Template Name" := RecLConnectorsActivation."Journal Templ Name Stock TRF";
                    end
                    else begin
                        "PWD Item Jounal Line Buffer"."Journal Batch Name" := RecLConnectorsActivation."Journal Batch Name Stock MVT";
                        "PWD Item Jounal Line Buffer"."Journal Template Name" := RecLConnectorsActivation."Journal Templ Name Stock MVT";

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
        RecGOSYSSetup.TestField("Journal Templ Name Stock MVT");
        RecGOSYSSetup.TestField("Journal Batch Name Stock MVT");
        RecGOSYSSetup.TestField("Journal Templ Name Stock TRF");
        RecGOSYSSetup.TestField("Journal Batch Name Stock TRF");
    end;

    var
        RecGConnectorValues: Record "PWD Connector Values";
        CduGBufferManagement: Codeunit "Buffer Management";
        CduGProductionJrnlMgt: Codeunit "Production Journal Mgt";
        RecGOSYSSetup: Record "PWD OSYS Setup";
        RecGProdOrder: Record "Production Order";
        RecGConnectorMessages: Record "PWD Connector Messages";
        RecGOSYSItemJnlLineBuffer: Record "OSYS Item Jounal Line Buffer";
        IntGPos: Integer;
        IntGLineNo: Integer;


    procedure FctInitXmlPort(RecPConnectorValues: Record "PWD Connector Values")
    begin
        RecGConnectorValues := RecPConnectorValues;
        RecGConnectorMessages.Get(RecPConnectorValues."Partner Code", RecPConnectorValues."Message Code", RecPConnectorValues.Direction);
    end;
}

