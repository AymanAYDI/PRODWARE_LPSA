codeunit 8073298 "PWD Buffer Tracking Management"
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
    // WMS-FE008_15.001:GR 19/07/2011 Shipment
    //                                - Add function:
    //                                  FctSynchronizeLinkedSourcesSal
    //                                  FctIsSerializedItemSales
    // 
    // +----------------------------------------------------------------------------------------------------------------+


    trigger OnRun()
    begin
    end;

    var
        RecGItem: Record Item;
        RecGItemTrackingCode: Record "Item Tracking Code";
        RecGTempReservEntry: Record "Reservation Entry" temporary;
        RecGTempItemTrackLineReserv: Record "Tracking Specification" temporary;
        CduGReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        OptGCurrentEntryStatus: Option Reservation,Tracking,Surplus,Prospect;

    local procedure FctNextEntryNo(): Integer
    var
        RecLTrackingSpecification: Record "Tracking Specification";
    begin
        RecLTrackingSpecification.Reset();
        if RecLTrackingSpecification.FindLast() then
            exit(RecLTrackingSpecification."Entry No." + 1)
        else
            exit(1);
    end;


    procedure FctNextPurchLineNo(CodPPurchOrderNo: Code[20]): Integer
    var
        RecLPurchLine: Record "Purchase Line";
    begin
        with RecLPurchLine do begin
            Reset();
            SetRange("Document Type", "Document Type"::Order);
            SetRange("Document No.", CodPPurchOrderNo);
            if FindLast() then
                exit("Line No." + 10000)
            else
                exit(10000);
        end;
    end;


    procedure FctDeleteTrackingLines(CodPPurchOrderNo: Code[20]; IntPPurchLineNo: Integer)
    var
        RecLReservationEntry: Record "Reservation Entry";
        RecLTempItemTrackLineDelete: Record "Tracking Specification" temporary;
        CduGItemTrackingDataCollection: Codeunit "Item Tracking Data Collection";
    begin
        RecLTempItemTrackLineDelete.Reset();
        RecLTempItemTrackLineDelete.DeleteAll();
        RecLReservationEntry.Reset();
        RecLReservationEntry.SetRange("Source Type", DATABASE::"Purchase Line");
        RecLReservationEntry.SetRange("Source Subtype", 1); //Order
        RecLReservationEntry.SetRange("Source ID", CodPPurchOrderNo);
        if IntPPurchLineNo <> 0 then
            RecLReservationEntry.SetRange("Source Ref. No.", IntPPurchLineNo);
        RecLReservationEntry.SetRange("Quantity Invoiced (Base)", 0);
        if RecLReservationEntry.IsEmpty then
            exit;
        RecLReservationEntry.FindSet();
        repeat
            RecLTempItemTrackLineDelete.TransferFields(RecLReservationEntry);
            RecLTempItemTrackLineDelete.Insert();
            CduGItemTrackingDataCollection.UpdateTrackingDataSetWithChange(RecLTempItemTrackLineDelete, false, 1, 2);
            FctRegisterChange(RecLTempItemTrackLineDelete, RecLTempItemTrackLineDelete, 2, false);
            FctUpdateOrderTracking();
            FctReestablishReservations();
        until RecLReservationEntry.Next() = 0;
    end;


    procedure FctAssignSerialNo(IntPTableID: Integer; IntPSubTypeID: Integer; CodPSourceID: Code[20]; CodPSourceBatchName: Code[10]; IntPSourceRefNo: Integer; IntPSourceProdOrderLine: Integer; CodPLocationCode: Code[10]; CodPBinCode: Code[10]; CodPVariantCode: Code[10]; CodPItemNo: Code[20]; IntPQtyToCreate: Decimal; IntPTrackingType: Integer; CodPSerialNo: Code[20]; CodPLotNo: Code[20]; DatPExpirationDate: Date)
    var
        RecLPurchLine: Record "Purchase Line";
        RecLSalesLine: Record "Sales Line";
        RecLTempItemTrackLineInsert: Record "Tracking Specification" temporary;
        CduGItemTrackingDataCollection: Codeunit "Item Tracking Data Collection";
    begin
        //IntPTableID = ID Table
        //IntPSubTypeID = Dans le cas d'un document ayant un type le document type sinon 0
        //CodPSourceID = N° doc ou Journal Template Name
        //CodPSourceBatchName = vide ou Journal Batch Name
        //IntPSourceRefNo = N° de ligne
        //IntPSourceProdOrderLine = achat et Item non utilisé donc 0
        //CodPLocationCode = code magasion
        //CodPBinCode = code emplacement
        //CodPVariantCode = code variant
        //CodPItemNo = N° article
        //IntPQtyToCreate = quantité
        //IntPTrackingType = 1 Lot | 2 lot et Série | 3 Série
        //CodPSerialNo = N° série
        //CodPLotNo = N° Lot

        if IntPTrackingType = 0 then
            exit;
        if IntPQtyToCreate < 0 then
            IntPQtyToCreate := 0;

        RecGItem.Get(CodPItemNo);
        case IntPTableID of
            DATABASE::"Purchase Line":
                FctIsSerializedItem(RecGItem, IntPTrackingType);
            DATABASE::"Item Journal Line":
                FctIsSerializedItem2(RecGItem, IntPTrackingType);
            DATABASE::"Sales Line":
                FctIsSerializedItemSales(RecGItem, IntPTrackingType);
        end;
        //FctIsSerializedItem(RecGItem , IntPTrackingType);
        RecLTempItemTrackLineInsert.Init();
        RecLTempItemTrackLineInsert."Source Type" := IntPTableID;
        RecLTempItemTrackLineInsert."Source Subtype" := IntPSubTypeID;
        RecLTempItemTrackLineInsert."Source ID" := CodPSourceID;
        RecLTempItemTrackLineInsert."Source Batch Name" := CodPSourceBatchName;
        RecLTempItemTrackLineInsert."Source Ref. No." := IntPSourceRefNo;
        RecLTempItemTrackLineInsert."Source Prod. Order Line" := IntPSourceProdOrderLine;
        RecLTempItemTrackLineInsert."Item No." := CodPItemNo;
        RecLTempItemTrackLineInsert."Location Code" := CodPLocationCode;
        RecLTempItemTrackLineInsert."Bin Code" := CodPBinCode;
        RecLTempItemTrackLineInsert."Variant Code" := CodPVariantCode;
        RecLTempItemTrackLineInsert."Expiration Date" := DatPExpirationDate;
        case IntPTrackingType of
            1:
                RecLTempItemTrackLineInsert.Validate("Lot No.", CodPLotNo);
            2:
                begin
                    RecLTempItemTrackLineInsert.Validate("Lot No.", CodPLotNo);
                    RecLTempItemTrackLineInsert.Validate("Serial No.", CodPSerialNo);
                end;
            3:
                RecLTempItemTrackLineInsert.Validate("Serial No.", CodPSerialNo);
        end;

        RecLTempItemTrackLineInsert.Validate("Quantity (Base)", IntPQtyToCreate);
        RecLTempItemTrackLineInsert."Entry No." := FctNextEntryNo();
        RecLTempItemTrackLineInsert.Insert();

        CduGItemTrackingDataCollection.UpdateTrackingDataSetWithChange(RecLTempItemTrackLineInsert, false, 1, 0);

        FctRegisterChange(RecLTempItemTrackLineInsert, RecLTempItemTrackLineInsert, 0, false);
        FctUpdateOrderTracking();
        FctReestablishReservations();

        //Lien des commandes d'achat en drop shipment
        if IntPTableID = DATABASE::"Purchase Line" then begin
            RecLPurchLine.Get(IntPSubTypeID, CodPSourceID, IntPSourceRefNo);
            FctSynchronizeLinkedSources(RecLPurchLine);
        end;

        //Lien des commandes d'achat en drop shipment
        if IntPTableID = DATABASE::"Sales Line" then begin
            RecLSalesLine.Get(IntPSubTypeID, CodPSourceID, IntPSourceRefNo);
            FctSynchronizeLinkedSourcesSal(RecLSalesLine);
        end;
    end;


    procedure FctGetCountAssignSerialNo(IntPTableID: Integer; IntPSubTypeID: Integer; CodPSourceID: Code[20]; CodPSourceBatchName: Code[10]; IntPSourceRefNo: Integer; IntPSourceProdOrderLine: Integer): Decimal
    var
        RecLReservationEntry: Record "Reservation Entry";
    begin
        //IntPTableID = ID Table
        //IntPSubTypeID = Dans le cas d'un document ayant un type le document type sinon 0
        //CodPSourceID = N° doc ou Journal Template Name
        //CodPSourceBatchName = vide ou Journal Batch Name
        //IntPSourceRefNo = N° de ligne
        //IntPSourceProdOrderLine = achat et Item non utilisé donc 0
        RecLReservationEntry.SetCurrentKey("Source ID", "Source Ref. No.",
                                          "Source Type", "Source Subtype", "Source Batch Name", "Source Prod. Order Line",
                                          "Reservation Status", "Shipment Date", "Expected Receipt Date");
        RecLReservationEntry.SetRange("Source ID", CodPSourceID);
        RecLReservationEntry.SetRange("Source Ref. No.", IntPSourceRefNo);
        RecLReservationEntry.SetRange("Source Type", IntPTableID);
        RecLReservationEntry.SetRange("Source Subtype", IntPSubTypeID);
        RecLReservationEntry.SetRange("Source Batch Name", CodPSourceBatchName);
        RecLReservationEntry.SetRange("Source Prod. Order Line", IntPSourceProdOrderLine);
        RecLReservationEntry.CalcSums("Quantity (Base)");
        exit(RecLReservationEntry."Quantity (Base)");
    end;

    local procedure FctRegisterChange(var OldTrackingSpecification: Record "Tracking Specification"; var NewTrackingSpecification: Record "Tracking Specification"; ChangeType: Option Insert,Modify,FullDelete,PartDelete,ModifyAll; ModifySharedFields: Boolean) OK: Boolean
    var
        RecLPurchLine: Record "Purchase Line";
        ReservEntry1: Record "Reservation Entry";
        RecLSalesLine: Record "Sales Line";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        CduLItemTrackingMgt: Codeunit "Item Tracking Management";
        ReservationMgt: Codeunit "Reservation Management";
        DatLExpectedReceiptDate: Date;
        DatLShipmentDate: Date;
        DecLTempDec: Decimal;
        LostReservQty: Decimal;
        QtyToAdd: Decimal;
    begin
        RecGTempReservEntry.Reset();
        RecGTempReservEntry.DeleteAll();
        DecLTempDec := 0;
        RecGItem.Get(OldTrackingSpecification."Item No.");
        RecGItemTrackingCode.Get(RecGItem."Item Tracking Code");
        DatLShipmentDate := 0D;
        DatLExpectedReceiptDate := 0D;
        if RecLPurchLine.Get(OldTrackingSpecification."Source Subtype",
                          OldTrackingSpecification."Source ID",
                          OldTrackingSpecification."Source Ref. No.") then
            DatLExpectedReceiptDate := RecLPurchLine."Expected Receipt Date";

        if RecLSalesLine.Get(OldTrackingSpecification."Source Subtype",
                          OldTrackingSpecification."Source ID",
                          OldTrackingSpecification."Source Ref. No.") then
            DatLShipmentDate := RecLSalesLine."Planned Shipment Date";

        if CduLItemTrackingMgt.IsOrderNetworkEntity(OldTrackingSpecification."Source Type",
             OldTrackingSpecification."Source Subtype") and not (RecLPurchLine."Drop Shipment")
        then
            OptGCurrentEntryStatus := OptGCurrentEntryStatus::Surplus
        else
            OptGCurrentEntryStatus := OptGCurrentEntryStatus::Prospect;

        if CduLItemTrackingMgt.IsOrderNetworkEntity(OldTrackingSpecification."Source Type",
             OldTrackingSpecification."Source Subtype") and not (RecLSalesLine."Drop Shipment")
        then
            OptGCurrentEntryStatus := OptGCurrentEntryStatus::Surplus
        else
            OptGCurrentEntryStatus := OptGCurrentEntryStatus::Prospect;

        OK := false;
        if (NewTrackingSpecification."Qty. to Handle") < 0 then
            NewTrackingSpecification."Expiration Date" := 0D;

        case ChangeType of
            ChangeType::Insert:
                begin
                    if (OldTrackingSpecification."Quantity (Base)" = 0) or
                       ((OldTrackingSpecification."Lot No." = '') and
                        (OldTrackingSpecification."Serial No." = ''))
                    then
                        exit(true);
                    RecGTempReservEntry.SetRange("Serial No.", '');
                    RecGTempReservEntry.SetRange("Lot No.", '');
                    OldTrackingSpecification."Quantity (Base)" := CduGReservEngineMgt.AddItemTrackingToTempRecSet(
                                                                  RecGTempReservEntry, NewTrackingSpecification,
                                                                  OldTrackingSpecification."Quantity (Base)", DecLTempDec,
                                                                  RecGItemTrackingCode);
                    RecGTempReservEntry.SetRange("Serial No.");
                    RecGTempReservEntry.SetRange("Lot No.");

                    // Late Binding
                    if CduGReservEngineMgt.RetrieveLostReservQty(LostReservQty) then begin
                        RecGTempItemTrackLineReserv := NewTrackingSpecification;
                        RecGTempItemTrackLineReserv."Quantity (Base)" := LostReservQty;
                        RecGTempItemTrackLineReserv.Insert();
                    end;

                    if OldTrackingSpecification."Quantity (Base)" = 0 then
                        exit(true);

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
                      OldTrackingSpecification."Qty. to Handle",
                      OldTrackingSpecification."Qty. to Handle (Base)",
                      ReservEntry1);
                    CreateReservEntry.CreateEntry(OldTrackingSpecification."Item No.",
                      OldTrackingSpecification."Variant Code",
                      OldTrackingSpecification."Location Code",
                      OldTrackingSpecification.Description,
                      DatLExpectedReceiptDate,
                      DatLShipmentDate, 0, OptGCurrentEntryStatus);
                    CreateReservEntry.GetLastEntry(ReservEntry1);
                    if RecGItem."Order Tracking Policy" = RecGItem."Order Tracking Policy"::"Tracking & Action Msg." then
                        CduGReservEngineMgt.UpdateActionMessages(ReservEntry1);

                    if ModifySharedFields then begin
                        ReservEntry1.SetPointerFilter();
                        ReservEntry1.SetRange("Lot No.", ReservEntry1."Lot No.");
                        ReservEntry1.SetRange("Serial No.", ReservEntry1."Serial No.");
                        ReservEntry1.SetFilter("Entry No.", '<>%1', ReservEntry1."Entry No.");
                        FctModifyFieldsWithinFilter(ReservEntry1, NewTrackingSpecification);
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
                        RecGTempReservEntry.SetRange("Serial No.", OldTrackingSpecification."Serial No.");
                        RecGTempReservEntry.SetRange("Lot No.", OldTrackingSpecification."Lot No.");
                        OldTrackingSpecification."Serial No." := '';
                        OldTrackingSpecification."Lot No." := '';
                        OldTrackingSpecification."Warranty Date" := 0D;
                        OldTrackingSpecification."Expiration Date" := 0D;
                        QtyToAdd := CduGReservEngineMgt.AddItemTrackingToTempRecSet(
                                     RecGTempReservEntry, OldTrackingSpecification,
                                     OldTrackingSpecification."Quantity (Base)", DecLTempDec,
                                     RecGItemTrackingCode);
                        RecGTempReservEntry.SetRange("Serial No.");
                        RecGTempReservEntry.SetRange("Lot No.");
                        ReservationMgt.DeleteReservEntries(true, 0, ReservEntry1)
                    end
                    else begin
                        ReservationMgt.DeleteReservEntries(false, ReservEntry1."Quantity (Base)" -
                          OldTrackingSpecification."Quantity Handled (Base)", ReservEntry1);
                        if ModifySharedFields then begin
                            ReservEntry1.SetRange("Reservation Status");
                            FctModifyFieldsWithinFilter(ReservEntry1, OldTrackingSpecification);
                        end;
                    end;
                    OK := true;
                end;
        end;
        FctSetQtyToHandleAndInvoice(NewTrackingSpecification);
    end;

    local procedure FctUpdateOrderTracking()
    begin
        if not CduGReservEngineMgt.CollectAffectedSurplusEntries(RecGTempReservEntry) then
            exit;
        if RecGItem."Order Tracking Policy" = RecGItem."Order Tracking Policy"::None then
            exit;
        CduGReservEngineMgt.UpdateOrderTracking(RecGTempReservEntry);
    end;

    local procedure FctReestablishReservations()
    var
        LateBindingMgt: Codeunit "Late Binding Management";
    begin
        if RecGTempItemTrackLineReserv.FindSet() then
            repeat
                LateBindingMgt.ReserveItemTrackingLine(RecGTempItemTrackLineReserv);
                FctSetQtyToHandleAndInvoice(RecGTempItemTrackLineReserv);
            until RecGTempItemTrackLineReserv.Next() = 0;
        RecGTempItemTrackLineReserv.DeleteAll();
    end;

    local procedure FctModifyFieldsWithinFilter(var ReservEntry1: Record "Reservation Entry"; var TrackingSpecification: Record "Tracking Specification")
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

    local procedure FctSetQtyToHandleAndInvoice(TrackingSpecification: Record "Tracking Specification") OK: Boolean
    var
        ReservEntry1: Record "Reservation Entry";
        CduLItemTrackingMgt: Codeunit "Item Tracking Management";
        QtyAlreadyHandledToInvoice: Decimal;
        QtyToHandleThisLine: Decimal;
        QtyToInvoiceThisLine: Decimal;
        TotalQtyToHandle: Decimal;
        TotalQtyToInvoice: Decimal;
    begin
        OK := false;
        TotalQtyToHandle := TrackingSpecification."Qty. to Handle (Base)";
        TotalQtyToInvoice := TrackingSpecification."Qty. to Invoice (Base)";

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
            CduLItemTrackingMgt.SetPointerFilter(TrackingSpecification);
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

    local procedure FctSynchronizeLinkedSources(RecPPurchLine: Record "Purchase Line")
    var
        CduLItemTrackingMgt: Codeunit "Item Tracking Management";
        TxtLCurrentSourceRowID: Text[100];
        TxtLSecondSourceRowID: Text[100];
    begin
        Clear(TxtLSecondSourceRowID);
        Clear(TxtLSecondSourceRowID);
        if (RecPPurchLine."Drop Shipment") and (RecPPurchLine."Sales Order No." <> '') then begin
            TxtLSecondSourceRowID := CduLItemTrackingMgt.ComposeRowID(DATABASE::"Sales Line",
                                                                 1, RecPPurchLine."Sales Order No.", '', 0, RecPPurchLine."Sales Order Line No."
          );
            TxtLCurrentSourceRowID := CduLItemTrackingMgt.ComposeRowID(DATABASE::"Purchase Line",
                                                                 1, RecPPurchLine."Document No.", '', 0, RecPPurchLine."Line No.");
        end;
        if (TxtLSecondSourceRowID = '') or (TxtLCurrentSourceRowID = '') then
            exit;
        CduLItemTrackingMgt.SynchronizeItemTracking(TxtLCurrentSourceRowID, TxtLSecondSourceRowID, '');
    end;

    local procedure FctSynchronizeLinkedSourcesSal(RecPSalesLine: Record "Sales Line")
    var
        CduLItemTrackingMgt: Codeunit "Item Tracking Management";
        TxtLCurrentSourceRowID: Text[100];
        TxtLSecondSourceRowID: Text[100];
    begin
        Clear(TxtLSecondSourceRowID);
        Clear(TxtLSecondSourceRowID);
        if (RecPSalesLine."Drop Shipment") and (RecPSalesLine."Purchase Order No." <> '') then begin
            TxtLSecondSourceRowID := CduLItemTrackingMgt.ComposeRowID(DATABASE::"Sales Line",
                                                                 1, RecPSalesLine."Purchase Order No."
                                                                 , '', 0, RecPSalesLine."Purch. Order Line No.");
            TxtLCurrentSourceRowID := CduLItemTrackingMgt.ComposeRowID(DATABASE::"Sales Line",
                                                                 1, RecPSalesLine."Document No.", '', 0,
                                                                 RecPSalesLine."Line No.");
        end;
        if (TxtLSecondSourceRowID = '') or (TxtLCurrentSourceRowID = '') then
            exit;
        CduLItemTrackingMgt.SynchronizeItemTracking(TxtLCurrentSourceRowID, TxtLSecondSourceRowID, '');
    end;

    local procedure FctIsSerializedItem(RecPItem: Record Item; IntPTrackingType: Integer)
    var
        RecLItemTrackingCode: Record "Item Tracking Code";
    begin
        if IntPTrackingType = 0 then
            exit;
        RecPItem.TestField("Item Tracking Code");
        RecLItemTrackingCode.Get(RecPItem."Item Tracking Code");
        case IntPTrackingType of
            1:
                begin
                    RecLItemTrackingCode.TestField("Lot Purchase Inbound Tracking");
                    RecLItemTrackingCode.TestField("Lot Purchase Outbound Tracking");
                end;
            2:
                begin
                    RecLItemTrackingCode.TestField("SN Purchase Inbound Tracking");
                    RecLItemTrackingCode.TestField("SN Purchase Outbound Tracking");
                    RecLItemTrackingCode.TestField("Lot Purchase Inbound Tracking");
                    RecLItemTrackingCode.TestField("Lot Purchase Outbound Tracking");
                end;
            3:
                begin
                    RecLItemTrackingCode.TestField("SN Purchase Inbound Tracking");
                    RecLItemTrackingCode.TestField("SN Purchase Outbound Tracking");
                end;
        end;
    end;

    local procedure FctIsSerializedItem2(RecPItem: Record Item; IntPTrackingType: Integer)
    var
        RecLItemTrackingCode: Record "Item Tracking Code";
    begin
        if IntPTrackingType = 0 then
            exit;
        RecPItem.TestField("Item Tracking Code");
        RecLItemTrackingCode.Get(RecPItem."Item Tracking Code");
        case IntPTrackingType of
            1:
                begin
                    RecLItemTrackingCode.TestField("Lot Pos. Adjmt. Inb. Tracking");
                    RecLItemTrackingCode.TestField("Lot Pos. Adjmt. Outb. Tracking");
                    RecLItemTrackingCode.TestField("Lot Neg. Adjmt. Inb. Tracking");
                    RecLItemTrackingCode.TestField("Lot Neg. Adjmt. Outb. Tracking");
                end;
            2:
                begin
                    RecLItemTrackingCode.TestField("Lot Pos. Adjmt. Inb. Tracking");
                    RecLItemTrackingCode.TestField("Lot Pos. Adjmt. Outb. Tracking");
                    RecLItemTrackingCode.TestField("Lot Neg. Adjmt. Inb. Tracking");
                    RecLItemTrackingCode.TestField("Lot Neg. Adjmt. Outb. Tracking");
                    RecLItemTrackingCode.TestField("SN Pos. Adjmt. Inb. Tracking");
                    RecLItemTrackingCode.TestField("SN Pos. Adjmt. Outb. Tracking");
                    RecLItemTrackingCode.TestField("SN Neg. Adjmt. Inb. Tracking");
                    RecLItemTrackingCode.TestField("SN Neg. Adjmt. Outb. Tracking");
                end;
            3:
                begin
                    RecLItemTrackingCode.TestField("SN Pos. Adjmt. Inb. Tracking");
                    RecLItemTrackingCode.TestField("SN Pos. Adjmt. Outb. Tracking");
                    RecLItemTrackingCode.TestField("SN Neg. Adjmt. Inb. Tracking");
                    RecLItemTrackingCode.TestField("SN Neg. Adjmt. Outb. Tracking");
                end;
        end;
    end;

    local procedure FctIsSerializedItemSales(RecPItem: Record Item; IntPTrackingType: Integer)
    var
        RecLItemTrackingCode: Record "Item Tracking Code";
    begin
        if IntPTrackingType = 0 then
            exit;
        RecPItem.TestField("Item Tracking Code");
        RecLItemTrackingCode.Get(RecPItem."Item Tracking Code");
        case IntPTrackingType of
            1:
                begin
                    RecLItemTrackingCode.TestField("Lot Sales Inbound Tracking");
                    RecLItemTrackingCode.TestField("Lot Sales Outbound Tracking");
                end;
            2:
                begin
                    RecLItemTrackingCode.TestField("SN Sales Inbound Tracking");
                    RecLItemTrackingCode.TestField("SN Sales Outbound Tracking");
                    RecLItemTrackingCode.TestField("Lot Sales Inbound Tracking");
                    RecLItemTrackingCode.TestField("Lot Sales Outbound Tracking");
                end;
            3:
                begin
                    RecLItemTrackingCode.TestField("SN Sales Inbound Tracking");
                    RecLItemTrackingCode.TestField("SN Sales Outbound Tracking");
                end;
        end;
    end;
}

