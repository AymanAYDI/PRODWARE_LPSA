codeunit 8073291 "PWD Buffer Management"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect.1.00
    // FE_ProdConnect.001:GR 22/03/2011  Connector integration
    //                                   - Create Object
    // 
    // //>>ProdConnect1.50
    // WMS-FEMOT.001:GR 29/06/2011  Connector management
    //                                   - Add Buffer management :
    //                                         FctNewBufferLine
    //                                         FctDeleteBufferLine
    //                                         FctDuplicateBuffer
    //                                         FctUpdateBufferLineProcessed
    //                                         FctCheckBufferLine
    //                                         FctNextLineNo
    //                                         FctProcessSalesOrder
    //                                         FctCreateSalesOrder
    //                                         FctUpdateSalesOrder
    //                                         FctDeleteSalesOrder
    //                                         FctShowSalesOrder
    //                                         FctPurgeSalesHeaderBuffer
    //                                         FctProcessCustomer
    //                                         FctCreateCustomer
    //                                         FctUpdateCustomer
    //                                         FctDeleteCustomer
    //                                         FctShowCustomer
    //                                         FctPurgeCustomerBuffer
    //                                         FctCreateBufferValues2
    // 
    // WMS-FE009.001:GR 05/07/2011 Stock  - Add Functions :
    //                                         FctProcessItemJournaLine
    //                                         FctCreateItemJournaLine
    //                                         FctUpdateItemJournaLine
    //                                         FctDeleteItemJournaLine
    //                                         FctShowItemJournaLine
    //                                         FctPurgeItemJournaLine
    // 
    // 
    // WMS-FE007_15.001:GR 05/07/2011 Receipt
    //                                   - Add Receipt management
    //                                         FctProcessReceiptLine
    //                                         FctUpdateReceiptLine
    //                                         FctShowReceiptLine
    //                                         FctPurgeReceiptLineBuffer
    // 
    // WMS-FE008_15.001:GR 19/07/2011 Shipment
    //                                   - Add function
    //                                         FctProcessShipmentLine
    //                                         FctUpdateShipmentLine
    //                                         FctShowShipmentLine
    //                                         FctPurgeShipmentLine
    // 
    // //>>ProdConnect1.6.1
    // OSYS-Int001.001:GR 09/12/2011   Connector integration
    //                                   - Update
    //                                     FctCreateItemJournaLine
    //                                     FctUpdateItemJournaLine
    //                                     FctShowItemJournaLine
    //                                   - Add Functions :
    //                                     FctValidateItemJournaLine
    //                                     FctInitItemJnlLineTempBuffer
    //                                     FctInsertItemJnlLineTempBuffer
    //                                     FctValidateMultiItemJournaLine
    //                                     FctCanPost
    // 
    // //>>ProdConnect1.07
    // WMS-EBL1-003.001:GR 13/12/2011  Connector management
    //                                 - Modification in FctUpdateReceiptLine function
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_PROD02.001: NI 06/12/2011:  Commentaire sur feuille production
    //                                           - C/AL added in functions FctCreateItemJournaLine
    //                                                                     FctUpdateItemJournaLine
    // 
    // //>>LAP2.01
    // FE_LAPIERRETTE_PROD11.001: GR 16/02/2012: Conform Quality Control
    //                                           Modify Function
    //                                            FctCreateItemJournaLine
    //                                            FctUpdateItemJournaLine
    // 
    // //>>LAP2.06
    // FE_LAPRIERRETTE_GP0004.001 :GR  23/05/13  :Modify Function : FctCreateItemJournaLine
    // 
    // 
    // //>>LAP2.22
    // P24578_009: RO : 12/12/2019 : cf Demande par mail
    //                   -Add C\AL Code in triggers FctCreateItemJournaLine
    //                                              FctUpdateItemJournaLine
    // 
    // 
    // 
    // 
    // +----------------------------------------------------------------------------------------------------------------------------------+

    TableNo = Object;

    trigger OnRun()
    var
        RecLCustomerBuffer: Record "PWD Customer Buffer";
        RecLItemJournalLineBuffer: Record "PWD Item Jounal Line Buffer";
        RecLReceiptLineBuffer: Record "PWD Receipt Line Buffer";
        RecLSalesHeaderBuffer: Record "PWD Sales Header Buffer";
        RecLSalesLineBuffer: Record "PWD Sales Line Buffer";
    begin
        BooGHideDialog := TRUE;

        CASE ID OF
            DATABASE::"PWD Receipt Line Buffer":
                BEGIN
                    RecLReceiptLineBuffer.GET("DBM Table No.");
                    FctProcessReceiptLine(RecLReceiptLineBuffer);
                END;
            DATABASE::"PWD Customer Buffer":
                BEGIN
                    RecLCustomerBuffer.GET("DBM Table No.");
                    FctProcessCustomer(RecLCustomerBuffer);
                END;
            DATABASE::"PWD Sales Header Buffer":
                BEGIN
                    RecLSalesHeaderBuffer.GET("DBM Table No.");
                    FctProcessSalesOrder(RecLSalesHeaderBuffer);
                END;
            DATABASE::"PWD Item Jounal Line Buffer":
                BEGIN
                    RecLItemJournalLineBuffer.GET("DBM Table No.");
                    FctProcessItemJournaLine(RecLItemJournalLineBuffer);
                END;
            DATABASE::"PWD Sales Line Buffer":
                BEGIN
                    RecLSalesLineBuffer.GET("DBM Table No.");
                    FctProcessShipmentLine(RecLSalesLineBuffer);
                END;

        END;
    end;

    var
        RecGItemJnlLineTempBufferPost: Record "PWD Item Jounal Line Buffer" temporary;
        CduGFileManagement: Codeunit "PWD File Management";
        BooGCanPost: Boolean;
        BooGHideDialog: Boolean;
        CstG001: Label 'This buffer line is skipped.';
        CstG002: Label 'Are you sure to process this line ?';
        CstG003: Label 'Are you sure to delete the selected line ?';
        CstG004: Label 'This action isn''t allowed for this buffer.';
        CstG005: Label 'The buffer''s field %1 isn''t the same of the actual document. ';
        CstG006: Label 'Are you sure to process the selected lines ?';
        CstG007: Label 'Shipment is waiting on this order.';
        CstG008: Label 'Recept is waiting on this order.';

    procedure FctCreateBufferValues(var InsPStream: InStream; CodPPartnerCode: Code[20]; TxtPFileName: Text[250]; CodPFunction: Code[30]; OptPFilFormat: Option Xml,"with separator","File Position"; TxtPSeparator: Text[1]; OptPDirection: Option Import,Export; IntPLinkedEntryNo: Integer; CodPMEssageCode: Code[20]): Integer
    var
        RecLConnectorValues: Record "PWD Connector Values";
        RecLPartner: Record "PWD Partner Connector";
        OusLstream: OutStream;
    begin
        //**********************************************************************************************************//
        //                                  Insert Value in Buffer table                                            //
        //**********************************************************************************************************//

        RecLPartner.GET(CodPPartnerCode);
        RecLConnectorValues.INIT();
        RecLConnectorValues."Entry No." := FctEntryNoForBufferTable();
        RecLConnectorValues."Partner Code" := CodPPartnerCode;
        RecLConnectorValues."File Name" := TxtPFileName;
        RecLConnectorValues."Function" := CodPFunction;
        RecLConnectorValues.Direction := OptPDirection;
        RecLConnectorValues."File format" := OptPFilFormat;
        IF OptPFilFormat = OptPFilFormat::"with separator" THEN
            RecLConnectorValues.Separator := TxtPSeparator;
        IF IntPLinkedEntryNo <> 0 THEN
            RecLConnectorValues."Linked Entry No." := IntPLinkedEntryNo
        ELSE
            RecLConnectorValues."Linked Entry No." := RecLConnectorValues."Entry No.";
        RecLConnectorValues."Message Code" := CodPMEssageCode;
        RecLConnectorValues.Blob.CREATEOUTSTREAM(OusLstream);
        COPYSTREAM(OusLstream, InsPStream);
        RecLConnectorValues."Communication Mode" := RecLPartner."Communication Mode";
        RecLConnectorValues.INSERT();
        EXIT(RecLConnectorValues."Entry No.");
    end;

    procedure FctArchiveBufferValues(var RecPConnectorValues: Record "PWD Connector Values"; BooPSucces: Boolean)
    var
        RecLSendingMessage: Record "PWD Connector Messages";
        RecLConnectorValuesArc: Record "PWD Connector Values Archive";
    begin
        //**********************************************************************************************************//
        //                                  Remove Connector Value buffer (Archive in optional case)                //
        //**********************************************************************************************************//
        RecLSendingMessage.RESET();
        RecLSendingMessage.SETRANGE("Partner Code", RecPConnectorValues."Partner Code");
        RecLSendingMessage.SETRANGE("Function", RecPConnectorValues."Function");
        IF NOT RecLSendingMessage.ISEMPTY THEN BEGIN
            RecLSendingMessage.FINDFIRST();
            IF RecLSendingMessage."Archive Message" THEN BEGIN
                RecLConnectorValuesArc.INIT();
                RecPConnectorValues.CALCFIELDS(Blob);
                RecLConnectorValuesArc.TRANSFERFIELDS(RecPConnectorValues);
                RecLConnectorValuesArc.Succes := BooPSucces;
                RecLConnectorValuesArc.INSERT(TRUE);
            END;
        END
        ELSE BEGIN
            RecLSendingMessage.RESET();
            RecLSendingMessage.SETRANGE("Partner Code", RecPConnectorValues."Partner Code");
            RecLSendingMessage.SETRANGE(Code, RecPConnectorValues."Message Code");
            IF NOT RecLSendingMessage.ISEMPTY THEN BEGIN
                RecLSendingMessage.FINDFIRST();
                IF RecLSendingMessage."Archive Message" THEN BEGIN
                    RecLConnectorValuesArc.INIT();
                    RecPConnectorValues.CALCFIELDS(Blob);
                    RecLConnectorValuesArc.TRANSFERFIELDS(RecPConnectorValues);
                    RecLConnectorValuesArc.Succes := BooPSucces;
                    RecLConnectorValuesArc.INSERT(TRUE);
                END;
            END
        END;
        RecPConnectorValues.DELETE(TRUE);
    end;

    procedure FctEntryNoForBufferTable(): Integer
    var
        RecLConnectorValues: Record "PWD Connector Values";
        RecLConnectValueArch: Record "PWD Connector Values Archive";
        IntLEntryNo: Integer;
    begin
        //**********************************************************************************************************//
        //                                  Find the new sequence No. in Buffer Table                               //
        //**********************************************************************************************************//

        IntLEntryNo := 0;
        RecLConnectorValues.RESET();
        IF RecLConnectorValues.FINDLAST() THEN
            IntLEntryNo := RecLConnectorValues."Entry No.";
        RecLConnectValueArch.RESET();
        IF RecLConnectValueArch.FINDLAST() THEN
            IF (IntLEntryNo < RecLConnectValueArch."Entry No.") THEN
                IntLEntryNo := RecLConnectValueArch."Entry No.";
        EXIT(IntLEntryNo + 1);
    end;

    procedure "---WMS-FEMOT.001--"()
    begin
    end;

    procedure FctNewBufferLine(IntPTable: Integer; RecPConnectorVal: Record "PWD Connector Values"; OptPStatus: Option Skip,Insert,Modify,Delete) IntRKey: Integer
    var
        RecordRef: RecordRef;
        RecordRef2: RecordRef;
        FieldRef: FieldRef;
        FieldRef2: FieldRef;
        IntLEntryNo: Integer;
    begin
        //>>WMS-FEMOT.001
        RecordRef.OPEN(IntPTable, FALSE, COMPANYNAME);
        RecordRef.INIT();

        RecordRef2.OPEN(RecordRef.NUMBER, FALSE, COMPANYNAME);
        IF RecordRef2.FINDLAST() THEN BEGIN
            FieldRef2 := RecordRef2.FIELD(1);
            FieldRef := RecordRef.FIELD(1);
            EVALUATE(IntLEntryNo, FORMAT(FieldRef2.VALUE));
            FieldRef.VALUE := IntLEntryNo + 1;
        END ELSE BEGIN
            FieldRef := RecordRef.FIELD(1);
            FieldRef.VALUE := 1;
        END;

        EVALUATE(IntRKey, FORMAT(FieldRef.VALUE));

        FieldRef := RecordRef.FIELD(10);
        FieldRef.VALUE := RecPConnectorVal."Entry No.";

        FieldRef := RecordRef.FIELD(11);
        FieldRef.VALUE := RecPConnectorVal."Partner Code";

        FieldRef := RecordRef.FIELD(12);
        FieldRef.VALUE := RecPConnectorVal."Message Code";

        FieldRef := RecordRef.FIELD(17);
        FieldRef.VALUE := OptPStatus;

        FieldRef := RecordRef.FIELD(19);
        FieldRef.VALUE := CURRENTDATETIME;

        RecordRef.INSERT();
        //<<WMS-FEMOT.001
    end;

    procedure FctNewBufferLine2(var RefPRecordRef: RecordRef; RecPConnectorVal: Record "PWD Connector Values"; OptPStatus: Option Skip,Insert,Modify,Delete) IntRKey: Integer
    var
        RecordRef2: RecordRef;
        FieldRef: FieldRef;
        FieldRef2: FieldRef;
        IntLEntryNo: Integer;
    begin
        //>>WMS-FEMOT.001

        RefPRecordRef.INIT();

        RecordRef2.OPEN(RefPRecordRef.NUMBER, FALSE, COMPANYNAME);
        IF RecordRef2.FINDLAST() THEN BEGIN
            FieldRef2 := RecordRef2.FIELD(1);
            FieldRef := RefPRecordRef.FIELD(1);
            EVALUATE(IntLEntryNo, FORMAT(FieldRef2.VALUE));
            FieldRef.VALUE := IntLEntryNo + 1;
        END ELSE BEGIN
            FieldRef := RefPRecordRef.FIELD(1);
            FieldRef.VALUE := 1;
        END;

        EVALUATE(IntRKey, FORMAT(FieldRef.VALUE));

        FieldRef := RefPRecordRef.FIELD(10);
        FieldRef.VALUE := RecPConnectorVal."Entry No.";

        FieldRef := RefPRecordRef.FIELD(11);
        FieldRef.VALUE := RecPConnectorVal."Partner Code";

        FieldRef := RefPRecordRef.FIELD(12);
        FieldRef.VALUE := RecPConnectorVal."Message Code";

        FieldRef := RefPRecordRef.FIELD(17);
        FieldRef.VALUE := OptPStatus;

        FieldRef := RefPRecordRef.FIELD(19);
        FieldRef.VALUE := CURRENTDATETIME;


        //<<WMS-FEMOT.001
    end;

    procedure FctDeleteBufferLine(IntPTable: Integer; IntPEntryNo: Integer)
    var
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        //>>WMS-FEMOT.001
        RecordRef.OPEN(IntPTable, FALSE, COMPANYNAME);
        FieldRef := RecordRef.FIELD(1);
        FieldRef.SETRANGE(IntPEntryNo);
        IF RecordRef.FINDFIRST() THEN
            RecordRef.DELETE(TRUE);
        //<<WMS-FEMOT.001
    end;

    procedure FctDuplicateBuffer(IntPTable: Integer; RecordRef2: RecordRef) IntRKey: Integer
    var
        RecordRef: RecordRef;
        FieldRef: FieldRef;
        FieldRef2: FieldRef;
    begin
        //>>WMS-FEMOT.001
        RecordRef.OPEN(IntPTable, FALSE, COMPANYNAME);
        RecordRef.INIT();

        FieldRef2 := RecordRef2.FIELD(1);
        FieldRef := RecordRef.FIELD(1);
        FieldRef.VALUE := FieldRef2.VALUE;

        EVALUATE(IntRKey, FORMAT(FieldRef.VALUE));

        RecordRef.INSERT();
        //<<WMS-FEMOT.001
    end;

    procedure FctUpdateBufferLineProcessed(var RecordRef: RecordRef; OptPStatus: Option ,Inserted,Modified,Deleted; RecordId: RecordID) IntRKey: Integer
    var
        FieldRef: FieldRef;
    begin
        //>>WMS-FEMOT.001
        FieldRef := RecordRef.FIELD(13);
        FieldRef.VALUE := OptPStatus;

        FieldRef := RecordRef.FIELD(14);
        FieldRef.VALUE := TRUE;

        FieldRef := RecordRef.FIELD(15);
        FieldRef.VALUE := CURRENTDATETIME;

        FieldRef := RecordRef.FIELD(18);
        FieldRef.VALUE := RecordId;

        FieldRef := RecordRef.FIELD(16);
        FieldRef.VALUE := '';

        RecordRef.MODIFY();
        //<<WMS-FEMOT.001
    end;

    procedure FctCheckBufferLine(var RecordRef: RecordRef) IntRKey: Integer
    var
        FieldRef: FieldRef;
    begin
        //>>WMS-FEMOT.001
        FieldRef := RecordRef.FIELD(17);
        IF FORMAT(FieldRef.VALUE) = '0' THEN
            ERROR(CstG001);
        //<<WMS-FEMOT.001
    end;

    procedure FctNextLineNo(CodPDocNo: Code[20]): Integer
    var
        RecLSalesLine: Record "Sales Line";
    begin
        //>>WMS-FEMOT.001
        //**********************************************************************************************************//
        //                                    Find the next line No. for an order                                   //
        //**********************************************************************************************************//

        RecLSalesLine.RESET();
        RecLSalesLine.SETRANGE("Document Type", RecLSalesLine."Document Type"::Order);
        RecLSalesLine.SETRANGE("Document No.", CodPDocNo);
        IF RecLSalesLine.FINDLAST() THEN
            EXIT(RecLSalesLine."Line No." + 10000)
        ELSE
            EXIT(10000);
        //<<WMS-FEMOT.001
    end;

    procedure FctGetFieldCaption(IntPTable: Integer; IntPFieldNumber: Integer): Text[100]
    var
        "Field": Record "Field";
    begin
        //>>WMS-FEMOT.001
        Field.GET(IntPTable, IntPFieldNumber);
        EXIT(Field."Field Caption");
        //<<WMS-FEMOT.001
    end;

    procedure FctGetCaptionClass(IntPTable: Integer; IntPFieldNumber: Integer): Text[80]
    begin
        //>>WMS-FEMOT.001
        EXIT('3,' + FctGetFieldCaption(IntPTable, IntPFieldNumber));
        //<<WMS-FEMOT.001
    end;

    procedure FctTransformErrorToBlob(var Fieldref: FieldRef)
    var
        RecLTempBlob: Codeunit "Temp Blob";
        OuSLOutStream: OutStream;
    begin
        //>>WMS-FE007_15.001
        Fieldref.CALCFIELD();
        RecLTempBlob.FromFieldRef(Fieldref);
        CLEAR(RecLTempBlob);

        RecLTempBlob.CREATEOUTSTREAM(OuSLOutStream);
        OuSLOutStream.WRITETEXT(GETLASTERRORTEXT);
        Fieldref.VALUE := RecLTempBlob.HasValue();
        //<<WMS-FE007_15.001
    end;

    procedure FctReadBlob(var RecordRef: RecordRef)
    var
        CduLFileManagement: Codeunit "PWD File Management";
        RecLTempBlob: Codeunit "Temp Blob";
        Fieldref: FieldRef;
        InsLStream: InStream;
    begin
        //>>WMS-FE007_15.001
        Fieldref := RecordRef.FIELD(9);
        Fieldref.CALCFIELD();
        RecLTempBlob.FromFieldRef(Fieldref);
        IF RecLTempBlob.HASVALUE() THEN BEGIN
            RecLTempBlob.CREATEINSTREAM(InsLStream);
            CduLFileManagement.FctShowBlobAsWindow(InsLStream)
        END;
        //<<WMS-FE007_15.001
    end;

    procedure FctMultiProcessLine(var Rec: RecordRef)
    var
        RecLObject: Record "Object";
        FieldRef: FieldRef;
        FieldRefKey: FieldRef;
        DiaLWin: Dialog;
        IntLLine: Integer;
        IntLTotal: Integer;
    begin
        //>>WMS-FE007_15.001

        //>>WMS-EBL1-003.001.001
        IF GUIALLOWED AND NOT BooGHideDialog THEN
            //<<WMS-EBL1-003.001.001

            IF NOT CONFIRM(CstG006) THEN
                EXIT;

        //>>OSYS-Int001.001
        FctInitItemJnlLineTempBuffer();
        //<<OSYS-Int001.001
        IF NOT Rec.ISEMPTY THEN BEGIN
            IntLTotal := Rec.COUNT;
            IntLLine := 1;
            //>>WMS-EBL1-003.001.001
            IF GUIALLOWED THEN
                //<<WMS-EBL1-003.001.001

                DiaLWin.OPEN('@@@@@@@@@@@@@@1@@@@@@@@@@@@@@');

            Rec.FINDSET();
            REPEAT
                IF GUIALLOWED THEN
                    DiaLWin.UPDATE(1, ROUND(IntLLine / IntLTotal * 10000, 1));

                RecLObject.INIT();
                RecLObject.ID := Rec.NUMBER;
                FieldRefKey := Rec.FIELD(1);
                EVALUATE(RecLObject."DBM Table No.", FORMAT(FieldRefKey.VALUE));
                COMMIT();
                IF NOT CODEUNIT.RUN(Codeunit::"PWD Buffer Management", RecLObject) THEN BEGIN
                    FieldRef := Rec.FIELD(16);
                    FieldRef.VALUE := COPYSTR(GETLASTERRORTEXT, 1, 250);
                    FieldRef := Rec.FIELD(9);
                    FctTransformErrorToBlob(FieldRef);
                    Rec.MODIFY();
                    CLEARLASTERROR();
                END

                //>>OSYS-Int001.001
                ELSE
                    FctInsertItemJnlLineTempBuffer(Rec);
                //<<OSYS-Int001.001

                IntLLine += 1;
            UNTIL Rec.NEXT() = 0;

            //>>WMS-EBL1-003.001.001
            IF GUIALLOWED THEN
                //<<WMS-EBL1-003.001.001
                DiaLWin.CLOSE();
        END;
        //<<WMS-FE007_15.001
    end;

    procedure FctProcessSalesOrder(var Rec: Record "PWD Sales Header Buffer")
    begin
        //>>WMS-FEMOT.001
        //>>WMS-EBL1-003.001.001
        IF GUIALLOWED THEN
            //<<WMS-EBL1-003.001.001

            IF NOT BooGHideDialog THEN
                IF NOT CONFIRM(CstG002) THEN
                    EXIT;

        CASE Rec.Action OF
            Rec.Action::Skip:
                ERROR(CstG001);
            Rec.Action::Insert:
                FctCreateSalesOrder(Rec);
            Rec.Action::Modify:
                FctUpdateSalesOrder(Rec);
            Rec.Action::Delete:
                FctDeleteSalesOrder(Rec);
        END;
        //<<WMS-FEMOT.001
    end;

    procedure FctCreateSalesOrder(var RecPSalesHeaderBuffer: Record "PWD Sales Header Buffer")
    var
        RecLSalesCommentLineBuffer: Record "PWD Sales Comment Line Buffer";
        RecLSalesLineBuffer: Record "PWD Sales Line Buffer";
        RecLSalesSetup: Record "Sales & Receivables Setup";
        RecLSalesCommentLine: Record "Sales Comment Line";
        RecLSalesHeader: Record "Sales Header";
        RecLSalesLine: Record "Sales Line";
        RecLTempVATAmountLine0: Record "VAT Amount Line" temporary;
        RecLTempVATAmountLine1: Record "VAT Amount Line" temporary;
        CduLConnectorPebParseData: Codeunit "PWD Connector Peb Parse Data";
        RecordRef: RecordRef;
        RecordRefBuf: RecordRef;
        IntLLineNo: Integer;
    begin
        //>>WMS-FEMOT.001
        RecLSalesHeader.INIT();
        RecLSalesHeader."Document Type" := RecLSalesHeader."Document Type"::Order;
        RecLSalesHeader."No." := '';
        RecLSalesHeader.INSERT(TRUE);

        RecordRefBuf.GETTABLE(RecPSalesHeaderBuffer);
        RecordRef.GETTABLE(RecLSalesHeader);
        FctCheckBufferLine(RecordRefBuf);
        FctUpdateBufferLineProcessed(RecordRefBuf, 1, RecordRef.RECORDID);
        RecPSalesHeaderBuffer.GET(RecPSalesHeaderBuffer."Entry No.");

        RecLSalesHeader.VALIDATE("Sell-to Customer No.", COPYSTR(RecPSalesHeaderBuffer."Sell-to Customer No.", 1, 20));
        EVALUATE(RecLSalesHeader."Posting Date", RecPSalesHeaderBuffer."Posting Date");
        RecLSalesHeader.VALIDATE("Posting Date");
        RecLSalesHeader."External Document No." := COPYSTR(RecPSalesHeaderBuffer."External Document No.", 1, 20);
        RecLSalesHeader."PWD Order No. From Partner" := COPYSTR(RecPSalesHeaderBuffer."Document No.", 1, 20);

        //Spécifiques PEB
        CduLConnectorPebParseData.FctUpdateSalesHeader(RecLSalesHeader, RecPSalesHeaderBuffer."Entry No.");

        RecLSalesHeader.MODIFY(TRUE);

        IntLLineNo := 10000;
        RecLSalesCommentLineBuffer.SETCURRENTKEY("Document Type", "Document No.", "Document Line No.");
        RecLSalesCommentLineBuffer.SETRANGE("Document Type", RecPSalesHeaderBuffer."Document Type");
        RecLSalesCommentLineBuffer.SETRANGE("Document No.", RecPSalesHeaderBuffer."Document No.");
        RecLSalesCommentLineBuffer.SETRANGE("Document Line No.", 0);
        IF NOT RecLSalesCommentLineBuffer.ISEMPTY THEN BEGIN
            RecLSalesCommentLineBuffer.FINDSET();
            REPEAT
                RecordRefBuf.GETTABLE(RecLSalesCommentLineBuffer);
                FctCheckBufferLine(RecordRefBuf);

                RecLSalesCommentLine.INIT();
                RecLSalesCommentLine."Document Type" := "Sales Comment Document Type".FromInteger(RecPSalesHeaderBuffer."Document Type");
                RecLSalesCommentLine."No." := RecLSalesHeader."No.";
                RecLSalesCommentLine."Line No." := IntLLineNo;
                RecLSalesCommentLine."Document Line No." := 0;
                EVALUATE(RecLSalesCommentLine.Date, RecLSalesCommentLineBuffer.Date);
                RecLSalesCommentLine.VALIDATE(Date);
                RecLSalesCommentLine.Comment := RecLSalesCommentLineBuffer.Comment;
                //Spécifiques PEB
                CduLConnectorPebParseData.FctUpdateSalesCommentLine(RecLSalesCommentLine, RecLSalesCommentLineBuffer."Entry No.");

                RecLSalesCommentLine.INSERT(TRUE);

                RecordRef.GETTABLE(RecLSalesCommentLine);
                FctUpdateBufferLineProcessed(RecordRefBuf, 1, RecordRef.RECORDID);

                IntLLineNo := 10000;
            UNTIL RecLSalesCommentLineBuffer.NEXT() = 0;
        END;

        RecLSalesLineBuffer.SETCURRENTKEY("Document Type", "Document No.");
        RecLSalesLineBuffer.SETRANGE("Document Type", RecPSalesHeaderBuffer."Document Type");
        RecLSalesLineBuffer.SETRANGE("Document No.", RecPSalesHeaderBuffer."Document No.");
        IF NOT RecLSalesLineBuffer.ISEMPTY THEN BEGIN
            RecLSalesLineBuffer.FINDSET();
            REPEAT
                RecordRefBuf.GETTABLE(RecLSalesLineBuffer);
                FctCheckBufferLine(RecordRefBuf);

                RecLSalesLine.INIT();
                RecLSalesLine.VALIDATE("Document Type", RecLSalesLine."Document Type"::Order);
                RecLSalesLine.VALIDATE("Document No.", RecLSalesHeader."No.");
                RecLSalesLine."Line No." := FctNextLineNo(RecLSalesHeader."No.");
                RecLSalesLine.INSERT(TRUE);

                RecordRef.GETTABLE(RecLSalesLine);
                FctUpdateBufferLineProcessed(RecordRefBuf, 1, RecordRef.RECORDID);

                RecLSalesLine.Type := "Sales Line Type".FromInteger(RecLSalesLineBuffer.Type);
                RecLSalesLine.VALIDATE("No.", COPYSTR(RecLSalesLineBuffer."No.", 1, 20));
                EVALUATE(RecLSalesLine."Unit Price", RecLSalesLineBuffer."Unit Price");
                RecLSalesLine.VALIDATE("Unit Price");
                EVALUATE(RecLSalesLine.Quantity, RecLSalesLineBuffer.Quantity);
                RecLSalesLine.VALIDATE(Quantity);
                IF RecLSalesLineBuffer."Line Amount" <> '' THEN BEGIN
                    EVALUATE(RecLSalesLine."Line Amount", RecLSalesLineBuffer."Line Amount");
                    RecLSalesLine.VALIDATE("Line Amount");
                END;
                //Spécifiques PEB
                CduLConnectorPebParseData.FctUpdateSalesLine(RecLSalesLine, RecLSalesLineBuffer."Entry No.");

                RecLSalesLine.MODIFY(TRUE);

                IntLLineNo := 10000;
                RecLSalesCommentLineBuffer.SETCURRENTKEY("Document Type", "Document No.", "Document Line No.");
                RecLSalesCommentLineBuffer.SETRANGE("Document Type", RecLSalesLineBuffer."Document Type");
                RecLSalesCommentLineBuffer.SETRANGE("Document No.", RecLSalesLineBuffer."Document No.");
                RecLSalesCommentLineBuffer.SETRANGE("Document Line No.", RecLSalesLineBuffer."Entry No.");
                IF NOT RecLSalesCommentLineBuffer.ISEMPTY THEN BEGIN
                    RecLSalesCommentLineBuffer.FINDSET();
                    REPEAT
                        RecordRefBuf.GETTABLE(RecLSalesCommentLineBuffer);
                        FctCheckBufferLine(RecordRefBuf);

                        RecLSalesCommentLine.INIT();
                        RecLSalesCommentLine."Document Type" := "Sales Comment Document Type".FromInteger(RecPSalesHeaderBuffer."Document Type");
                        RecLSalesCommentLine."No." := RecLSalesLine."Document No.";
                        RecLSalesCommentLine."Line No." := IntLLineNo;
                        RecLSalesCommentLine."Document Line No." := RecLSalesLine."Line No.";
                        EVALUATE(RecLSalesCommentLine.Date, RecLSalesCommentLineBuffer.Date);
                        RecLSalesCommentLine.VALIDATE(Date);
                        RecLSalesCommentLine.Comment := RecLSalesCommentLineBuffer.Comment;
                        //Spécifiques PEB
                        CduLConnectorPebParseData.FctUpdateSalesCommentLine(RecLSalesCommentLine, RecLSalesCommentLineBuffer."Entry No.");

                        RecLSalesCommentLine.INSERT(TRUE);

                        RecordRef.GETTABLE(RecLSalesCommentLine);
                        FctUpdateBufferLineProcessed(RecordRefBuf, 1, RecordRef.RECORDID);

                        IntLLineNo := 10000;
                    UNTIL RecLSalesCommentLineBuffer.NEXT() = 0;
                END;
            UNTIL RecLSalesLineBuffer.NEXT() = 0;
        END;

        //Calc SalesHeaderAmount
        RecLSalesHeader.GET(RecLSalesHeader."Document Type", RecLSalesHeader."No.");
        RecLSalesLine.RESET();
        RecLSalesSetup.GET();
        IF RecLSalesSetup."Calc. Inv. Discount" THEN BEGIN
            CODEUNIT.RUN(CODEUNIT::"Sales-Calc. Discount", RecLSalesLine);
            RecLSalesHeader.GET(RecLSalesHeader."Document Type", RecLSalesHeader."No.");
        END;
        RecLSalesLine.SetSalesHeader(RecLSalesHeader);
        RecLSalesLine.CalcVATAmountLines(0, RecLSalesHeader, RecLSalesLine, RecLTempVATAmountLine0);
        RecLSalesLine.CalcVATAmountLines(1, RecLSalesHeader, RecLSalesLine, RecLTempVATAmountLine1);
        RecLSalesLine.UpdateVATOnLines(0, RecLSalesHeader, RecLSalesLine, RecLTempVATAmountLine0);
        RecLSalesLine.UpdateVATOnLines(1, RecLSalesHeader, RecLSalesLine, RecLTempVATAmountLine1);
        RecLSalesHeader.MODIFY(TRUE);
        //<<WMS-FEMOT.001
    end;

    procedure FctUpdateSalesOrder(var RecPSalesHeaderBuffer: Record "PWD Sales Header Buffer")
    var
        RecLSalesCommentLineBuffer: Record "PWD Sales Comment Line Buffer";
        RecLSalesLineBuffer: Record "PWD Sales Line Buffer";
        RecLSalesSetup: Record "Sales & Receivables Setup";
        RecLSalesCommentLine: Record "Sales Comment Line";
        RecLSalesHeader: Record "Sales Header";
        RecLSalesLine: Record "Sales Line";
        RecLTempVATAmountLine0: Record "VAT Amount Line" temporary;
        RecLTempVATAmountLine1: Record "VAT Amount Line" temporary;
        CduLConnectorPebParseData: Codeunit "PWD Connector Peb Parse Data";
        RecordRef: RecordRef;
        RecordRefBuf: RecordRef;
        IntLLineNo: Integer;
    begin
        //>>WMS-FEMOT.001
        RecordRef.OPEN(DATABASE::"Sales Header", FALSE, COMPANYNAME);
        RecordRef.GET(RecPSalesHeaderBuffer."RecordID Created");
        RecordRef.SETTABLE(RecLSalesHeader);

        RecordRefBuf.GETTABLE(RecPSalesHeaderBuffer);
        FctCheckBufferLine(RecordRefBuf);
        FctUpdateBufferLineProcessed(RecordRefBuf, 2, RecordRef.RECORDID);
        RecPSalesHeaderBuffer.GET(RecPSalesHeaderBuffer."Entry No.");

        RecLSalesHeader.VALIDATE("Sell-to Customer No.", COPYSTR(RecPSalesHeaderBuffer."Sell-to Customer No.", 1, 20));
        EVALUATE(RecLSalesHeader."Posting Date", RecPSalesHeaderBuffer."Posting Date");
        RecLSalesHeader.VALIDATE("Posting Date");
        RecLSalesHeader."External Document No." := COPYSTR(RecPSalesHeaderBuffer."External Document No.", 1, 20);
        RecLSalesHeader."PWD Order No. From Partner" := COPYSTR(RecPSalesHeaderBuffer."Document No.", 1, 20);

        //Spécifiques PEB
        CduLConnectorPebParseData.FctUpdateSalesHeader(RecLSalesHeader, RecPSalesHeaderBuffer."Entry No.");

        RecLSalesHeader.MODIFY(TRUE);

        IntLLineNo := 10000;
        RecLSalesCommentLineBuffer.SETCURRENTKEY("Document Type", "Document No.", "Document Line No.");
        RecLSalesCommentLineBuffer.SETRANGE("Document Type", RecPSalesHeaderBuffer."Document Type");
        RecLSalesCommentLineBuffer.SETRANGE("Document No.", RecPSalesHeaderBuffer."Document No.");
        RecLSalesCommentLineBuffer.SETRANGE("Document Line No.", 0);
        IF NOT RecLSalesCommentLineBuffer.ISEMPTY THEN BEGIN
            RecLSalesCommentLineBuffer.FINDSET();
            REPEAT
                RecordRefBuf.GETTABLE(RecLSalesCommentLineBuffer);
                FctCheckBufferLine(RecordRefBuf);

                CLEAR(RecordRef);
                RecordRef.OPEN(DATABASE::"Sales Comment Line", FALSE, COMPANYNAME);
                RecordRef.GET(RecLSalesCommentLineBuffer."RecordID Created");
                RecordRef.SETTABLE(RecLSalesCommentLine);

                RecLSalesCommentLine."Document Type" := "Sales Comment Document Type".FromInteger(RecPSalesHeaderBuffer."Document Type");
                RecLSalesCommentLine."No." := RecLSalesHeader."No.";
                RecLSalesCommentLine."Line No." := IntLLineNo;
                RecLSalesCommentLine."Document Line No." := 0;
                EVALUATE(RecLSalesCommentLine.Date, RecLSalesCommentLineBuffer.Date);
                RecLSalesCommentLine.VALIDATE(Date);
                RecLSalesCommentLine.Comment := RecLSalesCommentLineBuffer.Comment;
                //Spécifiques PEB
                CduLConnectorPebParseData.FctUpdateSalesCommentLine(RecLSalesCommentLine, RecLSalesCommentLineBuffer."Entry No.");

                RecLSalesCommentLine.MODIFY(TRUE);

                RecordRef.GETTABLE(RecLSalesCommentLine);
                FctUpdateBufferLineProcessed(RecordRefBuf, 2, RecordRef.RECORDID);

                IntLLineNo := 10000;
            UNTIL RecLSalesCommentLineBuffer.NEXT() = 0;
        END;

        RecLSalesLineBuffer.SETCURRENTKEY("Document Type", "Document No.");
        RecLSalesLineBuffer.SETRANGE("Document Type", RecPSalesHeaderBuffer."Document Type");
        RecLSalesLineBuffer.SETRANGE("Document No.", RecPSalesHeaderBuffer."Document No.");
        IF NOT RecLSalesLineBuffer.ISEMPTY THEN BEGIN
            RecLSalesLineBuffer.FINDSET();
            REPEAT
                RecordRefBuf.GETTABLE(RecLSalesLineBuffer);
                FctCheckBufferLine(RecordRefBuf);

                CLEAR(RecordRef);
                RecordRef.OPEN(DATABASE::"Sales Line", FALSE, COMPANYNAME);
                RecordRef.GET(RecLSalesLineBuffer."RecordID Created");
                RecordRef.SETTABLE(RecLSalesLine);
                FctUpdateBufferLineProcessed(RecordRefBuf, 2, RecordRef.RECORDID);

                RecLSalesLine.Type := "Sales Line Type".FromInteger(RecLSalesLineBuffer.Type);
                RecLSalesLine.VALIDATE("No.", COPYSTR(RecLSalesLineBuffer."No.", 1, 20));
                EVALUATE(RecLSalesLine."Unit Price", RecLSalesLineBuffer."Unit Price");
                RecLSalesLine.VALIDATE("Unit Price");
                EVALUATE(RecLSalesLine.Quantity, RecLSalesLineBuffer.Quantity);
                RecLSalesLine.VALIDATE(Quantity);
                IF RecLSalesLineBuffer."Line Amount" <> '' THEN BEGIN
                    EVALUATE(RecLSalesLine."Line Amount", RecLSalesLineBuffer."Line Amount");
                    RecLSalesLine.VALIDATE("Line Amount");
                END;
                //Spécifiques PEB
                CduLConnectorPebParseData.FctUpdateSalesLine(RecLSalesLine, RecLSalesLineBuffer."Entry No.");

                RecLSalesLine.MODIFY(TRUE);

                IntLLineNo := 10000;
                RecLSalesCommentLineBuffer.SETCURRENTKEY("Document Type", "Document No.", "Document Line No.");
                RecLSalesCommentLineBuffer.SETRANGE("Document Type", RecLSalesLineBuffer."Document Type");
                RecLSalesCommentLineBuffer.SETRANGE("Document No.", RecLSalesLineBuffer."Document No.");
                RecLSalesCommentLineBuffer.SETRANGE("Document Line No.", RecLSalesLineBuffer."Entry No.");
                IF NOT RecLSalesCommentLineBuffer.ISEMPTY THEN BEGIN
                    RecLSalesCommentLineBuffer.FINDSET();
                    REPEAT
                        RecordRefBuf.GETTABLE(RecLSalesCommentLineBuffer);
                        FctCheckBufferLine(RecordRefBuf);

                        CLEAR(RecordRef);
                        RecordRef.OPEN(DATABASE::"Sales Comment Line", FALSE, COMPANYNAME);
                        RecordRef.GET(RecLSalesCommentLineBuffer."RecordID Created");
                        RecordRef.SETTABLE(RecLSalesCommentLine);

                        RecLSalesCommentLine."Document Type" := "Sales Comment Document Type".FromInteger(RecPSalesHeaderBuffer."Document Type");
                        RecLSalesCommentLine."No." := RecLSalesLine."Document No.";
                        RecLSalesCommentLine."Line No." := IntLLineNo;
                        RecLSalesCommentLine."Document Line No." := RecLSalesLine."Line No.";
                        EVALUATE(RecLSalesCommentLine.Date, RecLSalesCommentLineBuffer.Date);
                        RecLSalesCommentLine.VALIDATE(Date);
                        RecLSalesCommentLine.Comment := RecLSalesCommentLineBuffer.Comment;
                        //Spécifiques PEB
                        CduLConnectorPebParseData.FctUpdateSalesCommentLine(RecLSalesCommentLine, RecLSalesCommentLineBuffer."Entry No.");

                        RecLSalesCommentLine.MODIFY(TRUE);

                        RecordRef.GETTABLE(RecLSalesCommentLine);
                        FctUpdateBufferLineProcessed(RecordRefBuf, 2, RecordRef.RECORDID);

                        IntLLineNo := 10000;
                    UNTIL RecLSalesCommentLineBuffer.NEXT() = 0;
                END;
            UNTIL RecLSalesLineBuffer.NEXT() = 0;
        END;

        //Calc SalesHeaderAmount
        RecLSalesHeader.GET(RecLSalesHeader."Document Type", RecLSalesHeader."No.");
        RecLSalesLine.RESET();
        RecLSalesSetup.GET();
        IF RecLSalesSetup."Calc. Inv. Discount" THEN BEGIN
            CODEUNIT.RUN(CODEUNIT::"Sales-Calc. Discount", RecLSalesLine);
            RecLSalesHeader.GET(RecLSalesHeader."Document Type", RecLSalesHeader."No.");
        END;
        RecLSalesLine.SetSalesHeader(RecLSalesHeader);
        RecLSalesLine.CalcVATAmountLines(0, RecLSalesHeader, RecLSalesLine, RecLTempVATAmountLine0);
        RecLSalesLine.CalcVATAmountLines(1, RecLSalesHeader, RecLSalesLine, RecLTempVATAmountLine1);
        RecLSalesLine.UpdateVATOnLines(0, RecLSalesHeader, RecLSalesLine, RecLTempVATAmountLine0);
        RecLSalesLine.UpdateVATOnLines(1, RecLSalesHeader, RecLSalesLine, RecLTempVATAmountLine1);
        RecLSalesHeader.MODIFY(TRUE);
        //<<WMS-FEMOT.001
    end;

    procedure FctDeleteSalesOrder(var RecPSalesHeaderBuffer: Record "PWD Sales Header Buffer")
    var
        RecordRef: RecordRef;
        RecordRefBuf: RecordRef;
    begin
        //>>WMS-FEMOT.001
        RecordRef.OPEN(DATABASE::"Sales Header", FALSE, COMPANYNAME);
        RecordRef.GET(RecPSalesHeaderBuffer."RecordID Created");
        RecordRefBuf.GETTABLE(RecPSalesHeaderBuffer);
        FctCheckBufferLine(RecordRefBuf);
        FctUpdateBufferLineProcessed(RecordRefBuf, 3, RecordRef.RECORDID);

        RecordRef.DELETE(TRUE);
        //<<WMS-FEMOT.001
    end;

    procedure FctShowSalesOrder(var RecPSalesHeaderBuffer: Record "PWD Sales Header Buffer")
    var
        RecLSalesHeader: Record "Sales Header";
        RecordRef: RecordRef;
    begin
        //>>WMS-FEMOT.001
        RecordRef.OPEN(DATABASE::"Sales Header", FALSE, COMPANYNAME);
        RecordRef.GET(RecPSalesHeaderBuffer."RecordID Created");
        RecordRef.SETTABLE(RecLSalesHeader);
        Page.RUN(Page::"Sales Order", RecLSalesHeader);
        //<<WMS-FEMOT.001
    end;

    procedure FctPurgeSalesHeader(var RecPSalesHeaderBuffer: Record "PWD Sales Header Buffer")
    begin
        //>>WMS-FEMOT.001

        //>>WMS-EBL1-003.001.001
        IF GUIALLOWED THEN
            //<<WMS-EBL1-003.001.001

            IF NOT BooGHideDialog THEN
                IF NOT CONFIRM(CstG003) THEN
                    ERROR('');

        RecPSalesHeaderBuffer.DELETEALL(TRUE);
        //<<WMS-FEMOT.001
    end;

    procedure FctProcessCustomer(var Rec: Record "PWD Customer Buffer")
    begin
        //>>WMS-FEMOT.001
        //>>WMS-EBL1-003.001.001
        IF GUIALLOWED THEN
            //<<WMS-EBL1-003.001.001

            IF NOT BooGHideDialog THEN
                IF NOT CONFIRM(CstG002) THEN
                    EXIT;

        CASE Rec.Action OF
            Rec.Action::Skip:
                ERROR(CstG001);
            Rec.Action::Insert:
                FctCreateCustomer(Rec);
            Rec.Action::Modify:
                FctUpdateCustomer(Rec);
            Rec.Action::Delete:
                FctDeleteCustomer(Rec);
        END;
        //<<WMS-FEMOT.001
    end;

    procedure FctCreateCustomer(var RecPCustomerBuffer: Record "PWD Customer Buffer")
    var
        RecLCustomer: Record Customer;
        CduLConnectorPebParseData: Codeunit "PWD Connector Peb Parse Data";
        RecordRef: RecordRef;
        RecordRefBuf: RecordRef;
    begin
        //>>WMS-FEMOT.001
        RecLCustomer.INIT();
        RecLCustomer.Name := COPYSTR(RecPCustomerBuffer.Name, 1, 50);
        RecLCustomer.INSERT(TRUE);

        RecordRefBuf.GETTABLE(RecPCustomerBuffer);
        RecordRef.GETTABLE(RecLCustomer);
        FctCheckBufferLine(RecordRefBuf);
        FctUpdateBufferLineProcessed(RecordRefBuf, 1, RecordRef.RECORDID);
        RecPCustomerBuffer.GET(RecPCustomerBuffer."Entry No.");

        RecLCustomer."Name 2" := COPYSTR(RecPCustomerBuffer."Name 2", 1, 50);
        RecLCustomer.Address := COPYSTR(RecPCustomerBuffer.Address, 1, 50);
        RecLCustomer."Address 2" := COPYSTR(RecPCustomerBuffer."Address 2", 1, 50);
        RecLCustomer."Post Code" := COPYSTR(RecPCustomerBuffer."Post Code", 1, 20);
        RecLCustomer.City := COPYSTR(RecPCustomerBuffer.City, 1, 30);
        RecLCustomer."Country/Region Code" := COPYSTR(RecPCustomerBuffer."Country/Region Code", 1, 10);
        RecLCustomer."E-Mail" := COPYSTR(RecPCustomerBuffer."E-Mail", 1, 80);
        RecLCustomer."Phone No." := COPYSTR(RecPCustomerBuffer."Phone No.", 1, 30);

        //Spécifiques PEB
        CduLConnectorPebParseData.FctUpdateCustomer(RecLCustomer, RecPCustomerBuffer."Entry No.");

        RecLCustomer.MODIFY(TRUE);
        //<<WMS-FEMOT.001
    end;

    procedure FctUpdateCustomer(var RecPCustomerBuffer: Record "PWD Customer Buffer")
    var
        RecLCustomer: Record Customer;
        CduLConnectorPebParseData: Codeunit "PWD Connector Peb Parse Data";
        RecordRef: RecordRef;
        RecordRefBuf: RecordRef;
    begin
        //>>WMS-FEMOT.001
        RecordRef.OPEN(DATABASE::Customer, FALSE, COMPANYNAME);
        RecordRef.GET(RecPCustomerBuffer."RecordID Created");
        RecordRef.SETTABLE(RecLCustomer);

        RecordRefBuf.GETTABLE(RecPCustomerBuffer);
        FctCheckBufferLine(RecordRefBuf);
        FctUpdateBufferLineProcessed(RecordRefBuf, 2, RecordRef.RECORDID);

        RecLCustomer.Name := COPYSTR(RecPCustomerBuffer.Name, 1, 50);
        RecLCustomer."Name 2" := COPYSTR(RecPCustomerBuffer."Name 2", 1, 50);
        RecLCustomer.Address := COPYSTR(RecPCustomerBuffer.Address, 1, 50);
        RecLCustomer."Address 2" := COPYSTR(RecPCustomerBuffer."Address 2", 1, 50);
        RecLCustomer."Post Code" := COPYSTR(RecPCustomerBuffer."Post Code", 1, 20);
        RecLCustomer.City := COPYSTR(RecPCustomerBuffer.City, 1, 30);
        RecLCustomer."Country/Region Code" := COPYSTR(RecPCustomerBuffer."Country/Region Code", 1, 10);
        RecLCustomer."E-Mail" := COPYSTR(RecPCustomerBuffer."E-Mail", 1, 80);
        RecLCustomer."Phone No." := COPYSTR(RecPCustomerBuffer."Phone No.", 1, 30);

        //Spécifiques PEB
        CduLConnectorPebParseData.FctUpdateCustomer(RecLCustomer, RecPCustomerBuffer."Entry No.");

        RecLCustomer.MODIFY(TRUE);
        //<<WMS-FEMOT.001
    end;

    procedure FctDeleteCustomer(var RecPCustomerBuffer: Record "PWD Customer Buffer")
    var
        RecordRef: RecordRef;
        RecordRefBuf: RecordRef;
    begin
        //>>WMS-FEMOT.001
        RecordRef.OPEN(DATABASE::Customer, FALSE, COMPANYNAME);
        RecordRef.GET(RecPCustomerBuffer."RecordID Created");
        RecordRefBuf.GETTABLE(RecPCustomerBuffer);
        FctCheckBufferLine(RecordRefBuf);
        FctUpdateBufferLineProcessed(RecordRefBuf, 3, RecordRef.RECORDID);

        RecordRef.DELETE(TRUE);
        //<<WMS-FEMOT.001
    end;

    procedure FctShowCustomer(var RecPCustomerBuffer: Record "PWD Customer Buffer")
    var
        RecLCustomer: Record Customer;
        RecordRef: RecordRef;
    begin
        //>>WMS-FEMOT.001
        RecordRef.OPEN(DATABASE::Customer, FALSE, COMPANYNAME);
        RecordRef.GET(RecPCustomerBuffer."RecordID Created");
        RecordRef.SETTABLE(RecLCustomer);
        PAGE.RUN(PAGE::"Customer Card", RecLCustomer);
        //<<WMS-FEMOT.001
    end;

    procedure FctPurgeCustomer(var RecPCustomerBuffer: Record "PWD Customer Buffer")
    begin
        //>>WMS-FEMOT.001

        //>>WMS-EBL1-003.001.001
        IF GUIALLOWED THEN
            //<<WMS-EBL1-003.001.001

            IF NOT BooGHideDialog THEN
                IF NOT CONFIRM(CstG003) THEN
                    ERROR('');

        RecPCustomerBuffer.DELETEALL(TRUE);
        //<<WMS-FEMOT.001
    end;

    procedure "---WMS-FE009.001--"()
    begin
    end;

    procedure FctProcessItemJournaLine(var Rec: Record "PWD Item Jounal Line Buffer")
    begin
        //>>WMS-FEMOT.001
        //>>WMS-EBL1-003.001.001
        IF GUIALLOWED THEN
            //<<WMS-EBL1-003.001.001

            IF NOT BooGHideDialog THEN
                IF NOT CONFIRM(CstG002) THEN
                    EXIT;

        CASE Rec.Action OF
            Rec.Action::Skip:
                ERROR(CstG001);
            Rec.Action::Insert:
                FctCreateItemJournaLine(Rec);
            Rec.Action::Modify:
                FctUpdateItemJournaLine(Rec);
            Rec.Action::Delete:
                FctDeleteItemJournaLine(Rec);
        END;
        //<<WMS-FEMOT.001
    end;

    procedure FctCreateItemJournaLine(var RecPItemJounalLineBuffer: Record "PWD Item Jounal Line Buffer")
    var
        RecLItem: Record Item;
        RecLItemJnlBatch: Record "Item Journal Batch";
        RecLItemJounalLine: Record "Item Journal Line";
        RecLItemJnlTemplate: Record "Item Journal Template";
        RecLProdOrderComponent: Record "Prod. Order Component";
        RecLProdOrderLine: Record "Prod. Order Line";
        RecLProdOrderRoutingLine: Record "Prod. Order Routing Line";
        RecLProdOrderRtngLine: Record "Prod. Order Routing Line";
        CduLNoSeriesMgt: Codeunit NoSeriesManagement;
        CduLBufferTrackingManagement: Codeunit "PWD Buffer Tracking Management";
        CduLConnectorOSYSParseData: Codeunit "PWD Connector OSYS Parse Data";
        CduLConnectorWMSParseData: Codeunit "PWD Connector WMS Parse Data";
        CduLLotInheritanceMgt: Codeunit "PWD Lot Inheritance Mgt.PW";
        LPSASetGet: Codeunit "PWD LPSA Set/Get Functions.";
        RecordRef: RecordRef;
        RecordRefBuf: RecordRef;
        CodLLotNo: Code[20];
        CodLSerialNo: Code[20];
        IntLLineNo: Integer;
        IntLSourceSubType: Integer;
        IntLTrackingType: Integer;
    begin
        //>>OSYS-Int001
        BooGCanPost := FALSE;
        //<<OSYS-Int001


        //>>WMS-FEMOT.001
        CLEAR(CduLNoSeriesMgt);
        RecLItemJnlTemplate.GET(RecPItemJounalLineBuffer."Journal Template Name");
        RecLItemJnlBatch.GET(RecPItemJounalLineBuffer."Journal Template Name", RecPItemJounalLineBuffer."Journal Batch Name");

        //>>FE_LAPRIERRETTE_GP0004.001
        //insert Possible Item
        CduLConnectorOSYSParseData.FctInsertNewProdOrderLine(RecPItemJounalLineBuffer);
        //<<FE_LAPRIERRETTE_GP0004.001

        RecLItemJounalLine.RESET();
        RecLItemJounalLine.SETRANGE("Journal Template Name", RecPItemJounalLineBuffer."Journal Template Name");
        RecLItemJounalLine.SETRANGE("Journal Batch Name", RecPItemJounalLineBuffer."Journal Batch Name");
        IF RecLItemJounalLine.FINDLAST() THEN
            IntLLineNo := RecLItemJounalLine."Line No.";

        IntLLineNo += 10000;
        RecLItemJounalLine.INIT();
        IF RecPItemJounalLineBuffer."Posting Date" <> '' THEN
            EVALUATE(RecLItemJounalLine."Posting Date", RecPItemJounalLineBuffer."Posting Date")
        ELSE
            RecLItemJounalLine."Posting Date" := TODAY;

        //>>LPSA. 14/12/2015
        RecLItemJounalLine."Posting Date" := TODAY;
        //>>LPSA. 14/12/2015

        IF RecLItemJnlBatch."No. Series" <> '' THEN BEGIN
            //>>FE_LAPRIERRETTE_GP0004.001
            //RecLItemJounalLine."Document No.":=CduLNoSeriesMgt.TryGetNextNo(RecLItemJnlBatch."No. Series",RecLItemJounalLine."Posting Date"
            CduLNoSeriesMgt.GetNextNo1(RecLItemJnlBatch."No. Series", RecLItemJounalLine."Posting Date");
            CduLNoSeriesMgt.GetNextNo(RecLItemJnlBatch."No. Series", RecLItemJounalLine."Posting Date", FALSE);
            RecLItemJounalLine."Document No." := CduLNoSeriesMgt.GetNextNo2();
            //>>LAP2.22
            IF RecPItemJounalLineBuffer."Message Code" = 'IMPORTSTOCK' THEN
                RecLItemJounalLine."Document No." := CduLNoSeriesMgt.TryGetNextNo
                                                    (RecLItemJnlBatch."No. Series", RecLItemJounalLine."Posting Date")
            //<<LAP2.22
        END;
        //<<FE_LAPRIERRETTE_GP0004.001


        RecLItemJounalLine."Journal Template Name" := RecPItemJounalLineBuffer."Journal Template Name";
        RecLItemJounalLine."Journal Batch Name" := RecPItemJounalLineBuffer."Journal Batch Name";
        RecLItemJounalLine."Line No." := IntLLineNo;
        RecLItemJounalLine."Source Code" := RecLItemJnlTemplate."Source Code";
        RecLItemJounalLine.VALIDATE("Posting Date");
        RecLItemJounalLine.INSERT(TRUE);

        RecordRefBuf.GETTABLE(RecPItemJounalLineBuffer);
        RecordRef.GETTABLE(RecLItemJounalLine);
        FctCheckBufferLine(RecordRefBuf);
        FctUpdateBufferLineProcessed(RecordRefBuf, 1, RecordRef.RECORDID);
        RecPItemJounalLineBuffer.GET(RecPItemJounalLineBuffer."Entry No.");
        RecLItemJounalLine.VALIDATE("Item No.", RecPItemJounalLineBuffer."Item No.");
        RecLItemJounalLine.VALIDATE("Location Code", RecPItemJounalLineBuffer."Location Code");
        RecLItemJounalLine.VALIDATE("Bin Code", RecPItemJounalLineBuffer."Bin Code");
        CduGFileManagement.FctEvaluateDecimal(RecPItemJounalLineBuffer.Quantity, RecLItemJounalLine.Quantity);
        RecLItemJounalLine.VALIDATE(Quantity);
        RecLItemJounalLine.VALIDATE("Entry Type", RecPItemJounalLineBuffer."Entry Type");
        RecLItemJounalLine.VALIDATE("Variant Code", RecPItemJounalLineBuffer."Variant Code");
        RecLItemJounalLine."Reason Code" := RecPItemJounalLineBuffer."Reason Code";
        RecLItemJounalLine."Source Type" := "Analysis Source Type".FromInteger(RecPItemJounalLineBuffer."Source Type");
        //>>FE_LAPIERRETTE_PROD02.001
        RecLItemJounalLine."PWD Quartis Comment" := RecPItemJounalLineBuffer."Comment Code";
        //<<FE_LAPIERRETTE_PROD02.001

        //>>LAP2.22
        RecLItemJounalLine.VALIDATE("Shortcut Dimension 1 Code", RecPItemJounalLineBuffer."Shortcut Dimension 1 Code");
        IF RecPItemJounalLineBuffer."New Location Code" <> '' THEN
            RecLItemJounalLine.VALIDATE("New Location Code", RecPItemJounalLineBuffer."New Location Code");
        //<<LAP2.22

        EVALUATE(RecLItemJounalLine."Expiration Date", RecPItemJounalLineBuffer."Expiration Date");

        //>>WMS-EBL1-003.001
        EVALUATE(CodLSerialNo, RecPItemJounalLineBuffer."Serial No.");
        EVALUATE(CodLLotNo, RecPItemJounalLineBuffer."Lot No.");
        //<<WMS-EBL1-003.001

        //IntLTrackingType = 1 Lot | 2 lot et Série | 3 Série
        IntLTrackingType := 0;
        IF (CodLLotNo <> '') AND (CodLSerialNo <> '') THEN
            IntLTrackingType := 2
        ELSE
            IF (CodLLotNo <> '') THEN
                IntLTrackingType := 1
            ELSE
                IF (CodLSerialNo <> '') THEN
                    IntLTrackingType := 3;

        //>>OSYS-Int001
        CASE RecLItemJounalLine."Entry Type" OF
            RecLItemJounalLine."Entry Type"::"Positive Adjmt.":
                IntLSourceSubType := 2;
            RecLItemJounalLine."Entry Type"::"Negative Adjmt.":
                IntLSourceSubType := 3;
            RecLItemJounalLine."Entry Type"::Output:
                BEGIN
                    IntLSourceSubType := 6;
                    RecLItemJounalLine.VALIDATE("Order No.", RecPItemJounalLineBuffer."Prod. Order No.");
                    RecLItemJounalLine.VALIDATE("Item No.", RecPItemJounalLineBuffer."Item No.");

                    //>>FE_LAPRIERRETTE_GP0004.001
                    IF NOT RecPItemJounalLineBuffer."Is Possible Item" THEN BEGIN
                        //<<FE_LAPRIERRETTE_GP0004.001

                        RecLItemJounalLine.VALIDATE("Operation No.", RecPItemJounalLineBuffer."Operation No.");
                        RecLItemJounalLine.VALIDATE(Type, RecPItemJounalLineBuffer.Type);
                        RecLItemJounalLine.VALIDATE("No.", RecPItemJounalLineBuffer."No.");

                        //>>FE_LAPRIERRETTE_GP0004.001
                    END
                    ELSE BEGIN
                        RecLProdOrderLine.SETRANGE(Status, RecLProdOrderLine.Status::Released);
                        RecLProdOrderLine.SETRANGE("Prod. Order No.", RecPItemJounalLineBuffer."Prod. Order No.");
                        IF RecLProdOrderLine.FINDFIRST() THEN BEGIN
                            RecLProdOrderRtngLine.SETRANGE(Status, RecLProdOrderLine.Status);
                            RecLProdOrderRtngLine.SETRANGE("Prod. Order No.", RecLProdOrderLine."Prod. Order No.");
                            RecLProdOrderRtngLine.SETRANGE("Routing Reference No.", RecLProdOrderLine."Routing Reference No.");
                            RecLProdOrderRtngLine.SETRANGE("Routing No.", RecLProdOrderLine."Routing No.");
                            RecLProdOrderRtngLine.SETRANGE(RecLProdOrderRtngLine."Next Operation No.", '');
                            IF RecLProdOrderRtngLine.FINDLAST() THEN BEGIN
                                RecLItemJounalLine."Routing No." := RecLProdOrderRtngLine."Routing No.";
                                RecLItemJounalLine."Operation No." := RecLProdOrderRtngLine."Operation No.";
                                RecLItemJounalLine.Type := RecLProdOrderRtngLine.Type;
                                //RecLItemJounalLine."No."            :=  RecLProdOrderRtngLine."No.";
                                RecLItemJounalLine.VALIDATE("No.", RecLProdOrderRtngLine."No.");
                            END;
                            RecLProdOrderLine.RESET();
                            RecLProdOrderRtngLine.RESET();
                        END;
                    END;
                    //<<FE_LAPRIERRETTE_GP0004.001

                    IF RecLProdOrderLine.GET(RecLProdOrderLine.Status::Released, RecPItemJounalLineBuffer."Prod. Order No.",
                                                RecPItemJounalLineBuffer."Prod. Order Line No.") THEN BEGIN
                        RecLItemJounalLine.VALIDATE("Location Code", RecLProdOrderLine."Location Code");
                        RecLItemJounalLine.VALIDATE("Bin Code", RecLProdOrderLine."Bin Code");
                    END;

                    //>>FE_LAPIERRETTE_PROD11.001
                    LPSASetGet.SetFromOsys();
                    RecLItemJounalLine.VALIDATE("PWD Conform quality control", RecPItemJounalLineBuffer."Conform quality control");
                    //<<FE_LAPIERRETTE_PROD11.001

                    RecLItemJounalLine.VALIDATE("Output Quantity", RecPItemJounalLineBuffer."Output Quantity");
                    RecLItemJounalLine.VALIDATE("Scrap Quantity", RecPItemJounalLineBuffer."Scrap Quantity");
                    IF RecPItemJounalLineBuffer."Scrap Code" <> '' THEN
                        RecLItemJounalLine.VALIDATE("Scrap Code", RecPItemJounalLineBuffer."Scrap Code");
                    RecLItemJounalLine.VALIDATE("Setup Time", RecPItemJounalLineBuffer."Setup Time");
                    RecLItemJounalLine.VALIDATE("Run Time", RecPItemJounalLineBuffer."Run Time");
                    //>>LPSA 14/12/2015 - on remplace les temps QUARTIS par les temps théoriques
                    IF RecPItemJounalLineBuffer.Finished THEN
                        IF RecLProdOrderRoutingLine.GET(RecLProdOrderLine.Status,
                        RecLProdOrderLine."Prod. Order No.",
                        RecLProdOrderLine."Line No.",
                        RecLProdOrderLine."Routing No.",
                        RecPItemJounalLineBuffer."Operation No.") THEN BEGIN
                            RecLItemJounalLine.VALIDATE("Setup Time", RecLProdOrderRoutingLine."Setup Time");
                            RecLItemJounalLine.VALIDATE("Run Time", RecLProdOrderRoutingLine."Run Time" * RecLProdOrderRtngLine."Input Quantity");
                        END;
                    //<<LPSA 14/12/2015

                    RecLItemJounalLine.Finished := RecPItemJounalLineBuffer.Finished;
                    IF RecLProdOrderRtngLine.GET(RecLProdOrderLine.Status, RecLProdOrderLine."Prod. Order No.",
                                                 RecLItemJounalLine."Routing Reference No.",
                                                 RecLItemJounalLine."Routing No.",
                                                 RecLItemJounalLine."Operation No.") THEN
                        IF RecLProdOrderRtngLine."Next Operation No." <> '' THEN
                            IntLTrackingType := 0;
                END;
            RecLItemJounalLine."Entry Type"::Consumption:
                BEGIN
                    IntLSourceSubType := 5;
                    RecLItemJounalLine.VALIDATE("Order No.", RecPItemJounalLineBuffer."Prod. Order No.");
                    RecLItemJounalLine.VALIDATE("Order Line No.", RecPItemJounalLineBuffer."Prod. Order Line No.");
                    RecLItemJounalLine.VALIDATE("Item No.", RecPItemJounalLineBuffer."Item No.");
                    IF RecLProdOrderLine.GET(RecLProdOrderLine.Status::Released, RecPItemJounalLineBuffer."Prod. Order No.",
                                              RecPItemJounalLineBuffer."Prod. Order Line No.") THEN BEGIN
                        RecLProdOrderComponent.RESET();
                        RecLProdOrderComponent.SETRANGE(Status, RecLProdOrderLine.Status);
                        RecLProdOrderComponent.SETRANGE("Prod. Order No.", RecLProdOrderLine."Prod. Order No.");
                        RecLProdOrderComponent.SETRANGE("Prod. Order Line No.", RecLProdOrderLine."Line No.");
                        RecLProdOrderComponent.SETRANGE("Item No.", RecPItemJounalLineBuffer."Item No.");
                        RecLProdOrderComponent.SETRANGE("Variant Code", RecPItemJounalLineBuffer."Variant Code");
                        IF NOT RecLProdOrderComponent.ISEMPTY THEN BEGIN
                            RecLProdOrderComponent.FINDFIRST();
                            RecLItemJounalLine.VALIDATE("Location Code", RecLProdOrderComponent."Location Code");
                            RecLItemJounalLine.VALIDATE("Bin Code", RecLProdOrderComponent."Bin Code");
                            RecLItemJounalLine.VALIDATE("Prod. Order Comp. Line No.", RecLProdOrderComponent."Line No.");
                        END;
                        CduGFileManagement.FctEvaluateDecimal(RecPItemJounalLineBuffer.Quantity, RecLItemJounalLine.Quantity);
                        RecLItemJounalLine.VALIDATE(Quantity);
                    END;
                END;
        END;
        //<<OSYS-Int001

        //Spécifiques WMS
        CduLConnectorWMSParseData.FctUpdateItemJournaLineWMS(RecLItemJounalLine, RecPItemJounalLineBuffer."Entry No.");

        //>>OSYS-Int001
        //Spécifiques OSYS
        CduLConnectorOSYSParseData.FctUpdateItemJournaLineOSYS(RecLItemJounalLine, RecPItemJounalLineBuffer."Entry No.");
        IF RecPItemJounalLineBuffer.Description <> '' THEN
            RecLItemJounalLine.Description := COPYSTR(RecPItemJounalLineBuffer.Description, 1, 30);
        //<<OSYS-Int001

        RecLItemJounalLine.MODIFY(TRUE);


        //>>FE_LAPIERRETTE_PROD11.001
        //===Get lot No From Prod Order line and If Exist Add in Item Journal line Tracking==============================
        /*
        IF IntLTrackingType = 0 THEN
          IF RecLProdOrderLine."Prod. Order No." <> '' THEN
            RecLProdOrdLine2.RESET;
            RecLProdOrdLine2.SETRANGE("Prod. Order No.",RecPItemJounalLineBuffer."Prod. Order No.");
            RecLProdOrdLine2.SETRANGE(Status,RecLProdOrderLine.Status::Released);
            RecLProdOrdLine2.SETRANGE("Item No.",RecPItemJounalLineBuffer."Item No.");
            IF RecLProdOrdLine2.FINDFIRST THEN
            BEGIN
              DecLQty := RecPItemJounalLineBuffer."Output Quantity";
        
              RecLReservEntry.RESET;
              RecLReservEntry.SETRANGE("Source Type",DATABASE::"Prod. Order Line");
              RecLReservEntry.SETRANGE("Source Subtype",RecLProdOrdLine2.Status);
              RecLReservEntry.SETRANGE("Source ID",RecLProdOrdLine2."Prod. Order No.");
              RecLReservEntry.SETRANGE("Source Batch Name",'');
              RecLReservEntry.SETRANGE("Source Prod. Order Line",RecLProdOrdLine2."Line No.");
              RecLReservEntry.SETRANGE("Source Ref. No.",0);
              IF RecLReservEntry.FINDFIRST THEN
              BEGIN
                IF RecLReservEntry."Lot No." <> '' THEN
                  IntLTrackingType := 1;
                REPEAT
                  IF DecLQty > RecLReservEntry.Quantity THEN
                    DecLQtyLine := RecLReservEntry.Quantity
                  ELSE
                    DecLQtyLine := DecLQty;
                  CduLBufferTrackingManagement.FctAssignSerialNo(DATABASE::"Item Journal Line",
                                                                 IntLSourceSubType,
                                                                 RecLItemJounalLine."Journal Template Name",
                                                                 RecLItemJounalLine."Journal Batch Name",
                                                                 IntLLineNo,
                                                                 0,
                                                                 RecLItemJounalLine."Location Code",
                                                                 RecLItemJounalLine."Bin Code",
                                                                 RecLItemJounalLine."Variant Code",
                                                                 RecLItemJounalLine."Item No.",
                                                                 //>>
                                                                 DecLQtyLine,
                                                                 IntLTrackingType,
                                                                 //>>WMS-EBL1-003.001
                                                                 //RecPItemJounalLineBuffer."Serial No.",
                                                                 //RecPItemJounalLineBuffer."Lot No.",
                                                                 RecLReservEntry."Serial No.",
                                                                 RecLReservEntry."Lot No.",
                                                                 //<<WMS-EBL1-003.001
                                                                 RecLItemJounalLine."Expiration Date");
        
                  DecLQty -=RecLReservEntry.Quantity;
                UNTIL RecLReservEntry.NEXT=0;
              END;
              IntLTrackingType := 0;
            END;
        */
        //<<FE_LAPIERRETTE_PROD11.001

        //>>FE_LAPIERRETTE_PROD11.002
        IF IntLTrackingType <> 0 THEN
            IF RecLItem.GET(RecLItemJounalLine."Item No.") THEN

                //>>FE_LAPRIERRETTE_GP0004.001
                //OLD : IF NOT(CduLLotInheritanceMgt.CheckItemDetermined(RecLItem)) THEN
                IF RecPItemJounalLineBuffer."Is Possible Item" OR
                NOT (CduLLotInheritanceMgt.CheckItemDetermined(RecLItem)) OR
                CduLConnectorOSYSParseData.FctIsStoneItem(RecLItem."No.") THEN
                    //<<FE_LAPRIERRETTE_GP0004.001

                    CduLBufferTrackingManagement.FctAssignSerialNo(DATABASE::"Item Journal Line",
                                                         IntLSourceSubType,
                                                         RecLItemJounalLine."Journal Template Name",
                                                         RecLItemJounalLine."Journal Batch Name",
                                                         IntLLineNo,
                                                         0,
                                                         RecLItemJounalLine."Location Code",
                                                         RecLItemJounalLine."Bin Code",
                                                         RecLItemJounalLine."Variant Code",
                                                         RecLItemJounalLine."Item No.",
                                                         RecLItemJounalLine.Quantity,
                                                         IntLTrackingType,
                                                         //>>WMS-EBL1-003.001
                                                         //RecPItemJounalLineBuffer."Serial No.",
                                                         //RecPItemJounalLineBuffer."Lot No.",
                                                         CodLSerialNo,
                                                         CodLLotNo,
                                                         //<<WMS-EBL1-003.001
                                                         RecLItemJounalLine."Expiration Date");
        //<<WMS-FEMOT.001
        //<<FE_LAPIERRETTE_PROD11.002

        //>>OSYS-Int001
        BooGCanPost := TRUE;
        //<<OSYS-Int001

    end;


    procedure FctUpdateItemJournaLine(var RecPItemJounalLineBuffer: Record "PWD Item Jounal Line Buffer")
    var
        RecLItemJounalLine: Record "Item Journal Line";
        RecLItemJnlTemplate: Record "Item Journal Template";
        RecLProdOrderComponent: Record "Prod. Order Component";
        RecLProdOrderLine: Record "Prod. Order Line";
        RecLProdOrderRtngLine: Record "Prod. Order Routing Line";
        CduLItemJnlLineReserve: Codeunit "Item Jnl. Line-Reserve";
        CduLBufferTrackingManagement: Codeunit "PWD Buffer Tracking Management";
        CduLConnectorOSYSParseData: Codeunit "PWD Connector OSYS Parse Data";
        CduLConnectorWMSParseData: Codeunit "PWD Connector WMS Parse Data";
        RecordRef: RecordRef;
        RecordRefBuf: RecordRef;
        IntLSourceSubType: Integer;
        IntLTrackingType: Integer;
    begin
        //>>WMS-FEMOT.001
        RecordRef.OPEN(DATABASE::"Item Journal Line", FALSE, COMPANYNAME);
        RecordRef.GET(RecPItemJounalLineBuffer."RecordID Created");
        RecordRef.SETTABLE(RecLItemJounalLine);

        CduLItemJnlLineReserve.DeleteLineConfirm(RecLItemJounalLine);
        CduLItemJnlLineReserve.DeleteLine(RecLItemJounalLine);

        RecordRefBuf.GETTABLE(RecPItemJounalLineBuffer);
        FctCheckBufferLine(RecordRefBuf);
        FctUpdateBufferLineProcessed(RecordRefBuf, 2, RecordRef.RECORDID);
        RecPItemJounalLineBuffer.GET(RecPItemJounalLineBuffer."Entry No.");
        RecLItemJnlTemplate.GET(RecPItemJounalLineBuffer."Journal Template Name");
        //>>LPSA 14/12/2015
        //IF RecPItemJounalLineBuffer."Posting Date" <> '' THEN
        //  EVALUATE(RecLItemJounalLine."Posting Date" , RecPItemJounalLineBuffer."Posting Date");
        RecLItemJounalLine."Posting Date" := TODAY;

        //>>LPSA 14/12/2015

        RecLItemJounalLine.VALIDATE("Posting Date");
        RecLItemJounalLine."Source Code" := RecLItemJnlTemplate."Source Code";
        RecLItemJounalLine.VALIDATE("Item No.", RecPItemJounalLineBuffer."Item No.");
        RecLItemJounalLine.VALIDATE("Location Code", RecPItemJounalLineBuffer."Location Code");
        RecLItemJounalLine.VALIDATE("Bin Code", RecPItemJounalLineBuffer."Bin Code");
        CduGFileManagement.FctEvaluateDecimal(RecPItemJounalLineBuffer.Quantity, RecLItemJounalLine.Quantity);
        RecLItemJounalLine.VALIDATE(Quantity);
        RecLItemJounalLine.VALIDATE("Entry Type", RecPItemJounalLineBuffer."Entry Type");
        RecLItemJounalLine.VALIDATE("Variant Code", RecPItemJounalLineBuffer."Variant Code");
        RecLItemJounalLine."Source Type" := "Analysis Source Type".FromInteger(RecPItemJounalLineBuffer."Source Type");
        RecLItemJounalLine."Reason Code" := RecPItemJounalLineBuffer."Reason Code";

        //>>FE_LAPIERRETTE_PROD02.001
        RecLItemJounalLine."PWD Quartis Comment" := RecPItemJounalLineBuffer."Comment Code";
        //<<FE_LAPIERRETTE_PROD02.001

        //>>LAP2.22
        RecLItemJounalLine.VALIDATE("Shortcut Dimension 1 Code", RecPItemJounalLineBuffer."Shortcut Dimension 1 Code");
        IF RecPItemJounalLineBuffer."New Location Code" <> '' THEN
            RecLItemJounalLine.VALIDATE("New Location Code", RecPItemJounalLineBuffer."New Location Code");
        //<<LAP2.22

        //>>FE_LAPIERRETTE_PROD11.001
        RecLItemJounalLine.VALIDATE("PWD Conform quality control", RecPItemJounalLineBuffer."Conform quality control");
        //<<FE_LAPIERRETTE_PROD11.001

        EVALUATE(RecLItemJounalLine."Expiration Date", RecPItemJounalLineBuffer."Expiration Date");

        //>>OSYS-Int001
        CASE RecLItemJounalLine."Entry Type" OF
            RecLItemJounalLine."Entry Type"::"Positive Adjmt.":
                IntLSourceSubType := 0;
            RecLItemJounalLine."Entry Type"::"Negative Adjmt.":
                IntLSourceSubType := 0;
            RecLItemJounalLine."Entry Type"::Output:
                BEGIN
                    IntLSourceSubType := 6;
                    RecLItemJounalLine.VALIDATE("Order No.", RecPItemJounalLineBuffer."Prod. Order No.");
                    RecLItemJounalLine.VALIDATE("Item No.", RecPItemJounalLineBuffer."Item No.");
                    RecLItemJounalLine.VALIDATE("Operation No.", RecPItemJounalLineBuffer."Operation No.");
                    RecLItemJounalLine.VALIDATE(Type, RecPItemJounalLineBuffer.Type);
                    RecLItemJounalLine.VALIDATE("No.", RecPItemJounalLineBuffer."No.");
                    IF RecLProdOrderLine.GET(RecLProdOrderLine.Status::Released, RecPItemJounalLineBuffer."Prod. Order No.",
                                              RecPItemJounalLineBuffer."Prod. Order Line No.") THEN BEGIN
                        RecLItemJounalLine.VALIDATE("Location Code", RecLProdOrderLine."Location Code");
                        RecLItemJounalLine.VALIDATE("Bin Code", RecLProdOrderLine."Bin Code");
                    END;
                    RecLItemJounalLine.VALIDATE("Output Quantity", RecPItemJounalLineBuffer."Output Quantity");
                    RecLItemJounalLine.VALIDATE("Scrap Quantity", RecPItemJounalLineBuffer."Scrap Quantity");
                    IF RecPItemJounalLineBuffer."Scrap Code" <> '' THEN
                        RecLItemJounalLine.VALIDATE("Scrap Code", RecPItemJounalLineBuffer."Scrap Code");
                    RecLItemJounalLine.VALIDATE("Setup Time", RecPItemJounalLineBuffer."Setup Time");
                    RecLItemJounalLine.VALIDATE("Run Time", RecPItemJounalLineBuffer."Run Time");
                    RecLItemJounalLine.Finished := RecPItemJounalLineBuffer.Finished;
                    IF RecLProdOrderRtngLine.GET(RecLProdOrderLine.Status, RecLProdOrderLine."Prod. Order No.",
                                                 RecLItemJounalLine."Routing Reference No.",
                                                 RecLItemJounalLine."Routing No.",
                                                 RecLItemJounalLine."Operation No.") THEN BEGIN
                        //>>LPSA 14/12/2015 - on remplace les temps QUARTIS par les temps théoriques
                        IF RecPItemJounalLineBuffer.Finished THEN BEGIN
                            RecLItemJounalLine.VALIDATE("Setup Time", RecLProdOrderRtngLine."Setup Time");
                            RecLItemJounalLine.VALIDATE("Run Time", RecLProdOrderRtngLine."Run Time" * RecLProdOrderRtngLine."Input Quantity");
                        END;
                        //<<LPSA 14/12/2015
                        IF RecLProdOrderRtngLine."Next Operation No." <> '' THEN
                            IntLTrackingType := 0;
                    END;
                END;
            RecLItemJounalLine."Entry Type"::Consumption:
                BEGIN
                    IntLSourceSubType := 5;
                    RecLItemJounalLine.VALIDATE("Order No.", RecPItemJounalLineBuffer."Prod. Order No.");
                    RecLItemJounalLine.VALIDATE("Order Line No.", RecPItemJounalLineBuffer."Prod. Order Line No.");
                    RecLItemJounalLine.VALIDATE("Item No.", RecPItemJounalLineBuffer."Item No.");
                    RecLItemJounalLine.VALIDATE("Operation No.", RecPItemJounalLineBuffer."Operation No.");
                    IF RecLProdOrderLine.GET(RecLProdOrderLine.Status::Released, RecPItemJounalLineBuffer."Prod. Order No.",
                                              RecPItemJounalLineBuffer."Prod. Order Line No.") THEN BEGIN
                        RecLProdOrderComponent.RESET();
                        RecLProdOrderComponent.SETRANGE(Status, RecLProdOrderLine.Status);
                        RecLProdOrderComponent.SETRANGE("Prod. Order No.", RecLProdOrderLine."Prod. Order No.");
                        RecLProdOrderComponent.SETRANGE("Prod. Order Line No.", RecLProdOrderLine."Line No.");
                        RecLProdOrderComponent.SETRANGE("Item No.", RecPItemJounalLineBuffer."Item No.");
                        RecLProdOrderComponent.SETRANGE("Variant Code", RecPItemJounalLineBuffer."Variant Code");
                        IF NOT RecLProdOrderComponent.ISEMPTY THEN BEGIN
                            RecLProdOrderComponent.FINDFIRST();
                            RecLItemJounalLine.VALIDATE("Prod. Order Comp. Line No.", RecLProdOrderComponent."Line No.");
                        END;
                    END;
                END;
        END;
        //<<OSYS-Int001


        //IntLTrackingType = 1 Lot | 2 lot et Série | 3 Série
        IntLTrackingType := 0;
        IF (RecPItemJounalLineBuffer."Lot No." <> '') AND (RecPItemJounalLineBuffer."Serial No." <> '') THEN
            IntLTrackingType := 2
        ELSE
            IF (RecPItemJounalLineBuffer."Lot No." <> '') THEN
                IntLTrackingType := 1
            ELSE
                IF (RecPItemJounalLineBuffer."Serial No." <> '') THEN
                    IntLTrackingType := 3;


        //Spécifiques WMS
        CduLConnectorWMSParseData.FctUpdateItemJournaLineWMS(RecLItemJounalLine, RecPItemJounalLineBuffer."Entry No.");

        //>>OSYS-Int001
        //Spécifiques OSYS
        CduLConnectorOSYSParseData.FctUpdateItemJournaLineOSYS(RecLItemJounalLine, RecPItemJounalLineBuffer."Entry No.");
        IF RecPItemJounalLineBuffer.Description <> '' THEN
            RecLItemJounalLine.Description := COPYSTR(RecPItemJounalLineBuffer.Description, 1, 30);
        //<<OSYS-Int001

        RecLItemJounalLine.MODIFY(TRUE);

        IF IntLTrackingType <> 0 THEN
            CduLBufferTrackingManagement.FctAssignSerialNo(DATABASE::"Item Journal Line",
                                                           IntLSourceSubType,
                                                           RecLItemJounalLine."Journal Template Name",
                                                           RecLItemJounalLine."Journal Batch Name",
                                                           RecLItemJounalLine."Line No.",
                                                           0,
                                                           RecLItemJounalLine."Location Code",
                                                           RecLItemJounalLine."Bin Code",
                                                           RecLItemJounalLine."Variant Code",
                                                           RecLItemJounalLine."Item No.",
                                                           RecLItemJounalLine.Quantity,
                                                           IntLTrackingType,
                                                           RecPItemJounalLineBuffer."Serial No.",
                                                           RecPItemJounalLineBuffer."Lot No.",
                                                           RecLItemJounalLine."Expiration Date");

        //<<WMS-FEMOT.001
    end;


    procedure FctDeleteItemJournaLine(var RecPItemJounalLineBuffer: Record "PWD Item Jounal Line Buffer")
    var
        RecLItemJournalLine: Record "Item Journal Line";
        CduLItemJnlLineReserve: Codeunit "Item Jnl. Line-Reserve";
        RecordRef: RecordRef;
        RecordRefBuf: RecordRef;
    begin
        //>>WMS-FEMOT.001
        RecordRef.OPEN(DATABASE::"Item Journal Line", FALSE, COMPANYNAME);
        RecordRef.GET(RecPItemJounalLineBuffer."RecordID Created");
        RecordRefBuf.GETTABLE(RecPItemJounalLineBuffer);
        FctCheckBufferLine(RecordRefBuf);
        FctUpdateBufferLineProcessed(RecordRefBuf, 3, RecordRef.RECORDID);

        RecordRef.SETTABLE(RecLItemJournalLine);
        CduLItemJnlLineReserve.DeleteLineConfirm(RecLItemJournalLine);
        CduLItemJnlLineReserve.DeleteLine(RecLItemJournalLine);

        RecordRef.DELETE(TRUE);

        //<<WMS-FEMOT.001
    end;


    procedure FctShowItemJournaLine(var RecPItemJounalLineBuffer: Record "PWD Item Jounal Line Buffer")
    var
        RecLItemJounalLine: Record "Item Journal Line";
        RecordRef: RecordRef;
    begin
        //>>WMS-FEMOT.001
        RecordRef.OPEN(DATABASE::"Item Journal Line", FALSE, COMPANYNAME);
        IF RecordRef.GET(RecPItemJounalLineBuffer."RecordID Created") THEN;
        RecordRef.SETTABLE(RecLItemJounalLine);

        //>>OSYS-Int001
        //OLD : FORM.RUN(FORM::"Item Journal", RecLItemJounalLine);
        CASE RecLItemJounalLine."Entry Type" OF
            RecLItemJounalLine."Entry Type"::Purchase:
                page.RUN(page::"Item Journal", RecLItemJounalLine);
            RecLItemJounalLine."Entry Type"::"Negative Adjmt.":
                page.RUN(page::"Item Journal", RecLItemJounalLine);
            RecLItemJounalLine."Entry Type"::Output:
                page.RUN(page::"Output Journal", RecLItemJounalLine);
            RecLItemJounalLine."Entry Type"::Consumption:
                page.RUN(page::"Consumption Journal", RecLItemJounalLine);
        END;
        //>>OSYS-Int001

        //<<WMS-FEMOT.001
    end;


    procedure FctPurgeItemJournaLine(var RecPItemJounalLineBuffer: Record "PWD Item Jounal Line Buffer")
    begin
        //>>WMS-FEMOT.001

        //>>WMS-EBL1-003.001.001
        IF GUIALLOWED THEN
            //<<WMS-EBL1-003.001.001

            IF NOT BooGHideDialog THEN
                IF NOT CONFIRM(CstG003) THEN
                    ERROR('');

        RecPItemJounalLineBuffer.DELETEALL(TRUE);
        //<<WMS-FEMOT.001
    end;


    procedure FctValidateItemJournaLine(TxtPJTempName: Text[30]; TxtPJBatchName: Text[30])
    var
        RecLItemJounalLine: Record "Item Journal Line";
        CduLConnectorErrorlog: Codeunit "PWD Connector Error log";
    begin
        //>>OSYS-Int001
        CLEARLASTERROR();
        COMMIT();
        RecLItemJounalLine.SETRANGE("Journal Template Name", TxtPJTempName);
        RecLItemJounalLine.SETRANGE("Journal Batch Name", TxtPJBatchName);
        IF NOT RecLItemJounalLine.ISEMPTY THEN BEGIN
            RecLItemJounalLine.FINDFIRST();
            IF NOT CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post", RecLItemJounalLine) THEN
                CduLConnectorErrorlog.InsertLogEntry(2, 1, '', COPYSTR(GETLASTERRORTEXT, 1, 250), 0);
        END;
        //<<OSYS-Int001
    end;


    procedure FctProcessReceiptLine(var Rec: Record "PWD Receipt Line Buffer")
    begin
        //>>WMS-FE007_15.001
        //>>WMS-EBL1-003.001.001
        IF GUIALLOWED THEN
            //<<WMS-EBL1-003.001.001

            IF NOT BooGHideDialog THEN
                IF NOT CONFIRM(CstG002) THEN
                    EXIT;

        CASE Rec.Action OF
            Rec.Action::Skip:
                ERROR(CstG001);
            Rec.Action::Insert:
                ERROR(CstG004);
            Rec.Action::Modify:
                FctUpdateReceiptLine(Rec);
            Rec.Action::Delete:
                ERROR(CstG004);
        END;
        //<<WMS-FE007_15.001
    end;


    procedure FctUpdateReceiptLine(var RecPReceiptLineBuffer: Record "PWD Receipt Line Buffer")
    var
        RecLPurchHead: Record "Purchase Header";
        RecLPuchaseLine: Record "Purchase Line";
        RecLPurchLToGetINfo: Record "Purchase Line";
        CduLBufferTrackingManagement: Codeunit "PWD Buffer Tracking Management";
        CduLConnectorPebParseData: Codeunit "PWD Connector Peb Parse Data";
        CduLConnectorWMSParseData: Codeunit "PWD Connector WMS Parse Data";
        RecordRef: RecordRef;
        RecordRefBuf: RecordRef;
        BooLOpen: Boolean;
        CodLLotNo: Code[20];
        CodLSerialNo: Code[20];
        CodLVariant: Code[30];
        DatLExpirationDate: Date;
        DecLQty: Decimal;
        DecLQtyReceipt: Decimal;
        IntLLineNo: Integer;
        IntLTrackingType: Integer;
    begin
        //>>WMS-FE007_15.001
        RecordRef.OPEN(DATABASE::"Purchase Line", FALSE, COMPANYNAME);

        IF FORMAT(RecPReceiptLineBuffer."RecordID Created") <> '' THEN BEGIN
            RecordRef.GET(RecPReceiptLineBuffer."RecordID Created");
            RecordRef.SETTABLE(RecLPuchaseLine);
        END ELSE BEGIN
            EVALUATE(IntLLineNo, RecPReceiptLineBuffer."Document Line No.");
            RecLPuchaseLine.GET(RecPReceiptLineBuffer."Document Type", RecPReceiptLineBuffer."Document No.", IntLLineNo);
            RecordRef.GETTABLE(RecLPuchaseLine);
        END;

        IF RecLPurchHead.GET(RecLPuchaseLine."Document Type", RecLPuchaseLine."Document No.") THEN
            IF RecLPurchHead.Status = RecLPurchHead.Status::Released THEN BEGIN
                RecLPurchHead.VALIDATE(Status, RecLPurchHead.Status::Open);
                RecLPurchHead.MODIFY(TRUE);
                BooLOpen := TRUE;
            END;

        IF RecLPuchaseLine."Qty. to Receive" > 0 THEN
            ERROR(CstG008);

        RecordRefBuf.GETTABLE(RecPReceiptLineBuffer);
        FctCheckBufferLine(RecordRefBuf);
        FctUpdateBufferLineProcessed(RecordRefBuf, 2, RecordRef.RECORDID);

        //>>WMS-EBL1-003.001
        RecLPuchaseLine.FctFromImport(TRUE);
        //<<WMS-EBL1-003.001

        //>>controle
        IF (RecPReceiptLineBuffer.Type <> RecLPuchaseLine.Type.AsInteger()) THEN
            ERROR(CstG005, RecPReceiptLineBuffer.FIELDCAPTION(Type));

        IF (RecPReceiptLineBuffer."No." <> RecLPuchaseLine."No.") THEN
            ERROR(CstG005, RecPReceiptLineBuffer.FIELDCAPTION("No."));

        EVALUATE(CodLVariant, RecPReceiptLineBuffer."Variant Code");
        //IF (RecPReceiptLineBuffer."Variant Code" <> RecLPuchaseLine."Variant Code") THEN
        IF (CodLVariant <> RecLPuchaseLine."Variant Code") THEN
            ERROR(CstG005, RecPReceiptLineBuffer.FIELDCAPTION("Variant Code"));

        //IF (RecPReceiptLineBuffer."Unit of Measure" <> RecLPuchaseLine."Unit of Measure Code") THEN
        //  ERROR(CstG005, RecPReceiptLineBuffer.FIELDCAPTION("Unit of Measure"));

        EVALUATE(DecLQty, RecPReceiptLineBuffer."Initial Quantity (Base)");
        IF (DecLQty <> RecLPuchaseLine."Quantity (Base)") THEN
            ERROR(CstG005, RecPReceiptLineBuffer.FIELDCAPTION("Initial Quantity (Base)"));
        //>>controle

        IF RecLPuchaseLine."Location Code" <> RecPReceiptLineBuffer."Location Code" THEN
            RecLPuchaseLine.VALIDATE("Location Code", RecPReceiptLineBuffer."Location Code");
        EVALUATE(DecLQtyReceipt, RecPReceiptLineBuffer."Receipt Quantity (Base)");
        IF RecPReceiptLineBuffer."Expiration Date" <> '' THEN
            EVALUATE(DatLExpirationDate, RecPReceiptLineBuffer."Expiration Date");
        CodLLotNo := COPYSTR(RecPReceiptLineBuffer."Lot No.", 1, 20);
        CodLSerialNo := COPYSTR(RecPReceiptLineBuffer."Serial No.", 1, 20);

        //IntLTrackingType = 1 Lot | 2 lot et Série | 3 Série
        IntLTrackingType := 0;
        IF (CodLLotNo <> '') AND (CodLSerialNo <> '') THEN
            IntLTrackingType := 2
        ELSE
            IF (CodLLotNo <> '') THEN
                IntLTrackingType := 1
            ELSE
                IF (CodLSerialNo <> '') THEN
                    IntLTrackingType := 3;

        IF IntLTrackingType <> 0 THEN BEGIN
            CduLBufferTrackingManagement.FctAssignSerialNo(DATABASE::"Purchase Line",
                                                            RecLPuchaseLine."Document Type".AsInteger(),
                                                            RecLPuchaseLine."Document No.",
                                                            '',
                                                            RecLPuchaseLine."Line No.",
                                                            0,
                                                            RecLPuchaseLine."Location Code",
                                                            RecLPuchaseLine."Bin Code",
                                                            RecLPuchaseLine."Variant Code",
                                                            RecLPuchaseLine."No.",
                                                            DecLQtyReceipt,
                                                            IntLTrackingType,
                                                            CodLSerialNo,
                                                            CodLLotNo,
                                                            DatLExpirationDate);

            //>>WMS-EBL1-003.001
            IF IntLTrackingType <> 1 THEN
                //<<WMS-EBL1-003.001
                RecLPuchaseLine.VALIDATE("Qty. to Receive (Base)",
               CduLBufferTrackingManagement.FctGetCountAssignSerialNo(DATABASE::"Purchase Line",
                                                              RecLPuchaseLine."Document Type".AsInteger(),
                                                              RecLPuchaseLine."Document No.",
                                                              '',
                                                              RecLPuchaseLine."Line No.",
                                                              0));

        END
        ELSE
            //RecLPuchaseLine.VALIDATE("Qty. to Receive (Base)", DecLQtyReceipt);
            //RecLPuchaseLine.VALIDATE("Qty. to Receive (Base)", DecLQtyReceipt);

            IF RecLPurchLToGetINfo.GET(RecLPuchaseLine."Document Type", RecLPuchaseLine."Document No.", RecLPuchaseLine."Line No.") THEN
                IF RecLPurchLToGetINfo."Qty. per Unit of Measure" <> 0 THEN
                    RecLPuchaseLine.VALIDATE("Qty. to Receive", DecLQtyReceipt / RecLPurchLToGetINfo."Qty. per Unit of Measure")
                ELSE
                    RecLPuchaseLine.VALIDATE("Qty. to Receive", DecLQtyReceipt);

        //Spécifiques PEB
        CduLConnectorPebParseData.FctUpdateReceiptLine(RecLPuchaseLine, RecPReceiptLineBuffer."Entry No.");
        //Spécifiques WMS
        CduLConnectorWMSParseData.FctUpdateReceiptLine(RecLPuchaseLine, RecPReceiptLineBuffer."Entry No.");

        IF BooLOpen THEN BEGIN
            RecLPurchHead.VALIDATE(Status, RecLPurchHead.Status::Released);
            RecLPurchHead.MODIFY(TRUE);
        END;

        RecLPuchaseLine.MODIFY(TRUE);
        //<<WMS-FE007_15.001
    end;


    procedure FctShowReceiptLine(var RecPReceiptLineBuffer: Record "PWD Receipt Line Buffer")
    var
        RecLPurchaseHeader: Record "Purchase Header";
        RecLPurchaseLine: Record "Purchase Line";
        RecordRef: RecordRef;
    begin
        //>>WMS-FE007_15.001
        RecordRef.OPEN(DATABASE::"Purchase Line", FALSE, COMPANYNAME);
        RecordRef.GET(RecPReceiptLineBuffer."RecordID Created");
        RecordRef.SETTABLE(RecLPurchaseLine);
        RecLPurchaseHeader.GET(RecLPurchaseLine."Document Type", RecLPurchaseLine."Document No.");
        page.RUN(page::"Purchase Order", RecLPurchaseHeader);
        //<<WMS-FE007_15.001
    end;


    procedure FctPurgeReceiptLine(var RecPReceiptLineBuffer: Record "PWD Receipt Line Buffer")
    begin
        //>>WMS-FE007_15.001

        //>>WMS-EBL1-003.001.001
        IF GUIALLOWED THEN
            //<<WMS-EBL1-003.001.001

            IF NOT BooGHideDialog THEN
                IF NOT CONFIRM(CstG003) THEN
                    ERROR('');

        RecPReceiptLineBuffer.DELETEALL(TRUE);
    end;


    procedure FctCreateBufferValues2(CodPPartnerCode: Code[20]; TxtPFileName: Text[250]; CodPFunction: Code[30]; OptPFilFormat: Option Xml,"with separator","File Position"; TxtPSeparator: Text[1]; OptPDirection: Option Import,Export; IntPLinkedEntryNo: Integer; CodPMEssageCode: Code[20]; TxtPFileName2: Text[1024]): Integer
    var
        RecLConnectorValues: Record "PWD Connector Values";
        RecLPartner: Record "PWD Partner Connector";
        CduLFileManagement: Codeunit "PWD File Management";
        RecLTempBlob: Codeunit "Temp Blob";
        InsLstream: InStream;
        OusLstream: OutStream;
    begin
        //**********************************************************************************************************//
        //                                  Insert Value in Buffer table                                            //
        //**********************************************************************************************************//

        //>>WMS-FEMOT.001
        RecLPartner.GET(CodPPartnerCode);
        RecLConnectorValues.INIT();
        RecLConnectorValues."Entry No." := FctEntryNoForBufferTable();
        RecLConnectorValues."Partner Code" := CodPPartnerCode;
        RecLConnectorValues."File Name" := TxtPFileName;
        RecLConnectorValues."Function" := CodPFunction;
        RecLConnectorValues.Direction := OptPDirection;
        RecLConnectorValues."File format" := OptPFilFormat;
        IF OptPFilFormat = OptPFilFormat::"with separator" THEN
            RecLConnectorValues.Separator := TxtPSeparator;
        IF IntPLinkedEntryNo <> 0 THEN
            RecLConnectorValues."Linked Entry No." := IntPLinkedEntryNo
        ELSE
            RecLConnectorValues."Linked Entry No." := RecLConnectorValues."Entry No.";
        RecLConnectorValues."Message Code" := CodPMEssageCode;
        RecLConnectorValues."Communication Mode" := RecLPartner."Communication Mode";
        CduLFileManagement.FctTranformFileToBlob(TxtPFileName2,
                                                 RecLTempBlob, CodPPartnerCode, RecLConnectorValues."Entry No.", OptPDirection);
        RecLTempBlob.CREATEINSTREAM(InsLstream);
        RecLConnectorValues.Blob.CREATEOUTSTREAM(OusLstream);
        COPYSTREAM(OusLstream, InsLstream);
        RecLConnectorValues.INSERT();
        EXIT(RecLConnectorValues."Entry No.");
        //<<WMS-FEMOT.001
    end;


    procedure FctProcessShipmentLine(var Rec: Record "PWD Sales Line Buffer")
    begin

        //>>WMS-EBL1-003.001.001
        IF GUIALLOWED THEN
            //<<WMS-EBL1-003.001.001

            IF NOT BooGHideDialog THEN
                IF NOT CONFIRM(CstG002) THEN
                    EXIT;

        CASE Rec.Action OF
            Rec.Action::Skip:
                ERROR(CstG001);
            Rec.Action::Insert:
                ERROR(CstG004);
            Rec.Action::Modify:
                FctUpdateShipmentLine(Rec);
            Rec.Action::Delete:
                ERROR(CstG004);
        END;
    end;


    procedure FctUpdateShipmentLine(var RecPShipmentLineBuffer: Record "PWD Sales Line Buffer")
    var
        RecLSalesHeader: Record "Sales Header";
        RecLSalesLine: Record "Sales Line";
        RecLSalesLineToGetInf: Record "Sales Line";
        CduLBufferTrackingManagement: Codeunit "PWD Buffer Tracking Management";
        CduLConnectorPebParseData: Codeunit "PWD Connector Peb Parse Data";
        CduLConnectorWMSParseData: Codeunit "PWD Connector WMS Parse Data";
        PWDLPSAFunctionsMgt: codeunit "PWD LPSA Functions Mgt.";
        CduLReleaseSalesDocument: Codeunit "Release Sales Document";
        LPSASetGetFunctions: Codeunit "PWD LPSA Set/Get Functions.";
        RecordRef: RecordRef;
        RecordRefBuf: RecordRef;
        CodLLotNo: Code[20];
        CodLSerialNo: Code[20];
        CodLVariant: Code[30];
        DatLExpirationDate: Date;
        DecLQtyShip: Decimal;
        IntLLineNo: Integer;
        IntLTrackingType: Integer;
    begin
        RecordRef.OPEN(DATABASE::"Sales Line", FALSE, COMPANYNAME);

        IF FORMAT(RecPShipmentLineBuffer."RecordID Created") <> '' THEN BEGIN
            RecordRef.GET(RecPShipmentLineBuffer."RecordID Created");
            RecordRef.SETTABLE(RecLSalesLine);
        END ELSE BEGIN
            EVALUATE(IntLLineNo, RecPShipmentLineBuffer."Document Line No.");
            RecLSalesLine.GET(RecPShipmentLineBuffer."Document Type", RecPShipmentLineBuffer."Document No.", IntLLineNo);
            RecordRef.GETTABLE(RecLSalesLine);
        END;

        IF RecLSalesLine."Qty. to Ship" > 0 THEN
            ERROR(CstG007);

        RecLSalesHeader.GET(RecLSalesLine."Document Type", RecLSalesLine."Document No.");
        PWDLPSAFunctionsMgt.FctIsImport(TRUE);
        CduLReleaseSalesDocument.Reopen(RecLSalesHeader);

        //>>WMS-EBL1-003.001
        LPSASetGetFunctions.SetFctFromImportSaleLine(TRUE);

        //<<WMS-EBL1-003.001

        RecLSalesLine.GET(RecLSalesLine."Document Type", RecLSalesLine."Document No.", RecLSalesLine."Line No.");

        RecordRefBuf.GETTABLE(RecPShipmentLineBuffer);
        FctCheckBufferLine(RecordRefBuf);
        FctUpdateBufferLineProcessed(RecordRefBuf, 2, RecordRef.RECORDID);


        IF (RecPShipmentLineBuffer.Type <> RecLSalesLine.Type.AsInteger()) THEN
            ERROR(CstG005, RecPShipmentLineBuffer.FIELDCAPTION(Type));

        IF (RecPShipmentLineBuffer."No." <> RecLSalesLine."No.") THEN
            ERROR(CstG005, RecPShipmentLineBuffer.FIELDCAPTION("No."));

        //RecLSalesLine.VALIDATE("Variant Code", RecPShipmentLineBuffer."Variant Code");
        EVALUATE(CodLVariant, RecPShipmentLineBuffer."Variant Code");
        IF CodLVariant <> '' THEN
            RecLSalesLine.VALIDATE("Variant Code", CodLVariant);

        EVALUATE(DecLQtyShip, RecPShipmentLineBuffer."Qty. to Ship (Base)");

        CodLLotNo := COPYSTR(RecPShipmentLineBuffer."Lot No.", 1, 20);
        CodLSerialNo := COPYSTR(RecPShipmentLineBuffer."Serial No.", 1, 20);

        //IntLTrackingType = 1 Lot | 2 lot et Série | 3 Série
        IntLTrackingType := 0;
        IF (CodLLotNo <> '') AND (CodLSerialNo <> '') THEN
            IntLTrackingType := 2
        ELSE
            IF (CodLLotNo <> '') THEN
                IntLTrackingType := 1
            ELSE
                IF (CodLSerialNo <> '') THEN
                    IntLTrackingType := 3;

        IF IntLTrackingType <> 0 THEN BEGIN
            CduLBufferTrackingManagement.FctAssignSerialNo(DATABASE::"Sales Line",
                                                            RecLSalesLine."Document Type".AsInteger(),
                                                            RecLSalesLine."Document No.",
                                                            '',
                                                            RecLSalesLine."Line No.",
                                                            0,
                                                            RecLSalesLine."Location Code",
                                                            RecLSalesLine."Bin Code",
                                                            RecLSalesLine."Variant Code",
                                                            RecLSalesLine."No.",
                                                            DecLQtyShip,
                                                            IntLTrackingType,
                                                            CodLSerialNo,
                                                            CodLLotNo,
                                                            DatLExpirationDate);
            //>>WMS-EBL1-003.001
            IF IntLTrackingType <> 1 THEN
                //<<WMS-EBL1-003.001
                RecLSalesLine.VALIDATE("Qty. to Ship (Base)",
               CduLBufferTrackingManagement.FctGetCountAssignSerialNo(DATABASE::"Sales Line",
                                                              RecLSalesLine."Document Type".AsInteger(),
                                                              RecLSalesLine."Document No.",
                                                              '',
                                                              RecLSalesLine."Line No.",
                                                              0));

        END

        //RecLSalesLine.VALIDATE("Qty. to Ship (Base)", DecLQtyShip);
        ELSE
            IF RecLSalesLineToGetInf.GET(RecLSalesLine."Document Type", RecLSalesLine."Document No.", RecLSalesLine."Line No.") THEN
                IF RecLSalesLineToGetInf."Qty. per Unit of Measure" <> 0 THEN
                    RecLSalesLine.VALIDATE("Qty. to Ship", DecLQtyShip / RecLSalesLineToGetInf."Qty. per Unit of Measure")
                ELSE
                    RecLSalesLine.VALIDATE("Qty. to Ship", DecLQtyShip);

        //Spécifiques PEB
        CduLConnectorPebParseData.FctUpdateShipmentLine(RecLSalesLine, RecPShipmentLineBuffer."Entry No.");
        //Spécifiques WMS
        CduLConnectorWMSParseData.FctUpdateShipmentLine(RecLSalesLine, RecPShipmentLineBuffer."Entry No.");

        RecLSalesLine.MODIFY(TRUE);

        COMMIT();
        CduLReleaseSalesDocument.RUN(RecLSalesHeader);
    end;


    procedure FctShowShipmentLine(var RecPShipmentLineBuffer: Record "PWD Sales Line Buffer")
    var
        RecLSalesHeader: Record "Sales Header";
        RecLSalesLine: Record "Sales Line";
        RecordRef: RecordRef;
    begin
        RecordRef.OPEN(DATABASE::"Sales Line", FALSE, COMPANYNAME);
        RecordRef.GET(RecPShipmentLineBuffer."RecordID Created");
        RecordRef.SETTABLE(RecLSalesLine);
        RecLSalesHeader.GET(RecLSalesLine."Document Type", RecLSalesLine."Document No.");
        page.RUN(page::"Sales Order", RecLSalesHeader);
    end;


    procedure FctPurgeShipmentLine(var RecPShipmentLineBuffer: Record "PWD Sales Line Buffer")
    begin
        //>>WMS-EBL1-003.001.001
        IF GUIALLOWED THEN
            //<<WMS-EBL1-003.001.001

            IF NOT BooGHideDialog THEN
                IF NOT CONFIRM(CstG003) THEN
                    ERROR('');

        RecPShipmentLineBuffer.DELETEALL(TRUE);
    end;


    procedure "---OSYS-Int001---"()
    begin
    end;


    procedure FctInitItemJnlLineTempBuffer()
    begin
        RecGItemJnlLineTempBufferPost.RESET();
        RecGItemJnlLineTempBufferPost.DELETEALL();
    end;


    procedure FctValidateMultiItemJournaLine()
    begin
        RecGItemJnlLineTempBufferPost.RESET();
        RecGItemJnlLineTempBufferPost.SETRANGE("Auto-Post Document", TRUE);
        IF NOT RecGItemJnlLineTempBufferPost.ISEMPTY THEN BEGIN
            RecGItemJnlLineTempBufferPost.FINDSET();
            REPEAT
                FctValidateItemJournaLine(RecGItemJnlLineTempBufferPost."Journal Template Name",
                                          RecGItemJnlLineTempBufferPost."Journal Batch Name");
            UNTIL RecGItemJnlLineTempBufferPost.NEXT() = 0;
        END;
    end;


    procedure FctInsertItemJnlLineTempBuffer(var Rec: RecordRef)
    var
        RecLItemJournalLineBuffer: Record "PWD Item Jounal Line Buffer";
        FieldRef: FieldRef;
    begin
        IF Rec.NUMBER <> DATABASE::"PWD Item Jounal Line Buffer" THEN
            EXIT;
        //Rec.SETTABLE(RecLItemJournalLineBuffer);
        FieldRef := Rec.FIELD(1);
        RecLItemJournalLineBuffer.GET(FieldRef.VALUE);
        RecGItemJnlLineTempBufferPost.RESET();
        IF RecGItemJnlLineTempBufferPost.FINDLAST() THEN;
        RecGItemJnlLineTempBufferPost.SETRANGE("Journal Template Name", RecLItemJournalLineBuffer."Journal Template Name");
        RecGItemJnlLineTempBufferPost.SETRANGE("Journal Batch Name", RecLItemJournalLineBuffer."Journal Batch Name");
        IF RecGItemJnlLineTempBufferPost.ISEMPTY THEN BEGIN
            RecGItemJnlLineTempBufferPost := RecLItemJournalLineBuffer;
            RecGItemJnlLineTempBufferPost."Entry No." := RecGItemJnlLineTempBufferPost."Entry No." + 1;
            RecGItemJnlLineTempBufferPost.INSERT();
        END
        ELSE BEGIN
            RecGItemJnlLineTempBufferPost.FINDFIRST();
            IF (NOT RecGItemJnlLineTempBufferPost."Auto-Post Document") AND (RecLItemJournalLineBuffer."Auto-Post Document") THEN BEGIN
                RecGItemJnlLineTempBufferPost."Auto-Post Document" := RecLItemJournalLineBuffer."Auto-Post Document";
                RecGItemJnlLineTempBufferPost.MODIFY();
            END;
        END;
    end;


    procedure FctCanPost(): Boolean
    begin
        EXIT(BooGCanPost);
    end;


    procedure "---ProdConnect1.07.01---"()
    begin
    end;


    procedure FctHideDialog(BooLHideDialog: Boolean)
    begin
        BooGHideDialog := BooLHideDialog;
    end;


    procedure FctValidateItemJournaLineBatch(TxtPJTempName: Text[30]; TxtPJBatchName: Text[30])
    var
        RecLItemJounalLine: Record "Item Journal Line";
        CduLConnectorErrorlog: Codeunit "PWD Connector Error log";
    begin
        CLEARLASTERROR();
        COMMIT();
        RecLItemJounalLine.SETRANGE("Journal Template Name", TxtPJTempName);
        RecLItemJounalLine.SETRANGE("Journal Batch Name", TxtPJBatchName);
        IF NOT RecLItemJounalLine.ISEMPTY THEN BEGIN
            RecLItemJounalLine.FINDFIRST();
            IF NOT CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post Batch", RecLItemJounalLine) THEN
                CduLConnectorErrorlog.InsertLogEntry(2, 1, '', COPYSTR(GETLASTERRORTEXT, 1, 250), 0);
        END;
    end;
}

