codeunit 8073287 "Connector Buffer Mgt Export"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // //>>ProdConnect.1.00
    // FE_ProdConnect.001:GR 22/03/2011  Connector integration
    //                                   - Create Object
    // 
    // //>>ProdConnect1.5
    // WMS-FE10.001:GR 01/07/2011  :   Connector integratioin
    //                                 - Add functions:
    //                                     FctCreateBigTextWithPosition
    //                                     FctMergeBigText
    //                                     FctConcatBigText
    //                                     FctGenerateBlob
    //                                     FctMakeFileName
    //                                 -C\AL in Functions :
    //                                     FctCreateXml
    //                                     FctCreateSeparator
    // 
    // //>>ProdConnect1.6
    // OSYS-Int001.001:GR 21/10/2011   Connector integration
    //                                   - Create function FctValidateField
    //                                   - C\AL in :  FctCreateXml
    //                                                FctCreateSeparator
    //                                                FctCreateBigTextWithPosition
    // 
    // 
    // +----------------------------------------------------------------------------------------------------------------+

    SingleInstance = false;

    trigger OnRun()
    begin
    end;

    var
        CduGConnectFieldsMgt: Codeunit "Connector Fields Management";
        CduGFileManagement: Codeunit "PWD File Management";
        BooGError: Boolean;
        CodGConnectorPartner: Code[20];
        IntGConnectorValue: Integer;
        IntGNbPosition: Integer;
        CstG001: Label 'The field %1 of the table %2 is too long to be export for this partner. Record %3 value : %4. The maximum lenght is %5.';

    procedure FctCreateXml(TxtPFilters: Text[1024]; RecPSendingMessage: Record "PWD Connector Messages"; var TempBlob: Codeunit "Temp Blob"; BooLInsertXMLHeader: Boolean)
    // var
    //     AutLXMLDom: Automation; //TODO: Type Automation n'existe pas dans la nouvelle version
    //     AutLXMLDomElement: Automation;//TODO: Type Automation n'existe pas dans la nouvelle version
    //     AutLXMLDomElement2: Automation;//TODO: Type Automation n'existe pas dans la nouvelle version
    //     AutLXMLDomElement3: Automation;//TODO: Type Automation n'existe pas dans la nouvelle version
    //     AutLXMLDomProcInst: Automation;//TODO: Type Automation n'existe pas dans la nouvelle version
    //     AutLXMLDomNodeTxt: Automation;//TODO: Type Automation n'existe pas dans la nouvelle version
    //     FldRef: FieldRef;
    //     RecLRecRef: RecordRef;
    //     RecLRecRef2: RecordRef;
    //     RecLFieldsExportSetup: Record "PWD Fields Export Setup";
    //     OusLStream: OutStream;
    //     TxtLValue: Text[250];
    //     ChrL10: Char;
    //     ChrL13: Char;
    //     RecLPartnerConnector: Record "PWD Partner Connector";
    //     DatLValue: Date;
    //     DecLValue: Decimal;
    begin
        //     //**********************************************************************************************************//
        //     //                                  Create generic Xml in blob field                                        //
        //     //**********************************************************************************************************//

        //     RecLRecRef2.OPEN(RecPSendingMessage."Table ID");

        //     RecLRecRef2.RESET();
        //     IF TxtPFilters <> '' THEN
        //         RecLRecRef2.SETVIEW(TxtPFilters);

        //     //>>WMS-FE10.001
        //     IF RecPSendingMessage."Export Option" = RecPSendingMessage."Export Option"::Partial THEN
        //         FctSetExportDateFilter(RecPSendingMessage, RecLRecRef2);
        //     IF RecLPartnerConnector.GET(RecPSendingMessage."Partner Code") THEN;
        //     //<<WMS-FE10.001

        //     //>>OSYS-Int001.001
        //     IF RecLRecRef2.ISEMPTY THEN
        //         EXIT;
        //     FctInitValidateField(RecPSendingMessage."Partner Code", 0);
        //     //<<OSYS-Int001.001

        //     CREATE(AutLXMLDom);
        //     IF BooLInsertXMLHeader THEN BEGIN
        //         AutLXMLDom.loadXML('<' + RecPSendingMessage."Partner Code" + '/>');
        //         AutLXMLDomProcInst := AutLXMLDom.createProcessingInstruction('xml', 'version="1.0" encoding="UTF-8" standalone="no"');
        //         AutLXMLDomElement := AutLXMLDom.documentElement;
        //         AutLXMLDom.insertBefore(AutLXMLDomProcInst, AutLXMLDomElement);
        //     END
        //     ELSE BEGIN
        //         AutLXMLDom.loadXML('<Parent/>');
        //         AutLXMLDomElement := AutLXMLDom.documentElement;
        //     END;


        //     IF NOT RecLRecRef2.ISEMPTY THEN BEGIN
        //         RecLRecRef2.FINDFIRST();
        //         REPEAT

        //             //>>OSYS-Int001.001
        //             RecLRecRef := RecLRecRef2.DUPLICATE();
        //             IF NOT FctCheckFields(RecLRecRef) THEN BEGIN
        //                 //<<OSYS-Int001.001

        //                 //>>WMS-FE10.001
        //                 RecPSendingMessage.TESTFIELD("Xml Tag");
        //                 //<<WMS-FE10.001

        //                 //>>OSYS-Int001.001
        //                 //intCpt +=1;
        //                 //AutLXMLDomElement2 := AutLXMLDom.createElement(RecPSendingMessage."Xml Tag" + FORMAT(intCpt));
        //                 AutLXMLDomElement2 := AutLXMLDom.createElement(RecPSendingMessage."Xml Tag");
        //                 //<<OSYS-Int001.001

        //                 AutLXMLDomElement.appendChild(AutLXMLDomElement2);
        //                 RecLFieldsExportSetup.RESET();
        //                 RecLFieldsExportSetup.SETRANGE("Partner Code", RecPSendingMessage."Partner Code");
        //                 RecLFieldsExportSetup.SETRANGE("Message Code", RecPSendingMessage.Code);
        //                 RecLFieldsExportSetup.SETRANGE("Table ID", RecLRecRef.NUMBER);

        //                 //>>WMS-FE10.001
        //                 RecLFieldsExportSetup.SETRANGE(Direction, RecLFieldsExportSetup.Direction::Export);
        //                 //<<WMS-FE10.001

        //                 IF NOT RecLFieldsExportSetup.ISEMPTY THEN BEGIN
        //                     RecLFieldsExportSetup.FINDSET();
        //                     REPEAT
        //                         RecLFieldsExportSetup.TESTFIELD("Xml Tag");
        //                         AutLXMLDomElement3 := AutLXMLDom.createElement(RecLFieldsExportSetup."Xml Tag");

        //                         //>>WMS-FE10.001
        //                         //***************************************************************************************************
        //                         //Gestion des constantes
        //                         //***************************************************************************************************
        //                         IF (RecLFieldsExportSetup."Field Type" = RecLFieldsExportSetup."Field Type"::Constante) THEN BEGIN
        //                             TxtLValue := FORMAT(RecLFieldsExportSetup."Constant Value");
        //                             AutLXMLDomNodeTxt := AutLXMLDom.createTextNode(TxtLValue);
        //                         END
        //                         ELSE BEGIN
        //                             FldRef := RecLRecRef.FIELD(RecLFieldsExportSetup."Field ID");
        //                             IF RecLFieldsExportSetup."Fct For Replace" <> '' THEN BEGIN
        //                                 //***************************************************************************************************
        //                                 //utilisation d'une fonction de remplacement, à la place des champs paramétrés
        //                                 //***************************************************************************************************
        //                                 IF FORMAT(FldRef.CLASS) = 'Option' THEN
        //                                     TxtLValue := FORMAT(FldRef.VALUE, 2)
        //                                 ELSE
        //                                     TxtLValue := FORMAT(FldRef.VALUE);
        //                                 CduGConnectFieldsMgt.FctGiveOldValue(TxtLValue, RecLFieldsExportSetup."Fct For Replace", RecLRecRef);
        //                                 CduGConnectFieldsMgt.RUN();
        //                                 TxtLValue := CduGConnectFieldsMgt.FctReturnNewValue();
        //                                 AutLXMLDomNodeTxt := AutLXMLDom.createTextNode(TxtLValue);
        //                             END
        //                             ELSE BEGIN

        //                                 //<<WMS-FE10.001

        //                                 FldRef := RecLRecRef.FIELD(RecLFieldsExportSetup."Field ID");
        //                                 IF (FORMAT(FldRef.CLASS) = 'FlowField') THEN
        //                                     FldRef.CALCFIELD();

        //                                 CASE FORMAT(FldRef.TYPE) OF
        //                                     'Boolean':
        //                                         BEGIN
        //                                             //>>WMS-FE10.001
        //                                             RecLPartnerConnector.TESTFIELD("Default Value Bool Yes");
        //                                             RecLPartnerConnector.TESTFIELD("Default Value Bool No");
        //                                             IF FldRef.VALUE THEN
        //                                                 AutLXMLDomNodeTxt := AutLXMLDom.createTextNode(RecLPartnerConnector."Default Value Bool Yes")
        //                                             ELSE
        //                                                 AutLXMLDomNodeTxt := AutLXMLDom.createTextNode(RecLPartnerConnector."Default Value Bool No");

        //                                             /*OLD:
        //                                              IF FldRef.VALUE THEN
        //                                                AutLXMLDomNodeTxt  := AutLXMLDom.createTextNode('TRUE')
        //                                              ELSE
        //                                                AutLXMLDomNodeTxt  := AutLXMLDom.createTextNode('FALSE')
        //                                             */
        //                                             //<WMS-FE10.001
        //                                         END;

        //                                     'Date':
        //                                         //>>WMS-FE10.001
        //                                         /*OLD:
        //                                         AutLXMLDomNodeTxt  := AutLXMLDom.createTextNode(FORMAT(FldRef.VALUE,0,'<day,2><month,2><year4>'));
        //                                         */
        //                                         BEGIN
        //                                             DatLValue := FldRef.VALUE;
        //                                             AutLXMLDomNodeTxt := AutLXMLDom.createTextNode(CduGFileManagement.FctFormatDate(RecLFieldsExportSetup, DatLValue)
        //                            );
        //                                         END;
        //                                     //<<WMS-FE10.001

        //                                     'DateTime':
        //                                         //>>WMS-FE10.001
        //                                         /*OLD:
        //                                         AutLXMLDomNodeTxt  := AutLXMLDom.createTextNode(FORMAT(FldRef.VALUE,0,'<day,2><month,2><year4>'));
        //                                         */
        //                                         BEGIN
        //                                             DatLValue := FldRef.VALUE;
        //                                             AutLXMLDomNodeTxt := AutLXMLDom.createTextNode(CduGFileManagement.FctFormatDate(RecLFieldsExportSetup, DatLValue)
        //                            );
        //                                         END;
        //                                     //<<WMS-FE10.001

        //                                     'Decimal':
        //                                         //>>WMS-FE10.001
        //                                         /*OLD:
        //                                         AutLXMLDomNodeTxt  := AutLXMLDom.createTextNode(FtcRemoveChar(TxtLValue))
        //                                         */
        //                                         BEGIN
        //                                             DecLValue := FldRef.VALUE;
        //                                             TxtLValue := FctNormalizeDecimal(CduGFileManagement.FctFormatDecimal(RecLFieldsExportSetup, DecLValue));
        //                                             AutLXMLDomNodeTxt := AutLXMLDom.createTextNode(FtcRemoveChar(TxtLValue))
        //                                         END;
        //                                     //<<WMS-FE10.001

        //                                     'Integer':
        //                                         BEGIN
        //                                             TxtLValue := FctNormalizeDecimal(FORMAT(FldRef.VALUE));
        //                                             AutLXMLDomNodeTxt := AutLXMLDom.createTextNode(FtcRemoveChar(TxtLValue))
        //                                         END;
        //                                     ELSE BEGIN
        //                                             TxtLValue := DELCHR(FORMAT(FldRef.VALUE), '=', FORMAT(FORMAT(ChrL13)));
        //                                             TxtLValue := DELCHR(TxtLValue, '=', FORMAT(FORMAT(ChrL10)));
        //                                             AutLXMLDomNodeTxt := AutLXMLDom.createTextNode(TxtLValue);
        //                                         END;
        //                                 END;

        //                                 //>>WMS-FE10.001
        //                             END;
        //                         END;
        //                         //<<WMS-FE10.001

        //                         AutLXMLDomElement3.appendChild(AutLXMLDomNodeTxt);
        //                         AutLXMLDomElement2.appendChild(AutLXMLDomElement3);
        //                     UNTIL RecLFieldsExportSetup.NEXT() = 0;
        //                 END;

        //                 //>>OSYS-Int001.001
        //             END;
        //         //<<OSYS-Int001.001
        //         UNTIL RecLRecRef2.NEXT() = 0;
        //     END;

        //     RecLRecRef2.CLOSE();
        //     TempBlob.CREATEOUTSTREAM(OusLStream);
        //     AutLXMLDom.save(OusLStream);

    end;


    procedure FctCreateSeparator(TxtPFilters: Text[1024]; RecPSendingMessage: Record "PWD Connector Messages"; var TempBlob: Codeunit "Temp Blob")
    var
        RecLFieldsExportSetup: Record "PWD Fields Export Setup";
        RecLPartnerConnector: Record "PWD Partner Connector";
        BigTLBigTextToReturn: BigText;
        RecLRecRef: RecordRef;
        RecLRecRef2: RecordRef;
        FldRef: FieldRef;
        BooLFirstInLoop: Boolean;
        ChrL10: Char;
        ChrL13: Char;
        DatLValue: Date;
        DecLValue: Decimal;
        OusLStream: OutStream;
        TxtLValue: Text[250];
    begin
        //**********************************************************************************************************//
        //                                  Create generic file with Separator in blob field                        //
        //**********************************************************************************************************//


        RecLRecRef2.OPEN(RecPSendingMessage."Table ID");
        RecLRecRef2.RESET();
        ChrL10 := 10;
        ChrL13 := 13;
        IF RecLPartnerConnector.GET(RecPSendingMessage."Partner Code") THEN BEGIN
            IF TxtPFilters <> '' THEN
                RecLRecRef2.SETVIEW(TxtPFilters);

            //>>WMS-FE10.001
            IF RecPSendingMessage."Export Option" = RecPSendingMessage."Export Option"::Partial THEN
                FctSetExportDateFilter(RecPSendingMessage, RecLRecRef2);
            //<<WMS-FE10.001

            //>>OSYS-Int001.001
            IF RecLRecRef2.ISEMPTY THEN
                EXIT;
            FctInitValidateField(RecPSendingMessage."Partner Code", 0);
            //<<OSYS-Int001.001

            RecLPartnerConnector.TESTFIELD(Separator);
            IF NOT RecLRecRef2.ISEMPTY THEN BEGIN
                RecLRecRef2.FINDSET();
                REPEAT
                    //>>OSYS-Int001.001
                    RecLRecRef := RecLRecRef2.DUPLICATE();
                    IF NOT FctCheckFields(RecLRecRef) THEN BEGIN
                        //<<OSYS-Int001.001

                        RecLFieldsExportSetup.RESET();
                        RecLFieldsExportSetup.SETRANGE("Partner Code", RecPSendingMessage."Partner Code");
                        RecLFieldsExportSetup.SETRANGE("Message Code", RecPSendingMessage.Code);
                        RecLFieldsExportSetup.SETRANGE("Table ID", RecLRecRef.NUMBER);

                        //>>WMS-FE10.001
                        RecLFieldsExportSetup.SETRANGE(Direction, RecLFieldsExportSetup.Direction::Export);
                        //<<WMS-FE10.001

                        BooLFirstInLoop := TRUE;
                        IF NOT RecLFieldsExportSetup.ISEMPTY THEN BEGIN
                            RecLFieldsExportSetup.FINDSET();
                            REPEAT
                                FldRef := RecLRecRef.FIELD(RecLFieldsExportSetup."Field ID");
                                IF NOT BooLFirstInLoop THEN
                                    BigTLBigTextToReturn.ADDTEXT(FORMAT(RecLPartnerConnector.Separator));

                                //>>WMS-FE10.001
                                //**********************************************************************************************************
                                //Gestion des constantes
                                //**********************************************************************************************************
                                IF (RecLFieldsExportSetup."Field Type" = RecLFieldsExportSetup."Field Type"::Constante) THEN BEGIN
                                    TxtLValue := FORMAT(RecLFieldsExportSetup."Constant Value");
                                    BigTLBigTextToReturn.ADDTEXT(TxtLValue);
                                END
                                ELSE BEGIN
                                    FldRef := RecLRecRef.FIELD(RecLFieldsExportSetup."Field ID");

                                    IF RecLFieldsExportSetup."Fct For Replace" <> '' THEN BEGIN
                                        //**********************************************************************************************************
                                        //utilisation d'une fonction de remplacement, à la place des champs paramétrés
                                        //**********************************************************************************************************
                                        IF FORMAT(FldRef.CLASS) = 'Option' THEN
                                            TxtLValue := FORMAT(FldRef.VALUE, 2)
                                        ELSE
                                            TxtLValue := FORMAT(FldRef.VALUE);
                                        CduGConnectFieldsMgt.FctGiveOldValue(TxtLValue, RecLFieldsExportSetup."Fct For Replace", RecLRecRef);
                                        CduGConnectFieldsMgt.RUN();
                                        TxtLValue := CduGConnectFieldsMgt.FctReturnNewValue();
                                        BigTLBigTextToReturn.ADDTEXT(TxtLValue);
                                    END
                                    ELSE BEGIN
                                        //<<WMS-FE10.001

                                        IF (FORMAT(FldRef.CLASS) = 'FlowField') THEN
                                            FldRef.CALCFIELD();

                                        CASE FORMAT(FldRef.TYPE) OF
                                            'Boolean':
                                                BEGIN
                                                    //>>WMS-FE10.001
                                                    RecLPartnerConnector.TESTFIELD("Default Value Bool Yes");
                                                    RecLPartnerConnector.TESTFIELD("Default Value Bool No");
                                                    IF FldRef.VALUE THEN
                                                        BigTLBigTextToReturn.ADDTEXT(RecLPartnerConnector."Default Value Bool Yes")
                                                    ELSE
                                                        BigTLBigTextToReturn.ADDTEXT(RecLPartnerConnector."Default Value Bool No");

                                                    /*OLD:
                                                      IF FldRef.VALUE THEN
                                                        BigTLBigTextToReturn.ADDTEXT('TRUE')
                                                      ELSE
                                                        BigTLBigTextToReturn.ADDTEXT('FALSE');
                                                    */
                                                    //<WMS-FE10.001
                                                END;

                                            'Date':

                                                //>>WMS-FE10.001
                                                /*OLD:
                                                 BigTLBigTextToReturn.ADDTEXT(FORMAT(FldRef.VALUE,0,'<day,2><month,2><year4>'));
                                                */
                                                BEGIN
                                                    DatLValue := FldRef.VALUE;
                                                    BigTLBigTextToReturn.ADDTEXT(CduGFileManagement.FctFormatDate(RecLFieldsExportSetup, DatLValue));
                                                END;
                                            //<<WMS-FE10.001


                                            'DateTime':

                                                //>>WMS-FE10.001
                                                /*OLD:
                                                 BigTLBigTextToReturn.ADDTEXT(FORMAT(FldRef.VALUE,0,'<day,2><month,2><year4>'));
                                                */
                                                BEGIN
                                                    DatLValue := FldRef.VALUE;
                                                    BigTLBigTextToReturn.ADDTEXT(CduGFileManagement.FctFormatDate(RecLFieldsExportSetup, DatLValue));
                                                END;
                                            //<<WMS-FE10.001


                                            'Decimal':
                                                //>>WMS-FE10.001
                                                /*OLD:
                                                   BEGIN
                                                     TxtLValue := FctNormalizeDecimal(FtcRemoveChar(FORMAT(FldRef.VALUE)));
                                                     BigTLBigTextToReturn.ADDTEXT(TxtLValue);
                                                   END;
                                                */
                                                BEGIN
                                                    DecLValue := FldRef.VALUE;
                                                    TxtLValue := FctNormalizeDecimal(CduGFileManagement.FctFormatDecimal(RecLFieldsExportSetup, DecLValue));
                                                    BigTLBigTextToReturn.ADDTEXT(FtcRemoveChar(TxtLValue));
                                                END;
                                            //<<WMS-FE10.001


                                            'Integer':
                                                BEGIN
                                                    TxtLValue := FctNormalizeDecimal(FtcRemoveChar(FORMAT(FldRef.VALUE)));
                                                    BigTLBigTextToReturn.ADDTEXT(TxtLValue);
                                                END;
                                            ELSE BEGIN
                                                    TxtLValue := DELCHR(FORMAT(FldRef.VALUE), '=', FORMAT(FORMAT(ChrL13)));
                                                    TxtLValue := DELCHR(TxtLValue, '=', FORMAT(FORMAT(ChrL10)));
                                                    BigTLBigTextToReturn.ADDTEXT(FORMAT(FldRef.VALUE));
                                                END;
                                        END;

                                        //>>WMS-FE10.001
                                    END;
                                END;
                                //<<WMS-FE10.001

                                BooLFirstInLoop := FALSE;
                            UNTIL RecLFieldsExportSetup.NEXT() = 0;
                            BigTLBigTextToReturn.ADDTEXT(FORMAT(ChrL13) + FORMAT(ChrL10));
                        END;

                        //>>OSYS-Int001.001
                    END;
                //<<OSYS-Int001.001

                UNTIL RecLRecRef2.NEXT() = 0;
            END;
        END;

        RecLRecRef2.CLOSE();

        //>>WMS-FE10.001
        IF BigTLBigTextToReturn.LENGTH <> 0 THEN BEGIN
            //<<WMS-FE10.001

            TempBlob.CREATEOUTSTREAM(OusLStream);
            BigTLBigTextToReturn.WRITE(OusLStream);

            //>>WMS-FE10.001
        END;
        //<<WMS-FE10.001

    end;


    procedure FtcRemoveChar(TxtPTextToModify: Text[250]): Text[250]
    var
        Chr255: Char;
        TxtLChar: Text[1];
        TxtLModifyInProcess: Text[250];
    begin
        TxtLModifyInProcess := DELCHR(TxtPTextToModify);
        Chr255 := 255;
        TxtLChar := FORMAT(Chr255);
        TxtLModifyInProcess := DELCHR(TxtPTextToModify, '=', TxtLChar);
        Chr255 := 255;
        TxtLChar := FORMAT(Chr255);

        TxtLModifyInProcess := CONVERTSTR(TxtLModifyInProcess, ',', '.');
        EXIT(TxtLModifyInProcess);
    end;


    procedure FctNormalizeDecimal(TxtPDecimalToNormalize: Text[250]): Text[250]
    var
        ChrLChar: Char;
        IntLI: Integer;
    begin
        FOR IntLI := 0 TO 47 DO
            IF (IntLI <> 44) AND (IntLI <> 45) AND (IntLI <> 46) THEN BEGIN
                ChrLChar := IntLI;
                TxtPDecimalToNormalize := DELCHR(TxtPDecimalToNormalize, '=', FORMAT(ChrLChar));
            END;
        FOR IntLI := 58 TO 255 DO BEGIN
            ChrLChar := IntLI;
            TxtPDecimalToNormalize := DELCHR(TxtPDecimalToNormalize, '=', FORMAT(ChrLChar));
        END;
        EXIT(TxtPDecimalToNormalize)
    end;


    procedure "---ProdConnect1.5---"()
    begin
    end;


    procedure FctCreateBigTextWithPosition(TxtPFilters: Text[1024]; RecPSendingMessage: Record "PWD Connector Messages"; var BigTPToReturn: BigText)
    var
        RecLSendingMessage: Record "PWD Connector Messages";
        RecLFieldsExportLenght: Record "PWD Fields Export Setup";
        RecLFieldsExportSetup: Record "PWD Fields Export Setup";
        RecLPartnerConnector: Record "PWD Partner Connector";
        RecLRecRef: RecordRef;
        RecLRecRef2: RecordRef;
        FldRef: FieldRef;
        ChrL10: Char;
        ChrL13: Char;
        DatLValue: Date;
        DecLValue: Decimal;
        i: Integer;
        IntLCurrentLenth: Integer;
        IntLCurrentNbPosition: Integer;
        IntLMaxLength: Integer;
        TxtLValue: Text[250];
    begin
        //**********************************************************************************************************//
        //                                  Create generic file with Define position in blob field                  //
        //**********************************************************************************************************//

        RecLRecRef2.OPEN(RecPSendingMessage."Table ID");
        RecLRecRef2.RESET();

        ChrL10 := 10;
        ChrL13 := 13;

        IF RecLPartnerConnector.GET(RecPSendingMessage."Partner Code") THEN BEGIN

            //**********************************************************************************************************
            //Recuperation de la taille Maximum d'une ligne
            //**********************************************************************************************************
            IntLMaxLength := 0;

            RecLSendingMessage.RESET();
            RecLSendingMessage.SETRANGE("Partner Code", RecPSendingMessage."Partner Code");
            RecLSendingMessage.SETRANGE("Function", RecPSendingMessage."Function");
            IF RecLSendingMessage.FINDSET() THEN
                REPEAT
                    RecLFieldsExportLenght.SETCURRENTKEY("File Position");
                    RecLFieldsExportLenght.RESET();
                    RecLFieldsExportLenght.SETRANGE("Partner Code", RecLSendingMessage."Partner Code");
                    RecLFieldsExportLenght.SETRANGE("Message Code", RecLSendingMessage.Code);

                    //>>WMS-FE10.001
                    RecLFieldsExportLenght.SETRANGE(Direction, RecLFieldsExportSetup.Direction::Export);
                    //<<WMS-FE10.001

                    IF RecLFieldsExportLenght.FINDLAST() THEN
                        IF (RecLFieldsExportLenght."File Position" + (RecLFieldsExportLenght."File Length" - 1)) > IntLMaxLength THEN
                            IntLMaxLength := RecLFieldsExportLenght."File Position" + (RecLFieldsExportLenght."File Length" - 1);
                UNTIL RecLSendingMessage.NEXT() = 0;

            //**********************************************************************************************************
            //Passage des filtres
            //**********************************************************************************************************
            IF TxtPFilters <> '' THEN
                RecLRecRef2.SETVIEW(TxtPFilters);

            IF RecPSendingMessage."Export Option" = RecPSendingMessage."Export Option"::Partial THEN
                FctSetExportDateFilter(RecPSendingMessage, RecLRecRef2);

            //>>OSYS-Int001.001
            IF RecLRecRef2.ISEMPTY THEN
                EXIT;

            FctInitValidateField(RecPSendingMessage."Partner Code", 0);
            //<<OSYS-Int001.001

            //**********************************************************************************************************
            //Travail sur plusieurs lignes
            //**********************************************************************************************************
            IF NOT RecLRecRef2.ISEMPTY THEN BEGIN
                RecLRecRef2.FINDSET();
                REPEAT
                    //>>OSYS-Int001.001
                    RecLRecRef := RecLRecRef2.DUPLICATE();
                    IF NOT FctCheckFields(RecLRecRef) THEN BEGIN
                        //<<OSYS-Int001.001


                        IntLCurrentLenth := 0;

                        RecLFieldsExportSetup.SETCURRENTKEY("File Position");
                        RecLFieldsExportSetup.RESET();
                        RecLFieldsExportSetup.SETRANGE("Partner Code", RecPSendingMessage."Partner Code");
                        RecLFieldsExportSetup.SETRANGE("Message Code", RecPSendingMessage.Code);
                        RecLFieldsExportSetup.SETRANGE("Table ID", RecLRecRef.NUMBER);

                        //>>WMS-FE10.001
                        RecLFieldsExportSetup.SETRANGE(Direction, RecLFieldsExportSetup.Direction::Export);
                        //<<WMS-FE10.001

                        IF NOT RecLFieldsExportSetup.ISEMPTY THEN BEGIN
                            RecLFieldsExportSetup.FINDSET();

                            //**********************************************************************************************************
                            //Travail sur 1 ligne
                            //**********************************************************************************************************
                            REPEAT
                                RecLFieldsExportSetup.TESTFIELD("File Length");
                                //IntGNbPosition obtenu par la fonction FctNbPosition
                                IF IntGNbPosition <> 0 THEN
                                    FOR IntLCurrentNbPosition := 1 TO IntGNbPosition DO
                                        RecLFieldsExportSetup."File Position" += RecLFieldsExportSetup."File Length";

                                IF (RecLFieldsExportSetup."File Position" > (IntLCurrentLenth + 1)) THEN
                                    FOR i := (IntLCurrentLenth + 1) TO (RecLFieldsExportSetup."File Position" - 1) DO
                                        IF RecLFieldsExportSetup."Fill Character" <> '' THEN
                                            BigTPToReturn.ADDTEXT(RecLFieldsExportSetup."Fill Character")
                                        ELSE
                                            BigTPToReturn.ADDTEXT(' ');

                                //**********************************************************************************************************
                                //Gestion des constantes
                                //**********************************************************************************************************
                                IF /*((RecLFieldsExportSetup."Field ID" = 0) AND */
                                    (RecLFieldsExportSetup."Field Type" = RecLFieldsExportSetup."Field Type"::Constante) THEN BEGIN
                                    TxtLValue := CduGFileManagement.FctFillUpString(RecLFieldsExportSetup, FORMAT(RecLFieldsExportSetup."Constant Value")
                      );
                                    BigTPToReturn.ADDTEXT(TxtLValue);
                                END
                                ELSE BEGIN
                                    FldRef := RecLRecRef.FIELD(RecLFieldsExportSetup."Field ID");

                                    IF RecLFieldsExportSetup."Fct For Replace" <> '' THEN BEGIN
                                        //**********************************************************************************************************
                                        //utilisation d'une fonction de remplacement, à la place des champs paramétrés
                                        //**********************************************************************************************************
                                        IF FORMAT(FldRef.CLASS) = 'Option' THEN
                                            TxtLValue := FORMAT(FldRef.VALUE, 2)
                                        ELSE
                                            TxtLValue := FORMAT(FldRef.VALUE);
                                        CduGConnectFieldsMgt.FctGiveOldValue(TxtLValue, RecLFieldsExportSetup."Fct For Replace", RecLRecRef);
                                        CduGConnectFieldsMgt.RUN();
                                        BigTPToReturn.ADDTEXT(CduGFileManagement.FctFillUpString(RecLFieldsExportSetup,
                                                              CduGConnectFieldsMgt.FctReturnNewValue()));
                                    END
                                    ELSE BEGIN
                                        //**********************************************************************************************************
                                        //utilisation des champs paramétrés
                                        //**********************************************************************************************************
                                        IF (FORMAT(FldRef.CLASS) = 'FlowField') THEN
                                            FldRef.CALCFIELD();

                                        CASE FORMAT(FldRef.TYPE) OF
                                            'Boolean':
                                                BEGIN
                                                    RecLPartnerConnector.TESTFIELD("Default Value Bool Yes");
                                                    RecLPartnerConnector.TESTFIELD("Default Value Bool No");
                                                    IF FldRef.VALUE THEN
                                                        BigTPToReturn.ADDTEXT(CduGFileManagement.FctFillUpString(RecLFieldsExportSetup,
                                                                              RecLPartnerConnector."Default Value Bool Yes"))
                                                    ELSE
                                                        BigTPToReturn.ADDTEXT(CduGFileManagement.FctFillUpString(RecLFieldsExportSetup,
                                                                              RecLPartnerConnector."Default Value Bool No"));
                                                END;

                                            'Date':
                                                BEGIN
                                                    DatLValue := FldRef.VALUE;
                                                    BigTPToReturn.ADDTEXT(CduGFileManagement.FctFillUpString(RecLFieldsExportSetup,
                                                                          CduGFileManagement.FctFormatDate(RecLFieldsExportSetup, DatLValue)));
                                                END;

                                            'DateTime':
                                                BEGIN
                                                    DatLValue := FldRef.VALUE;
                                                    BigTPToReturn.ADDTEXT(CduGFileManagement.FctFillUpString(RecLFieldsExportSetup,
                                                                          CduGFileManagement.FctFormatDate(RecLFieldsExportSetup, DatLValue)));
                                                END;

                                            'Decimal':
                                                BEGIN
                                                    DecLValue := FldRef.VALUE;
                                                    TxtLValue := CduGFileManagement.FctFillUpString(RecLFieldsExportSetup,
                                                                                            CduGFileManagement.FctFormatDecimal(RecLFieldsExportSetup, DecLValue))
                               ;
                                                    BigTPToReturn.ADDTEXT(TxtLValue);
                                                END;

                                            'Integer':
                                                BEGIN
                                                    TxtLValue := CduGFileManagement.FctFillUpString(RecLFieldsExportSetup, FORMAT(FldRef.VALUE));
                                                    BigTPToReturn.ADDTEXT(TxtLValue);
                                                END;

                                            ELSE BEGIN
                                                    TxtLValue := DELCHR(FORMAT(FldRef.VALUE), '=', FORMAT(FORMAT(ChrL13)));
                                                    TxtLValue := DELCHR(TxtLValue, '=', FORMAT(FORMAT(ChrL10)));
                                                    TxtLValue := CduGFileManagement.FctFillUpString(RecLFieldsExportSetup, FORMAT(FldRef.VALUE));
                                                    BigTPToReturn.ADDTEXT(TxtLValue);
                                                END;
                                        END;
                                    END;
                                END;
                                IntLCurrentLenth := (RecLFieldsExportSetup."File Length" - 1) + RecLFieldsExportSetup."File Position";
                            UNTIL RecLFieldsExportSetup.NEXT() = 0;
                        END;
                        IF BigTPToReturn.LENGTH <> 0 THEN BEGIN
                            IF IntLMaxLength > IntLCurrentLenth THEN
                                FOR i := (IntLCurrentLenth + 1) TO IntLMaxLength DO
                                    IF RecLFieldsExportSetup."Fill Character" <> '' THEN
                                        BigTPToReturn.ADDTEXT(RecLFieldsExportSetup."Fill Character")
                                    ELSE
                                        BigTPToReturn.ADDTEXT(' ');

                            BigTPToReturn.ADDTEXT(FORMAT(ChrL13) + FORMAT(ChrL10));
                        END;

                        //>>OSYS-Int001.001
                    END;
                //<<OSYS-Int001.001

                UNTIL RecLRecRef2.NEXT() = 0;
            END
            ELSE
                IF BigTPToReturn.LENGTH <> 0 THEN BEGIN
                    IF IntLMaxLength > IntLCurrentLenth THEN
                        FOR i := (IntLCurrentLenth + 1) TO IntLMaxLength DO
                            IF RecLFieldsExportSetup."Fill Character" <> '' THEN
                                BigTPToReturn.ADDTEXT(RecLFieldsExportSetup."Fill Character")
                            ELSE
                                BigTPToReturn.ADDTEXT(' ');
                    BigTPToReturn.ADDTEXT(FORMAT(ChrL13) + FORMAT(ChrL10));
                END;
        END;

        RecLRecRef2.CLOSE();

    end;


    procedure FctMergeBigText(TxtPFillCharacter: Text[1]; BigTPBigText1: BigText; BigTPBigText2: BigText; var BigTPBigResult: BigText)
    var
        i: Integer;
        IntLMaxLength: Integer;
        CharLToAdd: Text[1];
        CharLValueText1: Text[1];
        CharLValueText2: Text[1];
    begin
        CLEAR(BigTPBigResult);

        IF TxtPFillCharacter = '' THEN
            TxtPFillCharacter := ' ';
        IF BigTPBigText1.LENGTH > BigTPBigText2.LENGTH THEN
            IntLMaxLength := BigTPBigText1.LENGTH
        ELSE
            IntLMaxLength := BigTPBigText2.LENGTH;

        FOR i := 1 TO IntLMaxLength DO BEGIN
            IF i <= BigTPBigText1.LENGTH THEN
                BigTPBigText1.GETSUBTEXT(CharLValueText1, i, 1)
            ELSE
                CharLValueText1 := TxtPFillCharacter;
            IF i <= BigTPBigText2.LENGTH THEN
                BigTPBigText2.GETSUBTEXT(CharLValueText2, i, 1)
            ELSE
                CharLValueText2 := TxtPFillCharacter;

            CharLToAdd := TxtPFillCharacter;
            IF CharLValueText1 <> TxtPFillCharacter THEN
                CharLToAdd := CharLValueText1;
            IF CharLValueText2 <> TxtPFillCharacter THEN
                CharLToAdd := CharLValueText2;

            BigTPBigResult.ADDTEXT(CharLToAdd);
        END;
    end;


    procedure FctConcatBigText(BigTPBigTextToAdd: BigText; var BigTPBigTextToReturn: BigText)
    begin
        BigTPBigTextToReturn.ADDTEXT(BigTPBigTextToAdd);
    end;


    procedure FctGenerateBlob(BigTPToTransform: BigText; var TempBlob: Codeunit "Temp Blob")
    var
        OusLStream: OutStream;
    begin
        TempBlob.CREATEOUTSTREAM(OusLStream);
        BigTPToTransform.WRITE(OusLStream);
    end;


    procedure FctSetExportDateFilter(RecPExportMessage: Record "PWD Connector Messages"; var RecPRef: RecordRef)
    var
        FieldLRef: FieldRef;
    begin
        FieldLRef := RecPRef.FIELD(RecPExportMessage."Field ID");
        FieldLRef.SETFILTER('>=%1', RecPExportMessage."Export Date");
    end;


    procedure FctMakeFileName(TxtPPath: Text[250]; CodPPartner: Code[20]; IntPBufferMessageNo: Integer; RecPPartner: Record "PWD Partner Connector"; TxtPFixedValue: Text[50]; BooPSocietyCode: Boolean; BooPDate: Boolean; BooPTime: Boolean; TxtPExtension: Text[5]): Text[1024]
    var
        TxLExtension: Text[4];
        TxtPNameValue: Text[100];
    begin
        IF RecPPartner."Data Format" = RecPPartner."Data Format"::Xml THEN
            TxLExtension := '.xml'
        ELSE
            IF TxtPExtension <> '' THEN
                TxLExtension := '.' + TxtPExtension
            ELSE
                TxLExtension := '.txt';

        TxtPNameValue := '';
        IF TxtPFixedValue <> '' THEN BEGIN
            IF BooPSocietyCode THEN
                TxtPNameValue := CodPPartner + '_';

            TxtPNameValue := TxtPNameValue + TxtPFixedValue + '_' + FORMAT(IntPBufferMessageNo);

            IF BooPDate THEN
                TxtPNameValue := TxtPNameValue + '_' + FORMAT(WORKDATE(), 0, '<year4><month,2><day,2>');
            IF BooPTime THEN
                TxtPNameValue := TxtPNameValue + '_' + FORMAT(TIME, 0, '<hour,2><minute,2><Second,2>');
        END
        ELSE
            TxtPNameValue := CodPPartner + '_' + FORMAT(IntPBufferMessageNo) + '_' + FORMAT(WORKDATE(), 0, '<year4><month,2><day,2>') + '_' +
                             FORMAT(TIME, 0, '<hour,2><minute,2><Second,2>');

        EXIT(TxtPPath + '\' + TxtPNameValue + TxLExtension);
        //<<FE_ProdConnect.002
    end;


    procedure FctNbPosition(IntPNbPosition: Integer)
    begin
        IntGNbPosition := IntPNbPosition;
    end;


    procedure "--ProdConnect1.6--"()
    begin
    end;


    procedure FctValidateField(IntPTableID: Integer; IntPFieldID: Integer; TxtPValue: Text[250]; RecPRecordID: RecordID): Text[250]
    var
        RecLPartnerConnectorFields: Record "PWD Partner Connector Fields";
        CduLConnectorErrorlog: Codeunit "PWD Connector Error log";
    begin
        //>>OSYS-Int001.001
        IF RecLPartnerConnectorFields.GET(CodGConnectorPartner, IntPTableID, IntPFieldID) THEN BEGIN
            //Gestion des erreurs de longueur max
            IF (STRLEN(TxtPValue) > RecLPartnerConnectorFields."Max Lenght") THEN
                CASE RecLPartnerConnectorFields."Max Lenght Error" OF

                    RecLPartnerConnectorFields."Max Lenght Error"::Error:
                        BEGIN
                            CduLConnectorErrorlog.InsertLogEntry(2, 2, CodGConnectorPartner,
                                                    STRSUBSTNO(CstG001, IntPFieldID, IntPTableID,
                                                    FORMAT(RecPRecordID),
                                                    TxtPValue, RecLPartnerConnectorFields."Max Lenght")
                                                    , IntGConnectorValue);
                            BooGError := TRUE;
                            EXIT('');
                        END;

                    RecLPartnerConnectorFields."Max Lenght Error"::Truncate:

                        EXIT(COPYSTR(TxtPValue, 1, RecLPartnerConnectorFields."Max Lenght"));
                END
            ELSE
                EXIT(TxtPValue);

        END ELSE
            EXIT(TxtPValue);
        //<<OSYS-Int001.001
    end;


    procedure FctInitValidateField(CodPConnectorPartner: Code[20]; IntPConnectorValue: Integer)
    begin
        //>>OSYS-Int001.001
        CodGConnectorPartner := CodPConnectorPartner;
        IntGConnectorValue := IntPConnectorValue;
        //<<OSYS-Int001.001
    end;


    procedure FctCheckFields(var RefRecord: RecordRef): Boolean
    var
        RecLField: Record "Field";
        RecLPartnerConnectorFields: Record "PWD Partner Connector Fields";
        FieldRef: FieldRef;
        DatLDate: Date;
        DtiLDateTime: DateTime;
        DecLDecimal: Decimal;
        IntLInteger: Integer;
    begin
        //>>OSYS-Int001.001
        BooGError := FALSE;

        RecLPartnerConnectorFields.SETRANGE("Partner Code", CodGConnectorPartner);
        RecLPartnerConnectorFields.SETRANGE("Table ID", RefRecord.NUMBER);
        IF NOT RecLPartnerConnectorFields.ISEMPTY THEN BEGIN
            RecLPartnerConnectorFields.FINDSET();
            REPEAT
                FieldRef := RefRecord.FIELD(RecLPartnerConnectorFields."Field ID");
                RecLField.GET(RecLPartnerConnectorFields."Table ID", RecLPartnerConnectorFields."Field ID");
                CASE RecLField.Type OF
                    RecLField.Type::Date:
                        BEGIN
                            EVALUATE(DatLDate, FctValidateField(RecLPartnerConnectorFields."Table ID", RecLPartnerConnectorFields."Field ID", FORMAT(FieldRef.VALUE), RefRecord.RECORDID));
                            FieldRef.VALUE := DatLDate;
                        END;

                    RecLField.Type::Decimal:
                        BEGIN
                            EVALUATE(DecLDecimal, FctValidateField(RecLPartnerConnectorFields."Table ID", RecLPartnerConnectorFields."Field ID", FORMAT(FieldRef.VALUE), RefRecord.RECORDID));
                            FieldRef.VALUE := DecLDecimal;
                        END;

                    RecLField.Type::Integer, RecLField.Type::Option:
                        BEGIN
                            EVALUATE(IntLInteger, FctValidateField(RecLPartnerConnectorFields."Table ID", RecLPartnerConnectorFields."Field ID", FORMAT(FieldRef.VALUE), RefRecord.RECORDID));
                            FieldRef.VALUE := IntLInteger;
                        END;

                    RecLField.Type::DateTime:
                        BEGIN
                            EVALUATE(DtiLDateTime, FctValidateField(RecLPartnerConnectorFields."Table ID", RecLPartnerConnectorFields."Field ID", FORMAT(FieldRef.VALUE), RefRecord.RECORDID));
                            FieldRef.VALUE := DtiLDateTime;
                        END;

                    ELSE
                        FieldRef.VALUE := FctValidateField(RecLPartnerConnectorFields."Table ID", RecLPartnerConnectorFields."Field ID", FORMAT(FieldRef.VALUE), RefRecord.RECORDID);
                END;
            UNTIL RecLPartnerConnectorFields.NEXT() = 0;
        END;

        EXIT(BooGError);
        //<<OSYS-Int001.001
    end;


    procedure FctTransferFields(RecordRefFrom: RecordRef; var RecordRefTo: RecordRef)
    var
        RecLField: Record "Field";
        RecLFieldFrom: FieldRef;
        RecLFieldTo: FieldRef;
    begin
        //>>OSYS-Int001.001
        RecLField.SETRANGE(TableNo, RecordRefFrom.NUMBER);
        IF NOT RecLField.ISEMPTY THEN BEGIN
            RecLField.FINDSET();

            REPEAT
                RecLFieldFrom := RecordRefFrom.FIELD(RecLField."No.");
                RecLFieldTo := RecordRefTo.FIELD(RecLField."No.");
                RecLFieldTo.VALUE := RecLFieldFrom.VALUE;
            UNTIL RecLField.NEXT() = 0;
        END;
        //<<OSYS-Int001.001
    end;


    procedure FctTransferField(RecordRefFrom: RecordRef; IntLFieldFromID: Integer; var RecordRefTo: RecordRef; IntLFieldToID: Integer)
    var
        FieldRefFrom: FieldRef;
        FieldRefTo: FieldRef;
    begin
        //>>OSYS-Int001.001
        FieldRefFrom := RecordRefFrom.FIELD(IntLFieldFromID);
        FieldRefTo := RecordRefTo.FIELD(IntLFieldToID);
        FieldRefTo.VALUE := FieldRefFrom.VALUE;
        FieldRefFrom := RecordRefFrom.FIELD(IntLFieldFromID);
        //<<OSYS-Int001.001
    end;


    procedure FctCreateFileWithPosition(TxtPFilters: Text[1024]; RecPSendingMessage: Record "PWD Connector Messages"; var TempBlob: Codeunit "Temp Blob")
    var
        RecLFieldsExportSetup: Record "PWD Fields Export Setup";
        RecLPartnerConnector: Record "PWD Partner Connector";
        BigTLBigTextToReturn: BigText;
        RecLRecRef: RecordRef;
        FldRef: FieldRef;
        BooLtest: Boolean;
        ChrL10: Char;
        ChrL13: Char;
        OusLStream: OutStream;
        TxtLValue: Text[250];
    begin
        //**********************************************************************************************************//
        //                                  Create generic file with Define position in blob field                  //
        //**********************************************************************************************************//

        RecLRecRef.OPEN(RecPSendingMessage."Table ID");
        RecLRecRef.RESET();
        ChrL10 := 10;
        ChrL13 := 13;
        IF RecLPartnerConnector.GET(RecPSendingMessage."Partner Code") THEN
            IF TxtPFilters <> '' THEN
                RecLRecRef.SETVIEW(TxtPFilters);
        IF NOT RecLRecRef.ISEMPTY THEN BEGIN
            RecLRecRef.FINDSET();
            REPEAT
                RecLFieldsExportSetup.SETCURRENTKEY("File Position");
                RecLFieldsExportSetup.RESET();
                RecLFieldsExportSetup.SETRANGE("Partner Code", RecPSendingMessage."Partner Code");
                RecLFieldsExportSetup.SETRANGE("Message Code", RecPSendingMessage.Code);
                RecLFieldsExportSetup.SETRANGE("Table ID", RecLRecRef.NUMBER);
                IF NOT RecLFieldsExportSetup.ISEMPTY THEN BEGIN
                    RecLFieldsExportSetup.FINDSET();
                    REPEAT
                        RecLFieldsExportSetup.TESTFIELD("File Length");

                        FldRef := RecLRecRef.FIELD(RecLFieldsExportSetup."Field ID");
                        IF (FORMAT(FldRef.CLASS) = 'FlowField') THEN
                            FldRef.CALCFIELD();

                        CASE FORMAT(FldRef.TYPE) OF
                            'Boolean':
                                BEGIN
                                    //>>FE_ProdConnect.003
                                    BooLtest := FldRef.VALUE;
                                    //IF FldRef.VALUE THEN
                                    IF BooLtest THEN
                                        //<<FE_ProdConnect.003
                                        BigTLBigTextToReturn.ADDTEXT('TRUE ')
                                    ELSE
                                        BigTLBigTextToReturn.ADDTEXT('FALSE');
                                END;

                            'Date':
                                BigTLBigTextToReturn.ADDTEXT(FORMAT(FldRef.VALUE, 0, '<day,2><month,2><year4>'));

                            'DateTime':
                                BigTLBigTextToReturn.ADDTEXT(FORMAT(FldRef.VALUE, 0, '<day,2><month,2><year4>'));

                            'Decimal':
                                BEGIN
                                    TxtLValue := PADSTR(FtcRemoveChar(FctNormalizeDecimal(FORMAT(FldRef.VALUE))), RecLFieldsExportSetup."File Length");
                                    //TxtLValue := PADSTR(FctNormalizeDecimal(FORMAT(FldRef.VALUE)),RecLFieldsExportSetup."File Length");
                                    BigTLBigTextToReturn.ADDTEXT(FtcRemoveChar(TxtLValue));
                                    //BigTLBigTextToReturn.ADDTEXT(TxtLValue);
                                END;

                            'Integer':
                                BEGIN
                                    TxtLValue := PADSTR(FtcRemoveChar(FctNormalizeDecimal(FORMAT(FldRef.VALUE))), RecLFieldsExportSetup."File Length");
                                    BigTLBigTextToReturn.ADDTEXT(TxtLValue);
                                END;


                            ELSE BEGIN
                                    TxtLValue := DELCHR(FORMAT(FldRef.VALUE), '=', FORMAT(FORMAT(ChrL13)));
                                    TxtLValue := DELCHR(TxtLValue, '=', FORMAT(FORMAT(ChrL10)));
                                    BigTLBigTextToReturn.ADDTEXT(PADSTR(TxtLValue, RecLFieldsExportSetup."File Length"));
                                END;
                        END;

                    UNTIL RecLFieldsExportSetup.NEXT() = 0;
                END;
                BigTLBigTextToReturn.ADDTEXT(FORMAT(ChrL13) + FORMAT(ChrL10));
            UNTIL RecLRecRef.NEXT() = 0;
        END;

        RecLRecRef.CLOSE();

        TempBlob.CREATEOUTSTREAM(OusLStream);
        BigTLBigTextToReturn.WRITE(OusLStream);
    end;
}

