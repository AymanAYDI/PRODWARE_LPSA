tableextension 60038 "PWD ProdOrderComponent" extends "Prod. Order Component"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                               |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_PROD01.001: TO 13/12/2011:  No Commande vente identique OF-LOT
    //                                           - Add field 50000 & 50001
    // 
    // //>>LAP2.06
    // FE_LAPRIERRETTE_GP0003 : APA 16/05/2013 : Add C/AL Code On No.- OnValidate()
    //                                               Add Function ShowItemSubPhantom
    //                                               Add Function UpdateReserveItemPhantom
    //                                               Add Function RegisterChange
    //                                               Add Function ModifyFieldsWithinFilter
    //                                               Add Function SetQtyToHandleAndInvoice
    // 
    // //>>LAP.TDL.09/10/2014 :
    // 09/10/2014 : Add indicator (to know the component status)
    //               - Add function CheckComponentAvailabilty,CalcProdOrderLineFields,CalcProdOrderCompFields
    // 
    // //>>LAP090615
    // TO 09/06/15 : Modify functon CheckComponentAvailabilty
    // 
    // TDL.LPSA.002 Modify OnInsrt()
    // +----------------------------------------------------------------------------------------------------------------+
    fields
    {
        field(50000; "PWD Lot Determining"; Boolean)
        {
            Caption = 'Lot Determining';
            Description = 'LAP1.00';

            trigger OnValidate()
            var
                Item: Record Item;
                ProdOrderComp: Record "Prod. Order Component";
            begin

                IF "PWD Lot Determining" THEN BEGIN
                    Item.GET("Item No.");
                    Item.IsLotItem(/*piForceError=*/ TRUE);
                    //  TESTFIELD("From the same Lot");
                END;

                //gcuLotInheritanceMgt.CheckInheritPOCompChangeable(Rec);

                ProdOrderComp.SETRANGE(Status, Status);
                ProdOrderComp.SETRANGE("Prod. Order No.", "Prod. Order No.");
                ProdOrderComp.SETRANGE("Prod. Order Line No.", "Prod. Order Line No.");
                ProdOrderComp.SETFILTER("Line No.", '<>%1', "Line No.");
                IF "PWD Lot Determining" THEN BEGIN
                    ProdOrderComp.SETFILTER("Item No.", '<>%1', "Item No.");
                    ProdOrderComp.SETRANGE("PWD Lot Determining", TRUE);
                    IF ProdOrderComp.FIND('-') THEN
                        ERROR(CstG001, ProdOrderComp.FIELDCAPTION("PWD Lot Determining"), ProdOrderComp."Item No.", "PWD Lot Determining");
                END;

                //Begin#803/01:A9232/2.10.09  22.02.06 TECTURA.WW
                //gcuLSLicPermMgt.T5407_AuTrActions(Rec, xRec, FIELDNO("Lot Determining"), CurrFieldNo, {piMode=} 'MODIFY');
                //End#803/01:A9232/2.10.09  22.02.06 TECTURA.WW

                ProdOrderComp.SETRANGE("Item No.", "Item No.");
                ProdOrderComp.SETRANGE("PWD Lot Determining", (NOT "PWD Lot Determining"));
                IF ProdOrderComp.FIND('-') THEN
                    IF CONFIRM(CstG002, TRUE, ProdOrderComp.FIELDCAPTION("PWD Lot Determining"), "PWD Lot Determining") THEN
                        //Begin#803/01:A3046/2.10  18.11.04 ASTON.WW
                        //ProdOrderComp.MODIFYALL("Lot Determining", "Lot Determining",
                        //  gcuDataHistFunctions.T5407_LogModifyAll(ProdOrderComp, ProdOrderComp.FIELDNO("Lot Determining"), "Lot Determining", FALSE))
                        //End#803/01:A3046/2.10  18.11.04 ASTON.WW
                        ProdOrderComp.MODIFYALL("PWD Lot Determining", "PWD Lot Determining")
                    //,
                    //  gcuDataHistFunctions.T5407_LogModifyAll(ProdOrderComp, ProdOrderComp.FIELDNO("Lot Determining"), "Lot Determining", FALSE))

                    ELSE
                        ERROR('');

            end;
        }
        field(50001; "PWD From the same Lot"; Boolean)
        {
            Caption = 'From the same Lot';
            Description = 'LAP1.00';
        }
    }

    procedure ShowItemSubPhantom()
    var
        PWDLPSAFunctionsMgt: Codeunit "PWD LPSA Functions Mgt.";
    begin
        PWDLPSAFunctionsMgt.GetCompSubstPhantom(Rec);
    end;

    procedure UpdateReserveItemPhantom()
    var
        TempReservEntry: Record "Reservation Entry" temporary;
        RecLTrackingSpec: Record "Tracking Specification" temporary;
        RecLTrackingSpecPhantom: Record "Tracking Specification Phantom";
        ItemTrackingDataCollection: Codeunit "Item Tracking Data Collection";
        LPSAFunctionsMgt: Codeunit "PWD LPSA Functions Mgt.";
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        CurrentSignFactor: Decimal;
        QtyToAddAsBlank: Decimal;
        ChangeType: Option Insert,Modify,FullDelete,PartDelete,ModifyAll;
    begin
        CurrentSignFactor := 1;
        Item.GET("Item No.");

        IF Item."Order Tracking Policy" = Item."Order Tracking Policy"::None THEN
            QtyToAddAsBlank := 0
        ELSE
            QtyToAddAsBlank := "Remaining Quantity" * CurrentSignFactor;

        RecLTrackingSpecPhantom.SETRANGE("Source ID", "Prod. Order No.");
        RecLTrackingSpecPhantom.SETRANGE("Source Prod. Order Line", "Prod. Order Line No.");
        RecLTrackingSpecPhantom.SETRANGE("Source Ref. No.", "Line No.");
        IF RecLTrackingSpecPhantom.FINDFIRST() THEN BEGIN
            ReservEntry.SETCURRENTKEY(
              "Source ID", "Source Ref. No.", "Source Type", "Source Subtype",
              "Source Batch Name", "Source Prod. Order Line", "Reservation Status");

            ReservEntry.SETRANGE("Source ID", RecLTrackingSpecPhantom."Source ID");
            ReservEntry.SETRANGE("Source Ref. No.", RecLTrackingSpecPhantom."Source Ref. No.");
            ReservEntry.SETRANGE("Source Type", RecLTrackingSpecPhantom."Source Type");
            ReservEntry.SETRANGE("Source Subtype", RecLTrackingSpecPhantom."Source Subtype");
            ReservEntry.SETRANGE("Source Batch Name", RecLTrackingSpecPhantom."Source Batch Name");
            ReservEntry.SETRANGE("Source Prod. Order Line", RecLTrackingSpecPhantom."Source Prod. Order Line");

            //AddReservEntriesToTempRecSet(ReservEntry,RecLTrackingSpec,FALSE,0,TempReservEntry);

            TempReservEntry.COPYFILTERS(ReservEntry);

            REPEAT
                RecLTrackingSpec.INIT();
                RecLTrackingSpec.TRANSFERFIELDS(RecLTrackingSpecPhantom);
                RecLTrackingSpec.INSERT();
                ItemTrackingDataCollection.UpdateTrackingDataSetWithChange(
                     RecLTrackingSpec, CurrentSignFactor * "Remaining Quantity" < 0, CurrentSignFactor, 0);
            UNTIL RecLTrackingSpecPhantom.NEXT() = 0;

            IF RecLTrackingSpec.FINDFIRST() THEN
                REPEAT
                    RegisterChange(RecLTrackingSpec, RecLTrackingSpec, ChangeType::Insert, FALSE, CurrentSignFactor, TempReservEntry, QtyToAddAsBlank);

                UNTIL RecLTrackingSpec.NEXT() = 0;

            TempReservEntry.RESET();
            ReservEngineMgt.UpdateOrderTracking(TempReservEntry);

        END;

        //ItemTrackingForm.RegisterItemTrackingLines2(SourceSpecification,"Due Date",RecLTrackingSpec);
        RecLTrackingSpecPhantom.DELETEALL();

        LPSAFunctionsMgt.VerifyQuantityPhantom(Rec, xRec);
    end;

    local procedure RegisterChange(var OldTrackingSpecification: Record "Tracking Specification"; var NewTrackingSpecification: Record "Tracking Specification"; ChangeType: Option Insert,Modify,FullDelete,PartDelete,ModifyAll; ModifySharedFields: Boolean; CurrentSignFactor: Decimal; var TempReservEntry: Record "Reservation Entry"; QtyToAddAsBlank: Decimal) OK: Boolean
    var
        ReservEntry1: Record "Reservation Entry";
        TempItemTrackLineReserv: Record "Tracking Specification" temporary;
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        // AvailabilityDate: Date;
        LostReservQty: Decimal;
        CurrentEntryStatus: Enum "Reservation Status";
    begin
        OK := FALSE;
        //TODO: La procedure SetPick n'existe pas dans le codeunit "Reservation Engine Mgt."
        //ReservEngineMgt.SetPick(IsPick);

        CurrentEntryStatus := CurrentEntryStatus::Surplus;

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
                    //TODO: vérifier les parametres de la procedure AddItemTrackingToTempRecSet 
                    // OldTrackingSpecification."Quantity (Base)" :=
                    //   CurrentSignFactor *
                    //   ReservEngineMgt.AddItemTrackingToTempRecSet(
                    //     TempReservEntry, NewTrackingSpecification,
                    //     CurrentSignFactor * OldTrackingSpecification."Quantity (Base)", QtyToAddAsBlank,
                    //     ItemTrackingCode."SN Specific Tracking", ItemTrackingCode."Lot Specific Tracking");
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

                    CreateReservEntry.SetDates(
                      NewTrackingSpecification."Warranty Date", NewTrackingSpecification."Expiration Date");
                    CreateReservEntry.SetApplyFromEntryNo(
                      NewTrackingSpecification."Appl.-from Item Entry");
                    //TODO: vérifier les parametres de la procedure CreateReservEntryFor 
                    // CreateReservEntry.CreateReservEntryFor(
                    //   OldTrackingSpecification."Source Type",
                    //   OldTrackingSpecification."Source Subtype",
                    //   OldTrackingSpecification."Source ID",
                    //   OldTrackingSpecification."Source Batch Name",
                    //   OldTrackingSpecification."Source Prod. Order Line",
                    //   OldTrackingSpecification."Source Ref. No.",
                    //   OldTrackingSpecification."Qty. per Unit of Measure",
                    //   OldTrackingSpecification."Quantity (Base)",
                    //   OldTrackingSpecification."Serial No.",
                    //   OldTrackingSpecification."Lot No.");
                    CreateReservEntry.CreateEntry(OldTrackingSpecification."Item No.",
                      OldTrackingSpecification."Variant Code",
                      OldTrackingSpecification."Location Code",
                      OldTrackingSpecification.Description,
                      0D,
                      "Due Date", 0, CurrentEntryStatus);
                    CreateReservEntry.GetLastEntry(ReservEntry1);
                    IF Item."Order Tracking Policy" = Item."Order Tracking Policy"::"Tracking & Action Msg." THEN
                        ReservEngineMgt.UpdateActionMessages(ReservEntry1);

                    IF ModifySharedFields THEN BEGIN
                        //TODO: La procedure SetPointerFilter n'existe pas dans le codeunit "Reservation Management"
                        //ReservationMgt.SetPointerFilter(ReservEntry1);
                        ReservEntry1.SETRANGE("Lot No.", ReservEntry1."Lot No.");
                        ReservEntry1.SETRANGE("Serial No.", ReservEntry1."Serial No.");
                        ReservEntry1.SETFILTER("Entry No.", '<>%1', ReservEntry1."Entry No.");
                        ModifyFieldsWithinFilter(ReservEntry1, NewTrackingSpecification);
                    END;

                    // IF CurrentSignFactor < 0 THEN
                    //     AvailabilityDate := "Due Date"
                    // ELSE
                    //     AvailabilityDate := "Due Date";
                    OK := TRUE;
                END;
        END;
        SetQtyToHandleAndInvoice(NewTrackingSpecification, CurrentSignFactor, FALSE);
    end;

    local procedure SetQtyToHandleAndInvoice(TrackingSpecification: Record "Tracking Specification"; CurrentSignFactor: Decimal; IsCorrection: Boolean) OK: Boolean
    var
        ReservEntry1: Record "Reservation Entry";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        QtyAlreadyHandledToInvoice: Decimal;
        QtyToHandleThisLine: Decimal;
        QtyToInvoiceThisLine: Decimal;
        TotalQtyToHandle: Decimal;
        TotalQtyToInvoice: Decimal;
    begin
        //>>FE_LAPRIERRETTE_GP0003 : APA 16/05/2013

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
        //TODO: La procedure SetPointerFilter n'existe pas dans le codeunit "Reservation Management"
        //ReservationMgt.SetPointerFilter(ReservEntry1);
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
        //<<FE_LAPRIERRETTE_GP0003 : APA 16/05/2013
    end;

    procedure CheckComponentAvailabilty() IsNotAvailable: Boolean
    var
        CompItem: Record Item;
        TempProdOrderComp: Record "Prod. Order Component" temporary;
        TempProdOrderLine: Record "Prod. Order Line" temporary;
        RecLProdOrder: Record "Production Order";
        NeededQty: Decimal;
        QtyOnHandAfterProd: Decimal;
    // RemainingQty: Decimal;
    begin
        //>>LAP.TDL.09/10/2014 :
        //>>Based on Report 99000788
        RecLProdOrder.GET(Status, "Prod. Order No.");

        SETFILTER("Remaining Qty. (Base)", '>0');

        CompItem.GET("Item No.");
        CompItem.SETRANGE("Variant Filter", "Variant Code");
        CompItem.SETRANGE("Location Filter", "Location Code");
        //>>LAP2.07
        //CompItem.SETRANGE(
        //  "Date Filter",0D,"Due Date" - 1);
        //>>LAP090615
        CompItem.SETRANGE("Date Filter", 0D, TODAY - 1);
        //<<LAP090615
        //<<LAP2.07

        CompItem.CALCFIELDS(
          Inventory, "Reserved Qty. on Inventory",
          "Scheduled Receipt (Qty.)", "Reserved Qty. on Prod. Order",
          "Qty. on Component Lines", "Res. Qty. on Prod. Order Comp.");
        CompItem.Inventory :=
          CompItem.Inventory -
          CompItem."Reserved Qty. on Inventory";
        CompItem."Scheduled Receipt (Qty.)" :=
          CompItem."Scheduled Receipt (Qty.)" -
          CompItem."Reserved Qty. on Prod. Order";
        CompItem."Qty. on Component Lines" :=
          CompItem."Qty. on Component Lines" -
          CompItem."Res. Qty. on Prod. Order Comp.";

        //>>LAP2.07
        //CompItem.SETRANGE(
        //  "Date Filter",0D,"Due Date");
        //>>LAP090615
        CompItem.SETRANGE("Date Filter", 0D, TODAY);
        //<<LAP090615
        //<<LAP2.07

        CompItem.CALCFIELDS(
          "Qty. on Sales Order", "Reserved Qty. on Sales Orders",
          "Qty. on Purch. Order", "Reserved Qty. on Purch. Orders");
        CompItem."Qty. on Sales Order" :=
          CompItem."Qty. on Sales Order" -
          CompItem."Reserved Qty. on Sales Orders";
        CompItem."Qty. on Purch. Order" :=
          CompItem."Qty. on Purch. Order" -
          CompItem."Reserved Qty. on Purch. Orders";

        TempProdOrderLine.SETCURRENTKEY(
          "Item No.", "Variant Code", "Location Code", Status, "Ending Date");

        TempProdOrderLine.SETRANGE(Status, TempProdOrderLine.Status::Planned, Status.AsInteger() - 1);
        TempProdOrderLine.SETRANGE("Item No.", "Item No.");
        TempProdOrderLine.SETRANGE("Variant Code", "Variant Code");
        TempProdOrderLine.SETRANGE("Location Code", "Location Code");
        //>>LAP2.07
        //TempProdOrderLine.SETRANGE("Due Date","Due Date");
        //<<LAP2.07
        CalcProdOrderLineFields(TempProdOrderLine);
        CompItem."Scheduled Receipt (Qty.)" :=
          CompItem."Scheduled Receipt (Qty.)" +
          TempProdOrderLine."Remaining Qty. (Base)" -
          TempProdOrderLine."Reserved Qty. (Base)";

        TempProdOrderLine.SETRANGE(Status, Status);
        TempProdOrderLine.SETRANGE("Prod. Order No.", "Prod. Order No.");
        CalcProdOrderLineFields(TempProdOrderLine);
        CompItem."Scheduled Receipt (Qty.)" :=
          CompItem."Scheduled Receipt (Qty.)" +
          TempProdOrderLine."Remaining Qty. (Base)" -
          TempProdOrderLine."Reserved Qty. (Base)";


        TempProdOrderComp.SETCURRENTKEY(
          "Item No.", "Variant Code", "Location Code", Status, "Due Date");

        TempProdOrderComp.SETRANGE(Status, TempProdOrderComp.Status::Planned, Status.AsInteger() - 1);
        TempProdOrderComp.SETRANGE("Item No.", "Item No.");
        TempProdOrderComp.SETRANGE("Variant Code", "Variant Code");
        TempProdOrderComp.SETRANGE("Location Code", "Location Code");
        //>>LAP2.07
        //TempProdOrderComp.SETRANGE("Due Date","Due Date");
        //<<LAP2.07
        CalcProdOrderCompFields(TempProdOrderComp);
        CompItem."Qty. on Component Lines" :=
          CompItem."Qty. on Component Lines" +
          TempProdOrderComp."Remaining Qty. (Base)" -
          TempProdOrderComp."Reserved Qty. (Base)";

        TempProdOrderComp.SETRANGE(Status, Status);
        TempProdOrderComp.SETFILTER("Prod. Order No.", '<%1', "Prod. Order No.");
        CalcProdOrderCompFields(TempProdOrderComp);
        CompItem."Qty. on Component Lines" :=
          CompItem."Qty. on Component Lines" +
          TempProdOrderComp."Remaining Qty. (Base)" -
          TempProdOrderComp."Reserved Qty. (Base)";

        TempProdOrderComp.SETRANGE("Prod. Order No.", "Prod. Order No.");
        TempProdOrderComp.SETRANGE("Prod. Order Line No.", 0, "Prod. Order Line No." - 1);
        CalcProdOrderCompFields(TempProdOrderComp);
        CompItem."Qty. on Component Lines" :=
          CompItem."Qty. on Component Lines" +
          TempProdOrderComp."Remaining Qty. (Base)" -
          TempProdOrderComp."Reserved Qty. (Base)";

        TempProdOrderComp.SETRANGE("Prod. Order Line No.", "Prod. Order Line No.");
        TempProdOrderComp.SETRANGE("Line No.", 0, "Line No.");
        CalcProdOrderCompFields(TempProdOrderComp);
        CompItem."Qty. on Component Lines" :=
          CompItem."Qty. on Component Lines" +
          TempProdOrderComp."Remaining Qty. (Base)" -
          TempProdOrderComp."Reserved Qty. (Base)";

        // RemainingQty :=
        //   TempProdOrderComp."Remaining Qty. (Base)" -
        //   TempProdOrderComp."Reserved Qty. (Base)";

        QtyOnHandAfterProd :=
          CompItem.Inventory -
          TempProdOrderComp."Remaining Qty. (Base)" +
          TempProdOrderComp."Reserved Qty. (Base)";

        NeededQty :=
          CompItem."Qty. on Component Lines" +
          CompItem."Qty. on Sales Order" -
          CompItem."Qty. on Purch. Order" -
          CompItem."Scheduled Receipt (Qty.)" -
          CompItem.Inventory;

        IF NeededQty < 0 THEN
            NeededQty := 0;

        IF (NeededQty = 0) AND
           (QtyOnHandAfterProd >= 0)
        THEN
            EXIT(FALSE)
        ELSE
            EXIT(TRUE);
        //<<LAP.TDL.09/10/2014 :
    end;

    procedure CalcProdOrderLineFields(var ProdOrderLineFields: Record "Prod. Order Line")
    var
        ProdOrderLine: Record "Prod. Order Line";
        RemainingQtyBase: Decimal;
        ReservedQtyBase: Decimal;
    begin
        //>>LAP.TDL.09/10/2014 :
        ProdOrderLine.COPY(ProdOrderLineFields);

        IF ProdOrderLine.FINDSET() THEN
            REPEAT
                ProdOrderLine.CALCFIELDS("Reserved Qty. (Base)");
                RemainingQtyBase += ProdOrderLine."Remaining Qty. (Base)";
                ReservedQtyBase += ProdOrderLine."Reserved Qty. (Base)";
            UNTIL ProdOrderLine.NEXT() = 0;

        ProdOrderLineFields."Remaining Qty. (Base)" := RemainingQtyBase;
        ProdOrderLineFields."Reserved Qty. (Base)" := ReservedQtyBase;
    end;

    procedure CalcProdOrderCompFields(var ProdOrderCompFields: Record "Prod. Order Component")
    var
        ProdOrderComp: Record "Prod. Order Component";
        RemainingQtyBase: Decimal;
        ReservedQtyBase: Decimal;
    begin
        //>>LAP.TDL.09/10/2014 :
        ProdOrderComp.COPY(ProdOrderCompFields);

        IF ProdOrderComp.FINDSET() THEN
            REPEAT
                ProdOrderComp.CALCFIELDS("Reserved Qty. (Base)");
                RemainingQtyBase += ProdOrderComp."Remaining Qty. (Base)";
                ReservedQtyBase += ProdOrderComp."Reserved Qty. (Base)";
            UNTIL ProdOrderComp.NEXT() = 0;

        ProdOrderCompFields."Remaining Qty. (Base)" := RemainingQtyBase;
        ProdOrderCompFields."Reserved Qty. (Base)" := ReservedQtyBase;
    end;

    PROCEDURE ModifyFieldsWithinFilter(VAR ReservEntry1: Record "Reservation Entry"; VAR TrackingSpecification: Record "Tracking Specification");
    BEGIN
        //>>FE_LAPRIERRETTE_GP0003 : APA 16/05/2013

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

        //<<FE_LAPRIERRETTE_GP0003 : APA 16/05/2013
    END;

    var
        Item: Record Item;
        ReservEntry: Record "Reservation Entry";
        CstG001: Label '%1: Component %2 is already set to %3.';
        CstG002: Label '%1: Component %2 is already set to %3.';
}

