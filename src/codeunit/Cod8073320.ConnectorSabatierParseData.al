codeunit 8073320 "Connector Sabatier Parse Data"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.5
    // FE_Sabatier.001:GR 08/09/2001 :  Connector integration
    //                                   - Create Object
    // 
    // 
    // +----------------------------------------------------------------------------------------------------------------+

    TableNo = "PWD Connector Values";

    trigger OnRun()
    var
        RecLConnectorMessages: Record "PWD Connector Messages";
    begin
        //********************************************************************************************************************************//
        //                                                                                                                                //
        //                                         Fonction Spécifique WMS                                                                //
        //                                                                                                                                //
        //********************************************************************************************************************************//

        CASE Direction OF
            Direction::Export:
                BEGIN
                    RecLConnectorMessages.GET("Partner Code", "Message Code", Direction);
                    FctProcessExport(RecLConnectorMessages);
                END;

            Direction::Import:

                FctProcessImport(Rec);
        END;
    end;

    var
        CduGConnectBufMgtExport: Codeunit "Connector Buffer Mgt Export";
        CduGBufferManagement: Codeunit "PWD Buffer Management";
        OptGFlowType: Option " ","Import Connector","Export Connector";
        IntGSequenceNo: Integer;


    procedure FctProcessImport(var RecPConnectorValues: Record "PWD Connector Values")
    begin
        CASE RecPConnectorValues."Function" OF
            'IMPORTOT':
                FctImportOTXML(RecPConnectorValues);
        END;

        CduGBufferManagement.FctArchiveBufferValues(RecPConnectorValues, TRUE);
    end;


    procedure FctProcessExport(RecPConnectorMessages: Record "PWD Connector Messages")
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
        RecLRef: RecordRef;
    begin
        CLEAR(BigTLToReturn);
        CLEAR(IntGSequenceNo);
        RecLPartnerConnector.GET(RecPConnectorMessages."Partner Code");

        RecPConnectorMessages.TESTFIELD(Path);

        CASE RecPConnectorMessages."Function" OF
            'CONTACT':
                FctGetContactXML(RecPConnectorMessages, RecLTempBlob);
            ELSE
                CASE RecLPartnerConnector."Data Format" OF
                    RecLPartnerConnector."Data Format"::Xml:
                        CduGConnectBufMgtExport.FctCreateXml(RecLRef.GETVIEW(), RecPConnectorMessages, RecLTempBlob, TRUE);
                    RecLPartnerConnector."Data Format"::"with separator":
                        CduGConnectBufMgtExport.FctCreateSeparator(RecLRef.GETVIEW(), RecPConnectorMessages, RecLTempBlob);
                END;
        END;

        RecLTempBlob.CALCFIELDS(Blob);
        IF RecLTempBlob.Blob.HASVALUE THEN BEGIN
            RecLTempBlob.Blob.CREATEINSTREAM(InLStream);
            IntGSequenceNo := CduLBufferMgt.FctCreateBufferValues(InLStream, RecPConnectorMessages."Partner Code", '',
                                                                  RecPConnectorMessages.Code,
                                                                  RecLPartnerConnector."Data Format"::Xml,
                                                                  RecLPartnerConnector.Separator, 1, 0,
                                                                  RecPConnectorMessages.Code);

            TxtLFile := CduGConnectBufMgtExport.FctMakeFileName(
                                                RecPConnectorMessages.Path, RecPConnectorMessages."Partner Code",
                                                IntGSequenceNo, RecLPartnerConnector,
                                                //>>WMS-FEMOT.002
                                                RecPConnectorMessages."File Name value",
                                                RecPConnectorMessages."File Name with Society Code",
                                                RecPConnectorMessages."File Name with Date",
                                                RecPConnectorMessages."File Name with Time",
                                                RecPConnectorMessages."File extension");
            //<<WMS-FEMOT.002


            CLEAR(InLStream);
            RecLConnectorValues.GET(IntGSequenceNo);
            RecLConnectorValues."File Name" := COPYSTR(TxtLFile, 1, 250);
            RecLConnectorValues.MODIFY();
            RecLConnectorValues.CALCFIELDS(Blob);
            RecLConnectorValues.Blob.CREATEINSTREAM(InLStream);
            BooLResult := CduLFileManagement.FctbTransformBlobToFile(TxtLFile, InLStream, RecLConnectorValues."Partner Code",
                                                                     IntGSequenceNo, OptGFlowType::"Export Connector");
            CduLBufferMgt.FctArchiveBufferValues(RecLConnectorValues, BooLResult);
        END;
    end;


    procedure FctGetContactXML(RecPConnectorMes: Record "PWD Connector Messages"; var RecPTempBlob: Record TempBlob temporary)
    var
        XmlLExportContactSabatier: XMLport "PWD Export Contact Sabatier";
        OutLStream: OutStream;
    begin
        CLEAR(XmlLExportContactSabatier);
        RecPTempBlob.Blob.CREATEOUTSTREAM(OutLStream);
        XmlLExportContactSabatier.SETDESTINATION(OutLStream);
        XmlLExportContactSabatier.EXPORT();
    end;


    procedure FctImportOTXML(var RecPConnectorValues: Record "PWD Connector Values")
    var
        XmlLImportOTSabatier: XMLport "PWD Import OT Sabatier";
        InsLSrtream: InStream;
    begin
        RecPConnectorValues.CALCFIELDS(Blob);
        RecPConnectorValues.Blob.CREATEINSTREAM(InsLSrtream);
        XmlLImportOTSabatier.FctInitXmlPort(RecPConnectorValues);
        XmlLImportOTSabatier.SETSOURCE(InsLSrtream);
        XmlLImportOTSabatier.IMPORT();
    end;
}

