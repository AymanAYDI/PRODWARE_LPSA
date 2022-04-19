codeunit 8073306 "PWD Connector OSYS Parse Data"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.6
    // OSYS-Int001.001:GR 18/10/2011   Connector integration
    //                                   - Create Object
    // 
    // //>>LAP2.06
    // FE_LAPRIERRETTE_GP0004.001 :GR  23/05/13  : - Add Functions : FctGetItemsPossibleXML
    //                                                               FctExportItemsPossibleManual
    //                                                               FctInsertNewProdOrderLine
    //                                                               FctInsertConsumptionJnlLine
    //                                             - C\AL in : FctProcessExport , FctUpdateItemJournaLineOSYS
    // 
    // 
    // 
    // //>>LAP2.06.01
    // FE_LAPRIERRETTE_GP0004.002 :GR  15/07/13  : - Add Functions : FctIsSteeItem
    // 
    // //>>LAP2.14
    //  RO : 23/01/2018 : Nouvelles demande Export Prod Order remis à plat
    //                    - Add C/AL Code in triggers FctProcessExport
    //                    - Add Function FctGetReleasedProdOrderLPSA
    // 
    // //>>LAP2.22
    // P24578_009: RO : 12/12/2019 : cf Demande par mail
    //                   - Add function FctImportStockXML
    //                   - Add C\AL Code in trigger FctProcessImport
    // 
    // +----------------------------------------------------------------------------------------------------------------+

    TableNo = "PWD Connector Values";

    trigger OnRun()
    var
        RecLConnectorMessages: Record "PWD Connector Messages";
    begin
        //********************************************************************************************************************************//
        //                                                                                                                                //
        //                                         Fonction Spécifique OSYS                                                               //
        //                                                                                                                                //
        //********************************************************************************************************************************//

        IF NOT FctOSYSEnabled() THEN
            EXIT;

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

            'IMPORTPROD':
                FctImportProdXML(RecPConnectorValues);
            'IMPORTCONSO':
                FctImportConsoXML(RecPConnectorValues);

            //>>LAP2.22
            'IMPORTSTOCK':
                FctImportStockXML(RecPConnectorValues);
        //<<LAP2.22

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
    begin
        CLEAR(BigTLToReturn);
        CLEAR(IntGSequenceNo);
        RecLPartnerConnector.GET(RecPConnectorMessages."Partner Code");

        RecPConnectorMessages.TESTFIELD(Path);

        CASE RecPConnectorMessages."Function" OF
            'EXPORTITEMS':
                FctGetItemsXML(RecPConnectorMessages, RecLTempBlob);
            'EXPORTSTOCK':
                FctGetStockXML(RecPConnectorMessages, RecLTempBlob);
            'RELEASEDPRODORDERS':
                FctGetReleasedProdOrderXML(RecPConnectorMessages, RecLTempBlob);
            'FINISHEDPRODORDERS':
                FctGetFinishedProdOrderXML(RecPConnectorMessages, RecLTempBlob);
            'DELETEDPRODORDERS':
                FctGetDeletedProdOrderXML(RecPConnectorMessages, RecLTempBlob);

            //>>FE_LAPRIERRETTE_GP0004.001
            'EXPORTPOSSIBLEITEMS':
                FctGetItemsPossibleXML(RecPConnectorMessages, RecLTempBlob, '');
            //<<FE_LAPRIERRETTE_GP0004.001
            //>>LAP2.14
            'RELEASEDPRODORDERSLPSA':
                FctGetReleasedProdOrderLPSA(RecPConnectorMessages, RecLTempBlob);
            //<<LAP2.14
            ELSE
                CASE RecLPartnerConnector."Data Format" OF
                    RecLPartnerConnector."Data Format"::Xml:
                        CduGConnectBufMgtExport.FctCreateXml('', RecPConnectorMessages, RecLTempBlob, TRUE);
                    RecLPartnerConnector."Data Format"::"with separator":
                        CduGConnectBufMgtExport.FctCreateSeparator('', RecPConnectorMessages, RecLTempBlob);
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
                                                RecPConnectorMessages.Path,
                                                RecPConnectorMessages."Partner Code",
                                                IntGSequenceNo, RecLPartnerConnector,
                                                //>>WMS-FEMOT.002
                                                RecPConnectorMessages."File Name value",
                                                RecPConnectorMessages."File Name with Society Code",
                                                RecPConnectorMessages."File Name with Date",
                                                RecPConnectorMessages."File Name with Time",
                                                RecPConnectorMessages."File extension");
            //<<WMS-FEMOT.002

            //>>LAP2.14
            IF RecPConnectorMessages."Function" = 'RELEASEDPRODORDERSLPSA' THEN
                TxtLFile := RecPConnectorMessages.Path + '\' +
                            'LPSA_' + FORMAT(IntGSequenceNo) + '_' +
                            FORMAT(WORKDATE(), 0, '<year4><month,2><day,2>') + '_' +
                            FORMAT(TIME, 0, '<hour,2><minute,2><Second,2>') + '.CSV';
            //<<LAP2.14

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


    procedure FctGetItemsXML(RecPConnectorMes: Record "PWD Connector Messages"; var RecPTempBlob: Record TempBlob temporary)
    var
        XmlLItemsExport: XMLport "PWD Items Export OSYS";
        OutLStream: OutStream;
    begin
        CLEAR(XmlLItemsExport);
        XmlLItemsExport.FctDefinePartner(RecPConnectorMes);
        IF XmlLItemsExport.FctInitXML() THEN BEGIN
            RecPTempBlob.Blob.CREATEOUTSTREAM(OutLStream);
            XmlLItemsExport.SETDESTINATION(OutLStream);
            XmlLItemsExport.EXPORT;
        END;
    end;


    procedure FctGetStockXML(RecPConnectorMes: Record "PWD Connector Messages"; var RecPTempBlob: Record TempBlob temporary)
    var
        XmlLStockExport: XMLport "PWD Stock Export OSYS";
        OutLStream: OutStream;
    begin
        CLEAR(XmlLStockExport);
        XmlLStockExport.FctDefinePartner(RecPConnectorMes);
        IF XmlLStockExport.FctInitXML() THEN BEGIN
            RecPTempBlob.Blob.CREATEOUTSTREAM(OutLStream);
            XmlLStockExport.SETDESTINATION(OutLStream);
            XmlLStockExport.EXPORT;
        END;
    end;


    procedure FctImportProdXML(var RecPConnectorValues: Record "PWD Connector Values")
    var
        XmlLImportProdOsys: XMLport "PWD Import Prod OSYS";
        InsLSrtream: InStream;
    begin
        RecPConnectorValues.CALCFIELDS(Blob);
        RecPConnectorValues.Blob.CREATEINSTREAM(InsLSrtream);
        XmlLImportProdOsys.FctInitXmlPort(RecPConnectorValues);
        XmlLImportProdOsys.SETSOURCE(InsLSrtream);
        XmlLImportProdOsys.IMPORT;
    end;


    procedure FctImportConsoXML(var RecPConnectorValues: Record "PWD Connector Values")
    var
        XmlLImportConsoOsys: XMLport "PWD Import Conso OSYS";
        InsLSrtream: InStream;
    begin
        RecPConnectorValues.CALCFIELDS(Blob);
        RecPConnectorValues.Blob.CREATEINSTREAM(InsLSrtream);
        XmlLImportConsoOsys.FctInitXmlPort(RecPConnectorValues);
        XmlLImportConsoOsys.SETSOURCE(InsLSrtream);
        XmlLImportConsoOsys.IMPORT;
    end;


    procedure FctOSYSEnabled(): Boolean
    var
        RecLOSYSSetup: Record "PWD OSYS Setup";
    begin
        RecLOSYSSetup.GET();
        EXIT(RecLOSYSSetup.OSYS);
    end;


    procedure FctValidateItemJournalLine()
    begin
    end;


    procedure FctGetReleasedProdOrderXML(RecPConnectorMes: Record "PWD Connector Messages"; var RecPTempBlob: Record TempBlob temporary)
    var
        XmlLExportProdOrderOSYS: XMLport "PWD Export Prod Order OSYS";
        OutLStream: OutStream;
    begin
        CLEAR(XmlLExportProdOrderOSYS);
        XmlLExportProdOrderOSYS.FctDefinePartner(RecPConnectorMes);
        XmlLExportProdOrderOSYS.FctDefineProdOrderStatus(3);
        IF XmlLExportProdOrderOSYS.FctInitXML() THEN BEGIN
            RecPTempBlob.Blob.CREATEOUTSTREAM(OutLStream);
            XmlLExportProdOrderOSYS.SETDESTINATION(OutLStream);
            XmlLExportProdOrderOSYS.EXPORT;
        END;
    end;


    procedure FctGetFinishedProdOrderXML(RecPConnectorMes: Record "PWD Connector Messages"; var RecPTempBlob: Record TempBlob temporary)
    var
        XmlLExportProdOrderOSYS: XMLport "PWD Export Prod Order OSYS";
        OutLStream: OutStream;
    begin
        CLEAR(XmlLExportProdOrderOSYS);
        XmlLExportProdOrderOSYS.FctDefinePartner(RecPConnectorMes);
        XmlLExportProdOrderOSYS.FctDefineProdOrderStatus(4);
        IF XmlLExportProdOrderOSYS.FctInitXML() THEN BEGIN
            RecPTempBlob.Blob.CREATEOUTSTREAM(OutLStream);
            XmlLExportProdOrderOSYS.SETDESTINATION(OutLStream);
            XmlLExportProdOrderOSYS.EXPORT;
        END;
    end;


    procedure FctGetDeletedProdOrderXML(RecPConnectorMes: Record "PWD Connector Messages"; var RecPTempBlob: Record TempBlob temporary)
    var
        XmlLExportDeleteProdOrderOSYS: XMLport "PWD Delete Prod. Order Line";
        OutLStream: OutStream;
    begin
        CLEAR(XmlLExportDeleteProdOrderOSYS);
        XmlLExportDeleteProdOrderOSYS.FctDefinePartner(RecPConnectorMes);
        IF XmlLExportDeleteProdOrderOSYS.FctInitXML() THEN BEGIN
            RecPTempBlob.Blob.CREATEOUTSTREAM(OutLStream);
            XmlLExportDeleteProdOrderOSYS.SETDESTINATION(OutLStream);
            XmlLExportDeleteProdOrderOSYS.EXPORT;
        END;
    end;


    procedure FctUpdateItemJournaLineOSYS(var RecPItemJounalLine: Record "Item Journal Line"; var IntPEntryBufferNo: Integer)
    var
        RecLOSYSItemJounalLineBuffer: Record "OSYS Item Jounal Line Buffer";
        RecLItemJounalLineBuffer: Record "PWD Item Jounal Line Buffer";
        RecLProdOrderLine: Record "Prod. Order Line";
        RecLProdOrderComponent: Record "Prod. Order Component";
        RecLProdOrderRtngLine: Record "Prod. Order Routing Line";
        RecLCapacityUnitofMeasure: Record "Capacity Unit of Measure";
        RecLWorkCenter: Record "Work Center";
        DecLPre: Decimal;
    begin
        IF NOT FctOSYSEnabled() THEN
            EXIT;

        IF NOT RecLItemJounalLineBuffer.GET(IntPEntryBufferNo) THEN
            EXIT;

        IF NOT FctIsTheSamePartener(RecLItemJounalLineBuffer."Partner Code") THEN
            EXIT;

        IF RecLOSYSItemJounalLineBuffer.GET(IntPEntryBufferNo) THEN;

        WITH RecPItemJounalLine DO


            CASE "Entry Type" OF
                "Entry Type"::Output:
                    BEGIN

                        IF RecLProdOrderLine.GET(RecLProdOrderLine.Status::Released, RecPItemJounalLine."Order No.",
                                                  RecPItemJounalLine."Order Line No.") THEN
                            ;


                        IF RecLProdOrderRtngLine.GET(RecLProdOrderLine.Status, RecLProdOrderLine."Prod. Order No.", "Routing Reference No.",
                                                     "Routing No.", "Operation No.") THEN BEGIN
                            RecLWorkCenter.GET(RecLProdOrderRtngLine."Work Center No.");
                            DecLPre := RecLWorkCenter."Calendar Rounding Precision";

                            RecLCapacityUnitofMeasure.GET(RecLProdOrderRtngLine."Setup Time Unit of Meas. Code");
                            CASE RecLCapacityUnitofMeasure.Type OF
                                RecLCapacityUnitofMeasure.Type::"100/Hour":
                                    "Setup Time" := ROUND(RecLItemJounalLineBuffer."Setup Time" / 36, DecLPre)
