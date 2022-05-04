codeunit 8073296 "PWD Connector WMS Parse Data"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect.1.00
    // 
    // WMS-FEMOT.001:GR 04/07/2001 :  Connector integration
    //                                   - Create Object
    // 
    // WMS-FE007_15.001:GR 05/07/2011 Receipt
    //                              - Add function FctUpdateReceiptLine
    //                              - Add function FctCreateReceiptLine
    // 
    // WMS-FE009.001:GR 05/07/2011 Stock  - Add Functions :
    //                                         FctProcessItemJournaLine
    //                                         FctCreateItemJournaLine
    //                                         FctImportInventoryFilePos
    // 
    // WMS-FE008_15.001:GR 19/07/2011 Shipment
    //                                   - Add function:
    //                                         FctUpdateShipmentLine
    //                                         FctImportShipmentLineFilePos
    //                                         FctImportShipmentLine
    //                                         FctImportShipmentLineXML
    //                                         FctImportShipmentLineWithSep
    // 
    // 
    // //>>ProdConnect1.6
    // OSYS-Int001.001:GR 18/10/2011   Connector integration
    //                                 - Add function : FctIsTheSamePartener
    //                                 - C\AL in functions :
    //                                   FctUpdateReceiptLine
    //                                   FctUpdateShipmentLine
    //                                   FctUpdateItemJournaLineWMS
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
        if not FctWMSEnabled() then
            exit;

        case Direction of
            Direction::Export:
                begin
                    RecLConnectorMessages.Get("Partner Code", "Message Code", Direction);
                    FctProcessExport(RecLConnectorMessages);
                end;

            Direction::Import:

                FctProcessImport(Rec);
        end;
    end;

    var
        RecGAllConnectorMes: Record "PWD Connector Messages";
        CduGConnectBufMgtExport: Codeunit "Connector Buffer Mgt Export";
        CduGBufferManagement: Codeunit "PWD Buffer Management";
        BigTGCommentMergeInProgress: BigText;
        BigTGEqualNbLineMainTable: BigText;
        BigTGFinal: BigText;
        BigTGFinal2: BigText;
        BigTGMergeInProgress: BigText;
        BigTGOneLine: BigText;
        BigTGOneLineComment: BigText;
        BigTGSecondBloc: BigText;
        ChrG10: Char;
        ChrG13: Char;
        IntGLoop: Integer;
        IntGNbLineMainTable: Integer;
        IntGNbSecondBloc: Integer;
        IntGSequenceNo: Integer;
        OptGFlowType: Option " ","Import Connector","Export Connector";


    procedure FctProcessImport(var RecPConnectorValues: Record "PWD Connector Values")
    begin
        case RecPConnectorValues."Function" of
            'PWAIMPORTINVENTORY':
                FctImportInventory(RecPConnectorValues);
            'PWAIMPORTVENDSHIP':
                FctImportVendShipFilePos(RecPConnectorValues);
            'PWAORDERCUST':
                FctImportShipmentLine(RecPConnectorValues);
        end;

        CduGBufferManagement.FctArchiveBufferValues(RecPConnectorValues, true);
    end;


    procedure FctProcessExport(RecPConnectorMessages: Record "PWD Connector Messages")
    var
        RecLConnectorValues: Record "PWD Connector Values";
        RecLPartnerConnector: Record "PWD Partner Connector";
        RecLConnectorsActivation: Record "PWD WMS Setup";
        CduLBufferMgt: Codeunit "PWD Buffer Management";
        CduLFileManagement: Codeunit "PWD File Management";
        TempBlob: Codeunit "Temp Blob";
        BigTLToReturn: BigText;
        BooLResult: Boolean;
        InLStream: InStream;
        TxtLFile: Text[1024];
    begin
        Clear(BigTLToReturn);
        Clear(IntGSequenceNo);
        RecLPartnerConnector.Get(RecPConnectorMessages."Partner Code");

        RecPConnectorMessages.TestField(Path);

        case RecPConnectorMessages."Function" of
            'PWAGETITEM':
                FctGetItemFilePos(RecPConnectorMessages, TempBlob);
            'PWAGETVENDORDER':
                FctGetVendOrderFilePos(RecPConnectorMessages, TempBlob);
            'PWAGETCUSTORDER':
                FctGetCustOrderFilePos(RecPConnectorMessages, TempBlob);
            'PWAGETADDRESS':
                FctGetAddressFilePos(RecPConnectorMessages, TempBlob);
            'PWAUNITLOG':
                FctGetLogisticUnitsFilePos(RecPConnectorMessages, TempBlob);
            'PWAGETKITMGT':
                FctGetKitMgtFilePos(RecPConnectorMessages, TempBlob);
            'PWACREATECUSTSHIP':
                FctCreateCustShipFilePos(RecPConnectorMessages, TempBlob);
            else
                case RecLPartnerConnector."Data Format" of
                    RecLPartnerConnector."Data Format"::Xml:
                        CduGConnectBufMgtExport.FctCreateXml('', RecPConnectorMessages, TempBlob, true);
                    RecLPartnerConnector."Data Format"::"with separator":
                        CduGConnectBufMgtExport.FctCreateSeparator('', RecPConnectorMessages, TempBlob);
                end;
        end;
        //TODO:'Codeunit "Temp Blob"' does not contain a definition for 'CalcFields'
        //TempBlob.CalcFields(Blob);
        if TempBlob.HasValue() then begin
            TempBlob.CreateInStream(InLStream);
            IntGSequenceNo := CduLBufferMgt.FctCreateBufferValues(InLStream, RecPConnectorMessages."Partner Code", '',
                                                                  RecPConnectorMessages."Function",
                                                                  RecLPartnerConnector."Data Format"::Xml,
                                                                  RecLPartnerConnector.Separator, 1, 0,
                                                                  RecPConnectorMessages.Code);

            if RecLConnectorsActivation.Get() then;
            TxtLFile := CduGConnectBufMgtExport.FctMakeFileName(
                                                RecPConnectorMessages.Path,
                                                RecLConnectorsActivation."WMS Company Code",
                                                //RecPConnectorMessages."Partner Code" ,
                                                IntGSequenceNo, RecLPartnerConnector,
                                                //>>WMS-FEMOT.002
                                                RecPConnectorMessages."File Name value",
                                                RecPConnectorMessages."File Name with Society Code",
                                                RecPConnectorMessages."File Name with Date",
                                                RecPConnectorMessages."File Name with Time",
                                                RecPConnectorMessages."File extension"
                                                );
            //<<WMS-FEMOT.002



            Clear(InLStream);
            RecLConnectorValues.Get(IntGSequenceNo);
            RecLConnectorValues."File Name" := CopyStr(TxtLFile, 1, 250);
            RecLConnectorValues.Modify();
            RecLConnectorValues.CalcFields(Blob);
            RecLConnectorValues.Blob.CreateInStream(InLStream);
            BooLResult := CduLFileManagement.FctbTransformBlobToFile(TxtLFile, InLStream, RecLConnectorValues."Partner Code",
                                                                     IntGSequenceNo, OptGFlowType::"Export Connector");
            CduLBufferMgt.FctArchiveBufferValues(RecLConnectorValues, BooLResult);
        end;
    end;


    procedure FctGetItemFilePos(RecPConnectorMes: Record "PWD Connector Messages"; var TempBlob: Codeunit "Temp Blob")
    var
        RecLItem: Record Item;
        RecLItemForCrossRef: Record Item;
        RecLItemCrossReference: Record "Item Cross Reference";
        RecLItemUnitofMeasure: Record "Item Unit of Measure";
        RecLLocation: Record Location;
        RecLVendor: Record Vendor;
    begin
        //Travail sur la table "PWD Connector Messages" afin de ne générer cette fonction qu'une fois, en prenant pour référence la table 27

        ChrG10 := 10;
        ChrG13 := 13;

        if RecPConnectorMes."Master Table" then begin
            Clear(BigTGFinal);
            Clear(BigTGMergeInProgress);
            //*******************************************************************************************************************************
            //************************Premier bloc*******************************************************************************************
            //*******************************************************************************************************************************

            //Sélections de toutes les lignes de la table "PWD Connector Messages" correspondant à la fonction à traiter
            RecGAllConnectorMes.Reset();
            RecGAllConnectorMes.SetRange("Partner Code", RecPConnectorMes."Partner Code");
            RecGAllConnectorMes.SetRange("Function", RecPConnectorMes."Function");
            RecGAllConnectorMes.SetRange(Direction, RecPConnectorMes.Direction::Export);
            RecGAllConnectorMes.SetCurrentKey("Master Table");
            RecGAllConnectorMes.Ascending(false);
            if RecGAllConnectorMes.FindFirst() then
                repeat

                    case RecGAllConnectorMes."Table ID" of
                        //*********************************************************************************
                        //Table Principale
                        //*********************************************************************************
                        27:
                            begin
                                RecLItemForCrossRef.Reset();
                                RecLItemForCrossRef.SetRange("PWD WMS_Item", true);
                                RecLItemForCrossRef.SetFilter("Vendor No.", '<>%1', '');
                                if RecLItemForCrossRef.FindSet() then
                                    repeat
                                        RecLItemCrossReference.SetRange("Item No.", RecLItemForCrossRef."No.");
                                        RecLItemCrossReference.SetRange("Unit of Measure", RecLItemForCrossRef."Base Unit of Measure");
                                        RecLItemCrossReference.SetRange("Cross-Reference Type", RecLItemCrossReference."Cross-Reference Type"::Vendor);
                                        RecLItemCrossReference.SetRange("Cross-Reference Type No.", RecLItemForCrossRef."Vendor No.");
                                        if not RecLItemCrossReference.FindFirst() then begin
                                            RecLItemCrossReference.Init();
                                            RecLItemCrossReference."Item No." := RecLItemForCrossRef."No.";
                                            RecLItemCrossReference."Unit of Measure" := RecLItemForCrossRef."Base Unit of Measure";
                                            RecLItemCrossReference."Cross-Reference Type" := RecLItemCrossReference."Cross-Reference Type"::Vendor;
                                            RecLItemCrossReference."Cross-Reference Type No." := RecLItemForCrossRef."Vendor No.";
                                            RecLItemCrossReference."Cross-Reference No." := RecLItemForCrossRef."Vendor Item No.";
                                            RecLItemCrossReference.Insert();
                                        end;
                                    until RecLItemForCrossRef.Next() = 0;
                                Commit();

                                RecLItem.Reset();
                                RecLItem.SetRange("PWD WMS_Item", true);
                                RecLItem.SetFilter("Vendor No.", '<>%1', '');
                                IntGNbLineMainTable := RecLItem.Count;
                                Clear(BigTGEqualNbLineMainTable);
                                CduGConnectBufMgtExport.FctCreateBigTextWithPosition(RecLItem.GetView(), RecGAllConnectorMes, BigTGEqualNbLineMainTable);
                            end;

                        //*********************************************************************************
                        //Tables Secondaires
                        //*********************************************************************************
                        8073288:
                            begin
                                Clear(BigTGEqualNbLineMainTable);
                                //Boucle pour récupérer autant de lignes ds le BigText, de la table 8073288, que celles générées pour les articles
                                for IntGLoop := 1 to IntGNbLineMainTable do begin
                                    Clear(BigTGOneLine);
                                    CduGConnectBufMgtExport.FctCreateBigTextWithPosition('', RecGAllConnectorMes, BigTGOneLine);
                                    CduGConnectBufMgtExport.FctConcatBigText(BigTGOneLine, BigTGEqualNbLineMainTable);
                                end;
                            end;

                        5404:
                            begin
                                Clear(BigTGEqualNbLineMainTable);
                                //Boucle pour récupérer autant de lignes ds le BigText, de la table 5404, que celles générées pour les articles
                                if RecLItem.FindSet() then
                                    repeat
                                        Clear(BigTGOneLine);
                                        RecLItemUnitofMeasure.SetRange("Item No.", RecLItem."No.");
                                        RecLItemUnitofMeasure.SetRange(Code, RecLItem."Base Unit of Measure");
                                        CduGConnectBufMgtExport.FctCreateBigTextWithPosition(RecLItemUnitofMeasure.GetView(), RecGAllConnectorMes, BigTGOneLine);
                                        CduGConnectBufMgtExport.FctConcatBigText(BigTGOneLine, BigTGEqualNbLineMainTable);
                                    until RecLItem.Next() = 0;
                            end;

                        23:
                            begin
                                Clear(BigTGEqualNbLineMainTable);
                                //Boucle pour récupérer autant de lignes ds le BigText, de la table 5404, que celles générées pour les articles
                                if RecLItem.FindSet() then
                                    repeat
                                        Clear(BigTGOneLine);
                                        RecLVendor.SetRange("No.", RecLItem."Vendor No.");
                                        CduGConnectBufMgtExport.FctCreateBigTextWithPosition(RecLVendor.GetView(), RecGAllConnectorMes, BigTGOneLine);
                                        CduGConnectBufMgtExport.FctConcatBigText(BigTGOneLine, BigTGEqualNbLineMainTable);
                                    until RecLItem.Next() = 0;
                            end;

                        5717:
                            begin
                                Clear(BigTGEqualNbLineMainTable);
                                //Boucle pour récupérer autant de lignes ds le BigText, de la table 5404, que celles générées pour les articles
                                if RecLItem.FindSet() then
                                    repeat
                                        Clear(BigTGOneLine);
                                        RecLItemCrossReference.SetRange("Item No.", RecLItem."No.");
                                        RecLItemCrossReference.SetRange("Unit of Measure", RecLItem."Base Unit of Measure");
                                        RecLItemCrossReference.SetRange("Cross-Reference Type", RecLItemCrossReference."Cross-Reference Type"::Vendor);
                                        RecLItemCrossReference.SetRange("Cross-Reference Type No.", RecLItem."Vendor No.");
                                        RecLItemCrossReference.SetRange("Cross-Reference No.", RecLItem."Vendor Item No.");
                                        CduGConnectBufMgtExport.FctCreateBigTextWithPosition(RecLItemCrossReference.GetView(), RecGAllConnectorMes, BigTGOneLine);
                                        CduGConnectBufMgtExport.FctConcatBigText(BigTGOneLine, BigTGEqualNbLineMainTable);
                                    until RecLItem.Next() = 0;
                            end;

                        6502:
                            begin
                                Clear(BigTGEqualNbLineMainTable);
                                //Boucle pour récupérer autant de lignes ds le BigText, de la table 5404, que celles générées pour les articles
                                if RecLItem.FindSet() then
                                    repeat
                                        Clear(BigTGOneLine);
                                        RecLItemCrossReference.SetRange("Item No.", RecLItem."No.");
                                        RecLItemCrossReference.SetRange("Unit of Measure", RecLItem."Base Unit of Measure");
                                        RecLItemCrossReference.SetRange("Cross-Reference Type", RecLItemCrossReference."Cross-Reference Type"::Vendor);
                                        RecLItemCrossReference.SetRange("Cross-Reference Type No.", RecLItem."Vendor No.");
                                        CduGConnectBufMgtExport.FctCreateBigTextWithPosition(RecLItemCrossReference.GetView(), RecGAllConnectorMes, BigTGOneLine);
                                        CduGConnectBufMgtExport.FctConcatBigText(BigTGOneLine, BigTGEqualNbLineMainTable);
                                    until RecLItem.Next() = 0;
                            end;

                    end;

                    //Merge du bigtext obtenu sur la table traitée dans la boucle, avec le bigtext global
                    if BigTGMergeInProgress.Length <> 0 then
                        CduGConnectBufMgtExport.FctMergeBigText(RecGAllConnectorMes."Fill Character",
                                                                BigTGEqualNbLineMainTable,
                                                                BigTGMergeInProgress,
                                                                BigTGFinal)
                    else
                        BigTGFinal.AddText(BigTGEqualNbLineMainTable);

                    Clear(BigTGMergeInProgress);
                    BigTGMergeInProgress.AddText(BigTGFinal);

                until RecGAllConnectorMes.Next() = 0;

            //*******************************************************************************************************************************
            //************************Second bloc*******************************************************************************************
            //*******************************************************************************************************************************

            RecGAllConnectorMes.Reset();
            RecGAllConnectorMes.SetRange("Partner Code", RecPConnectorMes."Partner Code");
            RecGAllConnectorMes.SetRange("Function", RecPConnectorMes."Function");
            RecGAllConnectorMes.SetRange(Direction, RecPConnectorMes.Direction::Export);
            if RecGAllConnectorMes.FindFirst() then
                repeat

                    case RecGAllConnectorMes."Table ID" of
                        //*********************************************************************************
                        //Table Principale
                        //*********************************************************************************
                        14:
                            begin
                                Clear(BigTGSecondBloc);
                                RecLLocation.Reset();
                                RecLLocation.SetRange("PWD WMS_Location", true);
                                CduGConnectBufMgtExport.FctCreateBigTextWithPosition(RecLLocation.GetView(), RecGAllConnectorMes, BigTGSecondBloc);
                            end;
                    end;

                until RecGAllConnectorMes.Next() = 0;

            if BigTGFinal.Length <> 0 then
                BigTGFinal.AddText(Format(ChrG13) + Format(ChrG10));
            BigTGFinal.AddText(BigTGSecondBloc);


            //Génération du blog avec le bigText mergé
            if BigTGFinal.Length <> 0 then
                CduGConnectBufMgtExport.FctGenerateBlob(BigTGFinal, TempBlob);
        end;
    end;


    procedure FctGetVendOrderFilePos(RecPConnectorMes: Record "PWD Connector Messages"; var TempBlob: Codeunit "Temp Blob")
    var
        RecLPurchaseHeader: Record "Purchase Header";
        RecLPurchaseLine: Record "Purchase Line";
        CodLDocNo: Code[20];
    begin
        if not FctWMSEnabled() then
            exit;
        //Travail sur la table "PWD Connector Messages" afin de ne générer cette fonction qu'une fois, en prenant pour référence la table 39

        ChrG10 := 10;
        ChrG13 := 13;

        if RecPConnectorMes."Master Table" then begin
            Clear(BigTGFinal);
            Clear(BigTGMergeInProgress);
            //*******************************************************************************************************************************
            //************************Premier bloc*******************************************************************************************
            //*******************************************************************************************************************************

            //Sélections de toutes les lignes de la table "PWD Connector Messages" correspondant à la fonction à traiter
            RecGAllConnectorMes.Reset();
            RecGAllConnectorMes.SetRange("Partner Code", RecPConnectorMes."Partner Code");
            RecGAllConnectorMes.SetRange("Function", RecPConnectorMes."Function");
            RecGAllConnectorMes.SetRange(Direction, RecPConnectorMes.Direction::Export);
            RecGAllConnectorMes.SetCurrentKey("Master Table");
            RecGAllConnectorMes.Ascending(false);
            if RecGAllConnectorMes.FindFirst() then
                repeat

                    case RecGAllConnectorMes."Table ID" of
                        //*********************************************************************************
                        //Table Principale
                        //*********************************************************************************
                        39:
                            begin
                                RecLPurchaseLine.Reset();
                                RecLPurchaseLine.SetRange("Document Type", RecLPurchaseLine."Document Type"::Order);
                                RecLPurchaseLine.SetRange("Drop Shipment", false);
                                RecLPurchaseLine.SetRange(Type, RecLPurchaseLine.Type::Item);
                                RecLPurchaseLine.SetRange("PWD WMS_Status_Header", RecLPurchaseLine."PWD WMS_Status_Header"::Released);
                                RecLPurchaseLine.SetRange("PWD WMS_Item", true);
                                RecLPurchaseLine.SetRange("PWD WMS_Location", true);
                                RecLPurchaseLine.SetRange("PWD WMS_Status", RecLPurchaseLine."PWD WMS_Status"::" ");
                                RecLPurchaseLine.SetFilter("Outstanding Quantity", '<>%1', 0);
                                IntGNbLineMainTable := RecLPurchaseLine.Count;
                                Clear(BigTGEqualNbLineMainTable);
                                CduGConnectBufMgtExport.FctCreateBigTextWithPosition(RecLPurchaseLine.GetView(),
                                                                                     RecGAllConnectorMes, BigTGEqualNbLineMainTable);
                            end;

                        //*********************************************************************************
                        //Tables Secondaires
                        //*********************************************************************************
                        8073288:
                            begin
                                Clear(BigTGEqualNbLineMainTable);
                                //Boucle pour récupérer autant de lignes ds le BigText, de la table 8073288, que celles générées pour les articles
                                for IntGLoop := 1 to IntGNbLineMainTable do begin
                                    Clear(BigTGOneLine);
                                    CduGConnectBufMgtExport.FctCreateBigTextWithPosition('', RecGAllConnectorMes, BigTGOneLine);
                                    CduGConnectBufMgtExport.FctConcatBigText(BigTGOneLine, BigTGEqualNbLineMainTable);
                                end;
                            end;
                    end;

                    //Merge du bigtext obtenu sur la table traitée dans la boucle, avec le bigtext global
                    if BigTGMergeInProgress.Length <> 0 then
                        CduGConnectBufMgtExport.FctMergeBigText(RecGAllConnectorMes."Fill Character",
                                                                BigTGEqualNbLineMainTable,
                                                                BigTGMergeInProgress,
                                                                BigTGFinal)
                    else
                        BigTGFinal.AddText(BigTGEqualNbLineMainTable);

                    Clear(BigTGMergeInProgress);
                    BigTGMergeInProgress.AddText(BigTGFinal);

                until RecGAllConnectorMes.Next() = 0;

            //*******************************************************************************************************************************
            //************************Second bloc*******************************************************************************************
            //*******************************************************************************************************************************

            Clear(BigTGOneLine);
            Clear(BigTGEqualNbLineMainTable);
            Clear(BigTGMergeInProgress);
            Clear(BigTGSecondBloc);

            RecGAllConnectorMes.Reset();
            RecGAllConnectorMes.SetRange("Partner Code", RecPConnectorMes."Partner Code");
            RecGAllConnectorMes.SetRange("Function", RecPConnectorMes."Function");
            RecGAllConnectorMes.SetRange(Direction, RecPConnectorMes.Direction::Export);
            if RecGAllConnectorMes.FindFirst() then
                repeat

                    case RecGAllConnectorMes."Table ID" of
                        //*********************************************************************************
                        //Table Principale
                        //*********************************************************************************
                        38:
                            begin
                                CodLDocNo := '0';
                                IntGNbLineMainTable := 0;
                                //Boucle pour récupérer autant de lignes ds le BigText, de la table 38, que celles générées pour les articles
                                if RecLPurchaseLine.FindSet() then
                                    repeat
                                        if CodLDocNo <> RecLPurchaseLine."Document No." then begin
                                            IntGNbLineMainTable += 1;
                                            Clear(BigTGOneLine);
                                            RecLPurchaseHeader.SetRange("Document Type", RecLPurchaseLine."Document Type");
                                            RecLPurchaseHeader.SetRange("No.", RecLPurchaseLine."Document No.");
                                            CduGConnectBufMgtExport.FctCreateBigTextWithPosition(RecLPurchaseHeader.GetView(),
                                                                                                 RecGAllConnectorMes, BigTGOneLine);
                                            CduGConnectBufMgtExport.FctConcatBigText(BigTGOneLine, BigTGEqualNbLineMainTable);
                                            CodLDocNo := RecLPurchaseLine."Document No.";
                                        end;
                                    until RecLPurchaseLine.Next() = 0;
                            end;

                        8073288:
                            begin
                                Clear(BigTGEqualNbLineMainTable);
                                //Boucle pour récupérer autant de lignes ds le BigText, de la table 8073288, que celles générées pour les articles
                                for IntGLoop := 1 to IntGNbLineMainTable do begin
                                    Clear(BigTGOneLine);
                                    CduGConnectBufMgtExport.FctCreateBigTextWithPosition('', RecGAllConnectorMes, BigTGOneLine);
                                    CduGConnectBufMgtExport.FctConcatBigText(BigTGOneLine, BigTGEqualNbLineMainTable);
                                end;
                            end;
                    end;

                    if BigTGMergeInProgress.Length <> 0 then
                        CduGConnectBufMgtExport.FctMergeBigText(RecGAllConnectorMes."Fill Character",
                                                                BigTGEqualNbLineMainTable,
                                                                BigTGMergeInProgress,
                                                                BigTGSecondBloc)
                    else
                        BigTGSecondBloc.AddText(BigTGEqualNbLineMainTable);

                    Clear(BigTGMergeInProgress);
                    BigTGMergeInProgress.AddText(BigTGSecondBloc);

                until RecGAllConnectorMes.Next() = 0;

            if BigTGFinal.Length <> 0 then

                //>>CED
                //BigTGFinal.ADDTEXT( FORMAT(ChrG13) + FORMAT(ChrG10) );
                BigTGSecondBloc.AddText(Format(ChrG13) + Format(ChrG10));
            //BigTGFinal.ADDTEXT(BigTGSecondBloc) ;
            BigTGSecondBloc.AddText(BigTGFinal);

            Clear(BigTGFinal);
            BigTGFinal.AddText(BigTGSecondBloc);
            //<<CED

            //Génération du blog avec le bigText mergé
            if BigTGFinal.Length <> 0 then
                CduGConnectBufMgtExport.FctGenerateBlob(BigTGFinal, TempBlob);

            RecLPurchaseLine.SetRange(RecLPurchaseLine."PWD WMS_Status");
            if RecLPurchaseLine.FindSet() then
                repeat
                    if (RecLPurchaseLine."PWD WMS_Status" = RecLPurchaseLine."PWD WMS_Status"::" ") then begin
                        RecLPurchaseLine."PWD WMS_Status" := RecLPurchaseLine."PWD WMS_Status"::Send;
                        RecLPurchaseLine.Modify();
                    end;
                until RecLPurchaseLine.Next() = 0;

        end;
    end;


    procedure FctGetCustOrderFilePos(RecPConnectorMes: Record "PWD Connector Messages"; var TempBlob: Codeunit "Temp Blob")
    var
        RecLConnectorsActivation: Record "PWD WMS Setup";
        RecLReservationEntry: Record "Reservation Entry";
        RecLSalesCommentLine: Record "Sales Comment Line";
        RecLSalesCommentLToSend: Record "Sales Comment Line";
        RecLSalesHeader: Record "Sales Header";
        RecLSalesLine: Record "Sales Line";
        BooLCommentPrepa: Boolean;
        CodLDocNo: Code[20];
        intLCommentLineNo: array[5] of Integer;
        intLLineNo: Integer;
    begin
        Clear(CduGConnectBufMgtExport);
        if not FctWMSEnabled() then
            exit;
        //Travail sur la table "PWD Connector Messages" afin de ne générer cette fonction qu'une fois, en prenant pour référence la table 37

        ChrG10 := 10;
        ChrG13 := 13;

        if RecPConnectorMes."Master Table" then begin
            Clear(BigTGFinal);
            Clear(BigTGMergeInProgress);
            //*******************************************************************************************************************************
            //************************Premier bloc*******************************************************************************************
            //*******************************************************************************************************************************

            if RecLConnectorsActivation.Get() then;

            //Sélections de toutes les lignes de la table "PWD Connector Messages" correspondant à la fonction à traiter
            RecGAllConnectorMes.Reset();
            RecGAllConnectorMes.SetRange("Partner Code", RecPConnectorMes."Partner Code");
            RecGAllConnectorMes.SetRange("Function", RecPConnectorMes."Function");
            RecGAllConnectorMes.SetRange(Direction, RecPConnectorMes.Direction::Export);
            RecGAllConnectorMes.SetCurrentKey("Master Table");
            RecGAllConnectorMes.Ascending(false);
            if RecGAllConnectorMes.FindFirst() then
                repeat

                    case RecGAllConnectorMes."Table ID" of
                        //*********************************************************************************
                        //Table Principale
                        //*********************************************************************************
                        37:
                            begin
                                RecLSalesLine.Reset();
                                RecLSalesLine.SetRange("Document Type", RecLSalesLine."Document Type"::Order);
                                RecLSalesLine.SetRange("Drop Shipment", false);
                                RecLSalesLine.SetRange(Type, RecLSalesLine.Type::Item);
                                RecLSalesLine.SetRange("PWD WMS_Status_Header", RecLSalesLine."PWD WMS_Status_Header"::Released);
                                RecLSalesLine.SetRange("PWD WMS_Item", true);
                                RecLSalesLine.SetRange("PWD WMS_Location", true);
                                RecLSalesLine.SetRange("PWD WMS_Cust_Blocked", RecLSalesLine."PWD WMS_Cust_Blocked"::" ");
                                RecLSalesLine.SetRange("PWD WMS_Status", RecLSalesLine."PWD WMS_Status"::" ");
                                RecLSalesLine.SetFilter("Outstanding Quantity", '<>%1', 0);
                                IntGNbLineMainTable := RecLSalesLine.Count;
                                Clear(BigTGEqualNbLineMainTable);
                                CduGConnectBufMgtExport.FctCreateBigTextWithPosition(RecLSalesLine.GetView(),
                                                                                     RecGAllConnectorMes, BigTGEqualNbLineMainTable);
                            end;

                        //*********************************************************************************
                        //Tables Secondaires
                        //*********************************************************************************
                        8073288:
                            begin
                                Clear(BigTGEqualNbLineMainTable);
                                //Boucle pour récupérer autant de lignes ds le BigText, de la table 8073288, que celles générées pour les articles
                                for IntGLoop := 1 to IntGNbLineMainTable do begin
                                    Clear(BigTGOneLine);
                                    CduGConnectBufMgtExport.FctCreateBigTextWithPosition('', RecGAllConnectorMes, BigTGOneLine);
                                    CduGConnectBufMgtExport.FctConcatBigText(BigTGOneLine, BigTGEqualNbLineMainTable);
                                end;
                            end;
                    end;

                    //Merge du bigtext obtenu sur la table traitée dans la boucle, avec le bigtext global
                    if BigTGMergeInProgress.Length <> 0 then
                        CduGConnectBufMgtExport.FctMergeBigText(RecGAllConnectorMes."Fill Character",
                                                                BigTGEqualNbLineMainTable,
                                                                BigTGMergeInProgress,
                                                                BigTGFinal)
                    else
                        BigTGFinal.AddText(BigTGEqualNbLineMainTable);

                    Clear(BigTGMergeInProgress);
                    BigTGMergeInProgress.AddText(BigTGFinal);

                until RecGAllConnectorMes.Next() = 0;

            //*************************************************************************************************************************
            //************************Second bloc**************************************************************************************
            //*************************************************************************************************************************

            Clear(BigTGOneLine);
            Clear(BigTGEqualNbLineMainTable);
            Clear(BigTGMergeInProgress);
            Clear(BigTGSecondBloc);

            RecGAllConnectorMes.Reset();
            RecGAllConnectorMes.SetRange("Partner Code", RecPConnectorMes."Partner Code");
            RecGAllConnectorMes.SetRange("Function", RecPConnectorMes."Function");
            RecGAllConnectorMes.SetRange(Direction, RecPConnectorMes.Direction::Export);
            if RecGAllConnectorMes.FindFirst() then
                repeat

                    case RecGAllConnectorMes."Table ID" of
                        337:
                            begin
                                CodLDocNo := '0';
                                IntGNbLineMainTable := 0;
                                //Boucle pour récupérer autant de lignes ds le BigText, de la table 38, que celles générées pour les articles

                                if RecLSalesLine.FindSet() then
                                    repeat
                                        if CodLDocNo <> RecLSalesLine."Document No." then begin
                                            IntGNbLineMainTable += 1;
                                            Clear(BigTGOneLine);
                                            RecLReservationEntry.Reset();
                                            RecLReservationEntry.SetRange("Source Type", DATABASE::"Sales Line");
                                            RecLReservationEntry.SetRange("Source ID", RecLSalesLine."Document No.");
                                            RecLReservationEntry.SetRange("Source Ref. No.", RecLSalesLine."Line No.");
                                            CduGConnectBufMgtExport.FctCreateBigTextWithPosition(RecLReservationEntry.GetView(), RecGAllConnectorMes, BigTGOneLine);
                                            CduGConnectBufMgtExport.FctConcatBigText(BigTGOneLine, BigTGEqualNbLineMainTable);
                                            CodLDocNo := RecLSalesLine."Document No.";
                                        end;
                                    until RecLSalesLine.Next() = 0;
                            end;
                    end;

                    if BigTGMergeInProgress.Length <> 0 then
                        CduGConnectBufMgtExport.FctMergeBigText(RecGAllConnectorMes."Fill Character",
                                                                BigTGEqualNbLineMainTable,
                                                                BigTGMergeInProgress,
                                                                BigTGSecondBloc)
                    else
                        BigTGSecondBloc.AddText(BigTGEqualNbLineMainTable);

                    Clear(BigTGMergeInProgress);
                    BigTGMergeInProgress.AddText(BigTGSecondBloc);

                until RecGAllConnectorMes.Next() = 0;

            if BigTGFinal.Length <> 0 then
                BigTGFinal.AddText(Format(ChrG13) + Format(ChrG10));
            BigTGFinal.AddText(BigTGSecondBloc);

            //**************************************************************************************************************************
            //************************Troisième bloc -> Kits à réaliser en vers FR******************************************************
            //**************************************************************************************************************************
            /*
            CLEAR(BigTGOneLine);
            CLEAR(BigTGEqualNbLineMainTable);
            CLEAR(BigTGMergeInProgress);
            CLEAR(BigTGSecondBloc);

            RecGAllConnectorMes.RESET;
            RecGAllConnectorMes.SETRANGE("Partner Code",RecPConnectorMes."Partner Code");
            RecGAllConnectorMes.SETRANGE("Function",RecPConnectorMes."Function");
            RecGAllConnectorMes.SETRANGE(Direction,RecPConnectorMes.Direction::Export);
            IF RecGAllConnectorMes.FINDFIRST THEN
            REPEAT

              CASE RecGAllConnectorMes."Table ID" OF
                25000:
                BEGIN
                  CodLDocNo := '0';
                  IntGNbLineMainTable := 0;
                  //Boucle pour récupérer autant de lignes ds le BigText, de la table 38, que celles générées pour les articles
                  //********************
                  //Ajouter filtre sur Kit line

                  IF RecLSalesLine.FINDSET THEN
                  REPEAT
                    IF CodLDocNo <> RecLSalesLine."Document No." THEN
                    BEGIN
                      IntGNbLineMainTable += 1;
                      CLEAR(BigTGOneLine);
                      //>>Travail sur Table ligne de kit

                      CduGConnectBufMgtExport.FctCreateBigTextWithPosition(RecLReservationEntry.GETVIEW,RecGAllConnectorMes,BigTGOneLine);
                      CduGConnectBufMgtExport.FctConcatBigText(BigTGOneLine,BigTGEqualNbLineMainTable);
                      CodLDocNo := RecLSalesLine."Document No.";
                    END;
                  UNTIL RecLSalesLine.NEXT = 0;
                END;
              END;

              IF BigTGMergeInProgress.LENGTH <> 0 THEN
                CduGConnectBufMgtExport.FctMergeBigText(RecGAllConnectorMes."Fill Character",
                                                        BigTGEqualNbLineMainTable,
                                                        BigTGMergeInProgress,
                                                        BigTGSecondBloc)
              ELSE
                BigTGSecondBloc.ADDTEXT(BigTGEqualNbLineMainTable) ;

              CLEAR(BigTGMergeInProgress);
              BigTGMergeInProgress.ADDTEXT(BigTGSecondBloc) ;

            UNTIL RecGAllConnectorMes.NEXT = 0;

            BigTGFinal.ADDTEXT( FORMAT(ChrG13) + FORMAT(ChrG10) );
            BigTGFinal.ADDTEXT(BigTGSecondBloc) ;
            */

            //**************************************************************************************************************************
            //************************Quatrième bloc, mis en premier********************************************************************
            //**************************************************************************************************************************
            Clear(BigTGOneLine);
            Clear(BigTGEqualNbLineMainTable);
            Clear(BigTGMergeInProgress);
            Clear(BigTGSecondBloc);
            Clear(BigTGFinal2);

            RecGAllConnectorMes.Reset();
            RecGAllConnectorMes.SetRange("Partner Code", RecPConnectorMes."Partner Code");
            RecGAllConnectorMes.SetRange("Function", RecPConnectorMes."Function");
            RecGAllConnectorMes.SetRange(Direction, RecPConnectorMes.Direction::Export);
            if RecGAllConnectorMes.FindFirst() then
                repeat
                    case RecGAllConnectorMes."Table ID" of
                        //*********************************************************************************
                        //Table Principale
                        //*********************************************************************************
                        36:
                            begin
                                CodLDocNo := '0';
                                IntGNbLineMainTable := 0;
                                //Boucle pour récupérer autant de lignes ds le BigText, de la table 38, que celles générées pour les articles

                                if RecLSalesLine.FindSet() then
                                    repeat
                                        if CodLDocNo <> RecLSalesLine."Document No." then begin
                                            IntGNbLineMainTable += 1;
                                            Clear(BigTGOneLine);
                                            RecLSalesHeader.SetRange("Document Type", RecLSalesLine."Document Type");
                                            RecLSalesHeader.SetRange("No.", RecLSalesLine."Document No.");
                                            CduGConnectBufMgtExport.FctCreateBigTextWithPosition(RecLSalesHeader.GetView(),
                                                                                                 RecGAllConnectorMes, BigTGOneLine);
                                            CduGConnectBufMgtExport.FctConcatBigText(BigTGOneLine, BigTGEqualNbLineMainTable);
                                            CodLDocNo := RecLSalesLine."Document No.";
                                            if RecLSalesHeader.FindFirst() then begin
                                                RecLSalesHeader."PWD WMS_Status" := RecLSalesHeader."PWD WMS_Status"::Send;
                                                RecLSalesHeader.Modify();
                                            end;
                                        end;
                                    until RecLSalesLine.Next() = 0;
                            end;

                        8073288:
                            begin
                                Clear(BigTGEqualNbLineMainTable);
                                //Boucle pour récupérer autant de lignes ds le BigText, de la table 8073288, que celles générées pour les articles
                                for IntGLoop := 1 to IntGNbLineMainTable do begin
                                    Clear(BigTGOneLine);
                                    CduGConnectBufMgtExport.FctCreateBigTextWithPosition('', RecGAllConnectorMes, BigTGOneLine);
                                    CduGConnectBufMgtExport.FctConcatBigText(BigTGOneLine, BigTGEqualNbLineMainTable);
                                end;
                            end;

                        //>>Gestion des commentaires en dur:
                        44:
                            begin
                                CodLDocNo := '0';

                                Clear(BigTGEqualNbLineMainTable);

                                //Boucle pour récupérer autant de lignes ds le BigText, de la table 44, que celles générées pour les articles
                                if RecLSalesLine.FindSet() then
                                    repeat
                                        if CodLDocNo <> RecLSalesLine."Document No." then begin
                                            Clear(intLCommentLineNo);
                                            Clear(BigTGOneLineComment);
                                            Clear(BigTGCommentMergeInProgress);
                                            intLLineNo := 1;
                                            BooLCommentPrepa := false;
                                            RecLSalesCommentLine.Reset();
                                            RecLSalesCommentLine.SetRange("Document Type", RecLSalesLine."Document Type");
                                            RecLSalesCommentLine.SetRange("No.", RecLSalesLine."Document No.");
                                            RecLSalesCommentLine.SetRange("Document Line No.", 0);
                                            if RecLSalesCommentLine.FindSet() then
                                                repeat
                                                    Clear(BigTGOneLine);
                                                    if RecLSalesCommentLine.Code = RecLConnectorsActivation."WMS Delivery" then
                                                        if intLLineNo < 5 then begin
                                                            RecLSalesCommentLToSend.Reset();
                                                            RecLSalesCommentLToSend.SetRange("Document Type", RecLSalesLine."Document Type");
                                                            RecLSalesCommentLToSend.SetRange("No.", RecLSalesLine."Document No.");
                                                            RecLSalesCommentLToSend.SetRange("Document Line No.", 0);
                                                            RecLSalesCommentLToSend.SetRange("Line No.", RecLSalesCommentLine."Line No.");

                                                            CduGConnectBufMgtExport.FctNbPosition(intLLineNo - 1);
                                                            CduGConnectBufMgtExport.FctCreateBigTextWithPosition(RecLSalesCommentLToSend.GetView(),
                                                                                                                   RecGAllConnectorMes, BigTGOneLine);
                                                            if BigTGCommentMergeInProgress.Length <> 0 then
                                                                CduGConnectBufMgtExport.FctMergeBigText(RecGAllConnectorMes."Fill Character",
                                                                                                        BigTGOneLine,
                                                                                                        BigTGCommentMergeInProgress,
                                                                                                        BigTGOneLineComment)
                                                            else
                                                                BigTGOneLineComment.AddText(BigTGOneLine);

                                                            Clear(BigTGCommentMergeInProgress);
                                                            BigTGCommentMergeInProgress.AddText(BigTGOneLineComment);
                                                            intLLineNo += 1;
                                                        end;

                                                    if ((RecLSalesCommentLine.Code = RecLConnectorsActivation."WMS Shipment") and (not BooLCommentPrepa)) then begin
                                                        RecLSalesCommentLToSend.Reset();
                                                        RecLSalesCommentLToSend.SetRange("Document Type", RecLSalesLine."Document Type");
                                                        RecLSalesCommentLToSend.SetRange("No.", RecLSalesLine."Document No.");
                                                        RecLSalesCommentLToSend.SetRange("Document Line No.", 0);
                                                        RecLSalesCommentLToSend.SetRange("Line No.", RecLSalesCommentLine."Line No.");

                                                        CduGConnectBufMgtExport.FctNbPosition(4);
                                                        CduGConnectBufMgtExport.FctCreateBigTextWithPosition(RecLSalesCommentLToSend.GetView(),
                                                                                                             RecGAllConnectorMes, BigTGOneLine);
                                                        BooLCommentPrepa := true;
                                                        if BigTGCommentMergeInProgress.Length <> 0 then
                                                            CduGConnectBufMgtExport.FctMergeBigText(RecGAllConnectorMes."Fill Character",
                                                                                                    BigTGOneLine,
                                                                                                    BigTGCommentMergeInProgress,
                                                                                                    BigTGOneLineComment)
                                                        else
                                                            BigTGOneLineComment.AddText(BigTGOneLine);

                                                        Clear(BigTGCommentMergeInProgress);
                                                        BigTGCommentMergeInProgress.AddText(BigTGOneLineComment);
                                                    end;
                                                until RecLSalesCommentLine.Next() = 0;
                                            CduGConnectBufMgtExport.FctConcatBigText(BigTGOneLineComment, BigTGEqualNbLineMainTable);
                                            CodLDocNo := RecLSalesLine."Document No.";
                                        end;

                                        RecLSalesLine."PWD WMS_Status" := RecLSalesLine."PWD WMS_Status"::Send;
                                        RecLSalesLine.Modify();

                                    until RecLSalesLine.Next() = 0;

                                CduGConnectBufMgtExport.FctNbPosition(0);
                            end;
                    end;

                    if BigTGMergeInProgress.Length <> 0 then
                        CduGConnectBufMgtExport.FctMergeBigText(RecGAllConnectorMes."Fill Character",
                                                                BigTGEqualNbLineMainTable,
                                                                BigTGMergeInProgress,
                                                                BigTGSecondBloc)
                    else
                        BigTGSecondBloc.AddText(BigTGEqualNbLineMainTable);

                    Clear(BigTGMergeInProgress);
                    BigTGMergeInProgress.AddText(BigTGSecondBloc);
                until RecGAllConnectorMes.Next() = 0;

            BigTGFinal2.AddText(BigTGSecondBloc);
            if BigTGFinal2.Length <> 0 then
                BigTGFinal2.AddText(Format(ChrG13) + Format(ChrG10));
            BigTGFinal2.AddText(BigTGFinal);

            //Génération du blog avec le bigText mergé
            if BigTGFinal2.Length <> 0 then
                CduGConnectBufMgtExport.FctGenerateBlob(BigTGFinal2, TempBlob);

        end;

    end;


    procedure FctGetAddressFilePos(RecPConnectorMes: Record "PWD Connector Messages"; var TempBlob: Codeunit "Temp Blob")
    begin
    end;


    procedure FctGetLogisticUnitsFilePos(RecPConnectorMes: Record "PWD Connector Messages"; var TempBlob: Codeunit "Temp Blob")
    var
        RecLItem: Record Item;
        RecLItemUnitofMeasure: Record "Item Unit of Measure";
    begin
        //Travail sur la table "PWD Connector Messages" afin de ne générer cette fonction qu'une fois, en prenant pour référence la table 5404
        if RecPConnectorMes."Master Table" then begin
            Clear(BigTGFinal);
            Clear(BigTGMergeInProgress);

            //Sélections de toutes les lignes de la table "PWD Connector Messages" correspondant à la fonction à traiter
            RecGAllConnectorMes.Reset();
            RecGAllConnectorMes.SetRange("Partner Code", RecPConnectorMes."Partner Code");
            RecGAllConnectorMes.SetRange("Function", RecPConnectorMes."Function");
            RecGAllConnectorMes.SetRange(Direction, RecPConnectorMes.Direction::Export);
            RecGAllConnectorMes.SetCurrentKey("Master Table");
            RecGAllConnectorMes.Ascending(false);
            if RecGAllConnectorMes.FindFirst() then
                repeat

                    //*********************************************************************************
                    //Table Principale
                    //*********************************************************************************

                    case RecGAllConnectorMes."Table ID" of
                        5404:
                            begin
                                RecLItemUnitofMeasure.Reset();
                                RecLItemUnitofMeasure.SetRange("PWD WMS_Item", true);
                                Clear(BigTGEqualNbLineMainTable);
                                IntGNbLineMainTable := RecLItemUnitofMeasure.Count;
                                CduGConnectBufMgtExport.FctCreateBigTextWithPosition(RecLItemUnitofMeasure.GetView(),
                                                                                     RecGAllConnectorMes, BigTGEqualNbLineMainTable);
                            end;

                        //*********************************************************************************
                        //Tables Secondaires
                        //*********************************************************************************
                        8073288:
                            begin
                                Clear(BigTGEqualNbLineMainTable);
                                //Boucle pour récupérer autant de lignes ds le BigText, de la table 8073288, que celles générées pour les articles
                                for IntGLoop := 1 to IntGNbLineMainTable do begin
                                    Clear(BigTGOneLine);
                                    CduGConnectBufMgtExport.FctCreateBigTextWithPosition('', RecGAllConnectorMes, BigTGOneLine);
                                    CduGConnectBufMgtExport.FctConcatBigText(BigTGOneLine, BigTGEqualNbLineMainTable);
                                end;
                            end;

                        27:
                            begin
                                Clear(BigTGEqualNbLineMainTable);
                                //Boucle pour récupérer autant de lignes ds le BigText, de la table 5404, que celles générées pour les articles
                                if RecLItemUnitofMeasure.FindSet() then
                                    repeat
                                        Clear(BigTGOneLine);
                                        RecLItem.SetRange("No.", RecLItemUnitofMeasure."Item No.");
                                        CduGConnectBufMgtExport.FctCreateBigTextWithPosition(RecLItem.GetView(), RecGAllConnectorMes, BigTGOneLine);
                                        CduGConnectBufMgtExport.FctConcatBigText(BigTGOneLine, BigTGEqualNbLineMainTable);
                                    until RecLItemUnitofMeasure.Next() = 0;
                            end;
                    end;

                    //Merge du bigtext obtenu sur la table traitée dans la boucle, avec le bigtext global
                    if BigTGMergeInProgress.Length <> 0 then
                        CduGConnectBufMgtExport.FctMergeBigText(RecGAllConnectorMes."Fill Character",
                                                                BigTGEqualNbLineMainTable,
                                                                BigTGMergeInProgress,
                                                                BigTGFinal)
                    else
                        BigTGFinal.AddText(BigTGEqualNbLineMainTable);

                    Clear(BigTGMergeInProgress);
                    BigTGMergeInProgress.AddText(BigTGFinal);

                until RecGAllConnectorMes.Next() = 0;

            //Génération du blog avec le bigText mergé
            if BigTGFinal.Length <> 0 then
                CduGConnectBufMgtExport.FctGenerateBlob(BigTGFinal, TempBlob);
        end;
    end;


    procedure FctGetKitMgtFilePos(RecPConnectorMes: Record "PWD Connector Messages"; var TempBlob: Codeunit "Temp Blob")
    var
        RecLProdBOMHeader: Record "Production BOM Header";
        RecLProdBOMLine: Record "Production BOM Line";
    begin
        //Travail sur la table "PWD Connector Messages" afin de ne générer cette fonction qu'une fois, en prenant pour référence la table
        //99000772

        if RecPConnectorMes."Master Table" then begin
            Clear(BigTGFinal);
            Clear(BigTGMergeInProgress);

            //Sélections de toutes les lignes de la table "PWD Connector Messages" correspondant à la fonction à traiter
            RecGAllConnectorMes.Reset();
            RecGAllConnectorMes.SetRange("Partner Code", RecPConnectorMes."Partner Code");
            RecGAllConnectorMes.SetRange("Function", RecPConnectorMes."Function");
            RecGAllConnectorMes.SetRange(Direction, RecPConnectorMes.Direction::Export);
            RecGAllConnectorMes.SetCurrentKey("Master Table");
            RecGAllConnectorMes.Ascending(false);
            if RecGAllConnectorMes.FindFirst() then begin
                FctUpdateProdBomLine();

                repeat
                    //*********************************************************************************
                    //Table Principale
                    //*********************************************************************************

                    case RecGAllConnectorMes."Table ID" of
                        99000772:
                            begin
                                RecLProdBOMLine.Reset();
                                RecLProdBOMLine.SetRange("PWD WMS_Item", true);
                                RecLProdBOMLine.SetRange("PWD WMS_Status", RecLProdBOMLine."PWD WMS_Status"::Certified);
                                //************************************************************
                                //Ajout control sur type: Kitting de l'entete, pour base FR, en créant un flowfield de type lookup sur les lignes
                                //************************************************************
                                Clear(BigTGEqualNbLineMainTable);
                                IntGNbLineMainTable := RecLProdBOMLine.Count;
                                CduGConnectBufMgtExport.FctCreateBigTextWithPosition(RecLProdBOMLine.GetView(),
                                                                                     RecGAllConnectorMes, BigTGEqualNbLineMainTable);
                            end;

                        //*********************************************************************************
                        //Tables Secondaires
                        //*********************************************************************************
                        8073288:
                            begin
                                Clear(BigTGEqualNbLineMainTable);
                                //Boucle pour récupérer autant de lignes ds le BigText, de la table 8073288, que celles générées pour les articles
                                for IntGLoop := 1 to IntGNbLineMainTable do begin
                                    Clear(BigTGOneLine);
                                    CduGConnectBufMgtExport.FctCreateBigTextWithPosition('', RecGAllConnectorMes, BigTGOneLine);
                                    CduGConnectBufMgtExport.FctConcatBigText(BigTGOneLine, BigTGEqualNbLineMainTable);
                                end;
                            end;

                        99000771:
                            begin
                                Clear(BigTGEqualNbLineMainTable);
                                //Boucle pour récupérer autant de lignes ds le BigText, de la table 99000771, que celles générées pour les articles
                                //************************************************************
                                //Ajout control sur type: Kitting de l'entete, pour base FR
                                //************************************************************

                                if RecLProdBOMLine.FindSet() then
                                    repeat
                                        Clear(BigTGOneLine);
                                        RecLProdBOMHeader.SetRange("No.", RecLProdBOMLine."Production BOM No.");
                                        RecLProdBOMHeader.SetRange("Version Nos.", RecLProdBOMLine."Version Code");
                                        CduGConnectBufMgtExport.FctCreateBigTextWithPosition(RecLProdBOMHeader.GetView(), RecGAllConnectorMes, BigTGOneLine);
                                        CduGConnectBufMgtExport.FctConcatBigText(BigTGOneLine, BigTGEqualNbLineMainTable);
                                    until RecLProdBOMLine.Next() = 0;
                            end;
                    end;

                    //Merge du bigtext obtenu sur la table traitée dans la boucle, avec le bigtext global
                    if BigTGMergeInProgress.Length <> 0 then
                        CduGConnectBufMgtExport.FctMergeBigText(RecGAllConnectorMes."Fill Character",
                                                                BigTGEqualNbLineMainTable,
                                                                BigTGMergeInProgress,
                                                                BigTGFinal)
                    else
                        BigTGFinal.AddText(BigTGEqualNbLineMainTable);

                    Clear(BigTGMergeInProgress);
                    BigTGMergeInProgress.AddText(BigTGFinal);

                until RecGAllConnectorMes.Next() = 0;
            end;

            //Génération du blog avec le bigText mergé
            if BigTGFinal.Length <> 0 then
                CduGConnectBufMgtExport.FctGenerateBlob(BigTGFinal, TempBlob);
        end;
    end;


    procedure FctCreateCustShipFilePos(RecPConnectorMes: Record "PWD Connector Messages"; var TempBlob: Codeunit "Temp Blob")
    var
        RecLCustomer: Record Customer;
        RecLShipToAddress: Record "Ship-to Address";
    begin
        if not FctWMSEnabled() then
            exit;
        //Travail sur la table "PWD Connector Messages" afin de ne générer cette fonction qu'une fois, en prenant pour référence la table 39

        ChrG10 := 10;
        ChrG13 := 13;

        if RecPConnectorMes."Master Table" then begin
            Clear(BigTGFinal);
            Clear(BigTGMergeInProgress);
            //*******************************************************************************************************************************
            //************************Premier bloc*******************************************************************************************
            //*******************************************************************************************************************************

            //Sélections de toutes les lignes de la table "PWD Connector Messages" correspondant à la fonction à traiter
            RecGAllConnectorMes.Reset();
            RecGAllConnectorMes.SetRange("Partner Code", RecPConnectorMes."Partner Code");
            RecGAllConnectorMes.SetRange("Function", RecPConnectorMes."Function");
            RecGAllConnectorMes.SetRange(Direction, RecPConnectorMes.Direction::Export);
            RecGAllConnectorMes.SetCurrentKey("Master Table");
            RecGAllConnectorMes.Ascending(false);
            if RecGAllConnectorMes.FindFirst() then
                repeat
                    case RecGAllConnectorMes."Table ID" of
                        18:
                            begin
                                RecLCustomer.Reset();
                                RecLCustomer.SetRange(Blocked, RecLCustomer.Blocked::" ");
                                //************************************************************
                                //Ajout control sur type: Kitting de l'entete, pour base FR, en créant un flowfield de type lookup sur les lignes
                                //************************************************************
                                Clear(BigTGEqualNbLineMainTable);
                                IntGNbLineMainTable := RecLCustomer.Count;
                                CduGConnectBufMgtExport.FctCreateBigTextWithPosition(RecLCustomer.GetView(),
                                                                                     RecGAllConnectorMes, BigTGEqualNbLineMainTable);
                            end;

                        //*********************************************************************************
                        //Tables Secondaires
                        //*********************************************************************************
                        8073288:
                            begin
                                Clear(BigTGEqualNbLineMainTable);
                                //Boucle pour récupérer autant de lignes ds le BigText, de la table 8073288, que celles générées pour les articles
                                for IntGLoop := 1 to IntGNbLineMainTable do begin
                                    Clear(BigTGOneLine);
                                    CduGConnectBufMgtExport.FctCreateBigTextWithPosition('', RecGAllConnectorMes, BigTGOneLine);
                                    CduGConnectBufMgtExport.FctConcatBigText(BigTGOneLine, BigTGEqualNbLineMainTable);
                                end;
                            end;
                    end;

                    //Merge du bigtext obtenu sur la table traitée dans la boucle, avec le bigtext global
                    if BigTGMergeInProgress.Length <> 0 then
                        CduGConnectBufMgtExport.FctMergeBigText(RecGAllConnectorMes."Fill Character",
                                                                BigTGEqualNbLineMainTable,
                                                                BigTGMergeInProgress,
                                                                BigTGFinal)
                    else
                        BigTGFinal.AddText(BigTGEqualNbLineMainTable);

                    Clear(BigTGMergeInProgress);
                    BigTGMergeInProgress.AddText(BigTGFinal);

                until RecGAllConnectorMes.Next() = 0;

            //*******************************************************************************************************************************
            //************************Second bloc*******************************************************************************************
            //*******************************************************************************************************************************

            Clear(BigTGOneLine);
            Clear(BigTGEqualNbLineMainTable);
            Clear(BigTGMergeInProgress);
            Clear(BigTGSecondBloc);

            RecGAllConnectorMes.Reset();
            RecGAllConnectorMes.SetRange("Partner Code", RecPConnectorMes."Partner Code");
            RecGAllConnectorMes.SetRange("Function", RecPConnectorMes."Function");
            RecGAllConnectorMes.SetRange(Direction, RecPConnectorMes.Direction::Export);
            if RecGAllConnectorMes.FindFirst() then
                repeat

                    case RecGAllConnectorMes."Table ID" of
                        //*********************************************************************************
                        //Table Principale
                        //*********************************************************************************
                        222:
                            begin
                                IntGNbSecondBloc := 0;
                                Clear(BigTGEqualNbLineMainTable);
                                Clear(BigTGSecondBloc);
                                if RecLCustomer.FindSet() then
                                    repeat
                                        Clear(BigTGOneLine);
                                        RecLShipToAddress.Reset();
                                        RecLShipToAddress.SetRange("Customer No.", RecLCustomer."No.");
                                        IntGNbSecondBloc += RecLShipToAddress.Count;
                                        if RecLShipToAddress.FindFirst() then begin
                                            CduGConnectBufMgtExport.FctCreateBigTextWithPosition(RecLShipToAddress.GetView(),
                                                                                                 RecGAllConnectorMes, BigTGOneLine);
                                            CduGConnectBufMgtExport.FctConcatBigText(BigTGOneLine, BigTGEqualNbLineMainTable);
                                        end;
                                    until RecLCustomer.Next() = 0;
                            end;

                        8073288:
                            begin
                                Clear(BigTGEqualNbLineMainTable);
                                //Boucle pour récupérer autant de lignes ds le BigText, de la table 8073288, que celles générées pour les articles
                                for IntGLoop := 1 to IntGNbSecondBloc do begin
                                    Clear(BigTGOneLine);
                                    CduGConnectBufMgtExport.FctCreateBigTextWithPosition('', RecGAllConnectorMes, BigTGOneLine);
                                    CduGConnectBufMgtExport.FctConcatBigText(BigTGOneLine, BigTGEqualNbLineMainTable);
                                end;
                            end;
                    end;

                    if BigTGMergeInProgress.Length <> 0 then
                        CduGConnectBufMgtExport.FctMergeBigText(RecGAllConnectorMes."Fill Character",
                                                                BigTGEqualNbLineMainTable,
                                                                BigTGMergeInProgress,
                                                                BigTGSecondBloc)
                    else
                        BigTGSecondBloc.AddText(BigTGEqualNbLineMainTable);

                    Clear(BigTGMergeInProgress);
                    BigTGMergeInProgress.AddText(BigTGSecondBloc);

                until RecGAllConnectorMes.Next() = 0;

            if BigTGFinal.Length <> 0 then
                BigTGFinal.AddText(Format(ChrG13) + Format(ChrG10));
            BigTGFinal.AddText(BigTGSecondBloc);


            //Génération du blog avec le bigText mergé
            if BigTGFinal.Length <> 0 then
                CduGConnectBufMgtExport.FctGenerateBlob(BigTGFinal, TempBlob);
        end;
    end;


    procedure FctImportVendShipFilePos(var RecPConnectorValues: Record "PWD Connector Values")
    begin
    end;


    procedure FctUpdateProdBomLine()
    var
        RecLItemUnitMeas: Record "Item Unit of Measure";
        RecLProdBomLine: Record "Production BOM Line";
    begin
        RecLProdBomLine.Reset();
        if RecLProdBomLine.FindSet() then
            repeat
                if RecLItemUnitMeas.Get(RecLProdBomLine."No.", RecLProdBomLine."Unit of Measure Code") then
                    RecLProdBomLine."PWD WMS_Quantity_Per(Base)" := RecLProdBomLine.Quantity * RecLItemUnitMeas."Qty. per Unit of Measure"
                else
                    RecLProdBomLine."PWD WMS_Quantity_Per(Base)" := 0;
                RecLProdBomLine.Modify(false);
            until RecLProdBomLine.Next() = 0;
    end;


    procedure FctWMSEnabled(): Boolean
    var
        RecLConnectorsActivation: Record "PWD WMS Setup";
    begin
        if RecLConnectorsActivation.Get() then;
        exit(RecLConnectorsActivation.WMS);
    end;


    procedure FctChangePurchOrderStatus(var RecPPurchaseLine: Record "Purchase Line")
    begin
        if RecPPurchaseLine."PWD WMS_Status" = RecPPurchaseLine."PWD WMS_Status"::Send then begin
            RecPPurchaseLine."PWD WMS_Status" := RecPPurchaseLine."PWD WMS_Status"::" ";
            RecPPurchaseLine.Modify();
        end;
    end;


    procedure FctChangeSalesOrderLineStatus(var RecPSalesLine: Record "Sales Line")
    begin
        if RecPSalesLine."PWD WMS_Status" = RecPSalesLine."PWD WMS_Status"::Send then begin
            RecPSalesLine."PWD WMS_Status" := RecPSalesLine."PWD WMS_Status"::" ";
            RecPSalesLine.Modify();
        end;
    end;


    procedure FctChangeSalesOrderHeadeStatus(var RecPSalesHeader: Record "Sales Header")
    var
        RecLSalesLines: Record "Sales Line";
    begin
        if RecPSalesHeader."PWD WMS_Status" = RecPSalesHeader."PWD WMS_Status"::Send then begin
            RecPSalesHeader."PWD WMS_Status" := RecPSalesHeader."PWD WMS_Status"::" ";
            RecPSalesHeader.Modify();

            RecLSalesLines.Reset();
            RecLSalesLines.SetRange("Document Type", RecPSalesHeader."Document Type");
            RecLSalesLines.SetRange("Document No.", RecPSalesHeader."No.");
            if RecLSalesLines.FindSet() then
                repeat
                    FctChangeSalesOrderLineStatus(RecLSalesLines);
                    RecLSalesLines.Modify();
                until RecLSalesLines.Next() = 0;
        end;
    end;

    procedure FctUpdateReceiptLine(var RecPPurchaseLine: Record "Purchase Line"; var IntPEntryBufferNo: Integer)
    var
        RecLReceiptLineBuffer: Record "PWD Receipt Line Buffer";
        RecLWMSReceiptLineBuffer: Record "PWD WMS Receipt Line Buffer";
        DecLQtyError: Decimal;
    begin
        //>>OSYS-Int001.001
        RecLReceiptLineBuffer.Get(IntPEntryBufferNo);
        if not FctIsTheSamePartener(RecLReceiptLineBuffer."Partner Code") then
            exit;
        //<<OSYS-Int001.001

        //>>WMS-FE007_15.001
        RecLWMSReceiptLineBuffer.Get(IntPEntryBufferNo);
        //Placer les champs spécifiques WMS

        if RecLWMSReceiptLineBuffer."Qty on receipt error (Base)" <> '' then begin
            Evaluate(DecLQtyError, RecLWMSReceiptLineBuffer."Qty on receipt error (Base)");
            RecPPurchaseLine.Validate("PWD WMS_Qty receipt error (Base)", DecLQtyError);
        end;

        RecPPurchaseLine.Validate("PWD WMS_Reason Code Receipt Error", RecLWMSReceiptLineBuffer."Reason Code Receipt Error");
        RecPPurchaseLine.Validate("PWD WMS_Status", RecPPurchaseLine."PWD WMS_Status"::Received);

        RecPPurchaseLine.CalcFields("PWD WMS_Item");
        RecPPurchaseLine.TestField("PWD WMS_Item");

        RecPPurchaseLine.CalcFields("PWD WMS_Location");
        RecPPurchaseLine.TestField("PWD WMS_Location");
        //<<WMS-FE007_15.001
    end;


    procedure FctCreateReceiptLine(var RecPConnectorVal: Record "PWD Connector Values")
    var
        RecLReceiptLineBuffer: Record "PWD Receipt Line Buffer";
        RecLWMSReceiptLineBuffer: Record "PWD WMS Receipt Line Buffer";
        CduLBinaryFileManagement: Codeunit "PWD Binary File Management";
        RecordRef: RecordRef;
        InSLInStream: InStream;
    begin
        //>>WMS-FE007_15.001
        //**********************************************************************************************************//
        //                             Create a customer, by using Xml Management.                                  //
        //                                                                                                          //
        // Parameters:                                                                                              //
        //         1  :  CODE SOCIETE                                                                               //
        //         2  :  N° DE COMMANDE FOURNISSEUR                                                                 //
        //         3  :  CODE DEPOT                                                                                 //
        //         4  :  DATE/HEURE DE LIVRAISON PREVUE                                                             //
        //         5  :  N° DE LIGNE APPROVISIONNEMENT                                                              //
        //         6  :  CODE ARTICLE                                                                               //
        //         7  :  VARIANTE PROMOTIONNELLE                                                                    //
        //         8  :  VARIANTE ARTICLE                                                                           //
        //         9  :  UNITE LOGISTIQUE                                                                           //
        //        10  :  QUANTITE COMMANDEE  EN UNITE CONSOMMATEUR                                                  //
        //        11  :  QUANTITE RECUE EN UNITE CONSOMMATEUR                                                       //
        //        12  :  POIDS RECU                                                                                 //
        //        13  :  DLC/DLUO RECEPTIONNEE                                                                      //
        //        14  :  QUANTITE EN ANOMALIE DE RECEPTION                                                          //
        //        15  :  CODE MOTIF ANOMALIE DE RECEPTION                                                           //
        //        16  :  N° LOT                                                                                     //
        //        17  :  N° SERIE                                                                                   //
        //**********************************************************************************************************//

        RecPConnectorVal.CalcFields(Blob);
        RecPConnectorVal.Blob.CreateInStream(InSLInStream);

        CduLBinaryFileManagement.FctOpenStream(InSLInStream);
        CduLBinaryFileManagement.FctDefineSeparatorAndDelemiter(RecPConnectorVal);

        while (not CduLBinaryFileManagement.FctReadLine()) do begin

            RecLReceiptLineBuffer.Get(
                           CduGBufferManagement.FctNewBufferLine(DATABASE::"PWD Receipt Line Buffer", RecPConnectorVal, 2));
            RecLReceiptLineBuffer."Document Type" := RecLReceiptLineBuffer."Document Type"::Order;
            RecLReceiptLineBuffer."Document No." := CduLBinaryFileManagement.FctReturnFixData(2, 20);
            RecLReceiptLineBuffer."Document Line No." := CduLBinaryFileManagement.FctReturnFixData(44, 20);
            RecLReceiptLineBuffer."Location Code" := CduLBinaryFileManagement.FctReturnFixData(22, 10);
            RecLReceiptLineBuffer.Type := RecLReceiptLineBuffer.Type::Item;
            RecLReceiptLineBuffer."No." := CduLBinaryFileManagement.FctReturnFixData(64, 20);
            RecLReceiptLineBuffer."Variant Code" := CduLBinaryFileManagement.FctReturnFixData(86, 10);
            RecLReceiptLineBuffer."Unit of Measure" := CduLBinaryFileManagement.FctReturnFixData(96, 10);
            RecLReceiptLineBuffer."Initial Quantity (Base)" := CduLBinaryFileManagement.FctReturnFixData(106, 8);
            RecLReceiptLineBuffer."Receipt Quantity (Base)" := CduLBinaryFileManagement.FctReturnFixData(114, 8);
            RecLReceiptLineBuffer."Expiration Date" := CduLBinaryFileManagement.FctReturnFixData(131, 8);
            RecLReceiptLineBuffer."Serial No." := CduLBinaryFileManagement.FctReturnFixData(149, 20);
            RecLReceiptLineBuffer."Lot No." := CduLBinaryFileManagement.FctReturnFixData(169, 20);
            RecLReceiptLineBuffer.Modify();

            Clear(RecordRef);
            RecordRef.GetTable(RecLReceiptLineBuffer);
            RecLWMSReceiptLineBuffer.Get(CduGBufferManagement.FctDuplicateBuffer(DATABASE::"PWD WMS Receipt Line Buffer", RecordRef));
            //Placer les champs spécifiques WMS
            RecLWMSReceiptLineBuffer."Qty on receipt error (Base)" := CduLBinaryFileManagement.FctReturnFixData(139, 8);
            RecLWMSReceiptLineBuffer."Reason Code Receipt Error" := CduLBinaryFileManagement.FctReturnFixData(147, 2);
            RecLWMSReceiptLineBuffer."Posting Date" := CduLBinaryFileManagement.FctReturnFixData(32, 12);
            RecLWMSReceiptLineBuffer.Modify();
        end;
        //<<WMS-FE007_15.001
    end;

    procedure FctUpdateItemJournaLineWMS(var RecPItemJounalLine: Record "Item Journal Line"; var IntPEntryBufferNo: Integer)
    var
        RecLItem: Record Item;
        RecLLocation: Record Location;
        RecLItemJounalLineBuffer: Record "PWD Item Jounal Line Buffer";
        RecWMSItemJounalLineBuffer: Record "PWD WMS Item Jnl Line Buffer";
        RecLWMSetup: Record "PWD WMS Setup";
        RecLReason: Record "Reason Code";
        CstL000: Label 'The field %1 must be "O" or "N" in table %2, EntryNo.: %3';
    begin
        if not FctWMSEnabled() then
            exit;

        //>>OSYS-Int001.001
        RecLItemJounalLineBuffer.Get(IntPEntryBufferNo);
        if not FctIsTheSamePartener(RecLItemJounalLineBuffer."Partner Code") then
            exit;
        //<<OSYS-Int001.001

        if RecWMSItemJounalLineBuffer.Get(IntPEntryBufferNo) then begin
            //Placer les champs spécifiques WMS


            //Règle de gestion spécifique WMS
            if RecLWMSetup.Get() then;
            RecWMSItemJounalLineBuffer.TestField("WMS Company Code", RecLWMSetup."WMS Company Code");
            RecLItem.Get(RecPItemJounalLine."Item No.");
            RecLItem.TestField("PWD WMS_Item");
            RecLLocation.Get(RecPItemJounalLine."Location Code");
            RecLLocation.TestField("PWD WMS_Location");
            RecLReason.Reset();
            RecLReason.SetRange("PWD WMS Code", RecWMSItemJounalLineBuffer."WMS Reson Code");
            RecLReason.FindFirst();
            if (RecPItemJounalLine."Reason Code" <> 'O') and (RecPItemJounalLine."Reason Code" <> 'N') then
                Error(StrSubstNo(CstL000, RecPItemJounalLine.FieldCaption("Reason Code"),
                                          RecPItemJounalLine.TableCaption, IntPEntryBufferNo));
            if RecPItemJounalLine."Reason Code" = 'O' then
                RecPItemJounalLine."Entry Type" := RecPItemJounalLine."Entry Type"::"Positive Adjmt."
            else
                RecPItemJounalLine."Entry Type" := RecPItemJounalLine."Entry Type";
            RecPItemJounalLine."Reason Code" := RecLReason.Code;
            RecPItemJounalLine."Source Type" := RecPItemJounalLine."Source Type"::Item;
        end;
    end;


    procedure FctImportInventory(var RecPConnectorValues: Record "PWD Connector Values")
    begin
        case RecPConnectorValues."File format" of
            RecPConnectorValues."File format"::Xml:
                FctImportInventoryXML(RecPConnectorValues);
            RecPConnectorValues."File format"::"with separator":
                FctImportInventoryWithSep(RecPConnectorValues);
            RecPConnectorValues."File format"::"File Position":
                FctImportInventoryFilePos(RecPConnectorValues);
        end;
    end;


    procedure FctImportInventoryFilePos(var RecPConnectorValues: Record "PWD Connector Values")
    var
        RecLItemJounalLineBuffer: Record "PWD Item Jounal Line Buffer";
        RecLItemJounalLineBufferWMS: Record "PWD WMS Item Jnl Line Buffer";
        RecLConnectorsActivation: Record "PWD WMS Setup";
        BigLText: BigText;
        RecordRef: RecordRef;
        InSLInStream: InStream;
        TxtLLine: Text[1024];
    begin
        //**********************************************************************************************************//
        //                             Import Invetory Line  WMS                                                    //
        //                                                                                                          //
        // Parameters:                                                                                              //
        //         1  :  CODE DEPOT                     (1,10)                                                      //
        //         2  :  CODE SOCIETE                   (11,2)                                                      //
        //         3  :  CODE ARTICLE                   (13,20)                                                     //
        //         4  :  CODE VARIANTE PROMOTIONNELLE   (33,2)                                                      //
        //         5  :  VARIANTE ARTICLE               (35,10)                                                     //
        //         6  :  CODE MOUVEMENT DE STOCK        (45,1)                                                      //
        //         7  :  QUANTITE EN UNITE CONSOMMATEUR (46,8)                                                      //
        //         8  :  LIBELLE MOUVEMENT              (54,50)                                                     //
        //         9  :  DATE DU MOUVEMENT              (104,12)                                                    //
        //        10  :  CODE MOTIF MOUVEMENT DE STOCK  (116,2)                                                     //
        //        11  :  NUMERO DE LOT                  (118,20)                                                    //
        //        12  :  DLC/DLUO                       (138,8)                                                     //
        //        13  :  TYPE D'OPERATION               (146,2)                                                     //
        //        14  :  ANNEE D'OPERATION              (148,4)                                                     //
        //        15  :  N° D'OPERATION                 (152,4)                                                     //
        //        16  :  CODE QUARANTAINE               (156,2)                                                     //
        //        17  :  N° SERIE                       (158,20)                                                    //
        //**********************************************************************************************************//

        RecLConnectorsActivation.Get();
        RecPConnectorValues.CalcFields(Blob);
        RecPConnectorValues.Blob.CreateInStream(InSLInStream);
        while (InSLInStream.ReadText(TxtLLine) > 0) do begin
            Clear(BigLText);
            BigLText.AddText(TxtLLine);
            RecLItemJounalLineBuffer.Get(CduGBufferManagement.FctNewBufferLine(DATABASE::"PWD Item Jounal Line Buffer", RecPConnectorValues, 1));
            RecLItemJounalLineBuffer."Journal Batch Name" := RecLConnectorsActivation."Journal Batch Name";
            RecLItemJounalLineBuffer."Journal Template Name" := RecLConnectorsActivation."Journal Template Name";
            BigLText.GetSubText(RecLItemJounalLineBuffer."Item No.", 13, 20);
            BigLText.GetSubText(RecLItemJounalLineBuffer.Description, 54, 50);
            BigLText.GetSubText(RecLItemJounalLineBuffer."Location Code", 1, 10);
            BigLText.GetSubText(RecLItemJounalLineBuffer.Quantity, 46, 8);
            BigLText.GetSubText(RecLItemJounalLineBuffer."Reason Code", 45, 1);
            BigLText.GetSubText(RecLItemJounalLineBuffer."Serial No.", 158, 20);
            BigLText.GetSubText(RecLItemJounalLineBuffer."Lot No.", 118, 20);
            BigLText.GetSubText(RecLItemJounalLineBuffer."Expiration Date", 138, 8);
            BigLText.GetSubText(RecLItemJounalLineBuffer."Variant Code", 35, 10);
            RecLItemJounalLineBuffer."Source Type" := RecLItemJounalLineBuffer."Source Type"::Item;
            if RecLItemJounalLineBuffer."Reason Code" = 'O' then
                RecLItemJounalLineBuffer."Entry Type" := RecLItemJounalLineBuffer."Entry Type"::"Positive Adjmt.";
            if RecLItemJounalLineBuffer."Reason Code" = 'N' then
                RecLItemJounalLineBuffer."Entry Type" := RecLItemJounalLineBuffer."Entry Type"::"Negative Adjmt.";

            RecLItemJounalLineBuffer.Modify();

            Clear(RecordRef);

            RecordRef.GetTable(RecLItemJounalLineBuffer);
            RecLItemJounalLineBufferWMS.Get(CduGBufferManagement.FctDuplicateBuffer(DATABASE::"PWD WMS Item Jnl Line Buffer", RecordRef));
            //Placer les champs spécifiques WMS
            BigLText.GetSubText(RecLItemJounalLineBufferWMS."WMS Reson Code", 116, 2);
            BigLText.GetSubText(RecLItemJounalLineBufferWMS."WMS Company Code", 11, 2);
            RecLItemJounalLineBufferWMS.Modify();
        end;
        //<<WMS-FE007_15.001
    end;


    procedure FctImportInventoryWithSep(var RecPConnectorValues: Record "PWD Connector Values")
    begin
        //A définir
    end;


    procedure FctImportInventoryXML(var RecPConnectorValues: Record "PWD Connector Values")
    begin
        //A définir
    end;

    procedure FctUpdateShipmentLine(var RecPSalesLine: Record "Sales Line"; var IntPEntryBufferNo: Integer)
    var
        RecLSalesLineBuffer: Record "PWD Sales Line Buffer";
        RecLWMSShipmentLineBuffer: Record "PWD WMS Sales Line Buffer";
    begin
        //>>OSYS-Int001.001
        RecLSalesLineBuffer.Get(IntPEntryBufferNo);
        if not FctIsTheSamePartener(RecLSalesLineBuffer."Partner Code") then
            exit;
        //<<OSYS-Int001.001

        RecLWMSShipmentLineBuffer.Get(IntPEntryBufferNo);

        RecPSalesLine.Validate("PWD WMS_Status", RecPSalesLine."PWD WMS_Status"::Received);

        RecPSalesLine.CalcFields("PWD WMS_Item");
        RecPSalesLine.TestField("PWD WMS_Item");

        RecPSalesLine.CalcFields("PWD WMS_Location");
        RecPSalesLine.TestField("PWD WMS_Location");
    end;


    procedure FctImportShipmentLineFilePos(var RecPConnectorValues: Record "PWD Connector Values")
    var
        RecLShipmentLineBuffer: Record "PWD Sales Line Buffer";
        RecLWMSShipmentLineBuffer: Record "PWD WMS Sales Line Buffer";
        CduLBinaryFileManagement: Codeunit "PWD Binary File Management";
        RecordRef: RecordRef;
        InSLInStream: InStream;
    begin
        //**********************************************************************************************************//
        //                                         Create sales line.                                               //
        //                                                                                                          //
        // Parameters:                                                                                              //
        //         1  :  CODE SOCIETE                                                                               //
        //         2  :  N° DE COMMANDE VENTE                                                                       //
        //         3  :  N° DE FOLIO COMMANDE VENTE                                                                 //
        //         4  :  N° ORDRE DE PREPARATION                                                                    //
        //         5  :  N° LIGNE DE COMMANDE VENTE                                                                 //
        //         6  :  N° LIGNE DE COMMANDE ASSOCIE                                                               //
        //         7  :  CODE ARTICLE COMMANDE                                                                      //
        //         8  :  CODE VARIANTE PROMOTIONNELLE COMMANDEE                                                     //
        //         9  :  VARIANTE ARTICLE COMMANDEE                                                                 //
        //        10  :  QUANTITE COMMANDEE EN UC                                                                   //
        //        11  :  DLC/DLUO MINIMUM COMMANDEE                                                                 //
        //        12  :  NUMERO DE LOT COMMANDE                                                                     //
        //        13  :  CODE ARTICLE LIVRE                                                                         //
        //        14  :  CODE VARIANTE PROMOTIONNELLE LIVREE                                                        //
        //        15  :  VARIANTE ARTICLE LIVREE                                                                    //
        //        16  :  QUANTITE LIVREE                                                                            //
        //        17  :  POIDS LIVRE                                                                                //
        //        18  :  QUANTITE EN RUPTURE EN UC                                                                  //
        //        19  :  N° SERIE                                                                                   //
        //**********************************************************************************************************//

        RecPConnectorValues.CalcFields(Blob);
        RecPConnectorValues.Blob.CreateInStream(InSLInStream);

        CduLBinaryFileManagement.FctOpenStream(InSLInStream);
        CduLBinaryFileManagement.FctDefineSeparatorAndDelemiter(RecPConnectorValues);

        while (not CduLBinaryFileManagement.FctReadLine()) do begin

            RecLShipmentLineBuffer.Get(
                           CduGBufferManagement.FctNewBufferLine(DATABASE::"PWD Sales Line Buffer", RecPConnectorValues, 2));
            RecLShipmentLineBuffer."Document Type" := RecLShipmentLineBuffer."Document Type"::Order;
            RecLShipmentLineBuffer."Document No." := CduLBinaryFileManagement.FctReturnFixData(3, 20);
            RecLShipmentLineBuffer."Document Line No." := CduLBinaryFileManagement.FctReturnFixData(33, 20);
            RecLShipmentLineBuffer.Type := RecLShipmentLineBuffer.Type::Item;
            RecLShipmentLineBuffer."No." := CduLBinaryFileManagement.FctReturnFixData(55, 20);
            RecLShipmentLineBuffer."Variant Code" := CduLBinaryFileManagement.FctReturnFixData(77, 10);
            RecLShipmentLineBuffer."Initial Quantity (Base)" := CduLBinaryFileManagement.FctReturnFixData(87, 6);
            RecLShipmentLineBuffer."Qty. to Ship (Base)" := CduLBinaryFileManagement.FctReturnFixData(146, 6);
            RecLShipmentLineBuffer."Serial No." := CduLBinaryFileManagement.FctReturnFixData(165, 20);
            RecLShipmentLineBuffer."Lot No." := CduLBinaryFileManagement.FctReturnFixData(101, 20);
            RecLShipmentLineBuffer.Modify();

            Clear(RecordRef);
            RecordRef.GetTable(RecLShipmentLineBuffer);
            RecLWMSShipmentLineBuffer.Get(CduGBufferManagement.FctDuplicateBuffer(DATABASE::"PWD WMS Sales Line Buffer", RecordRef));
            //Placer les champs spécifiques WMS
            RecLWMSShipmentLineBuffer.Modify();
        end;
    end;


    procedure FctImportShipmentLine(var RecPConnectorValues: Record "PWD Connector Values")
    begin
        case RecPConnectorValues."File format" of
            RecPConnectorValues."File format"::Xml:
                FctImportShipmentLineXML(RecPConnectorValues);
            RecPConnectorValues."File format"::"with separator":
                FctImportShipmentLineWithSep(RecPConnectorValues);
            RecPConnectorValues."File format"::"File Position":
                FctImportShipmentLineFilePos(RecPConnectorValues);
        end;
    end;


    procedure FctImportShipmentLineXML(var RecPConnectorValues: Record "PWD Connector Values")
    begin
        //A définir
    end;


    procedure FctImportShipmentLineWithSep(var RecPConnectorValues: Record "PWD Connector Values")
    begin
        //A définir
    end;


    procedure "-OSYS-Int001.001-"()
    begin
    end;


    procedure FctIsTheSamePartener(CodPPartner: Code[20]): Boolean
    var
        RecLWMSSetup: Record "PWD WMS Setup";
    begin
        RecLWMSSetup.Get();
        RecLWMSSetup.TestField(RecLWMSSetup."Partner Code");
        exit((RecLWMSSetup."Partner Code" = CodPPartner) and FctWMSEnabled());
    end;
}

