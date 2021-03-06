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
        IntGSequenceNo: Integer;
        OptGFlowType: Option " ","Import Connector","Export Connector";


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
        RecLConnectorValues: Record "PWD Connector Values";
        RecLPartnerConnector: Record "PWD Partner Connector";
        CduLBufferMgt: Codeunit "PWD Buffer Management";
        CduLFileManagement: Codeunit "PWD File Management";
        TempBlob: Codeunit "Temp Blob";
        BigTLToReturn: BigText;
        RecLRef: RecordRef;
        BooLResult: Boolean;
        InLStream: InStream;
        TxtLFile: Text[1024];
    begin
        CLEAR(BigTLToReturn);
        CLEAR(IntGSequenceNo);
        RecLPartnerConnector.GET(RecPConnectorMessages."Partner Code");

        RecPConnectorMessages.TESTFIELD(Path);

        CASE RecPConnectorMessages."Function" OF
            'CONTACT':
                FctGetContactXML(RecPConnectorMessages, TempBlob);
            ELSE
                CASE RecLPartnerConnector."Data Format" OF
                    RecLPartnerConnector."Data Format"::Xml:
                        CduGConnectBufMgtExport.FctCreateXml(RecLRef.GETVIEW(), RecPConnectorMessages, TempBlob, TRUE);
                    RecLPartnerConnector."Data Format"::"with separator":
                        CduGConnectBufMgtExport.FctCreateSeparator(RecLRef.GETVIEW(), RecPConnectorMessages, TempBlob);
                END;
        END;
        IF TempBlob.HASVALUE() THEN BEGIN
            TempBlob.CREATEINSTREAM(InLStream);
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


            RecLConnectorValues.GET(IntGSequenceNo);
            RecLConnectorValues."File Name" := COPYSTR(TxtLFile, 1, 250);
            RecLConnectorValues.MODIFY();
            BooLResult := CduLFileManagement.FctbTransformBlobToFile(TxtLFile, TempBlob, RecLConnectorValues."Partner Code",
                                                                     IntGSequenceNo, OptGFlowType::"Export Connector");
            CduLBufferMgt.FctArchiveBufferValues(RecLConnectorValues, BooLResult);
        END;
    end;


    procedure FctGetContactXML(RecPConnectorMes: Record "PWD Connector Messages"; var TempBlob: Codeunit "Temp Blob")
    var
        XmlLExportContactSabatier: XMLport "PWD Export Contact Sabatier";
        OutLStream: OutStream;
    begin
        CLEAR(XmlLExportContactSabatier);
        TempBlob.CREATEOUTSTREAM(OutLStream);
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