;
                                RecLCapacityUnitofMeasure.Type::Minutes:
                                    "Setup Time" := ROUND(RecLItemJounalLineBuffer."Setup Time" / 60, DecLPre)
;
                                RecLCapacityUnitofMeasure.Type::Hours:
                                    "Setup Time" := ROUND(RecLItemJounalLineBuffer."Setup Time" / 3600, DecLPre)
;
                                RecLCapacityUnitofMeasure.Type::Days:
                                    "Setup Time" := ROUND(RecLItemJounalLineBuffer."Setup Time" / 86400, DecLPre)
;
                            END;
                            RecLCapacityUnitofMeasure.GET(RecLProdOrderRtngLine."Run Time Unit of Meas. Code");
                            CASE RecLCapacityUnitofMeasure.Type OF
                                RecLCapacityUnitofMeasure.Type::"100/Hour":
                                    "Run Time" := ROUND(RecLItemJounalLineBuffer."Run Time" / 36, DecLPre)
;
                                RecLCapacityUnitofMeasure.Type::Minutes:
                                    "Run Time" := ROUND(RecLItemJounalLineBuffer."Run Time" / 60, DecLPre)
;
                                RecLCapacityUnitofMeasure.Type::Hours:
                                    "Run Time" := ROUND(RecLItemJounalLineBuffer."Run Time" / 3600, DecLPre)
