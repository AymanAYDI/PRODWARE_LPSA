pageextension 50084 pageextension50084 extends "Item Tracking Lines"
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
        addafter("Control 24")
        {
            field(NC; NC)
            {
                ApplicationArea = All;
            }
        }
    }

    var
        "-FE_LAPIERRETTE_PROD01.001": Integer;
        gNoSerialLotNo: Boolean;
        gLotDeterminingLotCode: Code[30];
        gLotDeterminingExpirDate: Date;
        gNoAssignLotDetLotNo: Boolean;
        gCurrSourceSpecification: Record "336";
        gCurrSourceSpecDueDate: Date;
        gCurrSourceSpecificationSet: Boolean;
        gFromTheSameLot: Boolean;
        CstGErr0001: Label 'You only can assign one Lot!';
        CstGErr0002: Label 'Lot Inheritance: You can''t assign a Lot No.,\because there is no Lot assigned to the lot determining component.';


    //Unsupported feature: Code Modification on "OnInsertRecord".

    //trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF "Entry No." <> 0 THEN
      EXIT(FALSE);
    "Entry No." := NextEntryNo;
    "Qty. per Unit of Measure" := QtyPerUOM;
    IF (NOT InsertIsBlocked) AND (NOT ZeroLineExists) THEN
      IF NOT TestTempSpecificationExists THEN BEGIN
        TempItemTrackLineInsert.TRANSFERFIELDS(Rec);
        TempItemTrackLineInsert.INSERT;
        INSERT;
        ItemTrackingDataCollection.UpdateLotSNDataSetWithChange(
          TempItemTrackLineInsert,CurrentSignFactor * SourceQuantityArray[1] < 0,CurrentSignFactor,0);
      END;
    CalculateSums;

    EXIT(FALSE);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..6
        //>>FE_LAPIERRETTE_PROD01.001
        IF CheckFromTheSameLot({piForceError=} FALSE) THEN BEGIN
        //<<FE_LAPIERRETTE_PROD01.001

    #7..11

        //>>FE_LAPIERRETTE_PROD01.001
        END;
        //<<FE_LAPIERRETTE_PROD01.001

    #12..15
    */
    //end;


    //Unsupported feature: Code Modification on "SetSource(PROCEDURE 1)".

    //procedure SetSource();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    GetItem(TrackingSpecification."Item No.");
    ForBinCode := TrackingSpecification."Bin Code";
    SetFilters(TrackingSpecification);
    TempTrackingSpecification.DELETEALL;
    TempItemTrackLineInsert.DELETEALL;
    TempItemTrackLineModify.DELETEALL;
    TempItemTrackLineDelete.DELETEALL;

    TempReservEntry.DELETEALL;
    LastEntryNo := 0;
    IF ItemTrackingMgt.IsOrderNetworkEntity(TrackingSpecification."Source Type",
         TrackingSpecification."Source Subtype") AND NOT (FormRunMode = FormRunMode::"Drop Shipment")
    THEN
      CurrentEntryStatus := CurrentEntryStatus::Surplus
    ELSE
      CurrentEntryStatus := CurrentEntryStatus::Prospect;

    IF (TrackingSpecification."Source Type" IN
        [DATABASE::"Item Ledger Entry",
        DATABASE::"Item Journal Line",
        DATABASE::"Job Journal Line",
        DATABASE::"BOM Journal Line",
        DATABASE::"Requisition Line"]) OR
       ((TrackingSpecification."Source Type" IN [DATABASE::"Sales Line",DATABASE::"Purchase Line",DATABASE::"Service Line"]) AND
        (TrackingSpecification."Source Subtype" IN [0,2,3]))
    THEN
      SetControls(Controls::Handle,FALSE)
    ELSE
      SetControls(Controls::Handle,TRUE);

    IF (TrackingSpecification."Source Type" IN
        [DATABASE::"Item Ledger Entry",
        DATABASE::"Item Journal Line",
        DATABASE::"Job Journal Line",
        DATABASE::"BOM Journal Line",
        DATABASE::"Requisition Line",
        DATABASE::"Transfer Line",
        DATABASE::"Prod. Order Line",
        DATABASE::"Prod. Order Component"]) OR
       ((TrackingSpecification."Source Type" IN [DATABASE::"Sales Line",DATABASE::"Purchase Line",DATABASE::"Service Line"]) AND
        (TrackingSpecification."Source Subtype" IN [0,2,3,4]))
    THEN
      SetControls(Controls::Invoice,FALSE)
    ELSE
      SetControls(Controls::Invoice,TRUE);

    SetControls(Controls::Reclass,FormRunMode = FormRunMode::Reclass);

    IF FormRunMode = FormRunMode::"Combined Ship/Rcpt" THEN
      SetControls(Controls::LotSN,FALSE);
    IF ItemTrackingMgt.ItemTrkgIsManagedByWhse(
      TrackingSpecification."Source Type",
      TrackingSpecification."Source Subtype",
      TrackingSpecification."Source ID",
      TrackingSpecification."Source Prod. Order Line",
      TrackingSpecification."Source Ref. No.",
      TrackingSpecification."Location Code",
      TrackingSpecification."Item No.")
    THEN BEGIN
      SetControls(Controls::Quantity,FALSE);
      "Qty. to Handle (Base)Editable" := TRUE;
      DeleteIsBlocked := TRUE;
    END;

    ReservEntry."Source Type" := TrackingSpecification."Source Type";
    ReservEntry."Source Subtype" := TrackingSpecification."Source Subtype";
    CurrentSignFactor := CreateReservEntry.SignFactor(ReservEntry);
    CurrentSourceCaption := ReservEntry.TextCaption;
    CurrentSourceType := ReservEntry."Source Type";

    IF CurrentSignFactor < 0 THEN BEGIN
      ExpectedReceiptDate := 0D;
      ShipmentDate := AvailabilityDate;
    END ELSE BEGIN
      ExpectedReceiptDate := AvailabilityDate;
      ShipmentDate := 0D;
    END;

    SourceQuantityArray[1] := TrackingSpecification."Quantity (Base)";
    SourceQuantityArray[2] := TrackingSpecification."Qty. to Handle (Base)";
    SourceQuantityArray[3] := TrackingSpecification."Qty. to Invoice (Base)";
    SourceQuantityArray[4] := TrackingSpecification."Quantity Handled (Base)";
    SourceQuantityArray[5] := TrackingSpecification."Quantity Invoiced (Base)";
    QtyPerUOM := TrackingSpecification."Qty. per Unit of Measure";

    ReservEntry.SETCURRENTKEY(
      "Source ID","Source Ref. No.","Source Type","Source Subtype",
      "Source Batch Name","Source Prod. Order Line","Reservation Status");

    ReservEntry.SETRANGE("Source ID",TrackingSpecification."Source ID");
    ReservEntry.SETRANGE("Source Ref. No.",TrackingSpecification."Source Ref. No.");
    ReservEntry.SETRANGE("Source Type",TrackingSpecification."Source Type");
    ReservEntry.SETRANGE("Source Subtype",TrackingSpecification."Source Subtype");
    ReservEntry.SETRANGE("Source Batch Name",TrackingSpecification."Source Batch Name");
    ReservEntry.SETRANGE("Source Prod. Order Line",TrackingSpecification."Source Prod. Order Line");

    // Transfer Receipt gets special treatment:
    IF (TrackingSpecification."Source Type" = DATABASE::"Transfer Line") AND
       (FormRunMode <> FormRunMode::Transfer) AND
       (TrackingSpecification."Source Subtype" = 1) THEN BEGIN
      ReservEntry.SETRANGE("Source Subtype",0);
      AddReservEntriesToTempRecSet(ReservEntry,TempTrackingSpecification2,TRUE,8421504);
      ReservEntry.SETRANGE("Source Subtype",1);
      ReservEntry.SETRANGE("Source Prod. Order Line",TrackingSpecification."Source Ref. No.");
      ReservEntry.SETRANGE("Source Ref. No.");
      DeleteIsBlocked := TRUE;
      SetControls(Controls::Quantity,FALSE);
    END;

    AddReservEntriesToTempRecSet(ReservEntry,TempTrackingSpecification,FALSE,0);

    TempReservEntry.COPYFILTERS(ReservEntry);

    TrackingSpecification.SETCURRENTKEY(
      "Source ID","Source Type","Source Subtype",
      "Source Batch Name","Source Prod. Order Line","Source Ref. No.");

    TrackingSpecification.SETRANGE("Source ID",TrackingSpecification."Source ID");
    TrackingSpecification.SETRANGE("Source Type",TrackingSpecification."Source Type");
    TrackingSpecification.SETRANGE("Source Subtype",TrackingSpecification."Source Subtype");
    TrackingSpecification.SETRANGE("Source Batch Name",TrackingSpecification."Source Batch Name");
    TrackingSpecification.SETRANGE("Source Prod. Order Line",TrackingSpecification."Source Prod. Order Line");
    TrackingSpecification.SETRANGE("Source Ref. No.",TrackingSpecification."Source Ref. No.");

    IF TrackingSpecification.FINDSET THEN
      REPEAT
        TempTrackingSpecification := TrackingSpecification;
        TempTrackingSpecification.INSERT;
      UNTIL TrackingSpecification.NEXT = 0;

    // Data regarding posted quantities on transfers is collected from Item Ledger Entries:
    IF TrackingSpecification."Source Type" = DATABASE::"Transfer Line" THEN
      CollectPostedTransferEntries(TrackingSpecification,TempTrackingSpecification);

    // Data regarding posted output quantities on prod.orders is collected from Item Ledger Entries:
    IF TrackingSpecification."Source Type" = DATABASE::"Prod. Order Line" THEN
      IF TrackingSpecification."Source Subtype" = 3 THEN
        CollectPostedOutputEntries(TrackingSpecification,TempTrackingSpecification);

    // If run for Drop Shipment a RowID is prepared for synchronisation:
    IF FormRunMode = FormRunMode::"Drop Shipment" THEN
      CurrentSourceRowID := ItemTrackingMgt.ComposeRowID(TrackingSpecification."Source Type",
        TrackingSpecification."Source Subtype",TrackingSpecification."Source ID",
        TrackingSpecification."Source Batch Name",TrackingSpecification."Source Prod. Order Line",
        TrackingSpecification."Source Ref. No.");

    // Synchronization of outbound transfer order:
    IF (TrackingSpecification."Source Type" = DATABASE::"Transfer Line") AND
       (TrackingSpecification."Source Subtype" = 0) THEN BEGIN
      BlockCommit := TRUE;
      CurrentSourceRowID := ItemTrackingMgt.ComposeRowID(TrackingSpecification."Source Type",
        TrackingSpecification."Source Subtype",TrackingSpecification."Source ID",
        TrackingSpecification."Source Batch Name",TrackingSpecification."Source Prod. Order Line",
        TrackingSpecification."Source Ref. No.");
      SecondSourceRowID := ItemTrackingMgt.ComposeRowID(TrackingSpecification."Source Type",
        1,TrackingSpecification."Source ID",
        TrackingSpecification."Source Batch Name",TrackingSpecification."Source Prod. Order Line",
        TrackingSpecification."Source Ref. No.");
      FormRunMode := FormRunMode::Transfer;
    END;

    AddToGlobalRecordSet(TempTrackingSpecification);
    AddToGlobalRecordSet(TempTrackingSpecification2);
    CalculateSums;

    ItemTrackingDataCollection.SetCurrentBinAndItemTrkgCode(ForBinCode,ItemTrackingCode);
    ItemTrackingDataCollection.RetrieveLookupData(Rec,FALSE);

    FunctionsDemandVisible := CurrentSignFactor * SourceQuantityArray[1] < 0;
    FunctionsSupplyVisible := NOT FunctionsDemandVisible;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    //>>FE_LAPIERRETTE_PROD01.001
    gCurrSourceSpecification := TrackingSpecification;
    gCurrSourceSpecDueDate := AvailabilityDate;
    gCurrSourceSpecificationSet := TRUE;
    //<<FE_LAPIERRETTE_PROD01.001

    #1..17
    //>>FE_LAPIERRETTE_PROD01.001
    #65..67
    //<<FE_LAPIERRETTE_PROD01.001
    #30..35
    #23..170
    */
    //end;

    //Unsupported feature: Variable Insertion (Variable: ---FE_LAPIERRETTE_PROD01.001) (VariableCollection) on "AssignLotNo(PROCEDURE 21)".


    //Unsupported feature: Variable Insertion (Variable: cuLSAvailMgt) (VariableCollection) on "AssignLotNo(PROCEDURE 21)".



    //Unsupported feature: Code Modification on "AssignLotNo(PROCEDURE 21)".

    //procedure AssignLotNo();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF ZeroLineExists THEN
      DELETE;

    IF (SourceQuantityArray[1] * UndefinedQtyArray[1] <= 0) OR
       (ABS(SourceQuantityArray[1]) < ABS(UndefinedQtyArray[1]))
    THEN
    #7..10
    GetItem("Item No.");

    Item.TESTFIELD("Lot Nos.");
    VALIDATE("Lot No.",NoSeriesMgt.GetNextNo(Item."Lot Nos.",WORKDATE,TRUE));
    "Qty. per Unit of Measure" := QtyPerUOM;
    VALIDATE("Quantity (Base)",QtyToCreate);
    "Entry No." := NextEntryNo;
    TestTempSpecificationExists;
    INSERT;
    TempItemTrackLineInsert.TRANSFERFIELDS(Rec);
    TempItemTrackLineInsert.INSERT;
    ItemTrackingDataCollection.UpdateLotSNDataSetWithChange(
      TempItemTrackLineInsert,CurrentSignFactor * SourceQuantityArray[1] < 0,CurrentSignFactor,0);
    CalculateSums;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    //>>FE_LAPIERRETTE_PROD01.001
    IF gNoAssignLotDetLotNo AND (gLotDeterminingLotCode = '') THEN
      ERROR(CstGErr0002);
    //<<FE_LAPIERRETTE_PROD01.001


    #1..3
    //>>FE_LAPIERRETTE_PROD01.001
    //CheckFromTheSameLot({piForceError=}TRUE);
    //<<FE_LAPIERRETTE_PROD01.001

    #4..13

    //>>FE_LAPIERRETTE_PROD01.001
    // STD:
    // VALIDATE("Lot No.",NoSeriesMgt.GetNextNo(Item."Lot Nos.",WORKDATE,TRUE));
    IF gLotDeterminingLotCode = '' THEN BEGIN
      VALIDATE("Lot No.", NoSeriesMgt.GetNextNo(Item."Lot Nos.", WORKDATE, TRUE));
    END ELSE
      VALIDATE("Lot No.", gLotDeterminingLotCode);
    //<<FE_LAPIERRETTE_PROD01.001

    //>>FE_LAPIERRETTE_PROD01.001
    cuLSAvailMgt.CheckItemTrackingAssignment(
      "Source Type",
      "Source Subtype",
      "Source ID",
      "Source Batch Name",
      "Source Prod. Order Line",
      "Source Ref. No.",
      "Lot Number",
      "Trading Unit Number",
      "Lot No.",
      "Serial No.",
      TRUE);
    //<<FE_LAPIERRETTE_PROD01.001

    "Qty. per Unit of Measure" := QtyPerUOM;
    VALIDATE("Quantity (Base)",QtyToCreate);

    //>>FE_LAPIERRETTE_PROD01.001
    IF gLotDeterminingExpirDate <> 0D THEN
      "Expiration Date" := gLotDeterminingExpirDate;
    //<<FE_LAPIERRETTE_PROD01.001

    #17..24
    */
    //end;

    procedure "---FE_LAPIERRETTE_PROD01.001"()
    begin
    end;

    procedure RegisterItemTrackingLines2(piTrackingSpecification: Record "336"; piAvailabilityDate: Date; var pioTempTrackingSpecification: Record "336" temporary; piReplace: Boolean)
    begin



        piTrackingSpecification.TESTFIELD("Source Type"); // Check if source has been set.
                                                          //IF NOT CalledFromSynchWhseItemTrkg THEN
        pioTempTrackingSpecification.RESET;

        IsCorrection := piTrackingSpecification.Correction;
        SetSource(piTrackingSpecification, piAvailabilityDate);
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
                    CheckLine(Rec);
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
        TrackingSpecification: Record "336";
    begin
        //
        //LSSetup         Record             Life Science Setup


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
        TempTrackingSpecificationSaved: Record "336" temporary;
        ProdOrderComp: Record "5407";
        SavedTrackingSpec: Record "336";
    begin
        //
        // cuIngrMgt              Codeunit           Ingredient Mgt.


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

                SetSource(gCurrSourceSpecification, gCurrSourceSpecDueDate);

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
        //#803/01:A3017/2.10  23.09.04 ASTON.FB

        gFromTheSameLot := piSet;
    end;

    procedure GetTempTrkgSpec(var pioTempTrackingSpecification: Record "336" temporary)
    begin
        // #NAV20100:A1000 20.04.07 TECTURA.SE
        IF FIND('-') THEN
            REPEAT
                pioTempTrackingSpecification := Rec;
                pioTempTrackingSpecification.INSERT;
            UNTIL NEXT = 0;
    end;
}

