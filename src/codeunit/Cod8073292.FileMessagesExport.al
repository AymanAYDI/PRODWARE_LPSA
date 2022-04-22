codeunit 8073292 "PWD File Messages Export"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect.1.00
    // 
    // FE_ProdConnect.001:GR 22/03/2011  Connector integration
    //                                   - Create Object
    // 
    // //>>ProdConnect1.5
    // WMS-FEMOT.001:GR 04/07/2011   Connector integration
    //                              - Add WMS functions in OnRun
    //                              - Partial export management
    // 
    // />>ProdConnect1.5.1
    // FTP.001:GR 20/11/2011 :  Connector integration
    //                          - C\AL in OnRUN
    // 
    // //>>ProdConnect1.07
    // WMS-EBL1-003.001:GR 13/12/2011  Connector management
    //                                 - Add Remove FctMakeFileName function(use the Connector Buffer Management Export)
    //                                 - Change Code in OnRun for 'GETCUSTOMER'
    // 
    // +----------------------------------------------------------------------------------------------------------------+

    TableNo = "PWD Connector Messages";

    trigger OnRun()
    var
        RecLTempBlob: Record TempBlob temporary;
        RecLPartnerConnector: Record "PWD Partner Connector";
        RecLConnectorValues: Record "PWD Connector Values";
        BigTLToReturn: BigText;
        CduLBufferMgt: Codeunit "PWD Buffer Management";
        InLStream: InStream;
        CduLFileManagement: Codeunit "File Management";
        TxtLFile: Text[1024];
        BooLResult: Boolean;
        CduLConnecPimParseData: Codeunit "PWD Connector Pim Parse Data";
        RecLConnectorsActivation: Record "PWD WMS Setup";
        RecLRef: RecordRef;
        RecLCustomer: Record Customer;
    begin
        Clear(BigTLToReturn);
        Clear(IntGSequenceNo);
        RecLPartnerConnector.Get("Partner Code");

        case "Function" of
            'GETCUSTOMER':
                begin
                    //>>WMS-EBL1-003.001
                    RecLCustomer.Reset();
                    RecLCustomer.FindSet();
                    CduLConnecPimParseData.FctGetCustomerWithSep(RecLCustomer.GetView(), Rec, RecLTempBlob);
                    // CduLConnecPimParseData.FctGetCustomerWithSep('',Rec, RecLTempBlob);
                    //<<WMS-EBL1-003.001
                end;

            //>>WMS-EBL1-003.001 - SDAG -> Pour l'instant paramétrage générique
            /*
            'GETITEM': BEGIN
              RecLItem.RESET;
              RecLItem.FINDSET;

              CduLConnecPimParseData.FctGetItemWithSep(RecLItem.GETVIEW, Rec, RecLTempBlob);

              IF "Export Option" = "Export Option"::Partial THEN
              BEGIN
                CLEAR(RecLRef);
                RecLRef.OPEN("Table ID");
                CduLConBufMgtExport.FctSetExportDateFilter(Rec, RecLRef);
                IF RecLRef.GETVIEW <> '' THEN
                  RecLItem.SETVIEW(RecLRef.GETVIEW);
                  RecLRef.CLOSE;
              END;

              CASE RecLPartnerConnector."Data Format" OF
                RecLPartnerConnector."Data Format"::Xml :
                                      CduLConBufMgtExport.FctCreateXml(RecLItem.GETVIEW,Rec,RecLTempBlob,TRUE);
                RecLPartnerConnector."Data Format"::"with separator" :
                                      CduLConBufMgtExport.FctCreateSeparator(RecLItem.GETVIEW,Rec,RecLTempBlob);
                RecLPartnerConnector."Data Format"::"File Position":
                                      CduLConBufMgtExport.FctCreateFileWithPosition(RecLItem.GETVIEW,Rec,RecLTempBlob);
              END;
            END;
            */
            //<<WMS-EBL1-003.001
            else begin

                    //>>WMS-FEMOT.001
                    Clear(RecLRef);
                    RecLRef.Open("Table ID");
                    if "Export Option" = "Export Option"::Partial then
                        CduLConBufMgtExport.FctSetExportDateFilter(Rec, RecLRef);
                    //<<WMS-FEMOT.001

                    case RecLPartnerConnector."Data Format" of
                        RecLPartnerConnector."Data Format"::Xml:
                            CduLConBufMgtExport.FctCreateXml(RecLRef.GetView(), Rec, RecLTempBlob, true);
                        RecLPartnerConnector."Data Format"::"with separator":
                            CduLConBufMgtExport.FctCreateSeparator(RecLRef.GetView(), Rec, RecLTempBlob);
                        RecLPartnerConnector."Data Format"::"File Position":
                            CduLConBufMgtExport.FctCreateFileWithPosition(RecLRef.GetView(), Rec, RecLTempBlob);
                    end;

                    //>>WMS-FEMOT.001
                    RecLRef.Close();
                    //<<WMS-FEMOT.001

                end;

        end;

        RecLTempBlob.CalcFields(Blob);
        if RecLTempBlob.Blob.HasValue then begin
            RecLTempBlob.Blob.CreateInStream(InLStream);
            IntGSequenceNo := CduLBufferMgt.FctCreateBufferValues(InLStream, "Partner Code", '', Code,
                                                                  RecLPartnerConnector."Data Format"::Xml,
                                                                  RecLPartnerConnector.Separator, 1, 0, Code);
            RecLConnectorsActivation.Get();
            //>>WMS-EBL1-003.001
            TxtLFile := CduLConBufMgtExport.FctMakeFileName(
                                           Path,
                                           RecLConnectorsActivation."WMS Company Code",
                                           IntGSequenceNo, RecLPartnerConnector,
                                           "File Name value",
                                           "File Name with Society Code",
                                           "File Name with Date",
                                           "File Name with Time",
                                           "File extension"
                                           );
            //<<WMS-EBL1-003.001

            Clear(InLStream);
            RecLConnectorValues.Get(IntGSequenceNo);
            RecLConnectorValues."File Name" := CopyStr(TxtLFile, 1, 250);
            RecLConnectorValues.Modify();
            RecLConnectorValues.CalcFields(Blob);
            RecLConnectorValues.Blob.CreateInStream(InLStream);
            BooLResult := CduLFileManagement.FctbTransformBlobToFile(TxtLFile, InLStream, RecLConnectorValues."Partner Code",
                                                                     IntGSequenceNo, OptGFlowType::"Export Connector");
            CduLBufferMgt.FctArchiveBufferValues(RecLConnectorValues, BooLResult);

            //>>FTP.001
            Clear(CduLFTPExport);
            CduLFTPExport.Run(Rec);
            //<<FTP.001

        end;

    end;

    var
        CduLConBufMgtExport: Codeunit "Connector Buffer Mgt Export";
        OptGFlowType: Option " ","Import Connector","Export Connector";
        IntGSequenceNo: Integer;
        CduLFTPExport: Codeunit "PWD FTP Messages Import/Export";


    procedure FctGetTransactionNo(): Integer
    begin
        exit(IntGSequenceNo);
    end;
}

