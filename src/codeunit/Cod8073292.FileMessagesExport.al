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
        RecLCustomer: Record Customer;
        RecLConnectorValues: Record "PWD Connector Values";
        RecLPartnerConnector: Record "PWD Partner Connector";
        RecLConnectorsActivation: Record "PWD WMS Setup";
        CduLBufferMgt: Codeunit "PWD Buffer Management";
        CduLConnecPimParseData: Codeunit "PWD Connector Pim Parse Data";
        CduLFileManagement: Codeunit "PWD File Management";
        TempBlob: Codeunit "Temp Blob";
        BigTLToReturn: BigText;
        RecLRef: RecordRef;
        BooLResult: Boolean;
        InLStream: InStream;
        TxtLFile: Text[1024];
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
                    CduLConnecPimParseData.FctGetCustomerWithSep(RecLCustomer.GetView(), Rec, TempBlob);
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
                        CduLConBufMgtExport.FctCreateXml(RecLRef.GetView(), Rec, TempBlob, true);
                    RecLPartnerConnector."Data Format"::"with separator":
                        CduLConBufMgtExport.FctCreateSeparator(RecLRef.GetView(), Rec, TempBlob);
                    RecLPartnerConnector."Data Format"::"File Position":
                        CduLConBufMgtExport.FctCreateFileWithPosition(RecLRef.GetView(), Rec, TempBlob);
                end;

                //>>WMS-FEMOT.001
                RecLRef.Close();
                //<<WMS-FEMOT.001

            end;

        end;
        if TempBlob.HasValue() then begin
            TempBlob.CreateInStream(InLStream);
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

            RecLConnectorValues.Get(IntGSequenceNo);
            RecLConnectorValues."File Name" := CopyStr(TxtLFile, 1, 250);
            RecLConnectorValues.Modify();
            BooLResult := CduLFileManagement.FctbTransformBlobToFile(TxtLFile, TempBlob, RecLConnectorValues."Partner Code",
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
        CduLFTPExport: Codeunit "PWD FTP Messages Import/Export";
        IntGSequenceNo: Integer;
        OptGFlowType: Option " ","Import Connector","Export Connector";


    procedure FctGetTransactionNo(): Integer
    begin
        exit(IntGSequenceNo);
    end;
}

