codeunit 50002 "PWD Lot Inheritance Mgt.PW"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // FE_LAPIERRETTE_PROD01.001: TO 13/12/2011:  No Commande vente identique OF-LOT
    //                                           - create
    // 
    // 
    // 
    // ------------------------------------------------------------------------------------------------------------------


    trigger OnRun()
    begin
    end;

    var
        CstG001: Label 'At Component %1 (From the same Lot) different Lots are available.';
        CstG002: Label 'You cannot change the Lot Inheritance/Expiration Determination of Prod. Order Component %1, because there exists at least one Item Ledger Entry associated with it.';
        CstG003: Label 'At Component %1 (From the same Lot) different Lots are available.';
        CstG004: Label 'You must enter only one Item Tracking Line.';
        gExtItemNo: Code[20];
        gExtVariantCode: Code[10];
        gExtSerialNo: Code[20];
        gExtLocationCode: Code[10];
        gExtBincode: Code[20];
        gctxErr0006: Label 'Source Type %1 is not supported.';
        gctxMsg0002: Label 'Lot Inheritance: It is not possible to inherit the lot of the lot determining component to the item of the related product, because posted entries exist.';


    procedure CheckBOMDetermining(var pioProdBOMLine: Record "Production BOM Line"; var pioNeededHits: Integer): Boolean
    var
        SearchFor: Option Determining,DetermAllSet,FromSameLotAllSet;
    begin
        IF CheckBOMLotInheritanceOnLevel(
          pioProdBOMLine,
          pioNeededHits,
          pioProdBOMLine."No.",
          SearchFor::Determining,
          /*piSet=ignore*/ FALSE)
        THEN
            EXIT(TRUE);

        IF CheckBOMDetermUp(
          pioProdBOMLine,
          pioNeededHits,
          pioProdBOMLine."No.")
        THEN
            EXIT(TRUE);

        EXIT(FALSE);

    end;

    local procedure CheckBOMLotInheritanceOnLevel(var pioProdBOMLine: Record "Production BOM Line"; var pioNeededHits: Integer; piActualItem: Code[20]; piSearchFor: Option Determining,DetermAllSet,FromSameLotAllSet; piSet: Boolean): Boolean
    var
        Level: Integer;
        VersionCode: array[99] of Code[10];
        ProdBOMLine: array[99] of Record "Production BOM Line";
        NoList: array[99] of Code[20];
        NoListType: array[99] of Option Item,"Production BOM";
        StopLoop: Boolean;
        NoNext: Boolean;
        ItemUpperLevel: Record Item;
        NextLevel: Integer;
        ItemComp: Record Item;
        ProdBOMHeader: Record "Production BOM Header";
        ProdBOMVersion: array[99] of Record "Production BOM Version";
        SearchInVersions: array[99] of Boolean;
    begin
        Level := 1;

        VersionCode[Level] := pioProdBOMLine."Version Code";
        CLEAR(ProdBOMLine);
        ProdBOMLine[Level]."Production BOM No." := pioProdBOMLine."Production BOM No.";
        ProdBOMLine[Level].SETRANGE("Production BOM No.", pioProdBOMLine."Production BOM No.");
        ProdBOMLine[Level].SETRANGE("Version Code", VersionCode[Level]);
        NoList[Level] := pioProdBOMLine."Production BOM No.";
        NoListType[Level] := NoListType[Level] ::"Production BOM";

        StopLoop := FALSE;
        REPEAT
            NoNext := ProdBOMLine[Level].NEXT() = 0;
            WHILE NoNext AND (NOT StopLoop) DO BEGIN
                Level := Level - 1;
                IF Level < 1 THEN
                    StopLoop := TRUE;
                IF NOT StopLoop THEN BEGIN
                    IF NoListType[Level] = NoListType[Level] ::Item THEN
                        ItemUpperLevel.GET(NoList[Level])
                    ELSE
                        ItemUpperLevel."Production BOM No." := NoList[Level];
                    ProdBOMLine[Level].SETRANGE("Production BOM No.", ItemUpperLevel."Production BOM No.");
                    ProdBOMLine[Level].SETRANGE("Version Code", VersionCode[Level]);
                    IF SearchInVersions[Level] THEN
                        NoNext := FALSE
                    ELSE
                        NoNext := ProdBOMLine[Level].NEXT() = 0;
                END;
            END;

            IF NOT StopLoop THEN BEGIN
                NextLevel := Level;
                CLEAR(ItemComp);
                CASE ProdBOMLine[Level].Type OF
                    ProdBOMLine[Level].Type::Item:

                        //Begin#803/01:A9227/2.10.09  22.02.06 TECTURA.WW
                        IF ProdBOMLine[Level]."No." <> '' THEN BEGIN
                            //End#803/01:A9227/2.10.09  22.02.06 TECTURA.WW
                            CASE piSearchFor OF
                                piSearchFor::Determining:

                                    IF ProdBOMLine[Level]."No." <> piActualItem THEN
                                        IF ProdBOMLine[Level]."Lot Determining" THEN BEGIN
                                            pioNeededHits -= 1;
                                            IF pioNeededHits < 0 THEN BEGIN
                                                pioProdBOMLine := ProdBOMLine[Level];
                                                EXIT(TRUE);
                                            END;
                                        END;
                                piSearchFor::DetermAllSet:

                                    IF (ProdBOMLine[Level]."No." = piActualItem) AND
                                       (ProdBOMLine[Level]."Lot Determining" <> piSet)
                                    THEN BEGIN
                                        pioNeededHits -= 1;
                                        IF pioNeededHits < 0 THEN BEGIN
                                            pioProdBOMLine := ProdBOMLine[Level];
                                            EXIT(TRUE);
                                        END;
                                    END;
                                piSearchFor::FromSameLotAllSet:

                                    ;
                            //                  IF (ProdBOMLine[Level]."No." = piActualItem) AND
                            //                     (ProdBOMLine[Level]."From the same Lot" <> piSet)
                            //                  THEN BEGIN
                            //                    pioNeededHits -= 1;
                            //                    IF pioNeededHits < 0 THEN BEGIN
                            //                      pioProdBOMLine := ProdBOMLine[Level];
                            //                      EXIT(TRUE);
                            //                    END;
                            //                  END;
                            END;
                            ItemComp.GET(ProdBOMLine[Level]."No.");
                            //Begin#803/01:A9227/2.10.09  22.02.06 TECTURA.WW
                        END;
                    //End#803/01:A9227/2.10.09  22.02.06 TECTURA.WW
                    ProdBOMLine[Level].Type::"Production BOM":

                        IF SearchInVersions[Level] THEN BEGIN
                            NextLevel := Level + 1;
                            IF ProdBOMVersion[Level].NEXT() = 0 THEN BEGIN
                                SearchInVersions[Level] := FALSE;
                                CLEAR(ProdBOMVersion[Level]);
                            END;
                            VersionCode[NextLevel] := ProdBOMVersion[Level]."Version Code";
                            ProdBOMLine[NextLevel].SETRANGE("Production BOM No.", NoList[NextLevel]);
                            ProdBOMLine[NextLevel].SETRANGE("Version Code", VersionCode[NextLevel]);
                        END ELSE
                            IF ProdBOMLine[Level]."No." <> pioProdBOMLine."Production BOM No." THEN BEGIN
                                ProdBOMHeader.GET(ProdBOMLine[Level]."No.");
                                NextLevel := Level + 1;
                                CLEAR(ProdBOMLine[NextLevel]);
                                NoListType[NextLevel] := NoListType[NextLevel] ::"Production BOM";
                                NoList[NextLevel] := ProdBOMHeader."No.";
                                ProdBOMVersion[Level].SETRANGE("Production BOM No.", ProdBOMHeader."No.");
                                IF ProdBOMVersion[Level].FIND('-') THEN
                                    SearchInVersions[Level] := TRUE
                                ELSE
                                    CLEAR(ProdBOMVersion[Level]);
                                VersionCode[NextLevel] := ProdBOMVersion[Level]."Version Code";
                                ProdBOMLine[NextLevel].SETRANGE("Production BOM No.", NoList[NextLevel]);
                                ProdBOMLine[NextLevel].SETRANGE("Version Code", VersionCode[NextLevel]);
                            END;
                END;

                Level := NextLevel;
                IF ItemComp."Production BOM No." <> '' THEN
                    ItemUpperLevel := ItemComp;
            END;
        UNTIL StopLoop;

        EXIT(FALSE);
    end;

    local procedure CheckBOMDetermUp(var pioProdBOMLine: Record "Production BOM Line"; var pioNeededHits: Integer; piActualItem: Code[20]): Boolean
    var
        ProdBOMLine: Record "Production BOM Line";
        ProdBOMVersion: Record "Production BOM Version";
        SearchFor: Option Determining,DetermAllSet,FromSameLotAllSet;
    begin
        //examine, where this BOM is Used
        //examine the same Level (always to do)
        ProdBOMLine.SETCURRENTKEY(Type, "No.");
        ProdBOMLine.SETRANGE(Type, ProdBOMLine.Type::"Production BOM");
        ProdBOMLine.SETRANGE("No.", pioProdBOMLine."Production BOM No.");
        IF ProdBOMLine.FIND('-') THEN
            REPEAT
                IF ProdBOMVersion.GET(ProdBOMLine."Production BOM No.", ProdBOMLine."Version Code") THEN BEGIN

                    IF CheckBOMLotInheritanceOnLevel(
                      ProdBOMLine,
                      pioNeededHits,
                      piActualItem,
                      SearchFor::Determining,
                      /*piSet=ignore*/ FALSE)
                    THEN BEGIN
                        pioProdBOMLine := ProdBOMLine;
                        EXIT(TRUE);
                    END;

                    IF CheckBOMDetermUp(
                      ProdBOMLine,
                      pioNeededHits,
                      piActualItem)
                    THEN BEGIN
                        pioProdBOMLine := ProdBOMLine;
                        EXIT(TRUE);
                    END;
                END;
            UNTIL ProdBOMLine.NEXT() = 0;

        EXIT(FALSE);

    end;


    procedure GetLotDeterminingData(var pioItemJnlLine: Record "Item Journal Line"; var poLotDetLotCode: Code[30]; var poLotDetExpirDate: Date)
    var
        ProdOrderComp: Record "Prod. Order Component";
        ItemLedgEntry: Record "Item Ledger Entry";
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        ItemJnlLine: Record "Item Journal Line";
        ReservEntry: Record "Reservation Entry";
        totalQty: Decimal;
    begin
        //Begin#803/01:A20071/3.00  11.05.07 TECTURA.WW
        // ORIG:
        // MfgSetup.GET;
        //LSSetup.GET;
        //End#803/01:A20071/3.00  11.05.07 TECTURA.WW

        poLotDetLotCode := '';
        poLotDetExpirDate := 0D;

        WITH pioItemJnlLine DO BEGIN
            ProdOrderComp.SETRANGE(Status, ProdOrderComp.Status::Released);
            ProdOrderComp.SETRANGE("Prod. Order No.", "Prod. Order No.");
            ProdOrderComp.SETRANGE("Prod. Order Line No.", "Prod. Order Line No.");
            ProdOrderComp.SETRANGE("Lot Determining", TRUE);
            IF ProdOrderComp.FIND('=><') THEN BEGIN
                //Begin#803/01:A9203/2.10.08  19.12.05 TECTURA.WW
                ItemLedgEntry.SETCURRENTKEY(
                  "Prod. Order No.",
                  "Prod. Order Line No.",
                  "Entry Type",
                  "Prod. Order Comp. Line No.");
                //End#803/01:A9203/2.10.08  19.12.05 TECTURA.WW
                ItemLedgEntry.SETRANGE("Prod. Order No.", ProdOrderComp."Prod. Order No.");
                ItemLedgEntry.SETRANGE("Prod. Order Line No.", ProdOrderComp."Prod. Order Line No.");
                ItemLedgEntry.SETRANGE("Entry Type", ItemLedgEntry."Entry Type"::Consumption);
                ItemLedgEntry.SETRANGE("Item No.", ProdOrderComp."Item No.");

                IF ItemLedgEntry.FIND('-') THEN
                    REPEAT
                        TempItemLedgEntry := ItemLedgEntry;
                        TempItemLedgEntry.INSERT();
                    UNTIL ItemLedgEntry.NEXT() = 0;

                IF TempItemLedgEntry.FIND('-') THEN BEGIN
                    REPEAT
                        //Begin#803/01:A20071/3.00  11.05.07 TECTURA.WW
                        // ORIG:
                        // IF MfgSetup."Lot Trading Unit Inheritance" THEN
                        //IF LSSetup."Lot Trading Unit Inheritance" THEN
                        //End#803/01:A20071/3.00  11.05.07 TECTURA.WW
                        TempItemLedgEntry.SETRANGE("Lot No.", TempItemLedgEntry."Lot No.");
                        //ELSE
                        //  TempItemLedgEntry.SETRANGE("Lot Number", TempItemLedgEntry."Lot Number");

                        poLotDetExpirDate := TempItemLedgEntry."Expiration Date";

                        REPEAT
                            //Begin#803/01:A20071/3.00  11.05.07 TECTURA.WW
                            // ORIG:
                            // IF MfgSetup."Lot Trading Unit Inheritance" THEN
                            //IF LSSetup."Lot Trading Unit Inheritance" THEN
                            //End#803/01:A20071/3.00  11.05.07 TECTURA.WW
                            poLotDetLotCode := TempItemLedgEntry."Lot No.";
                            //ELSE
                            //  poLotDetLotCode := TempItemLedgEntry."Lot Number";
                            IF (poLotDetExpirDate > TempItemLedgEntry."Expiration Date") AND
                               (TempItemLedgEntry."Expiration Date" <> 0D)
                            THEN
                                poLotDetExpirDate := TempItemLedgEntry."Expiration Date";
                            totalQty += TempItemLedgEntry.Quantity;
                        UNTIL TempItemLedgEntry.NEXT() = 0;

                        IF totalQty = 0 THEN
                            TempItemLedgEntry.DELETEALL();
                        TempItemLedgEntry.RESET();
                    UNTIL (NOT TempItemLedgEntry.FIND('-')) OR (totalQty <> 0);

                    IF totalQty = 0 THEN BEGIN
                        poLotDetLotCode := '';
                        poLotDetExpirDate := 0D;
                    END ELSE BEGIN
                        //Begin#803/01:A20071/3.00  11.05.07 TECTURA.WW
                        // ORIG:
                        // IF MfgSetup."Lot Trading Unit Inheritance" THEN
                        //IF LSSetup."Lot Trading Unit Inheritance" THEN
                        //End#803/01:A20071/3.00  11.05.07 TECTURA.WW
                        ItemLedgEntry.SETFILTER("Lot No.", '<>%1', poLotDetLotCode);
                        //ELSE
                        //  ItemLedgEntry.SETFILTER("Lot Number", '<>%1', poLotDetLotCode);
                        IF GetItemLedgerEntryQty(ItemLedgEntry) <> 0 THEN
                            ERROR(CstG001, ProdOrderComp."Item No.");
                    END;
                END;

                //Begin#803/01:A9069/2.10.01  25.02.05 TECTURA.WW
                IF poLotDetLotCode = '' THEN BEGIN
                    ItemJnlLine.SETRANGE("Journal Template Name", pioItemJnlLine."Journal Template Name");
                    ItemJnlLine.SETRANGE("Journal Batch Name", pioItemJnlLine."Journal Batch Name");
                    ItemJnlLine.SETRANGE("Entry Type", ItemJnlLine."Entry Type"::Consumption);
                    ItemJnlLine.SETRANGE("Prod. Order No.", pioItemJnlLine."Prod. Order No.");
                    ItemJnlLine.SETRANGE("Prod. Order Line No.", pioItemJnlLine."Prod. Order Line No.");
                    IF ItemJnlLine.FIND('-') THEN BEGIN
                        ReservEntry.SETCURRENTKEY(
                            "Source Type",
                            "Source Subtype",
                            "Source ID",
                            "Source Batch Name",
                            "Source Prod. Order Line",
                            "Source Ref. No.");
                        ReservEntry.SETRANGE("Source Type", DATABASE::"Item Journal Line");
                        ReservEntry.SETRANGE("Source Subtype", ItemJnlLine."Entry Type");
                        ReservEntry.SETRANGE("Source ID", ItemJnlLine."Journal Template Name");
                        ReservEntry.SETRANGE("Source Batch Name", ItemJnlLine."Journal Batch Name");
                        ReservEntry.SETRANGE("Source Prod. Order Line", 0);
                        ReservEntry.SETRANGE("Source Ref. No.", ItemJnlLine."Line No.");
                        ReservEntry.SETFILTER("Lot No.", '<>%1', '');
                        IF ReservEntry.FIND('><=') THEN BEGIN
                            //IF LotNoInfo.GET(
                            //  ItemJnlLine."Item No.",
                            //  ItemJnlLine."Variant Code",
                            //  ReservEntry."Lot Number",
                            //  //Begin#803/01:A20120/3.00  14.04.07 TECTURA.WW
                            // ORIG:
                            // ReservEntry."Trading Unit Number")
                            //  ReservEntry."Trading Unit Number",
                            //  ReservEntry."Serial No.")
                            //End#803/01:A20120/3.00  14.04.07 TECTURA.WW
                            //THEN
                            //  poLotDetExpirDate := LotNoInfo."Expiration Date"
                            //ELSE
                            poLotDetExpirDate := ReservEntry."Expiration Date";
                            //Begin#803/01:A20071/3.00  11.05.07 TECTURA.WW
                            // ORIG:
                            // IF MfgSetup."Lot Trading Unit Inheritance" THEN
                            //IF LSSetup."Lot Trading Unit Inheritance" THEN
                            //End#803/01:A20071/3.00  11.05.07 TECTURA.WW
                            poLotDetLotCode := ReservEntry."Lot No."
                            //ELSE
                            //  poLotDetLotCode := ReservEntry."Lot Number";
                        END;
                    END;
                END;
                //End#803/01:A9069/2.10.01  25.02.05 TECTURA.WW
            END;
            //Begin#803/01:A20020/3.00  22.05.07 TECTURA.WW
            //IF NOT ProdOrderComp."Expiration Determining" THEN
            //  poLotDetExpirDate := 0D;
            //End#803/01:A20020/3.00  22.05.07 TECTURA.WW
        END;
    end;


    procedure CheckInheritPOCompChangeable(piProdOrderComp: Record "Prod. Order Component"): Boolean
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        //Begin#803/01:A9203/2.10.08  19.12.05 TECTURA.WW
        ItemLedgEntry.SETCURRENTKEY(
          "Prod. Order No.",
          "Prod. Order Line No.",
          "Entry Type",
          "Prod. Order Comp. Line No.");
        //End#803/01:A9203/2.10.08  19.12.05 TECTURA.WW

        ItemLedgEntry.SETRANGE("Prod. Order No.", piProdOrderComp."Prod. Order No.");
        ItemLedgEntry.SETRANGE("Prod. Order Line No.", piProdOrderComp."Prod. Order Line No.");
        ItemLedgEntry.SETRANGE("Prod. Order Comp. Line No.", piProdOrderComp."Line No.");
        ItemLedgEntry.SETRANGE("Entry Type", ItemLedgEntry."Entry Type"::Consumption);

        IF GetItemLedgerEntryQty(ItemLedgEntry) <> 0 THEN
            ERROR(CstG002, piProdOrderComp."Line No.");
    end;


    procedure GetItemLedgerEntryQty(var pioItemLedgEntry: Record "Item Ledger Entry") retQty: Decimal
    begin
        IF pioItemLedgEntry.FIND('-') THEN BEGIN
            REPEAT
                retQty += pioItemLedgEntry.Quantity;
            UNTIL pioItemLedgEntry.NEXT() = 0;
            pioItemLedgEntry.FIND('-');
        END;
    end;


    procedure CheckPOCompOnInsert(var pioProdOrderComp: Record "Prod. Order Component")
    var
        ProdOrderComp: Record "Prod. Order Component";
    begin
        ProdOrderComp.SETRANGE(Status, pioProdOrderComp.Status);
        ProdOrderComp.SETRANGE("Prod. Order No.", pioProdOrderComp."Prod. Order No.");
        ProdOrderComp.SETRANGE("Prod. Order Line No.", pioProdOrderComp."Prod. Order Line No.");
        ProdOrderComp.SETRANGE("Item No.", pioProdOrderComp."Item No.");

        IF ProdOrderComp.FIND('-') THEN
            pioProdOrderComp."Lot Determining" := ProdOrderComp."Lot Determining";
    end;


    procedure PhysInvJnl_RetrieveItemTrkg(var pioItemJnlLine: Record "Item Journal Line")
    var
        SourceTrkgSpec: Record "Tracking Specification";
        TempTrackingSpecification: Record "Tracking Specification" temporary;
        cuReserveItemJnlLine: Codeunit "Item Jnl. Line-Reserve";
    begin

        //IF NOT pioItemJnlLine."Phys. Inventory" THEN
        //  EXIT;

        cuReserveItemJnlLine.InitTrackingSpecification(pioItemJnlLine, SourceTrkgSpec);


        CLEAR(frmItemTrkgLines);
        frmItemTrkgLines.SetSource(SourceTrkgSpec, pioItemJnlLine."Posting Date");
        frmItemTrkgLines.GetTempTrkgSpec(TempTrackingSpecification);
        IF TempTrackingSpecification.COUNT > 1 THEN
            ERROR(CstG004);

        IF NOT TempTrackingSpecification.FIND('-') THEN
            EXIT;

        //pioItemJnlLine."Phys. Inv. Lot Number" := TempTrackingSpecification."Lot Number";
        //pioItemJnlLine."Phys. Inv. Trading Unit Number" := TempTrackingSpecification."Trading Unit Number";
        //pioItemJnlLine."Phys. Inv. Lot No." := TempTrackingSpecification."Lot No.";
        //pioItemJnlLine."Phys. Inv. Serial No." := TempTrackingSpecification."Serial No.";
        //pioItemJnlLine.MODIFY(TRUE);
    end;


    procedure AutoCreateItemJnlLineTracking(piItemJnlLine: Record "Item Journal Line")
    var
        Item: Record Item;
        OutputJnlLine: Record "Item Journal Line";
        TrackingSpecification: Record "Tracking Specification";
        TempTrackingSpecification: Record "Tracking Specification" temporary;
        ReservEntry: Record "Reservation Entry";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderComp: Record "Prod. Order Component";
        ProdOrderRtngLine: Record "Prod. Order Routing Line";
        cuReserveItemJnlLine: Codeunit "Item Jnl. Line-Reserve";
        LotDetLotCode: Code[30];
        LotDetExpirDate: Date;
        OutputFound: Boolean;
        Stop: Boolean;
    begin
        //  locales manquantes
        // LSSetup                     Record                    Table5060454
        // cuTradingUnitMgt            Codeunit                  Codeunit5060482

        IF piItemJnlLine."Entry Type" <> piItemJnlLine."Entry Type"::Consumption THEN
            EXIT;


        IF NOT ProdOrderComp.GET(
          ProdOrderComp.Status::Released,
          piItemJnlLine."Prod. Order No.",
          piItemJnlLine."Prod. Order Line No.",
          piItemJnlLine."Prod. Order Comp. Line No.")
        THEN
            EXIT;

        IF NOT ProdOrderComp."Lot Determining" THEN
            EXIT;


        //Check, if Output ItemJnlLine exist in the same Template/Batch
        Stop := FALSE;
        OutputFound := FALSE;
        //Begin#803/01:A10211/2.20.04  12.01.07 TECTURA.WW
        ProdOrderLine.GET(
          ProdOrderComp.Status,
          ProdOrderComp."Prod. Order No.",
          ProdOrderComp."Prod. Order Line No.");
        ProdOrderRtngLine.SETRANGE(Status, ProdOrderLine.Status);
        ProdOrderRtngLine.SETRANGE("Prod. Order No.", ProdOrderLine."Prod. Order No.");
        ProdOrderRtngLine.SETRANGE("Routing Reference No.", ProdOrderLine."Routing Reference No.");
        ProdOrderRtngLine.SETRANGE("Routing No.", ProdOrderLine."Routing No.");

        IF NOT ProdOrderRtngLine.FIND('-') THEN BEGIN
            OutputJnlLine.SETRANGE("Journal Template Name", piItemJnlLine."Journal Template Name");
            OutputJnlLine.SETRANGE("Journal Batch Name", piItemJnlLine."Journal Batch Name");
            OutputJnlLine.SETRANGE("Entry Type", OutputJnlLine."Entry Type"::Output);
            OutputJnlLine.SETRANGE("Prod. Order No.", piItemJnlLine."Prod. Order No.");
            OutputJnlLine.SETRANGE("Prod. Order Line No.", piItemJnlLine."Prod. Order Line No.");
            OutputFound := OutputJnlLine.FINDFIRST();
        END ELSE BEGIN
            //End#803/01:A10211/2.20.04  12.01.07 TECTURA.WW
            OutputJnlLine.SETRANGE("Journal Template Name", piItemJnlLine."Journal Template Name");
            OutputJnlLine.SETRANGE("Journal Batch Name", piItemJnlLine."Journal Batch Name");
            OutputJnlLine.SETRANGE("Entry Type", OutputJnlLine."Entry Type"::Output);
            OutputJnlLine.SETRANGE("Prod. Order No.", piItemJnlLine."Prod. Order No.");
            OutputJnlLine.SETRANGE("Prod. Order Line No.", piItemJnlLine."Prod. Order Line No.");
            IF OutputJnlLine.FIND('-') THEN
                REPEAT
                    ProdOrderRtngLine.GET(
                      ProdOrderRtngLine.Status::Released,
                      OutputJnlLine."Prod. Order No.",
                      OutputJnlLine."Routing Reference No.",
                      OutputJnlLine."Routing No.",
                      OutputJnlLine."Operation No.");
                    ProdOrderRtngLine.RESET();
                    ProdOrderRtngLine.SETRANGE(Status, ProdOrderRtngLine.Status);
                    ProdOrderRtngLine.SETRANGE("Prod. Order No.", ProdOrderRtngLine."Prod. Order No.");
                    ProdOrderRtngLine.SETRANGE("Routing No.", ProdOrderRtngLine."Routing No.");
                    ProdOrderRtngLine.SETRANGE("Routing Reference No.", ProdOrderRtngLine."Routing Reference No.");
                    IF NOT ProdOrderRtngLine.FIND('>') THEN BEGIN
                        Stop := TRUE;
                        OutputFound := TRUE;
                    END ELSE
                        Stop := OutputJnlLine.NEXT() = 0;
                UNTIL Stop;
            //Begin#803/01:A10211/2.20.04  12.01.07 TECTURA.WW
        END;
        //End#803/01:A10211/2.20.04  12.01.07 TECTURA.WW


        IF NOT OutputFound THEN
            EXIT;

        IF OutputJnlLine."Output Quantity (Base)" <= 0 THEN
            EXIT;

        IF NOT Item.GET(OutputJnlLine."Item No.") THEN
            EXIT;

        //IF Item."Handled in Trading Units" THEN BEGIN
        //  MESSAGE(gctxMsg0001);
        //  EXIT;
        //END;

        IF NOT ProdOrderLine.GET(
          ProdOrderLine.Status::Released,
          piItemJnlLine."Prod. Order No.",
          piItemJnlLine."Prod. Order Line No.")
        THEN
            EXIT;



        GetLotDeterminingDataPOL(ProdOrderLine, LotDetLotCode, LotDetExpirDate);


        IF LotDetLotCode <> '' THEN
            EXIT;


        //Begin#803/01:A20071/3.00  11.05.07 TECTURA.WW
        // ORIG:
        // MfgSetup.GET;
        //LSSetup.GET;
        //End#803/01:A20071/3.00  11.05.07 TECTURA.WW
        ReservEntry.SETCURRENTKEY(
          "Source Type",
          "Source Subtype",
          "Source ID",
          "Source Batch Name",
          "Source Prod. Order Line",
          "Source Ref. No.");
        ReservEntry.SETRANGE("Source Type", DATABASE::"Item Journal Line");
        ReservEntry.SETRANGE("Source Subtype", piItemJnlLine."Entry Type");
        ReservEntry.SETRANGE("Source ID", piItemJnlLine."Journal Template Name");
        ReservEntry.SETRANGE("Source Batch Name", piItemJnlLine."Journal Batch Name");
        ReservEntry.SETRANGE("Source Prod. Order Line", 0);
        ReservEntry.SETRANGE("Source Ref. No.", piItemJnlLine."Line No.");
        ReservEntry.SETFILTER("Lot No.", '<>%1', '');

        IF ReservEntry.FIND('><=') THEN
            //IF LotNoInfo.GET(
            //  piItemJnlLine."Item No.",
            //  piItemJnlLine."Variant Code",
            //  ReservEntry."Lot Number",
            //  //Begin#803/01:A20120/3.00  14.04.07 TECTURA.WW
            //  // ORIG:
            //  // ReservEntry."Trading Unit Number")
            //  ReservEntry."Trading Unit Number",
            //  ReservEntry."Serial No.")
            //  //End#803/01:A20120/3.00  14.04.07 TECTURA.WW
            //THEN
            //  LotDetExpirDate := LotNoInfo."Expiration Date"
            //ELSE
            //  LotDetExpirDate := ReservEntry."Expiration Date";
            //Begin#803/01:A20071/3.00  11.05.07 TECTURA.WW
            // ORIG:
            // IF MfgSetup."Lot Trading Unit Inheritance" THEN
            //IF LSSetup."Lot Trading Unit Inheritance" THEN
            ////End#803/01:A20071/3.00  11.05.07 TECTURA.WW
            //  LotDetLotCode := ReservEntry."Lot No."
            //ELSE
            //  LotDetLotCode := ReservEntry."Lot Number";

            LotDetLotCode := ReservEntry."Lot No.";


        cuReserveItemJnlLine.InitTrackingSpecification(OutputJnlLine, TrackingSpecification);
        IF LotDetLotCode <> '' THEN BEGIN
            TempTrackingSpecification := TrackingSpecification;
            ////Begin#803/01:A10017-7/2.20  22.06.06 TECTURA.WW
            //TempTrackingSpecification."Lot Number" := cuTradingUnitMgt.GetLotNo(LotDetLotCode);
            ////End#803/01:A10017-7/2.20  22.06.06 TECTURA.WW
            //TempTrackingSpecification."Trading Unit Number" := '';
            TempTrackingSpecification."Expiration Date" := LotDetExpirDate;
            //  TempTrackingSpecification."Lot No." :=
            //    cuTradingUnitMgt.GetLotTradingUnitNo(
            //      TempTrackingSpecification."Lot Number",
            //      TempTrackingSpecification."Trading Unit Number");
            TempTrackingSpecification."Lot No." := LotDetLotCode;              // PADE

            TempTrackingSpecification."Quantity (Base)" := OutputJnlLine."Output Quantity (Base)";
            TempTrackingSpecification."Qty. to Handle (Base)" := OutputJnlLine."Output Quantity (Base)";
            TempTrackingSpecification."Qty. to Invoice (Base)" := OutputJnlLine."Output Quantity (Base)";
            TempTrackingSpecification.INSERT();
        END;


        CLEAR(FrmItemTrackingForm);
        FrmItemTrackingForm.SetBlockCommit(TRUE);
        FrmItemTrackingForm.RegisterItemTrackingLines2(
          TrackingSpecification,
          piItemJnlLine."Posting Date",
          TempTrackingSpecification,
         TRUE);
    end;


    procedure GetLotDeterminingDataPOL(var pioProdOrderLine: Record "Prod. Order Line"; var poLotDetLotCode: Code[30]; var poLotDetExpirDate: Date)
    var
        ProdOrderComp: Record "Prod. Order Component";
        ItemLedgEntry: Record "Item Ledger Entry";
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        ReservEntry: Record "Reservation Entry";
        totalQty: Decimal;
    begin
        //  locales manquantes
        // LSSetup                     Record                    Table5060454



        poLotDetLotCode := '';
        poLotDetExpirDate := 0D;


        WITH pioProdOrderLine DO BEGIN
            ProdOrderComp.SETRANGE(Status, Status);
            ProdOrderComp.SETRANGE("Prod. Order No.", "Prod. Order No.");
            ProdOrderComp.SETRANGE("Prod. Order Line No.", "Line No.");
            ProdOrderComp.SETRANGE("Lot Determining", TRUE);
            IF ProdOrderComp.FIND('=><') THEN BEGIN
                ItemLedgEntry.SETCURRENTKEY(
                  "Prod. Order No.",
                  "Prod. Order Line No.",
                  "Entry Type",
                  "Prod. Order Comp. Line No.");

                ItemLedgEntry.SETRANGE("Prod. Order No.", ProdOrderComp."Prod. Order No.");
                ItemLedgEntry.SETRANGE("Prod. Order Line No.", ProdOrderComp."Prod. Order Line No.");
                ItemLedgEntry.SETRANGE("Entry Type", ItemLedgEntry."Entry Type"::Consumption);
                ItemLedgEntry.SETRANGE("Item No.", ProdOrderComp."Item No.");

                IF ItemLedgEntry.FIND('-') THEN
                    REPEAT
                        TempItemLedgEntry := ItemLedgEntry;
                        TempItemLedgEntry.INSERT();
                    UNTIL ItemLedgEntry.NEXT() = 0;

                IF TempItemLedgEntry.FIND('-') THEN BEGIN
                    REPEAT
                        //Begin#803/01:A20071/3.00  11.05.07 TECTURA.WW
                        // ORIG:
                        // IF MfgSetup."Lot Trading Unit Inheritance" THEN
                        //IF LSSetup."Lot Trading Unit Inheritance" THEN
                        //End#803/01:A20071/3.00  11.05.07 TECTURA.WW
                        //  TempItemLedgEntry.SETRANGE("Lot No.", TempItemLedgEntry."Lot No.")
                        //ELSE
                        //  TempItemLedgEntry.SETRANGE("Lot Number", TempItemLedgEntry."Lot Number");

                        TempItemLedgEntry.SETRANGE("Lot No.", TempItemLedgEntry."Lot No.");   //pade

                        poLotDetExpirDate := TempItemLedgEntry."Expiration Date";

                        REPEAT
                            //Begin#803/01:A20071/3.00  11.05.07 TECTURA.WW
                            // ORIG:
                            // IF MfgSetup."Lot Trading Unit Inheritance" THEN
                            //IF LSSetup."Lot Trading Unit Inheritance" THEN
                            //End#803/01:A20071/3.00  11.05.07 TECTURA.WW
                            //  poLotDetLotCode := TempItemLedgEntry."Lot No."
                            //ELSE
                            //  poLotDetLotCode := TempItemLedgEntry."Lot Number";
                            poLotDetLotCode := TempItemLedgEntry."Lot No.";                      //pade

                            IF (poLotDetExpirDate > TempItemLedgEntry."Expiration Date") AND
                               (TempItemLedgEntry."Expiration Date" <> 0D)
                            THEN
                                poLotDetExpirDate := TempItemLedgEntry."Expiration Date";
                            totalQty += TempItemLedgEntry.Quantity;
                        UNTIL TempItemLedgEntry.NEXT() = 0;

                        IF totalQty = 0 THEN
                            TempItemLedgEntry.DELETEALL();
                        TempItemLedgEntry.RESET();
                    UNTIL (NOT TempItemLedgEntry.FIND('-')) OR (totalQty <> 0);

                    IF totalQty = 0 THEN BEGIN
                        poLotDetLotCode := '';
                        poLotDetExpirDate := 0D;
                    END ELSE BEGIN
                        //Begin#803/01:A20071/3.00  11.05.07 TECTURA.WW
                        // ORIG:
                        // IF MfgSetup."Lot Trading Unit Inheritance" THEN
                        //IF LSSetup."Lot Trading Unit Inheritance" THEN
                        //End#803/01:A20071/3.00  11.05.07 TECTURA.WW
                        //  ItemLedgEntry.SETFILTER("Lot No.", '<>%1', poLotDetLotCode)
                        //ELSE
                        //  ItemLedgEntry.SETFILTER("Lot Number", '<>%1', poLotDetLotCode);

                        ItemLedgEntry.SETFILTER("Lot No.", '<>%1', poLotDetLotCode);             //pade

                        IF GetItemLedgerEntryQty(ItemLedgEntry) <> 0 THEN
                            ERROR(CstG003, ProdOrderComp."Item No.");
                    END;
                END;

                IF poLotDetLotCode = '' THEN BEGIN
                    ReservEntry.SETCURRENTKEY(
                      "Source Type",
                      "Source Subtype",
                      "Source ID",
                      "Source Batch Name",
                      "Source Prod. Order Line",
                      "Source Ref. No.");

                    ReservEntry.SETRANGE("Source Type", DATABASE::"Prod. Order Component");
                    ReservEntry.SETRANGE("Source Subtype", pioProdOrderLine.Status);
                    ReservEntry.SETRANGE("Source ID", pioProdOrderLine."Prod. Order No.");
                    ReservEntry.SETRANGE("Source Batch Name", '');
                    ReservEntry.SETRANGE("Source Prod. Order Line", pioProdOrderLine."Line No.");
                    ReservEntry.SETRANGE("Source Ref. No.", ProdOrderComp."Line No.");
                    ReservEntry.SETFILTER("Lot No.", '<>%1', '');

                    IF ReservEntry.FIND('-') THEN
                        //IF LotNoInfo.GET(
                        //  ProdOrderComp."Item No.",
                        //  ProdOrderComp."Variant Code",
                        //  ReservEntry."Lot Number",
                        //  //Begin#803/01:A20120/3.00  14.04.07 TECTURA.WW
                        //  // ORIG:
                        //  // ReservEntry."Trading Unit Number")
                        //  ReservEntry."Trading Unit Number",
                        //  ReservEntry."Serial No.")
                        //  //End#803/01:A20120/3.00  14.04.07 TECTURA.WW

                        //THEN BEGIN
                        //  poLotDetExpirDate := LotNoInfo."Expiration Date";
                        //END ELSE
                        //  poLotDetExpirDate := ReservEntry."Expiration Date";
                        //Begin#803/01:A20071/3.00  11.05.07 TECTURA.WW
                        // ORIG:
                        // IF MfgSetup."Lot Trading Unit Inheritance" THEN
                        //IF LSSetup."Lot Trading Unit Inheritance" THEN
                        //End#803/01:A20071/3.00  11.05.07 TECTURA.WW
                        //  poLotDetLotCode := ReservEntry."Lot No."
                        //ELSE
                        //  poLotDetLotCode := ReservEntry."Lot Number";

                        poLotDetLotCode := ReservEntry."Lot No.";                                  //pade
                END;


                //Begin#803/01:A20020/3.00  22.05.07 TECTURA.WW
                //IF NOT ProdOrderComp."Expiration Determining" THEN
                //  poLotDetExpirDate := 0D;
                //End#803/01:A20020/3.00  22.05.07 TECTURA.WW
            END;
        END;
    end;


    procedure CheckItemTrackingAssignment(piSourceType: Integer; piSourceSubtype: Integer; piSourceID: Code[20]; piSourceBatchName: Code[10]; piSourceProdOrderLine: Integer; piSourceRefNo: Integer; piLotNumber: Code[20]; piTradingUnitNumber: Code[20]; piLotTradingUnitNumber: Code[40]; piSerialNo: Code[20]; piShowError: Boolean): Boolean
    var
        Customer: Record Customer;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        ReqLine: Record "Requisition Line";
        PurchLine: Record "Purchase Line";
        ItemJnlLine: Record "Item Journal Line";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderComp: Record "Prod. Order Component";
        PlanningComp: Record "Planning Component";
        TransferLine: Record "Transfer Line";
        ServiceLine: Record "Service Line";
        TestItemJnlLine: Record "Item Journal Line";
        ItemTrackingCode: Record "Item Tracking Code";
        cuItemTrackingMgt: Codeunit "Item Tracking Management";
        SNRequired: Boolean;
        SNInfoRequired: Boolean;
        LotRequired: Boolean;
        LotInfoRequired: Boolean;
        PlannedDelivDate: Date;
        ShipmentDate: Date;
        CheckDates: Boolean;
        CheckStatus: Boolean;
        CustomerNo: Code[20];
        CountryCode: Code[10];
    begin
        // manque locales
        //InvPostPerm           Record     Inventory Posting Permission
        //LotSerialNoStatus     Record     Lot-/ Serial No. Status
        //InvOverView           Record     Inventory Overview


        //#803/01:A20010/3.00  23.04.07 TECTURA.WW
        IF (piLotNumber = '') AND (piSerialNo = '') THEN
            EXIT(TRUE);
        CLEAR(TestItemJnlLine);
        CASE piSourceType OF
            //Begin#803/01:A21104/3.10.01  30.09.08 TECTURA.TG avoid Error in Put Away Process: Source Type Zero
            0:
                BEGIN
                    TestItemJnlLine."Entry Type" := TestItemJnlLine."Entry Type"::"Positive Adjmt.";
                    TestItemJnlLine.Quantity := 0;
                    TestItemJnlLine."Invoiced Quantity" := 0;
                    TestItemJnlLine."Item No." := gExtItemNo;
                    TestItemJnlLine."Variant Code" := gExtVariantCode;
                    TestItemJnlLine."Location Code" := gExtLocationCode;
                    TestItemJnlLine."Serial No." := gExtSerialNo;
                    TestItemJnlLine."Bin Code" := gExtBincode;
                    TestItemJnlLine."Phys. Inventory" := FALSE;
                    TestItemJnlLine."Last Item Ledger Entry No." := 0;
                END;
            //End#803/01:A21104/3.10.01  30.09.08 TECTURA.TG avoid Error in Put Away Process: Source Type Zero
            DATABASE::"Sales Line":
                BEGIN
                    SalesLine.GET(piSourceSubtype, piSourceID, piSourceRefNo);
                    SalesLine.TESTFIELD(Type, SalesLine.Type::Item);
                    TestItemJnlLine."Entry Type" := TestItemJnlLine."Entry Type"::Sale;
                    IF SalesLine.SignedXX(SalesLine.Quantity) > 0 THEN BEGIN
                        TestItemJnlLine.Quantity := -SalesLine."Quantity (Base)";
                        TestItemJnlLine."Invoiced Quantity" := -SalesLine."Quantity (Base)";
                    END ELSE BEGIN
                        TestItemJnlLine.Quantity := SalesLine."Quantity (Base)";
                        TestItemJnlLine."Invoiced Quantity" := SalesLine."Quantity (Base)";
                    END;
                    TestItemJnlLine."Item No." := SalesLine."No.";
                    TestItemJnlLine."Variant Code" := SalesLine."Variant Code";
                    TestItemJnlLine."Location Code" := SalesLine."Location Code";
                    TestItemJnlLine."Bin Code" := SalesLine."Bin Code";
                    TestItemJnlLine."Phys. Inventory" := FALSE;
                    IF SalesLine.SignedXX(SalesLine.Quantity) < 0 THEN BEGIN
                        PlannedDelivDate := SalesLine."Planned Delivery Date";
                        ShipmentDate := SalesLine."Shipment Date";
                        CheckDates := TRUE;
                    END;
                    IF NOT Customer.GET(SalesLine."Sell-to Customer No.") THEN
                        CLEAR(Customer);
                    SalesHeader.GET(SalesLine."Document Type", SalesLine."Document No.");
                    CustomerNo := SalesLine."Sell-to Customer No.";
                    //CustomerGroupCode := Customer."Customer Group Code";
                    CountryCode := SalesHeader."Ship-to Country/Region Code";
                    CheckStatus := TRUE;
                END;
            DATABASE::"Requisition Line":
                BEGIN
                    ReqLine.GET(piSourceID, piSourceBatchName, piSourceRefNo);
                    ReqLine.TESTFIELD(Type, SalesLine.Type::Item);
                    CASE ReqLine."Ref. Order Type" OF
                        ReqLine."Ref. Order Type"::"Prod. Order":
                            BEGIN
                                TestItemJnlLine."Entry Type" := TestItemJnlLine."Entry Type"::Output;
                                TestItemJnlLine.Quantity := ReqLine."Quantity (Base)";
                                TestItemJnlLine."Invoiced Quantity" := ReqLine."Quantity (Base)";
                                TestItemJnlLine."Location Code" := ReqLine."Location Code";
                                TestItemJnlLine."Bin Code" := ReqLine."Bin Code";
                                TestItemJnlLine."Last Item Ledger Entry No." := 0;
                            END;
                        ReqLine."Ref. Order Type"::Transfer:
                            BEGIN
                                TestItemJnlLine."Entry Type" := TestItemJnlLine."Entry Type"::Transfer;
                                TestItemJnlLine.Quantity := ReqLine."Quantity (Base)";
                                TestItemJnlLine."Invoiced Quantity" := ReqLine."Quantity (Base)";
                                TestItemJnlLine."Location Code" := ReqLine."Transfer-from Code";
                                TestItemJnlLine."Bin Code" := '';
                                TestItemJnlLine."New Location Code" := ReqLine."Location Code";
                                TestItemJnlLine."New Bin Code" := ReqLine."Bin Code";
                                TestItemJnlLine."Last Item Ledger Entry No." := 0;
                            END;
                        ELSE BEGIN
                                TestItemJnlLine."Entry Type" := TestItemJnlLine."Entry Type"::Purchase;
                                TestItemJnlLine.Quantity := ReqLine."Quantity (Base)";
                                TestItemJnlLine."Invoiced Quantity" := ReqLine."Quantity (Base)";
                                TestItemJnlLine."Location Code" := ReqLine."Location Code";
                                TestItemJnlLine."Bin Code" := ReqLine."Bin Code";
                                TestItemJnlLine."Last Item Ledger Entry No." := 0;
                            END;
                    END;
                    TransferLine."Item No." := ReqLine."No.";
                    TransferLine."Variant Code" := ReqLine."Variant Code";
                END;
            DATABASE::"Purchase Line":
                BEGIN
                    PurchLine.GET(piSourceSubtype, piSourceID, piSourceRefNo);
                    PurchLine.TESTFIELD(Type, PurchLine.Type::Item);
                    TestItemJnlLine."Entry Type" := TestItemJnlLine."Entry Type"::Purchase;
                    IF PurchLine.Signed(PurchLine.Quantity) > 0 THEN BEGIN
                        TestItemJnlLine.Quantity := PurchLine."Quantity (Base)";
                        TestItemJnlLine."Invoiced Quantity" := PurchLine."Quantity (Base)";
                    END ELSE BEGIN
                        TestItemJnlLine.Quantity := -PurchLine."Quantity (Base)";
                        TestItemJnlLine."Invoiced Quantity" := -PurchLine."Quantity (Base)";
                    END;
                    TestItemJnlLine."Item No." := PurchLine."No.";
                    TestItemJnlLine."Variant Code" := PurchLine."Variant Code";
                    TestItemJnlLine."Location Code" := PurchLine."Location Code";
                    TestItemJnlLine."Bin Code" := PurchLine."Bin Code";
                    TestItemJnlLine."Phys. Inventory" := FALSE;
                    TestItemJnlLine."Last Item Ledger Entry No." := 0;
                END;
            DATABASE::"Item Journal Line":
                BEGIN
                    ItemJnlLine.GET(piSourceID, piSourceBatchName, piSourceRefNo);
                    TestItemJnlLine."Entry Type" := ItemJnlLine."Entry Type";
                    TestItemJnlLine.Quantity := ItemJnlLine."Quantity (Base)";
                    TestItemJnlLine."Invoiced Quantity" := ItemJnlLine."Quantity (Base)";
                    TestItemJnlLine."Item No." := ItemJnlLine."Item No.";
                    TestItemJnlLine."Variant Code" := ItemJnlLine."Variant Code";
                    TestItemJnlLine."Location Code" := ItemJnlLine."Location Code";
                    TestItemJnlLine."Bin Code" := ItemJnlLine."Bin Code";
                    TestItemJnlLine."New Location Code" := ItemJnlLine."New Location Code";
                    TestItemJnlLine."New Bin Code" := ItemJnlLine."New Bin Code";
                    TestItemJnlLine."Phys. Inventory" := TestItemJnlLine."Phys. Inventory";
                    TestItemJnlLine."Last Item Ledger Entry No." := 0;
                END;
            DATABASE::"Prod. Order Line":
                BEGIN
                    ProdOrderLine.GET(piSourceSubtype, piSourceID, piSourceProdOrderLine);
                    TestItemJnlLine."Entry Type" := TestItemJnlLine."Entry Type"::Output;
                    TestItemJnlLine.Quantity := ProdOrderLine."Quantity (Base)";
                    TestItemJnlLine."Invoiced Quantity" := ProdOrderLine."Quantity (Base)";
                    TestItemJnlLine."Item No." := ProdOrderLine."Item No.";
                    TestItemJnlLine."Variant Code" := ProdOrderLine."Variant Code";
                    TestItemJnlLine."Location Code" := ProdOrderLine."Location Code";
                    TestItemJnlLine."Bin Code" := ProdOrderLine."Bin Code";
                    TestItemJnlLine."Phys. Inventory" := FALSE;
                    TestItemJnlLine."Last Item Ledger Entry No." := 0;
                END;
            DATABASE::"Prod. Order Component":
                BEGIN
                    ProdOrderComp.GET(piSourceSubtype, piSourceID, piSourceProdOrderLine, piSourceRefNo);
                    TestItemJnlLine."Entry Type" := TestItemJnlLine."Entry Type"::Consumption;
                    TestItemJnlLine.Quantity := ProdOrderComp."Expected Qty. (Base)";
                    TestItemJnlLine."Invoiced Quantity" := ProdOrderComp."Expected Qty. (Base)";
                    TestItemJnlLine."Item No." := ProdOrderComp."Item No.";
                    TestItemJnlLine."Variant Code" := ProdOrderComp."Variant Code";
                    TestItemJnlLine."Location Code" := ProdOrderComp."Location Code";
                    TestItemJnlLine."Bin Code" := ProdOrderComp."Bin Code";
                    TestItemJnlLine."Phys. Inventory" := FALSE;
                    TestItemJnlLine."Last Item Ledger Entry No." := 0;
                    IF ProdOrderComp."Expected Quantity" > 0 THEN BEGIN
                        PlannedDelivDate := ProdOrderComp."Due Date";
                        ShipmentDate := ProdOrderComp."Due Date";
                        CheckDates := TRUE;
                    END;
                END;
            /*
                DATABASE::"Inventory Overview":
                BEGIN
                  InvOverView.GET(piSourceRefNo);
                  TestItemJnlLine."Entry Type" := TestItemJnlLine."Entry Type"::Consumption;
                  TestItemJnlLine.Quantity := 0;
                  TestItemJnlLine."Invoiced Quantity" := 0;
                  TestItemJnlLine."Item No." := InvOverView."Item No.";
                  TestItemJnlLine."Variant Code" := InvOverView."Variant Code";
                  TestItemJnlLine."Location Code" := InvOverView."Location Code";
                  TestItemJnlLine."Bin Code" := InvOverView."Bin Code";
                  TestItemJnlLine."Phys. Inventory" := FALSE;
                  TestItemJnlLine."Last Item Ledger Entry No." := 0;
                END;
            */
            DATABASE::"Planning Component":
                BEGIN
                    PlanningComp.GET(piSourceID, piSourceBatchName, piSourceProdOrderLine, piSourceRefNo);
                    TestItemJnlLine."Entry Type" := TestItemJnlLine."Entry Type"::Consumption;
                    TestItemJnlLine.Quantity := PlanningComp."Expected Quantity (Base)";
                    TestItemJnlLine."Invoiced Quantity" := PlanningComp."Expected Quantity (Base)";
                    TestItemJnlLine."Item No." := PlanningComp."Item No.";
                    TestItemJnlLine."Variant Code" := PlanningComp."Variant Code";
                    TestItemJnlLine."Location Code" := PlanningComp."Location Code";
                    TestItemJnlLine."Bin Code" := PlanningComp."Bin Code";
                    TestItemJnlLine."Phys. Inventory" := FALSE;
                    TestItemJnlLine."Last Item Ledger Entry No." := 0;
                    IF PlanningComp."Expected Quantity" > 0 THEN BEGIN
                        PlannedDelivDate := PlanningComp."Due Date";
                        ShipmentDate := PlanningComp."Due Date";
                        CheckDates := TRUE;
                    END;
                END;
            DATABASE::"Transfer Line":
                BEGIN
                    TransferLine.GET(piSourceID, piSourceRefNo);
                    TestItemJnlLine."Entry Type" := TestItemJnlLine."Entry Type"::Transfer;
                    TestItemJnlLine.Quantity := TransferLine."Quantity (Base)";
                    TestItemJnlLine."Invoiced Quantity" := TransferLine."Quantity (Base)";
                    TestItemJnlLine."Location Code" := TransferLine."Transfer-from Code";
                    TestItemJnlLine."Bin Code" := TransferLine."Transfer-from Bin Code";
                    TestItemJnlLine."New Location Code" := TransferLine."Transfer-to Code";
                    TestItemJnlLine."New Bin Code" := TransferLine."Transfer-To Bin Code";
                    TestItemJnlLine."Last Item Ledger Entry No." := 0;
                    TestItemJnlLine."Item No." := TransferLine."Item No.";
                    TestItemJnlLine."Variant Code" := TransferLine."Variant Code";
                    IF TransferLine.Quantity > 0 THEN BEGIN
                        PlannedDelivDate := TransferLine."Shipment Date";
                        ShipmentDate := TransferLine."Shipment Date";
                        CheckDates := TRUE;
                    END;
                    CheckStatus := FALSE;
                END;
            DATABASE::"Service Line":
                BEGIN
                    ServiceLine.GET(piSourceSubtype, piSourceID, piSourceRefNo);
                    ServiceLine.TESTFIELD(Type, ServiceLine.Type::Item);
                    TestItemJnlLine."Entry Type" := TestItemJnlLine."Entry Type"::Sale;
                    IF ServiceLine.SignedXX(ServiceLine.Quantity) > 0 THEN BEGIN
                        TestItemJnlLine.Quantity := ServiceLine."Quantity (Base)";
                        TestItemJnlLine."Invoiced Quantity" := ServiceLine."Quantity (Base)";
                    END ELSE BEGIN
                        TestItemJnlLine.Quantity := -ServiceLine."Quantity (Base)";
                        TestItemJnlLine."Invoiced Quantity" := -ServiceLine."Quantity (Base)";
                    END;
                    TestItemJnlLine."Item No." := ServiceLine."No.";
                    TestItemJnlLine."Variant Code" := ServiceLine."Variant Code";
                    TestItemJnlLine."Location Code" := ServiceLine."Location Code";
                    TestItemJnlLine."Bin Code" := ServiceLine."Bin Code";
                    TestItemJnlLine."Phys. Inventory" := FALSE;
                    TestItemJnlLine."Last Item Ledger Entry No." := 0;
                    IF ServiceLine.Quantity > 0 THEN BEGIN
                        PlannedDelivDate := ServiceLine."Posting Date";
                        ShipmentDate := ServiceLine."Posting Date";
                        CheckDates := TRUE;
                    END;
                END;
            ELSE
                ERROR(gctxErr0006, piSourceType);
        END;

        //TestItemJnlLine."Lot Block/Release Posting" := FALSE;
        TestItemJnlLine."Serial No." := piSerialNo;
        TestItemJnlLine."Lot No." := piLotTradingUnitNumber;
        //TestItemJnlLine."Lot Number" := piLotNumber;
        //TestItemJnlLine."Trading Unit Number" := piTradingUnitNumber;

        /*
        IF LotSerialNoInfo.GET(
          TestItemJnlLine."Item No.",
          TestItemJnlLine."Variant Code",
        //  TestItemJnlLine."Lot Number",
          '',
        //  TestItemJnlLine."Trading Unit Number",
          '',
          TestItemJnlLine."Serial No.")
        THEN BEGIN
        
          IF CheckStatus THEN BEGIN
            IF NOT LotSerialNoStatus.GET(LotSerialNoInfo.Status) THEN
              IF piShowError THEN
                ERROR(gctxErr0012, GetLotSerialNoText(LotSerialNoInfo, TRUE, TRUE))
              ELSE
                EXIT(FALSE);
        
            IF NOT IsStatusOk(LotSerialNoStatus, CustomerNo, CustomerGroupCode, CountryCode, FALSE, FALSE, FALSE) THEN
              IF piShowError THEN
                ERROR(gctxErr0013, GetLotSerialNoText(LotSerialNoInfo, TRUE, TRUE), LotSerialNoInfo.Status)
              ELSE
                EXIT(FALSE);
          END;
        
          IF CheckDates THEN
            IF ShipmentDate <= LotSerialNoInfo."Quarantine Date" THEN
              IF NOT piShowError THEN
                EXIT(FALSE)
              ELSE
                ERROR(gctxErr0011, GetLotSerialNoText(LotSerialNoInfo, TRUE, TRUE), LotSerialNoInfo."Quarantine Date");
        END;
        */

        cuItemTrackingMgt.GetItemTrackingSettings(
          ItemTrackingCode,
          TestItemJnlLine."Entry Type",
          //Begin#803/01:A20432/3.00.01  17.07.07 TECTURA.WW
          // ORIG:
          // TestItemJnlLine.Signed(ItemJnlLine."Quantity (Base)") > 0,
          TestItemJnlLine.Signed(TestItemJnlLine."Quantity (Base)") > 0,
          //End#803/01:A20432/3.00.01  17.07.07 TECTURA.WW
          SNRequired,
          LotRequired,
          SNInfoRequired,
          LotInfoRequired);

        /*
        IF InvPostPerm.CheckPosting(
          TestItemJnlLine,
          TestItemJnlLine."Lot Number",
          TestItemJnlLine."Trading Unit Number",
          TestItemJnlLine."Serial No.",
          LotInfoRequired,
          SNInfoRequired,
          1,
          piShowError)
        THEN
          EXIT(FALSE)
        ELSE
          EXIT(TRUE);
        
        */

    end;


    procedure SetExtParameter(piExtItemNo: Code[20]; piExtVariantCode: Code[10]; piExtSerialNo: Code[20]; piExtLocationCode: Code[10]; piExtBincode: Code[20])
    begin
        //#803/01:A21104/3.10.01  30.09.08 TECTURA.TG avoid Error in Put Away Process: Source Type Zero
        gExtItemNo := piExtItemNo;
        gExtVariantCode := piExtVariantCode;
        gExtLocationCode := piExtLocationCode;
        gExtBincode := piExtBincode;
        gExtSerialNo := piExtSerialNo;
    end;


    procedure GetCompIsFromTheSameLot(var pioItemJnlLine: Record "Item Journal Line"): Boolean
    var
        ProdOrderComp: Record "Prod. Order Component";
    begin
        WITH pioItemJnlLine DO BEGIN
            IF pioItemJnlLine."Prod. Order No." = '' THEN
                EXIT(FALSE);
            IF "Prod. Order Line No." = 0 THEN
                EXIT(FALSE);
            IF "Prod. Order Comp. Line No." = 0 THEN
                EXIT(FALSE);
            IF NOT
              ProdOrderComp.GET(
                ProdOrderComp.Status::Released,
                "Prod. Order No.",
                "Prod. Order Line No.",
                "Prod. Order Comp. Line No.")
            THEN
                EXIT(FALSE);

            EXIT(ProdOrderComp."From the same Lot");
        END;
    end;


    procedure AutoCreatePOLTracking(var pioProdOrderLine: Record "Prod. Order Line")
    var
        TrackingSpecification: Record "Tracking Specification";
        LotDetLotCode: Code[30];
        LotDetExpirDate: Date;
        cuReserveProdOrderLine: Codeunit "Prod. Order Line-Reserve";
        Item: Record Item;
        TempTrackingSpecification: Record "Tracking Specification" temporary;
        cuTradingUnitMgt: Codeunit "Trading Unit Mgt.PW";
    begin
        WITH pioProdOrderLine DO BEGIN
            Item.GET("Item No.");
            //IF Item."Handled in Trading Units" THEN BEGIN
            //  MESSAGE(gctxMsg0001);
            //  EXIT;
            //END;
            IF (Status <> Status::"Firm Planned") AND (Status <> Status::Released) THEN
                EXIT;

            GetLotDeterminingDataPOL(pioProdOrderLine, LotDetLotCode, LotDetExpirDate);

            cuReserveProdOrderLine.InitTrackingSpecification(pioProdOrderLine, TrackingSpecification);
            frmItemTrackingForm.SetSource(TrackingSpecification, "Due Date");
            frmItemTrackingForm.GetTempTrkgSpec(TempTrackingSpecification);
            IF TempTrackingSpecification.FIND('-') THEN
                REPEAT
                    IF TempTrackingSpecification."Quantity Handled (Base)" <> 0 THEN BEGIN
                        MESSAGE(gctxMsg0002);
                        EXIT;
                    END;
                UNTIL TempTrackingSpecification.NEXT() = 0;
            TempTrackingSpecification.DELETEALL();
            TempTrackingSpecification := TrackingSpecification;
            //Begin#803/01:A10017-7/2.20  22.06.06 TECTURA.WW
            TempTrackingSpecification."Lot Number" := cuTradingUnitMgt.GetLotNo(LotDetLotCode);
            //End#803/01:A10017-7/2.20  22.06.06 TECTURA.WW
            TempTrackingSpecification."Trading Unit Number" := '';
            TempTrackingSpecification."Expiration Date" := LotDetExpirDate;
            TempTrackingSpecification."Lot No." :=
              cuTradingUnitMgt.GetLotTradingUnitNo(
                TempTrackingSpecification."Lot Number",
                TempTrackingSpecification."Trading Unit Number");
            TempTrackingSpecification."Quantity (Base)" := pioProdOrderLine."Remaining Qty. (Base)";
            TempTrackingSpecification."Qty. to Handle (Base)" := pioProdOrderLine."Remaining Qty. (Base)";
            TempTrackingSpecification."Qty. to Invoice (Base)" := pioProdOrderLine."Remaining Qty. (Base)";
            //Begin#803/01:A20220/3.00  22.05.07 TECTURA.WW
            //IF TempTrackingSpecification."Expiration Date" = 0D THEN
            //cuLSStdInt.T336_InitDateValues(TempTrackingSpecification);
            //End#803/01:A20220/3.00  22.05.07 TECTURA.WW
            TempTrackingSpecification.INSERT();
            CLEAR(frmItemTrackingForm);
            frmItemTrackingForm.SetBlockCommit(TRUE);
            frmItemTrackingForm.RegisterItemTrackingLines2(TrackingSpecification, "Due Date", TempTrackingSpecification, TRUE);
        END;
    end;


    procedure CheckItemDetermined(RecPItem: Record Item): Boolean
    var
        NeededHits: Integer;
        RecLProdBOM: Record "Production BOM Header";
        RecLProdBOMLine: Record "Production BOM Line";
    begin
        IF RecLProdBOM.GET(RecPItem."Production BOM No.") THEN BEGIN
            NeededHits := 0;
            RecLProdBOMLine.SETRANGE(RecLProdBOMLine."Production BOM No.", RecLProdBOM."No.");
            IF RecLProdBOMLine.FINDFIRST() THEN
                REPEAT
                    /*
                    IF gcuLotInheritanceMgt.CheckBOMDetermining(RecLProdBOMLine, NeededHits) THEN
                    BEGIN
                      MESSAGE(
                        CstG005, LotDeterminingBOMLine."No.", LotDeterminingBOMLine."Production BOM No.",
                        LotDeterminingBOMLine."Version Code");
                    */
                    IF RecLProdBOMLine."Lot Determining" THEN
                        EXIT(TRUE);
                UNTIL RecLProdBOMLine.NEXT() = 0;
        END;
        EXIT(FALSE);

    end;


    procedure AutoCreatePlanLineTracking(var pioReqLine: Record "Requisition Line")
    var
        TrackingSpecification: Record "Tracking Specification";
        LotDetLotCode: Code[30];
        LotDetExpirDate: Date;
        cuReserveReqLine: Codeunit "Req. Line-Reserve";
        Item: Record Item;
        TempTrackingSpecification: Record "Tracking Specification" temporary;
        cuTradingUnitMgt: Codeunit "Trading Unit Mgt.PW";
    begin
        WITH pioReqLine DO BEGIN
            IF (Type <> Type::Item) OR ("No." = '') THEN
                EXIT;

            Item.GET("No.");
            //IF Item."Handled in Trading Units" THEN BEGIN
            //  MESSAGE(gctxMsg0001);
            //  EXIT;
            //END;

            GetLotDeterminingDataPlanLine(pioReqLine, LotDetLotCode, LotDetExpirDate);

            cuReserveReqLine.InitTrackingSpecification(pioReqLine, TrackingSpecification);
            frmItemTrackingForm.SetSource(TrackingSpecification, "Due Date");
            frmItemTrackingForm.GetTempTrkgSpec(TempTrackingSpecification);
            IF TempTrackingSpecification.FIND('-') THEN
                REPEAT
                    IF TempTrackingSpecification."Quantity Handled (Base)" <> 0 THEN BEGIN
                        MESSAGE(gctxMsg0002);
                        EXIT;
                    END;
                UNTIL TempTrackingSpecification.NEXT() = 0;
            TempTrackingSpecification.DELETEALL();
            TempTrackingSpecification := TrackingSpecification;
            //Begin#803/01:A10017-7/2.20  22.06.06 TECTURA.WW
            TempTrackingSpecification."Lot Number" := cuTradingUnitMgt.GetLotNo(LotDetLotCode);
            //End#803/01:A10017-7/2.20  22.06.06 TECTURA.WW
            TempTrackingSpecification."Trading Unit Number" := '';
            TempTrackingSpecification."Expiration Date" := LotDetExpirDate;
            TempTrackingSpecification."Lot No." :=
              cuTradingUnitMgt.GetLotTradingUnitNo(
                TempTrackingSpecification."Lot Number",
                TempTrackingSpecification."Trading Unit Number");
            TempTrackingSpecification."Quantity (Base)" := pioReqLine."Remaining Qty. (Base)";
            TempTrackingSpecification."Qty. to Handle (Base)" := pioReqLine."Remaining Qty. (Base)";
            TempTrackingSpecification."Qty. to Invoice (Base)" := pioReqLine."Remaining Qty. (Base)";
            TempTrackingSpecification.INSERT();
            CLEAR(frmItemTrackingForm);
            frmItemTrackingForm.SetBlockCommit(TRUE);
            frmItemTrackingForm.RegisterItemTrackingLines2(TrackingSpecification, "Due Date", TempTrackingSpecification, TRUE);
        END;
    end;


    procedure GetLotDeterminingDataPlanLine(var pioReqLine: Record "Requisition Line"; var poLotDetLotCode: Code[30]; var poLotDetExpirDate: Date)
    var
        PlanningComponent: Record "Planning Component";
        ReservEntry: Record "Reservation Entry";
        LotNoInfo: Record "Lot No. Information";
    begin
        poLotDetLotCode := '';
        poLotDetExpirDate := 0D;

        WITH pioReqLine DO BEGIN
            PlanningComponent.SETRANGE("Worksheet Template Name", "Worksheet Template Name");
            PlanningComponent.SETRANGE("Worksheet Batch Name", "Journal Batch Name");
            PlanningComponent.SETRANGE("Worksheet Line No.", "Line No.");
            PlanningComponent.SETRANGE("Lot Determining", TRUE);
            IF PlanningComponent.FIND('=><') THEN BEGIN
                ReservEntry.SETCURRENTKEY(
                  "Source Type",
                  "Source Subtype",
                  "Source ID",
                  "Source Batch Name",
                  "Source Prod. Order Line",
                  "Source Ref. No.");

                ReservEntry.SETRANGE("Source Type", DATABASE::"Planning Component");
                ReservEntry.SETRANGE("Source Subtype", 0);
                ReservEntry.SETRANGE("Source ID", PlanningComponent."Worksheet Template Name");
                ReservEntry.SETRANGE("Source Batch Name", PlanningComponent."Worksheet Batch Name");
                ReservEntry.SETRANGE("Source Prod. Order Line", PlanningComponent."Worksheet Line No.");
                ReservEntry.SETRANGE("Source Ref. No.", PlanningComponent."Line No.");
                ReservEntry.SETFILTER("Lot No.", '<>%1', '');
                IF ReservEntry.FIND('-') THEN BEGIN
                    IF LotNoInfo.GET(
                      PlanningComponent."Item No.",
                      PlanningComponent."Variant Code",
                      '',
                      //Begin#803/01:A20120/3.00  14.04.07 TECTURA.WW
                      // ORIG:
                      // ReservEntry."Trading Unit Number")
                      '',
                      ReservEntry."Serial No.")
                    //End#803/01:A20120/3.00  14.04.07 TECTURA.WW
                    THEN
                        //  poLotDetExpirDate := LotNoInfo."Expiration Date";
                        //END ELSE
                        poLotDetExpirDate := ReservEntry."Expiration Date";
                    //Begin#803/01:A20071/3.00  11.05.07 TECTURA.WW
                    // ORIG:
                    // MfgSetup.GET;
                    // IF MfgSetup."Lot Trading Unit Inheritance" THEN
                    //LSSetup.GET;
                    //IF LSSetup."Lot Trading Unit Inheritance" THEN
                    //End#803/01:A20071/3.00  11.05.07 TECTURA.WW
                    poLotDetLotCode := ReservEntry."Lot No."
                    //ELSE
                    // poLotDetLotCode := ReservEntry."Lot Number";
                END;
                //Begin#803/01:A20020/3.00  22.05.07 TECTURA.WW
                // IF NOT PlanningComponent."Expiration Determining" THEN
                poLotDetExpirDate := 0D;
                //End#803/01:A20020/3.00  22.05.07 TECTURA.WW
            END;
        END;
    end;


    procedure AutoCreatePOLTrackingPWD(var pioProdOrderLine: Record "Prod. Order Line"; DecPQty: Decimal)
    var
        TrackingSpecification: Record "Tracking Specification";
        LotDetLotCode: Code[30];
        LotDetExpirDate: Date;
        cuReserveProdOrderLine: Codeunit "Prod. Order Line-Reserve";
        Item: Record Item;
        TempTrackingSpecification: Record "Tracking Specification" temporary;
        cuTradingUnitMgt: Codeunit "Trading Unit Mgt.PW";
    begin
        WITH pioProdOrderLine DO BEGIN
            Item.GET("Item No.");
            //IF Item."Handled in Trading Units" THEN BEGIN
            //  MESSAGE(gctxMsg0001);
            //  EXIT;
            //END;
            IF (Status <> Status::"Firm Planned") AND (Status <> Status::Released) THEN
                EXIT;

            GetLotDeterminingDataPOL(pioProdOrderLine, LotDetLotCode, LotDetExpirDate);

            cuReserveProdOrderLine.InitTrackingSpecification(pioProdOrderLine, TrackingSpecification);
            frmItemTrackingForm.SetSource(TrackingSpecification, "Due Date");
            frmItemTrackingForm.GetTempTrkgSpec(TempTrackingSpecification);
            IF TempTrackingSpecification.FIND('-') THEN
                REPEAT
                    IF TempTrackingSpecification."Quantity Handled (Base)" <> 0 THEN BEGIN
                        MESSAGE(gctxMsg0002);
                        EXIT;
                    END;
                UNTIL TempTrackingSpecification.NEXT() = 0;
            TempTrackingSpecification.DELETEALL();
            TempTrackingSpecification := TrackingSpecification;
            //Begin#803/01:A10017-7/2.20  22.06.06 TECTURA.WW
            TempTrackingSpecification."Lot Number" := cuTradingUnitMgt.GetLotNo(LotDetLotCode);
            //End#803/01:A10017-7/2.20  22.06.06 TECTURA.WW
            TempTrackingSpecification."Trading Unit Number" := '';
            TempTrackingSpecification."Expiration Date" := LotDetExpirDate;
            TempTrackingSpecification."Lot No." :=
              cuTradingUnitMgt.GetLotTradingUnitNo(
                TempTrackingSpecification."Lot Number",
                TempTrackingSpecification."Trading Unit Number");
            TempTrackingSpecification."Quantity (Base)" := DecPQty;
            TempTrackingSpecification."Qty. to Handle (Base)" := DecPQty;
            TempTrackingSpecification."Qty. to Invoice (Base)" := DecPQty;
            //Begin#803/01:A20220/3.00  22.05.07 TECTURA.WW
            //IF TempTrackingSpecification."Expiration Date" = 0D THEN
            //cuLSStdInt.T336_InitDateValues(TempTrackingSpecification);
            //End#803/01:A20220/3.00  22.05.07 TECTURA.WW
            TempTrackingSpecification.INSERT();
            CLEAR(frmItemTrackingForm);
            frmItemTrackingForm.SetBlockCommit(TRUE);
            frmItemTrackingForm.RegisterItemTrackingLines2(TrackingSpecification, "Due Date", TempTrackingSpecification, TRUE);
        END;
    end;
}

