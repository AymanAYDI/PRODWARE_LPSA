codeunit 50098 "PWD RDD - Tracking Management"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>RDD1.00
    // INTEGRATION.001:PA 13/10/2010 Intégration des données ECRITURES
    //                               -Creation
    // 
    // INTEGRATION.002:PA 20/10/2010 Intégration des données ECRITURES
    //                               -Add function InsertLine2()
    // ------------------------------------------------------------------------------------------------------------------


    trigger OnRun()
    begin
    end;

    var
        xTempItemTrackingLine: Record "Tracking Specification" temporary;
        TotalItemTrackingLine: Record "Tracking Specification";
        TempItemTrackLineInsert: Record "Tracking Specification" temporary;
        TempItemTrackLineModify: Record "Tracking Specification" temporary;
        TempItemTrackLineDelete: Record "Tracking Specification" temporary;
        TempItemTrackLineReserv: Record "Tracking Specification" temporary;
        Item: Record Item;
        ItemTrackingCode: Record "Item Tracking Code";
        TempReservEntry: Record "Reservation Entry" temporary;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        ItemTrackingDataCollection: Codeunit "Item Tracking Data Collection";
        UndefinedQtyArray: array[3] of Decimal;
        SourceQuantityArray: array[5] of Decimal;
        QtyPerUOM: Decimal;
        QtyToAddAsBlank: Decimal;
        CurrentSteps: Integer;
        CurrentSignFactor: Integer;
        LastEntryNo: Integer;
        ColorOfQuantityArray: array[3] of Integer;
        CurrentSourceType: Integer;
        ExpectedReceiptDate: Date;
        ShipmentDate: Date;
        CurrentEntryStatus: Option Reservation,Tracking,Surplus,Prospect;
        FormRunMode: Option ,Reclass,"Combined Ship/Rcpt","Drop Shipment",Transfer,,,,,Countermark;
        InsertIsBlocked: Boolean;
        DeleteIsBlocked: Boolean;
        BlockCommit: Boolean;
        IsCorrection: Boolean;
        MoveBinContent: Boolean;
        CurrentFormIsOpen: Boolean;
        CalledFromSynchWhseItemTrkg: Boolean;
        SNAvailabilityActive: Boolean;
        LotAvailabilityActive: Boolean;
        Inbound: Boolean;
        CurrentSourceCaption: Text[255];
        CurrentSourceRowID: Text[100];
        SecondSourceRowID: Text[100];
        ForBinCode: Code[20];
        rec: Record "Tracking Specification" temporary;
        Text000: Label 'Reservation is defined for the %1.\You must cancel the existing Reservation before deleting or changing Item Tracking.';
        Text001: Label 'Reservation is defined for the %1.\You must not set %2 lower then %3.';
        Text002: Label 'Quantity must be %1.';
        Text003: Label 'negative';
        Text004: Label 'positive';
        Text005: Label 'Error when writing to database.';
        Text006: Label 'The corrections cannot be saved as excess quantity has been defined.\Close the form anyway?';
        Text007: Label 'Another user has modified the item tracking data since it was retrieved from the database.\Start again.';
        Text008: Label 'The quantity to create must be an integer.';
        Text009: Label 'The quantity to create must be positive.';
        Text011: Label '%1 already exists with %2 %3 and %4 %5.';
        Text012: Label '%1 already exists with %2 %3.';
        Text013: Label 'The string %1 contains no number and cannot be incremented.';
        Text014: Label 'The total item tracking quantity %1 exceeds the %2 quantity %3.\The changes cannot be saved to the database.';
        Text015: Label 'Do you want to synchronize item tracking on the line with item tracking on the related drop shipment %1?';
        Text016: Label 'purchase order line';
        Text017: Label 'sales order line';
        Text018: Label 'Saving item tracking line changes';
        Text019: Label 'There are availability warnings on one or more lines.\Close the form anyway?';
        xrec: Record "Tracking Specification" temporary;


    procedure SetFormRunMode(Mode: Option ,Reclass,"Combined Ship/Rcpt","Drop Shipment",,,,,Countermark)
    begin
        FormRunMode := Mode;
        CurrentFormIsOpen := true;
    end;


    procedure SetSource(TrackingSpecification: Record "Tracking Specification"; AvailabilityDate: Date)
    var
        ReservEntry: Record "Reservation Entry";
        TempTrackingSpecification: Record "Tracking Specification" temporary;
        TempTrackingSpecification2: Record "Tracking Specification" temporary;
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        Controls: Option Handle,Invoice,Quantity,Reclass,LotSN;
    begin
        GetItem(TrackingSpecification."Item No.");
        ForBinCode := TrackingSpecification."Bin Code";
        SetFilters(TrackingSpecification);
        TempTrackingSpecification.DeleteAll;
        TempItemTrackLineInsert.DeleteAll;
        TempItemTrackLineModify.DeleteAll;
        TempItemTrackLineDelete.DeleteAll;

        TempReservEntry.DeleteAll;
        LastEntryNo := 0;

        if ItemTrackingMgt.IsOrderNetworkEntity(TrackingSpecification."Source Type",
          TrackingSpecification."Source Subtype") and not (FormRunMode = FormRunMode::"Drop Shipment")
        then
            CurrentEntryStatus := CurrentEntryStatus::Surplus
        else
            CurrentEntryStatus := CurrentEntryStatus::Prospect;


        if FormRunMode = FormRunMode::"Combined Ship/Rcpt" then;
        //SetControls(Controls::LotSN,FALSE);
        if ItemTrackingMgt.ItemTrkgIsManagedByWhse(
          TrackingSpecification."Source Type",
          TrackingSpecification."Source Subtype",
          TrackingSpecification."Source ID",
          TrackingSpecification."Source Prod. Order Line",
          TrackingSpecification."Source Ref. No.",
          TrackingSpecification."Location Code",
          TrackingSpecification."Item No.")
        then begin
            //SetControls(Controls::Quantity,FALSE);
            //CurrForm."Qty. to Handle (Base)".EDITABLE(FALSE);
            DeleteIsBlocked := true;
        end;

        ReservEntry."Source Type" := TrackingSpecification."Source Type";
        ReservEntry."Source Subtype" := TrackingSpecification."Source Subtype";
        CurrentSignFactor := CreateReservEntry.SignFactor(ReservEntry);
        CurrentSourceCaption := ReservEntry.TextCaption;
        CurrentSourceType := ReservEntry."Source Type";

        if CurrentSignFactor < 0 then begin
            ExpectedReceiptDate := 0D;
            ShipmentDate := AvailabilityDate;
        end else begin
            ExpectedReceiptDate := AvailabilityDate;
            ShipmentDate := 0D;
        end;

        SourceQuantityArray[1] := TrackingSpecification."Quantity (Base)";
        SourceQuantityArray[2] := TrackingSpecification."Qty. to Handle (Base)";
        SourceQuantityArray[3] := TrackingSpecification."Qty. to Invoice (Base)";
        SourceQuantityArray[4] := TrackingSpecification."Quantity Handled (Base)";
        SourceQuantityArray[5] := TrackingSpecification."Quantity Invoiced (Base)";
        QtyPerUOM := TrackingSpecification."Qty. per Unit of Measure";

        ReservEntry.SetCurrentKey(
          "Source ID", "Source Ref. No.", "Source Type", "Source Subtype",
          "Source Batch Name", "Source Prod. Order Line", "Reservation Status");

        ReservEntry.SetRange("Source ID", TrackingSpecification."Source ID");
        ReservEntry.SetRange("Source Ref. No.", TrackingSpecification."Source Ref. No.");
        ReservEntry.SetRange("Source Type", TrackingSpecification."Source Type");
        ReservEntry.SetRange("Source Subtype", TrackingSpecification."Source Subtype");
        ReservEntry.SetRange("Source Batch Name", TrackingSpecification."Source Batch Name");
        ReservEntry.SetRange("Source Prod. Order Line", TrackingSpecification."Source Prod. Order Line");

        // Transfer Receipt gets special treatment:
        if (TrackingSpecification."Source Type" = DATABASE::"Transfer Line") and
           (FormRunMode <> FormRunMode::Transfer) and
           (TrackingSpecification."Source Subtype" = 1) then begin
            ReservEntry.SetRange("Source Subtype", 0);
            AddReservEntriesToTempRecSet(ReservEntry, TempTrackingSpecification2, true, 8421504);
            ReservEntry.SetRange("Source Subtype", 1);
            ReservEntry.SetRange("Source Prod. Order Line", TrackingSpecification."Source Ref. No.");
            ReservEntry.SetRange("Source Ref. No.");
            DeleteIsBlocked := true;
            //SetControls(Controls::Quantity,FALSE);
        end;

        AddReservEntriesToTempRecSet(ReservEntry, TempTrackingSpecification, false, 0);

        TempReservEntry.CopyFilters(ReservEntry);

        TrackingSpecification.SetCurrentKey(
          "Source ID", "Source Type", "Source Subtype",
          "Source Batch Name", "Source Prod. Order Line", "Source Ref. No.");

        TrackingSpecification.SetRange("Source ID", TrackingSpecification."Source ID");
        TrackingSpecification.SetRange("Source Type", TrackingSpecification."Source Type");
        TrackingSpecification.SetRange("Source Subtype", TrackingSpecification."Source Subtype");
        TrackingSpecification.SetRange("Source Batch Name", TrackingSpecification."Source Batch Name");
        TrackingSpecification.SetRange("Source Prod. Order Line", TrackingSpecification."Source Prod. Order Line");
        TrackingSpecification.SetRange("Source Ref. No.", TrackingSpecification."Source Ref. No.");

        if TrackingSpecification.FindSet then
            repeat
                TempTrackingSpecification := TrackingSpecification;
                TempTrackingSpecification.Insert;
            until TrackingSpecification.Next = 0;

        // Data regarding posted quantities on transfers is collected from Item Ledger Entries:
        if TrackingSpecification."Source Type" = DATABASE::"Transfer Line" then
            CollectPostedTransferEntries(TrackingSpecification, TempTrackingSpecification);

        // Data regarding posted output quantities on prod.orders is collected from Item Ledger Entries:
        if TrackingSpecification."Source Type" = DATABASE::"Prod. Order Line" then
            if TrackingSpecification."Source Subtype" = 3 then
                CollectPostedOutputEntries(TrackingSpecification, TempTrackingSpecification);

        // If run for Drop Shipment a RowID is prepared for synchronisation:
        if FormRunMode = FormRunMode::"Drop Shipment" then
            CurrentSourceRowID := ItemTrackingMgt.ComposeRowID(TrackingSpecification."Source Type",
              TrackingSpecification."Source Subtype", TrackingSpecification."Source ID",
              TrackingSpecification."Source Batch Name", TrackingSpecification."Source Prod. Order Line",
              TrackingSpecification."Source Ref. No.");
        //>>
        if FormRunMode = FormRunMode::Countermark then
            CurrentSourceRowID := ItemTrackingMgt.ComposeRowID(TrackingSpecification."Source Type",
              TrackingSpecification."Source Subtype", TrackingSpecification."Source ID",
              TrackingSpecification."Source Batch Name", TrackingSpecification."Source Prod. Order Line",
              TrackingSpecification."Source Ref. No.");
        //<<

        // Synchronization of outbound transfer order:
        if (TrackingSpecification."Source Type" = DATABASE::"Transfer Line") and
           (TrackingSpecification."Source Subtype" = 0) then begin
            BlockCommit := true;
            CurrentSourceRowID := ItemTrackingMgt.ComposeRowID(TrackingSpecification."Source Type",
              TrackingSpecification."Source Subtype", TrackingSpecification."Source ID",
              TrackingSpecification."Source Batch Name", TrackingSpecification."Source Prod. Order Line",
              TrackingSpecification."Source Ref. No.");
            SecondSourceRowID := ItemTrackingMgt.ComposeRowID(TrackingSpecification."Source Type",
              1, TrackingSpecification."Source ID",
              TrackingSpecification."Source Batch Name", TrackingSpecification."Source Prod. Order Line",
              TrackingSpecification."Source Ref. No.");
            FormRunMode := FormRunMode::Transfer;
        end;

        AddToGlobalRecordSet(TempTrackingSpecification);
        AddToGlobalRecordSet(TempTrackingSpecification2);
        CalculateSums;

        ItemTrackingDataCollection.SetCurrentBinAndItemTrkgCode(ForBinCode, ItemTrackingCode);
        ItemTrackingDataCollection.RetrieveLookupData(rec, false);

        //CurrForm.FunctionsDemand.VISIBLE(CurrentSignFactor * SourceQuantityArray[1] < 0);
        //CurrForm.FunctionsSupply.VISIBLE(NOT CurrForm.FunctionsDemand.VISIBLE);
    end;


    procedure SetSecondSourceQuantity(var SecondSourceQuantityArray: array[3] of Decimal)
    var
        Controls: Option Handle,Invoice;
    begin
        case SecondSourceQuantityArray[1] of
            DATABASE::"Warehouse Receipt Line", DATABASE::"Warehouse Shipment Line":
                begin
                    SourceQuantityArray[2] := SecondSourceQuantityArray[2]; // "Qty. to Handle (Base)"
                    SourceQuantityArray[3] := SecondSourceQuantityArray[3]; // "Qty. to Invoice (Base)"
                                                                            //SetControls(Controls::Invoice,FALSE);
                end;
            else
                exit;
        end;
        CalculateSums;
    end;


    procedure SetSecondSourceRowID(RowID: Text[100])
    begin
        SecondSourceRowID := RowID;
    end;

    local procedure AddReservEntriesToTempRecSet(var ReservEntry: Record "Reservation Entry"; var TempTrackingSpecification: Record "Tracking Specification" temporary; SwapSign: Boolean; Color: Integer)
    begin
        if ReservEntry.FindSet then
            repeat
                if Color = 0 then begin
                    TempReservEntry := ReservEntry;
                    TempReservEntry.Insert;
                end;
                if (ReservEntry."Lot No." <> '') or (ReservEntry."Serial No." <> '') then begin
                    TempTrackingSpecification.TransferFields(ReservEntry);
                    // Ensure uniqueness of Entry No. by making it negative:
                    TempTrackingSpecification."Entry No." *= -1;
                    if SwapSign then
                        TempTrackingSpecification."Quantity (Base)" *= -1;
                    if Color <> 0 then begin
                        TempTrackingSpecification."Quantity Handled (Base)" :=
                          TempTrackingSpecification."Quantity (Base)";
                        TempTrackingSpecification."Quantity Invoiced (Base)" :=
                          TempTrackingSpecification."Quantity (Base)";
                        TempTrackingSpecification."Qty. to Handle (Base)" := 0;
                        TempTrackingSpecification."Qty. to Invoice (Base)" := 0;
                    end;
                    TempTrackingSpecification."Buffer Status" := Color;
                    TempTrackingSpecification.Insert;
                end;
            until ReservEntry.Next = 0;
    end;

    local procedure AddToGlobalRecordSet(var TempTrackingSpecification: Record "Tracking Specification" temporary)
    var
        ExpDate: Date;
        EntriesExist: Boolean;
    begin
        TempTrackingSpecification.SetCurrentKey("Lot No.", "Serial No.");
        if TempTrackingSpecification.Find('-') then
            repeat
                TempTrackingSpecification.SetRange("Lot No.", TempTrackingSpecification."Lot No.");
                TempTrackingSpecification.SetRange("Serial No.", TempTrackingSpecification."Serial No.");
                TempTrackingSpecification.CalcSums("Quantity (Base)", "Qty. to Handle (Base)",
                  "Qty. to Invoice (Base)", "Quantity Handled (Base)", "Quantity Invoiced (Base)");
                rec := TempTrackingSpecification;
                rec."Quantity (Base)" *= CurrentSignFactor;
                rec."Qty. to Handle (Base)" *= CurrentSignFactor;
                rec."Qty. to Invoice (Base)" *= CurrentSignFactor;
                rec."Quantity Handled (Base)" *= CurrentSignFactor;
                rec."Quantity Invoiced (Base)" *= CurrentSignFactor;
                rec."Qty. to Handle" :=
                  rec.CalcQty(rec."Qty. to Handle (Base)");
                rec."Qty. to Invoice" :=
                  rec.CalcQty(rec."Qty. to Invoice (Base)");
                rec."Entry No." := NextEntryNo;

                ExpDate := ItemTrackingMgt.ExistingExpirationDate(
                  rec."Item No.", rec."Variant Code",
                  rec."Lot No.", rec."Serial No.", false, EntriesExist);

                if ExpDate <> 0D then begin
                    rec."Expiration Date" := ExpDate;
                    rec."Buffer Status2" := rec."Buffer Status2"::"ExpDate blocked";
                end;

                rec.Insert;
                if rec."Buffer Status" = 0 then begin
                    xTempItemTrackingLine := rec;
                    xTempItemTrackingLine.Insert;
                end;
                TempTrackingSpecification.Find('+');
                TempTrackingSpecification.SetRange("Lot No.");
                TempTrackingSpecification.SetRange("Serial No.");
            until TempTrackingSpecification.Next = 0;
    end;

    local procedure GetItem(ItemNo: Code[20])
    begin
        if Item."No." <> ItemNo then begin
            Item.Get(ItemNo);
            Item.TestField("Item Tracking Code");
            if ItemTrackingCode.Code <> Item."Item Tracking Code" then
                ItemTrackingCode.Get(Item."Item Tracking Code");
        end;
    end;

    local procedure SetFilters(TrackingSpecification: Record "Tracking Specification")
    begin
        rec.FilterGroup := 2;
        rec.SetCurrentKey("Source ID", "Source Type", "Source Subtype", "Source Batch Name", "Source Prod. Order Line", "Source Ref. No.");
        rec.SetRange("Source ID", TrackingSpecification."Source ID");
        rec.SetRange("Source Type", TrackingSpecification."Source Type");
        rec.SetRange("Source Subtype", TrackingSpecification."Source Subtype");
        rec.SetRange("Source Batch Name", TrackingSpecification."Source Batch Name");
        if (TrackingSpecification."Source Type" = DATABASE::"Transfer Line") and
           (TrackingSpecification."Source Subtype" = 1) then begin
            rec.SetRange("Source Prod. Order Line", TrackingSpecification."Source Ref. No.");
            rec.SetRange("Source Ref. No.");
        end else begin
            rec.SetRange("Source Prod. Order Line", TrackingSpecification."Source Prod. Order Line");
            rec.SetRange("Source Ref. No.", TrackingSpecification."Source Ref. No.");
        end;
        rec.SetRange("Item No.", TrackingSpecification."Item No.");
        rec.SetRange("Location Code", TrackingSpecification."Location Code");
        rec.SetRange("Variant Code", TrackingSpecification."Variant Code");
        rec.FilterGroup := 0;
    end;

    local procedure CheckLine(TrackingLine: Record "Tracking Specification"): Boolean
    begin
        if TrackingLine."Quantity (Base)" * SourceQuantityArray[1] < 0 then
            if SourceQuantityArray[1] < 0 then
                Error(Text002, Text003)
            else
                Error(Text002, Text004);
    end;

    local procedure CalculateSums()
    var
        xTrackingSpec: Record "Tracking Specification";
    begin
        xTrackingSpec.Copy(rec);
        rec.Reset;
        rec.CalcSums("Quantity (Base)",
          rec."Qty. to Handle (Base)",
          rec."Qty. to Invoice (Base)");
        TotalItemTrackingLine := rec;
        rec.Copy(xTrackingSpec);

        UpdateUndefinedQty;
    end;

    local procedure UpdateUndefinedQty() QtyIsValid: Boolean
    begin
        UndefinedQtyArray[1] := SourceQuantityArray[1] - TotalItemTrackingLine."Quantity (Base)";
        UndefinedQtyArray[2] := SourceQuantityArray[2] - TotalItemTrackingLine."Qty. to Handle (Base)";
        UndefinedQtyArray[3] := SourceQuantityArray[3] - TotalItemTrackingLine."Qty. to Invoice (Base)";

        if Abs(SourceQuantityArray[1]) < Abs(TotalItemTrackingLine."Quantity (Base)") then begin
            ColorOfQuantityArray[1] := 255;
            QtyIsValid := false;
        end else begin
            ColorOfQuantityArray[1] := 0;
            QtyIsValid := true;
        end;

        if Abs(SourceQuantityArray[2]) < Abs(TotalItemTrackingLine."Qty. to Handle (Base)") then
            ColorOfQuantityArray[2] := 255
        else
            ColorOfQuantityArray[2] := 0;

        if Abs(SourceQuantityArray[3]) < Abs(TotalItemTrackingLine."Qty. to Invoice (Base)") then
            ColorOfQuantityArray[3] := 255
        else
            ColorOfQuantityArray[3] := 0;
    end;

    local procedure TempRecIsValid() OK: Boolean
    var
        ReservEntry: Record "Reservation Entry";
        RecordCount: Integer;
        IdenticalArray: array[2] of Boolean;
    begin
        OK := false;
        TempReservEntry.SetCurrentKey("Entry No.", Positive);
        ReservEntry.SetCurrentKey("Entry No.", Positive);
        ReservEntry.CopyFilters(TempReservEntry);

        if ReservEntry.FindSet then
            repeat
                if not TempReservEntry.Get(ReservEntry."Entry No.", ReservEntry.Positive) then
                    exit(false);
                if not EntriesAreIdentical(ReservEntry, TempReservEntry, IdenticalArray) then
                    exit(false);
                RecordCount += 1;
            until ReservEntry.Next = 0;

        OK := RecordCount = TempReservEntry.Count;
    end;

    local procedure EntriesAreIdentical(var ReservEntry1: Record "Reservation Entry"; var ReservEntry2: Record "Reservation Entry"; var IdenticalArray: array[2] of Boolean): Boolean
    begin
        IdenticalArray[1] := (
          (ReservEntry1."Entry No." = ReservEntry2."Entry No.") and
          (ReservEntry1."Item No." = ReservEntry2."Item No.") and
          (ReservEntry1."Location Code" = ReservEntry2."Location Code") and
          (ReservEntry1."Quantity (Base)" = ReservEntry2."Quantity (Base)") and
          (ReservEntry1."Reservation Status" = ReservEntry2."Reservation Status") and
          (ReservEntry1."Creation Date" = ReservEntry2."Creation Date") and
          (ReservEntry1."Transferred from Entry No." = ReservEntry2."Transferred from Entry No.") and
          (ReservEntry1."Source Type" = ReservEntry2."Source Type") and
          (ReservEntry1."Source Subtype" = ReservEntry2."Source Subtype") and
          (ReservEntry1."Source ID" = ReservEntry2."Source ID") and
          (ReservEntry1."Source Batch Name" = ReservEntry2."Source Batch Name") and
          (ReservEntry1."Source Prod. Order Line" = ReservEntry2."Source Prod. Order Line") and
          (ReservEntry1."Source Ref. No." = ReservEntry2."Source Ref. No.") and
          (ReservEntry1."Expected Receipt Date" = ReservEntry2."Expected Receipt Date") and
          (ReservEntry1."Shipment Date" = ReservEntry2."Shipment Date") and
          (ReservEntry1."Serial No." = ReservEntry2."Serial No.") and
          (ReservEntry1."Created By" = ReservEntry2."Created By") and
          (ReservEntry1."Changed By" = ReservEntry2."Changed By") and
          (ReservEntry1.Positive = ReservEntry2.Positive) and
          (ReservEntry1."Qty. per Unit of Measure" = ReservEntry2."Qty. per Unit of Measure") and
          (ReservEntry1.Quantity = ReservEntry2.Quantity) and
          (ReservEntry1."Action Message Adjustment" = ReservEntry2."Action Message Adjustment") and
          (ReservEntry1.Binding = ReservEntry2.Binding) and
          (ReservEntry1."Suppressed Action Msg." = ReservEntry2."Suppressed Action Msg.") and
          (ReservEntry1."Planning Flexibility" = ReservEntry2."Planning Flexibility") and
          (ReservEntry1."Lot No." = ReservEntry2."Lot No.") and
          (ReservEntry1."Variant Code" = ReservEntry2."Variant Code") and
          (ReservEntry1."Quantity Invoiced (Base)" = ReservEntry2."Quantity Invoiced (Base)"));

        IdenticalArray[2] := (
          (ReservEntry1.Description = ReservEntry2.Description) and
          (ReservEntry1."New Serial No." = ReservEntry2."New Serial No.") and
          (ReservEntry1."New Lot No." = ReservEntry2."New Lot No.") and
          (ReservEntry1."Expiration Date" = ReservEntry2."Expiration Date") and
          (ReservEntry1."Warranty Date" = ReservEntry2."Warranty Date") and
          (ReservEntry1."New Expiration Date" = ReservEntry2."New Expiration Date"));

        exit(IdenticalArray[1] and IdenticalArray[2]);
    end;

    local procedure QtyToHandleAndInvoiceChanged(var ReservEntry1: Record "Reservation Entry"; var ReservEntry2: Record "Reservation Entry"): Boolean
    begin
        exit(
          (ReservEntry1."Qty. to Handle (Base)" <> ReservEntry2."Qty. to Handle (Base)") or
          (ReservEntry1."Qty. to Invoice (Base)" <> ReservEntry2."Qty. to Invoice (Base)"));
    end;

    local procedure NextEntryNo(): Integer
    begin
        LastEntryNo += 1;
        exit(LastEntryNo);
    end;

    local procedure WriteToDatabase()
    var
        Window: Dialog;
        ChangeType: Option Insert,Modify,Delete;
        EntryNo: Integer;
        NoOfLines: Integer;
        i: Integer;
    begin
        if CurrentFormIsOpen then begin
            TempReservEntry.LockTable;
            if not TempRecIsValid then
                Error(Text007);

            if Item."Order Tracking Policy" = Item."Order Tracking Policy"::None then
                QtyToAddAsBlank := 0
            else
                QtyToAddAsBlank := UndefinedQtyArray[1] * CurrentSignFactor;

            rec.Reset;
            rec.DeleteAll;

            NoOfLines := TempItemTrackLineInsert.Count + TempItemTrackLineModify.Count + TempItemTrackLineDelete.Count;
            if TempItemTrackLineDelete.Find('-') then begin
                repeat
                    i := i + 1;
                    if i mod 100 = 0 then
                        RegisterChange(TempItemTrackLineDelete, TempItemTrackLineDelete, ChangeType::Delete, false);
                    if TempItemTrackLineModify.Get(TempItemTrackLineDelete."Entry No.") then
                        TempItemTrackLineModify.Delete;
                until TempItemTrackLineDelete.Next = 0;
                TempItemTrackLineDelete.DeleteAll;
            end;

            if TempItemTrackLineModify.Find('-') then begin
                repeat
                    i := i + 1;
                    if i mod 100 = 0 then
                        if xTempItemTrackingLine.Get(TempItemTrackLineModify."Entry No.") then
                            if (xTempItemTrackingLine."Serial No." <> TempItemTrackLineModify."Serial No.") or
                               (xTempItemTrackingLine."Lot No." <> TempItemTrackLineModify."Lot No.") or
                               (xTempItemTrackingLine."Appl.-from Item Entry" <> TempItemTrackLineModify."Appl.-from Item Entry")
                            then begin
                                RegisterChange(xTempItemTrackingLine, xTempItemTrackingLine, ChangeType::Delete, false);
                                RegisterChange(TempItemTrackLineModify, TempItemTrackLineModify, ChangeType::Insert, false);
                                if (TempItemTrackLineInsert."Quantity (Base)" <> TempItemTrackLineInsert."Qty. to Handle (Base)") or
                                   (TempItemTrackLineInsert."Quantity (Base)" <> TempItemTrackLineInsert."Qty. to Invoice (Base)")
                                then
                                    SetQtyToHandleAndInvoice(TempItemTrackLineInsert);
                            end else begin
                                RegisterChange(xTempItemTrackingLine, TempItemTrackLineModify, ChangeType::Modify, false);
                                SetQtyToHandleAndInvoice(TempItemTrackLineModify);
                            end;
                until TempItemTrackLineModify.Next = 0;
                TempItemTrackLineModify.DeleteAll;
            end;

            if TempItemTrackLineInsert.Find('-') then begin
                repeat
                    i := i + 1;
                    if TempItemTrackLineModify.Get(TempItemTrackLineInsert."Entry No.") then
                        TempItemTrackLineInsert.TransferFields(TempItemTrackLineModify);
                    if not RegisterChange(TempItemTrackLineInsert, TempItemTrackLineInsert, ChangeType::Insert, false) then
                        Error(Text005);
                    if (TempItemTrackLineInsert."Quantity (Base)" <> TempItemTrackLineInsert."Qty. to Handle (Base)") or
                       (TempItemTrackLineInsert."Quantity (Base)" <> TempItemTrackLineInsert."Qty. to Invoice (Base)")
                    then
                        SetQtyToHandleAndInvoice(TempItemTrackLineInsert);
                until TempItemTrackLineInsert.Next = 0;
                TempItemTrackLineInsert.DeleteAll;
            end;


        end else begin

            TempReservEntry.LockTable;
            if not TempRecIsValid then
                Error(Text007);

            if Item."Order Tracking Policy" = Item."Order Tracking Policy"::None then
                QtyToAddAsBlank := 0
            else
                QtyToAddAsBlank := UndefinedQtyArray[1] * CurrentSignFactor;

            rec.Reset;
            rec.SetFilter("Buffer Status", '<>%1', 0);
            rec.DeleteAll;
            rec.Reset;

            xTempItemTrackingLine.Reset;
            rec.SetCurrentKey("Entry No.");
            xTempItemTrackingLine.SetCurrentKey("Entry No.");
            if xTempItemTrackingLine.Find('-') then
                repeat
                    rec.SetRange("Lot No.", xTempItemTrackingLine."Lot No.");
                    rec.SetRange("Serial No.", xTempItemTrackingLine."Serial No.");
                    if rec.Find('-') then begin
                        if RegisterChange(xTempItemTrackingLine, rec, ChangeType::Modify, false) then begin
                            EntryNo := xTempItemTrackingLine."Entry No.";
                            xTempItemTrackingLine := rec;
                            xTempItemTrackingLine."Entry No." := EntryNo;
                            xTempItemTrackingLine.Modify;
                        end;
                        SetQtyToHandleAndInvoice(rec);
                        rec.Delete;
                    end else begin
                        RegisterChange(xTempItemTrackingLine, xTempItemTrackingLine, ChangeType::Delete, false);
                        xTempItemTrackingLine.Delete;
                    end;
                until xTempItemTrackingLine.Next = 0;

            rec.Reset;

            if rec.Find('-') then
                repeat
                    if RegisterChange(rec, rec, ChangeType::Insert, false) then begin
                        xTempItemTrackingLine := rec;
                        xTempItemTrackingLine.Insert;
                    end else
                        Error(Text005);
                    SetQtyToHandleAndInvoice(rec);
                    rec.Delete;
                until rec.Next = 0;

        end;

        UpdateOrderTracking;
        ReestablishReservations; // Late Binding

        if not BlockCommit then
            Commit;
    end;

    local procedure RegisterChange(var OldTrackingSpecification: Record "Tracking Specification"; var NewTrackingSpecification: Record "Tracking Specification"; ChangeType: Option Insert,Modify,FullDelete,PartDelete,ModifyAll; ModifySharedFields: Boolean) OK: Boolean
    var
        ReservEntry1: Record "Reservation Entry";
        ReservEntry2: Record "Reservation Entry";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        ReservationMgt: Codeunit "Reservation Management";
        AvailabilityDate: Date;
        QtyToAdd: Decimal;
        LostReservQty: Decimal;
        IdenticalArray: array[2] of Boolean;
    begin
        OK := false;

        if CurrentSignFactor < 0 then
            NewTrackingSpecification."Expiration Date" := 0D;

        case ChangeType of
            ChangeType::Insert:
                begin
                    if (OldTrackingSpecification."Quantity (Base)" = 0) or
                       ((OldTrackingSpecification."Lot No." = '') and
                        (OldTrackingSpecification."Serial No." = ''))
                    then
                        exit(true);
                    TempReservEntry.SetRange("Serial No.", '');
                    TempReservEntry.SetRange("Lot No.", '');
                    OldTrackingSpecification."Quantity (Base)" :=
                      CurrentSignFactor *
                      ReservEngineMgt.AddItemTrackingToTempRecSet(
                        TempReservEntry, NewTrackingSpecification,
                        CurrentSignFactor * OldTrackingSpecification."Quantity (Base)", QtyToAddAsBlank,
                        ItemTrackingCode."SN Specific Tracking", ItemTrackingCode."Lot Specific Tracking");
                    TempReservEntry.SetRange("Serial No.");
                    TempReservEntry.SetRange("Lot No.");

                    // Late Binding
                    if ReservEngineMgt.RetrieveLostReservQty(LostReservQty) then begin
                        TempItemTrackLineReserv := OldTrackingSpecification;
                        TempItemTrackLineReserv."Quantity (Base)" := LostReservQty * CurrentSignFactor;
                        TempItemTrackLineReserv.Insert;
                    end;

                    if OldTrackingSpecification."Quantity (Base)" = 0 then
                        exit(true);

                    if (FormRunMode = FormRunMode::Reclass) or MoveBinContent then begin
                        CreateReservEntry.SetNewSerialLotNo(
                          OldTrackingSpecification."New Serial No.", OldTrackingSpecification."New Lot No.");
                        CreateReservEntry.SetNewExpirationDate(OldTrackingSpecification."New Expiration Date");
                    end;
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
                      OldTrackingSpecification."Serial No.",
                      OldTrackingSpecification."Lot No.");
                    CreateReservEntry.CreateEntry(OldTrackingSpecification."Item No.",
                      OldTrackingSpecification."Variant Code",
                      OldTrackingSpecification."Location Code",
                      OldTrackingSpecification.Description,
                      ExpectedReceiptDate,
                      ShipmentDate, 0, CurrentEntryStatus);
                    CreateReservEntry.GetLastEntry(ReservEntry1);
                    if Item."Order Tracking Policy" = Item."Order Tracking Policy"::"Tracking & Action Msg." then
                        ReservEngineMgt.UpdateActionMessages(ReservEntry1);

                    if ModifySharedFields then begin
                        ReservationMgt.SetPointerFilter(ReservEntry1);
                        ReservEntry1.SetRange("Lot No.", ReservEntry1."Lot No.");
                        ReservEntry1.SetRange("Serial No.", ReservEntry1."Serial No.");
                        ReservEntry1.SetFilter("Entry No.", '<>%1', ReservEntry1."Entry No.");
                        ModifyFieldsWithinFilter(ReservEntry1, NewTrackingSpecification);
                    end;

                    if CurrentSignFactor < 0 then
                        AvailabilityDate := ShipmentDate
                    else
                        AvailabilityDate := ExpectedReceiptDate;
                    OK := true;
                end;
            ChangeType::Modify:
                begin
                    ReservEntry1.TransferFields(OldTrackingSpecification);
                    ReservEntry2.TransferFields(NewTrackingSpecification);

                    ReservEntry1."Entry No." := ReservEntry2."Entry No."; // If only entry no. has changed it should not trigger
                    if EntriesAreIdentical(ReservEntry1, ReservEntry2, IdenticalArray) then
                        exit(QtyToHandleAndInvoiceChanged(ReservEntry1, ReservEntry2));

                    if Abs(OldTrackingSpecification."Quantity (Base)") < Abs(NewTrackingSpecification."Quantity (Base)") then begin
                        // Item Tracking is added to any blank reservation entries:
                        TempReservEntry.SetRange("Serial No.", '');
                        TempReservEntry.SetRange("Lot No.", '');
                        QtyToAdd :=
                          CurrentSignFactor *
                          ReservEngineMgt.AddItemTrackingToTempRecSet(
                            TempReservEntry, NewTrackingSpecification,
                            CurrentSignFactor * (NewTrackingSpecification."Quantity (Base)" -
                            OldTrackingSpecification."Quantity (Base)"), QtyToAddAsBlank,
                            ItemTrackingCode."SN Specific Tracking", ItemTrackingCode."Lot Specific Tracking");
                        TempReservEntry.SetRange("Serial No.");
                        TempReservEntry.SetRange("Lot No.");

                        // Late Binding
                        if ReservEngineMgt.RetrieveLostReservQty(LostReservQty) then begin
                            TempItemTrackLineReserv := OldTrackingSpecification;
                            TempItemTrackLineReserv."Quantity (Base)" := LostReservQty * CurrentSignFactor;
                            TempItemTrackLineReserv.Insert;
                        end;

                        OldTrackingSpecification."Quantity (Base)" := QtyToAdd;
                        OldTrackingSpecification."Warranty Date" := NewTrackingSpecification."Warranty Date";
                        OldTrackingSpecification."Expiration Date" := NewTrackingSpecification."Expiration Date";
                        OldTrackingSpecification.Description := NewTrackingSpecification.Description;
                        RegisterChange(OldTrackingSpecification, OldTrackingSpecification,
                          ChangeType::Insert, not IdenticalArray[2]);
                    end else begin
                        TempReservEntry.SetRange("Serial No.", OldTrackingSpecification."Serial No.");
                        TempReservEntry.SetRange("Lot No.", OldTrackingSpecification."Lot No.");
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
                            ItemTrackingCode."SN Specific Tracking", ItemTrackingCode."Lot Specific Tracking");
                        TempReservEntry.SetRange("Serial No.");
                        TempReservEntry.SetRange("Lot No.");
                        RegisterChange(NewTrackingSpecification, NewTrackingSpecification,
                          ChangeType::PartDelete, not IdenticalArray[2]);
                    end;
                    OK := true;
                end;
            ChangeType::FullDelete, ChangeType::PartDelete:
                begin
                    ReservationMgt.SetItemTrackingHandling(1); // Allow deletion of Item Tracking
                    ReservEntry1.TransferFields(OldTrackingSpecification);
                    ReservationMgt.SetPointerFilter(ReservEntry1);
                    ReservEntry1.SetRange("Lot No.", ReservEntry1."Lot No.");
                    ReservEntry1.SetRange("Serial No.", ReservEntry1."Serial No.");
                    if ChangeType = ChangeType::FullDelete then begin
                        TempReservEntry.SetRange("Serial No.", OldTrackingSpecification."Serial No.");
                        TempReservEntry.SetRange("Lot No.", OldTrackingSpecification."Lot No.");
                        OldTrackingSpecification."Serial No." := '';
                        OldTrackingSpecification."Lot No." := '';
                        OldTrackingSpecification."Warranty Date" := 0D;
                        OldTrackingSpecification."Expiration Date" := 0D;
                        QtyToAdd :=
                          CurrentSignFactor *
                          ReservEngineMgt.AddItemTrackingToTempRecSet(
                            TempReservEntry, OldTrackingSpecification,
                            CurrentSignFactor * OldTrackingSpecification."Quantity (Base)", QtyToAddAsBlank,
                            ItemTrackingCode."SN Specific Tracking", ItemTrackingCode."Lot Specific Tracking");
                        TempReservEntry.SetRange("Serial No.");
                        TempReservEntry.SetRange("Lot No.");
                        ReservationMgt.DeleteReservEntries2(true, 0, ReservEntry1)
                    end else begin
                        ReservationMgt.DeleteReservEntries2(false, ReservEntry1."Quantity (Base)" -
                          OldTrackingSpecification."Quantity Handled (Base)", ReservEntry1);
                        if ModifySharedFields then begin
                            ReservEntry1.SetRange("Reservation Status");
                            ModifyFieldsWithinFilter(ReservEntry1, OldTrackingSpecification);
                        end;
                    end;
                    OK := true;
                end;
        end;
        SetQtyToHandleAndInvoice(NewTrackingSpecification);
    end;

    local procedure UpdateOrderTracking()
    var
        TempReservEntry: Record "Reservation Entry" temporary;
    begin
        if not ReservEngineMgt.CollectAffectedSurplusEntries(TempReservEntry) then
            exit;
        if Item."Order Tracking Policy" = Item."Order Tracking Policy"::None then
            exit;
        ReservEngineMgt.UpdateOrderTracking(TempReservEntry);
    end;


    procedure ModifyFieldsWithinFilter(var ReservEntry1: Record "Reservation Entry"; var TrackingSpecification: Record "Tracking Specification")
    begin
        // Used to ensure that field values that are common to a SN/Lot are copied to all entries.
        if ReservEntry1.Find('-') then
            repeat
                ReservEntry1.Description := TrackingSpecification.Description;
                ReservEntry1."Warranty Date" := TrackingSpecification."Warranty Date";
                ReservEntry1."Expiration Date" := TrackingSpecification."Expiration Date";
                ReservEntry1."New Serial No." := TrackingSpecification."New Serial No.";
                ReservEntry1."New Lot No." := TrackingSpecification."New Lot No.";
                ReservEntry1."New Expiration Date" := TrackingSpecification."New Expiration Date";
                ReservEntry1.Modify;
            until ReservEntry1.Next = 0;
    end;

    local procedure SetQtyToHandleAndInvoice(TrackingSpecification: Record "Tracking Specification") OK: Boolean
    var
        ReservEntry1: Record "Reservation Entry";
        ReservationMgt: Codeunit "Reservation Management";
        TotalQtyToHandle: Decimal;
        TotalQtyToInvoice: Decimal;
        QtyAlreadyHandledToInvoice: Decimal;
        QtyToHandleThisLine: Decimal;
        QtyToInvoiceThisLine: Decimal;
    begin
        if IsCorrection then
            exit;
        OK := false;

        TotalQtyToHandle := TrackingSpecification."Qty. to Handle (Base)" * CurrentSignFactor;
        TotalQtyToInvoice := TrackingSpecification."Qty. to Invoice (Base)" * CurrentSignFactor;

        if Abs(TotalQtyToHandle) > Abs(TotalQtyToInvoice) then
            QtyAlreadyHandledToInvoice := 0
        else
            QtyAlreadyHandledToInvoice := TotalQtyToInvoice - TotalQtyToHandle;

        ReservEntry1.TransferFields(TrackingSpecification);
        ReservationMgt.SetPointerFilter(ReservEntry1);
        ReservEntry1.SetRange("Lot No.", ReservEntry1."Lot No.");
        ReservEntry1.SetRange("Serial No.", ReservEntry1."Serial No.");
        if (TrackingSpecification."Lot No." <> '') or
           (TrackingSpecification."Serial No." <> '')
        then begin
            ItemTrackingMgt.SetPointerFilter(TrackingSpecification);
            TrackingSpecification.SetRange("Lot No.", TrackingSpecification."Lot No.");
            TrackingSpecification.SetRange("Serial No.", TrackingSpecification."Serial No.");

            if TrackingSpecification.Find('-') then
                repeat
                    if not TrackingSpecification.Correction then begin
                        QtyToInvoiceThisLine :=
                          TrackingSpecification."Quantity Handled (Base)" - TrackingSpecification."Quantity Invoiced (Base)";
                        if Abs(QtyToInvoiceThisLine) > Abs(TotalQtyToInvoice) then
                            QtyToInvoiceThisLine := TotalQtyToInvoice;

                        if Abs(QtyToInvoiceThisLine) > Abs(QtyAlreadyHandledToInvoice) then begin
                            QtyToInvoiceThisLine := QtyAlreadyHandledToInvoice;
                            QtyAlreadyHandledToInvoice := 0;
                        end else
                            QtyAlreadyHandledToInvoice -= QtyToInvoiceThisLine;

                        if TrackingSpecification."Qty. to Invoice (Base)" <> QtyToInvoiceThisLine then begin
                            TrackingSpecification."Qty. to Invoice (Base)" := QtyToInvoiceThisLine;
                            TrackingSpecification.Modify;
                        end;

                        TotalQtyToInvoice -= QtyToInvoiceThisLine;
                    end;
                until (TrackingSpecification.Next = 0);

            OK := ((TotalQtyToHandle = 0) and (TotalQtyToInvoice = 0));
        end;

        if TrackingSpecification."Lot No." <> '' then begin
            for ReservEntry1."Reservation Status" := ReservEntry1."Reservation Status"::Reservation to
              ReservEntry1."Reservation Status"::Prospect
            do begin
                ReservEntry1.SetRange("Reservation Status", ReservEntry1."Reservation Status");
                if ReservEntry1.Find('-') then
                    repeat
                        QtyToHandleThisLine := ReservEntry1."Quantity (Base)";
                        QtyToInvoiceThisLine := QtyToHandleThisLine;

                        if Abs(QtyToHandleThisLine) > Abs(TotalQtyToHandle) then
                            QtyToHandleThisLine := TotalQtyToHandle;
                        if Abs(QtyToInvoiceThisLine) > Abs(TotalQtyToInvoice) then
                            QtyToInvoiceThisLine := TotalQtyToInvoice;

                        if (ReservEntry1."Qty. to Handle (Base)" <> QtyToHandleThisLine) or
                           (ReservEntry1."Qty. to Invoice (Base)" <> QtyToInvoiceThisLine) and not ReservEntry1.Correction
                        then begin
                            ReservEntry1."Qty. to Handle (Base)" := QtyToHandleThisLine;
                            ReservEntry1."Qty. to Invoice (Base)" := QtyToInvoiceThisLine;
                            ReservEntry1.Modify;
                        end;

                        TotalQtyToHandle -= QtyToHandleThisLine;
                        TotalQtyToInvoice -= QtyToInvoiceThisLine;

                    until (ReservEntry1.Next = 0);
            end;

            OK := ((TotalQtyToHandle = 0) and (TotalQtyToInvoice = 0));
        end else
            if ReservEntry1.Find('-') then
                if (ReservEntry1."Qty. to Handle (Base)" <> TotalQtyToHandle) or
                   (ReservEntry1."Qty. to Invoice (Base)" <> TotalQtyToInvoice) and not ReservEntry1.Correction
                then begin
                    ReservEntry1."Qty. to Handle (Base)" := TotalQtyToHandle;
                    ReservEntry1."Qty. to Invoice (Base)" := TotalQtyToInvoice;
                    ReservEntry1.Modify;
                end;
    end;

    local procedure CollectPostedTransferEntries(TrackingSpecification: Record "Tracking Specification"; var TempTrackingSpecification: Record "Tracking Specification" temporary)
    var
        ItemEntryRelation: Record "Item Entry Relation";
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        // Used for collecting information about posted Transfer Shipments from the created Item Ledger Entries.
        if TrackingSpecification."Source Type" <> DATABASE::"Transfer Line" then
            exit;

        ItemEntryRelation.SetCurrentKey("Order No.", "Order Line No.");
        ItemEntryRelation.SetRange("Order No.", TrackingSpecification."Source ID");
        ItemEntryRelation.SetRange("Order Line No.", TrackingSpecification."Source Ref. No.");

        case TrackingSpecification."Source Subtype" of
            0: // Outbound
                begin
                    ItemEntryRelation.SetRange("Source Type", DATABASE::"Transfer Shipment Line");
                end;
            1: // Inbound
                begin
                    ItemEntryRelation.SetRange("Source Type", DATABASE::"Transfer Receipt Line");
                end;
        end;

        if ItemEntryRelation.Find('-') then
            repeat
                ItemLedgerEntry.Get(ItemEntryRelation."Item Entry No.");
                TempTrackingSpecification := TrackingSpecification;
                TempTrackingSpecification."Entry No." := ItemLedgerEntry."Entry No.";
                TempTrackingSpecification."Item No." := ItemLedgerEntry."Item No.";
                TempTrackingSpecification."Serial No." := ItemLedgerEntry."Serial No.";
                TempTrackingSpecification."Lot No." := ItemLedgerEntry."Lot No.";
                TempTrackingSpecification."Quantity (Base)" := ItemLedgerEntry.Quantity;
                TempTrackingSpecification."Quantity Handled (Base)" := ItemLedgerEntry.Quantity;
                TempTrackingSpecification."Quantity Invoiced (Base)" := ItemLedgerEntry.Quantity;
                TempTrackingSpecification."Qty. per Unit of Measure" := ItemLedgerEntry."Qty. per Unit of Measure";
                TempTrackingSpecification.InitQtyToShip;
                TempTrackingSpecification.Insert;
            until ItemEntryRelation.Next = 0;
    end;

    local procedure CollectPostedOutputEntries(TrackingSpecification: Record "Tracking Specification"; var TempTrackingSpecification: Record "Tracking Specification" temporary)
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        BackwardFlushing: Boolean;
    begin
        // Used for collecting information about posted prod. order output from the created Item Ledger Entries.
        if TrackingSpecification."Source Type" <> DATABASE::"Prod. Order Line" then
            exit;

        if (TrackingSpecification."Source Type" = DATABASE::"Prod. Order Line") and
           (TrackingSpecification."Source Subtype" = 3)
        then begin
            ProdOrderRoutingLine.SetRange(Status, TrackingSpecification."Source Subtype");
            ProdOrderRoutingLine.SetRange("Prod. Order No.", TrackingSpecification."Source ID");
            ProdOrderRoutingLine.SetRange("Routing Reference No.", TrackingSpecification."Source Prod. Order Line");
            if ProdOrderRoutingLine.Find('+') then
                BackwardFlushing :=
                  ProdOrderRoutingLine."Flushing Method" = ProdOrderRoutingLine."Flushing Method"::Backward;
        end;

        ItemLedgerEntry.SetCurrentKey("Prod. Order No.", "Prod. Order Line No.", "Entry Type");
        ItemLedgerEntry.SetRange("Prod. Order No.", TrackingSpecification."Source ID");
        ItemLedgerEntry.SetRange("Prod. Order Line No.", TrackingSpecification."Source Prod. Order Line");
        ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Output);

        if ItemLedgerEntry.Find('-') then
            repeat
                TempTrackingSpecification := TrackingSpecification;
                TempTrackingSpecification."Entry No." := ItemLedgerEntry."Entry No.";
                TempTrackingSpecification."Item No." := ItemLedgerEntry."Item No.";
                TempTrackingSpecification."Serial No." := ItemLedgerEntry."Serial No.";
                TempTrackingSpecification."Lot No." := ItemLedgerEntry."Lot No.";
                TempTrackingSpecification."Quantity (Base)" := ItemLedgerEntry.Quantity;
                TempTrackingSpecification."Quantity Handled (Base)" := ItemLedgerEntry.Quantity;
                TempTrackingSpecification."Quantity Invoiced (Base)" := ItemLedgerEntry.Quantity;
                TempTrackingSpecification."Qty. per Unit of Measure" := ItemLedgerEntry."Qty. per Unit of Measure";
                TempTrackingSpecification.InitQtyToShip;
                TempTrackingSpecification.Insert;

                if BackwardFlushing then begin
                    SourceQuantityArray[1] += ItemLedgerEntry.Quantity;
                    SourceQuantityArray[2] += ItemLedgerEntry.Quantity;
                    SourceQuantityArray[3] += ItemLedgerEntry.Quantity;
                end;

            until ItemLedgerEntry.Next = 0;
    end;

    local procedure ZeroLineExists() OK: Boolean
    var
        xTrackingSpec: Record "Tracking Specification";
    begin
        if (rec."Quantity (Base)" <> 0) or (rec."Serial No." <> '') or (rec."Lot No." <> '') then
            exit(false);
        xTrackingSpec.Copy(rec);
        rec.Reset;
        rec.SetRange("Quantity (Base)", 0);
        rec.SetRange("Serial No.", '');
        rec.SetRange("Lot No.", '');
        OK := not rec.IsEmpty;
        rec.Copy(xTrackingSpec);
    end;


    procedure AssignSerialNo()
    var
        QtyToCreate: Decimal;
        QtyToCreateInt: Integer;
        CreateLotNo: Boolean;
    begin
        if ZeroLineExists then
            rec.Delete;

        QtyToCreate := UndefinedQtyArray[1] * QtySignFactor;
        if QtyToCreate < 0 then
            QtyToCreate := 0;

        if QtyToCreate mod 1 <> 0 then
            Error(Text008);

        QtyToCreateInt := QtyToCreate;
        /*
        CLEAR(EnterQuantityToCreate);
        EnterQuantityToCreate.LOOKUPMODE := TRUE;
        EnterQuantityToCreate.SetFields(rec."Item No.",rec."Variant Code",QtyToCreate,FALSE);
        IF EnterQuantityToCreate.RUNMODAL = ACTION::LookupOK THEN BEGIN
          EnterQuantityToCreate.GetFields(QtyToCreateInt,CreateLotNo);
          AssignSerialNoBatch(QtyToCreateInt,CreateLotNo);
        END;
        */

    end;


    procedure AssignSerialNoBatch(QtyToCreate: Integer; CreateLotNo: Boolean)
    var
        i: Integer;
    begin
        if QtyToCreate <= 0 then
            Error(Text009);
        if QtyToCreate mod 1 <> 0 then
            Error(Text008);

        GetItem(rec."Item No.");

        if CreateLotNo then begin
            rec.TestField(rec."Lot No.", '');
            Item.TestField("Lot Nos.");
            rec.Validate("Lot No.", NoSeriesMgt.GetNextNo(Item."Lot Nos.", WorkDate, true));
        end;

        Item.TestField("Serial Nos.");
        for i := 1 to QtyToCreate do begin
            rec.Validate("Serial No.", NoSeriesMgt.GetNextNo(Item."Serial Nos.", WorkDate, true));
            rec.Validate("Quantity (Base)", QtySignFactor);
            rec."Entry No." := NextEntryNo;
            TestTempSpecificationExists;
            rec.Insert;
            TempItemTrackLineInsert.TransferFields(rec);
            TempItemTrackLineInsert.Insert;
            ItemTrackingDataCollection.UpdateLotSNDataSetWithChange(
              TempItemTrackLineInsert, CurrentSignFactor * SourceQuantityArray[1] < 0, CurrentSignFactor, 0);
        end;
        CalculateSums;
    end;


    procedure AssignLotNo()
    var
        QtyToCreate: Decimal;
    begin
        if ZeroLineExists then
            rec.Delete;

        if (SourceQuantityArray[1] * UndefinedQtyArray[1] <= 0) or
           (Abs(SourceQuantityArray[1]) < Abs(UndefinedQtyArray[1]))
        then
            QtyToCreate := 0
        else
            QtyToCreate := UndefinedQtyArray[1];

        GetItem(rec."Item No.");

        Item.TestField("Lot Nos.");
        rec.Validate("Lot No.", NoSeriesMgt.GetNextNo(Item."Lot Nos.", WorkDate, true));
        rec."Qty. per Unit of Measure" := QtyPerUOM;
        rec.Validate("Quantity (Base)", QtyToCreate);
        rec."Entry No." := NextEntryNo;
        TestTempSpecificationExists;
        rec.Insert;
        TempItemTrackLineInsert.TransferFields(rec);
        TempItemTrackLineInsert.Insert;
        ItemTrackingDataCollection.UpdateLotSNDataSetWithChange(
          TempItemTrackLineInsert, CurrentSignFactor * SourceQuantityArray[1] < 0, CurrentSignFactor, 0);
        CalculateSums;
    end;


    procedure CreateCustomizedSN()
    var
        QtyToCreate: Decimal;
        QtyToCreateInt: Integer;
        Increment: Integer;
        CreateLotNo: Boolean;
        CustomizedSN: Code[20];
    begin
        if ZeroLineExists then
            rec.Delete;
        rec.TestField("Quantity Handled (Base)", 0);
        rec.TestField("Quantity Invoiced (Base)", 0);

        QtyToCreate := UndefinedQtyArray[1] * QtySignFactor;
        if QtyToCreate < 0 then
            QtyToCreate := 0;

        if QtyToCreate mod 1 <> 0 then
            Error(Text008);

        QtyToCreateInt := QtyToCreate;
        /*
        CLEAR(EnterCustomizedSN);
        EnterCustomizedSN.LOOKUPMODE := TRUE;
        EnterCustomizedSN.SetFields(rec."Item No.",rec."Variant Code",QtyToCreate,FALSE);
        IF EnterCustomizedSN.RUNMODAL = ACTION::LookupOK THEN BEGIN
          EnterCustomizedSN.GetFields(QtyToCreateInt,CreateLotNo,CustomizedSN,Increment);
          CreateCustomizedSNBatch(QtyToCreateInt,CreateLotNo,CustomizedSN,Increment);
        END;
        */
        CalculateSums;

    end;


    procedure CreateCustomizedSNBatch(QtyToCreate: Decimal; CreateLotNo: Boolean; CustomizedSN: Code[20]; Increment: Integer)
    var
        i: Integer;
        Counter: Integer;
    begin
        if IncStr(CustomizedSN) = '' then
            Error(Text013, CustomizedSN);
        NoSeriesMgt.TestManual(Item."Serial Nos.");

        rec.TestField("Quantity Handled (Base)", 0);
        rec.TestField("Quantity Invoiced (Base)", 0);

        if QtyToCreate <= 0 then
            Error(Text009);
        if QtyToCreate mod 1 <> 0 then
            Error(Text008);

        if CreateLotNo then begin
            rec.TestField("Lot No.", '');
            Item.TestField("Lot Nos.");
            rec.Validate("Lot No.", NoSeriesMgt.GetNextNo(Item."Lot Nos.", WorkDate, true));
        end;

        for i := 1 to QtyToCreate do begin
            rec.Validate("Serial No.", CustomizedSN);
            rec.Validate("Quantity (Base)", QtySignFactor);
            rec."Entry No." := NextEntryNo;
            TestTempSpecificationExists;
            rec.Insert;
            TempItemTrackLineInsert.TransferFields(rec);
            TempItemTrackLineInsert.Insert;
            ItemTrackingDataCollection.UpdateLotSNDataSetWithChange(
              TempItemTrackLineInsert, CurrentSignFactor * SourceQuantityArray[1] < 0, CurrentSignFactor, 0);
            if i < QtyToCreate then begin
                Counter := Increment;
                repeat
                    CustomizedSN := IncStr(CustomizedSN);
                    Counter := Counter - 1;
                until Counter <= 0;
            end;
        end;
        CalculateSums;
    end;


    procedure TestTempSpecificationExists() Exists: Boolean
    var
        TempSpecification: Record "Tracking Specification" temporary;
    begin
        TempSpecification.Copy(rec);
        rec.SetCurrentKey("Lot No.", rec."Serial No.");
        rec.SetRange("Serial No.", rec."Serial No.");
        if rec."Serial No." = '' then
            rec.SetRange("Lot No.", rec."Lot No.");
        rec.SetFilter("Entry No.", '<>%1', rec."Entry No.");
        rec.SetRange("Buffer Status", 0);
        Exists := not rec.IsEmpty;
        rec.Copy(TempSpecification);
        if Exists and CurrentFormIsOpen then;
        /*
          IF rec."Serial No." = '' THEN
            MESSAGE(
              Text011,
              rec.TABLECAPTION,rec.FIELDCAPTION("Serial No."),rec."Serial No.",
              rec.FIELDCAPTION("Lot No."),rec."Lot No.")
          ELSE
            MESSAGE(
              Text012,
              rec.TABLECAPTION,rec.FIELDCAPTION("Serial No."),rec."Serial No.");
        */

    end;

    local procedure QtySignFactor(): Integer
    begin
        if SourceQuantityArray[1] < 0 then
            exit(-1)
        else
            exit(1)
    end;


    procedure RegisterItemTrackingLines(SourceSpecification: Record "Tracking Specification"; AvailabilityDate: Date; var TempSpecification: Record "Tracking Specification" temporary)
    begin
        SourceSpecification.TestField("Source Type"); // Check if source has been set.
        if not CalledFromSynchWhseItemTrkg then
            TempSpecification.Reset;
        if not TempSpecification.Find('-') then
            exit;

        IsCorrection := SourceSpecification.Correction;
        SetSource(SourceSpecification, AvailabilityDate);
        rec.Reset;
        rec.SetCurrentKey("Lot No.", "Serial No.");

        repeat
            rec.SetRange("Lot No.", TempSpecification."Lot No.");
            rec.SetRange("Serial No.", TempSpecification."Serial No.");
            if rec.Find('-') then begin
                if IsCorrection then begin
                    rec."Quantity (Base)" :=
                      rec."Quantity (Base)" + TempSpecification."Quantity (Base)";
                    rec."Qty. to Handle (Base)" :=
                      rec."Qty. to Handle (Base)" + TempSpecification."Qty. to Handle (Base)";
                    rec."Qty. to Invoice (Base)" :=
                      rec."Qty. to Invoice (Base)" + TempSpecification."Qty. to Invoice (Base)";
                end else
                    rec.Validate("Quantity (Base)",
                      rec."Quantity (Base)" + TempSpecification."Quantity (Base)");
                rec.Modify;
            end else begin
                rec.TransferFields(SourceSpecification);
                rec."Serial No." := TempSpecification."Serial No.";
                rec."Lot No." := TempSpecification."Lot No.";
                rec."Warranty Date" := TempSpecification."Warranty Date";
                rec."Expiration Date" := TempSpecification."Expiration Date";
                rec.Validate("Quantity (Base)", TempSpecification."Quantity (Base)");
                rec."Entry No." := NextEntryNo;
                rec.Insert;
            end;
        until TempSpecification.Next = 0;
        rec.Reset;
        if rec.Find('-') then
            repeat
                CheckLine(rec);
            until rec.Next = 0;

        rec.SetRange("Lot No.", SourceSpecification."Lot No.");
        rec.SetRange("Serial No.", SourceSpecification."Serial No.");

        CalculateSums;
        if UpdateUndefinedQty then
            WriteToDatabase
        else
            Error(Text014, TotalItemTrackingLine."Quantity (Base)",
              LowerCase(TempReservEntry.TextCaption), SourceQuantityArray[1]);

        // Copy to inbound part of transfer
        if FormRunMode = FormRunMode::Transfer then
            SynchronizeLinkedSources('');
    end;


    procedure SynchronizeLinkedSources(DialogText: Text[250]): Boolean
    begin
        if CurrentSourceRowID = '' then
            exit(false);
        if SecondSourceRowID = '' then
            exit(false);

        //ItemTrackingMgt.SetFromEDI(TRUE);
        ItemTrackingMgt.SynchronizeItemTracking(CurrentSourceRowID, SecondSourceRowID, DialogText);
        exit(true);
    end;


    procedure SetBlockCommit(NewBlockCommit: Boolean)
    begin
        BlockCommit := NewBlockCommit;
    end;


    procedure BinContentItemTrackingInsert(TempItemTrackingLineNew: Record "Tracking Specification")
    begin
        rec := TempItemTrackingLineNew;
        rec."Entry No." := NextEntryNo;
        if (not InsertIsBlocked) and (not ZeroLineExists) then
            if not TestTempSpecificationExists then
                rec.Insert;
        MoveBinContent := true;
        WriteToDatabase;
    end;


    procedure TempItemTrackingDef(NewTrackingSpecification: Record "Tracking Specification")
    begin
        rec := NewTrackingSpecification;
        rec."Entry No." := NextEntryNo;
        if (not InsertIsBlocked) and (not ZeroLineExists) then
            if not TestTempSpecificationExists then
                rec.Insert
            else
                ModifyTrackingSpecification(NewTrackingSpecification);
        WriteToDatabase;
    end;

    local procedure CheckEntryIsReservation(Checktype: Option "Rename/Delete",Quantity; Messagetype: Option Error,Message) EntryIsReservation: Boolean
    var
        ReservEntry: Record "Reservation Entry";
        QtyToCheck: Decimal;
    begin
        with ReservEntry do begin
            SetCurrentKey(
              "Source ID", "Source Ref. No.", "Source Type", "Source Subtype",
              "Source Batch Name", "Source Prod. Order Line", "Reservation Status");
            SetRange("Source ID", rec."Source ID");
            SetRange("Source Ref. No.", rec."Source Ref. No.");
            SetRange("Source Type", rec."Source Type");
            SetRange("Source Subtype", rec."Source Subtype");
            SetRange("Source Batch Name", rec."Source Batch Name");
            SetRange("Source Prod. Order Line", rec."Source Prod. Order Line");
            SetRange("Reservation Status", "Reservation Status"::Reservation);
            SetRange("Serial No.", xrec."Serial No.");
            SetRange("Lot No.", xrec."Lot No.");
            if Find('-') then begin
                case Checktype of
                    Checktype::"Rename/Delete":
                        begin
                            EntryIsReservation := true;
                            case Messagetype of
                                Messagetype::Error:
                                    Error(Text000, TextCaption);
                                Messagetype::Message:
                                    ;// MESSAGE(Text000,TextCaption);
                            end;
                        end;
                    Checktype::Quantity:
                        begin
                            repeat
                                QtyToCheck := QtyToCheck + "Quantity (Base)";
                            until Next = 0;
                            if Abs(rec."Quantity (Base)") < Abs(QtyToCheck) then
                                Error(Text001, TextCaption, FieldCaption("Quantity (Base)"), Abs(QtyToCheck));
                        end;
                end;
            end;
        end;
    end;


    procedure SetCalledFromSynchWhseItemTrkg(CalledFromSynchWhseItemTrkg2: Boolean)
    begin
        CalledFromSynchWhseItemTrkg := CalledFromSynchWhseItemTrkg2;
    end;


    procedure ModifyTrackingSpecification(NewTrackingSpecification: Record "Tracking Specification")
    var
        CrntTempTrackingSpec: Record "Tracking Specification" temporary;
    begin
        CrntTempTrackingSpec.Copy(rec);
        rec.SetCurrentKey("Lot No.", "Serial No.");
        rec.SetRange("Lot No.", NewTrackingSpecification."Lot No.");
        rec.SetRange("Serial No.", NewTrackingSpecification."Serial No.");
        rec.SetFilter("Entry No.", '<>%1', rec."Entry No.");
        rec.SetRange("Buffer Status", 0);
        if rec.Find('-') then begin
            rec.Validate("Quantity (Base)",
              rec."Quantity (Base)" + NewTrackingSpecification."Quantity (Base)");
            rec.Modify;
        end;
        rec.Copy(CrntTempTrackingSpec);
    end;

    local procedure UpdateExpDateColor()
    begin
        //IF (Rec."Buffer Status2" = Rec."Buffer Status2"::"ExpDate blocked") OR (CurrentSignFactor < 0) THEN
        //CurrForm."Expiration Date".UPDATEFORECOLOR(8421504)
        //ELSE
        // CurrForm."Expiration Date".UPDATEFORECOLOR(0);
    end;

    local procedure UpdateExpDateEditable()
    begin
        //CurrForm."Expiration Date".EDITABLE(
        //NOT (("Buffer Status2" = "Buffer Status2"::"ExpDate blocked") OR (CurrentSignFactor < 0)));
    end;


    procedure LookupAvailable(LookupMode: Option "Serial No.","Lot No.")
    begin
        rec."Bin Code" := ForBinCode;
        ItemTrackingDataCollection.LookupLotSerialNoAvailability(rec, LookupMode);
        rec."Bin Code" := '';
        //CurrForm.UPDATE;
    end;


    procedure F6LookupAvailable()
    begin
        if SNAvailabilityActive then
            LookupAvailable(0);
        if LotAvailabilityActive then
            LookupAvailable(1);
    end;


    procedure LotSnAvailable(var TrackingSpecification: Record "Tracking Specification"; LookupMode: Option "Serial No.","Lot No."): Boolean
    begin
        exit(ItemTrackingDataCollection.LotSNAvailable(TrackingSpecification, LookupMode));
    end;


    procedure SelectEntries()
    var
        xTrackingSpec: Record "Tracking Specification";
        MaxQuantity: Decimal;
    begin
        xTrackingSpec.CopyFilters(rec);
        MaxQuantity := UndefinedQtyArray[1];
        if MaxQuantity * CurrentSignFactor > 0 then
            MaxQuantity := 0;
        rec."Bin Code" := ForBinCode;
        ItemTrackingDataCollection.SelectMultipleLotSerialNo(rec, MaxQuantity, CurrentSignFactor);
        rec."Bin Code" := '';
        if rec.FindSet then
            repeat
                case rec."Buffer Status" of
                    rec."Buffer Status"::MODIFY:
                        begin
                            if TempItemTrackLineModify.Get(rec."Entry No.") then
                                TempItemTrackLineModify.Delete;
                            if TempItemTrackLineInsert.Get(rec."Entry No.") then begin
                                TempItemTrackLineInsert.TransferFields(rec);
                                TempItemTrackLineInsert.Modify;
                            end else begin
                                TempItemTrackLineModify.TransferFields(rec);
                                TempItemTrackLineModify.Insert;
                            end;
                        end;
                    rec."Buffer Status"::INSERT:
                        begin
                            TempItemTrackLineInsert.TransferFields(rec);
                            TempItemTrackLineInsert.Insert;
                        end;
                end;
                rec."Buffer Status" := 0;
                rec.Modify;
            until rec.Next = 0;
        LastEntryNo := rec."Entry No.";
        CalculateSums;
        UpdateUndefinedQty;
        rec.CopyFilters(xTrackingSpec);
        //CurrForm.UPDATE(FALSE);
    end;


    procedure ReserveItemTrackingLine()
    var
        LateBindingMgt: Codeunit "Late Binding Management";
    begin
        LateBindingMgt.ReserveItemTrackingLine(rec);
    end;


    procedure ReestablishReservations()
    var
        LateBindingMgt: Codeunit "Late Binding Management";
    begin
        if TempItemTrackLineReserv.FindSet then
            repeat
                LateBindingMgt.ReserveItemTrackingLine2(TempItemTrackLineReserv, TempItemTrackLineReserv."Quantity (Base)");
                SetQtyToHandleAndInvoice(TempItemTrackLineReserv);
            until TempItemTrackLineReserv.Next = 0;
        TempItemTrackLineReserv.DeleteAll;
    end;


    procedure SetInbound(NewInbound: Boolean)
    begin
        Inbound := NewInbound;
    end;


    procedure InsertLine(CodPLotNo: array[999] of Code[20]; DecLQty: Decimal; RecLTrackingSpec: Record "Tracking Specification"): Boolean
    var
        i: Integer;
    begin
        //Copy of the "OnInsertRecord" Trigger of the form

        //IF rec."Entry No." <> 0 THEN
        //  EXIT(FALSE);


        i := 1;

        while CodPLotNo[i] <> '' do begin
            rec := RecLTrackingSpec;
            rec."Entry No." := NextEntryNo;

            rec."Qty. to Handle (Base)" := 0;
            rec."Qty. to Invoice (Base)" := 0;
            rec."Quantity Handled (Base)" := 0;
            rec."Quantity Invoiced (Base)" := 0;

            rec.Validate("Quantity (Base)", 1);
            rec.Validate(rec."Serial No.", CodPLotNo[i]);

            rec."Qty. per Unit of Measure" := QtyPerUOM;
            if (not InsertIsBlocked) and (not ZeroLineExists) then
                if not TestTempSpecificationExists then begin
                    TempItemTrackLineInsert.TransferFields(rec);
                    TempItemTrackLineInsert.Insert;
                    rec.Insert;
                    ItemTrackingDataCollection.UpdateLotSNDataSetWithChange(
                      TempItemTrackLineInsert, CurrentSignFactor * SourceQuantityArray[1] < 0, CurrentSignFactor, 0);
                end;
            CalculateSums;
            i += 1;
        end;


        //Copy of the "OnCloseForm" Trigger of the form ...
        if UpdateUndefinedQty then
            WriteToDatabase;


        if FormRunMode = FormRunMode::"Drop Shipment" then
            case CurrentSourceType of
                DATABASE::"Sales Line":
                    SynchronizeLinkedSources(StrSubstNo(Text015, Text016));
                DATABASE::"Purchase Line":
                    SynchronizeLinkedSources(StrSubstNo(Text015, Text017));
            end;

        // IF (CodLLotNo = 'P0002') THEN
        //   ERROR('Pas ici :P0002 Début 9');

        //>>
        if FormRunMode = FormRunMode::Countermark then
            SynchronizeLinkedSources('');//STRSUBSTNO(Text015,Text017));
        //<<
    end;


    procedure UpdateUndefinedQty2()
    begin
        UpdateUndefinedQty();
    end;


    procedure "---INTEGRATION.002---"()
    begin
    end;


    procedure InsertLine2(CodPSerialNo: array[999] of Code[20]; CodPLotNo: array[999] of Code[20]; DecLQty: Decimal; RecLTrackingSpec: Record "Tracking Specification"): Boolean
    var
        i: Integer;
    begin
        //>>INTEGRATION.002
        rec := RecLTrackingSpec;
        rec."Entry No." := NextEntryNo;

        rec."Qty. to Handle (Base)" := 0;
        rec."Qty. to Invoice (Base)" := 0;
        rec."Quantity Handled (Base)" := 0;
        rec."Quantity Invoiced (Base)" := 0;

        //rec.VALIDATE("Quantity (Base)",1);
        rec.Validate("Quantity (Base)", DecLQty);
        rec.Validate(rec."Serial No.", CodPSerialNo[1]);
        rec.Validate(rec."Lot No.", CodPLotNo[1]);
        rec."Qty. per Unit of Measure" := QtyPerUOM;
        if (not InsertIsBlocked) and (not ZeroLineExists) then
            if not TestTempSpecificationExists then begin
                TempItemTrackLineInsert.TransferFields(rec);
                TempItemTrackLineInsert.Insert;
                rec.Insert;
                ItemTrackingDataCollection.UpdateLotSNDataSetWithChange(
                  TempItemTrackLineInsert, CurrentSignFactor * SourceQuantityArray[1] < 0, CurrentSignFactor, 0);
            end;
        CalculateSums;

        if UpdateUndefinedQty then
            WriteToDatabase;


        if FormRunMode = FormRunMode::"Drop Shipment" then
            case CurrentSourceType of
                DATABASE::"Sales Line":
                    SynchronizeLinkedSources(StrSubstNo(Text015, Text016));
                DATABASE::"Purchase Line":
                    SynchronizeLinkedSources(StrSubstNo(Text015, Text017));
            end;

        if FormRunMode = FormRunMode::Countermark then
            SynchronizeLinkedSources('');//STRSUBSTNO(Text015,Text017));
        //<<INTEGRATION.002
    end;
}

