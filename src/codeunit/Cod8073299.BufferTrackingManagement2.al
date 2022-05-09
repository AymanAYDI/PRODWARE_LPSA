codeunit 8073299 "Buffer Tracking Management 2"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.5
    // WMS-FE007_15.001:GR 05/07/2011 Receipt
    //                                - Create Object
    // 
    // //>>ProdConnect1.06
    // OSYS-Int001.001:GR 18/10/2011   Connector integration
    //                                - Add function GetTrackingSpecification
    // 
    // +----------------------------------------------------------------------------------------------------------------+


    trigger OnRun()
    begin
    end;

    var
        Item: Record Item;
        ItemTrackingCode: Record "Item Tracking Code";
        PurchLineNC: Record "Purchase Line";
        TempReservEntry: Record "Reservation Entry" temporary;
        SalesLineNC: Record "Sales Line";
        Rec: Record "Tracking Specification" temporary;
        TempItemTrackLineDelete: Record "Tracking Specification" temporary;
        TempItemTrackLineInsert: Record "Tracking Specification" temporary;
        TempItemTrackLineModify: Record "Tracking Specification" temporary;
        TempItemTrackLineReserv: Record "Tracking Specification" temporary;
        TotalItemTrackingLine: Record "Tracking Specification";
        xTempItemTrackingLine: Record "Tracking Specification" temporary;
        TransferLineNC: Record "Transfer Line";
        // WhseReceiptLineNC: Record "Warehouse Receipt Line";
        WhseShptLineNC: Record "Warehouse Shipment Line";
        ItemTrackingDataCollection: Codeunit "Item Tracking Data Collection";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        BlockCommit: Boolean;
        CalledFromSynchWhseItemTrkg: Boolean;
        CurrentFormIsOpen: Boolean;
        // DeleteIsBlocked: Boolean;
        Inbound: Boolean;
        InsertIsBlocked: Boolean;
        IsCorrection: Boolean;
        IsPick: Boolean;
        LotAvailabilityActive: Boolean;
        SNAvailabilityActive: Boolean;
        ForBinCode: Code[20];
        ExpectedReceiptDate: Date;
        ShipmentDate: Date;
        QtyPerUOM: Decimal;
        QtyToAddAsBlank: Decimal;
        SourceQuantityArray: array[5] of Decimal;
        UndefinedQtyArray: array[3] of Decimal;
        ColorOfQuantityArray: array[3] of Integer;
        CurrentSignFactor: Integer;
        CurrentSourceType: Integer;
        LastEntryNo: Integer;
        SourceTable: Integer;
        Text002: Label 'Quantity must be %1.';
        Text003: Label 'negative';
        Text004: Label 'positive';
        Text005: Label 'Error when writing to database.';
        Text007: Label 'Another user has modified the item tracking data since it was retrieved from the database.\Start again.';
        Text008: Label 'The quantity to create must be an integer.';
        Text009: Label 'The quantity to create must be positive.';
        Text011: Label '%1 already exists with %2 %3 and %4 %5.';
        Text012: Label '%1 already exists with %2 %3.';
        Text013: Label 'The string %1 contains no number and cannot be incremented.';
        Text014: Label 'The total item tracking quantity %1 exceeds the %2 quantity %3.\The changes cannot be saved to the database.';
        Text018: Label 'Saving item tracking line changes';
        FormRunMode: Option ,Reclass,"Combined Ship/Rcpt","Drop Shipment",Transfer;
        DirectionNC: Option Outbound,Inbound;
        CurrentEntryStatus: Enum "Reservation Status";
        CurrentSourceRowID: Text[100];
        SecondSourceRowID: Text[100];
        CurrentSourceCaption: Text[255];


    procedure SetFormRunMode(Mode: Option ,Reclass,"Combined Ship/Rcpt","Drop Shipment")
    begin
        FormRunMode := Mode;
    end;


    procedure SetSource(TrackingSpecification: Record "Tracking Specification"; AvailabilityDate: Date)
    var
        ReservEntry: Record "Reservation Entry";
        TempTrackingSpecification: Record "Tracking Specification" temporary;
        TempTrackingSpecification2: Record "Tracking Specification" temporary;
        CreateReservEntry: Codeunit "Create Reserv. Entry";
    begin
        Rec.RESET();
        Rec.DELETEALL();

        GetItem(TrackingSpecification."Item No.");
        ForBinCode := TrackingSpecification."Bin Code";
        SetFilters(TrackingSpecification);

        TempTrackingSpecification.RESET();
        TempItemTrackLineInsert.RESET();
        TempItemTrackLineModify.RESET();
        TempItemTrackLineDelete.RESET();
        TempReservEntry.RESET();

        TempTrackingSpecification.DELETEALL();
        TempItemTrackLineInsert.DELETEALL();
        TempItemTrackLineModify.DELETEALL();
        TempItemTrackLineDelete.DELETEALL();
        TempReservEntry.DELETEALL();
        LastEntryNo := 0;

        IF ItemTrackingMgt.IsOrderNetworkEntity(TrackingSpecification."Source Type",
             TrackingSpecification."Source Subtype") AND NOT (FormRunMode = FormRunMode::"Drop Shipment")
        THEN
            CurrentEntryStatus := CurrentEntryStatus::Surplus
        ELSE
            CurrentEntryStatus := CurrentEntryStatus::Prospect;

        IF ItemTrackingMgt.ItemTrkgIsManagedByWhse(
          TrackingSpecification."Source Type",
          TrackingSpecification."Source Subtype",
          TrackingSpecification."Source ID",
          TrackingSpecification."Source Prod. Order Line",
          TrackingSpecification."Source Ref. No.",
          TrackingSpecification."Location Code",
          TrackingSpecification."Item No.")
        THEN
            ;
        // DeleteIsBlocked := TRUE;


        ReservEntry."Source Type" := TrackingSpecification."Source Type";
        ReservEntry."Source Subtype" := TrackingSpecification."Source Subtype";
        CurrentSignFactor := CreateReservEntry.SignFactor(ReservEntry);
        CurrentSourceCaption := ReservEntry.TextCaption();
        // CurrentSourceType := ReservEntry."Source Type";

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
          "Source ID", "Source Ref. No.", "Source Type", "Source Subtype",
          "Source Batch Name", "Source Prod. Order Line", "Reservation Status");

        ReservEntry.SETRANGE("Source ID", TrackingSpecification."Source ID");
        ReservEntry.SETRANGE("Source Ref. No.", TrackingSpecification."Source Ref. No.");
        ReservEntry.SETRANGE("Source Type", TrackingSpecification."Source Type");
        ReservEntry.SETRANGE("Source Subtype", TrackingSpecification."Source Subtype");
        ReservEntry.SETRANGE("Source Batch Name", TrackingSpecification."Source Batch Name");
        ReservEntry.SETRANGE("Source Prod. Order Line", TrackingSpecification."Source Prod. Order Line");

        // Transfer Receipt gets special treatment:
        IF (TrackingSpecification."Source Type" = DATABASE::"Transfer Line") AND
           (FormRunMode <> FormRunMode::Transfer) AND
           (TrackingSpecification."Source Subtype" = 1) THEN BEGIN
            ReservEntry.SETRANGE("Source Subtype", 0);
            AddReservEntriesToTempRecSet(ReservEntry, TempTrackingSpecification2, TRUE, 8421504);
            ReservEntry.SETRANGE("Source Subtype", 1);
            ReservEntry.SETRANGE("Source Prod. Order Line", TrackingSpecification."Source Ref. No.");
            ReservEntry.SETRANGE("Source Ref. No.");
            // DeleteIsBlocked := TRUE;
        END;

        AddReservEntriesToTempRecSet(ReservEntry, TempTrackingSpecification, FALSE, 0);

        TempReservEntry.COPYFILTERS(ReservEntry);

        TrackingSpecification.SETCURRENTKEY(
          "Source ID", "Source Type", "Source Subtype",
          "Source Batch Name", "Source Prod. Order Line", "Source Ref. No.");

        TrackingSpecification.SETRANGE("Source ID", TrackingSpecification."Source ID");
        TrackingSpecification.SETRANGE("Source Type", TrackingSpecification."Source Type");
        TrackingSpecification.SETRANGE("Source Subtype", TrackingSpecification."Source Subtype");
        TrackingSpecification.SETRANGE("Source Batch Name", TrackingSpecification."Source Batch Name");
        TrackingSpecification.SETRANGE("Source Prod. Order Line", TrackingSpecification."Source Prod. Order Line");
        TrackingSpecification.SETRANGE("Source Ref. No.", TrackingSpecification."Source Ref. No.");

        IF TrackingSpecification.FINDSET() THEN
            REPEAT
                TempTrackingSpecification := TrackingSpecification;
                TempTrackingSpecification.INSERT();
            UNTIL TrackingSpecification.NEXT() = 0;

        // Data regarding posted quantities on transfers is collected from Item Ledger Entries:
        IF TrackingSpecification."Source Type" = DATABASE::"Transfer Line" THEN
            CollectPostedTransferEntries(TrackingSpecification, TempTrackingSpecification);

        // Data regarding posted output quantities on prod.orders is collected from Item Ledger Entries:
        IF TrackingSpecification."Source Type" = DATABASE::"Prod. Order Line" THEN
            IF TrackingSpecification."Source Subtype" = 3 THEN
                CollectPostedOutputEntries(TrackingSpecification, TempTrackingSpecification);

        // If run for Drop Shipment a RowID is prepared for synchronisation:
        IF FormRunMode = FormRunMode::"Drop Shipment" THEN
            CurrentSourceRowID := ItemTrackingMgt.ComposeRowID(TrackingSpecification."Source Type",
              TrackingSpecification."Source Subtype", TrackingSpecification."Source ID",
              TrackingSpecification."Source Batch Name", TrackingSpecification."Source Prod. Order Line",
              TrackingSpecification."Source Ref. No.");

        // Synchronization of outbound transfer order:
        IF (TrackingSpecification."Source Type" = DATABASE::"Transfer Line") AND
           (TrackingSpecification."Source Subtype" = 0) THEN BEGIN
            BlockCommit := TRUE;
            CurrentSourceRowID := ItemTrackingMgt.ComposeRowID(TrackingSpecification."Source Type",
              TrackingSpecification."Source Subtype", TrackingSpecification."Source ID",
              TrackingSpecification."Source Batch Name", TrackingSpecification."Source Prod. Order Line",
              TrackingSpecification."Source Ref. No.");
            SecondSourceRowID := ItemTrackingMgt.ComposeRowID(TrackingSpecification."Source Type",
              1, TrackingSpecification."Source ID",
              TrackingSpecification."Source Batch Name", TrackingSpecification."Source Prod. Order Line",
              TrackingSpecification."Source Ref. No.");
            FormRunMode := FormRunMode::Transfer;
        END;

        AddToGlobalRecordSet(TempTrackingSpecification);
        AddToGlobalRecordSet(TempTrackingSpecification2);
        CalculateSums();

        ItemTrackingDataCollection.SetCurrentBinAndItemTrkgCode(ForBinCode, ItemTrackingCode);
        ItemTrackingDataCollection.RetrieveLookupData(Rec, FALSE);
    end;


    procedure SetSecondSourceQuantity(var SecondSourceQuantityArray: array[3] of Decimal)
    begin
        CASE SecondSourceQuantityArray[1] OF
            DATABASE::"Warehouse Receipt Line", DATABASE::"Warehouse Shipment Line":
                BEGIN
                    SourceQuantityArray[2] := SecondSourceQuantityArray[2]; // "Qty. to Handle (Base)"
                    SourceQuantityArray[3] := SecondSourceQuantityArray[3]; // "Qty. to Invoice (Base)"
                END;
            ELSE
                EXIT;
        END;
        CalculateSums();
    end;


    procedure SetSecondSourceRowID(RowID: Text[100])
    begin
        SecondSourceRowID := RowID;
    end;

    local procedure AddReservEntriesToTempRecSet(var ReservEntry: Record "Reservation Entry"; var TempTrackingSpecification: Record "Tracking Specification" temporary; SwapSign: Boolean; Color: Integer)
    begin
        IF ReservEntry.FINDSET() THEN
            REPEAT
                IF Color = 0 THEN BEGIN
                    TempReservEntry := ReservEntry;
                    TempReservEntry.INSERT();
                END;
                IF (ReservEntry."Lot No." <> '') OR (ReservEntry."Serial No." <> '') THEN BEGIN
                    TempTrackingSpecification.TRANSFERFIELDS(ReservEntry);
                    // Ensure uniqueness of Entry No. by making it negative:
                    TempTrackingSpecification."Entry No." *= -1;
                    IF SwapSign THEN
                        TempTrackingSpecification."Quantity (Base)" *= -1;
                    IF Color <> 0 THEN BEGIN
                        TempTrackingSpecification."Quantity Handled (Base)" :=
                          TempTrackingSpecification."Quantity (Base)";
                        TempTrackingSpecification."Quantity Invoiced (Base)" :=
                          TempTrackingSpecification."Quantity (Base)";
                        TempTrackingSpecification."Qty. to Handle (Base)" := 0;
                        TempTrackingSpecification."Qty. to Invoice (Base)" := 0;
                    END;
                    TempTrackingSpecification."Buffer Status" := Color;
                    TempTrackingSpecification.INSERT();
                END;
            UNTIL ReservEntry.NEXT() = 0;
    end;

    local procedure AddToGlobalRecordSet(var TempTrackingSpecification: Record "Tracking Specification" temporary)
    var
        EntriesExist: Boolean;
        ExpDate: Date;
    begin
        TempTrackingSpecification.SETCURRENTKEY("Lot No.", "Serial No.");
        IF TempTrackingSpecification.FIND('-') THEN
            REPEAT
                TempTrackingSpecification.SETRANGE("Lot No.", TempTrackingSpecification."Lot No.");
                TempTrackingSpecification.SETRANGE("Serial No.", TempTrackingSpecification."Serial No.");
                TempTrackingSpecification.CALCSUMS("Quantity (Base)", "Qty. to Handle (Base)",
                  "Qty. to Invoice (Base)", "Quantity Handled (Base)", "Quantity Invoiced (Base)");
                Rec := TempTrackingSpecification;
                Rec."Quantity (Base)" *= CurrentSignFactor;
                Rec."Qty. to Handle (Base)" *= CurrentSignFactor;
                Rec."Qty. to Invoice (Base)" *= CurrentSignFactor;
                Rec."Quantity Handled (Base)" *= CurrentSignFactor;
                Rec."Quantity Invoiced (Base)" *= CurrentSignFactor;
                Rec."Qty. to Handle" :=
                  Rec.CalcQty(Rec."Qty. to Handle (Base)");
                Rec."Qty. to Invoice" :=
                  Rec.CalcQty(Rec."Qty. to Invoice (Base)");
                Rec."Entry No." := NextEntryNo();

                ExpDate := ItemTrackingMgt.ExistingExpirationDate(
                  Rec."Item No.", Rec."Variant Code",
                  Rec."Lot No.", Rec."Serial No.", FALSE, EntriesExist);

                IF ExpDate <> 0D THEN BEGIN
                    Rec."Expiration Date" := ExpDate;
                    Rec."Buffer Status2" := Rec."Buffer Status2"::"ExpDate blocked";
                END;

                Rec.INSERT();
                IF Rec."Buffer Status" = 0 THEN BEGIN
                    xTempItemTrackingLine := Rec;
                    xTempItemTrackingLine.INSERT();
                END;
                TempTrackingSpecification.FIND('+');
                TempTrackingSpecification.SETRANGE("Lot No.");
                TempTrackingSpecification.SETRANGE("Serial No.");
            UNTIL TempTrackingSpecification.NEXT() = 0;
    end;

    local procedure GetItem(ItemNo: Code[20])
    begin
        IF Item."No." <> ItemNo THEN BEGIN
            Item.GET(ItemNo);
            Item.TESTFIELD("Item Tracking Code");
            IF ItemTrackingCode.Code <> Item."Item Tracking Code" THEN
                ItemTrackingCode.GET(Item."Item Tracking Code");
        END;
    end;

    local procedure SetFilters(TrackingSpecification: Record "Tracking Specification")
    begin
        Rec.FILTERGROUP := 2;
        Rec.SETCURRENTKEY("Source ID", "Source Type", "Source Subtype", "Source Batch Name", "Source Prod. Order Line", "Source Ref. No.");
        Rec.SETRANGE("Source ID", TrackingSpecification."Source ID");
        Rec.SETRANGE("Source Type", TrackingSpecification."Source Type");
        Rec.SETRANGE("Source Subtype", TrackingSpecification."Source Subtype");
        Rec.SETRANGE("Source Batch Name", TrackingSpecification."Source Batch Name");
        IF (TrackingSpecification."Source Type" = DATABASE::"Transfer Line") AND
           (TrackingSpecification."Source Subtype" = 1) THEN BEGIN
            Rec.SETRANGE("Source Prod. Order Line", TrackingSpecification."Source Ref. No.");
            Rec.SETRANGE("Source Ref. No.");
        END ELSE BEGIN
            Rec.SETRANGE("Source Prod. Order Line", TrackingSpecification."Source Prod. Order Line");
            Rec.SETRANGE("Source Ref. No.", TrackingSpecification."Source Ref. No.");
        END;
        Rec.SETRANGE("Item No.", TrackingSpecification."Item No.");
        Rec.SETRANGE("Location Code", TrackingSpecification."Location Code");
        Rec.SETRANGE("Variant Code", TrackingSpecification."Variant Code");
        Rec.FILTERGROUP := 0;
    end;

    local procedure CheckLine(TrackingLine: Record "Tracking Specification"): Boolean
    begin
        IF TrackingLine."Quantity (Base)" * SourceQuantityArray[1] < 0 THEN
            IF SourceQuantityArray[1] < 0 THEN
                ERROR(Text002, Text003)
            ELSE
                ERROR(Text002, Text004);
    end;

    local procedure CalculateSums()
    var
        xTrackingSpec: Record "Tracking Specification";
    begin
        xTrackingSpec.COPY(Rec);
        Rec.RESET();
        Rec.CALCSUMS("Quantity (Base)",
          "Qty. to Handle (Base)",
          "Qty. to Invoice (Base)");
        TotalItemTrackingLine := Rec;
        Rec.COPY(xTrackingSpec);

        UpdateUndefinedQty();
    end;

    local procedure UpdateUndefinedQty() QtyIsValid: Boolean
    begin
        UndefinedQtyArray[1] := SourceQuantityArray[1] - TotalItemTrackingLine."Quantity (Base)";
        UndefinedQtyArray[2] := SourceQuantityArray[2] - TotalItemTrackingLine."Qty. to Handle (Base)";
        UndefinedQtyArray[3] := SourceQuantityArray[3] - TotalItemTrackingLine."Qty. to Invoice (Base)";

        IF ABS(SourceQuantityArray[1]) < ABS(TotalItemTrackingLine."Quantity (Base)") THEN BEGIN
            ColorOfQuantityArray[1] := 255;
            QtyIsValid := FALSE;
        END ELSE BEGIN
            ColorOfQuantityArray[1] := 0;
            QtyIsValid := TRUE;
        END;

        IF ABS(SourceQuantityArray[2]) < ABS(TotalItemTrackingLine."Qty. to Handle (Base)") THEN
            ColorOfQuantityArray[2] := 255
        ELSE
            ColorOfQuantityArray[2] := 0;

        IF ABS(SourceQuantityArray[3]) < ABS(TotalItemTrackingLine."Qty. to Invoice (Base)") THEN
            ColorOfQuantityArray[3] := 255
        ELSE
            ColorOfQuantityArray[3] := 0;
    end;

    local procedure TempRecIsValid() OK: Boolean
    var
        ReservEntry: Record "Reservation Entry";
        IdenticalArray: array[2] of Boolean;
        RecordCount: Integer;
    begin
        OK := FALSE;
        TempReservEntry.SETCURRENTKEY("Entry No.", Positive);
        ReservEntry.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type",
          "Source Subtype", "Source Batch Name", "Source Prod. Order Line");

        ReservEntry.COPYFILTERS(TempReservEntry);

        IF ReservEntry.FINDSET() THEN
            REPEAT
                IF NOT TempReservEntry.GET(ReservEntry."Entry No.", ReservEntry.Positive) THEN
                    EXIT(FALSE);
                IF NOT EntriesAreIdentical(ReservEntry, TempReservEntry, IdenticalArray) THEN
                    EXIT(FALSE);
                RecordCount += 1;
            UNTIL ReservEntry.NEXT() = 0;

        OK := RecordCount = TempReservEntry.COUNT;
    end;

    local procedure EntriesAreIdentical(var ReservEntry1: Record "Reservation Entry"; var ReservEntry2: Record "Reservation Entry"; var IdenticalArray: array[2] of Boolean): Boolean
    begin
        IdenticalArray[1] := (
          (ReservEntry1."Entry No." = ReservEntry2."Entry No.") AND
          (ReservEntry1."Item No." = ReservEntry2."Item No.") AND
          (ReservEntry1."Location Code" = ReservEntry2."Location Code") AND
          (ReservEntry1."Quantity (Base)" = ReservEntry2."Quantity (Base)") AND
          (ReservEntry1."Reservation Status" = ReservEntry2."Reservation Status") AND
          (ReservEntry1."Creation Date" = ReservEntry2."Creation Date") AND
          (ReservEntry1."Transferred from Entry No." = ReservEntry2."Transferred from Entry No.") AND
          (ReservEntry1."Source Type" = ReservEntry2."Source Type") AND
          (ReservEntry1."Source Subtype" = ReservEntry2."Source Subtype") AND
          (ReservEntry1."Source ID" = ReservEntry2."Source ID") AND
          (ReservEntry1."Source Batch Name" = ReservEntry2."Source Batch Name") AND
          (ReservEntry1."Source Prod. Order Line" = ReservEntry2."Source Prod. Order Line") AND
          (ReservEntry1."Source Ref. No." = ReservEntry2."Source Ref. No.") AND
          (ReservEntry1."Expected Receipt Date" = ReservEntry2."Expected Receipt Date") AND
          (ReservEntry1."Shipment Date" = ReservEntry2."Shipment Date") AND
          (ReservEntry1."Serial No." = ReservEntry2."Serial No.") AND
          (ReservEntry1."Created By" = ReservEntry2."Created By") AND
          (ReservEntry1."Changed By" = ReservEntry2."Changed By") AND
          (ReservEntry1.Positive = ReservEntry2.Positive) AND
          (ReservEntry1."Qty. per Unit of Measure" = ReservEntry2."Qty. per Unit of Measure") AND
          (ReservEntry1.Quantity = ReservEntry2.Quantity) AND
          (ReservEntry1."Action Message Adjustment" = ReservEntry2."Action Message Adjustment") AND
          (ReservEntry1.Binding = ReservEntry2.Binding) AND
          (ReservEntry1."Suppressed Action Msg." = ReservEntry2."Suppressed Action Msg.") AND
          (ReservEntry1."Planning Flexibility" = ReservEntry2."Planning Flexibility") AND
          (ReservEntry1."Lot No." = ReservEntry2."Lot No.") AND
          (ReservEntry1."Variant Code" = ReservEntry2."Variant Code") AND
          (ReservEntry1."Quantity Invoiced (Base)" = ReservEntry2."Quantity Invoiced (Base)"));

        IdenticalArray[2] := (
          (ReservEntry1.Description = ReservEntry2.Description) AND
          (ReservEntry1."New Serial No." = ReservEntry2."New Serial No.") AND
          (ReservEntry1."New Lot No." = ReservEntry2."New Lot No.") AND
          (ReservEntry1."Expiration Date" = ReservEntry2."Expiration Date") AND
          (ReservEntry1."Warranty Date" = ReservEntry2."Warranty Date") AND
          (ReservEntry1."New Expiration Date" = ReservEntry2."New Expiration Date"));

        EXIT(IdenticalArray[1] AND IdenticalArray[2]);
    end;

    local procedure QtyToHandleAndInvoiceChanged(var ReservEntry1: Record "Reservation Entry"; var ReservEntry2: Record "Reservation Entry"): Boolean
    begin
        EXIT(
          (ReservEntry1."Qty. to Handle (Base)" <> ReservEntry2."Qty. to Handle (Base)") OR
          (ReservEntry1."Qty. to Invoice (Base)" <> ReservEntry2."Qty. to Invoice (Base)"));
    end;

    local procedure NextEntryNo(): Integer
    begin
        LastEntryNo += 1;
        EXIT(LastEntryNo);
    end;

    local procedure WriteToDatabase()
    var
        Decrease: Boolean;
        Window: Dialog;
        EntryNo: Integer;
        i: Integer;
        ModifyLoop: Integer;
        NoOfLines: Integer;
        ChangeType: Option Insert,Modify,Delete;
    begin
        IF CurrentFormIsOpen THEN BEGIN
            TempReservEntry.LOCKTABLE();
            IF NOT TempRecIsValid() THEN
                ERROR(Text007);

            IF Item."Order Tracking Policy" = Item."Order Tracking Policy"::None THEN
                QtyToAddAsBlank := 0
            ELSE
                QtyToAddAsBlank := UndefinedQtyArray[1] * CurrentSignFactor;

            Rec.RESET();
            Rec.DELETEALL();

            Window.OPEN('#1############# @2@@@@@@@@@@@@@@@@@@@@@');
            Window.UPDATE(1, Text018);
            NoOfLines := TempItemTrackLineInsert.COUNT + TempItemTrackLineModify.COUNT + TempItemTrackLineDelete.COUNT;
            IF TempItemTrackLineDelete.FIND('-') THEN BEGIN
                REPEAT
                    i := i + 1;
                    IF i MOD 100 = 0 THEN
                        Window.UPDATE(2, ROUND(i / NoOfLines * 10000, 1));
                    RegisterChange(TempItemTrackLineDelete, TempItemTrackLineDelete, ChangeType::Delete, FALSE);
                    IF TempItemTrackLineModify.GET(TempItemTrackLineDelete."Entry No.") THEN
                        TempItemTrackLineModify.DELETE();
                UNTIL TempItemTrackLineDelete.NEXT() = 0;
                TempItemTrackLineDelete.DELETEALL();
            END;

            FOR ModifyLoop := 1 TO 2 DO
                IF TempItemTrackLineModify.FIND('-') THEN
                    REPEAT
                        IF xTempItemTrackingLine.GET(TempItemTrackLineModify."Entry No.") THEN BEGIN
                            // Process decreases before increases
                            Decrease := (xTempItemTrackingLine."Quantity (Base)" > TempItemTrackLineModify."Quantity (Base)");
                            IF ((ModifyLoop = 1) AND Decrease) OR ((ModifyLoop = 2) AND NOT Decrease) THEN BEGIN
                                i := i + 1;
                                IF (xTempItemTrackingLine."Serial No." <> TempItemTrackLineModify."Serial No.") OR
                                   (xTempItemTrackingLine."Lot No." <> TempItemTrackLineModify."Lot No.") OR
                                   (xTempItemTrackingLine."Appl.-from Item Entry" <> TempItemTrackLineModify."Appl.-from Item Entry")
                                THEN BEGIN
                                    RegisterChange(xTempItemTrackingLine, xTempItemTrackingLine, ChangeType::Delete, FALSE);
                                    RegisterChange(TempItemTrackLineModify, TempItemTrackLineModify, ChangeType::Insert, FALSE);
                                    IF (TempItemTrackLineInsert."Quantity (Base)" <> TempItemTrackLineInsert."Qty. to Handle (Base)") OR
                                       (TempItemTrackLineInsert."Quantity (Base)" <> TempItemTrackLineInsert."Qty. to Invoice (Base)")
                                    THEN
                                        SetQtyToHandleAndInvoice(TempItemTrackLineInsert);
                                END ELSE BEGIN
                                    RegisterChange(xTempItemTrackingLine, TempItemTrackLineModify, ChangeType::Modify, FALSE);
                                    SetQtyToHandleAndInvoice(TempItemTrackLineModify);
                                END;
                                TempItemTrackLineModify.DELETE();
                            END;
                        END ELSE BEGIN
                            i := i + 1;
                            TempItemTrackLineModify.DELETE();
                        END;
                        IF i MOD 100 = 0 THEN
                            Window.UPDATE(2, ROUND(i / NoOfLines * 10000, 1));
                    UNTIL TempItemTrackLineModify.NEXT() = 0;

            IF TempItemTrackLineInsert.FIND('-') THEN BEGIN
                REPEAT
                    i := i + 1;
                    IF i MOD 100 = 0 THEN
                        Window.UPDATE(2, ROUND(i / NoOfLines * 10000, 1));
                    IF TempItemTrackLineModify.GET(TempItemTrackLineInsert."Entry No.") THEN
                        TempItemTrackLineInsert.TRANSFERFIELDS(TempItemTrackLineModify);
                    IF NOT RegisterChange(TempItemTrackLineInsert, TempItemTrackLineInsert, ChangeType::Insert, FALSE) THEN
                        ERROR(Text005);
                    IF (TempItemTrackLineInsert."Quantity (Base)" <> TempItemTrackLineInsert."Qty. to Handle (Base)") OR
                       (TempItemTrackLineInsert."Quantity (Base)" <> TempItemTrackLineInsert."Qty. to Invoice (Base)")
                    THEN
                        SetQtyToHandleAndInvoice(TempItemTrackLineInsert);
                UNTIL TempItemTrackLineInsert.NEXT() = 0;
                TempItemTrackLineInsert.DELETEALL();
            END;
            Window.CLOSE();

        END ELSE BEGIN

            TempReservEntry.LOCKTABLE();
            IF NOT TempRecIsValid() THEN
                ERROR(Text007);

            IF Item."Order Tracking Policy" = Item."Order Tracking Policy"::None THEN
                QtyToAddAsBlank := 0
            ELSE
                QtyToAddAsBlank := UndefinedQtyArray[1] * CurrentSignFactor;

            Rec.RESET();
            Rec.SETFILTER("Buffer Status", '<>%1', 0);
            Rec.DELETEALL();
            Rec.RESET();

            xTempItemTrackingLine.RESET();
            Rec.SETCURRENTKEY("Entry No.");
            xTempItemTrackingLine.SETCURRENTKEY("Entry No.");
            IF xTempItemTrackingLine.FIND('-') THEN
                REPEAT
                    Rec.SETRANGE("Lot No.", xTempItemTrackingLine."Lot No.");
                    Rec.SETRANGE("Serial No.", xTempItemTrackingLine."Serial No.");
                    IF Rec.FIND('-') THEN BEGIN
                        IF RegisterChange(xTempItemTrackingLine, Rec, ChangeType::Modify, FALSE) THEN BEGIN
                            EntryNo := xTempItemTrackingLine."Entry No.";
                            xTempItemTrackingLine := Rec;
                            xTempItemTrackingLine."Entry No." := EntryNo;
                            xTempItemTrackingLine.MODIFY();
                        END;
                        SetQtyToHandleAndInvoice(Rec);
                        Rec.DELETE();
                    END ELSE BEGIN
                        RegisterChange(xTempItemTrackingLine, xTempItemTrackingLine, ChangeType::Delete, FALSE);
                        xTempItemTrackingLine.DELETE();
                    END;
                UNTIL xTempItemTrackingLine.NEXT() = 0;

            Rec.RESET();

            IF Rec.FIND('-') THEN
                REPEAT
                    IF RegisterChange(Rec, Rec, ChangeType::Insert, FALSE) THEN BEGIN
                        xTempItemTrackingLine := Rec;
                        xTempItemTrackingLine.INSERT();
                    END ELSE
                        ERROR(Text005);
                    SetQtyToHandleAndInvoice(Rec);
                    Rec.DELETE();
                UNTIL Rec.NEXT() = 0;

        END;

        UpdateOrderTracking();
        ReestablishReservations(); // Late Binding

        IF NOT BlockCommit THEN
            COMMIT();
    end;

    local procedure RegisterChange(var OldTrackingSpecification: Record "Tracking Specification"; var NewTrackingSpecification: Record "Tracking Specification"; ChangeType: Option Insert,Modify,FullDelete,PartDelete,ModifyAll; ModifySharedFields: Boolean) OK: Boolean
    var
        ReservEntry1: Record "Reservation Entry";
        ReservEntry2: Record "Reservation Entry";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        ReservationMgt: Codeunit "Reservation Management";
        IdenticalArray: array[2] of Boolean;
        // AvailabilityDate: Date;
        LostReservQty: Decimal;
        QtyToAdd: Decimal;
    begin
        OK := FALSE;
        SetPick(IsPick);

        IF (CurrentSignFactor * NewTrackingSpecification."Qty. to Handle") < 0 THEN
            NewTrackingSpecification."Expiration Date" := 0D;

        CASE ChangeType OF
            ChangeType::Insert:
                BEGIN
                    IF (OldTrackingSpecification."Quantity (Base)" = 0) OR
                       ((OldTrackingSpecification."Lot No." = '') AND
                        (OldTrackingSpecification."Serial No." = ''))
                    THEN
                        EXIT(TRUE);
                    TempReservEntry.SETRANGE("Serial No.", '');
                    TempReservEntry.SETRANGE("Lot No.", '');
                    OldTrackingSpecification."Quantity (Base)" :=
                      CurrentSignFactor *
                      ReservEngineMgt.AddItemTrackingToTempRecSet(
                        TempReservEntry, NewTrackingSpecification,
                        CurrentSignFactor * OldTrackingSpecification."Quantity (Base)", QtyToAddAsBlank,
                        ItemTrackingCode);
                    TempReservEntry.SETRANGE("Serial No.");
                    TempReservEntry.SETRANGE("Lot No.");

                    // Late Binding
                    IF ReservEngineMgt.RetrieveLostReservQty(LostReservQty) THEN BEGIN
                        TempItemTrackLineReserv := NewTrackingSpecification;
                        TempItemTrackLineReserv."Quantity (Base)" := LostReservQty * CurrentSignFactor;
                        TempItemTrackLineReserv.INSERT();
                    END;

                    IF OldTrackingSpecification."Quantity (Base)" = 0 THEN
                        EXIT(TRUE);

                    IF FormRunMode = FormRunMode::Reclass THEN BEGIN
                        CreateReservEntry.SetNewSerialLotNo(
                          OldTrackingSpecification."New Serial No.", OldTrackingSpecification."New Lot No.");
                        CreateReservEntry.SetNewExpirationDate(OldTrackingSpecification."New Expiration Date");
                    END;
                    CreateReservEntry.SetDates(
                      NewTrackingSpecification."Warranty Date", NewTrackingSpecification."Expiration Date");
                    CreateReservEntry.SetApplyFromEntryNo(
                      NewTrackingSpecification."Appl.-from Item Entry");
                    CreateReservEntry.CreateReservEntryFor(
                      OldTrackingSpecification."Source Type",
                      OldTrackingSpecification."Source Subtype",
                      OldTrackingSpecification."Source ID",
                      OldTrackingSpecification."Source Batch Name",
                      OldTrackingSpecification."Source Prod. Order Line",
                      OldTrackingSpecification."Source Ref. No.",
                      OldTrackingSpecification."Qty. per Unit of Measure",
                      OldTrackingSpecification."Quantity (Base)",
                      OldTrackingSpecification."Qty. to Handle (Base)",
                      ReservEntry1);
                    CreateReservEntry.CreateEntry(OldTrackingSpecification."Item No.",
                      OldTrackingSpecification."Variant Code",
                      OldTrackingSpecification."Location Code",
                      OldTrackingSpecification.Description,
                      ExpectedReceiptDate,
                      ShipmentDate, 0, CurrentEntryStatus);
                    CreateReservEntry.GetLastEntry(ReservEntry1);
                    IF Item."Order Tracking Policy" = Item."Order Tracking Policy"::"Tracking & Action Msg." THEN
                        ReservEngineMgt.UpdateActionMessages(ReservEntry1);

                    IF ModifySharedFields THEN BEGIN
                        ReservEntry1.SetPointerFilter();
                        ReservEntry1.SETRANGE("Lot No.", ReservEntry1."Lot No.");
                        ReservEntry1.SETRANGE("Serial No.", ReservEntry1."Serial No.");
                        ReservEntry1.SETFILTER("Entry No.", '<>%1', ReservEntry1."Entry No.");
                        ModifyFieldsWithinFilter(ReservEntry1, NewTrackingSpecification);
                    END;

                    // IF CurrentSignFactor < 0 THEN
                    //     AvailabilityDate := ShipmentDate
                    // ELSE
                    //     AvailabilityDate := ExpectedReceiptDate;
                    OK := TRUE;
                END;
            ChangeType::Modify:
                BEGIN
                    ReservEntry1.TRANSFERFIELDS(OldTrackingSpecification);
                    ReservEntry2.TRANSFERFIELDS(NewTrackingSpecification);

                    ReservEntry1."Entry No." := ReservEntry2."Entry No."; // If only entry no. has changed it should not trigger
                    IF EntriesAreIdentical(ReservEntry1, ReservEntry2, IdenticalArray) THEN
                        EXIT(QtyToHandleAndInvoiceChanged(ReservEntry1, ReservEntry2));

                    IF ABS(OldTrackingSpecification."Quantity (Base)") < ABS(NewTrackingSpecification."Quantity (Base)") THEN BEGIN
                        // Item Tracking is added to any blank reservation entries:
                        TempReservEntry.SETRANGE("Serial No.", '');
                        TempReservEntry.SETRANGE("Lot No.", '');
                        QtyToAdd :=
                          CurrentSignFactor *
                          ReservEngineMgt.AddItemTrackingToTempRecSet(
                            TempReservEntry, NewTrackingSpecification,
                            CurrentSignFactor * (NewTrackingSpecification."Quantity (Base)" -
                            OldTrackingSpecification."Quantity (Base)"), QtyToAddAsBlank
                            , ItemTrackingCode);
                        TempReservEntry.SETRANGE("Serial No.");
                        TempReservEntry.SETRANGE("Lot No.");

                        // Late Binding
                        IF ReservEngineMgt.RetrieveLostReservQty(LostReservQty) THEN BEGIN
                            TempItemTrackLineReserv := NewTrackingSpecification;
                            TempItemTrackLineReserv."Quantity (Base)" := LostReservQty * CurrentSignFactor;
                            TempItemTrackLineReserv.INSERT();
                        END;

                        OldTrackingSpecification."Quantity (Base)" := QtyToAdd;
                        OldTrackingSpecification."Warranty Date" := NewTrackingSpecification."Warranty Date";
                        OldTrackingSpecification."Expiration Date" := NewTrackingSpecification."Expiration Date";
                        OldTrackingSpecification.Description := NewTrackingSpecification.Description;
                        RegisterChange(OldTrackingSpecification, OldTrackingSpecification,
                          ChangeType::Insert, NOT IdenticalArray[2]);
                    END ELSE BEGIN
                        TempReservEntry.SETRANGE("Serial No.", OldTrackingSpecification."Serial No.");
                        TempReservEntry.SETRANGE("Lot No.", OldTrackingSpecification."Lot No.");
                        OldTrackingSpecification."Serial No." := '';
                        OldTrackingSpecification."Lot No." := '';
                        OldTrackingSpecification."Warranty Date" := 0D;
                        OldTrackingSpecification."Expiration Date" := 0D;
                        QtyToAdd :=
                          CurrentSignFactor *
                          ReservEngineMgt.AddItemTrackingToTempRecSet(
                            TempReservEntry, OldTrackingSpecification,
                            CurrentSignFactor * (OldTrackingSpecification."Quantity (Base)" -
                            NewTrackingSpecification."Quantity (Base)"), QtyToAddAsBlank,
                            ItemTrackingCode);
                        TempReservEntry.SETRANGE("Serial No.");
                        TempReservEntry.SETRANGE("Lot No.");
                        RegisterChange(NewTrackingSpecification, NewTrackingSpecification,
                          ChangeType::PartDelete, NOT IdenticalArray[2]);
                    END;
                    OK := TRUE;
                END;
            ChangeType::FullDelete, ChangeType::PartDelete:
                BEGIN
                    ReservationMgt.SetItemTrackingHandling(1); // Allow deletion of Item Tracking
                    ReservEntry1.TRANSFERFIELDS(OldTrackingSpecification);
                    ReservEntry1.SetPointerFilter();
                    ReservEntry1.SETRANGE("Lot No.", ReservEntry1."Lot No.");
                    ReservEntry1.SETRANGE("Serial No.", ReservEntry1."Serial No.");
                    IF ChangeType = ChangeType::FullDelete THEN BEGIN
                        TempReservEntry.SETRANGE("Serial No.", OldTrackingSpecification."Serial No.");
                        TempReservEntry.SETRANGE("Lot No.", OldTrackingSpecification."Lot No.");
                        OldTrackingSpecification."Serial No." := '';
                        OldTrackingSpecification."Lot No." := '';
                        OldTrackingSpecification."Warranty Date" := 0D;
                        OldTrackingSpecification."Expiration Date" := 0D;
                        QtyToAdd :=
                          CurrentSignFactor *
                          ReservEngineMgt.AddItemTrackingToTempRecSet(
                            TempReservEntry, OldTrackingSpecification,
                            CurrentSignFactor * OldTrackingSpecification."Quantity (Base)", QtyToAddAsBlank,
                             ItemTrackingCode);
                        TempReservEntry.SETRANGE("Serial No.");
                        TempReservEntry.SETRANGE("Lot No.");
                        ReservationMgt.DeleteReservEntries(TRUE, 0, ReservEntry1)
                    END ELSE BEGIN
                        ReservationMgt.DeleteReservEntries(FALSE, ReservEntry1."Quantity (Base)" -
                          OldTrackingSpecification."Quantity Handled (Base)", ReservEntry1);
                        IF ModifySharedFields THEN BEGIN
                            ReservEntry1.SETRANGE("Reservation Status");
                            ModifyFieldsWithinFilter(ReservEntry1, OldTrackingSpecification);
                        END;
                    END;
                    OK := TRUE;
                END;
        END;
        SetQtyToHandleAndInvoice(NewTrackingSpecification);
    end;

    local procedure UpdateOrderTracking()
    var
        TempReservEntry: Record "Reservation Entry" temporary;
    begin
        IF NOT ReservEngineMgt.CollectAffectedSurplusEntries(TempReservEntry) THEN
            EXIT;
        IF Item."Order Tracking Policy" = Item."Order Tracking Policy"::None THEN
            EXIT;
        ReservEngineMgt.UpdateOrderTracking(TempReservEntry);
    end;


    procedure ModifyFieldsWithinFilter(var ReservEntry1: Record "Reservation Entry"; var TrackingSpecification: Record "Tracking Specification")
    begin
        // Used to ensure that field values that are common to a SN/Lot are copied to all entries.
        IF ReservEntry1.FIND('-') THEN
            REPEAT
                ReservEntry1.Description := TrackingSpecification.Description;
                ReservEntry1."Warranty Date" := TrackingSpecification."Warranty Date";
                ReservEntry1."Expiration Date" := TrackingSpecification."Expiration Date";
                ReservEntry1."New Serial No." := TrackingSpecification."New Serial No.";
                ReservEntry1."New Lot No." := TrackingSpecification."New Lot No.";
                ReservEntry1."New Expiration Date" := TrackingSpecification."New Expiration Date";
                ReservEntry1.MODIFY();
            UNTIL ReservEntry1.NEXT() = 0;
    end;

    local procedure SetQtyToHandleAndInvoice(TrackingSpecification: Record "Tracking Specification") OK: Boolean
    var
        ReservEntry1: Record "Reservation Entry";
        QtyAlreadyHandledToInvoice: Decimal;
        QtyToHandleThisLine: Decimal;
        QtyToInvoiceThisLine: Decimal;
        TotalQtyToHandle: Decimal;
        TotalQtyToInvoice: Decimal;
    begin
        IF IsCorrection THEN
            EXIT;
        OK := FALSE;

        TotalQtyToHandle := TrackingSpecification."Qty. to Handle (Base)" * CurrentSignFactor;
        TotalQtyToInvoice := TrackingSpecification."Qty. to Invoice (Base)" * CurrentSignFactor;

        IF ABS(TotalQtyToHandle) > ABS(TotalQtyToInvoice) THEN
            QtyAlreadyHandledToInvoice := 0
        ELSE
            QtyAlreadyHandledToInvoice := TotalQtyToInvoice - TotalQtyToHandle;

        ReservEntry1.TRANSFERFIELDS(TrackingSpecification);
        ReservEntry1.SetPointerFilter();
        ReservEntry1.SETRANGE("Lot No.", ReservEntry1."Lot No.");
        ReservEntry1.SETRANGE("Serial No.", ReservEntry1."Serial No.");
        IF (TrackingSpecification."Lot No." <> '') OR
           (TrackingSpecification."Serial No." <> '')
        THEN BEGIN
            ItemTrackingMgt.SetPointerFilter(TrackingSpecification);
            TrackingSpecification.SETRANGE("Lot No.", TrackingSpecification."Lot No.");
            TrackingSpecification.SETRANGE("Serial No.", TrackingSpecification."Serial No.");

            IF TrackingSpecification.FIND('-') THEN
                REPEAT
                    IF NOT TrackingSpecification.Correction THEN BEGIN
                        QtyToInvoiceThisLine :=
                          TrackingSpecification."Quantity Handled (Base)" - TrackingSpecification."Quantity Invoiced (Base)";
                        IF ABS(QtyToInvoiceThisLine) > ABS(TotalQtyToInvoice) THEN
                            QtyToInvoiceThisLine := TotalQtyToInvoice;

                        IF ABS(QtyToInvoiceThisLine) > ABS(QtyAlreadyHandledToInvoice) THEN BEGIN
                            QtyToInvoiceThisLine := QtyAlreadyHandledToInvoice;
                            QtyAlreadyHandledToInvoice := 0;
                        END ELSE
                            QtyAlreadyHandledToInvoice -= QtyToInvoiceThisLine;

                        IF TrackingSpecification."Qty. to Invoice (Base)" <> QtyToInvoiceThisLine THEN BEGIN
                            TrackingSpecification."Qty. to Invoice (Base)" := QtyToInvoiceThisLine;
                            TrackingSpecification.MODIFY();
                        END;

                        TotalQtyToInvoice -= QtyToInvoiceThisLine;
                    END;
                UNTIL (TrackingSpecification.NEXT() = 0);

            OK := ((TotalQtyToHandle = 0) AND (TotalQtyToInvoice = 0));
        END;

        IF TrackingSpecification."Lot No." <> '' THEN BEGIN
            FOR ReservEntry1."Reservation Status" := ReservEntry1."Reservation Status"::Reservation TO
              ReservEntry1."Reservation Status"::Prospect
            DO BEGIN
                ReservEntry1.SETRANGE("Reservation Status", ReservEntry1."Reservation Status");
                IF ReservEntry1.FIND('-') THEN
                    REPEAT
                        QtyToHandleThisLine := ReservEntry1."Quantity (Base)";
                        QtyToInvoiceThisLine := QtyToHandleThisLine;

                        IF ABS(QtyToHandleThisLine) > ABS(TotalQtyToHandle) THEN
                            QtyToHandleThisLine := TotalQtyToHandle;
                        IF ABS(QtyToInvoiceThisLine) > ABS(TotalQtyToInvoice) THEN
                            QtyToInvoiceThisLine := TotalQtyToInvoice;

                        IF (ReservEntry1."Qty. to Handle (Base)" <> QtyToHandleThisLine) OR
                           (ReservEntry1."Qty. to Invoice (Base)" <> QtyToInvoiceThisLine) AND NOT ReservEntry1.Correction
                        THEN BEGIN
                            ReservEntry1."Qty. to Handle (Base)" := QtyToHandleThisLine;
                            ReservEntry1."Qty. to Invoice (Base)" := QtyToInvoiceThisLine;
                            ReservEntry1.MODIFY();
                        END;

                        TotalQtyToHandle -= QtyToHandleThisLine;
                        TotalQtyToInvoice -= QtyToInvoiceThisLine;

                    UNTIL (ReservEntry1.NEXT() = 0);
            END;

            OK := ((TotalQtyToHandle = 0) AND (TotalQtyToInvoice = 0));
        END ELSE
            IF ReservEntry1.FIND('-') THEN
                IF (ReservEntry1."Qty. to Handle (Base)" <> TotalQtyToHandle) OR
                   (ReservEntry1."Qty. to Invoice (Base)" <> TotalQtyToInvoice) AND NOT ReservEntry1.Correction
                THEN BEGIN
                    ReservEntry1."Qty. to Handle (Base)" := TotalQtyToHandle;
                    ReservEntry1."Qty. to Invoice (Base)" := TotalQtyToInvoice;
                    ReservEntry1.MODIFY();
                END;
    end;

    local procedure CollectPostedTransferEntries(TrackingSpecification: Record "Tracking Specification"; var TempTrackingSpecification: Record "Tracking Specification" temporary)
    var
        ItemEntryRelation: Record "Item Entry Relation";
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        // Used for collecting information about posted Transfer Shipments from the created Item Ledger Entries.
        IF TrackingSpecification."Source Type" <> DATABASE::"Transfer Line" THEN
            EXIT;

        ItemEntryRelation.SETCURRENTKEY("Order No.", "Order Line No.");
        ItemEntryRelation.SETRANGE("Order No.", TrackingSpecification."Source ID");
        ItemEntryRelation.SETRANGE("Order Line No.", TrackingSpecification."Source Ref. No.");

        CASE TrackingSpecification."Source Subtype" OF
            0: // Outbound


                ItemEntryRelation.SETRANGE("Source Type", DATABASE::"Transfer Shipment Line");
            1: // Inbound


                ItemEntryRelation.SETRANGE("Source Type", DATABASE::"Transfer Receipt Line");
        END;

        IF ItemEntryRelation.FIND('-') THEN
            REPEAT
                ItemLedgerEntry.GET(ItemEntryRelation."Item Entry No.");
                TempTrackingSpecification := TrackingSpecification;
                TempTrackingSpecification."Entry No." := ItemLedgerEntry."Entry No.";
                TempTrackingSpecification."Item No." := ItemLedgerEntry."Item No.";
                TempTrackingSpecification."Serial No." := ItemLedgerEntry."Serial No.";
                TempTrackingSpecification."Lot No." := ItemLedgerEntry."Lot No.";
                TempTrackingSpecification."Quantity (Base)" := ItemLedgerEntry.Quantity;
                TempTrackingSpecification."Quantity Handled (Base)" := ItemLedgerEntry.Quantity;
                TempTrackingSpecification."Quantity Invoiced (Base)" := ItemLedgerEntry.Quantity;
                TempTrackingSpecification."Qty. per Unit of Measure" := ItemLedgerEntry."Qty. per Unit of Measure";
                TempTrackingSpecification.InitQtyToShip();
                TempTrackingSpecification.INSERT();
            UNTIL ItemEntryRelation.NEXT() = 0;
    end;

    local procedure CollectPostedOutputEntries(TrackingSpecification: Record "Tracking Specification"; var TempTrackingSpecification: Record "Tracking Specification" temporary)
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        BackwardFlushing: Boolean;
    begin
        // Used for collecting information about posted prod. order output from the created Item Ledger Entries.
        IF TrackingSpecification."Source Type" <> DATABASE::"Prod. Order Line" THEN
            EXIT;

        IF (TrackingSpecification."Source Type" = DATABASE::"Prod. Order Line") AND
           (TrackingSpecification."Source Subtype" = 3)
        THEN BEGIN
            ProdOrderRoutingLine.SETRANGE(Status, TrackingSpecification."Source Subtype");
            ProdOrderRoutingLine.SETRANGE("Prod. Order No.", TrackingSpecification."Source ID");
            ProdOrderRoutingLine.SETRANGE("Routing Reference No.", TrackingSpecification."Source Prod. Order Line");
            IF ProdOrderRoutingLine.FindLast() THEN
                BackwardFlushing :=
                  ProdOrderRoutingLine."Flushing Method" = ProdOrderRoutingLine."Flushing Method"::Backward;
        END;

        ItemLedgerEntry.SETCURRENTKEY("Order No.", "Order Line No.", "Entry Type");
        ItemLedgerEntry.SETRANGE("Order No.", TrackingSpecification."Source ID");
        ItemLedgerEntry.SETRANGE("Order Line No.", TrackingSpecification."Source Prod. Order Line");
        ItemLedgerEntry.SETRANGE("Entry Type", ItemLedgerEntry."Entry Type"::Output);

        IF ItemLedgerEntry.FIND('-') THEN
            REPEAT
                TempTrackingSpecification := TrackingSpecification;
                TempTrackingSpecification."Entry No." := ItemLedgerEntry."Entry No.";
                TempTrackingSpecification."Item No." := ItemLedgerEntry."Item No.";
                TempTrackingSpecification."Serial No." := ItemLedgerEntry."Serial No.";
                TempTrackingSpecification."Lot No." := ItemLedgerEntry."Lot No.";
                TempTrackingSpecification."Quantity (Base)" := ItemLedgerEntry.Quantity;
                TempTrackingSpecification."Quantity Handled (Base)" := ItemLedgerEntry.Quantity;
                TempTrackingSpecification."Quantity Invoiced (Base)" := ItemLedgerEntry.Quantity;
                TempTrackingSpecification."Qty. per Unit of Measure" := ItemLedgerEntry."Qty. per Unit of Measure";
                TempTrackingSpecification.InitQtyToShip();
                TempTrackingSpecification.INSERT();

                IF BackwardFlushing THEN BEGIN
                    SourceQuantityArray[1] += ItemLedgerEntry.Quantity;
                    SourceQuantityArray[2] += ItemLedgerEntry.Quantity;
                    SourceQuantityArray[3] += ItemLedgerEntry.Quantity;
                END;

            UNTIL ItemLedgerEntry.NEXT() = 0;
    end;

    local procedure ZeroLineExists() OK: Boolean
    var
        xTrackingSpec: Record "Tracking Specification";
    begin
        IF (Rec."Quantity (Base)" <> 0) OR (Rec."Serial No." <> '') OR (Rec."Lot No." <> '') THEN
            EXIT(FALSE);
        xTrackingSpec.COPY(Rec);
        Rec.RESET();
        Rec.SETRANGE("Quantity (Base)", 0);
        Rec.SETRANGE("Serial No.", '');
        Rec.SETRANGE("Lot No.", '');
        OK := NOT Rec.ISEMPTY;
        Rec.COPY(xTrackingSpec);
    end;


    procedure AssignSerialNo()
    var
        EnterQuantityToCreate: Page "Enter Quantity to Create";
        CreateLotNo: Boolean;
        QtyToCreate: Decimal;
        QtyToCreateInt: Integer;
    begin
        IF ZeroLineExists() THEN
            Rec.DELETE();

        QtyToCreate := UndefinedQtyArray[1] * QtySignFactor();
        IF QtyToCreate < 0 THEN
            QtyToCreate := 0;

        IF QtyToCreate MOD 1 <> 0 THEN
            ERROR(Text008);

        QtyToCreateInt := QtyToCreate;

        CLEAR(EnterQuantityToCreate);
        EnterQuantityToCreate.LOOKUPMODE := TRUE;
        EnterQuantityToCreate.SetFields(Rec."Item No.", Rec."Variant Code", QtyToCreate, FALSE);
        IF EnterQuantityToCreate.RUNMODAL() = ACTION::LookupOK THEN BEGIN
            EnterQuantityToCreate.GetFields(QtyToCreateInt, CreateLotNo);
            AssignSerialNoBatch(QtyToCreateInt, CreateLotNo);
        END;
    end;


    procedure AssignSerialNoBatch(QtyToCreate: Integer; CreateLotNo: Boolean)
    var
        i: Integer;
    begin
        IF QtyToCreate <= 0 THEN
            ERROR(Text009);
        IF QtyToCreate MOD 1 <> 0 THEN
            ERROR(Text008);

        GetItem(Rec."Item No.");

        IF CreateLotNo THEN BEGIN
            Rec.TESTFIELD("Lot No.", '');
            Item.TESTFIELD("Lot Nos.");
            Rec.VALIDATE("Lot No.", NoSeriesMgt.GetNextNo(Item."Lot Nos.", WORKDATE(), TRUE));
        END;

        Item.TESTFIELD("Serial Nos.");
        FOR i := 1 TO QtyToCreate DO BEGIN
            Rec.VALIDATE("Serial No.", NoSeriesMgt.GetNextNo(Item."Serial Nos.", WORKDATE(), TRUE));
            Rec.VALIDATE("Quantity (Base)", QtySignFactor());
            Rec."Entry No." := NextEntryNo();
            IF TestTempSpecificationExists() THEN
                ERROR('');
            Rec.INSERT();
            TempItemTrackLineInsert.TRANSFERFIELDS(Rec);
            TempItemTrackLineInsert.INSERT();
            ItemTrackingDataCollection.UpdateTrackingDataSetWithChange(
              TempItemTrackLineInsert, CurrentSignFactor * SourceQuantityArray[1] < 0, CurrentSignFactor, 0);
        END;
        CalculateSums();
    end;


    procedure AssignLotNo()
    var
        QtyToCreate: Decimal;
    begin
        IF ZeroLineExists() THEN
            Rec.DELETE();

        IF (SourceQuantityArray[1] * UndefinedQtyArray[1] <= 0) OR
           (ABS(SourceQuantityArray[1]) < ABS(UndefinedQtyArray[1]))
        THEN
            QtyToCreate := 0
        ELSE
            QtyToCreate := UndefinedQtyArray[1];

        GetItem(Rec."Item No.");

        Item.TESTFIELD("Lot Nos.");
        Rec.VALIDATE("Lot No.", NoSeriesMgt.GetNextNo(Item."Lot Nos.", WORKDATE(), TRUE));
        Rec."Qty. per Unit of Measure" := QtyPerUOM;
        Rec.VALIDATE("Quantity (Base)", QtyToCreate);
        Rec."Entry No." := NextEntryNo();
        TestTempSpecificationExists();
        Rec.INSERT();
        TempItemTrackLineInsert.TRANSFERFIELDS(Rec);
        TempItemTrackLineInsert.INSERT();
        ItemTrackingDataCollection.UpdateTrackingDataSetWithChange(
          TempItemTrackLineInsert, CurrentSignFactor * SourceQuantityArray[1] < 0, CurrentSignFactor, 0);
        CalculateSums();
    end;


    procedure CreateCustomizedSN()
    var
        EnterCustomizedSN: Page "Enter Customized SN";
        CreateLotNo: Boolean;
        CustomizedSN: Code[20];
        QtyToCreate: Decimal;
        Increment: Integer;
        QtyToCreateInt: Integer;
    begin
        IF ZeroLineExists() THEN
            Rec.DELETE();
        Rec.TESTFIELD("Quantity Handled (Base)", 0);
        Rec.TESTFIELD("Quantity Invoiced (Base)", 0);

        QtyToCreate := UndefinedQtyArray[1] * QtySignFactor();
        IF QtyToCreate < 0 THEN
            QtyToCreate := 0;

        IF QtyToCreate MOD 1 <> 0 THEN
            ERROR(Text008);

        QtyToCreateInt := QtyToCreate;

        CLEAR(EnterCustomizedSN);
        EnterCustomizedSN.LOOKUPMODE := TRUE;
        EnterCustomizedSN.SetFields(Rec."Item No.", Rec."Variant Code", QtyToCreate, FALSE);
        IF EnterCustomizedSN.RUNMODAL() = ACTION::LookupOK THEN BEGIN
            EnterCustomizedSN.GetFields(QtyToCreateInt, CreateLotNo, CustomizedSN, Increment);
            CreateCustomizedSNBatch(QtyToCreateInt, CreateLotNo, CustomizedSN, Increment);
        END;
        CalculateSums();
    end;


    procedure CreateCustomizedSNBatch(QtyToCreate: Decimal; CreateLotNo: Boolean; CustomizedSN: Code[20]; Increment: Integer)
    var
        Counter: Integer;
        i: Integer;
    begin
        IF INCSTR(CustomizedSN) = '' THEN
            ERROR(Text013, CustomizedSN);
        NoSeriesMgt.TestManual(Item."Serial Nos.");

        Rec.TESTFIELD("Quantity Handled (Base)", 0);
        Rec.TESTFIELD("Quantity Invoiced (Base)", 0);

        IF QtyToCreate <= 0 THEN
            ERROR(Text009);
        IF QtyToCreate MOD 1 <> 0 THEN
            ERROR(Text008);

        IF CreateLotNo THEN BEGIN
            Rec.TESTFIELD("Lot No.", '');
            Item.TESTFIELD("Lot Nos.");
            Rec.VALIDATE("Lot No.", NoSeriesMgt.GetNextNo(Item."Lot Nos.", WORKDATE(), TRUE));
        END;

        FOR i := 1 TO QtyToCreate DO BEGIN
            Rec.VALIDATE("Serial No.", CustomizedSN);
            Rec.VALIDATE("Quantity (Base)", QtySignFactor());
            Rec."Entry No." := NextEntryNo();
            IF TestTempSpecificationExists() THEN
                ERROR('');
            Rec.INSERT();
            TempItemTrackLineInsert.TRANSFERFIELDS(Rec);
            TempItemTrackLineInsert.INSERT();
            ItemTrackingDataCollection.UpdateTrackingDataSetWithChange(
              TempItemTrackLineInsert, CurrentSignFactor * SourceQuantityArray[1] < 0, CurrentSignFactor, 0);
            IF i < QtyToCreate THEN BEGIN
                Counter := Increment;
                REPEAT
                    CustomizedSN := INCSTR(CustomizedSN);
                    Counter := Counter - 1;
                UNTIL Counter <= 0;
            END;
        END;
        CalculateSums();
    end;


    procedure TestTempSpecificationExists() Exists: Boolean
    var
        TempSpecification: Record "Tracking Specification" temporary;
    begin
        TempSpecification.COPY(Rec);
        Rec.SETCURRENTKEY("Lot No.", "Serial No.");
        Rec.SETRANGE("Serial No.", Rec."Serial No.");
        IF Rec."Serial No." = '' THEN
            Rec.SETRANGE("Lot No.", Rec."Lot No.");
        Rec.SETFILTER("Entry No.", '<>%1', Rec."Entry No.");
        Rec.SETRANGE("Buffer Status", 0);
        Exists := NOT Rec.ISEMPTY;
        Rec.COPY(TempSpecification);
        IF Exists AND CurrentFormIsOpen THEN
            IF Rec."Serial No." = '' THEN
                MESSAGE(
                  Text011,
                  Rec.TABLECAPTION, Rec.FIELDCAPTION("Serial No."), Rec."Serial No.",
                  Rec.FIELDCAPTION("Lot No."), Rec."Lot No.")
            ELSE
                MESSAGE(
                  Text012,
                  Rec.TABLECAPTION, Rec.FIELDCAPTION("Serial No."), Rec."Serial No.");
    end;

    local procedure QtySignFactor(): Integer
    begin
        IF SourceQuantityArray[1] < 0 THEN
            EXIT(-1)
        ELSE
            EXIT(1)
    end;


    procedure RegisterItemTrackingLines(SourceSpecification: Record "Tracking Specification"; AvailabilityDate: Date; var TempSpecification: Record "Tracking Specification" temporary)
    begin
        SourceSpecification.TESTFIELD("Source Type"); // Check if source has been set.
        IF NOT CalledFromSynchWhseItemTrkg THEN
            TempSpecification.RESET();
        IF NOT TempSpecification.FIND('-') THEN
            EXIT;

        IsCorrection := SourceSpecification.Correction;
        SetSource(SourceSpecification, AvailabilityDate);
        Rec.RESET();
        Rec.SETCURRENTKEY("Lot No.", "Serial No.");

        REPEAT
            Rec.SETRANGE("Lot No.", TempSpecification."Lot No.");
            Rec.SETRANGE("Serial No.", TempSpecification."Serial No.");
            IF Rec.FIND('-') THEN BEGIN
                IF IsCorrection THEN BEGIN
                    Rec."Quantity (Base)" :=
                      Rec."Quantity (Base)" + TempSpecification."Quantity (Base)";
                    Rec."Qty. to Handle (Base)" :=
                      Rec."Qty. to Handle (Base)" + TempSpecification."Qty. to Handle (Base)";
                    Rec."Qty. to Invoice (Base)" :=
                      Rec."Qty. to Invoice (Base)" + TempSpecification."Qty. to Invoice (Base)";
                END ELSE
                    Rec.VALIDATE("Quantity (Base)",
                      Rec."Quantity (Base)" + TempSpecification."Quantity (Base)");
                Rec.MODIFY();
            END ELSE BEGIN
                Rec.TRANSFERFIELDS(SourceSpecification);
                Rec."Serial No." := TempSpecification."Serial No.";
                Rec."Lot No." := TempSpecification."Lot No.";
                Rec."Warranty Date" := TempSpecification."Warranty Date";
                Rec."Expiration Date" := TempSpecification."Expiration Date";
                IF FormRunMode = FormRunMode::Reclass THEN BEGIN
                    Rec."New Serial No." := TempSpecification."New Serial No.";
                    Rec."New Lot No." := TempSpecification."New Lot No.";
                    Rec."New Expiration Date" := TempSpecification."New Expiration Date"
                END;
                Rec.VALIDATE("Quantity (Base)", TempSpecification."Quantity (Base)");
                Rec."Entry No." := NextEntryNo();
                Rec.INSERT();
            END;
        UNTIL TempSpecification.NEXT() = 0;
        Rec.RESET();
        IF Rec.FIND('-') THEN
            REPEAT
                CheckLine(Rec);
            UNTIL Rec.NEXT() = 0;

        Rec.SETRANGE("Lot No.", SourceSpecification."Lot No.");
        Rec.SETRANGE("Serial No.", SourceSpecification."Serial No.");

        CalculateSums();
        IF UpdateUndefinedQty() THEN
            WriteToDatabase()
        ELSE
            ERROR(Text014, TotalItemTrackingLine."Quantity (Base)",
              LOWERCASE(TempReservEntry.TextCaption()), SourceQuantityArray[1]);

        // Copy to inbound part of transfer
        IF FormRunMode = FormRunMode::Transfer THEN
            SynchronizeLinkedSources('');
    end;


    procedure SynchronizeLinkedSources(DialogText: Text[250]): Boolean
    begin
        IF CurrentSourceRowID = '' THEN
            EXIT(FALSE);
        IF SecondSourceRowID = '' THEN
            EXIT(FALSE);

        ItemTrackingMgt.SynchronizeItemTracking(CurrentSourceRowID, SecondSourceRowID, DialogText);
        EXIT(TRUE);
    end;


    procedure SetBlockCommit(NewBlockCommit: Boolean)
    begin
        BlockCommit := NewBlockCommit;
    end;


    procedure TempItemTrackingDef(NewTrackingSpecification: Record "Tracking Specification")
    begin
        Rec := NewTrackingSpecification;
        Rec."Entry No." := NextEntryNo();
        IF (NOT InsertIsBlocked) AND (NOT ZeroLineExists()) THEN
            IF NOT TestTempSpecificationExists() THEN
                Rec.INSERT()
            ELSE
                ModifyTrackingSpecification(NewTrackingSpecification);
        WriteToDatabase();
    end;


    procedure SetCalledFromSynchWhseItemTrkg(CalledFromSynchWhseItemTrkg2: Boolean)
    begin
        CalledFromSynchWhseItemTrkg := CalledFromSynchWhseItemTrkg2;
    end;


    procedure ModifyTrackingSpecification(NewTrackingSpecification: Record "Tracking Specification")
    var
        CrntTempTrackingSpec: Record "Tracking Specification" temporary;
    begin
        CrntTempTrackingSpec.COPY(Rec);
        Rec.SETCURRENTKEY("Lot No.", "Serial No.");
        Rec.SETRANGE("Lot No.", NewTrackingSpecification."Lot No.");
        Rec.SETRANGE("Serial No.", NewTrackingSpecification."Serial No.");
        Rec.SETFILTER("Entry No.", '<>%1', Rec."Entry No.");
        Rec.SETRANGE("Buffer Status", 0);
        IF Rec.FIND('-') THEN BEGIN
            Rec.VALIDATE("Quantity (Base)",
              Rec."Quantity (Base)" + NewTrackingSpecification."Quantity (Base)");
            Rec.MODIFY();
        END;
        Rec.COPY(CrntTempTrackingSpec);
    end;


    procedure LookupAvailable(LookupMode: Enum "Item Tracking Type")
    VAR
        LPSAFunctionsMgt: Codeunit "PWD LPSA Functions Mgt.";
    begin
        Rec."Bin Code" := ForBinCode;
        LPSAFunctionsMgt.ShouldExitLookupTrackingAvailability(Rec, LookupMode);
        Rec."Bin Code" := '';
    end;


    procedure F6LookupAvailable()
    var
        LookupMode: Enum "Item Tracking Type";
    begin
        IF SNAvailabilityActive THEN
            LookupAvailable(LookupMode::"Serial No.");
        IF LotAvailabilityActive THEN
            LookupAvailable(LookupMode::"Lot No.");
    end;


    procedure LotSnAvailable(var TrackingSpecification: Record "Tracking Specification"; LookupMode: Enum "Item Tracking Type"): Boolean
    VAR
        LPSAFunctionsMgt: Codeunit "PWD LPSA Functions Mgt.";
    begin
        EXIT(LPSAFunctionsMgt.ShouldExitLookupTrackingAvailability(TrackingSpecification, LookupMode));
    end;


    procedure SelectEntries()
    var
        xTrackingSpec: Record "Tracking Specification";
        MaxQuantity: Decimal;
    begin
        xTrackingSpec.COPYFILTERS(Rec);
        MaxQuantity := UndefinedQtyArray[1];
        IF MaxQuantity * CurrentSignFactor > 0 THEN
            MaxQuantity := 0;
        Rec."Bin Code" := ForBinCode;
        ItemTrackingDataCollection.SelectMultipleTrackingNo(Rec, MaxQuantity, CurrentSignFactor);
        Rec."Bin Code" := '';
        IF Rec.FINDSET() THEN
            REPEAT
                CASE Rec."Buffer Status" OF
                    Rec."Buffer Status"::MODIFY:
                        BEGIN
                            IF TempItemTrackLineModify.GET(Rec."Entry No.") THEN
                                TempItemTrackLineModify.DELETE();
                            IF TempItemTrackLineInsert.GET(Rec."Entry No.") THEN BEGIN
                                TempItemTrackLineInsert.TRANSFERFIELDS(Rec);
                                TempItemTrackLineInsert.MODIFY();
                            END ELSE BEGIN
                                TempItemTrackLineModify.TRANSFERFIELDS(Rec);
                                TempItemTrackLineModify.INSERT();
                            END;
                        END;
                    Rec."Buffer Status"::INSERT:
                        BEGIN
                            TempItemTrackLineInsert.TRANSFERFIELDS(Rec);
                            TempItemTrackLineInsert.INSERT();
                        END;
                END;
                Rec."Buffer Status" := 0;
                Rec.MODIFY();
            UNTIL Rec.NEXT() = 0;
        LastEntryNo := Rec."Entry No.";
        CalculateSums();
        UpdateUndefinedQty();
        Rec.COPYFILTERS(xTrackingSpec);
    end;


    procedure ReserveItemTrackingLine()
    var
        LateBindingMgt: Codeunit "Late Binding Management";
    begin
        LateBindingMgt.ReserveItemTrackingLine(Rec);
    end;


    procedure ReestablishReservations()
    var
        LateBindingMgt: Codeunit "Late Binding Management";
    begin
        IF TempItemTrackLineReserv.FINDSET() THEN
            REPEAT
                LateBindingMgt.ReserveItemTrackingLine(TempItemTrackLineReserv);
                SetQtyToHandleAndInvoice(TempItemTrackLineReserv);
            UNTIL TempItemTrackLineReserv.NEXT() = 0;
        TempItemTrackLineReserv.DELETEALL();
    end;


    procedure SetInbound(NewInbound: Boolean)
    begin
        Inbound := NewInbound;
    end;


    procedure SetPick(IsPick2: Boolean)
    begin
        IsPick := IsPick2;
    end;


    // procedure SetWhseReceiptLine(FromWhseReceiptLine: Record "Warehouse Receipt Line")
    // begin
    //     WhseReceiptLineNC := FromWhseReceiptLine;
    //     SourceTable := DATABASE::"Warehouse Receipt Line";
    // end;


    procedure SetPurchLine(FromPurchLine: Record "Purchase Line")
    begin
        PurchLineNC := FromPurchLine;
        SourceTable := DATABASE::"Purchase Line";
    end;


    procedure SetWhseShptLine(FromWhseShptLine: Record "Warehouse Shipment Line")
    begin
        WhseShptLineNC := FromWhseShptLine;
        SourceTable := DATABASE::"Warehouse Shipment Line";
    end;


    procedure SetSalesLine(FromSalesLine: Record "Sales Line")
    begin
        SalesLineNC := FromSalesLine;
        SourceTable := DATABASE::"Sales Line";
    end;


    procedure SetTransferLine(FromTransferLine: Record "Transfer Line"; FromDirection: Option Outbound,Inbound)
    begin
        TransferLineNC := FromTransferLine;
        DirectionNC := FromDirection;
        SourceTable := DATABASE::"Transfer Line";
    end;


    procedure SetCurrentFormIsOpen(PCurrentFormIsOpen: Boolean)
    begin
        CurrentFormIsOpen := PCurrentFormIsOpen;
    end;

    procedure GetTrackingSpecification(var RecPTrackingSpecificationTemp: Record "Tracking Specification" temporary)
    begin
        //>>OSYS-Int001.001
        IF NOT Rec.ISEMPTY THEN BEGIN
            Rec.FINDSET();

            REPEAT
                RecPTrackingSpecificationTemp.INIT();
                RecPTrackingSpecificationTemp.TRANSFERFIELDS(Rec);
                RecPTrackingSpecificationTemp.INSERT();
            UNTIL Rec.NEXT() = 0;
        END;
        //<<OSYS-Int001.001
    end;


    procedure GetPostedItemTrackingProdOrder(var RecPTrackingSpecificationTemp: Record "Tracking Specification" temporary; var IntPIncrement: Integer; Type: Integer; ID: Code[20]; ProdOrderLine: Integer; RefNo: Integer)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        //>>OSYS-Int001.001
        // Used when calling Item Tracking from finished prod. order and component:
        ItemLedgEntry.SETCURRENTKEY("Order No.", "Order Line No.",
          "Entry Type", "Prod. Order Comp. Line No.");

        ItemLedgEntry.SETRANGE("Order No.", ID);
        ItemLedgEntry.SETRANGE("Order Line No.", ProdOrderLine);

        CASE Type OF
            DATABASE::"Prod. Order Line":
                BEGIN
                    ItemLedgEntry.SETRANGE("Entry Type", ItemLedgEntry."Entry Type"::Output);
                    ItemLedgEntry.SETRANGE("Prod. Order Comp. Line No.", 0);
                END;
            DATABASE::"Prod. Order Component":
                BEGIN
                    ItemLedgEntry.SETRANGE("Entry Type", ItemLedgEntry."Entry Type"::Consumption);
                    ItemLedgEntry.SETRANGE("Prod. Order Comp. Line No.", RefNo);
                END;
        END;

        IF NOT ItemLedgEntry.ISEMPTY THEN BEGIN
            ItemLedgEntry.FINDSET();
            REPEAT
                IntPIncrement += 1;

                IF (ItemLedgEntry."Serial No." <> '') OR (ItemLedgEntry."Lot No." <> '') THEN BEGIN
                    RecPTrackingSpecificationTemp.INIT();
                    RecPTrackingSpecificationTemp."Entry No." := IntPIncrement;
                    RecPTrackingSpecificationTemp."Item No." := ItemLedgEntry."Item No.";
                    RecPTrackingSpecificationTemp."Location Code" := ItemLedgEntry."Location Code";
                    RecPTrackingSpecificationTemp."Quantity (Base)" := ItemLedgEntry.Quantity;
                    RecPTrackingSpecificationTemp.Description := ItemLedgEntry.Description;
                    RecPTrackingSpecificationTemp."Creation Date" := ItemLedgEntry."Posting Date";
                    RecPTrackingSpecificationTemp."Source Subtype" := 4;
                    RecPTrackingSpecificationTemp."Source ID" := ID;
                    RecPTrackingSpecificationTemp."Source Prod. Order Line" := ProdOrderLine;
                    RecPTrackingSpecificationTemp."Source Ref. No." := RefNo;
                    RecPTrackingSpecificationTemp."Serial No." := ItemLedgEntry."Serial No.";
                    RecPTrackingSpecificationTemp."Lot No." := ItemLedgEntry."Lot No.";
                    RecPTrackingSpecificationTemp."Variant Code" := ItemLedgEntry."Variant Code";
                    RecPTrackingSpecificationTemp.INSERT();
                END
            UNTIL ItemLedgEntry.NEXT() = 0;
        END;
        //<<OSYS-Int001.001
    end;


    procedure FctInitTrackingSpecification(var RecPProdOrderLine: Record "Prod. Order Line"; var RecPTrackingSpecification: Record "Tracking Specification")
    begin
        RecPTrackingSpecification.INIT();
        RecPTrackingSpecification."Source Type" := DATABASE::"Prod. Order Line";
        RecPTrackingSpecification."Item No." := RecPProdOrderLine."Item No.";
        RecPTrackingSpecification."Location Code" := RecPProdOrderLine."Location Code";
        RecPTrackingSpecification.Description := RecPProdOrderLine.Description;
        RecPTrackingSpecification."Variant Code" := RecPProdOrderLine."Variant Code";
        RecPTrackingSpecification."Source Subtype" := RecPProdOrderLine.Status.AsInteger();
        RecPTrackingSpecification."Source ID" := RecPProdOrderLine."Prod. Order No.";
        RecPTrackingSpecification."Source Batch Name" := '';
        RecPTrackingSpecification."Source Prod. Order Line" := RecPProdOrderLine."Line No.";
        RecPTrackingSpecification."Source Ref. No." := 0;
        RecPTrackingSpecification."Quantity (Base)" := RecPProdOrderLine."Quantity (Base)";
        RecPTrackingSpecification."Qty. to Handle" := RecPProdOrderLine."Remaining Quantity";
        RecPTrackingSpecification."Qty. to Handle (Base)" := RecPProdOrderLine."Remaining Qty. (Base)";
        RecPTrackingSpecification."Qty. to Invoice" := RecPProdOrderLine."Remaining Quantity";
        RecPTrackingSpecification."Qty. to Invoice (Base)" := RecPProdOrderLine."Remaining Qty. (Base)";
        RecPTrackingSpecification."Quantity Handled (Base)" := RecPProdOrderLine."Finished Qty. (Base)";
        RecPTrackingSpecification."Quantity Invoiced (Base)" := RecPProdOrderLine."Finished Qty. (Base)";
        RecPTrackingSpecification."Qty. per Unit of Measure" := RecPProdOrderLine."Qty. per Unit of Measure";
    end;


    procedure FctInitTrackingSpecifComponent(var RecPProdOrderComponent: Record "Prod. Order Component"; var RecPTrackingSpecification: Record "Tracking Specification")
    begin
        RecPTrackingSpecification.INIT();
        RecPTrackingSpecification."Source Type" := DATABASE::"Prod. Order Component";
        RecPTrackingSpecification."Item No." := RecPProdOrderComponent."Item No.";
        RecPTrackingSpecification."Location Code" := RecPProdOrderComponent."Location Code";
        RecPTrackingSpecification.Description := RecPProdOrderComponent.Description;
        RecPTrackingSpecification."Variant Code" := RecPProdOrderComponent."Variant Code";
        RecPTrackingSpecification."Source Subtype" := RecPProdOrderComponent.Status.AsInteger();
        RecPTrackingSpecification."Source ID" := RecPProdOrderComponent."Prod. Order No.";
        RecPTrackingSpecification."Source Batch Name" := '';
        RecPTrackingSpecification."Source Prod. Order Line" := RecPProdOrderComponent."Prod. Order Line No.";
        RecPTrackingSpecification."Source Ref. No." := RecPProdOrderComponent."Line No.";
        RecPTrackingSpecification."Quantity (Base)" := RecPProdOrderComponent."Quantity (Base)";
        RecPTrackingSpecification."Qty. to Handle" := RecPProdOrderComponent."Remaining Quantity";
        RecPTrackingSpecification."Qty. to Handle (Base)" := RecPProdOrderComponent."Remaining Qty. (Base)";
        RecPTrackingSpecification."Qty. to Invoice" := RecPProdOrderComponent."Remaining Quantity";
        RecPTrackingSpecification."Qty. to Invoice (Base)" := RecPProdOrderComponent."Remaining Qty. (Base)";
        RecPTrackingSpecification."Qty. per Unit of Measure" := RecPProdOrderComponent."Qty. per Unit of Measure";
    end;
}

