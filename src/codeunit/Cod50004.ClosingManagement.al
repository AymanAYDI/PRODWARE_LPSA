codeunit 50004 "PWD Closing Management"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.19
    // P24578_008.001 : LY 12/08/2019 : Export contrôle de gestion
    // 
    // //>>NDBI
    // P27818_002 : LALE.PA : 02/03/2021 : cf. demande mail client TI526293
    //                   - Modif C/AL Code in trigger ExportItem
    // 
    // P27818_006 : LALE.PA : 05/07/2021 : Cf. demande mail client du 21/06/2021
    //                   - Modif C/AL Code in trigger ExportItem
    // 
    // P27818_006 : LALE.PA : 06/09/2021 : Cf. demande mail client du 06/09/2021
    //                   - Modif C/AL Code in trigger ExportInventory
    // 
    // P27818_006 : LALE.PA : 14/09/2021 : Cf. demande client du 13/09/2021 suite call
    //                   - Modif C/AL Code in trigger ExportInventory


    trigger OnRun()
    begin
        RecGGenLdgSetup.Get();
        RecGInventorySetup.Get();
        RecGUserSetup.Get(RecGInventorySetup."PWD Recipient User ID");
        if not BooGManualLaunch then
            RecGUserSetup.TestField("E-Mail");

        DatGCurrStartMonth := CalcDate('<-CM>', DatGReferenceDate);
        DatGCurrEndMonth := CalcDate('<CM>', DatGCurrStartMonth);

        if GuiAllowed then
            DiaGWindows.Open(CstG00000);

        if BooGItem then
            ExportItem();

        if BooGInventory then
            ExportInventory();

        if BooGProdOrder then
            ExportProdOrder();

        if BooGFinishedPO then
            ExportFinishedPO();

        if GuiAllowed then
            DiaGWindows.Close();

        //>>TDL131219
        // En attente
        //IF NOT BooGManualLaunch THEN BEGIN
        //  COMMIT;
        //  SMTP.CreateMessage(COMPANYNAME,RecGInventorySetup."Closing Sendor E-Mail",RecGUserSetup."E-Mail",'Bouclement',CstG00001,FALSE);
        //  SMTP.Send;
        //END;
        //<TDL131219
    end;

    var
        RecGDefaultDim: Record "Default Dimension";
        RecGDimValue: Record "Dimension Value";
        RecGGenLdgSetup: Record "General Ledger Setup";
        RecGInventorySetup: Record "Inventory Setup";
        RecGUserSetup: Record "User Setup";
        FileMgt: Codeunit "File Management";
        CduGConvert: Codeunit "PWD Convert Ascii To Ansi";
        BigTGExportText: BigText;
        BooGFinishedPO: Boolean;
        BooGInventory: Boolean;
        BooGItem: Boolean;
        BooGManualLaunch: Boolean;
        BooGProdOrder: Boolean;
        ChaGCR: Char;
        ChaGLF: Char;
        DatGCurrEndMonth: Date;
        DatGCurrStartMonth: Date;
        DatGReferenceDate: Date;
        DiaGWindows: Dialog;
        FilGToExport: File;
        CstG00000: Label 'Export #1############# #2############';
        OusGOutstream: OutStream;
        TxtGExportFileName: Text[250];
        TxtGServerFileName: Text[250];


    procedure UpdateDimValue(FromIDTable: Integer; FromIDCode: Code[20]; FromDescription: Text[30])
    var
        DimensionCode: Code[20];
    begin
        RecGInventorySetup.Get();
        case FromIDTable of
            5722:
                begin
                    RecGInventorySetup.TestField("PWD Item Category Dimension");
                    DimensionCode := RecGInventorySetup."PWD Item Category Dimension";
                end;

            5723:
                begin
                    RecGInventorySetup.TestField("PWD Product Group Dimension");
                    DimensionCode := RecGInventorySetup."PWD Product Group Dimension";
                end;

            else
                exit;
        end;

        if not RecGDimValue.Get(DimensionCode, FromIDCode) then begin
            RecGDimValue.Init();
            RecGDimValue."Dimension Code" := DimensionCode;
            RecGDimValue.Code := FromIDCode;
            RecGDimValue.Name := FromDescription;
            RecGDimValue.Insert(true);
        end;
        if (FromDescription <> '') and (RecGDimValue.Name <> FromDescription) then begin
            RecGDimValue.Name := FromDescription;
            RecGDimValue.Modify();
        end;
    end;


    procedure UpdtItemDimValue(FromIDTable: Integer; FromItemNo: Code[20]; FromIDCode: Code[20])
    var
        DimensionCode: Code[20];
    begin
        RecGInventorySetup.Get();
        case FromIDTable of
            5722:
                begin
                    RecGInventorySetup.TestField("PWD Item Category Dimension");
                    DimensionCode := RecGInventorySetup."PWD Item Category Dimension";
                end;

            5723:
                begin
                    RecGInventorySetup.TestField("PWD Product Group Dimension");
                    DimensionCode := RecGInventorySetup."PWD Product Group Dimension";
                end;

            else
                exit;
        end;

        RecGDefaultDim.SetRange("Table ID", DATABASE::Item);
        RecGDefaultDim.SetRange("No.", FromItemNo);
        RecGDefaultDim.SetRange("Dimension Code", DimensionCode);
        if RecGDefaultDim.FindFirst() then begin
            if RecGDefaultDim."Dimension Value Code" <> FromIDCode then begin
                RecGDefaultDim."Dimension Value Code" := FromIDCode;
                RecGDefaultDim.Modify();
            end;
        end else begin
            RecGDefaultDim.Init();
            RecGDefaultDim."Table ID" := DATABASE::Item;
            RecGDefaultDim."No." := FromItemNo;
            RecGDefaultDim."Dimension Code" := DimensionCode;
            RecGDefaultDim."Dimension Value Code" := FromIDCode;
            RecGDefaultDim."Value Posting" := RecGDefaultDim."Value Posting"::"Code Mandatory";
            RecGDefaultDim.Insert();
        end;
    end;


    procedure GetDirectory(TxtPDataSource: Text[250]): Text[250]
    var
        IntLCharPos: Integer;
        IntLLength: Integer;
        TxtLChar: Text[1];
    begin
        if StrLen(TxtPDataSource) = 0 then exit;

        IntLLength := StrLen(TxtPDataSource);
        for IntLCharPos := IntLLength downto 1 do begin
            TxtLChar := CopyStr(TxtPDataSource, IntLCharPos, 1);
            if TxtLChar = '\' then
                exit(CopyStr(TxtPDataSource, 1, IntLCharPos));
        end;
    end;


    procedure InitFile(TxtPRepertory: Text[250]; TxtPFileName: Text[250])
    begin

        TxtGExportFileName := TxtPRepertory + StrSubstNo(TxtPFileName,
                                Format(CurrentDateTime, 0, '<day,2><month,2><year4><Hours24,2><Filler Character,0><Minutes,2><Seconds,2>'));

        //CREATE FILE IN RTC MODE.
        if IsServiceTier then begin
            TxtGServerFileName := TxtGExportFileName;
            TxtGExportFileName := FileMgt.ServerTempFileName('.csv');
        end;

        // Create export file
        FilGToExport.TextMode(true);
        FilGToExport.WriteMode(true);

        if FilGToExport.Open(TxtGExportFileName) then begin
            if FilGToExport.Len > 0 then
                FilGToExport.Seek(FilGToExport.Len)
            else
                FilGToExport.Create(TxtGExportFileName);
            FilGToExport.CreateOutStream(OusGOutstream);
        end else begin
            FilGToExport.Create(TxtGExportFileName);
            FilGToExport.CreateOutStream(OusGOutstream);
        end;

        // Define chariot return and new line for outstream write
        ChaGCR := 13;
        ChaGLF := 10;
    end;


    procedure WriteSegment(TxtPTextFields: array[50] of Text[250]; IntPEndSegment: Integer)
    var
        IntLCount: Integer;
    begin
        //*************** Fonction qui va écrire une ligne dans le fichier texte ***************//

        Clear(BigTGExportText);

        IntLCount := 1;
        while (IntLCount <= IntPEndSegment) do begin
            BigTGExportText.AddText(CduGConvert.AsciiToAnsi(TxtPTextFields[IntLCount]) + ';');
            IntLCount += 1;
        end;

        BigTGExportText.AddText(Format(ChaGCR));
        BigTGExportText.AddText(Format(ChaGLF));
        BigTGExportText.Write(OusGOutstream);
    end;


    procedure EndMessage()
    begin
        FilGToExport.Close();
        if IsServiceTier then begin
            FileMgt.DownloadToFile(TxtGExportFileName, TxtGServerFileName);
            TxtGExportFileName := TxtGServerFileName;
        end;
    end;


    procedure ExportItem()
    var
        RecLItem: Record Item;
        RecLValueEntry: Record "Value Entry";
        RecLValueEntry2: Record "Value Entry";
        CstLItem: Label 'Articles_%1.csv';
        CstLTitle: Label 'Item';
        TxtLTextFields: array[50] of Text[250];
    begin
        if GuiAllowed then
            DiaGWindows.Update(1, CstLTitle);

        InitFile(RecGInventorySetup."PWD Path for Closing Export", CstLItem);

        //*************** HEADER ***************//
        // 1 - N° Article
        TxtLTextFields[1] := 'N° Article';

        // 2 - Désignation
        TxtLTextFields[2] := 'Désignation';

        // 3 - Tabelle
        TxtLTextFields[3] := 'Tabelle';

        // 4 - Code catégories articles.
        TxtLTextFields[4] := 'Code catégories articles';

        // 5 - Code groupe produits
        TxtLTextFields[5] := 'Code groupe produits';

        // 6 - PRP actuel
        TxtLTextFields[6] := 'PRP actuel';

        // 7 - Type cout
        TxtLTextFields[7] := 'Type coût';

        // 8 - Unité de quantité
        TxtLTextFields[8] := 'Unité de quantité';

        // 9 - Centre de profit
        TxtLTextFields[9] := 'Centre de profit';

        // 10 - Système réappro.
        TxtLTextFields[10] := 'Système réappro.';

        // 11 - Quantité en stock
        TxtLTextFields[11] := 'Quantité en stock';

        // 12 - Valeur stock
        TxtLTextFields[12] := 'Valeur stock';

        // 13 - Statut d'articles
        TxtLTextFields[13] := 'Statut d''articles';

        //>>NDBI
        // 14 - Groupe compta stock
        TxtLTextFields[14] := 'Groupe compta stock';

        // WRITE
        //WriteSegment(TxtLTextFields,13);

        //>>NDBI
        //WriteSegment(TxtLTextFields,14);

        // 15 - Système réappro
        TxtLTextFields[15] := 'Système réappro';


        // 16 -Dernier prix vente
        TxtLTextFields[16] := 'Dernier prix vente';

        WriteSegment(TxtLTextFields, 16);

        //<<NDBI
        //<<NDBI

        //*************** DETAIL ***************//
        RecLItem.FindSet();
        repeat
            if GuiAllowed then
                DiaGWindows.Update(2, RecLItem."No.");

            RecLItem.CalcFields(Inventory);

            // Item Ledger Entry
            RecLValueEntry.SetCurrentKey("Item No.");
            RecLValueEntry.SetRange("Item No.", RecLItem."No.");
            RecLValueEntry.CalcSums("Cost Amount (Actual)", "Cost Amount (Expected)");

            RecGDefaultDim.Reset();
            RecGDefaultDim.SetRange("Table ID", DATABASE::Item);
            RecGDefaultDim.SetRange("No.", RecLItem."No.");

            // 1 - N° Article
            TxtLTextFields[1] := RecLItem."No.";

            // 2 - Désignation
            TxtLTextFields[2] := RecLItem.Description;

            // 3 - Tabelle
            TxtLTextFields[3] := RecLItem."Search Description";

            // 4 - Code catégories articles
            RecGDefaultDim.SetRange("Dimension Code", RecGInventorySetup."PWD Item Category Dimension");
            if not RecGDefaultDim.FindFirst() then
                RecGDefaultDim.Init();
            TxtLTextFields[4] := RecGDefaultDim."Dimension Value Code";

            // 5 - Code groupe produits
            RecGDefaultDim.SetRange("Dimension Code", RecGInventorySetup."PWD Product Group Dimension");
            if not RecGDefaultDim.FindFirst() then
                RecGDefaultDim.Init();
            TxtLTextFields[5] := RecGDefaultDim."Dimension Value Code";

            // 6 - PRP actuel
            TxtLTextFields[6] := Format(RecLItem."Unit Cost");

            // 7 - Type cout
            TxtLTextFields[7] := Format(RecLItem."Costing Method");

            // 8 - Unité de quantité
            TxtLTextFields[8] := RecLItem."Base Unit of Measure";

            // 9 - Centre de profit
            RecGDefaultDim.SetRange("Dimension Code", RecGGenLdgSetup."Global Dimension 2 Code");
            if not RecGDefaultDim.FindFirst() then
                RecGDefaultDim.Init();
            TxtLTextFields[9] := RecGDefaultDim."Dimension Value Code";

            // 10 - Système réappro.
            TxtLTextFields[10] := Format(RecLItem."Replenishment System");

            // 11 - Quantité en stock
            TxtLTextFields[11] := Format(RecLItem.Inventory);

            // 12 - Valeur stock
            TxtLTextFields[12] := Format(RecLValueEntry."Cost Amount (Actual)" + RecLValueEntry."Cost Amount (Expected)");

            // 13 - Statut d'articles
            TxtLTextFields[13] := Format(RecLItem.Blocked);

            //>>NDBI
            // 14 - Groupe compta stock
            TxtLTextFields[14] := Format(RecLItem."Inventory Posting Group");

            // WRITE
            //  WriteSegment(TxtLTextFields,13);
            //>>NDBI
            //  WriteSegment(TxtLTextFields,14);

            // 15 - Système réappro
            TxtLTextFields[15] := Format(RecLItem."Replenishment System");


            // 16 -Prix vente moyen du mois
            RecLValueEntry2.Reset();
            RecLValueEntry2.SetCurrentKey("Item No.", "Posting Date", "Item Ledger Entry Type", "Source Type", "Source No.");
            RecLValueEntry2.SetRange("Item No.", RecLItem."No.");
            RecLValueEntry2.SetRange("Item Ledger Entry Type", RecLValueEntry2."Item Ledger Entry Type"::Sale);
            RecLValueEntry2.SetRange("Source Type", RecLValueEntry2."Source Type"::Customer);
            RecLValueEntry2.SetFilter("Source No.", '<>%1', 'C10219');
            RecLValueEntry2.SetFilter("Sales Amount (Actual)", '<>%1', 0);
            RecLValueEntry2.SetFilter("Item Charge No.", '%1', '');
            if RecLValueEntry2.FindLast() and (RecLValueEntry2."Invoiced Quantity" <> 0) then
                TxtLTextFields[16] := Format(-RecLValueEntry2."Sales Amount (Actual)" / RecLValueEntry2."Invoiced Quantity")
            else
                TxtLTextFields[16] := '0';

            WriteSegment(TxtLTextFields, 16);
        //<<NDBI
        //<<NDBI

        until RecLItem.Next() = 0;

        EndMessage();
    end;


    procedure ExportInventory()
    var
        RecLBinContent: Record "Bin Content";
        RecLItem: Record Item;
        RecLItemLdgEntry: Record "Item Ledger Entry";
        RecLLocation: Record Location;
        RecLWarehouseEntry: Record "Warehouse Entry";
        CstLInventory: Label 'Stocks_%1.csv';
        CstLTitle: Label 'Stock';
        TxtLTextFields: array[50] of Text[250];
    begin
        if GuiAllowed then
            DiaGWindows.Update(1, CstLTitle);

        InitFile(RecGInventorySetup."PWD Path for Closing Export", CstLInventory);

        //*************** HEADER ***************//

        // 1 - N° Article
        TxtLTextFields[1] := 'N° Article';

        // 2 - Désignation
        TxtLTextFields[2] := 'Désignation';

        // 3 - Code Magasin
        TxtLTextFields[3] := 'Code Magasin';

        // 4 - Code emplacement
        TxtLTextFields[4] := 'Code Emplacement';

        // 5 - Unité
        TxtLTextFields[5] := 'Unité';

        // 6 - Quantité en stock
        TxtLTextFields[6] := 'Quantité en stock';

        // 7 - Coût unitaire
        TxtLTextFields[7] := 'Coût unitaire';

        // 8 - Montant
        TxtLTextFields[8] := 'Montant';

        // 9 - Centre de profit
        TxtLTextFields[9] := 'Centre de profit';

        // 10 - Code Catégorie
        TxtLTextFields[10] := 'Code Catégorie';

        // 11 - Code Groupe Produit
        TxtLTextFields[11] := 'Code Groupe Produit';

        // 12 - Type de stock
        TxtLTextFields[12] := 'Type de stock';

        //>>NDBI
        // 13 - Date de premier mvt remplacé par Date dernier mvt
        //TxtLTextFields[13] := 'Date de premier mvt';
        TxtLTextFields[13] := 'Date de dernier mvt';

        // 14 - Type premier mvt remplacé par Type dernier mvt
        //TxtLTextFields[14] := 'Type premier mvt';
        TxtLTextFields[14] := 'Type dernier mvt';
        //<<NDBI

        // 15 - Couverture de stocks en mois
        TxtLTextFields[15] := 'Couverture de stocks en mois';

        // 16 - Besoins
        TxtLTextFields[16] := 'Besoins';

        //>>NDBI
        // 17 - Qté en cde
        TxtLTextFields[17] := 'Qté en cde';

        // WRITE
        //WriteSegment(TxtLTextFields,16);
        WriteSegment(TxtLTextFields, 17);
        //<<NDBI

        //*************** DETAIL ***************//

        RecLItem.FindSet();
        repeat
            if GuiAllowed then
                DiaGWindows.Update(2, RecLItem."No.");

            RecGDefaultDim.Reset();
            RecGDefaultDim.SetRange("Table ID", DATABASE::Item);
            RecGDefaultDim.SetRange("No.", RecLItem."No.");

            RecLLocation.FindSet();
            repeat

                RecLItem.SetFilter("Location Filter", '%1', RecLLocation.Code);
                RecLItem.SetFilter("Date Filter", '..%1', DatGCurrEndMonth);
                RecLItem.CalcFields(Inventory, "Qty. on Sales Order", "PWD Forecast Qty.", "Qty. on Component Lines");

                if RecLLocation."Bin Mandatory" then begin
                    RecLBinContent.SetRange("Location Code", RecLLocation.Code);
                    RecLBinContent.SetRange("Item No.", RecLItem."No.");
                    if RecLBinContent.FindSet() then
                        repeat
                            RecLBinContent.CalcFields(Quantity);
                            ;
                            if RecLBinContent.Quantity <> 0 then begin
                                Clear(TxtLTextFields);

                                RecLWarehouseEntry.SetRange("Item No.", RecLItem."No.");
                                RecLWarehouseEntry.SetRange("Location Code", RecLLocation.Code);
                                RecLWarehouseEntry.SetRange("Bin Code", RecLBinContent."Bin Code");
                                //>>NDBI
                                //            IF NOT RecLWarehouseEntry.FINDFIRST THEN
                                if not RecLWarehouseEntry.FindLast() then
                                    //<<NDBI
                                    RecLWarehouseEntry.Init();

                                // 1 - N° Article
                                TxtLTextFields[1] := RecLItem."No.";

                                // 2 - Désignation
                                TxtLTextFields[2] := RecLItem.Description;

                                // 3 - Code Magasin
                                TxtLTextFields[3] := RecLLocation.Code;

                                // 4 - Code emplacement
                                TxtLTextFields[4] := RecLBinContent."Bin Code";

                                // 5 - Unité
                                TxtLTextFields[5] := RecLItem."Base Unit of Measure";

                                // 6 - Quantité en stock
                                TxtLTextFields[6] := Format(RecLBinContent.Quantity);

                                // 7 - Coût unitaire
                                TxtLTextFields[7] := Format(RecLItem."Unit Cost");

                                // 8 - Montant
                                TxtLTextFields[8] := Format(RecLBinContent.Quantity * RecLItem."Unit Cost");

                                // 9 - Centre de profit
                                RecGDefaultDim.SetRange("Dimension Code", RecGGenLdgSetup."Global Dimension 2 Code");
                                if not RecGDefaultDim.FindFirst() then
                                    RecGDefaultDim.Init();
                                TxtLTextFields[9] := RecGDefaultDim."Dimension Value Code";

                                // 10 - Code Catégorie
                                RecGDefaultDim.SetRange("Dimension Code", RecGInventorySetup."PWD Item Category Dimension");
                                if not RecGDefaultDim.FindFirst() then
                                    RecGDefaultDim.Init();
                                TxtLTextFields[10] := RecGDefaultDim."Dimension Value Code";

                                // 11 - Code Groupe Produit
                                RecGDefaultDim.SetRange("Dimension Code", RecGInventorySetup."PWD Product Group Dimension");
                                if not RecGDefaultDim.FindFirst() then
                                    RecGDefaultDim.Init();
                                TxtLTextFields[11] := RecGDefaultDim."Dimension Value Code";

                                // 12 - Type de stock
                                TxtLTextFields[12] := RecLItem."Item Category Code";

                                // 13 - Date de premier mvt
                                TxtLTextFields[13] := Format(RecLWarehouseEntry."Registering Date");

                                // 14 - Type premier mvt
                                TxtLTextFields[14] := Format(RecLWarehouseEntry."Source Document");

                                // 15 - Couverture de stocks en mois
                                //TxtLTextFields[15] := FORMAT(0);
                                TxtLTextFields[15] := Format(CalcInventoryCover(RecLItem."No.", RecLLocation, RecLItem.Inventory));

                                // 16 - Besoins
                                TxtLTextFields[16] := Format(RecLItem."Qty. on Sales Order" +
                                                             RecLItem."PWD Forecast Qty." +
                                                             RecLItem."Qty. on Component Lines");

                                //>>NDBI
                                // 17 - Qté en cde
                                RecLItem.CalcFields("Qty. on Sales Order", "Qty. on Component Lines");
                                TxtLTextFields[17] := Format(RecLItem."Qty. on Sales Order" + RecLItem."Qty. on Component Lines");

                                //WriteSegment(TxtLTextFields,16);
                                WriteSegment(TxtLTextFields, 17);
                                //<<NDBI

                            end;
                        until RecLBinContent.Next() = 0;
                end else
                    if RecLItem.Inventory <> 0 then begin
                        RecLItemLdgEntry.SetRange("Item No.", RecLItem."No.");
                        RecLItemLdgEntry.SetRange("Location Code", RecLLocation.Code);
                        //>>NDBI
                        //        IF NOT RecLItemLdgEntry.FINDFIRST THEN
                        if not RecLItemLdgEntry.FindLast() then
                            //<<NDBI
                            RecLItemLdgEntry.Init();

                        Clear(TxtLTextFields);

                        // 1 - N° Article
                        TxtLTextFields[1] := RecLItem."No.";

                        // 2 - Désignation
                        TxtLTextFields[2] := RecLItem.Description;

                        // 3 - Code Magasin
                        TxtLTextFields[3] := RecLLocation.Code;

                        // 4 - Code emplacement
                        TxtLTextFields[4] := '';

                        // 5 - Unité
                        TxtLTextFields[5] := RecLItem."Base Unit of Measure";

                        // 6 - Quantité en stock
                        TxtLTextFields[6] := Format(RecLItem.Inventory);

                        // 7 - Coût unitaire
                        TxtLTextFields[7] := Format(RecLItem."Unit Cost");

                        // 8 - Montant
                        TxtLTextFields[8] := Format(RecLItem.Inventory * RecLItem."Unit Cost");

                        // 9 - Centre de profit
                        RecGDefaultDim.SetRange("Dimension Code", RecGGenLdgSetup."Global Dimension 2 Code");
                        if not RecGDefaultDim.FindFirst() then
                            RecGDefaultDim.Init();
                        TxtLTextFields[9] := RecGDefaultDim."Dimension Value Code";

                        // 10 - Code Catégorie
                        RecGDefaultDim.SetRange("Dimension Code", RecGInventorySetup."PWD Item Category Dimension");
                        if not RecGDefaultDim.FindFirst() then
                            RecGDefaultDim.Init();
                        TxtLTextFields[10] := RecGDefaultDim."Dimension Value Code";

                        // 11 - Code Groupe Produit
                        RecGDefaultDim.SetRange("Dimension Code", RecGInventorySetup."PWD Product Group Dimension");
                        if not RecGDefaultDim.FindFirst() then
                            RecGDefaultDim.Init();
                        TxtLTextFields[11] := RecGDefaultDim."Dimension Value Code";

                        // 12 - Type de stock
                        TxtLTextFields[12] := RecLItem."Item Category Code";

                        // 13 - Date de premier mvt
                        TxtLTextFields[13] := Format(RecLItemLdgEntry."Posting Date");

                        // 14 - Type premier mvt
                        TxtLTextFields[14] := Format(RecLItemLdgEntry."Entry Type");

                        // 15 - Couverture de stocks en mois
                        TxtLTextFields[15] := Format(CalcInventoryCover(RecLItem."No.", RecLLocation, RecLItem.Inventory));

                        // 16 - Besoins
                        TxtLTextFields[16] := Format(RecLItem."Qty. on Sales Order" +
                                                     RecLItem."PWD Forecast Qty." +
                                                     RecLItem."Qty. on Component Lines");

                        //>>NDBI
                        // 17 - Qté en cde
                        RecLItem.CalcFields("Qty. on Sales Order", "Qty. on Component Lines");
                        TxtLTextFields[17] := Format(RecLItem."Qty. on Sales Order" + RecLItem."Qty. on Component Lines");

                        //WriteSegment(TxtLTextFields,16);
                        WriteSegment(TxtLTextFields, 17);
                        //<<NDBI

                    end;

            until RecLLocation.Next() = 0;
        until RecLItem.Next() = 0;

        EndMessage();
    end;


    procedure ExportProdOrder()
    var
        RecLItem: Record Item;
        RecLProdOrderLine: Record "Prod. Order Line";
        RecLProductionOrder: Record "Production Order";
        DatLCurrPrevEndMonth: Date;
        CstLCurrent: Label 'Current_%1.csv';
        CstLTitle: Label 'En-cours';
        TxtLTextFields: array[50] of Text[250];
    begin
        if GuiAllowed then
            DiaGWindows.Update(1, CstLTitle);

        InitFile(RecGInventorySetup."PWD Path for Closing Export", CstLCurrent);

        DatLCurrPrevEndMonth := CalcDate('<-1D>', DatGCurrStartMonth);

        //*************** HEADER ***************//

        // 1 - Statut
        TxtLTextFields[1] := 'Statut';

        // 2 - Type O.F.
        TxtLTextFields[2] := 'Type O.F.';

        // 3 - N° O.F.
        TxtLTextFields[3] := 'N°';

        // 4 - N° article.
        TxtLTextFields[4] := 'N° article';

        // 5 - Désignation
        TxtLTextFields[5] := 'Désignation';

        // 6 - Magasin
        TxtLTextFields[6] := 'Magasin';

        // 7 - En cours M-1
        TxtLTextFields[7] := StrSubstNo('En-cours au %1', DatLCurrPrevEndMonth);

        // 8 - Consommation
        TxtLTextFields[8] := 'Consommation';

        // 9 - Capacité
        TxtLTextFields[9] := 'Capacité';

        // 10 - Sous-traitance
        TxtLTextFields[10] := 'Sous-traitance';

        //11 - Production
        TxtLTextFields[11] := 'Production';

        // 12 - En cours M
        TxtLTextFields[12] := StrSubstNo('En-cours au %1', DatGCurrEndMonth);

        // 13 - Quantité d'entrée
        TxtLTextFields[13] := 'Quantité d''entrée';

        // 14 - Code catégorie articles
        TxtLTextFields[14] := 'Code catégorie articles';

        // 15 - Code groupe produits
        TxtLTextFields[15] := 'Code groupe produits';

        // 16 - Code groupe produits
        TxtLTextFields[16] := 'Centre de profit';

        // WRITE
        WriteSegment(TxtLTextFields, 16);

        //*************** DETAIL ***************//

        RecLProductionOrder.SetFilter(Status, '%1..', RecLProductionOrder.Status::Released);
        RecLProductionOrder.SetFilter("Finished Date", '%1|%2..%3', 0D, DatGCurrStartMonth, DatGCurrEndMonth);

        if RecLProductionOrder.FindSet() then
            repeat
                if GuiAllowed then
                    DiaGWindows.Update(2, RecLProductionOrder."No.");

                RecLProdOrderLine.SetRange(Status, RecLProductionOrder.Status);
                RecLProdOrderLine.SetRange("Prod. Order No.", RecLProductionOrder."No.");
                if RecLProdOrderLine.FindFirst() then begin

                    RecLItem.Get(RecLProdOrderLine."Item No.");
                    RecGDefaultDim.Reset();
                    RecGDefaultDim.SetRange("Table ID", DATABASE::Item);
                    RecGDefaultDim.SetRange("No.", RecLItem."No.");

                    Clear(TxtLTextFields);

                    // 1 - Statut
                    TxtLTextFields[1] := Format(RecLProductionOrder.Status);

                    // 2 - Type O.F.
                    if IsSubcontractorProdOrder(RecLProductionOrder) then
                        TxtLTextFields[2] := 'Sous-traitance'
                    else
                        TxtLTextFields[2] := 'Production';

                    // 3 - N° O.F.
                    TxtLTextFields[3] := RecLProductionOrder."No.";

                    // 4 - N° article.
                    TxtLTextFields[4] := RecLProdOrderLine."Item No.";

                    // 5 - Désignation
                    TxtLTextFields[5] := RecLItem.Description;

                    // 6 - Magasin
                    TxtLTextFields[6] := RecLProdOrderLine."Location Code";

                    CalcProdOrderValue(RecLProductionOrder, DatGCurrStartMonth, DatGCurrEndMonth, TxtLTextFields);

                    // 13 - Quantité d'entrée
                    TxtLTextFields[13] := Format(RecLProdOrderLine.Quantity);

                    // 14 - Code catégorie articles
                    RecGDefaultDim.SetRange("Dimension Code", RecGInventorySetup."PWD Item Category Dimension");
                    if not RecGDefaultDim.FindFirst() then
                        RecGDefaultDim.Init();
                    TxtLTextFields[14] := RecGDefaultDim."Dimension Value Code";

                    // 15 - Code groupe produits
                    RecGDefaultDim.SetRange("Dimension Code", RecGInventorySetup."PWD Product Group Dimension");
                    if not RecGDefaultDim.FindFirst() then
                        RecGDefaultDim.Init();
                    TxtLTextFields[15] := RecGDefaultDim."Dimension Value Code";

                    // 16 - Code groupe produits
                    RecGDefaultDim.SetRange("Dimension Code", RecGGenLdgSetup."Global Dimension 2 Code");
                    if not RecGDefaultDim.FindFirst() then
                        RecGDefaultDim.Init();
                    TxtLTextFields[16] := RecGDefaultDim."Dimension Value Code";

                    // WRITE
                    WriteSegment(TxtLTextFields, 16);
                end;
            until RecLProductionOrder.Next() = 0;

        EndMessage();
    end;


    procedure ExportFinishedPO()
    var
        ReclCapacityLdgrEntry: Record "Capacity Ledger Entry";
        RecLItemLdgrEntry: Record "Item Ledger Entry";
        RecLProdOrderLine: Record "Prod. Order Line";
        RecLProductionOrder: Record "Production Order";
        CstLFinisheProdOrder: Label 'Finished_PO_%1.csv';
        CstLTitle: Label 'OF terminé';
        TxtLTextFields: array[50] of Text[250];
    begin
        if GuiAllowed then
            DiaGWindows.Update(1, CstLTitle);

        InitFile(RecGInventorySetup."PWD Path for Closing Export", CstLFinisheProdOrder);

        //*************** HEADER ***************//

        // 1 - N° O.F.
        TxtLTextFields[1] := 'N° O.F.';

        // 2 - N° article
        TxtLTextFields[2] := 'N° article';

        // 3 - Désignation
        TxtLTextFields[3] := 'Désignation';

        // 4 - Statut
        TxtLTextFields[4] := 'Statut O.F.';

        // 5 - Quantité lancée
        TxtLTextFields[5] := 'Quantité lancée';

        // 6 - Date de début
        TxtLTextFields[6] := 'Date de début';

        // 7 - Date de fin
        TxtLTextFields[7] := 'Date de fin';

        // 8 - Unité de quantité
        TxtLTextFields[8] := 'Unité de quantité';

        // 9 - Quantité livrée
        TxtLTextFields[9] := 'Quantité livrée';

        // 10 - Quantité rebut
        TxtLTextFields[10] := 'Quantité rebut';

        // 11 - Centre de Profit
        TxtLTextFields[11] := 'Centre de Profit';

        // WRITE
        WriteSegment(TxtLTextFields, 11);

        //*************** DETAIL ***************//

        RecLProductionOrder.SetRange(Status, RecLProductionOrder.Status::Finished);
        RecLProductionOrder.SetRange("Finished Date", DatGCurrStartMonth, DatGCurrEndMonth);
        if RecLProductionOrder.FindSet() then
            repeat
                if GuiAllowed then
                    DiaGWindows.Update(2, RecLProductionOrder."No.");

                RecLProdOrderLine.SetRange(Status, RecLProductionOrder.Status);
                RecLProdOrderLine.SetRange("Prod. Order No.", RecLProductionOrder."No.");
                if RecLProdOrderLine.FindFirst() then begin
                    RecLItemLdgrEntry.SetCurrentKey("Order No.");
                    RecLItemLdgrEntry.SetRange("Order No.", RecLProductionOrder."No.");

                    // 1 - N° O.F.
                    TxtLTextFields[1] := RecLProductionOrder."No.";

                    // 2 - N° article
                    TxtLTextFields[2] := RecLProdOrderLine."Item No.";

                    // 3 - Désignation
                    TxtLTextFields[3] := RecLProdOrderLine.Description;

                    // 4 - Statut
                    TxtLTextFields[4] := Format(RecLProdOrderLine.Status);

                    // 5 - Quantité lancée
                    TxtLTextFields[5] := Format(RecLProdOrderLine.Quantity);

                    // 6 - Date de début
                    RecLItemLdgrEntry.SetRange("Entry Type", RecLItemLdgrEntry."Entry Type"::Consumption);
                    if not RecLItemLdgrEntry.FindFirst() then
                        RecLItemLdgrEntry.Init();
                    TxtLTextFields[6] := Format(RecLItemLdgrEntry."Posting Date");

                    // 7 - Date de fin
                    RecLItemLdgrEntry.SetRange("Entry Type", RecLItemLdgrEntry."Entry Type"::Output);
                    if not RecLItemLdgrEntry.FindLast() then
                        RecLItemLdgrEntry.Init();
                    TxtLTextFields[7] := Format(RecLItemLdgrEntry."Posting Date");

                    // 8 - Unité de quantité
                    TxtLTextFields[8] := RecLProdOrderLine."Unit of Measure Code";

                    // 9 - Quantité livrée
                    TxtLTextFields[9] := Format(RecLProdOrderLine."Finished Quantity");

                    // 10 - Quantité rebut
                    ReclCapacityLdgrEntry.SetCurrentKey("Order No.");
                    ReclCapacityLdgrEntry.SetRange("Order No.", RecLProductionOrder."No.");
                    ReclCapacityLdgrEntry.CalcSums("Scrap Quantity");
                    TxtLTextFields[10] := Format(ReclCapacityLdgrEntry."Scrap Quantity");

                    // 11 - Centre de Profit
                    TxtLTextFields[11] := RecLProdOrderLine."Shortcut Dimension 2 Code";

                    // WRITE
                    WriteSegment(TxtLTextFields, 11);
                end;
            until RecLProductionOrder.Next() = 0;

        EndMessage();
    end;


    procedure CalcProdOrderValue(RecPProdOrder: Record "Production Order"; DatPCurrStartMonth: Date; DatPCurrEndMonth: Date; var TxtPTextFields: array[50] of Text[250])
    var
        RecLValueEntry: Record "Value Entry";
        DecLValueOfCap: Decimal;
        DecLValueOfCapVendor: Decimal;
        DecLValueOfExpOutput1: Decimal;
        DecLValueOfExpOutput2: Decimal;
        DecLValueOfInvOutput1: Decimal;
        DecLValueOfMatConsump: Decimal;
        DecLValueOfOutput: Decimal;
        DecLValueOfRevalCostAct: Decimal;
        DecLValueOfWIP: Decimal;
    begin
        Clear(DecLValueOfWIP);
        Clear(DecLValueOfMatConsump);
        Clear(DecLValueOfCap);
        Clear(DecLValueOfCapVendor);
        Clear(DecLValueOfOutput);

        RecLValueEntry.SetRange("Order No.", RecPProdOrder."No.");
        RecLValueEntry.SetRange("Posting Date", 0D, DatPCurrEndMonth);
        if RecLValueEntry.FindSet() then
            repeat
                if not IsNotWIP(RecLValueEntry) then
                    if RecLValueEntry."Posting Date" < DatPCurrStartMonth then begin
                        if RecLValueEntry."Item Ledger Entry Type" = RecLValueEntry."Item Ledger Entry Type"::" " then
                            DecLValueOfWIP += RecLValueEntry."Cost Amount (Actual)"
                        else
                            DecLValueOfWIP += -RecLValueEntry."Cost Amount (Actual)";
                        if RecLValueEntry."Item Ledger Entry Type" = RecLValueEntry."Item Ledger Entry Type"::Output then begin
                            DecLValueOfExpOutput1 := -RecLValueEntry."Cost Amount (Expected)";
                            DecLValueOfInvOutput1 := -RecLValueEntry."Cost Amount (Actual)";
                            DecLValueOfWIP += -RecLValueEntry."Cost Amount (Expected)" - RecLValueEntry."Cost Amount (Actual)";
                        end;

                        if (RecLValueEntry."Entry Type" = RecLValueEntry."Entry Type"::Revaluation)
                            and
                           (RecLValueEntry."Cost Amount (Actual)" <> 0)
                        then
                            DecLValueOfWIP += 0;
                    end else
                        case RecLValueEntry."Item Ledger Entry Type" of
                            RecLValueEntry."Item Ledger Entry Type"::Consumption:
                                if IsProductionCost(RecLValueEntry) then
                                    DecLValueOfMatConsump += -RecLValueEntry."Cost Amount (Actual)";

                            RecLValueEntry."Item Ledger Entry Type"::" ":
                                if IsSubcontractorLine(RecLValueEntry) then
                                    DecLValueOfCapVendor += RecLValueEntry."Cost Amount (Actual)"
                                else
                                    DecLValueOfCap += RecLValueEntry."Cost Amount (Actual)";

                            RecLValueEntry."Item Ledger Entry Type"::Output:
                                begin
                                    DecLValueOfExpOutput2 += -RecLValueEntry."Cost Amount (Expected)";
                                    DecLValueOfOutput += -(RecLValueEntry."Cost Amount (Actual)" + RecLValueEntry."Cost Amount (Expected)");
                                    if RecLValueEntry."Entry Type" = RecLValueEntry."Entry Type"::Revaluation then
                                        DecLValueOfRevalCostAct += -RecLValueEntry."Cost Amount (Actual)";
                                end;
                        end;

            until RecLValueEntry.Next() = 0;

        if (DecLValueOfExpOutput2 + DecLValueOfExpOutput1) = 0 then
            DecLValueOfOutput -= DecLValueOfRevalCostAct;

        // 7 - En cours M-1
        TxtPTextFields[7] := Format(DecLValueOfWIP);

        // 8 - Consommation
        TxtPTextFields[8] := Format(DecLValueOfMatConsump);

        // 9 - Capacité
        TxtPTextFields[9] := Format(DecLValueOfCap);

        // 10 - Sous-traitance
        TxtPTextFields[10] := Format(DecLValueOfCapVendor);

        //11 - Production
        TxtPTextFields[11] := Format(DecLValueOfOutput);

        // 12 - En cours M
        TxtPTextFields[12] := Format(DecLValueOfWIP + DecLValueOfMatConsump + DecLValueOfCap + DecLValueOfCapVendor + DecLValueOfOutput);
    end;


    procedure IsProductionCost(RecPValueEntry: Record "Value Entry"): Boolean
    var
        ILE: Record "Item Ledger Entry";
    begin
        if (RecPValueEntry."Entry Type" = RecPValueEntry."Entry Type"::Revaluation) and (RecPValueEntry."Item Ledger Entry Type" = RecPValueEntry."Item Ledger Entry Type"::Consumption) then begin
            ILE.Get(RecPValueEntry."Item Ledger Entry No.");
            if ILE.Positive then
                exit(false)
        end;

        exit(true);
    end;


    procedure IsNotWIP(RecPValueEntry: Record "Value Entry"): Boolean
    begin
        if RecPValueEntry."Item Ledger Entry Type" = RecPValueEntry."Item Ledger Entry Type"::Output then
            exit(not (RecPValueEntry."Entry Type" in [RecPValueEntry."Entry Type"::"Direct Cost",
                                       RecPValueEntry."Entry Type"::Revaluation]));

        exit(RecPValueEntry."Expected Cost");
    end;


    procedure IsSubcontractorLine(RecPValueEntry: Record "Value Entry"): Boolean
    var
        RecLWorkCenter: Record "Work Center";
    begin
        if RecPValueEntry.Type <> RecPValueEntry.Type::"Work Center" then
            exit(false);

        RecLWorkCenter.Get(RecPValueEntry."No.");
        exit(RecLWorkCenter."Subcontractor No." <> '');
    end;


    procedure IsSubcontractorProdOrder(RecPProdOrder: Record "Production Order"): Boolean
    var
        RecLPORoutingLine: Record "Prod. Order Routing Line";
        RecLWorkCenter: Record "Work Center";
        BooLIsSubcontractor: Boolean;
    begin

        BooLIsSubcontractor := false;
        RecLPORoutingLine.SetRange(Status, RecPProdOrder.Status);
        RecLPORoutingLine.SetRange("Prod. Order No.", RecPProdOrder."No.");
        RecLPORoutingLine.SetRange(Type, RecLPORoutingLine.Type::"Work Center");
        if RecLPORoutingLine.FindSet() then
            repeat
                RecLWorkCenter.Get(RecLPORoutingLine."No.");
                BooLIsSubcontractor := RecLWorkCenter."Subcontractor No." <> '';

            until (RecLPORoutingLine.Next() = 0) or BooLIsSubcontractor;

        exit(BooLIsSubcontractor);
    end;


    procedure SetDataExport(BooPItem: Boolean; BooPInventory: Boolean; BooPProdOrder: Boolean; BooPFinishedPO: Boolean; DatPReferenceDate: Date; BooPManualLaunch: Boolean)
    begin
        BooGItem := BooPItem;
        BooGInventory := BooPInventory;
        BooGProdOrder := BooPProdOrder;
        BooGFinishedPO := BooPFinishedPO;
        DatGReferenceDate := DatPReferenceDate;
        if DatGReferenceDate = 0D then
            DatGReferenceDate := Today;
        BooGManualLaunch := BooPManualLaunch;
    end;


    procedure SendEmail()
    begin
    end;


    procedure CalcInventoryCover(CodPItem: Code[20]; RecPLocation: Record Location; DecPInventory: Decimal): Decimal
    var
        RecLItemLdgrEntry: Record "Item Ledger Entry";
        DatLCoverStartMonth: Date;
    begin
        DatLCoverStartMonth := CalcDate(StrSubstNo('<-%1M>', RecGInventorySetup."PWD Period for Inventory Cover"), DatGCurrStartMonth);

        RecLItemLdgrEntry.SetCurrentKey("Item No.", "Entry Type", "Variant Code", "Drop Shipment", "Location Code", "Posting Date");
        RecLItemLdgrEntry.SetRange("Item No.", CodPItem);
        RecLItemLdgrEntry.SetRange("Location Code", RecPLocation.Code);
        RecLItemLdgrEntry.SetRange("Posting Date", DatLCoverStartMonth, DatGCurrEndMonth);
        RecLItemLdgrEntry.SetFilter("Entry Type", '%1|%2', RecLItemLdgrEntry."Entry Type"::Consumption, RecLItemLdgrEntry."Entry Type"::Sale)
        ;
        RecLItemLdgrEntry.CalcSums(Quantity);

        if RecLItemLdgrEntry.Quantity = 0 then
            exit(0)
        else
            exit(Abs(DecPInventory) / (Abs(RecLItemLdgrEntry.Quantity) / RecGInventorySetup."PWD Period for Inventory Cover"));
    end;
}