;
                                RecLCapacityUnitofMeasure.Type::Days:
                                    "Run Time" := ROUND(RecLItemJounalLineBuffer."Run Time" / 86400, DecLPre)
;
                            END;

                            /*
                            IF RecLProdOrderRtngLine."Next Operation No." <> '' THEN
                              IF RecLOSYSItemJounalLineBuffer."Next Operation No." <> RecLProdOrderRtngLine."Next Operation No." THEN
                                ERROR(STRSUBSTNO(CstGNextOp,RecLOSYSItemJounalLineBuffer."Next Operation No.",RecLProdOrderLine."Prod. Order No.",
                                                "Operation No."));

                            */

                            //>>FE_LAPRIERRETTE_GP0004.001
                            RecLProdOrderComponent.RESET();
                            RecLProdOrderComponent.SETCURRENTKEY(Status, "Prod. Order No.", "Routing Link Code");
                            RecLProdOrderComponent.SETRANGE(Status, RecLProdOrderLine.Status);
                            RecLProdOrderComponent.SETRANGE("Prod. Order No.", RecLProdOrderLine."Prod. Order No.");
                            RecLProdOrderComponent.SETRANGE("Routing Link Code", RecLProdOrderRtngLine."Routing Link Code");
                            RecLProdOrderComponent.SETRANGE("Prod. Order Line No.", RecLProdOrderLine."Line No.");
                            RecLProdOrderComponent.SETFILTER("Item No.", '<>%1', '');
                            IF NOT RecLProdOrderComponent.ISEMPTY THEN BEGIN
                                RecLProdOrderComponent.FINDSET();
                                REPEAT
                                    // Create Consumption Item Journal-line
                                    FctInsertConsumptionJnlLine(RecLProdOrderComponent, RecLProdOrderLine, RecPItemJounalLine, 1);
                                UNTIL RecLProdOrderComponent.NEXT() = 0;
                            END;
                            //<<FE_LAPRIERRETTE_GP0004.001
                        END;
                        //>>LPSA 14/12/2015
                        IF RecPItemJounalLine.Finished THEN BEGIN
                            VALIDATE("Setup Time", RecLProdOrderRtngLine."Setup Time");
                            VALIDATE("Run Time", RecLProdOrderRtngLine."Run Time" * RecLProdOrderRtngLine."Input Quantity");
                            IF ("Run Time" = 0) AND ("Setup Time" = 0) AND (RecPItemJounalLine."Output Quantity" = 0) AND
                              (RecPItemJounalLine."Scrap Quantity" = 0) THEN
                                VALIDATE("Run Time", 0.01);
                        END;
                        //<<LPSA 14/12/2015
                        VALIDATE("Setup Time");
                        VALIDATE("Run Time");

                    END;

                "Entry Type"::Consumption:


                    //gestion des gammes line link
                    IF RecLProdOrderLine.GET(RecLProdOrderLine.Status::Released, RecPItemJounalLine."Order No.",
                                              RecPItemJounalLine."Order Line No.") THEN
                        IF RecLProdOrderRtngLine.GET(RecLProdOrderLine.Status, RecLProdOrderLine."Prod. Order No.", RecLProdOrderLine."Line No.",
                                                     RecLProdOrderLine."Routing No.", RecLItemJounalLineBuffer."Operation No.") THEN BEGIN
                            RecLProdOrderComponent.RESET();
                            RecLProdOrderComponent.SETRANGE(Status, RecLProdOrderLine.Status);
                            RecLProdOrderComponent.SETRANGE("Prod. Order No.", RecLProdOrderLine."Prod. Order No.");
                            RecLProdOrderComponent.SETRANGE("Prod. Order Line No.", RecLProdOrderLine."Line No.");
                            RecLProdOrderComponent.SETRANGE("Item No.", RecPItemJounalLine."Item No.");
                            RecLProdOrderComponent.SETRANGE("Variant Code", RecPItemJounalLine."Variant Code");
                            RecLProdOrderComponent.SETRANGE("Routing Link Code", RecLProdOrderRtngLine."Routing Link Code");
                            IF NOT RecLProdOrderComponent.ISEMPTY THEN BEGIN
                                RecLProdOrderComponent.FINDFIRST();
                                VALIDATE("Location Code", RecLProdOrderComponent."Location Code");
                                VALIDATE("Bin Code", RecLProdOrderComponent."Bin Code");
                                VALIDATE("Prod. Order Comp. Line No.", RecLProdOrderComponent."Line No.");
                            END;
                        END;
            END;

    end;


    procedure FctIsTheSamePartener(CodPPartner: Code[20]): Boolean
    var
        RecLOSYSSetup: Record "PWD OSYS Setup";
    begin
        RecLOSYSSetup.GET();
        RecLOSYSSetup.TESTFIELD("Partner Code");
        EXIT((RecLOSYSSetup."Partner Code" = CodPPartner) AND FctOSYSEnabled());
    end;


    procedure FctConvertUnit(var RecPProdOrderRtngLine: Record "Prod. Order Routing Line")
    var
        RecLCapacityUnitofMeasure: Record "Capacity Unit of Measure";
        DecLPre: Decimal;
        RecLWorkCenter: Record "Work Center";
    begin
        RecLWorkCenter.GET(RecPProdOrderRtngLine."Work Center No.");
        DecLPre := RecLWorkCenter."Calendar Rounding Precision";

        WITH RecPProdOrderRtngLine DO BEGIN
            RecLCapacityUnitofMeasure.GET("Setup Time Unit of Meas. Code");
            CASE RecLCapacityUnitofMeasure.Type OF
                RecLCapacityUnitofMeasure.Type::"100/Hour":
                    "Setup Time" := ROUND("Setup Time" * 36, DecLPre);
                RecLCapacityUnitofMeasure.Type::Minutes:
                    "Setup Time" := ROUND("Setup Time" * 60, DecLPre);
                RecLCapacityUnitofMeasure.Type::Hours:
                    "Setup Time" := ROUND("Setup Time" * 3600, DecLPre);
                RecLCapacityUnitofMeasure.Type::Days:
                    "Setup Time" := ROUND("Setup Time" * 86400, DecLPre);
            END;

            RecLCapacityUnitofMeasure.GET("Run Time Unit of Meas. Code");
            CASE RecLCapacityUnitofMeasure.Type OF
                RecLCapacityUnitofMeasure.Type::"100/Hour":
                    "Run Time" := ROUND("Run Time" * 36, DecLPre);
                RecLCapacityUnitofMeasure.Type::Minutes:
                    "Run Time" := ROUND("Run Time" * 60, DecLPre);
                RecLCapacityUnitofMeasure.Type::Hours:
                    "Run Time" := ROUND("Run Time" * 3600, DecLPre);
                RecLCapacityUnitofMeasure.Type::Days:
                    "Run Time" := ROUND("Run Time" * 86400, DecLPre);
            END;
        END;
    end;


    procedure "---LAP2.06---"()
    begin
    end;


    procedure FctGetItemsPossibleXML(RecPConnectorMes: Record "PWD Connector Messages"; var RecPTempBlob: Record TempBlob temporary; CodPItemNo: Code[20])
    var
        XmlLItemsPossibleExport: XMLport "PWD Possible Items Export";
        OutLStream: OutStream;
        RecLPossibleItems: Record "PWD Possible Items";
    begin
        //>>FE_LAPRIERRETTE_GP0004.001
        CLEAR(XmlLItemsPossibleExport);
        IF CodPItemNo <> '' THEN BEGIN
            RecLPossibleItems.SETRANGE("Item Code", CodPItemNo);
            XmlLItemsPossibleExport.FctExportAll(TRUE);
            XmlLItemsPossibleExport.SETTABLEVIEW(RecLPossibleItems)
        END;

        XmlLItemsPossibleExport.FctDefineMessage(RecPConnectorMes);
        IF XmlLItemsPossibleExport.FctCanExportPossibleItems('', RecPConnectorMes."Export DateTime") THEN BEGIN
            RecPTempBlob.Blob.CREATEOUTSTREAM(OutLStream);
            XmlLItemsPossibleExport.SETDESTINATION(OutLStream);
            XmlLItemsPossibleExport.EXPORT;
        END;
        //>>FE_LAPRIERRETTE_GP0004.001
    end;


    procedure FctExportItemsPossibleManual(CodPItemNo: Code[20])
    var
        RecLConnectorMessages: Record "PWD Connector Messages";
        RecLTempBlob: Record TempBlob temporary;
        RecLPartnerConnector: Record "PWD Partner Connector";
        RecLConnectorValues: Record "PWD Connector Values";
        CduLBufferMgt: Codeunit "PWD Buffer Management";
        InLStream: InStream;
        CduLFileManagement: Codeunit "File Management";
        TxtLFile: Text[1024];
        BooLResult: Boolean;
        RecLOSYS: Record "PWD OSYS Setup";
    begin
        //>>FE_LAPRIERRETTE_GP0004.001
        CLEAR(IntGSequenceNo);
        RecLOSYS.GET();
        RecLOSYS.TESTFIELD(OSYS);
        RecLOSYS.TESTFIELD("Partner Code");
        RecLOSYS.TESTFIELD("Possible Items Message");
        RecLConnectorMessages.GET(RecLOSYS."Partner Code", RecLOSYS."Possible Items Message", RecLConnectorMessages.Direction::Export);
        RecLConnectorMessages.TESTFIELD(Path);
        RecLPartnerConnector.GET(RecLConnectorMessages."Partner Code");
        FctGetItemsPossibleXML(RecLConnectorMessages, RecLTempBlob, CodPItemNo);
        RecLTempBlob.CALCFIELDS(Blob);
        IF RecLTempBlob.Blob.HASVALUE THEN BEGIN
            RecLTempBlob.Blob.CREATEINSTREAM(InLStream);
            IntGSequenceNo := CduLBufferMgt.FctCreateBufferValues(InLStream, RecLConnectorMessages."Partner Code", '',
                                                                  RecLConnectorMessages.Code,
                                                                  RecLPartnerConnector."Data Format"::Xml,
                                                                  RecLPartnerConnector.Separator, 1, 0,
                                                                  RecLConnectorMessages.Code);

            TxtLFile := CduGConnectBufMgtExport.FctMakeFileName(
                                                RecLConnectorMessages.Path,
                                                RecLConnectorMessages."Partner Code",
                                                IntGSequenceNo, RecLPartnerConnector,
                                                RecLConnectorMessages."File Name value",
                                                RecLConnectorMessages."File Name with Society Code",
                                                RecLConnectorMessages."File Name with Date",
                                                RecLConnectorMessages."File Name with Time",
                                                RecLConnectorMessages."File extension");

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
        //<<FE_LAPRIERRETTE_GP0004.001
    end;


    procedure FctInsertNewProdOrderLine(var RecPItemJounalLineBuffer: Record "PWD Item Jounal Line Buffer")
    var
        RecLProdOrder: Record "Production Order";
        RecLProdOrderLine: Record "Prod. Order Line";
        RecLItem: Record Item;
        IntLNextLineNo: Integer;
        CduLFileManagement: Codeunit "File Management";
        DecLQuamtity: Decimal;
    begin
        //>>FE_LAPRIERRETTE_GP0004.001
        RecLItem.GET(RecPItemJounalLineBuffer."Item No.");

        IF NOT FctOSYSEnabled() OR (RecPItemJounalLineBuffer."Entry Type" <> RecPItemJounalLineBuffer."Entry Type"::Output) THEN
            EXIT;

        IF NOT RecLProdOrder.GET(RecLProdOrder.Status::Released, RecPItemJounalLineBuffer."Prod. Order No.") THEN
            EXIT;


        IF FctIsStoneItem(RecPItemJounalLineBuffer."Item No.") THEN BEGIN
            RecPItemJounalLineBuffer."Lot No." := FORMAT(RecLProdOrder."No.");
            RecPItemJounalLineBuffer.MODIFY();
        END;

        RecLProdOrderLine.SETRANGE(Status, RecLProdOrderLine.Status::Released);
        RecLProdOrderLine.SETRANGE("Prod. Order No.", RecPItemJounalLineBuffer."Prod. Order No.");
        RecLProdOrderLine.SETRANGE("Item No.", RecPItemJounalLineBuffer."Item No.");
        IF NOT RecLProdOrderLine.ISEMPTY THEN BEGIN
            IF RecLProdOrderLine.FINDFIRST() THEN BEGIN
                RecPItemJounalLineBuffer."Lot No." := FORMAT(RecLProdOrder."No.");
                RecPItemJounalLineBuffer."Prod. Order Line No." := RecLProdOrderLine."Line No.";
                RecPItemJounalLineBuffer."Is Possible Item" := RecLProdOrderLine."PWD Is Possible Item";
                IF RecLProdOrderLine."PWD Is Possible Item" THEN BEGIN
                    RecPItemJounalLineBuffer."Setup Time" := 0;
                    RecPItemJounalLineBuffer."Run Time" := 0;
                    RecPItemJounalLineBuffer.Finished := TRUE;
                    IF EVALUATE(DecLQuamtity, RecPItemJounalLineBuffer.Quantity) THEN BEGIN
                        RecLProdOrderLine.Quantity += DecLQuamtity;
                        RecLProdOrderLine.VALIDATE(Quantity);
                        RecLProdOrderLine.MODIFY(TRUE)
                    END;
                END;
                RecPItemJounalLineBuffer.MODIFY();
            END;
            EXIT;
        END;

        //Find Next Line No
        IntLNextLineNo := 10000;
        RecLProdOrderLine.SETRANGE("Item No.");
        IF NOT RecLProdOrderLine.ISEMPTY THEN BEGIN
            RecLProdOrderLine.FINDLAST();
            IntLNextLineNo := RecLProdOrderLine."Line No." + 10000;
        END;

        RecLProdOrderLine.RESET();
        RecLProdOrderLine.INIT();
        RecLProdOrderLine.Status := RecLProdOrder.Status;
        RecLProdOrderLine."Prod. Order No." := RecLProdOrder."No.";
        RecLProdOrderLine."Line No." := IntLNextLineNo;
        RecLProdOrderLine."Routing Reference No." := RecLProdOrderLine."Line No.";
        RecLProdOrderLine.VALIDATE("Item No.", RecLItem."No.");
        RecLProdOrderLine.VALIDATE("Production BOM No.", '');
        RecLProdOrderLine.VALIDATE("Routing No.", '');
        RecLProdOrderLine."Location Code" := RecLProdOrder."Location Code";
        RecLProdOrderLine."Shortcut Dimension 1 Code" := RecLProdOrder."Shortcut Dimension 1 Code";
        RecLProdOrderLine."Shortcut Dimension 2 Code" := RecLProdOrder."Shortcut Dimension 2 Code";
        IF RecLProdOrder."Bin Code" <> '' THEN
            RecLProdOrderLine."Bin Code" := RecLProdOrder."Bin Code"
        ELSE
            RecLProdOrderLine.VALIDATE("Location Code");
        RecLProdOrderLine."Scrap %" := RecLItem."Scrap %";
        RecLProdOrderLine."Due Date" := RecLProdOrder."Due Date";
        RecLProdOrderLine."Starting Date" := RecLProdOrder."Starting Date";
        RecLProdOrderLine."Starting Time" := RecLProdOrder."Starting Time";
        RecLProdOrderLine."Ending Date" := RecLProdOrder."Ending Date";
        RecLProdOrderLine."Ending Time" := RecLProdOrder."Ending Time";
        RecLProdOrderLine."Planning Level Code" := 0;
        RecLProdOrderLine."Inventory Posting Group" := RecLItem."Inventory Posting Group";
        RecLProdOrderLine.UpdateDatetime();
        RecLProdOrderLine.VALIDATE("Unit Cost");
        //RecLProdOrderLine.VALIDATE("Earliest Start Date");
        IF NOT CduLFileManagement.FctEvaluateDecimal(RecPItemJounalLineBuffer.Quantity, RecLProdOrderLine.Quantity) THEN
            EVALUATE(RecLProdOrderLine.Quantity, RecPItemJounalLineBuffer.Quantity);
        RecLProdOrderLine.VALIDATE(Quantity);
        RecLProdOrderLine.UpdateDatetime();
        RecLProdOrderLine."PWD Is Possible Item" := TRUE;
        RecLProdOrderLine.INSERT(TRUE);

        RecPItemJounalLineBuffer."Lot No." := FORMAT(RecLProdOrder."No.");
        RecPItemJounalLineBuffer."Prod. Order Line No." := RecLProdOrderLine."Line No.";
        RecPItemJounalLineBuffer."Is Possible Item" := TRUE;
        RecPItemJounalLineBuffer."Setup Time" := 0;
        RecPItemJounalLineBuffer."Run Time" := 0;
        RecPItemJounalLineBuffer.Finished := TRUE;
        RecPItemJounalLineBuffer.MODIFY();
        //<<FE_LAPRIERRETTE_GP0004.001
    end;


    procedure FctIsStoneItem(CodPItemNo: Code[20]): Boolean
    var
        RecLItem: Record Item;
        RecLItemCategory: Record "Item Category";
    begin
        IF RecLItem.GET(CodPItemNo) THEN
            IF RecLItemCategory.GET(RecLItem."Item Category Code") THEN
                IF NOT RecLItemCategory."PWD Transmitted Order No." THEN
                    EXIT(TRUE);
        EXIT(FALSE)
    end;

    local procedure FctInsertConsumptionJnlLine(RecPProdOrderComp: Record "Prod. Order Component"; RecPProdOrderLine: Record "Prod. Order Line"; RecPItemJnlLine: Record "Item Journal Line"; IntPLevel: Integer)
    var
        RecLItem: Record Item;
        CduLItemTrackingMgt: Codeunit "Item Tracking Management";
        RecLItemJnlLine: Record "Item Journal Line";
        RecLItemJnlBatch: Record "Item Journal Batch";
        RecLItemJnlTemplate: Record "Item Journal Template";
    begin
        WITH RecPProdOrderComp DO BEGIN
            RecLItem.GET("Item No.");
            RecLItem.TESTFIELD(Blocked, FALSE);
            IF "Flushing Method" = "Flushing Method"::Manual THEN
                EXIT;

            IF RecLItem."Item Tracking Code" = '' THEN
                EXIT;

            RecLItemJnlTemplate.GET(RecPItemJnlLine."Journal Template Name");
            RecLItemJnlBatch.GET(RecPItemJnlLine."Journal Template Name", RecPItemJnlLine."Journal Batch Name");

            RecLItemJnlLine.INIT();
            RecLItemJnlLine."Journal Template Name" := RecPItemJnlLine."Journal Template Name";
            RecLItemJnlLine."Journal Batch Name" := RecPItemJnlLine."Journal Batch Name";
            RecLItemJnlLine."Line No." := RecPItemJnlLine."Line No." + 10000;
            RecLItemJnlLine.VALIDATE("Posting Date", RecPItemJnlLine."Posting Date");
            RecLItemJnlLine.VALIDATE("Entry Type", RecLItemJnlLine."Entry Type"::Consumption);
            RecLItemJnlLine.VALIDATE("Order No.", "Prod. Order No.");
            RecLItemJnlLine.VALIDATE("Source No.", RecPProdOrderLine."Item No.");
            RecLItemJnlLine.VALIDATE("Item No.", "Item No.");
            RecLItemJnlLine.VALIDATE("Unit of Measure Code", "Unit of Measure Code");
            RecLItemJnlLine.Description := Description;
            RecLItemJnlLine.VALIDATE(Quantity, 0);
            RecLItemJnlLine.VALIDATE("Location Code", "Location Code");
            IF "Bin Code" <> '' THEN
                RecLItemJnlLine.VALIDATE("Bin Code", "Bin Code");
            RecLItemJnlLine."Variant Code" := "Variant Code";
            RecLItemJnlLine.VALIDATE("Order Line No.", "Prod. Order Line No.");
            RecLItemJnlLine.VALIDATE("Prod. Order Comp. Line No.", "Line No.");

            RecLItemJnlLine.Level := IntPLevel;
            RecLItemJnlLine."Flushing Method" := "Flushing Method";
            RecLItemJnlLine."Source Code" := RecLItemJnlTemplate."Source Code";
            RecLItemJnlLine."Reason Code" := RecLItemJnlBatch."Reason Code";
            RecLItemJnlLine."Posting No. Series" := RecLItemJnlBatch."Posting No. Series";
            CduLItemTrackingMgt.CopyItemTracking(RowID1(), RecLItemJnlLine.RowID1(), FALSE);
        END;
    end;


    procedure "---LAP2.06.01---"()
    begin
    end;


    procedure FctIsSteeItem(CodPItemNo: Code[20]): Boolean
    var
        RecLItem: Record Item;
        RecLItemCategory: Record "Item Category";
    begin
        //>>FE_LAPRIERRETTE_GP0004.002
        IF RecLItem.GET(CodPItemNo) THEN
            IF RecLItemCategory.GET(RecLItem."Item Category Code") THEN
                IF RecLItemCategory."PWD Transmitted Order No." THEN
                    EXIT(TRUE);
        EXIT(FALSE)
        //<<FE_LAPRIERRETTE_GP0004.002
    end;


    procedure "--- LAP2.14 ---"()
    begin
    end;


    procedure FctGetReleasedProdOrderLPSA(RecPConnectorMes: Record "PWD Connector Messages"; var RecPTempBlob: Record TempBlob temporary)
    var
        RepLExportProdOrderLPSA: Report "PWD Export Prod Order LPSA";
    begin
        CLEAR(RepLExportProdOrderLPSA);
        IF RepLExportProdOrderLPSA.FctInitRep() THEN BEGIN
            RepLExportProdOrderLPSA.RUNMODAL;
            RepLExportProdOrderLPSA.FctGetBlob(RecPTempBlob);
        END;
    end;

    procedure FctImportStockXML(var RecPConnectorValues: Record "PWD Connector Values")
    var
        XmlLImportStock: XMLport "PWD Import STOCK";
        InsLSrtream: InStream;
    begin
        RecPConnectorValues.CALCFIELDS(Blob);
        RecPConnectorValues.Blob.CREATEINSTREAM(InsLSrtream);
        XmlLImportStock.FctInitXmlPort(RecPConnectorValues);
        XmlLImportStock.SETSOURCE(InsLSrtream);
        XmlLImportStock.IMPORT;
    end;
}

