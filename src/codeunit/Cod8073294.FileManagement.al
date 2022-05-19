codeunit 8073294 "PWD File Management"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.00
    // FE_ProdConnect.001:GR 22/03/2011  Connector integration
    //                                   - Create Object
    // 
    // //>>ProdConnect1.5
    // WMS-FEMOT.001:GR 06/07/2011  Connector management
    //                               Add new functions :
    //                                 FctFormatDecimal
    //                                 FctFormatDate
    //                                 FctFillUpString
    //                                 FtcRemoveVirg
    //                                 FctMergeOutStream
    // 
    // />>ProdConnect1.5.1
    // FTP.001:GR 20/11/2011 :  Connector integration
    //                          - Add Function : FctDeleteFiles
    // 
    // //>>ProdConnect1.07
    // WMS-EBL1-003.001:GR 13/12/2011  Connector management
    //                                - Add Function : FctEvaluateInteger
    //                                - Modification of CduGAsciiToAnsi using
    // 
    // //>>ProdConnect1.07.02
    // WMS-EBL1-004.001:GR 05/01/2012  Connector management
    //                                - Update Prodconnect dll to 1.1.0.0
    //                                - add function : FctFormatDecimalWMS
    // 
    // 
    // +----------------------------------------------------------------------------------------------------------------+


    trigger OnRun()
    begin
    end;

    var
        CduGConnectorErrorlog: Codeunit "PWD Connector Error log";
        CduGAsciiToAnsi: Codeunit "PWD Convert Ascii To Ansi";

    procedure FctCopyFile(TxtPFileName: Text[100]; TxtPSourcePath: Text[250]; TxtPDestinationPath: Text[250]; CodPPartner: Code[20]; IntPBufferMessageNo: Integer; OptPFlowType: Option " ","Import Connector","Export Connector"): Boolean
    var
        BooLResult: Boolean;
        AutLFileManagement: dotnet "PWD FileManagement";
        TxtLError: Text[250];
    begin
        //**********************************************************************************************************//
        //                           Use automation copy file with log management                                   //
        //**********************************************************************************************************//
        if IsNull(AutLFileManagement) then
            AutLFileManagement := AutLFileManagement.FileManagement();
        BooLResult := AutLFileManagement.bCopyFile(TxtPFileName, TxtPSourcePath, TxtPDestinationPath, TxtLError);
        IF NOT BooLResult THEN
            CduGConnectorErrorlog.InsertLogEntry(2, OptPFlowType, CodPPartner, TxtLError, IntPBufferMessageNo);
        EXIT(BooLResult);
    end;

    procedure FctDeleteFile(TxtPFileName: Text[100]; TxtPSourcePath: Text[250]; CodPPartner: Code[20]; IntPBufferMessageNo: Integer; OptPFlowType: Option " ","Import Connector","Export Connector"): Boolean
    var
        BooLResult: Boolean;
        AutLFileManagement: dotnet "PWD FileManagement";
        TxtLError: Text[250];
    begin
        //**********************************************************************************************************//
        //                           Use automation Delete file with log management                                 //
        //**********************************************************************************************************//
        if IsNull(AutLFileManagement) then
            AutLFileManagement := AutLFileManagement.FileManagement();
        BooLResult := AutLFileManagement.bDeleteFile(TxtPFileName, TxtPSourcePath, TxtLError);
        IF NOT BooLResult THEN
            CduGConnectorErrorlog.InsertLogEntry(2, OptPFlowType, CodPPartner, TxtLError, IntPBufferMessageNo);
        EXIT(BooLResult);
    end;

    procedure FctMoveFile(TxtPFileName: Text[100]; TxtPSourcePath: Text[250]; TxtPDestinationPath: Text[250]; CodPPartner: Code[20]; IntPBufferMessageNo: Integer; OptPFlowType: Option " ","Import Connector","Export Connector"): Boolean
    var
        BooLResult: Boolean;
        AutLFileManagement: dotnet "PWD FileManagement";
        TxtLError: Text[250];
    begin
        //**********************************************************************************************************//
        //                           Use automation move file with log management                                   //
        //**********************************************************************************************************//
        if IsNull(AutLFileManagement) then
            AutLFileManagement := AutLFileManagement.FileManagement();
        BooLResult := AutLFileManagement.bMoveFile(TxtPFileName, TxtPSourcePath, TxtPDestinationPath, TxtLError);
        IF NOT BooLResult THEN
            CduGConnectorErrorlog.InsertLogEntry(2, OptPFlowType, CodPPartner, TxtLError, IntPBufferMessageNo);
        EXIT(BooLResult);
    end;

    procedure FctScanDirectoryFiles(TxtPSourcePath: Text[250]; var TxtPFileFound: Text[1024]; CodPPartner: Code[20]; IntPBufferMessageNo: Integer; OptPFlowType: Option " ","Import Connector","Export Connector"): Boolean
    var
        BooLResult: Boolean;
        AutLFileManagement: dotnet "PWD FileManagement";
        TxtLError: Text[250];
    begin
        //**********************************************************************************************************//
        //           Scan specific Directory and return first file name found in TxtPFileFound                      //
        //**********************************************************************************************************//

        if IsNull(AutLFileManagement) then
            AutLFileManagement := AutLFileManagement.FileManagement();
        BooLResult := AutLFileManagement.bScanDirectoryFiles(TxtPSourcePath, TxtPFileFound, TxtLError);
        //>>WMS-FEMOT.001
        //OLD :  IF NOT BooLResult THEN
        IF (NOT BooLResult) AND (TxtLError <> '') THEN
            //<<WMS-FEMOT.001

            CduGConnectorErrorlog.InsertLogEntry(2, OptPFlowType, CodPPartner, TxtLError, IntPBufferMessageNo);
        EXIT(BooLResult);
    end;

    procedure FctTranformFileToBlob(TxtPFile: Text[1024]; var RecPTempBlob: Codeunit "Temp Blob"; CodPPartner: Code[20]; IntPBufferMessageNo: Integer; OptPFlowType: Option " ","Import Connector","Export Connector"): Boolean
    var
        BooLResult: Boolean;
        AutLFileManagement: dotnet "PWD FileManagement";
        InsLStream: InStream;
        OutLStream: OutStream;
        TxtLError: Text[250];
    begin
        //**********************************************************************************************************//
        //                                  Read file in Stream                                                     //
        //**********************************************************************************************************//

        if IsNull(AutLFileManagement) then
            AutLFileManagement := AutLFileManagement.FileManagement();
        BooLResult := AutLFileManagement.TranformFileToBlob(TxtPFile, InsLStream, TxtLError);
        IF NOT BooLResult THEN
            CduGConnectorErrorlog.InsertLogEntry(2, OptPFlowType, CodPPartner, TxtLError, IntPBufferMessageNo);


        //>>WMS-FEMOT.001
        RecPTempBlob.CREATEOUTSTREAM(OutLStream);
        COPYSTREAM(OutLStream, InsLStream);
        //<<WMS-FEMOT.001
        EXIT(BooLResult);
    end;

    procedure FctbTransformBlobToFile(TxtPFile: Text[1024]; var InPStream: InStream; CodPPartner: Code[20]; IntPBufferMessageNo: Integer; OptPFlowType: Option " ","Import Connector","Export Connector"): Boolean
    var
        BooLResult: Boolean;
        AutLFileManagement: dotnet "PWD FileManagement";
        TxtLError: Text[250];
    begin
        //************************************************()**********************************************************//
        //                                  Write file in Stream                                                    //
        //**********************************************************************************************************//
        if IsNull(AutLFileManagement) then
            AutLFileManagement := AutLFileManagement.FileManagement();

        BooLResult := AutLFileManagement.bTransformBlobToFile(TxtPFile, InPStream, TxtLError);
        IF NOT BooLResult THEN
            CduGConnectorErrorlog.InsertLogEntry(2, OptPFlowType, CodPPartner, TxtLError, IntPBufferMessageNo);
        EXIT(BooLResult);

    end;

    procedure FctShowBlobAsWindow(InPStream: InStream)
    var
        AutLFileManagement: dotnet "PWD FileManagement";
        CstL000: Label 'Blob Content';
    begin
        //**********************************************************************************************************//
        //                                  Show blob content                                                       //
        //**********************************************************************************************************//
        if IsNull(AutLFileManagement) then
            AutLFileManagement := AutLFileManagement.FileManagement();
        AutLFileManagement.ShowBlobAsWindow(InPStream, CstL000)
    end;

    procedure FctMergeStream(InPStream1: InStream; InPStream2: InStream; var RecPTempBlob: Codeunit "Temp Blob"; CodPPartner: Code[20])
    var
        AutLFileManagement: dotnet "PWD FileManagement";
        InLStreamReturn: InStream;
        OutLStream: OutStream;
        TxtLError: Text[250];
    begin
        //**********************************************************************************************************//
        //                                  InStream Merge                                                          //
        //**********************************************************************************************************//

        if IsNull(AutLFileManagement) then
            AutLFileManagement := AutLFileManagement.FileManagement();
        InLStreamReturn := AutLFileManagement.MergeIstream(InPStream1, InPStream2, TxtLError);

        IF TxtLError <> '' THEN
            ERROR(TxtLError)
        ELSE BEGIN
            InLStreamReturn := AutLFileManagement.isRemoveStringFromIstream('Parent', CodPPartner, InLStreamReturn, TxtLError);
            IF TxtLError <> '' THEN
                ERROR(TxtLError)
        END;

        RecPTempBlob.CREATEOUTSTREAM(OutLStream);
        COPYSTREAM(OutLStream, InLStreamReturn);
    end;

    procedure FtcReplacePointByVirg(TxtPTextToModify: Text[250]): Text[250]
    var
        TxtLModifyInProcess: Text[250];
    begin
        //**********************************************************************************************************//
        //                                  Change "." by ","                                                       //
        //**********************************************************************************************************//
        TxtLModifyInProcess := CONVERTSTR(TxtPTextToModify, ',', '.');
        EXIT(TxtLModifyInProcess);

    end;

    procedure FctEvaluateDecimal(TxtPValueToTransform: Text[50]; var DecLValueToReturn: Decimal): Boolean
    var
        BooLTreatmentOK: Boolean;
    begin
        BooLTreatmentOK := TRUE;
        DecLValueToReturn := 0;

        IF NOT EVALUATE(DecLValueToReturn, TxtPValueToTransform) THEN BEGIN
            BooLTreatmentOK := FALSE;
            IF STRPOS(TxtPValueToTransform, ',') <> 0 THEN BEGIN
                IF EVALUATE(DecLValueToReturn, CONVERTSTR(TxtPValueToTransform, ',', '.')) THEN
                    BooLTreatmentOK := TRUE;
            END
            ELSE
                IF STRPOS(TxtPValueToTransform, '.') <> 0 THEN
                    IF EVALUATE(DecLValueToReturn, CONVERTSTR(TxtPValueToTransform, '.', ',')) THEN
                        BooLTreatmentOK := TRUE;
        END;

        EXIT(BooLTreatmentOK);
    end;

    procedure FctEvaluateInteger(TxtPValueToTransform: Text[50]; var IntLValueToReturn: Integer): Boolean
    var
        BooLTreatmentOK: Boolean;
    begin
        BooLTreatmentOK := TRUE;
        IntLValueToReturn := 0;

        IF NOT EVALUATE(IntLValueToReturn, TxtPValueToTransform) THEN BEGIN
            BooLTreatmentOK := FALSE;
            IF STRPOS(TxtPValueToTransform, ',') <> 0 THEN BEGIN
                IF EVALUATE(IntLValueToReturn, CONVERTSTR(TxtPValueToTransform, ',', '.')) THEN
                    BooLTreatmentOK := TRUE;
            END
            ELSE
                IF STRPOS(TxtPValueToTransform, '.') <> 0 THEN
                    IF EVALUATE(IntLValueToReturn, CONVERTSTR(TxtPValueToTransform, '.', ',')) THEN
                        BooLTreatmentOK := TRUE;
        END;

        EXIT(BooLTreatmentOK);
    end;

    procedure FctFormatDecimal(RecPFieldsExp: Record "PWD Fields Export Setup"; DecPValue: Decimal): Text[250]
    var
        TxtLValue: Text[250];
    begin
        //**********************************************************************************************************//
        //                           Format decimal value and return text                                           //
        //**********************************************************************************************************//
        IF RecPFieldsExp.Precision <> 0 THEN
            DecPValue := ROUND(DecPValue, RecPFieldsExp.Precision, FORMAT(RecPFieldsExp."Rounding Direction"))
        ELSE
            DecPValue := DecPValue;

        IF RecPFieldsExp.FormatStr <> '' THEN
            TxtLValue := FORMAT(DecPValue, 0, RecPFieldsExp.FormatStr)
        ELSE
            TxtLValue := FORMAT(DecPValue, 0, 2);

        //>>WMS-EBL1-004.001
        //EXIT(FtcRemoveVirg(FtcReplacePointByVirg(TxtLValue)));
        EXIT(FtcReplacePointByVirg(TxtLValue));
        //<<WMS-EBL1-004.001


        // IF RecPFieldsExp.FormatStr <> '' THEN
        // BEGIN
        //   IF RecPFieldsExp.Precision <> 0 THEN
        //     EXIT(FORMAT(ROUND(DecPValue,RecPFieldsExp.Precision, FORMAT(RecPFieldsExp."Rounding Direction")),0,RecPFieldsExp.FormatStr))
        //   ELSE
        //     EXIT(FORMAT(DecPValue,0,RecPFieldsExp.FormatStr));
        // END
        // ELSE
        // BEGIN
        //   IF RecPFieldsExp.Precision <> 0 THEN
        //     EXIT(FORMAT(ROUND(DecPValue,RecPFieldsExp.Precision, FORMAT(RecPFieldsExp."Rounding Direction"))))
        //   ELSE
        //     EXIT(FORMAT(DecPValue));
        // END;
    end;

    procedure FctFormatDate(RecPFieldsExp: Record "PWD Fields Export Setup"; DatPValue: Date): Text[250]
    begin
        //**********************************************************************************************************//
        //                                  Format Date value and return text                                       //
        //**********************************************************************************************************//

        IF RecPFieldsExp.FormatStr <> '' THEN
            EXIT(FORMAT(DatPValue, 0, RecPFieldsExp.FormatStr))
        ELSE
            EXIT(FORMAT(DatPValue));


    end;

    procedure FctFillUpString(RecPFieldsExp: Record "PWD Fields Export Setup"; TxtPValue: Text[250]): Text[250]
    var
        I: Integer;
        TxtLFillCharacter: Text[1];
    begin
        //**********************************************************************************************************//
        //                                  Fill Up text with  char                                                 //
        //**********************************************************************************************************//

        TxtPValue := COPYSTR(TxtPValue, 1, RecPFieldsExp."File Length");

        IF RecPFieldsExp."Fill Character" <> '' THEN
            TxtLFillCharacter := RecPFieldsExp."Fill Character"
        ELSE
            TxtLFillCharacter := ' ';

        IF (RecPFieldsExp."Fill up" = RecPFieldsExp."Fill up"::Left) THEN
            FOR I := 1 TO RecPFieldsExp."File Length" - STRLEN(TxtPValue) DO
                TxtPValue := TxtLFillCharacter + TxtPValue
        ELSE
            TxtPValue := PADSTR(TxtPValue, RecPFieldsExp."File Length", TxtLFillCharacter);

        //>>WMS-EBL1-003.001
        //TxtPValue := CduGAsciiToAnsi.AnsiToAscii(TxtPValue);
        TxtPValue := CduGAsciiToAnsi.AsciiToAnsi(TxtPValue);
        //<<WMS-EBL1-003.001

        EXIT(TxtPValue);
    end;

    procedure FtcRemoveVirg(TxtPTextToModify: Text[250]): Text[250]
    var
        TxtLModifyInProcess: Text[250];
    begin
        //**********************************************************************************************************//
        //                                  Change "." by ","                                                       //
        //**********************************************************************************************************//

        TxtLModifyInProcess := DELCHR(TxtPTextToModify, '=', '.');
        EXIT(TxtLModifyInProcess);
    end;

    procedure FctMergeOutStream(InPStream1: InStream; OutPStream2: OutStream; RecPTempBlob: Codeunit "Temp Blob"; CodPPartner: Code[20]): Boolean
    var
        BooLResult: Boolean;
        AutLFileManagement: dotnet "PWD FileManagement";
        InLStreamReturn: InStream;
        OutLStream: OutStream;
        TxtLError: Text[250];
    begin
        //**********************************************************************************************************//
        //                                  InStream Merge                                                          //
        //**********************************************************************************************************//
        if IsNull(AutLFileManagement) then
            AutLFileManagement := AutLFileManagement.FileManagement();
        InLStreamReturn := AutLFileManagement.MergeIstream(InPStream1, OutPStream2, TxtLError);

        IF NOT BooLResult THEN
            CduGConnectorErrorlog.InsertLogEntry(2, 0, CodPPartner, TxtLError, 0);

        RecPTempBlob.CREATEOUTSTREAM(OutLStream);
        COPYSTREAM(OutLStream, InLStreamReturn);
        EXIT(BooLResult);
    end;

    procedure FctDeleteFiles(RecLMessage: Record "PWD Connector Messages"; OptLFlowType: Option " ","Import Connector","Export Connector")
    var
        BooLNotSkip: Boolean;
        TxtLFileFound: Text[1024];
    begin
        //**********************************************************************************************************//
        //                           Use automation Delete files with log management                                //
        //**********************************************************************************************************//
        BooLNotSkip := TRUE;
        WHILE (FctScanDirectoryFiles(RecLMessage.Path, TxtLFileFound, RecLMessage."Partner Code", 0, OptLFlowType::"Import Connector") AND
               BooLNotSkip) DO
            BooLNotSkip := FctDeleteFile(TxtLFileFound, RecLMessage.Path, RecLMessage."Partner Code", 0, OptLFlowType::"Import Connector");
    end;

    procedure FctFormatDecimalWMS(RecPFieldsExp: Record "PWD Fields Export Setup"; DecPValue: Decimal): Text[250]
    var
        TxtLValue: Text[250];
    begin
        //**********************************************************************************************************//
        //                           Format decimal value and return text                                           //
        //**********************************************************************************************************//
        IF RecPFieldsExp.Precision <> 0 THEN
            DecPValue := ROUND(DecPValue, RecPFieldsExp.Precision, FORMAT(RecPFieldsExp."Rounding Direction"))
        ELSE
            DecPValue := DecPValue;

        IF RecPFieldsExp.FormatStr <> '' THEN
            TxtLValue := FORMAT(DecPValue, 0, RecPFieldsExp.FormatStr)
        ELSE
            TxtLValue := FORMAT(DecPValue, 0, 2);
        EXIT(FtcRemoveVirg(FtcReplacePointByVirg(TxtLValue)));

        // IF RecPFieldsExp.FormatStr <> '' THEN
        // BEGIN
        //   IF RecPFieldsExp.Precision <> 0 THEN
        //     EXIT(FORMAT(ROUND(DecPValue,RecPFieldsExp.Precision, FORMAT(RecPFieldsExp."Rounding Direction")),0,RecPFieldsExp.FormatStr))
        //   ELSE
        //     EXIT(FORMAT(DecPValue,0,RecPFieldsExp.FormatStr));
        // END
        // ELSE
        // BEGIN
        //   IF RecPFieldsExp.Precision <> 0 THEN
        //     EXIT(FORMAT(ROUND(DecPValue,RecPFieldsExp.Precision, FORMAT(RecPFieldsExp."Rounding Direction"))))
        //   ELSE
        //     EXIT(FORMAT(DecPValue));
        // END;
    end;

    procedure fctTODO(RecPFieldsExp: Record "PWD Fields Export Setup"; DecPValue: Decimal): Text[250]
    var
        TxtLValue: Text[250];
    begin
        //**********************************************************************************************************//
        //                           Format decimal value and return text                                           //
        //**********************************************************************************************************//
        IF RecPFieldsExp.Precision <> 0 THEN
            DecPValue := ROUND(DecPValue, RecPFieldsExp.Precision, FORMAT(RecPFieldsExp."Rounding Direction"))
        ELSE
            DecPValue := DecPValue;

        IF RecPFieldsExp.FormatStr <> '' THEN
            TxtLValue := FORMAT(DecPValue, 0, RecPFieldsExp.FormatStr)
        ELSE
            TxtLValue := FORMAT(DecPValue, 0, 2);
        EXIT(FtcRemoveVirg(FtcReplacePointByVirg(TxtLValue)));

        // IF RecPFieldsExp.FormatStr <> '' THEN
        // BEGIN
        //   IF RecPFieldsExp.Precision <> 0 THEN
        //     EXIT(FORMAT(ROUND(DecPValue,RecPFieldsExp.Precision, FORMAT(RecPFieldsExp."Rounding Direction")),0,RecPFieldsExp.FormatStr))
        //   ELSE
        //     EXIT(FORMAT(DecPValue,0,RecPFieldsExp.FormatStr));
        // END
        // ELSE
        // BEGIN
        //   IF RecPFieldsExp.Precision <> 0 THEN
        //     EXIT(FORMAT(ROUND(DecPValue,RecPFieldsExp.Precision, FORMAT(RecPFieldsExp."Rounding Direction"))))
        //   ELSE
        //     EXIT(FORMAT(DecPValue));
        // END;
    end;
}

