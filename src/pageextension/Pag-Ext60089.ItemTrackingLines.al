<<<<<<<< HEAD:src/pageextension/Pag-Ext50084.ItemTrackingLines.al
pageextension 50084 "PWD ItemTrackingLines" extends "Item Tracking Lines"
========
pageextension 60089 "PWD ItemTrackingLines" extends "Item Tracking Lines"
>>>>>>>> 0e9c74a532778d823a8ce26e8cfe38db025f63e2:src/pageextension/Pag-Ext60089.ItemTrackingLines.al
{
    // #1..3
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // FE_LAPIERRETTE_PROD01.001: TO 13/12/2011:  No Commande vente identique OF-LOT
    //                       Add functions RegisterItemTrackingLines2,NoNewSerialLotNumbers, SetgLotDeterminingData
    // 
    // 
    // FE_PROD01.001:GR 14/02/2012:  Order No, OF and LOT
    //                               - modify a lot
    // 
    // //>>LAP2.05
    // FE_LAPIERRETTE_PRO12.001: GR 15/10/2012: Non Conformite
    //                                          - Add Field
    //                                            NC
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    layout
    {
        addafter("Lot No.")
        {
<<<<<<<< HEAD:src/pageextension/Pag-Ext50084.ItemTrackingLines.al
            field("PWD NC"; NC)
========
            field("PWD NC"; "PWD NC")
>>>>>>>> 0e9c74a532778d823a8ce26e8cfe38db025f63e2:src/pageextension/Pag-Ext60089.ItemTrackingLines.al
            {
                ApplicationArea = All;
            }
        }
    }

    var
        gNoSerialLotNo: Boolean;
        gLotDeterminingLotCode: Code[30];
        gLotDeterminingExpirDate: Date;
        gNoAssignLotDetLotNo: Boolean;
        gCurrSourceSpecification: Record "Tracking Specification";
        gCurrSourceSpecDueDate: Date;
        gCurrSourceSpecificationSet: Boolean;
        gFromTheSameLot: Boolean;
        CstGErr0001: Label 'You only can assign one Lot!';
        CstGErr0002: Label 'Lot Inheritance: You can''t assign a Lot No.,\because there is no Lot assigned to the lot determining component.';




    procedure RegisterItemTrackingLines2(piTrackingSpecification: Record "Tracking Specification"; piAvailabilityDate: Date; var pioTempTrackingSpecification: Record "Tracking Specification" temporary; piReplace: Boolean)
    var
        Text014: label 'The total item tracking quantity %1 exceeds the %2 quantity %3.\The changes cannot be saved to the database.';
        IsCorrection: Boolean;
        TotalItemTrackingLine: Record "Tracking Specification";
        TempReservEntry: Record "Reservation Entry" temporary;
        FormRunMode: option " ",Reclass,"Combined Ship/Rcpt","Drop Shipment",Transfer;
    begin
        piTrackingSpecification.TESTFIELD("Source Type"); // Check if source has been set.
                                                          //IF NOT CalledFromSynchWhseItemTrkg THEN
        pioTempTrackingSpecification.RESET;
        IsCorrection := piTrackingSpecification.Correction;
        SetSourceSpec(piTrackingSpecification, piAvailabilityDate);
        RESET;
        SETCURRENTKEY("Lot No.", "Serial No.");

        //Begin#803/01:A9069/2.10.01  25.02.05 TECTURA.WW
        IF pioTempTrackingSpecification.FIND('-') THEN
            //End#803/01:A9069/2.10.01  25.02.05 TECTURA.WW
            REPEAT
                SETRANGE("Lot No.", pioTempTrackingSpecification."Lot No.");
                SETRANGE("Serial No.", pioTempTrackingSpecification."Serial No.");
                IF FIND('-') THEN BEGIN
                    IF piReplace THEN BEGIN
                        "Quantity (Base)" := pioTempTrackingSpecification."Quantity (Base)";
                        "Qty. to Handle (Base)" := pioTempTrackingSpecification."Qty. to Handle (Base)";
                        "Qty. to Invoice (Base)" := pioTempTrackingSpecification."Qty. to Invoice (Base)";
                    END ELSE
                        IF IsCorrection THEN BEGIN
                            "Quantity (Base)" :=
                              "Quantity (Base)" + pioTempTrackingSpecification."Quantity (Base)";
                            "Qty. to Handle (Base)" :=
                            "Qty. to Handle (Base)" + pioTempTrackingSpecification."Qty. to Handle (Base)";
                            "Qty. to Invoice (Base)" :=
                              "Qty. to Invoice (Base)" + pioTempTrackingSpecification."Qty. to Invoice (Base)";
                        END ELSE
                            VALIDATE("Quantity (Base)",
                              "Quantity (Base)" + pioTempTrackingSpecification."Quantity (Base)");

                    //Begin#803/01:A1006/1.50
                    "New Serial No." := pioTempTrackingSpecification."New Serial No.";
                    "New Lot No." := pioTempTrackingSpecification."New Lot No.";
                    //End#803/01:A1006/1.50
                    //Begin#803/01:A3013-1/2.10  01.09.04 ASTON.WW
                    //gcuTradingUnitMgt.SplitLotTradingUnitNo(                       // pade
                    //  "New Lot No.",
                    //  "New Lot Number",
                    //  "New Trading Unit Number");
                    //End#803/01:A3013-1/2.10  01.09.04 ASTON.WW

                    //Begin#803/01:A10118/2.20.01  07.08.06 TECTURA.WW
                    IF piReplace THEN BEGIN
                        "Warranty Date" := pioTempTrackingSpecification."Warranty Date";
                        "Expiration Date" := pioTempTrackingSpecification."Expiration Date";
                        //"External Lot No." := pioTempTrackingSpecification."External Lot No.";
                        //"Quarantine Date" := pioTempTrackingSpecification."Quarantine Date";
                        //"Retest Date" := pioTempTrackingSpecification."Retest Date";
                        //Status := pioTempTrackingSpecification.Status;
                        //Begin#803/01:A20005/3.00  12.04.07 TECTURA.WW
                        // ORIG:
                        // Substatus := pioTempTrackingSpecification.Substatus;
                        //End#803/01:A20005/3.00  12.04.07 TECTURA.WW

                        //Begin#803/01:A20005/3.00  17.04.07 TECTURA.WW
                        "New Expiration Date" := pioTempTrackingSpecification."New Expiration Date";
                        //End#803/01:A20005/3.00  17.04.07 TECTURA.WW
                        //"Entry Date" := pioTempTrackingSpecification."Entry Date";
                    END;
                    //End#803/01:A10118/2.20.01  07.08.06 TECTURA.WW

                    // >> #803/01:A30010/6.00 09.02.09 TECTURA.AM
                    //Begin#800/01:A1000/1.50
                    //"No. of Units" := pioTempTrackingSpecification."No. of Units";
                    //End#800/01:A1000/1.50
                    // << #803/01:A30010/6.00 09.02.09 TECTURA.AM

                    MODIFY;
                END ELSE BEGIN
                    TRANSFERFIELDS(piTrackingSpecification);
                    "Serial No." := pioTempTrackingSpecification."Serial No.";
                    "Lot No." := pioTempTrackingSpecification."Lot No.";
                    //Begin#803/01:A3013-1/2.10  01.09.04 ASTON.WW
                    //gcuTradingUnitMgt.SplitLotTradingUnitNo(
                    //  "Lot No.",
                    //  "Lot Number",
                    //  "Trading Unit Number");
                    //End#803/01:A3013-1/2.10  01.09.04 ASTON.WW
                    "Warranty Date" := pioTempTrackingSpecification."Warranty Date";
                    "Expiration Date" := pioTempTrackingSpecification."Expiration Date";
                    VALIDATE("Quantity (Base)", pioTempTrackingSpecification."Quantity (Base)");
                    //Begin#803/01:A1006/1.50
                    "New Serial No." := pioTempTrackingSpecification."New Serial No.";
                    "New Lot No." := pioTempTrackingSpecification."New Lot No.";
                    //End#803/01:A1006/1.50

                    //Begin#803/01:A3013-1/2.10  01.09.04 ASTON.WW
                    //gcuTradingUnitMgt.SplitLotTradingUnitNo(
                    //  "New Lot No.",
                    //  "New Lot Number",
                    //  "New Trading Unit Number");
                    //End#803/01:A3013-1/2.10  01.09.04 ASTON.WW

                    //Begin#803/01:A1006/1.50
                    //"External Lot No." := pioTempTrackingSpecification."External Lot No.";
                    //"Quarantine Date" := pioTempTrackingSpecification."Quarantine Date";
                    //"Retest Date" := pioTempTrackingSpecification."Retest Date";
                    //Status := pioTempTrackingSpecification.Status;
                    //Begin#803/01:A20005/3.00  12.04.07 TECTURA.WW
                    // ORIG:
                    // Substatus := pioTempTrackingSpecification.Substatus;
                    //End#803/01:A20005/3.00  12.04.07 TECTURA.WW
                    //Begin#803/01:A20005/3.00  17.04.07 TECTURA.WW
                    "New Expiration Date" := pioTempTrackingSpecification."New Expiration Date";
                    //End#803/01:A20005/3.00  17.04.07 TECTURA.WW
                    //End#803/01:A1006/1.50

                    //Begin#803/01:A3014-7/2.10  06.09.04 ASTON.FB
                    //"Entry Date" := pioTempTrackingSpecification."Entry Date";
                    //End#803/01:A3014-7/2.10  06.09.04 ASTON.FB

                    // >> #803/01:A30010/6.00 09.02.09 TECTURA.AM
                    //Begin#800/01:A1000/1.50
                    //"No. of Units" := pioTempTrackingSpecification."No. of Units";
                    //End#800/01:A1000/1.50
                    // << #803/01:A30010/6.00 09.02.09 TECTURA.AM
                    "Entry No." := NextEntryNo;
                    INSERT;
                END;
            UNTIL pioTempTrackingSpecification.NEXT = 0;


        RESET;
        IF FIND('-') THEN
            REPEAT
                //Begin#803/01:A3017/2.10  17.11.04 ASTON.FB
                pioTempTrackingSpecification.SETRANGE("Lot No.", "Lot No.");
                pioTempTrackingSpecification.SETRANGE("Serial No.", "Serial No.");
                IF NOT pioTempTrackingSpecification.FIND('-') THEN BEGIN
                    DELETE(TRUE)
                END ELSE
                    //End#803/01:A3017/2.10  17.11.04 ASTON.FB
                    CheckItemTrackingLine(Rec);
            UNTIL NEXT = 0;

        SETRANGE("Lot No.", piTrackingSpecification."Lot No.");
        SETRANGE("Serial No.", piTrackingSpecification."Serial No.");

        CalculateSums;
        IF UpdateUndefinedQty THEN
            WriteToDatabase
        ELSE
            ERROR(Text014, TotalItemTrackingLine."Quantity (Base)",
              LOWERCASE(TempReservEntry.TextCaption), SourceQuantityArray[1]);

        IF FormRunMode = FormRunMode::Transfer THEN
            SynchronizeLinkedSources('');
    end;

    procedure NoNewSerialLotNumbers(piSet: Boolean)
    begin
        //#803/01:A2056/1.50

        gNoSerialLotNo := piSet;
    end;

    procedure SetgLotDeterminingData(piSetLotCode: Code[30]; piSetExpirDate: Date)
    begin
        //#803/01:A3017/2.10  23.09.04 ASTON.FB

        gLotDeterminingLotCode := piSetLotCode;
        gLotDeterminingExpirDate := piSetExpirDate;
    end;

    procedure SetgNoAssignLotDetLotNo(piSet: Boolean)
    begin
        //#803/01:A3017/2.10  15.11.04 ASTON.FB

        gNoAssignLotDetLotNo := piSet;
    end;

    procedure CheckFromTheSameLot(piForceError: Boolean): Boolean
    var
        TrackingSpecification: Record "Tracking Specification";
    begin
        //IF gFromTheSameLot THEN BEGIN
        IF gNoAssignLotDetLotNo THEN BEGIN

            TrackingSpecification.COPY(Rec);
            RESET;
            IF NOT FIND('-') THEN BEGIN
                COPY(TrackingSpecification);
                EXIT(TRUE);
            END;

            //Begin#803/01:A20071/3.00  11.05.07 TECTURA.WW
            // // ORIG:
            // // MfgSetup.GET;
            // // IF NOT MfgSetup."Lot Trading Unit Inheritance" THEN
            //LSSetup.GET;
            //IF NOT LSSetup."Lot Trading Unit Inheritance" THEN
            //End#803/01:A20071/3.00  11.05.07 TECTURA.WW
            //  SETFILTER("Lot Number", '<>%1', TrackingSpecification."Lot Number")
            //ELSE
            //  SETFILTER("Lot No.", '<>%1', TrackingSpecification."Lot No.");
            SETFILTER("Lot No.", '<>%1', TrackingSpecification."Lot No.");

            /*
              IF NOT FIND('=><') THEN BEGIN
                IF TrackingSpecification."Lot Number" = "Lot Number" THEN BEGIN
                  COPY(TrackingSpecification);
                  EXIT(TRUE);
                END;
              END;
            */

            COPY(TrackingSpecification);
            IF piForceError THEN
                ERROR(CstGErr0001)
            ELSE BEGIN
                MESSAGE(CstGErr0001);
                EXIT(FALSE);
            END;
        END;

        EXIT(TRUE);

    end;

    procedure SaveData()
    var
        TempTrackingSpecificationSaved: Record "Tracking Specification" temporary;
        ProdOrderComp: Record "Prod. Order Component";
        SavedTrackingSpec: Record "Tracking Specification";
        TotalItemTrackingLine: Record "Tracking Specification";
        FormRunMode: option " ",Reclass,"Combined Ship/Rcpt","Drop Shipment",Transfer;
        Text015: label 'Do you want to synchronize item tracking on the line with item tracking on the related drop shipment %1?';
        Text016: label 'purchase order line';
        Text017: label 'sales order line';
        xTempItemTrackingLine: Record "Tracking Specification" temporary;
    begin
        //IF NOT gIngrHandling THEN
        //  EXIT;
        IF gCurrSourceSpecificationSet THEN BEGIN
            IF FIND('-') THEN
                REPEAT
                    TempTrackingSpecificationSaved := Rec;
                    TempTrackingSpecificationSaved.INSERT;
                UNTIL NEXT = 0;

            IF SourceQuantityArray[1] < TotalItemTrackingLine."Quantity (Base)" THEN BEGIN
                ProdOrderComp.GET("Source Subtype", "Source ID", "Source Prod. Order Line", "Source Ref. No.");
                ProdOrderComp.BlockDynamicTracking(TRUE);
                //    ProdOrderComp.VALIDATE("Ingr. Balancing Quantity",
                //      ProdOrderComp."Ingr. Balancing Quantity" +
                //      ROUND(
                //        (TotalItemTrackingLine."Quantity (Base)" - SourceQuantityArray[1]) / ProdOrderComp."Qty. per Unit of Measure",
                //        0.00001));
                ProdOrderComp.BlockDynamicTracking(FALSE);
                ProdOrderComp.MODIFY(TRUE);
                //    cuIngrMgt.POC_AdjustVariableLines(ProdOrderComp);
                SourceQuantityArray[1] := ProdOrderComp."Expected Qty. (Base)";
                SourceQuantityArray[2] := ProdOrderComp."Expected Qty. (Base)";
                gCurrSourceSpecification."Quantity (Base)" := ProdOrderComp."Expected Qty. (Base)";
                gCurrSourceSpecification."Qty. to Handle (Base)" := ProdOrderComp."Expected Qty. (Base)";
            END;

            IF UpdateUndefinedQty THEN BEGIN
                WriteToDatabase;
                IF FormRunMode = FormRunMode::"Drop Shipment" THEN
                    CASE CurrentSourceType OF
                        DATABASE::"Sales Line":
                            SynchronizeLinkedSources(STRSUBSTNO(Text015, Text016));
                        DATABASE::"Purchase Line":
                            SynchronizeLinkedSources(STRSUBSTNO(Text015, Text017));
                    END;

                IF SourceQuantityArray[1] > TotalItemTrackingLine."Quantity (Base)" THEN BEGIN
                    ProdOrderComp.GET("Source Subtype", "Source ID", "Source Prod. Order Line", "Source Ref. No.");
                    /*
                          IF ProdOrderComp."Ingr. Balancing Quantity" > 0 THEN BEGIN
                            ProdOrderComp."Ingr. Balancing Quantity" := ProdOrderComp."Ingr. Balancing Quantity" -
                              ROUND(
                                (SourceQuantityArray[1] - TotalItemTrackingLine."Quantity (Base)") / ProdOrderComp."Qty. per Unit of Measure",
                                0.00001);
                            IF ProdOrderComp."Ingr. Balancing Quantity" < 0 THEN
                              ProdOrderComp."Ingr. Balancing Quantity" := 0;
                            ProdOrderComp.VALIDATE("Ingr. Balancing Quantity");
                            ProdOrderComp.MODIFY(TRUE);
                            cuIngrMgt.POC_AdjustVariableLines(ProdOrderComp);
                            SourceQuantityArray[1] := ProdOrderComp."Expected Qty. (Base)";
                            SourceQuantityArray[2] := ProdOrderComp."Expected Qty. (Base)";
                            gCurrSourceSpecification."Quantity (Base)" := ProdOrderComp."Expected Qty. (Base)";
                            gCurrSourceSpecification."Qty. to Handle (Base)" := ProdOrderComp."Expected Qty. (Base)";
                          END;
                    */
                END;

                xTempItemTrackingLine.RESET;
                xTempItemTrackingLine.DELETEALL;
                RESET;
                DELETEALL;

                SetSourceSpec(gCurrSourceSpecification, gCurrSourceSpecDueDate);

                SavedTrackingSpec.COPY(Rec);
                IF TempTrackingSpecificationSaved.FIND('-') THEN
                    REPEAT
                        SETRANGE("Lot No.", TempTrackingSpecificationSaved."Lot No.");
                        SETRANGE("Serial No.", TempTrackingSpecificationSaved."Serial No.");
                        IF NOT FIND('-') THEN BEGIN
                            Rec := TempTrackingSpecificationSaved;
                            "Entry No." := NextEntryNo;
                            INSERT;
                            TempItemTrackLineInsert.TRANSFERFIELDS(Rec);
                            TempItemTrackLineInsert.INSERT();
                        END;
                    UNTIL TempTrackingSpecificationSaved.NEXT = 0;
                COPY(SavedTrackingSpec);
            END;
        END;

    end;

    procedure SetgFromTheSameLot(piSet: Boolean)
    begin
        gFromTheSameLot := piSet;
    end;

    procedure GetTempTrkgSpec(var pioTempTrackingSpecification: Record "Tracking Specification" temporary)
    begin
        // #NAV20100:A1000 20.04.07 TECTURA.SE
        IF FIND('-') THEN
            REPEAT
                pioTempTrackingSpecification := Rec;
                pioTempTrackingSpecification.INSERT;
            UNTIL NEXT = 0;
    end;

    procedure CheckItemTrackingLine(TrackingLine: Record "Tracking Specification")
    var
        Text002: Label 'Quantity must be %1.';
        Text003: Label 'negative';
        Text004: Label 'positive';
    begin
        if TrackingLine."Quantity (Base)" * SourceQuantityArray[1] < 0 then
            if SourceQuantityArray[1] < 0 then
                Error(Text002, Text003)
            else
                Error(Text002, Text004);
    end;

}

