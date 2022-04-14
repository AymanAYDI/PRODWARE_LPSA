codeunit 50021 "PWD LPSA Functions Mgt."
{
    //---TAB37---
    procedure Fct_OnValidateNoOnBeforeUpdateDates_SalesLine(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    begin
        SalesLine."Promised Delivery Date" := SalesHeader."Promised Delivery Date";
        SalesLine."Requested Delivery Date" := SalesHeader."Requested Delivery Date";
        SalesLine."Promised Delivery Date" := SalesHeader."Requested Delivery Date";
        SalesLine."Planned Delivery Date" := SalesHeader."Requested Delivery Date";
        SalesLine."Planned Shipment Date" := SalesHeader."Requested Delivery Date";
        SalesLine."PWD Initial Shipment Date" := SalesHeader."Requested Delivery Date";
        IF SalesHeader."Requested Delivery Date" <> 0D THEN
            SalesLine."Shipment Date" := SalesHeader."Requested Delivery Date";

        IF SalesHeader."PWD Cust Promised Delivery Date" <> 0D THEN
            SalesLine."PWD Cust Promised Delivery Date" := SalesHeader."PWD Cust Promised Delivery Date"
        ELSE
            SalesLine."PWD Cust Promised Delivery Date" := SalesHeader."Requested Delivery Date";

    end;
    //---TAB36---
    procedure RunPageCommentSheet(var SalesHeader: Record "Sales Header")
    var
        RecLComment: Record 97;
        PageLCommentSheet: Page 124;
    begin
        //>>TDL.LPSA.20.04.15
        RecLComment.RESET;
        RecLComment.SETRANGE("Table Name", RecLComment."Table Name"::Customer);
        RecLComment.SETRANGE("No.", SalesHeader."Bill-to Customer No.");
        IF RecLComment.FINDFIRST THEN BEGIN
            CLEAR(PageLCommentSheet);
            PageLCommentSheet.SETTABLEVIEW(RecLComment);
            PageLCommentSheet.RUNMODAL;
        END;
        //<<TDL.LPSA.20.04.15
    end;

    //---TAB5406---
    procedure CheckCapLedgEntry(var Rec: Record "Prod. Order Line"): Boolean
    var
        CapLedgEntry: Record "Capacity Ledger Entry";
    begin
        CapLedgEntry.SetCurrentKey("Order Type", "Order No.", "Order Line No.");
        CapLedgEntry.SetRange("Order Type", CapLedgEntry."Order Type"::Production);
        CapLedgEntry.SetRange("Order No.", Rec."Prod. Order No.");
        CapLedgEntry.SetRange("Order Line No.", Rec."Line No.");

        exit(not CapLedgEntry.IsEmpty);
    end;

    procedure CheckSubcontractPurchOrder(var Rec: Record "Prod. Order Line"): Boolean
    var
        PurchLine: Record "Purchase Line";
    begin
        PurchLine.SetCurrentKey(
          "Document Type", Type, "Prod. Order No.", "Prod. Order Line No.", "Routing No.", "Operation No.");
        PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
        PurchLine.SetRange(Type, PurchLine.Type::Item);
        PurchLine.SetRange("Prod. Order No.", Rec."Prod. Order No.");
        PurchLine.SetRange("Prod. Order Line No.", Rec."Line No.");

        exit(not PurchLine.IsEmpty);
    end;

    PROCEDURE UpdateNextLevelProdLine(RecPProdOrderLine: Record 5406; CodPLotNo: Code[20]);
    VAR
        RecLProdOrderComponent: Record 5407;
        RecLNegReservEntry: Record 337;
        RecLPosReservEntry: Record 337;
        RecLProdOrderLine: Record 5406;
        RecLLinkedProdOrder: Record 5405;
        RecLPlannerOneSetup: Record 8076502;
        RecLPlannerOneUtil: Codeunit 8076503;
        CduLCalcProdOrder: Codeunit 99000773;
        DecLRemQty: Decimal;
        DecLBaseRemQty: Decimal;
        CstL50000: Label 'ENU=More than on product order is linked to item %1, lot %2. Update is stopped.';
    BEGIN
        //>>FE_PROD01.002
        IF CodPLotNo = '' THEN
            EXIT;
        // Search Reservation entry for item, lot no.
        RecLPosReservEntry.RESET;
        RecLPosReservEntry.SETRANGE("Item No.", RecPProdOrderLine."Item No.");
        RecLPosReservEntry.SETRANGE("Lot No.", CodPLotNo);
        RecLPosReservEntry.SETRANGE(Positive, TRUE);
        // >>FE_LAPRIERRETTE_GP0003 : Correctif
        RecLPosReservEntry.SETRANGE("Reservation Status", RecLPosReservEntry."Reservation Status"::Reservation);
        // <<FE_LAPRIERRETTE_GP0003
        RecLPosReservEntry.SETRANGE("Source Type", DATABASE::"Item Ledger Entry");
        RecLPosReservEntry.SETRANGE("Item Tracking", RecLPosReservEntry."Item Tracking"::"Lot No.");
        IF RecLPosReservEntry.ISEMPTY THEN
            EXIT;
        //IF RecLPosReservEntry.COUNT > 1 THEN
        //  ERROR(CstL50000,RecPProdOrderLine."Item No.",CodPLotNo);
        RecLPosReservEntry.FINDFIRST;
        // Search associated entry
        RecLNegReservEntry.GET(RecLPosReservEntry."Entry No.", NOT RecLPosReservEntry.Positive);
        IF RecLNegReservEntry."Source Type" <> DATABASE::"Prod. Order Component" THEN
            EXIT;
        RecLProdOrderComponent.GET(RecLNegReservEntry."Source Subtype", RecLNegReservEntry."Source ID",
          RecLNegReservEntry."Source Prod. Order Line", RecLNegReservEntry."Source Ref. No.");
        // Update Quantity of Prod Line
        RecLProdOrderLine.GET(RecLProdOrderComponent.Status, RecLProdOrderComponent."Prod. Order No.",
          RecLProdOrderComponent."Prod. Order Line No.");
        RecLProdOrderLine.VALIDATE(Quantity, RecPProdOrderLine."Finished Quantity" / RecLProdOrderComponent."Quantity per");
        RecLProdOrderLine.MODIFY(TRUE);
        IF NOT (RecLPlannerOneSetup.FINDFIRST
           AND (RecLPlannerOneSetup.ProductionSchedulerEnabled AND RecLPlannerOneUtil.ProdOrderFilter(RecLProdOrderLine.Status, RecPProdOrderLine."Prod. Order No.", RecPProdOrderLine."Line No."))) THEN
            CduLCalcProdOrder.Recalculate(RecLProdOrderLine, 1);
        //<<FE_PROD01.002
    END;


}
