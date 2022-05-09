codeunit 50100 "PWD LPSA Tracking Management"
{
    // -----------------------------------------------------------------------------------------------------------------
    // Prodware : www.prodware.fr
    // -----------------------------------------------------------------------------------------------------------------
    // 
    // //>>EDI2.00
    // DEV-NAV-FLUX-EDI.001:GR 03/08/2010 : Dev Nav flux EDI
    //                                      - Create object (from F6510)
    // 
    // //>>EDI6.00
    // MIG-2009-001:LY 27/12/2011 : Merge from NAV5.00.01
    //                              - Upgrade C/AL (as current F6510))
    //                              - Define all differences with F6510 between start and stop comments
    // 
    // //>>FSA3.00
    // FE_FSACS_EDI_01_071111_ORDER.001:LY 30/12/2011 : EDI Order
    //                              - Add specific C/AL existing in P6510
    // -----------------------------------------------------------------------------------------------------------------


    trigger OnRun()
    begin
    end;

    var
        Item: Record Item;
        ItemTrackingCode: Record "Item Tracking Code";
        TempReservEntry: Record "Reservation Entry" temporary;
        Rec: Record "Tracking Specification" temporary;
        TempItemTrackLineDelete: Record "Tracking Specification" temporary;
        TempItemTrackLineInsert: Record "Tracking Specification" temporary;
        TempItemTrackLineModify: Record "Tracking Specification" temporary;
        TempItemTrackLineReserv: Record "Tracking Specification" temporary;
        TotalItemTrackingLine: Record "Tracking Specification";
        xRec: Record "Tracking Specification" temporary;
        xTempItemTrackingLine: Record "Tracking Specification" temporary;
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
        Text000: Label 'Reservation is defined for the %1.\You must cancel the existing Reservation before deleting or changing Item Tracking.';
        Text001: Label 'Reservation is defined for the %1.\You must not set %2 lower then %3.';
        Text002: Label 'Quantity must be %1.';
        Text003: Label 'negative';
        Text004: Label 'positive';
        Text005: Label 'Error when writing to database.';
        Text007: Label 'Another user has modified the item tracking data since it was retrieved from the database.\Start again.';
        Text008: Label 'The quantity to create must be an integer.';
        Text009: Label 'The quantity to create must be positive.';
        Text013: Label 'The string %1 contains no number and cannot be incremented.';
        Text014: Label 'The total item tracking quantity %1 exceeds the %2 quantity %3.\The changes cannot be saved to the database.';
        Text015: Label 'Do you want to synchronize item tracking on the line with item tracking on the related drop shipment %1?';
        Text016: Label 'purchase order line';
        Text017: Label 'sales order line';
        FormRunMode: Option ,Reclass,"Combined Ship/Rcpt","Drop Shipment",Transfer;
        CurrentEntryStatus: Enum "Reservation Status";
        CurrentSourceRowID: Text[100];
        SecondSourceRowID: Text[100];
        CurrentSourceCaption: Text[255];


    procedure SetFormRunMode(Mode: Option ,Reclass,"Combined Ship/Rcpt","Drop Shipment")
    begin
        FormRunMode := Mode;
        //>>MIG-2009-001
        CurrentFormIsOpen := true;
        //<<MIG-2009-001
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
        TempTrackingSpecification.DeleteAll();
        TempItemTrackLineInsert.DeleteAll();
        TempItemTrackLineModify.DeleteAll();
        TempItemTrackLineDelete.DeleteAll();

        TempReservEntry.DeleteAll();
        LastEntryNo := 0;
        if ItemTrackingMgt.IsOrderNetworkEntity(TrackingSpecification."Source Type",
             TrackingSpecification."Source Subtype") and not (FormRunMode = FormRunMode::"Drop Shipment")
        then
            CurrentEntryStatus := CurrentEntryStatus::Surplus
        else
            CurrentEntryStatus := CurrentEntryStatus::Prospect;

        if (TrackingSpecification."Source Type" in
            [DATABASE::"Item Ledger Entry",
            DATABASE::"Item Journal Line",
            DATABASE::"Job Journal Line",
            //DATABASE::"BOM Journal Line", //TODO: Table "BOM Journal Line" n'est plus disponible dans la nouvelle version
            DATABASE::"Requisition Line"]) or
           ((TrackingSpecification."Source Type" in [DATABASE::"Sales Line", DATABASE::"Purchase Line", DATABASE::"Service Line"]) and
            (TrackingSpecification."Source Subtype" in [0, 2, 3]))
        then
            SetControls(Controls::Handle, false)
        else
            SetControls(Controls::Handle, true);

        if (TrackingSpecification."Source Type" in
            [DATABASE::"Item Ledger Entry",
            DATABASE::"Item Journal Line",
            DATABASE::"Job Journal Line",
            //DATABASE::"BOM Journal Line", //TODO: Table "BOM Journal Line" n'est plus disponible dans la nouvelle version
            DATABASE::"Requisition Line",
            DATABASE::"Transfer Line",
            DATABASE::"Prod. Order Line",
            DATABASE::"Prod. Order Component"]) or
           ((TrackingSpecification."Source Type" in [DATABASE::"Sales Line", DATABASE::"Purchase Line", DATABASE::"Service Line"]) and
            (TrackingSpecification."Source Subtype" in [0, 2, 3, 4]))
        then
            SetControls(Controls::Invoice, false)
        else
            SetControls(Controls::Invoice, true);

        SetControls(Controls::Reclass, FormRunMode = FormRunMode::Reclass);

        if FormRunMode = FormRunMode::"Combined Ship/Rcpt" then
            SetControls(Controls::LotSN, false);
        if ItemTrackingMgt.ItemTrkgIsManagedByWhse(
          TrackingSpecification."Source Type",
          TrackingSpecification."Source Subtype",
          TrackingSpecification."Source ID",
          TrackingSpecification."Source Prod. Order Line",
          TrackingSpecification."Source Ref. No.",
          TrackingSpecification."Location Code",
          TrackingSpecification."Item No.")
        then
            SetControls(Controls::Quantity, false);
        //>>MIG-2009-001
        //CurrForm."Qty. to Handle (Base)".EDITABLE(TRUE);
        //<<MIG-2009-001
        // DeleteIsBlocked := true;
        // end;

        ReservEntry."Source Type" := TrackingSpecification."Source Type";
        ReservEntry."Source Subtype" := TrackingSpecification."Source Subtype";
        CurrentSignFactor := CreateReservEntry.SignFactor(ReservEntry);
        CurrentSourceCaption := ReservEntry.TextCaption();
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
            // DeleteIsBlocked := true;
            SetControls(Controls::Quantity, false);
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

        if TrackingSpecification.FindSet() then
            repeat
                TempTrackingSpecification := TrackingSpecification;
                TempTrackingSpecification.Insert();
            until TrackingSpecification.Next() = 0;

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
        CalculateSums();

        ItemTrackingDataCollection.SetCurrentBinAndItemTrkgCode(ForBinCode, ItemTrackingCode);
        ItemTrackingDataCollection.RetrieveLookupData(Rec, false);

        //>>MIG-2009-001
        //CurrForm.FunctionsDemand.VISIBLE(CurrentSignFactor * SourceQuantityArray[1] < 0);
        //CurrForm.FunctionsSupply.VISIBLE(NOT CurrForm.FunctionsDemand.VISIBLE);
        //<<MIG-2009-001
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
                    SetControls(Controls::Invoice, false);
                end;
            else
                exit;
        end;
        CalculateSums();
    end;


    procedure SetSecondSourceRowID(RowID: Text[100])
    begin
        SecondSourceRowID := RowID;
    end;

    local procedure AddReservEntriesToTempRecSet(var ReservEntry: Record "Reservation Entry"; var TempTrackingSpecification: Record "Tracking Specification" temporary; SwapSign: Boolean; Color: Integer)
    begin
        if ReservEntry.FindSet() then
            repeat
                if Color = 0 then begin
                    TempReservEntry := ReservEntry;
                    TempReservEntry.Insert();
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
                    TempTrackingSpecification.Insert();
                end;
            until ReservEntry.Next() = 0;
    end;

    local procedure AddToGlobalRecordSet(var TempTrackingSpecification: Record "Tracking Specification" temporary)
    var
        ItemTrackingSetup: Record "Item Tracking Setup";
        EntriesExist: Boolean;
        ExpDate: Date;
    begin
        TempTrackingSpecification.SetCurrentKey("Lot No.", "Serial No.");
        if TempTrackingSpecification.Find('-') then
            repeat
                TempTrackingSpecification.SetRange("Lot No.", TempTrackingSpecification."Lot No.");
                TempTrackingSpecification.SetRange("Serial No.", TempTrackingSpecification."Serial No.");
                TempTrackingSpecification.CalcSums("Quantity (Base)", "Qty. to Handle (Base)",
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

                ItemTrackingSetup."Serial No." := Rec."Serial No.";
                ItemTrackingSetup."Lot No." := Rec."Lot No.";
                ExpDate := ItemTrackingMgt.ExistingExpirationDate(
                  Rec."Item No.", Rec."Variant Code",
                  ItemTrackingSetup, false, EntriesExist);

                if ExpDate <> 0D then begin
                    Rec."Expiration Date" := ExpDate;
                    Rec."Buffer Status2" := Rec."Buffer Status2"::"ExpDate blocked";
                end;

                Rec.Insert();
                if Rec."Buffer Status" = 0 then begin
                    xTempItemTrackingLine := Rec;
                    xTempItemTrackingLine.Insert();
                end;
                TempTrackingSpecification.Find('+');
                TempTrackingSpecification.SetRange("Lot No.");
                TempTrackingSpecification.SetRange("Serial No.");
            until TempTrackingSpecification.Next() = 0;
    end;

    local procedure SetControls(Controls: Option Handle,Invoice,Quantity,Reclass,LotSN; SetAccess: Boolean)
    begin
        //>>MIG-2009-001
        /*
        CASE Controls OF
          Controls::Handle:
            BEGIN
              CurrForm.Handle0.VISIBLE(SetAccess);
              CurrForm.Handle1.VISIBLE(SetAccess);
              CurrForm.Handle2.VISIBLE(SetAccess);
              CurrForm.Handle3.VISIBLE(SetAccess);
              CurrForm."Qty. to Handle (Base)".VISIBLE(SetAccess);
              CurrForm."Qty. to Handle (Base)".EDITABLE(SetAccess);
            END;
          Controls::Invoice:
            BEGIN
              CurrForm.Invoice0.VISIBLE(SetAccess);
              CurrForm.Invoice1.VISIBLE(SetAccess);
              CurrForm.Invoice2.VISIBLE(SetAccess);
              CurrForm.Invoice3.VISIBLE(SetAccess);
              CurrForm."Qty. to Invoice (Base)".VISIBLE(SetAccess);
              CurrForm."Qty. to Invoice (Base)".EDITABLE(SetAccess);
            END;
          Controls::Quantity:
            BEGIN
              CurrForm."Quantity (Base)".EDITABLE(SetAccess);
              CurrForm."Serial No.".EDITABLE(SetAccess);
              CurrForm."Lot No.".EDITABLE(SetAccess);
              CurrForm.Description.EDITABLE(SetAccess);
              InsertIsBlocked := TRUE;
            END;
          Controls::Reclass:
            BEGIN
              CurrForm."New Serial No.".VISIBLE(SetAccess);
              CurrForm."New Serial No.".EDITABLE(SetAccess);
              CurrForm."New Lot No.".VISIBLE(SetAccess);
              CurrForm."New Lot No.".EDITABLE(SetAccess);
              CurrForm."New Expiration Date".VISIBLE(SetAccess);
              CurrForm."New Expiration Date".EDITABLE(SetAccess);
              CurrForm.ButtonLineReclass.VISIBLE(SetAccess);
              CurrForm.ButtonLine.VISIBLE(NOT SetAccess);
            END;
          Controls::LotSN:
            BEGIN
              CurrForm."Serial No.".EDITABLE(SetAccess);
              CurrForm."Lot No.".EDITABLE(SetAccess);
              CurrForm."Expiration Date".EDITABLE(SetAccess);
              CurrForm."Warranty Date".EDITABLE(SetAccess);
              InsertIsBlocked := SetAccess;
            END;
        END;
        */
        //<<MIG-2009-001

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
        Rec.FilterGroup := 2;
        Rec.SetCurrentKey("Source ID", "Source Type", "Source Subtype", "Source Batch Name", "Source Prod. Order Line", "Source Ref. No.");
        Rec.SetRange("Source ID", TrackingSpecification."Source ID");
        Rec.SetRange("Source Type", TrackingSpecification."Source Type");
        Rec.SetRange("Source Subtype", TrackingSpecification."Source Subtype");
        Rec.SetRange("Source Batch Name", TrackingSpecification."Source Batch Name");
        if (TrackingSpecification."Source Type" = DATABASE::"Transfer Line") and
           (TrackingSpecification."Source Subtype" = 1) then begin
            Rec.SetRange("Source Prod. Order Line", TrackingSpecification."Source Ref. No.");
            Rec.SetRange("Source Ref. No.");
        end else begin
            Rec.SetRange("Source Prod. Order Line", TrackingSpecification."Source Prod. Order Line");
            Rec.SetRange("Source Ref. No.", TrackingSpecification."Source Ref. No.");
        end;
        Rec.SetRange("Item No.", TrackingSpecification."Item No.");
        Rec.SetRange("Location Code", TrackingSpecification."Location Code");
        Rec.SetRange("Variant Code", TrackingSpecification."Variant Code");
        Rec.FilterGroup := 0;
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
        xTrackingSpec.Copy(Rec);
        Rec.Reset();
        Rec.CalcSums("Quantity (Base)",
          Rec."Qty. to Handle (Base)",
          Rec."Qty. to Invoice (Base)");
        TotalItemTrackingLine := Rec;
        Rec.Copy(xTrackingSpec);

        UpdateUndefinedQty();
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
        IdenticalArray: array[2] of Boolean;
        RecordCount: Integer;
    begin
        OK := false;
        TempReservEntry.SetCurrentKey("Entry No.", Positive);
        ReservEntry.SetCurrentKey("Source ID", "Source Ref. No.", "Source Type",
          "Source Subtype", "Source Batch Name", "Source Prod. Order Line");
        ReservEntry.CopyFilters(TempReservEntry);

        if ReservEntry.FindSet() then
            repeat
                if not TempReservEntry.Get(ReservEntry."Entry No.", ReservEntry.Positive) then
                    exit(false);
                if not EntriesAreIdentical(ReservEntry, TempReservEntry, IdenticalArray) then
                    exit(false);
                RecordCount += 1;
            until ReservEntry.Next() = 0;

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
        Decrease: Boolean;
        EntryNo: Integer;
        i: Integer;
        ModifyLoop: Integer;
        // NoOfLines: Integer;
        ChangeType: Option Insert,Modify,Delete;
    begin
        if CurrentFormIsOpen then begin
            TempReservEntry.LockTable();
            if not TempRecIsValid() then
                Error(Text007);

            if Item."Order Tracking Policy" = Item."Order Tracking Policy"::None then
                QtyToAddAsBlank := 0
            else
                QtyToAddAsBlank := UndefinedQtyArray[1] * CurrentSignFactor;

            Rec.Reset();
            Rec.DeleteAll();

            //>>MIG-2009-001
            //Window.OPEN('#1############# @2@@@@@@@@@@@@@@@@@@@@@');
            //Window.UPDATE(1,Text018);
            //<<MIG-2009-001
            // NoOfLines := TempItemTrackLineInsert.Count + TempItemTrackLineModify.Count + TempItemTrackLineDelete.Count;
            if TempItemTrackLineDelete.Find('-') then begin
                repeat
                    i := i + 1;
                    //>>MIG-2009-001
                    //IF i MOD 100 = 0 THEN
                    //  Window.UPDATE(2,ROUND(i / NoOfLines * 10000,1));
                    //<<MIG-2009-001
                    RegisterChange(TempItemTrackLineDelete, TempItemTrackLineDelete, ChangeType::Delete, false);
                    if TempItemTrackLineModify.Get(TempItemTrackLineDelete."Entry No.") then
                        TempItemTrackLineModify.Delete();
                until TempItemTrackLineDelete.Next() = 0;
                TempItemTrackLineDelete.DeleteAll();
            end;

            for ModifyLoop := 1 to 2 do
                if TempItemTrackLineModify.Find('-') then
                    repeat
                        if xTempItemTrackingLine.Get(TempItemTrackLineModify."Entry No.") then begin
                            // Process decreases before increases
                            Decrease := (xTempItemTrackingLine."Quantity (Base)" > TempItemTrackLineModify."Quantity (Base)");
                            if ((ModifyLoop = 1) and Decrease) or ((ModifyLoop = 2) and not Decrease) then begin
                                i := i + 1;
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
                                TempItemTrackLineModify.Delete();
                            end;
                        end else begin
                            i := i + 1;
                            TempItemTrackLineModify.Delete();
                        end;
                    //>>MIG-2009-001
                    //IF i MOD 100 = 0 THEN
                    //  Window.UPDATE(2,ROUND(i / NoOfLines * 10000,1));
                    //<<MIG-2009-001
                    until TempItemTrackLineModify.Next() = 0;

            if TempItemTrackLineInsert.Find('-') then begin
                repeat
                    i := i + 1;
                    //>>MIG-2009-001
                    //IF i MOD 100 = 0 THEN
                    //  Window.UPDATE(2,ROUND(i / NoOfLines * 10000,1));
                    //<<MIG-2009-001
                    if TempItemTrackLineModify.Get(TempItemTrackLineInsert."Entry No.") then
                        TempItemTrackLineInsert.TransferFields(TempItemTrackLineModify);
                    if not RegisterChange(TempItemTrackLineInsert, TempItemTrackLineInsert, ChangeType::Insert, false) then
                        Error(Text005);
                    if (TempItemTrackLineInsert."Quantity (Base)" <> TempItemTrackLineInsert."Qty. to Handle (Base)") or
                       (TempItemTrackLineInsert."Quantity (Base)" <> TempItemTrackLineInsert."Qty. to Invoice (Base)")
                    then
                        SetQtyToHandleAndInvoice(TempItemTrackLineInsert);
                until TempItemTrackLineInsert.Next() = 0;
                TempItemTrackLineInsert.DeleteAll();
            end;
            //>>MIG-2009-001
            //Window.CLOSE;
            //<<MIG-2009-001

        end else begin

            TempReservEntry.LockTable();
            if not TempRecIsValid() then
                Error(Text007);

            if Item."Order Tracking Policy" = Item."Order Tracking Policy"::None then
                QtyToAddAsBlank := 0
            else
                QtyToAddAsBlank := UndefinedQtyArray[1] * CurrentSignFactor;

            Rec.Reset();
            Rec.SetFilter("Buffer Status", '<>%1', 0);
            Rec.DeleteAll();
            Rec.Reset();

            xTempItemTrackingLine.Reset();
            Rec.SetCurrentKey("Entry No.");
            xTempItemTrackingLine.SetCurrentKey("Entry No.");
            if xTempItemTrackingLine.Find('-') then
                repeat
                    Rec.SetRange("Lot No.", xTempItemTrackingLine."Lot No.");
                    Rec.SetRange("Serial No.", xTempItemTrackingLine."Serial No.");
                    if Rec.Find('-') then begin
                        if RegisterChange(xTempItemTrackingLine, Rec, ChangeType::Modify, false) then begin
                            EntryNo := xTempItemTrackingLine."Entry No.";
                            xTempItemTrackingLine := Rec;
                            xTempItemTrackingLine."Entry No." := EntryNo;
                            xTempItemTrackingLine.Modify();
                        end;
                        SetQtyToHandleAndInvoice(Rec);
                        Rec.Delete();
                    end else begin
                        RegisterChange(xTempItemTrackingLine, xTempItemTrackingLine, ChangeType::Delete, false);
                        xTempItemTrackingLine.Delete();
                    end;
                until xTempItemTrackingLine.Next() = 0;

            Rec.Reset();

            if Rec.Find('-') then
                repeat
                    if RegisterChange(Rec, Rec, ChangeType::Insert, false) then begin
                        xTempItemTrackingLine := Rec;
                        xTempItemTrackingLine.Insert();
                    end else
                        Error(Text005);
                    SetQtyToHandleAndInvoice(Rec);
                    Rec.Delete();
                until Rec.Next() = 0;

        end;

        UpdateOrderTracking();
        ReestablishReservations(); // Late Binding

        if not BlockCommit then
            Commit();
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
        OK := false;

        if (CurrentSignFactor * NewTrackingSpecification."Qty. to Handle") < 0 then
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
                        ItemTrackingCode);
                    TempReservEntry.SetRange("Serial No.");
                    TempReservEntry.SetRange("Lot No.");

                    // Late Binding
                    if ReservEngineMgt.RetrieveLostReservQty(LostReservQty) then begin
                        TempItemTrackLineReserv := NewTrackingSpecification;
                        TempItemTrackLineReserv."Quantity (Base)" := LostReservQty * CurrentSignFactor;
                        TempItemTrackLineReserv.Insert();
                    end;

                    if OldTrackingSpecification."Quantity (Base)" = 0 then
                        exit(true);

                    if FormRunMode = FormRunMode::Reclass then begin
                        CreateReservEntry.SetNewTrackingFromNewTrackingSpecification(OldTrackingSpecification);
                        CreateReservEntry.SetNewExpirationDate(OldTrackingSpecification."New Expiration Date");
                    end;
                    CreateReservEntry.SetDates(
                      NewTrackingSpecification."Warranty Date", NewTrackingSpecification."Expiration Date");
                    CreateReservEntry.SetApplyFromEntryNo(
                      NewTrackingSpecification."Appl.-from Item Entry");
                    CreateReservEntry.SetApplyToEntryNo(NewTrackingSpecification."Appl.-to Item Entry");
                    ReservEntry1.CopyTrackingFromSpec(OldTrackingSpecification);
                    CreateReservEntry.CreateReservEntryFor(
                      OldTrackingSpecification."Source Type",
                      OldTrackingSpecification."Source Subtype",
                      OldTrackingSpecification."Source ID",
                      OldTrackingSpecification."Source Batch Name",
                      OldTrackingSpecification."Source Prod. Order Line",
                      OldTrackingSpecification."Source Ref. No.",
                      OldTrackingSpecification."Qty. per Unit of Measure",
                      0,
                      OldTrackingSpecification."Quantity (Base)",
                      ReservEntry1);
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
                        ReservEntry1.SetPointerFilter();
                        ReservEntry1.SetRange("Lot No.", ReservEntry1."Lot No.");
                        ReservEntry1.SetRange("Serial No.", ReservEntry1."Serial No.");
                        ReservEntry1.SetFilter("Entry No.", '<>%1', ReservEntry1."Entry No.");
                        ModifyFieldsWithinFilter(ReservEntry1, NewTrackingSpecification);
                    end;

                    // if CurrentSignFactor < 0 then
                    //     AvailabilityDate := ShipmentDate
                    // else
                    //     AvailabilityDate := ExpectedReceiptDate;
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
                            ItemTrackingCode);
                        TempReservEntry.SetRange("Serial No.");
                        TempReservEntry.SetRange("Lot No.");

                        // Late Binding
                        if ReservEngineMgt.RetrieveLostReservQty(LostReservQty) then begin
                            TempItemTrackLineReserv := NewTrackingSpecification;
                            TempItemTrackLineReserv."Quantity (Base)" := LostReservQty * CurrentSignFactor;
                            TempItemTrackLineReserv.Insert();
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
                            ItemTrackingCode);
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
                    ReservEntry1.SetPointerFilter();
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
                            ItemTrackingCode);
                        TempReservEntry.SetRange("Serial No.");
                        TempReservEntry.SetRange("Lot No.");
                        ReservationMgt.DeleteReservEntries(true, 0, ReservEntry1)
                    end else begin
                        ReservationMgt.DeleteReservEntries(false, ReservEntry1."Quantity (Base)" -
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
                ReservEntry1.Modify();
            until ReservEntry1.Next() = 0;
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
        ReservEntry1.SetPointerFilter();
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
                            TrackingSpecification.Modify();
                        end;

                        TotalQtyToInvoice -= QtyToInvoiceThisLine;
                    end;
                until (TrackingSpecification.Next() = 0);

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
                            ReservEntry1.Modify();
                        end;

                        TotalQtyToHandle -= QtyToHandleThisLine;
                        TotalQtyToInvoice -= QtyToInvoiceThisLine;

                    until (ReservEntry1.Next() = 0);
            end;

            OK := ((TotalQtyToHandle = 0) and (TotalQtyToInvoice = 0));
        end else
            if ReservEntry1.Find('-') then
                if (ReservEntry1."Qty. to Handle (Base)" <> TotalQtyToHandle) or
                   (ReservEntry1."Qty. to Invoice (Base)" <> TotalQtyToInvoice) and not ReservEntry1.Correction
                then begin
                    ReservEntry1."Qty. to Handle (Base)" := TotalQtyToHandle;
                    ReservEntry1."Qty. to Invoice (Base)" := TotalQtyToInvoice;
                    ReservEntry1.Modify();
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


                ItemEntryRelation.SetRange("Source Type", DATABASE::"Transfer Shipment Line");
            1: // Inbound


                ItemEntryRelation.SetRange("Source Type", DATABASE::"Transfer Receipt Line");
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
                TempTrackingSpecification.InitQtyToShip();
                TempTrackingSpecification.Insert();
            until ItemEntryRelation.Next() = 0;
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

        ItemLedgerEntry.SetCurrentKey("Order No.", "Order Line No.", "Entry Type");
        ItemLedgerEntry.SetRange("Order No.", TrackingSpecification."Source ID");
        ItemLedgerEntry.SetRange("Order Line No.", TrackingSpecification."Source Prod. Order Line");
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
                TempTrackingSpecification.InitQtyToShip();
                TempTrackingSpecification.Insert();

                if BackwardFlushing then begin
                    SourceQuantityArray[1] += ItemLedgerEntry.Quantity;
                    SourceQuantityArray[2] += ItemLedgerEntry.Quantity;
                    SourceQuantityArray[3] += ItemLedgerEntry.Quantity;
                end;

            until ItemLedgerEntry.Next() = 0;
    end;

    local procedure ZeroLineExists() OK: Boolean
    var
        xTrackingSpec: Record "Tracking Specification";
    begin
        if (Rec."Quantity (Base)" <> 0) or (Rec."Serial No." <> '') or (Rec."Lot No." <> '') then
            exit(false);
        xTrackingSpec.Copy(Rec);
        Rec.Reset();
        Rec.SetRange("Quantity (Base)", 0);
        Rec.SetRange("Serial No.", '');
        Rec.SetRange("Lot No.", '');
        OK := not Rec.IsEmpty;
        Rec.Copy(xTrackingSpec);
    end;


    procedure AssignSerialNo()
    var
        QtyToCreate: Decimal;
    // QtyToCreateInt: Integer;
    begin
        if ZeroLineExists() then
            Rec.Delete();

        QtyToCreate := UndefinedQtyArray[1] * QtySignFactor();
        if QtyToCreate < 0 then
            QtyToCreate := 0;

        if QtyToCreate mod 1 <> 0 then
            Error(Text008);

        // QtyToCreateInt := QtyToCreate;
        //>>MIG-2009-001
        /*
        CLEAR(EnterQuantityToCreate);
        EnterQuantityToCreate.LOOKUPMODE := TRUE;
        EnterQuantityToCreate.SetFields(Rec."Item No.",Rec."Variant Code",QtyToCreate,FALSE);
        IF EnterQuantityToCreate.RUNMODAL = ACTION::LookupOK THEN BEGIN
          EnterQuantityToCreate.GetFields(QtyToCreateInt,CreateLotNo);
          AssignSerialNoBatch(QtyToCreateInt,CreateLotNo);
        END;
        */
        //<<MIG-2009-001

    end;


    procedure AssignSerialNoBatch(QtyToCreate: Integer; CreateLotNo: Boolean)
    var
        i: Integer;
    begin
        if QtyToCreate <= 0 then
            Error(Text009);
        if QtyToCreate mod 1 <> 0 then
            Error(Text008);

        GetItem(Rec."Item No.");

        if CreateLotNo then begin
            Rec.TestField("Lot No.", '');
            Item.TestField("Lot Nos.");
            Rec.Validate("Lot No.", NoSeriesMgt.GetNextNo(Item."Lot Nos.", WorkDate(), true));
        end;

        Item.TestField("Serial Nos.");
        for i := 1 to QtyToCreate do begin
            Rec.Validate("Serial No.", NoSeriesMgt.GetNextNo(Item."Serial Nos.", WorkDate(), true));
            Rec.Validate("Quantity (Base)", QtySignFactor());
            Rec."Entry No." := NextEntryNo();
            if TestTempSpecificationExists() then
                Error('');
            Rec.Insert();
            TempItemTrackLineInsert.TransferFields(Rec);
            TempItemTrackLineInsert.Insert();
            ItemTrackingDataCollection.UpdateTrackingDataSetWithChange(
              TempItemTrackLineInsert, CurrentSignFactor * SourceQuantityArray[1] < 0, CurrentSignFactor, 0);
        end;
        CalculateSums();
    end;


    procedure AssignLotNo()
    var
        QtyToCreate: Decimal;
    begin
        if ZeroLineExists() then
            Rec.Delete();

        if (SourceQuantityArray[1] * UndefinedQtyArray[1] <= 0) or
           (Abs(SourceQuantityArray[1]) < Abs(UndefinedQtyArray[1]))
        then
            QtyToCreate := 0
        else
            QtyToCreate := UndefinedQtyArray[1];

        GetItem(Rec."Item No.");

        Item.TestField("Lot Nos.");
        Rec.Validate("Lot No.", NoSeriesMgt.GetNextNo(Item."Lot Nos.", WorkDate(), true));
        Rec."Qty. per Unit of Measure" := QtyPerUOM;
        Rec.Validate("Quantity (Base)", QtyToCreate);
        Rec."Entry No." := NextEntryNo();
        TestTempSpecificationExists();
        Rec.Insert();
        TempItemTrackLineInsert.TransferFields(Rec);
        TempItemTrackLineInsert.Insert();
        ItemTrackingDataCollection.UpdateTrackingDataSetWithChange(
          TempItemTrackLineInsert, CurrentSignFactor * SourceQuantityArray[1] < 0, CurrentSignFactor, 0);
        CalculateSums();
    end;


    procedure CreateCustomizedSN()
    var
        QtyToCreate: Decimal;
    // QtyToCreateInt: Integer;
    begin
        if ZeroLineExists() then
            Rec.Delete();
        Rec.TestField("Quantity Handled (Base)", 0);
        Rec.TestField("Quantity Invoiced (Base)", 0);

        QtyToCreate := UndefinedQtyArray[1] * QtySignFactor();
        if QtyToCreate < 0 then
            QtyToCreate := 0;

        if QtyToCreate mod 1 <> 0 then
            Error(Text008);

        // QtyToCreateInt := QtyToCreate;
        //>>MIG-2009-001
        /*
        CLEAR(EnterCustomizedSN);
        EnterCustomizedSN.LOOKUPMODE := TRUE;
        EnterCustomizedSN.SetFields(Rec."Item No.",Rec."Variant Code",QtyToCreate,FALSE);
        IF EnterCustomizedSN.RUNMODAL = ACTION::LookupOK THEN BEGIN
          EnterCustomizedSN.GetFields(QtyToCreateInt,CreateLotNo,CustomizedSN,Increment);
          CreateCustomizedSNBatch(QtyToCreateInt,CreateLotNo,CustomizedSN,Increment);
        END;
        */
        //<<MIG-2009-001
        CalculateSums();

    end;


    procedure CreateCustomizedSNBatch(QtyToCreate: Decimal; CreateLotNo: Boolean; CustomizedSN: Code[20]; Increment: Integer)
    var
        Counter: Integer;
        i: Integer;
    begin
        if IncStr(CustomizedSN) = '' then
            Error(Text013, CustomizedSN);
        NoSeriesMgt.TestManual(Item."Serial Nos.");

        Rec.TestField("Quantity Handled (Base)", 0);
        Rec.TestField("Quantity Invoiced (Base)", 0);

        if QtyToCreate <= 0 then
            Error(Text009);
        if QtyToCreate mod 1 <> 0 then
            Error(Text008);

        if CreateLotNo then begin
            Rec.TestField("Lot No.", '');
            Item.TestField("Lot Nos.");
            Rec.Validate("Lot No.", NoSeriesMgt.GetNextNo(Item."Lot Nos.", WorkDate(), true));
        end;

        for i := 1 to QtyToCreate do begin
            Rec.Validate("Serial No.", CustomizedSN);
            Rec.Validate("Quantity (Base)", QtySignFactor());
            Rec."Entry No." := NextEntryNo();
            if TestTempSpecificationExists() then
                Error('');
            Rec.Insert();
            TempItemTrackLineInsert.TransferFields(Rec);
            TempItemTrackLineInsert.Insert();
            ItemTrackingDataCollection.UpdateTrackingDataSetWithChange(
              TempItemTrackLineInsert, CurrentSignFactor * SourceQuantityArray[1] < 0, CurrentSignFactor, 0);
            if i < QtyToCreate then begin
                Counter := Increment;
                repeat
                    CustomizedSN := IncStr(CustomizedSN);
                    Counter := Counter - 1;
                until Counter <= 0;
            end;
        end;
        CalculateSums();
    end;


    procedure TestTempSpecificationExists() Exists: Boolean
    var
        TempSpecification: Record "Tracking Specification" temporary;
    begin
        TempSpecification.Copy(Rec);
        Rec.SetCurrentKey("Lot No.", Rec."Serial No.");
        Rec.SetRange("Serial No.", Rec."Serial No.");
        if Rec."Serial No." = '' then
            Rec.SetRange("Lot No.", Rec."Lot No.");
        Rec.SetFilter("Entry No.", '<>%1', Rec."Entry No.");
        Rec.SetRange("Buffer Status", 0);
        Exists := not Rec.IsEmpty;
        Rec.Copy(TempSpecification);
        //>>MIG-2009-001
        /*
        IF Exists AND CurrentFormIsOpen THEN
          IF Rec."Serial No." = '' THEN
            MESSAGE(
              Text011,
              Rec.TABLECAPTION,Rec.FIELDCAPTION("Serial No."),Rec."Serial No.",
              Rec.FIELDCAPTION("Lot No."),Rec."Lot No.")
          ELSE
            MESSAGE(
              Text012,
              Rec.TABLECAPTION,Rec.FIELDCAPTION("Serial No."),Rec."Serial No.");
        */
        if Exists and CurrentFormIsOpen then;
        //<<MIG-2009-001

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
            TempSpecification.Reset();
        if not TempSpecification.Find('-') then
            exit;

        IsCorrection := SourceSpecification.Correction;
        SetSource(SourceSpecification, AvailabilityDate);
        Rec.Reset();
        Rec.SetCurrentKey("Lot No.", "Serial No.");

        repeat
            Rec.SetRange("Lot No.", TempSpecification."Lot No.");
            Rec.SetRange("Serial No.", TempSpecification."Serial No.");
            if Rec.Find('-') then begin
                if IsCorrection then begin
                    Rec."Quantity (Base)" :=
                      Rec."Quantity (Base)" + TempSpecification."Quantity (Base)";
                    Rec."Qty. to Handle (Base)" :=
                      Rec."Qty. to Handle (Base)" + TempSpecification."Qty. to Handle (Base)";
                    Rec."Qty. to Invoice (Base)" :=
                      Rec."Qty. to Invoice (Base)" + TempSpecification."Qty. to Invoice (Base)";
                end else
                    Rec.Validate("Quantity (Base)",
                      Rec."Quantity (Base)" + TempSpecification."Quantity (Base)");
                Rec.Modify();
            end else begin
                Rec.TransferFields(SourceSpecification);
                Rec."Serial No." := TempSpecification."Serial No.";
                Rec."Lot No." := TempSpecification."Lot No.";
                Rec."Warranty Date" := TempSpecification."Warranty Date";
                Rec."Expiration Date" := TempSpecification."Expiration Date";
                if FormRunMode = FormRunMode::Reclass then begin
                    Rec."New Serial No." := TempSpecification."New Serial No.";
                    Rec."New Lot No." := TempSpecification."New Lot No.";
                    Rec."New Expiration Date" := TempSpecification."New Expiration Date"
                end;
                Rec.Validate("Quantity (Base)", TempSpecification."Quantity (Base)");
                Rec."Entry No." := NextEntryNo();
                Rec.Insert();
            end;
        until TempSpecification.Next() = 0;
        Rec.Reset();
        if Rec.Find('-') then
            repeat
                CheckLine(Rec);
            until Rec.Next() = 0;

        Rec.SetRange("Lot No.", SourceSpecification."Lot No.");
        Rec.SetRange("Serial No.", SourceSpecification."Serial No.");

        CalculateSums();
        if UpdateUndefinedQty() then
            WriteToDatabase()
        else
            Error(Text014, TotalItemTrackingLine."Quantity (Base)",
              LowerCase(TempReservEntry.TextCaption()), SourceQuantityArray[1]);

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

        ItemTrackingMgt.SynchronizeItemTracking(CurrentSourceRowID, SecondSourceRowID, DialogText);
        exit(true);
    end;


    procedure SetBlockCommit(NewBlockCommit: Boolean)
    begin
        BlockCommit := NewBlockCommit;
    end;


    procedure TempItemTrackingDef(NewTrackingSpecification: Record "Tracking Specification")
    begin
        Rec := NewTrackingSpecification;
        Rec."Entry No." := NextEntryNo();
        if (not InsertIsBlocked) and (not ZeroLineExists()) then
            if not TestTempSpecificationExists() then
                Rec.Insert()
            else
                ModifyTrackingSpecification(NewTrackingSpecification);
        WriteToDatabase();
    end;

    local procedure CheckEntryIsReservation(Checktype: Option "Rename/Delete",Quantity; Messagetype: Option Error,Message) EntryIsReservation: Boolean
    var
        ReservEntry: Record "Reservation Entry";
        QtyToCheck: Decimal;
    begin
        ReservEntry.SetCurrentKey(
  "Source ID", "Source Ref. No.", "Source Type", "Source Subtype",
  "Source Batch Name", "Source Prod. Order Line", "Reservation Status");
        ReservEntry.SetRange("Source ID", Rec."Source ID");
        ReservEntry.SetRange("Source Ref. No.", Rec."Source Ref. No.");
        ReservEntry.SetRange("Source Type", Rec."Source Type");
        ReservEntry.SetRange("Source Subtype", Rec."Source Subtype");
        ReservEntry.SetRange("Source Batch Name", Rec."Source Batch Name");
        ReservEntry.SetRange("Source Prod. Order Line", Rec."Source Prod. Order Line");
        ReservEntry.SetRange("Reservation Status", ReservEntry."Reservation Status"::Reservation);
        ReservEntry.SetRange("Serial No.", xRec."Serial No.");
        ReservEntry.SetRange("Lot No.", xRec."Lot No.");
        if ReservEntry.Find('-') then
            case Checktype of
                Checktype::"Rename/Delete":
                    begin
                        EntryIsReservation := true;
                        case Messagetype of
                            Messagetype::Error:
                                Error(Text000, ReservEntry.TextCaption());
                        //>>MIG-2009-001
                        //Messagetype::Message: MESSAGE(Text000,TextCaption);
                        //<<MIG-2009-001
                        end;
                    end;
                Checktype::Quantity:
                    begin
                        repeat
                            QtyToCheck := QtyToCheck + ReservEntry."Quantity (Base)";
                        until ReservEntry.Next() = 0;
                        if Abs(Rec."Quantity (Base)") < Abs(QtyToCheck) then
                            Error(Text001, ReservEntry.TextCaption(), ReservEntry.FieldCaption("Quantity (Base)"), Abs(QtyToCheck));
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
        CrntTempTrackingSpec.Copy(Rec);
        Rec.SetCurrentKey("Lot No.", "Serial No.");
        Rec.SetRange("Lot No.", NewTrackingSpecification."Lot No.");
        Rec.SetRange("Serial No.", NewTrackingSpecification."Serial No.");
        Rec.SetFilter("Entry No.", '<>%1', Rec."Entry No.");
        Rec.SetRange("Buffer Status", 0);
        if Rec.Find('-') then begin
            Rec.Validate("Quantity (Base)",
              Rec."Quantity (Base)" + NewTrackingSpecification."Quantity (Base)");
            Rec.Modify();
        end;
        Rec.Copy(CrntTempTrackingSpec);
    end;

    // local procedure UpdateExpDateColor()
    // begin
    //     //>>MIG-2009-001
    //     /*
    //     IF (Rec."Buffer Status2" = Rec."Buffer Status2"::"ExpDate blocked") OR (CurrentSignFactor < 0) THEN
    //       CurrForm."Expiration Date".UPDATEFORECOLOR(8421504)
    //     ELSE
    //       CurrForm."Expiration Date".UPDATEFORECOLOR(0);
    //     */
    //     //<<MIG-2009-001

    // end;

    // local procedure UpdateExpDateEditable()
    // begin
    //     //>>MIG-2009-001
    //     /*
    //     CurrForm."Expiration Date".EDITABLE(
    //       NOT (("Buffer Status2" = "Buffer Status2"::"ExpDate blocked") OR (CurrentSignFactor < 0)));
    //     */
    //     //<<MIG-2009-001

    // end;


    procedure LookupAvailable(LookupMode: Enum "Item Tracking Type")
    begin
        Rec."Bin Code" := ForBinCode;
        ItemTrackingDataCollection.LookupTrackingAvailability(Rec, LookupMode);
        Rec."Bin Code" := '';
        //>>MIG-2009-001
        //CurrForm.UPDATE;
        //<<MIG-2009-001
    end;


    procedure F6LookupAvailable()
    var
        LookupMode: Enum "Item Tracking Type";
    begin
        if SNAvailabilityActive then
            LookupAvailable(LookupMode::"Serial No.");
        if LotAvailabilityActive then
            LookupAvailable(LookupMode::"Lot No.");
    end;


    procedure LotSnAvailable(var TrackingSpecification: Record "Tracking Specification"; LookupMode: Enum "Item Tracking Type"): Boolean
    begin
        exit(ItemTrackingDataCollection.TrackingAvailable(TrackingSpecification, LookupMode));
    end;


    procedure SelectEntries()
    var
        xTrackingSpec: Record "Tracking Specification";
        MaxQuantity: Decimal;
    begin
        xTrackingSpec.CopyFilters(Rec);
        MaxQuantity := UndefinedQtyArray[1];
        if MaxQuantity * CurrentSignFactor > 0 then
            MaxQuantity := 0;
        Rec."Bin Code" := ForBinCode;
        ItemTrackingDataCollection.SelectMultipleTrackingNo(Rec, MaxQuantity, CurrentSignFactor);
        Rec."Bin Code" := '';
        if Rec.FindSet() then
            repeat
                case Rec."Buffer Status" of
                    Rec."Buffer Status"::MODIFY:
                        begin
                            if TempItemTrackLineModify.Get(Rec."Entry No.") then
                                TempItemTrackLineModify.Delete();
                            if TempItemTrackLineInsert.Get(Rec."Entry No.") then begin
                                TempItemTrackLineInsert.TransferFields(Rec);
                                TempItemTrackLineInsert.Modify();
                            end else begin
                                TempItemTrackLineModify.TransferFields(Rec);
                                TempItemTrackLineModify.Insert();
                            end;
                        end;
                    Rec."Buffer Status"::INSERT:
                        begin
                            TempItemTrackLineInsert.TransferFields(Rec);
                            TempItemTrackLineInsert.Insert();
                        end;
                end;
                Rec."Buffer Status" := 0;
                Rec.Modify();
            until Rec.Next() = 0;
        LastEntryNo := Rec."Entry No.";
        CalculateSums();
        UpdateUndefinedQty();
        Rec.CopyFilters(xTrackingSpec);
        //>>MIG-2009-001
        //CurrForm.UPDATE(FALSE);
        //<<MIG-2009-001
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
        if TempItemTrackLineReserv.FindSet() then
            repeat
                LateBindingMgt.ReserveItemTrackingLine(TempItemTrackLineReserv, 0, TempItemTrackLineReserv."Quantity (Base)");
                SetQtyToHandleAndInvoice(TempItemTrackLineReserv);
            until TempItemTrackLineReserv.Next() = 0;
        TempItemTrackLineReserv.DeleteAll();
    end;


    procedure SetInbound(NewInbound: Boolean)
    begin
        Inbound := NewInbound;
    end;


    procedure SetPick(IsPick2: Boolean)
    begin
        IsPick := IsPick2;
    end;


    procedure "--- EDI6.00 ---"()
    begin
    end;


    procedure InsertLine(CodPLotNo: array[999] of Code[20]; DecLQty: Decimal; RecLTrackingSpec: Record "Tracking Specification"): Boolean
    var
        i: Integer;
    begin
        // Copy of "Form - OnInsertRecord" trigger
        //>>MIG-2009-001
        //IF Rec."Entry No." <> 0 THEN
        //  EXIT(FALSE);

        i := 1;
        while CodPLotNo[i] <> '' do begin
            Rec := RecLTrackingSpec;
            //<<MIG-2009-001
            Rec."Entry No." := NextEntryNo();
            //>>MIG-2009-001

            Rec."Qty. to Handle (Base)" := 0;
            Rec."Qty. to Invoice (Base)" := 0;
            Rec."Quantity Handled (Base)" := 0;
            Rec."Quantity Invoiced (Base)" := 0;

            Rec.Validate("Quantity (Base)", DecLQty);
            Rec.Validate(Rec."Lot No.", CodPLotNo[i]);

            //<<MIG-2009-001
            Rec."Qty. per Unit of Measure" := QtyPerUOM;
            if (not InsertIsBlocked) and (not ZeroLineExists()) then
                if not TestTempSpecificationExists() then begin
                    TempItemTrackLineInsert.TransferFields(Rec);
                    TempItemTrackLineInsert.Insert();
                    Rec.Insert();
                    ItemTrackingDataCollection.UpdateTrackingDataSetWithChange(
                      TempItemTrackLineInsert, CurrentSignFactor * SourceQuantityArray[1] < 0, CurrentSignFactor, 0);
                end;
            CalculateSums();

            //>>MIG-2009-001
            i += 1;
        end;
        //<<MIG-2009-001


        // Copy of "Form - OnCloseForm" trigger
        if UpdateUndefinedQty() then
            WriteToDatabase();
        if FormRunMode = FormRunMode::"Drop Shipment" then
            case CurrentSourceType of
                DATABASE::"Sales Line":
                    SynchronizeLinkedSources(StrSubstNo(Text015, Text016));
                DATABASE::"Purchase Line":
                    SynchronizeLinkedSources(StrSubstNo(Text015, Text017));
            end;
        if FormRunMode = FormRunMode::Transfer then
            SynchronizeLinkedSources('');
    end;


    procedure UpdateUndefinedQty2()
    begin
        UpdateUndefinedQty();
    end;
}

