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

        IF SalesHeader."PWD Cust Promised Deliv. Date" <> 0D THEN
            SalesLine."PWD Cust Promis. Delivery Date" := SalesHeader."PWD Cust Promised Deliv. Date"
        ELSE
            SalesLine."PWD Cust Promis. Delivery Date" := SalesHeader."Requested Delivery Date";

    end;
    //---TAB36---
    procedure RunPageCommentSheet(var SalesHeader: Record "Sales Header")
    var
        RecLComment: Record "Comment Line";
        PageLCommentSheet: Page "Comment Sheet";
    begin
        //>>TDL.LPSA.20.04.15
        RecLComment.RESET();
        RecLComment.SETRANGE("Table Name", RecLComment."Table Name"::Customer);
        RecLComment.SETRANGE("No.", SalesHeader."Bill-to Customer No.");
        IF RecLComment.FINDFIRST() THEN BEGIN
            CLEAR(PageLCommentSheet);
            PageLCommentSheet.SETTABLEVIEW(RecLComment);
            PageLCommentSheet.RUNMODAL();
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
    //---CDU22---
    PROCEDURE UpdateNextLevelProdLine(RecPProdOrderLine: Record 5406; CodPLotNo: Code[20]);
    VAR
        RecLProdOrderComponent: Record "Prod. Order Component";
        RecLProdOrderLine: Record "Prod. Order Line";
        RecLNegReservEntry: Record "Reservation Entry";
        RecLPosReservEntry: Record "Reservation Entry";
        CduLCalcProdOrder: Codeunit "Calculate Prod. Order";
    BEGIN
        //>>FE_PROD01.002
        IF CodPLotNo = '' THEN
            EXIT;
        // Search Reservation entry for item, lot no.
        RecLPosReservEntry.RESET();
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
        RecLPosReservEntry.FINDFIRST();
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
        // IF NOT (RecLPlannerOneSetup.FINDFIRST 
        //    AND (RecLPlannerOneSetup.ProductionSchedulerEnabled AND RecLPlannerOneUtil.ProdOrderFilter(RecLProdOrderLine.Status, RecPProdOrderLine."Prod. Order No.", RecPProdOrderLine."Line No."))) THEN
        CduLCalcProdOrder.Recalculate(RecLProdOrderLine, 1, true);
        //<<FE_PROD01.002
    END;
    //---CDU80---
    PROCEDURE FctSalesLineFilterWMS(VAR RecPSalesLine: Record 37);
    BEGIN
        //RecPSalesLine.SETRANGE(WMS_Status,RecPSalesLine.WMS_Status::" ");
        RecPSalesLine.SETRANGE("PWD WMS_Item", TRUE);
        RecPSalesLine.CALCFIELDS("PWD WMS_Location");
        RecPSalesLine.SETRANGE("PWD WMS_Location", TRUE);
        RecPSalesLine.SETRANGE(Type, RecPSalesLine.Type::Item);
        RecPSalesLine.SETFILTER("Outstanding Quantity", '<>%1', 0);
        RecPSalesLine.SETRANGE("Drop Shipment", FALSE);
        RecPSalesLine.SETRANGE("PWD WMS_Cust_Blocked", RecPSalesLine."PWD WMS_Cust_Blocked"::" ");
    END;
    //---CDU241---
    PROCEDURE FctRecreateJournalLine(Var ItemJnlLine: Record 83);
    VAR
        RecLItem: Record Item;
        RecLItemJournalLine: Record "Item Journal Line";
        RecLItemLedgerEntry: Record "Item Ledger Entry";
        RecLProdOrderComponent: Record "Prod. Order Component";
        RecLProdOrderLine: Record "Prod. Order Line";
        RecLProdOrderRoutingLine: Record "Prod. Order Routing Line";
        RecLReservationEntry: Record "Reservation Entry";
        CduLLotInheritanceMgt: Codeunit "PWD Lot Inheritance Mgt.PW";
    BEGIN
        IF ItemJnlLine."Entry Type" = ItemJnlLine."Entry Type"::Output THEN BEGIN
            RecLItemJournalLine.RESET();

            //>>NICOLAS
            RecLItemJournalLine.SETRANGE("Journal Template Name", ItemJnlLine."Journal Template Name");
            RecLItemJournalLine.SETRANGE("Journal Batch Name", ItemJnlLine."Journal Batch Name");
            //<<NICOLAS
            RecLItemJournalLine.SETRANGE(RecLItemJournalLine."Item No.", ItemJnlLine."Item No.");
            RecLItemJournalLine.SETRANGE(RecLItemJournalLine."Entry Type", RecLItemJournalLine."Entry Type"::Output);
            RecLItemJournalLine.SETRANGE(RecLItemJournalLine."Source No.", ItemJnlLine."Source No.");
            RecLItemJournalLine.SETRANGE(RecLItemJournalLine."Document No.", ItemJnlLine."Document No.");
            RecLItemJournalLine.SETRANGE(RecLItemJournalLine."Order Type", ItemJnlLine."Order Type");
            RecLItemJournalLine.SETRANGE(RecLItemJournalLine."Order No.", ItemJnlLine."Order No.");
            RecLItemJournalLine.SETRANGE(RecLItemJournalLine."Order Line No.", ItemJnlLine."Order Line No.");
            RecLItemJournalLine.SETRANGE(RecLItemJournalLine."Source Type", ItemJnlLine."Source Type");
            IF RecLItemJournalLine.FINDLAST() THEN BEGIN

                //On v‚rifie si le journal line est associ‚ … la derniŠre ligne de gamme pour pouvoir y associer la tra‡a
                RecLProdOrderRoutingLine.SETRANGE(Status, RecLProdOrderLine.Status::Released);
                RecLProdOrderRoutingLine.SETRANGE(RecLProdOrderRoutingLine."Prod. Order No.", ItemJnlLine."Order No.");
                RecLProdOrderRoutingLine.SETRANGE(RecLProdOrderRoutingLine."Routing Reference No.", ItemJnlLine."Order Line No.");
                RecLProdOrderRoutingLine.SETRANGE(RecLProdOrderRoutingLine."Routing No.", ItemJnlLine."Routing No.");
                //RecLProdOrderRoutingLine.SETRANGE(RecLProdOrderRoutingLine."Operation No.",ItemJnlLine."Operation No.");
                RecLProdOrderRoutingLine.SETRANGE(RecLProdOrderRoutingLine."Operation No.", RecLItemJournalLine."Operation No.");
                IF RecLProdOrderRoutingLine.FINDFIRST() THEN
                    IF RecLProdOrderRoutingLine."Next Operation No." = '' THEN
                        IF RecLProdOrderLine.GET(RecLProdOrderLine.Status::Released, ItemJnlLine."Order No.",
                        ItemJnlLine."Order Line No.") THEN
                            IF RecLItem.GET(RecLProdOrderLine."Item No.") THEN
                                //On regarde si l'article de l'OF doit recevoir son num‚ro de lot depuis le composant de MP
                                IF CduLLotInheritanceMgt.CheckItemDetermined(RecLItem) THEN BEGIN
                                    RecLProdOrderComponent.SETRANGE(RecLProdOrderComponent.Status, RecLProdOrderComponent.Status::Released);
                                    RecLProdOrderComponent.SETRANGE(RecLProdOrderComponent."Prod. Order No.", RecLProdOrderLine."Prod. Order No.");
                                    RecLProdOrderComponent.SETRANGE(RecLProdOrderComponent."Prod. Order Line No.", RecLProdOrderLine."Line No.");
                                    RecLProdOrderComponent.SETRANGE(RecLProdOrderComponent."PWD Lot Determining", TRUE);
                                    //On recupŠre la ligne de composant OF qui a le num‚ro de lot … copier
                                    IF RecLProdOrderComponent.FINDFIRST() THEN BEGIN
                                        RecLReservationEntry.SETRANGE(RecLReservationEntry."Item No.", RecLProdOrderComponent."Item No.");
                                        RecLReservationEntry.SETRANGE(RecLReservationEntry."Source Subtype", RecLReservationEntry."Source Subtype"::"3");
                                        RecLReservationEntry.SETRANGE(RecLReservationEntry."Source ID", RecLProdOrderComponent."Prod. Order No.");
                                        RecLReservationEntry.SETRANGE(RecLReservationEntry."Source Prod. Order Line",
                                        RecLProdOrderComponent."Prod. Order Line No.");
                                        RecLReservationEntry.SETRANGE(RecLReservationEntry."Source Ref. No.", RecLProdOrderComponent."Line No.");
                                        RecLReservationEntry.SETFILTER(RecLReservationEntry."Lot No.", '<>%1', '');
                                        //Si il exite une ecriture r‚servation alors on copie le num‚ro de lot
                                        IF Not RecLReservationEntry.IsEmpty THEN BEGIN
                                            //Recr‚ation des lignes du journal selon le template utilis‚
                                            IF FctCheckJnlTemplateIsFromOF(RecLItemJournalLine) THEN
                                                FctRecreateJournalFromOF(RecLProdOrderLine, ItemJnlLine)
                                            ELSE
                                                FctRecreateJournalFromProd(RecLProdOrderLine, RecLItemJournalLine);
                                        END
                                        ELSE BEGIN
                                            // Il n'existe pas d'‚criture r‚servation on va voir si la MP a ‚t‚ consomm‚e cad
                                            // si il existe une ‚criture article pour la ligne de composant OF
                                            RecLItemLedgerEntry.SETRANGE(RecLItemLedgerEntry."Item No.", RecLProdOrderComponent."Item No.");
                                            RecLItemLedgerEntry.SETRANGE(RecLItemLedgerEntry."Source Type", RecLItemLedgerEntry."Source Type"::Item);
                                            RecLItemLedgerEntry.SETRANGE(RecLItemLedgerEntry."Document No.", RecLProdOrderComponent."Prod. Order No.");
                                            RecLItemLedgerEntry.SETRANGE("Entry Type", RecLItemLedgerEntry."Entry Type"::Consumption);
                                            RecLItemLedgerEntry.SETRANGE("Order No.", RecLProdOrderComponent."Prod. Order No.");
                                            RecLItemLedgerEntry.SETRANGE("Order Line No.", RecLProdOrderComponent."Prod. Order Line No.");
                                            RecLItemLedgerEntry.SETRANGE("Prod. Order Comp. Line No.", RecLProdOrderComponent."Line No.");
                                            RecLItemLedgerEntry.SETFILTER(RecLItemLedgerEntry."Lot No.", '<>%1', '');
                                            IF Not RecLItemLedgerEntry.IsEmpty THEN
                                                //Recr‚ation des lignes du journal selon le template utilis‚
                                                IF FctCheckJnlTemplateIsFromOF(RecLItemJournalLine) THEN
                                                    FctRecreateJournalFromOF(RecLProdOrderLine, ItemJnlLine)
                                                ELSE
                                                    FctRecreateJournalFromProd(RecLProdOrderLine, RecLItemJournalLine);
                                        END;
                                    END;
                                END;
            END;
        END;
    END;

    PROCEDURE FctCheckJnlTemplateIsFromOF(RecPItemJournalLine: Record 83): Boolean;
    VAR
        RecLItemJnlTemplate: Record "Item Journal Template";
    BEGIN
        //On regarde si on est en train de valider le journal depuis l'OF ou depuis la feuille de production
        RecLItemJnlTemplate.RESET();
        RecLItemJnlTemplate.SETRANGE("Page ID", Page::"Production Journal");
        RecLItemJnlTemplate.SETRANGE(Recurring, FALSE);
        RecLItemJnlTemplate.SETRANGE(Type, RecLItemJnlTemplate.Type::"Prod. Order");
        IF RecLItemJnlTemplate.FINDFIRST() THEN BEGIN
            IF RecPItemJournalLine."Journal Template Name" = RecLItemJnlTemplate.Name THEN
                EXIT(TRUE)
            ELSE
                EXIT(FALSE);
        END
        ELSE
            EXIT(FALSE);
    END;

    PROCEDURE FctRecreateJournalFromOF(RecPProdOrderLine: Record 5406; Var ItemJnlLine: Record 83);
    VAR
        RecLProdOrder: Record "Production Order";
        CduLLotInheritanceMgt: Codeunit "PWD Lot Inheritance Mgt.PW";
    BEGIN
        //Suppression et Recr‚ation des lignes de journal avec le num‚ro de lot du composant
        RecLProdOrder.GET(RecPProdOrderLine.Status, RecPProdOrderLine."Prod. Order No.");

        //CduLProductionJournalMgt.DeleteReservEntryFromOF(RecPProdOrderLine."Prod. Order No.",RecPProdOrderLine."Line No.");
        //COMMIT;

        CduLLotInheritanceMgt.AutoCreatePOLTrackingPWD(RecPProdOrderLine, ItemJnlLine.Quantity);
        COMMIT();

        //CduLProductionJournalMgt.CreateJnlLines(RecLProdOrder,RecPProdOrderLine."Line No.");
        //ItemTrackingMgt.CopyItemTracking(RecPProdOrderLine.RowID1,ItemJnlLine.RowID1,FALSE);
        FctCopyItemTrackingSpec(RecPProdOrderLine.RowID1(), ItemJnlLine.RowID1(), FALSE, ItemJnlLine.Quantity);
        COMMIT();
    END;

    PROCEDURE FctRecreateJournalFromProd(RecPProdOrderLine: Record 5406; RecPItemJournalLine: Record 83);
    VAR
        CduLLotInheritanceMgt: Codeunit "PWD Lot Inheritance Mgt.PW";
        LPSASetGetFunctions: codeunit "PWD LPSA Set/Get Functions.";
    BEGIN
        //Suppression et Recr‚ation des lignes de journal avec le num‚ro de lot du composant
        LPSASetGetFunctions.InitJnalName(RecPItemJournalLine."Journal Template Name",
        RecPItemJournalLine."Journal Batch Name");
        //CduLProductionJournalMgt.DeleteReservEntry(RecPProdOrderLine."Prod. Order No.",RecPProdOrderLine."Line No.");
        //COMMIT;

        CduLLotInheritanceMgt.AutoCreatePOLTrackingPWD(RecPProdOrderLine, RecPItemJournalLine.Quantity);
        COMMIT();

        //CduLProductionJournalMgt.InsertOutputJnlLine2(RecPItemJournalLine,RecPProdOrderLine);
        //ItemTrackingMgt.CopyItemTracking(RecPProdOrderLine.RowID1,RecPItemJournalLine.RowID1,FALSE);
        FctCopyItemTrackingSpec(RecPProdOrderLine.RowID1(), RecPItemJournalLine.RowID1(), FALSE, RecPItemJournalLine.Quantity);
        COMMIT();
    END;

    PROCEDURE ClearWrongReservEntries(Var ItemJnlLine: Record 83);
    VAR
        RecLItemJnlLine: Record "Item Journal Line";
        ItemJnlTemplate: Record "Item Journal Template";
        RecLReservEntry: Record "Reservation Entry";
        RecLReservEntry2: Record "Reservation Entry";
    BEGIN
        ItemJnlTemplate.Get(ItemJnlLine."Journal Template Name");
        RecLReservEntry.RESET();
        RecLReservEntry.SETRANGE("Source Type", DATABASE::"Item Journal Line");
        RecLReservEntry.SETRANGE("Source Subtype", RecLReservEntry."Source Subtype"::"5");
        RecLReservEntry.SETRANGE("Source ID", ItemJnlTemplate.Name);
        RecLReservEntry.SETRANGE("Source Batch Name", ItemJnlLine."Journal Batch Name");
        IF NOT RecLReservEntry.ISEMPTY THEN BEGIN
            RecLReservEntry.LOCKTABLE();
            RecLReservEntry.FINDSET();
            REPEAT
                IF NOT RecLItemJnlLine.GET(RecLReservEntry."Source ID", RecLReservEntry."Source Batch Name", RecLReservEntry."Source Ref. No.")
                THEN BEGIN
                    IF RecLReservEntry2.GET(RecLReservEntry."Entry No.", NOT RecLReservEntry.Positive) THEN
                        RecLReservEntry2.DELETE();
                    RecLReservEntry.DELETE();
                END;
            UNTIL RecLReservEntry.NEXT() = 0;
        END;
    END;

    //---CDU365---
    PROCEDURE SalesHeaderSellToFixedAddr(VAR AddrArray: ARRAY[8] OF Text[50]; VAR SalesHeader: Record 36);
    BEGIN
        AddrArray[1] := SalesHeader."Sell-to Customer Name";
        AddrArray[2] := SalesHeader."Sell-to Customer Name 2";
        //AddrArray[3]:=SalesHeader."Sell-to Contact";
        AddrArray[3] := SalesHeader."Sell-to Address";
        AddrArray[4] := SalesHeader."Sell-to Address 2";
        AddrArray[5] := SalesHeader."Sell-to Post Code" + ' ' + UPPERCASE(SalesHeader."Sell-to City");
    END;

    PROCEDURE SalesHeaderBillToFixedAddr(VAR AddrArray: ARRAY[8] OF Text[50]; VAR SalesHeader: Record 36);
    BEGIN
        AddrArray[1] := SalesHeader."Bill-to Name";
        AddrArray[2] := SalesHeader."Bill-to Name 2";
        //AddrArray[3]:=SalesHeader."Bill-to Contact";
        AddrArray[3] := SalesHeader."Bill-to Address";
        AddrArray[4] := SalesHeader."Bill-to Address 2";
        AddrArray[5] := SalesHeader."Bill-to Post Code" + ' ' + UPPERCASE(SalesHeader."Bill-to City");
    END;

    PROCEDURE SalesCrMemoBillToFixedAddr(VAR AddrArray: ARRAY[8] OF Text[50]; VAR SalesCrMemoHeader: Record 114);
    BEGIN
        AddrArray[1] := SalesCrMemoHeader."Bill-to Name";
        AddrArray[2] := SalesCrMemoHeader."Bill-to Name 2";
        //AddrArray[3]:=SalesCrMemoHeader."Bill-to Contact";
        AddrArray[3] := SalesCrMemoHeader."Bill-to Address";
        AddrArray[4] := SalesCrMemoHeader."Bill-to Address 2";
        AddrArray[5] := SalesCrMemoHeader."Bill-to Post Code" + ' ' + UPPERCASE(SalesCrMemoHeader."Bill-to City");
    END;

    PROCEDURE SalesShptShipToFixedAddr(VAR AddrArray: ARRAY[8] OF Text[50]; VAR SalesShptHeader: Record 110);
    BEGIN
        AddrArray[1] := SalesShptHeader."Ship-to Name";
        AddrArray[2] := SalesShptHeader."Ship-to Name 2";
        //AddrArray[3]:=SalesShptHeader."Ship-to Contact";
        AddrArray[3] := SalesShptHeader."Ship-to Address";
        AddrArray[4] := SalesShptHeader."Ship-to Address 2";
        AddrArray[5] := SalesShptHeader."Ship-to Post Code" + ' ' + UPPERCASE(SalesShptHeader."Ship-to City");
    END;

    PROCEDURE SalesInvBillToFixedAddr(VAR AddrArray: ARRAY[8] OF Text[50]; VAR SalesInvHeader: Record 112);
    BEGIN
        AddrArray[1] := SalesInvHeader."Bill-to Name";
        AddrArray[2] := SalesInvHeader."Bill-to Name 2";
        //AddrArray[2]:=SalesInvHeader."Bill-to Contact";
        AddrArray[3] := SalesInvHeader."Bill-to Address";
        AddrArray[4] := SalesInvHeader."Bill-to Address 2";
        AddrArray[5] := SalesInvHeader."Bill-to Post Code" + ' ' + UPPERCASE(SalesInvHeader."Bill-to City");
    END;

    PROCEDURE TransferShptFixedTransferTo(VAR AddrArray: ARRAY[8] OF Text[50]; VAR TransShptHeader: Record 5744);
    BEGIN
        AddrArray[1] := TransShptHeader."Transfer-to Name";
        AddrArray[2] := TransShptHeader."Transfer-to Name 2";
        //AddrArray[2]:=TransShptHeader."Transfer-to Contact";
        AddrArray[3] := TransShptHeader."Transfer-to Address";
        AddrArray[4] := TransShptHeader."Transfer-to Address 2";
        AddrArray[5] := TransShptHeader."Transfer-to Post Code" + ' ' + UPPERCASE(TransShptHeader."Transfer-to City");
    END;

    PROCEDURE PurchShptBuyFromFixedAddr(VAR AddrArray: ARRAY[8] OF Text[50]; VAR ReturnShptHeader: Record 6650);
    BEGIN
        AddrArray[1] := ReturnShptHeader."Buy-from Vendor Name";
        AddrArray[2] := ReturnShptHeader."Buy-from Vendor Name 2";
        AddrArray[3] := ReturnShptHeader."Buy-from Address";
        AddrArray[4] := ReturnShptHeader."Buy-from Address 2";
        AddrArray[5] := ReturnShptHeader."Buy-from Post Code" + ' ' + UPPERCASE(ReturnShptHeader."Buy-from City");
    END;
    //---CDU415---
    PROCEDURE SubcontractorOrder(PurchHeader: Record 38): Boolean;
    VAR
        PurchaseLines: Record "Purchase Line";
    BEGIN
        //>>FE_LAPIERRETTE_NDT01.001
        PurchaseLines.SETRANGE("Document Type", PurchHeader."Document Type");
        PurchaseLines.SETRANGE("Document No.", PurchHeader."No.");
        PurchaseLines.SETFILTER("Prod. Order No.", '<>%1', '');
        EXIT(NOT PurchaseLines.ISEMPTY);
        //<<FE_LAPIERRETTE_NDT01.001
    END;

    PROCEDURE MRPOrder(PurchHeader: Record 38): Boolean;
    VAR
        RecLPurchSetup: Record "Purchases & Payables Setup";
    BEGIN
        //>>FE_LAPIERRETTE_NDT01.001
        RecLPurchSetup.GET();
        IF PurchHeader."No. Series" = RecLPurchSetup."Order Nos." THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
        //<<FE_LAPIERRETTE_NDT01.001
    END;

    //---CDU99000854---
    procedure Fct_OnBeforeCreateSupply_InventoryProfileOffsetting(var Supply: Record "Inventory Profile"; var Demand: Record "Inventory Profile")
    var
        ProdOrder: Record "Production Order";
        //SalesLine: Record "Sales Line";
        ReqLine: Record "Requisition Line";
    //Counter: Integer;
    begin
        CASE Demand."Source Type" OF
            DATABASE::"Sales Line":
                //IF RecLSalesLine.GET(Demand."Source Order Status",Demand."Source ID",Demand."Source Ref. No.") THEN BEGIN
                IF Demand."PWD Transmitted Order No." THEN BEGIN
                    Supply."PWD Original Source Id" := Demand."PWD Original Source Id";
                    Supply."PWD Original Source No." := Demand."PWD Original Source No.";
                    Supply."PWD Original Source Position" := Demand."PWD Original Source Position";
                    Supply."PWD Original Counter" := 0;
                    Supply."PWD Transmitted Order No." := TRUE;
                END;
            DATABASE::"Planning Component":
                IF ReqLine.GET(Demand."Source ID", Demand."Source Batch Name", Demand."Source Prod. Order Line") THEN
                    IF ReqLine."PWD Transmitted Order No." THEN BEGIN
                        Supply."PWD Original Source Id" := ReqLine."PWD Original Source Id";
                        Supply."PWD Original Source No." := ReqLine."PWD Original Source No.";
                        Supply."PWD Original Source Position" := ReqLine."PWD Original Source Position";
                        Supply."PWD Transmitted Order No." := TRUE;

                        ReqLine.RESET();
                        ReqLine.SETRANGE("PWD Original Source Id", Supply."PWD Original Source Id");
                        ReqLine.SETRANGE("PWD Original Source No.", Supply."PWD Original Source No.");
                        ReqLine.SETRANGE("PWD Original Source Position", Supply."PWD Original Source Position");
                        IF ReqLine.FINDLAST() THEN
                            Supply."PWD Original Counter" := ReqLine."PWD Original Counter" + 1;
                    END;
            DATABASE::"Prod. Order Component":
                IF ProdOrder.GET(Demand."Source Order Status", Demand."Source ID") THEN
                    IF ProdOrder."PWD Transmitted Order No." THEN BEGIN
                        Supply."PWD Original Source Id" := Demand."Source Type";
                        Supply."PWD Original Source No." := ProdOrder."PWD Original Source No.";
                        Supply."PWD Original Source Position" := ProdOrder."PWD Original Source Position";
                        Supply."PWD Original Counter" := 1;
                        Supply."PWD Transmitted Order No." := TRUE;
                    END;
        END;
    end;

    PROCEDURE Fct_CalcCounter(CodPSourceNo: Code[20]; IntPSourcePos: Integer): Integer
    VAR
        ReqLine: Record "Requisition Line";
        IntLCounter: Integer;
    BEGIN
        IntLCounter := 0;
        ReqLine.RESET();
        ReqLine.SETRANGE("PWD Original Source No.", CodPSourceNo);
        ReqLine.SETRANGE("PWD Original Source Position", IntPSourcePos);
        IF ReqLine.FINDSET() THEN
            REPEAT
                IF IntLCounter < ReqLine."PWD Original Counter" THEN
                    IntLCounter := ReqLine."PWD Original Counter";
            UNTIL ReqLine.NEXT() = 0;
        EXIT(IntLCounter + 1);
    END;
    //---CDU99000838---
    PROCEDURE VerifyQuantityPhantom(VAR NewProdOrderComp: Record "Prod. Order Component"; VAR OldProdOrderComp: Record "Prod. Order Component")
    VAR
        ReservMgt: Codeunit "Reservation Management";
    BEGIN
        //TODO: Blocked Variable global  dans le codeunit "Prod. Order Comp.-Reserve"
        //   IF Blocked THEN
        //     EXIT;
        IF NewProdOrderComp.Status = NewProdOrderComp.Status::Finished THEN
            EXIT;
        SetSourceForProdOrderComp();
        IF NewProdOrderComp."Qty. per Unit of Measure" <> OldProdOrderComp."Qty. per Unit of Measure" THEN
            ReservMgt.ModifyUnitOfMeasure();
        IF NewProdOrderComp."Remaining Qty. (Base)" * OldProdOrderComp."Remaining Qty. (Base)" < 0 THEN
            ReservMgt.DeleteReservEntries(TRUE, 0)
        ELSE
            ReservMgt.DeleteReservEntries(FALSE, NewProdOrderComp."Remaining Qty. (Base)");
        ReservMgt.ClearSurplus();
        ReservMgt.AutoTrack(NewProdOrderComp."Remaining Qty. (Base)");
        AssignForPlanning(NewProdOrderComp);
    END;

    local procedure SetSourceForProdOrderComp()
    var
        ReservMgt: Codeunit "Reservation Management";
        ProdOrderComp: Record "Prod. Order Component";
        LPSASetGetFunctions: codeunit "PWD LPSA Set/Get Functions.";
        SourceRecRef: RecordRef;
        CalcReservEntry: Record "Reservation Entry";
    begin
        LPSASetGetFunctions.SetProdOrderComp(ProdOrderComp);
        LPSASetGetFunctions.GetCalcReservEntry(CalcReservEntry);
        ProdOrderComp.SetReservationEntry(CalcReservEntry);
        ReservMgt.UpdateReservation(ProdOrderComp."Remaining Qty. (Base)" > 0);
    end;

    local procedure AssignForPlanning(var ProdOrderComp: Record "Prod. Order Component")
    var
        PlanningAssignment: Record "Planning Assignment";
    begin
        if ProdOrderComp.Status = ProdOrderComp.Status::Simulated then
            exit;
        if ProdOrderComp."Item No." <> '' then
            PlanningAssignment.ChkAssignOne(ProdOrderComp."Item No.", ProdOrderComp."Variant Code", ProdOrderComp."Location Code", ProdOrderComp."Due Date");
    end;

    //---CDU99000835---
    // PROCEDURE SetgFromTheSameLot(piSet: Boolean)
    // var
    //     gFromTheSameLot: Boolean;
    // BEGIN
    //     gFromTheSameLot := piSet;
    // END;

    // PROCEDURE SetgLotDeterminingData(piSetLotCode: Code[30]; piSetExpirDate: Date): Code[20]
    // var
    //     LPSASetGetFunctions: codeunit "PWD LPSA Set/Get Functions.";
    //     gLotDeterminingLotCode: Code[30];
    //     gLotDeterminingExpirDate: Date;
    // BEGIN
    //     gLotDeterminingLotCode := piSetLotCode;
    //     gLotDeterminingExpirDate := piSetExpirDate;
    //     IF piSetLotCode <> '' THEN
    //         LPSASetGetFunctions.SetgFromTheSameLot(TRUE);
    // END;
    //---CDU99000813---
    PROCEDURE FctGetTime(OptPType: option "Work Center","Machine Center"; CodPNo: Code[20]; CodPItemNo: Code[20]; DecPQty: Decimal; VAR DecPSetupTime: Decimal; VAR DecPRunTime: Decimal; VAR CodPSetupTimeUnit: Code[10]; VAR CodPRunTimeUnit: Code[10])
    VAR
        RecLManufCyclesSetup: Record "PWD Manufacturing cycles Setup";
        DecLn: Decimal;
        DecLQ: Decimal;
        DecLQm: Decimal;
    BEGIN
        DecLQ := DecPQty;

        RecLManufCyclesSetup.GET(OptPType, CodPNo, CodPItemNo);
        DecLQm := RecLManufCyclesSetup."Maximun Qty by cycle (Base)";
        IF DecLQm <> 0 THEN DecLn := DecLQ / DecLQm;

        DecLn := ROUND(DecLn, 1, '>');

        DecPRunTime := (DecLn * RecLManufCyclesSetup."Run Time") / DecLQ;

        DecPSetupTime := RecLManufCyclesSetup."Setup Time";
        CodPSetupTimeUnit := RecLManufCyclesSetup."Setup Time Unit of Meas. Code";
        CodPRunTimeUnit := RecLManufCyclesSetup."Run Time Unit of Meas. Code";
    END;

    PROCEDURE FctGetTimeForCost(OptPType: Enum "Capacity Type Routing"; CodPNo: Code[20]; CodPItemNo: Code[20]; DecPQty: Decimal; VAR DecPSetupTime: Decimal; VAR DecPRunTime: Decimal; VAR CodPSetupTimeUnit: Code[10]; VAR CodPRunTimeUnit: Code[10])
    VAR
        RecLManufCyclesSetup: Record "PWD Manufacturing cycles Setup";
        DecLQ: Decimal;
        DecLQm: Decimal;
    BEGIN
        DecLQ := DecPQty;

        RecLManufCyclesSetup.GET(OptPType, CodPNo, CodPItemNo);
        DecLQm := RecLManufCyclesSetup."Maximun Qty by cycle (Base)";

        DecPRunTime := (RecLManufCyclesSetup."Run Time") / DecLQm;
        DecPSetupTime := RecLManufCyclesSetup."Setup Time";

        CodPSetupTimeUnit := RecLManufCyclesSetup."Setup Time Unit of Meas. Code";
        CodPRunTimeUnit := RecLManufCyclesSetup."Run Time Unit of Meas. Code";
    END;

    PROCEDURE TransferRoutingProd04(ReqLine: Record 246; ProdOrder: Record 5405; RoutingNo: Code[20]; RoutingRefNo: Integer; RecPProdOrderLine: Record 5406)
    VAR
        MachineCenter: Record "Machine Center";
        PlanningRtngLine: Record "Planning Routing Line";
        ProdOrderRtngLine: Record "Prod. Order Routing Line";
        RecLRoutingLine: Record "Routing Line";
        WorkCenter: Record "Work Center";
        CodLRunTimeUnit: Code[10];
        CodLSetupTimeUnit: Code[10];
        DecLRunTime: Decimal;
        DecLSetupTime: Decimal;
    BEGIN
        PlanningRtngLine.SETRANGE("Worksheet Template Name", ReqLine."Worksheet Template Name");
        PlanningRtngLine.SETRANGE("Worksheet Batch Name", ReqLine."Journal Batch Name");
        PlanningRtngLine.SETRANGE("Worksheet Line No.", ReqLine."Line No.");
        IF PlanningRtngLine.FIND('-') THEN
            REPEAT
                ProdOrderRtngLine.INIT();
                ProdOrderRtngLine.Status := ProdOrder.Status;
                ProdOrderRtngLine."Prod. Order No." := ProdOrder."No.";
                ProdOrderRtngLine."Routing No." := RoutingNo;
                ProdOrderRtngLine."Routing Reference No." := RoutingRefNo;
                ProdOrderRtngLine."Operation No." := PlanningRtngLine."Operation No.";
                ProdOrderRtngLine."Next Operation No." := PlanningRtngLine."Next Operation No.";
                ProdOrderRtngLine."Previous Operation No." := PlanningRtngLine."Previous Operation No.";
                ProdOrderRtngLine.Type := PlanningRtngLine.Type;
                ProdOrderRtngLine."No." := PlanningRtngLine."No.";
                ProdOrderRtngLine."Work Center No." := PlanningRtngLine."Work Center No.";
                ProdOrderRtngLine."Work Center Group Code" := PlanningRtngLine."Work Center Group Code";
                ProdOrderRtngLine.Description := PlanningRtngLine.Description;
                //>>FE_LAPIERRETTE_PROD04.001
                RecLRoutingLine.RESET();
                RecLRoutingLine.SETRANGE(RecLRoutingLine."Routing No.", RecPProdOrderLine."Routing No.");
                RecLRoutingLine.SETRANGE(RecLRoutingLine."Version Code", RecPProdOrderLine."Routing Version Code");
                RecLRoutingLine.SETRANGE(RecLRoutingLine."Operation No.", ProdOrderRtngLine."Operation No.");
                IF RecLRoutingLine.FINDFIRST() THEN BEGIN
                    IF RecLRoutingLine."PWD Fixed-step Prod. Rate time" THEN BEGIN
                        FctGetTime(RecLRoutingLine.Type.AsInteger(), RecLRoutingLine."No.", RecPProdOrderLine."Item No.",
                                   ProdOrder.Quantity,
                                   DecLSetupTime, DecLRunTime,
                                   CodLSetupTimeUnit, CodLRunTimeUnit);

                        ProdOrderRtngLine."Run Time" := DecLRunTime;
                        ProdOrderRtngLine."Setup Time" := DecLSetupTime;
                    END
                    ELSE BEGIN
                        ProdOrderRtngLine."Setup Time" := PlanningRtngLine."Setup Time";
                        ProdOrderRtngLine."Run Time" := PlanningRtngLine."Run Time";


                    END;
                END
                ELSE BEGIN
                    ProdOrderRtngLine."Setup Time" := PlanningRtngLine."Setup Time";
                    ProdOrderRtngLine."Run Time" := PlanningRtngLine."Run Time";
                END;
                ProdOrderRtngLine."Wait Time" := PlanningRtngLine."Wait Time";
                ProdOrderRtngLine."Move Time" := PlanningRtngLine."Move Time";
                ProdOrderRtngLine."Fixed Scrap Quantity" := PlanningRtngLine."Fixed Scrap Quantity";
                ProdOrderRtngLine."Lot Size" := PlanningRtngLine."Lot Size";
                ProdOrderRtngLine."Scrap Factor %" := PlanningRtngLine."Scrap Factor %";
                //STD ProdOrderRtngLine."Setup Time Unit of Meas. Code" := RtngLine."Setup Time Unit of Meas. Code";
                //STD ProdOrderRtngLine."Run Time Unit of Meas. Code" := RtngLine."Run Time Unit of Meas. Code";
                RecLRoutingLine.RESET();
                RecLRoutingLine.SETRANGE(RecLRoutingLine."Routing No.", RecPProdOrderLine."Routing No.");
                RecLRoutingLine.SETRANGE(RecLRoutingLine."Version Code", RecPProdOrderLine."Routing Version Code");
                RecLRoutingLine.SETRANGE(RecLRoutingLine."Operation No.", ProdOrderRtngLine."Operation No.");
                IF RecLRoutingLine.FINDFIRST() THEN BEGIN
                    IF RecLRoutingLine."PWD Fixed-step Prod. Rate time" THEN BEGIN
                        ProdOrderRtngLine."Setup Time Unit of Meas. Code" := CodLSetupTimeUnit;
                        ProdOrderRtngLine."Run Time Unit of Meas. Code" := CodLRunTimeUnit;
                    END
                    ELSE BEGIN
                        ProdOrderRtngLine."Setup Time Unit of Meas. Code" := PlanningRtngLine."Setup Time Unit of Meas. Code";
                        ProdOrderRtngLine."Run Time Unit of Meas. Code" := PlanningRtngLine."Run Time Unit of Meas. Code";
                    END;
                END
                ELSE BEGIN
                    ProdOrderRtngLine."Setup Time Unit of Meas. Code" := PlanningRtngLine."Setup Time Unit of Meas. Code";
                    ProdOrderRtngLine."Run Time Unit of Meas. Code" := PlanningRtngLine."Run Time Unit of Meas. Code";
                END;
                //<<FE_LAPIERRETTE_PROD04.001

                ProdOrderRtngLine."Wait Time Unit of Meas. Code" := PlanningRtngLine."Wait Time Unit of Meas. Code";
                ProdOrderRtngLine."Move Time Unit of Meas. Code" := PlanningRtngLine."Move Time Unit of Meas. Code";
                ProdOrderRtngLine."Minimum Process Time" := PlanningRtngLine."Minimum Process Time";
                ProdOrderRtngLine."Maximum Process Time" := PlanningRtngLine."Maximum Process Time";
                ProdOrderRtngLine."Concurrent Capacities" := PlanningRtngLine."Concurrent Capacities";
                ProdOrderRtngLine."Send-Ahead Quantity" := PlanningRtngLine."Send-Ahead Quantity";
                ProdOrderRtngLine."Routing Link Code" := PlanningRtngLine."Routing Link Code";
                ProdOrderRtngLine."Standard Task Code" := PlanningRtngLine."Standard Task Code";
                ProdOrderRtngLine."Unit Cost per" := PlanningRtngLine."Unit Cost per";
                ProdOrderRtngLine.Recalculate := PlanningRtngLine.Recalculate;
                ProdOrderRtngLine."Sequence No. (Forward)" := PlanningRtngLine."Sequence No.(Forward)";
                ProdOrderRtngLine."Sequence No. (Backward)" := PlanningRtngLine."Sequence No.(Backward)";
                ProdOrderRtngLine."Fixed Scrap Qty. (Accum.)" := PlanningRtngLine."Fixed Scrap Qty. (Accum.)";
                ProdOrderRtngLine."Scrap Factor % (Accumulated)" := PlanningRtngLine."Scrap Factor % (Accumulated)";
                ProdOrderRtngLine."Sequence No. (Actual)" := PlanningRtngLine."Sequence No. (Actual)";
                ProdOrderRtngLine."Starting Time" := PlanningRtngLine."Starting Time";
                ProdOrderRtngLine."Starting Date" := PlanningRtngLine."Starting Date";
                ProdOrderRtngLine."Ending Time" := PlanningRtngLine."Ending Time";
                ProdOrderRtngLine."Ending Date" := PlanningRtngLine."Ending Date";
                ProdOrderRtngLine."Unit Cost Calculation" := PlanningRtngLine."Unit Cost Calculation";
                ProdOrderRtngLine."Input Quantity" := PlanningRtngLine."Input Quantity";
                ProdOrderRtngLine."Critical Path" := PlanningRtngLine."Critical Path";
                ProdOrderRtngLine."Direct Unit Cost" := PlanningRtngLine."Direct Unit Cost";
                ProdOrderRtngLine."Indirect Cost %" := PlanningRtngLine."Indirect Cost %";
                ProdOrderRtngLine."Overhead Rate" := PlanningRtngLine."Overhead Rate";
                CASE ProdOrderRtngLine.Type OF
                    ProdOrderRtngLine.Type::"Work Center":
                        BEGIN
                            WorkCenter.GET(PlanningRtngLine."No.");
                            ProdOrderRtngLine."Flushing Method" := WorkCenter."Flushing Method";
                        END;
                    ProdOrderRtngLine.Type::"Machine Center":
                        BEGIN
                            MachineCenter.GET(ProdOrderRtngLine."No.");
                            ProdOrderRtngLine."Flushing Method" := MachineCenter."Flushing Method";
                        END;
                END;
                ProdOrderRtngLine."Expected Operation Cost Amt." := PlanningRtngLine."Expected Operation Cost Amt.";
                ProdOrderRtngLine."Expected Capacity Ovhd. Cost" := PlanningRtngLine."Expected Capacity Ovhd. Cost";
                ProdOrderRtngLine."Expected Capacity Need" := PlanningRtngLine."Expected Capacity Need";

                ProdOrderRtngLine.UpdateDatetime();
                ProdOrderRtngLine.INSERT();
            UNTIL PlanningRtngLine.NEXT() = 0;
    END;
    //---CDU99000792---
    PROCEDURE Fct_TransmitOrderNo(SalesLine: Record "Sales Line") BooLTransOrderNo: Boolean
    VAR
        ReclItem: Record Item;
        RecLItemCategory: Record "Item Category";
    BEGIN
        BooLTransOrderNo := FALSE;

        IF SalesLine.Type = SalesLine.Type::Item THEN
            IF ReclItem.GET(SalesLine."No.") THEN
                IF RecLItemCategory.GET(ReclItem."Item Category Code") THEN
                    IF RecLItemCategory."PWD Transmitted Order No." THEN
                        BooLTransOrderNo := TRUE;
    END;

    //---CDU99000778---
    PROCEDURE FindFirstRecord() Tracking: Text[250]
    VAR
        //TODO: a vérifier : les variables ItemLedgEntry2 sont des variables globales dans le codeunit OrderTrackingManagement
        TrackingExists: Boolean;
        ItemLedgEntry2: Record "Item Ledger Entry";
        TrackingEntry: Record "Order Tracking Entry" temporary;
        TempReservEntryList: Record "Reservation Entry" temporary;
    //Window: Dialog;
    //EntryNo: Integer;
    //Text000: label 'Counting records...';
    BEGIN
        //>>LAP2.06
        TempReservEntryList.DELETEALL();
        TrackingEntry.DELETEALL();
        //EntryNo := 1;

        //Window.OPEN(Text000);
        TrackingEntry.INIT();
        TrackingEntry."Entry No." := 0;
        //TODO: DrillOrdersUp procedure local dans le codeunit OrderTrackingManagement
        //DrillOrdersUp(ReservEntry, 1);
        ItemLedgEntry2.SETCURRENTKEY("Entry No.");
        ItemLedgEntry2.MARKEDONLY(TRUE);
        IF ItemLedgEntry2.FIND('-') THEN
            REPEAT
            //TODO: InsertItemLedgTrackEntry procedure local dans le codeunit OrderTrackingManagement
            // InsertItemLedgTrackEntry(1, ItemLedgEntry2, ItemLedgEntry2."Remaining Quantity", ItemLedgEntry2);
            UNTIL ItemLedgEntry2.NEXT() = 0;
        TrackingExists := not TrackingEntry.IsEmpty;
        IF TrackingExists THEN
            EXIT(FORMAT(-TrackingEntry.Quantity) + ' - ' + TrackingEntry."Supplied by")
        ELSE
            EXIT('Pas de chainage');
        //<<LAP2.06
    END;
    //---CDU5510---
    PROCEDURE DeleteReservEntryFromOF(CodPProdOrderNo: Code[20]; IntPActualLineNo: Integer);
    VAR
        MfgSetup: Record "Manufacturing Setup";
        OroductionJournalMGT: Codeunit "Production Journal Mgt";
        LPSASetGetFunctions: codeunit "PWD LPSA Set/Get Functions.";
    BEGIN
        MfgSetup.GET();
        OroductionJournalMGT.SetTemplateAndBatchName();
        OroductionJournalMGT.InitSetupValues();
        OroductionJournalMGT.DeleteJnlLines(LPSASetGetFunctions.GetToTemplateName(), LPSASetGetFunctions.GetToBatchName(), CodPProdOrderNo, IntPActualLineNo);
    END;

    PROCEDURE InsertOutputJnlLine2(RecPItemJnalLine: Record 83; RecPProdOrderLine: Record 5406);
    VAR
        ItemJnlBatch: Record "Item Journal Batch";
        ItemJnlLine: Record "Item Journal Line";
        ItemJnlTemplate: Record "Item Journal Template";
        RecLManufacturingSetup: Record "Manufacturing Setup";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        CodLWorkCenter: Code[10];
        PostingDate: Date;
        QtyToPost: Decimal;
        NextLineNo: Integer;
        LPSASetGetFunctions: codeunit "PWD LPSA Set/Get Functions.";
        ToBatchName: Code[10];
        ToTemplateName: Code[10];
    BEGIN
        PostingDate := WORKDATE();
        //===Copy of Function InsertOutputJnlLine to work on Manufacturing Sheet=======================================
        //>>FE_LAPIERRETTE_PROD03.001
        RecLManufacturingSetup.GET();
        //>>FE_LAPIERRETTE_PRO12.001
        //RecLManufacturingSetup.TESTFIELD("Non conformity Prod. Location");
        //<<FE_LAPIERRETTE_PRO12.001
        RecLManufacturingSetup.TESTFIELD("PWD Mach. center-Invent. input");
        CodLWorkCenter := RecLManufacturingSetup."PWD Mach. center-Invent. input";
        //<FE_LAPIERRETTE_PROD03.001
        QtyToPost := RecPItemJnalLine."Output Quantity";
        //>>ProdOrderRtngLine
        //>>ProdOrderLine
        ItemJnlLine.INIT();
        ToBatchName := LPSASetGetFunctions.GetToBatchName();
        ToTemplateName := LPSASetGetFunctions.GetToTemplateName();
        ItemJnlLine."Journal Template Name" := ToTemplateName;
        ItemJnlLine."Journal Batch Name" := ToBatchName;
        ItemJnlLine."Line No." := NextLineNo;
        ItemJnlLine."PWD Conform quality control" := RecPItemJnalLine."PWD Conform quality control";
        ItemJnlLine.VALIDATE("Posting Date", PostingDate);
        ItemJnlLine.VALIDATE("Entry Type", ItemJnlLine."Entry Type"::Output);
        ItemJnlLine.VALIDATE("Order Type", "ItemJnlLine"."Order Type"::Production);
        ItemJnlLine.VALIDATE("Order No.", RecPItemJnalLine."Order No.");
        ItemJnlLine.VALIDATE("Order Line No.", RecPItemJnalLine."Order Line No.");
        ItemJnlLine.VALIDATE("Item No.", RecPItemJnalLine."Item No.");
        ItemJnlLine.VALIDATE("Variant Code", RecPItemJnalLine."Variant Code");
        ItemJnlLine.VALIDATE("Location Code", RecPItemJnalLine."Location Code");
        IF RecPItemJnalLine."Bin Code" <> '' THEN
            ItemJnlLine.VALIDATE("Bin Code", RecPItemJnalLine."Bin Code");
        ItemJnlLine.VALIDATE("Routing No.", RecPItemJnalLine."Routing No.");
        ItemJnlLine.VALIDATE("Routing Reference No.", RecPItemJnalLine."Routing Reference No.");
        IF RecPItemJnalLine."Order No." <> '' THEN
            ItemJnlLine.VALIDATE("Operation No.", RecPItemJnalLine."Operation No.");
        ItemJnlLine.VALIDATE("Unit of Measure Code", RecPItemJnalLine."Unit of Measure Code");
        ItemJnlLine.VALIDATE("Setup Time", 0);
        ItemJnlLine.VALIDATE("Run Time", 0);
        IF (RecPItemJnalLine."Location Code" <> '') THEN
            ItemJnlLine.CheckWhse(RecPItemJnalLine."Location Code", QtyToPost);
        ItemJnlLine.VALIDATE("Output Quantity", QtyToPost);
        //IF ProdOrderRtngLine."Routing Status" = ProdOrderRtngLine."Routing Status"::Finished THEN
        ItemJnlLine.Finished := TRUE;
        ItemJnlLine."Flushing Method" := RecPItemJnalLine."Flushing Method";
        //
        ItemJnlTemplate.SetRange("Page ID", PAGE::"Production Journal");
        ItemJnlTemplate.SetRange(Recurring, false);
        ItemJnlTemplate.SetRange(Type, ItemJnlTemplate.Type::"Prod. Order");
        if ItemJnlTemplate.FindFirst() then
            //
            ItemJnlLine."Source Code" := ItemJnlTemplate."Source Code";
        //
        if ItemJnlBatch.Get(ToTemplateName, ToBatchName) then begin
            //
            ItemJnlLine."Reason Code" := ItemJnlBatch."Reason Code";
            ItemJnlLine."Posting No. Series" := ItemJnlBatch."Posting No. Series";
        End;
        ItemJnlLine.INSERT();
        //IF ProdOrderRtngLine."Next Operation No." = '' THEN // Last or no Routing Line
        ItemTrackingMgt.CopyItemTracking(RecPProdOrderLine.RowID1(), ItemJnlLine.RowID1(), FALSE);
        //ItemTrackingMgt.CopyItemTracking(RecPProdOrderLine.RowID1,ItemJnlLine.RowID1,FALSE);
        NextLineNo += 10000;
    END;

    PROCEDURE DeleteReservEntry(CodPProdOrderNo: Code[20]; IntPActualLineNo: Integer);
    VAR
        MfgSetup: Record "Manufacturing Setup";
        ProductionJournalMgt: Codeunit "Production Journal Mgt";
        LPSASetGetFunctions: codeunit "PWD LPSA Set/Get Functions.";
    BEGIN
        MfgSetup.GET();
        ProductionJournalMgt.InitSetupValues();
        ProductionJournalMgt.DeleteJnlLines(LPSASetGetFunctions.GetToTemplateName(), LPSASetGetFunctions.GetToBatchName(), CodPProdOrderNo, IntPActualLineNo);
    END;
    //---CDU5701---
    PROCEDURE GetCompSubstPhantom(VAR ProdOrderComp: Record "Prod. Order Component"): Code[10];
    Var
        TempItemSubPhantom: Record "PWD Phantom substitution Items" TEMPORARY;
        ItemSubst: Codeunit "Item Subst.";
    BEGIN
        // >> FE_LAPRIERRETTE_GP0003 : APA 16/05/13
        IF NOT PrepareSubstListPhantom(
                 ProdOrderComp."Item No.",
                 ProdOrderComp."Location Code",
                 ProdOrderComp."Due Date",
                 TRUE,
                 ProdOrderComp."Expected Quantity"
                 )
        THEN
            ItemSubst.ErrorMessage(ProdOrderComp."Item No.", ProdOrderComp."Variant Code");

        TempItemSubPhantom.RESET();
        IF TempItemSubPhantom.FIND('-') THEN;
        IF Page.RUNMODAL(Page::"Item Subst. Phantom Entries", TempItemSubPhantom) = ACTION::LookupOK THEN
            UpdateComponentPhantom(ProdOrderComp, TempItemSubPhantom."Item No.", TempItemSubPhantom);

        // << FE_LAPRIERRETTE_GP0003 : APA 16/05/13
    END;

    PROCEDURE UpdateComponentPhantom(VAR ProdOrderComp: Record "Prod. Order Component"; SubstItemNo: Code[20]; VAR PhantomItem: Record "PWD Phantom substitution Items");
    VAR
        ItemUnitOfMeasure: Record "Item Unit of Measure";
        TempProdOrderComp: Record "Prod. Order Component" TEMPORARY;
        ProdOrderCompReserve: Codeunit "Prod. Order Comp.-Reserve";
        RecLProdOrderLine: Record "Prod. Order Line";
        RecLTrackingSpecPhantom: Record "Tracking Specification Phantom";
        BooLOneItem: Boolean;
        DecLQty: Decimal;
        DecLxQty: Decimal;
        SaveQty: Decimal;
        IntLastEntryNo: Integer;
        Text50000: Label 'Vous ne pouvez pas sélectionner des articles différents. Veuillez sélectionner le même article, pour des n° lot différents';
        Text50001: Label 'Confirmez-vous la différence de quantité de %1 au lieu de %2?';
    BEGIN
        if (ProdOrderComp."Item No." <> SubstItemNo) then
            ProdOrderCompReserve.DeleteLine(ProdOrderComp);

        TempProdOrderComp := ProdOrderComp;
        // Mise … jour des informations composants
        PhantomItem.SETFILTER("Quantity Requested", '<>0');
        IF NOT PhantomItem.FINDFIRST() THEN
            ERROR('Aucun article sélectionné');

        //Contr“le qu'un seul article est s‚lectionn‚ et de la quantit‚ totale choisie
        SubstItemNo := PhantomItem."Item No.";

        BooLOneItem := TRUE;
        DecLQty := 0;
        REPEAT
            BooLOneItem := (PhantomItem."Item No." = SubstItemNo);
        UNTIL (PhantomItem.NEXT() = 0) OR (NOT BooLOneItem);

        PhantomItem.FINDFIRST();
        REPEAT
            DecLQty += PhantomItem."Quantity Requested";
        UNTIL PhantomItem.NEXT() = 0;

        IF NOT BooLOneItem THEN
            ERROR(Text50000);

        IF DecLQty <> TempProdOrderComp."Expected Quantity" THEN
            IF NOT CONFIRM(Text50001, FALSE, DecLQty, TempProdOrderComp."Expected Quantity") THEN
                EXIT;

        DeleteReservationEntryPhantom(ProdOrderComp);

        with TempProdOrderComp do begin
            SaveQty := "Quantity per";

            "Item No." := SubstItemNo;
            "Location Code" := ProdOrderComp."Location Code";
            "Quantity per" := 0;
            Validate("Item No.");

            "Original Item No." := ProdOrderComp."Item No.";
            IF DecLQty <> TempProdOrderComp."Expected Quantity" THEN
                TempProdOrderComp.VALIDATE("Expected Quantity", DecLQty * (1 + TempProdOrderComp."Scrap %" / 100));

            if ProdOrderComp."Qty. per Unit of Measure" <> 1 then
                if ItemUnitOfMeasure.Get(SubstItemNo, ProdOrderComp."Unit of Measure Code") and (ItemUnitOfMeasure."Qty. per Unit of Measure" = ProdOrderComp."Qty. per Unit of Measure") then
                    Validate("Unit of Measure Code", ProdOrderComp."Unit of Measure Code")
                else
                    SaveQty := ROUND(ProdOrderComp."Quantity per" * ProdOrderComp."Qty. per Unit of Measure", 0.00001);
            Validate("Quantity per", SaveQty);
            IF DecLQty <> TempProdOrderComp."Expected Quantity" THEN BEGIN
                DecLxQty := TempProdOrderComp."Expected Quantity";
                TempProdOrderComp.VALIDATE("Expected Quantity", DecLQty);
                ProdOrderComp := TempProdOrderComp;
                ProdOrderComp.MODIFY();
                IF RecLProdOrderLine.GET(Status, "Prod. Order No.", "Prod. Order Line No.") THEN BEGIN
                    //ERROR(FORMAT( RecLProdOrderLine.Quantity * TempProdOrderComp."Expected Quantity" / DecLxQty));
                    RecLProdOrderLine.VALIDATE(Quantity, ROUND((RecLProdOrderLine.Quantity * TempProdOrderComp."Expected Quantity" / DecLxQty), 1));
                    RecLProdOrderLine.MODIFY();
                END;
            END ELSE BEGIN
                ProdOrderComp := TempProdOrderComp;
                ProdOrderComp.MODIFY();
            END;
        END;
        DeletePreviousOperationPhantom(ProdOrderComp);
        // Mise … jour des informations de tra‡abilit‚
        IF RecLTrackingSpecPhantom.FINDLAST() THEN
            IntLastEntryNo := RecLTrackingSpecPhantom."Entry No."
        ELSE
            IntLastEntryNo := 0;

        PhantomItem.SETFILTER("Quantity Requested", '<>0');
        IF PhantomItem.FINDFIRST() THEN
            REPEAT
                RecLTrackingSpecPhantom.INIT();
                IntLastEntryNo += 1;
                RecLTrackingSpecPhantom."Entry No." := IntLastEntryNo;
                RecLTrackingSpecPhantom."Source Type" := DATABASE::"Prod. Order Component";
                WITH ProdOrderComp DO BEGIN
                    RecLTrackingSpecPhantom."Item No." := "Item No.";
                    RecLTrackingSpecPhantom."Location Code" := "Location Code";
                    RecLTrackingSpecPhantom."Bin Code" := "Bin Code";
                    RecLTrackingSpecPhantom.Description := Description;
                    RecLTrackingSpecPhantom."Variant Code" := "Variant Code";
                    RecLTrackingSpecPhantom."Source Subtype" := Status.AsInteger();
                    RecLTrackingSpecPhantom."Source ID" := "Prod. Order No.";
                    RecLTrackingSpecPhantom."Source Batch Name" := '';
                    RecLTrackingSpecPhantom."Source Prod. Order Line" := "Prod. Order Line No.";
                    RecLTrackingSpecPhantom."Source Ref. No." := "Line No.";
                    RecLTrackingSpecPhantom."Quantity (Base)" := PhantomItem."Quantity Requested";
                    RecLTrackingSpecPhantom."Qty. to Handle" := PhantomItem."Quantity Requested";
                    RecLTrackingSpecPhantom."Qty. to Handle (Base)" := PhantomItem."Quantity Requested";
                    RecLTrackingSpecPhantom."Qty. to Invoice" := PhantomItem."Quantity Requested";
                    RecLTrackingSpecPhantom."Qty. to Invoice (Base)" := PhantomItem."Quantity Requested";
                    RecLTrackingSpecPhantom."Quantity Handled (Base)" := "Expected Qty. (Base)" - "Remaining Qty. (Base)";
                    RecLTrackingSpecPhantom."Quantity Invoiced (Base)" := "Expected Qty. (Base)" - "Remaining Qty. (Base)";
                    RecLTrackingSpecPhantom."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
                    RecLTrackingSpecPhantom."Lot No." := PhantomItem."Lot No.";
                END;
                RecLTrackingSpecPhantom.INSERT();
            UNTIL PhantomItem.NEXT() = 0;

        // << FE_LAPRIERRETTE_GP0003 : APA 16/05/13
    END;

    PROCEDURE PrepareSubstListPhantom(ItemNo: Code[20]; LocationCode: Code[10]; DemandDate: Date; CalcATP: Boolean; ExpectedQuantity: Decimal): Boolean;
    var
        Item: Record Item;
        ItemSubPhantom: Record "PWD Phantom substitution Items";
        TempItemSubPhantom: Record "PWD Phantom substitution Items" TEMPORARY;
    BEGIN
        // >> FE_LAPRIERRETTE_GP0003 : APA 16/05/13
        Item.GET(ItemNo);
        Item.SETFILTER("Location Filter", LocationCode);
        Item.SETRANGE("Date Filter", 0D, DemandDate);

        ItemSubPhantom.RESET();
        ItemSubPhantom.SETRANGE("Phantom Item No.", ItemNo);
        IF ItemSubPhantom.FIND('-') THEN BEGIN
            TempItemSubPhantom.DELETEALL();
            CreateSubstListPhantom(ItemNo, ItemSubPhantom, 1, DemandDate, LocationCode, ExpectedQuantity);
            EXIT(TRUE);
        END;

        EXIT(FALSE);
        // << FE_LAPRIERRETTE_GP0003 : APA 16/05/13
    END;

    LOCAL PROCEDURE CreateSubstListPhantom(OrgNo: Code[20]; VAR ItemSubPhantom3: Record 50011; RelationsLevel: Integer; DemandDate: Date; LocationCode: Code[10]; ExpectedQuantity: Decimal);
    VAR
        RecLItemLedgEntry: Record "Item Ledger Entry";
        ItemSubPhantom: Record "PWD Phantom substitution Items";
        TempItemSubPhantom: Record "PWD Phantom substitution Items" TEMPORARY;
        RecLTrackingSpec: Record "Tracking Specification";
        RelationsLevel2: Integer;
    BEGIN
        // >> FE_LAPRIERRETTE_GP0003 : APA 16/05/13
        ItemSubPhantom.COPY(ItemSubPhantom3);
        RelationsLevel2 := RelationsLevel;

        RecLItemLedgEntry.SETCURRENTKEY(Open, "Item Tracking", "Item No.", "Variant Code", "Lot No.", "Serial No.");

        IF ItemSubPhantom.FIND('-') THEN
            REPEAT
                CLEAR(TempItemSubPhantom);

                RecLItemLedgEntry.SETRANGE(Open, TRUE);
                RecLItemLedgEntry.SETRANGE("Item No.", ItemSubPhantom."Item No.");
                RecLItemLedgEntry.SETFILTER("Lot No.", '<>%1', '');
                IF RecLItemLedgEntry.FIND('-') THEN
                    REPEAT
                        TempItemSubPhantom."Phantom Item No." := ItemSubPhantom."Phantom Item No.";
                        TempItemSubPhantom."Item No." := ItemSubPhantom."Item No.";
                        TempItemSubPhantom.Priority := ItemSubPhantom.Priority;
                        TempItemSubPhantom."Lot No." := RecLItemLedgEntry."Lot No.";
                        TempItemSubPhantom."Expected Quantity" := ExpectedQuantity;

                        RecLTrackingSpec.INIT();
                        RecLTrackingSpec."Item No." := ItemSubPhantom."Item No.";
                        RecLTrackingSpec."Location Code" := LocationCode;
                        RecLTrackingSpec."Lot No." := RecLItemLedgEntry."Lot No.";
                        TempItemSubPhantom."Total Available Quantity" := LotSNAvailablePhantom(RecLTrackingSpec);
                        IF TempItemSubPhantom."Total Available Quantity" <> 0 THEN
                            IF NOT TempItemSubPhantom.INSERT() THEN
                                TempItemSubPhantom.MODIFY();
                    UNTIL RecLItemLedgEntry.NEXT() = 0
                ELSE BEGIN
                    TempItemSubPhantom."Phantom Item No." := ItemSubPhantom."Phantom Item No.";
                    TempItemSubPhantom."Item No." := ItemSubPhantom."Item No.";
                    TempItemSubPhantom.Priority := ItemSubPhantom.Priority;
                    TempItemSubPhantom."Expected Quantity" := ExpectedQuantity;

                    RecLTrackingSpec.INIT();
                    RecLTrackingSpec."Item No." := ItemSubPhantom."Item No.";
                    RecLTrackingSpec."Location Code" := LocationCode;
                    TempItemSubPhantom."Total Available Quantity" := LotSNAvailablePhantom(RecLTrackingSpec);
                    IF TempItemSubPhantom."Total Available Quantity" <> 0 THEN
                        TempItemSubPhantom.INSERT();
                END;
            UNTIL ItemSubPhantom.NEXT() = 0;

        // << FE_LAPRIERRETTE_GP0003 : APA 16/05/13
    END;

    PROCEDURE DeletePreviousOperationPhantom(VAR ProdOrderComp: Record 5407);
    VAR
        ProdOrderLine: Record "Prod. Order Line";
    BEGIN
        // >> FE_LAPRIERRETTE_GP0003 : APA 16/05/13
        ProdOrderLine.SETRANGE(Status, ProdOrderComp.Status);
        ProdOrderLine.SETRANGE("Prod. Order No.", ProdOrderComp."Prod. Order No.");
        ProdOrderLine.SETFILTER("Line No.", '>%1', ProdOrderComp."Prod. Order Line No.");
        ProdOrderLine.SETRANGE("Item No.", ProdOrderComp."Original Item No.");
        IF ProdOrderLine.FINDFIRST() THEN
            ProdOrderLine.DELETEALL(TRUE);
        // << FE_LAPRIERRETTE_GP0003 : APA 16/05/13
    END;

    PROCEDURE DeleteReservationEntryPhantom(VAR ProdOrderComp: Record "Prod. Order Component");
    VAR
        ReservEntry: Record "Reservation Entry";
        ReservEntry2: Record "Reservation Entry";
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
    BEGIN
        // >> FE_LAPRIERRETTE_GP0003 : APA 16/05/13
        ReservEntry.SETRANGE("Source Type", DATABASE::"Prod. Order Component");
        ReservEntry.SETRANGE("Source Subtype", ProdOrderComp.Status);
        ReservEntry.SETRANGE("Source ID", ProdOrderComp."Prod. Order No.");
        ReservEntry.SETRANGE("Source Prod. Order Line", ProdOrderComp."Prod. Order Line No.");
        ReservEntry.SETRANGE("Source Ref. No.", ProdOrderComp."Line No.");
        ReservEntry.SETRANGE("Item No.", ProdOrderComp."Item No.");
        ReservEntry.SETRANGE("Variant Code", ProdOrderComp."Variant Code");
        ReservEntry.SETRANGE("Location Code", ProdOrderComp."Location Code");
        ReservEntry.SETRANGE("Shipment Date", ProdOrderComp."Due Date");
        //UnitOfMeasureCode := ProdOrderComp."Unit of Measure Code";

        IF ReservEntry.FindFirst() THEN BEGIN
            CLEAR(ReservEntry2);
            ReservEntry2 := ReservEntry;
            ReservEntry2.SetPointerFilter();
            ReservEntry2.SETRANGE("Reservation Status", ReservEntry2."Reservation Status"::Reservation);
            IF ReservEntry2.FindSet() THEN
                REPEAT
                    ReservEngineMgt.CancelReservation(ReservEntry2);
                UNTIL ReservEntry2.NEXT() = 0;
        END;

        // << FE_LAPRIERRETTE_GP0003 : APA 16/05/13
    END;
    //---CDU5063---
    PROCEDURE BeforeRestoreSalesDocument(var SalesHeaderArchive: Record "Sales Header Archive");
    var
        ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
        ReservEntry: Record "Reservation Entry";
        SalesHeader: Record "Sales Header";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesShptHeader: Record "Sales Shipment Header";
        ArchiveManagement: Codeunit ArchiveManagement;
        ConfirmManagement: Codeunit "Confirm Management";
        RecordLinkManagement: Codeunit "Record Link Management";
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        ConfirmRequired: Boolean;
        DoCheck: Boolean;
        RestoreDocument: Boolean;
        OldOpportunityNo: Code[20];
        Text002: Label 'Do you want to Restore %1 %2 Version %3?';
        Text003: Label '%1 %2 has been restored.';
        Text005: Label '%1 %2 has been partly posted.\Restore not possible.';
        Text006: Label 'Entries exist for on or more of the following:\  - %1\  - %2\  - %3.\Restoration of document will delete these entries.\Continue with restore?';
        Text008: Label 'Item Tracking Line';
        Text009: Label 'Unposted %1 %2 does not exist anymore.\It is not possible to restore the %1.';
    begin
        if not SalesHeader.Get(SalesHeaderArchive."Document Type", SalesHeaderArchive."No.") then
            //>>TDL.LPSA.30.07.15:NBO
            //ERROR(Text009,SalesHeaderArchive."Document Type",SalesHeaderArchive."No.");
            IF SalesHeaderArchive."Document Type" <> SalesHeaderArchive."Document Type"::Quote THEN
                Error(Text009, SalesHeaderArchive."Document Type", SalesHeaderArchive."No.")
            ELSE BEGIN
                SalesHeader.INIT();
                SalesHeader.TRANSFERFIELDS(SalesHeaderArchive);
                SalesHeader.INSERT(TRUE);
                SalesHeader."Doc. No. Occurrence" := 1;
                SalesHeader.MODIFY();
                //BooLRecreated := TRUE;
            END;
        //<<TDL.LPSA.30.07.15:NBO
        SalesHeader.TestField(Status, SalesHeader.Status::Open);
        DoCheck := true;
        if (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) and DoCheck then begin
            SalesShptHeader.Reset();
            SalesShptHeader.SetCurrentKey("Order No.");
            SalesShptHeader.SetRange("Order No.", SalesHeader."No.");
            if not SalesShptHeader.IsEmpty() then
                Error(Text005, SalesHeader."Document Type", SalesHeader."No.");
            SalesInvHeader.Reset();
            SalesInvHeader.SetCurrentKey("Order No.");
            SalesInvHeader.SetRange("Order No.", SalesHeader."No.");
            if not SalesInvHeader.IsEmpty() then
                Error(Text005, SalesHeader."Document Type", SalesHeader."No.");
        end;

        ConfirmRequired := false;
        ReservEntry.Reset();
        ReservEntry.SetCurrentKey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
        ReservEntry.SetRange("Source ID", SalesHeader."No.");
        ReservEntry.SetRange("Source Type", DATABASE::"Sales Line");
        ReservEntry.SetRange("Source Subtype", SalesHeader."Document Type");
        if ReservEntry.FindFirst() then
            ConfirmRequired := true;

        ItemChargeAssgntSales.Reset();
        ItemChargeAssgntSales.SetRange("Document Type", SalesHeader."Document Type");
        ItemChargeAssgntSales.SetRange("Document No.", SalesHeader."No.");
        if ItemChargeAssgntSales.FindFirst() then
            ConfirmRequired := true;

        RestoreDocument := false;
        if ConfirmRequired then begin
            if ConfirmManagement.GetResponseOrDefault(
                 StrSubstNo(
                   Text006, ReservEntry.TableCaption, ItemChargeAssgntSales.TableCaption, Text008), true)
            then
                RestoreDocument := true;
        end else
            if ConfirmManagement.GetResponseOrDefault(
                 StrSubstNo(
                   Text002, SalesHeaderArchive."Document Type",
                   SalesHeaderArchive."No.", SalesHeaderArchive."Version No."), true)
            then
                RestoreDocument := true;
        if RestoreDocument then begin
            SalesHeader.TestField("Doc. No. Occurrence", SalesHeaderArchive."Doc. No. Occurrence");
            SalesHeaderArchive.CalcFields("Work Description");
            if SalesHeader."Opportunity No." <> '' then begin
                OldOpportunityNo := SalesHeader."Opportunity No.";
                SalesHeader."Opportunity No." := '';
            end;
            SalesHeader.DeleteLinks();
            SalesHeader.Delete(true);
            SalesHeader.Init();
            SalesHeader.SetHideValidationDialog(true);
            SalesHeader."Document Type" := SalesHeaderArchive."Document Type";
            SalesHeader."No." := SalesHeaderArchive."No.";
            SalesHeader.Insert(true);
            SalesHeader.TransferFields(SalesHeaderArchive);
            SalesHeader.Status := SalesHeader.Status::Open;
            if SalesHeaderArchive."Sell-to Contact No." <> '' then
                SalesHeader.Validate("Sell-to Contact No.", SalesHeaderArchive."Sell-to Contact No.")
            else
                SalesHeader.Validate("Sell-to Customer No.", SalesHeaderArchive."Sell-to Customer No.");
            if SalesHeaderArchive."Bill-to Contact No." <> '' then
                SalesHeader.Validate("Bill-to Contact No.", SalesHeaderArchive."Bill-to Contact No.")
            else
                SalesHeader.Validate("Bill-to Customer No.", SalesHeaderArchive."Bill-to Customer No.");
            SalesHeader.Validate("Salesperson Code", SalesHeaderArchive."Salesperson Code");
            SalesHeader.Validate("Payment Terms Code", SalesHeaderArchive."Payment Terms Code");
            SalesHeader.Validate("Payment Discount %", SalesHeaderArchive."Payment Discount %");
            SalesHeader."Shortcut Dimension 1 Code" := SalesHeaderArchive."Shortcut Dimension 1 Code";
            SalesHeader."Shortcut Dimension 2 Code" := SalesHeaderArchive."Shortcut Dimension 2 Code";
            SalesHeader."Dimension Set ID" := SalesHeaderArchive."Dimension Set ID";
            RecordLinkManagement.CopyLinks(SalesHeaderArchive, SalesHeader);
            SalesHeader.LinkSalesDocWithOpportunity(OldOpportunityNo);
            SalesHeader.Modify(true);
            ArchiveManagement.ResetQuoteStatus(SalesHeader);
            RestoreSalesLines(SalesHeaderArchive, SalesHeader);
            SalesHeader.Status := SalesHeader.Status::Released;
            ReleaseSalesDoc.Reopen(SalesHeader);
            Message(Text003, SalesHeader."Document Type", SalesHeader."No.");
        end;
    end;

    local procedure RestoreSalesLines(var SalesHeaderArchive: Record "Sales Header Archive"; SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        SalesLineArchive: Record "Sales Line Archive";
        RecordLinkManagement: Codeunit "Record Link Management";
    begin
        RestoreSalesLineComments(SalesHeaderArchive, SalesHeader);

        SalesLineArchive.SetRange("Document Type", SalesHeaderArchive."Document Type");
        SalesLineArchive.SetRange("Document No.", SalesHeaderArchive."No.");
        SalesLineArchive.SetRange("Doc. No. Occurrence", SalesHeaderArchive."Doc. No. Occurrence");
        SalesLineArchive.SetRange("Version No.", SalesHeaderArchive."Version No.");
        if SalesLineArchive.FindSet() then
            repeat
                SalesLine.Init();
                SalesLine.TransferFields(SalesLineArchive);
                SalesLine.Insert(true);
                if SalesLine.Type <> SalesLine.Type::" " then begin
                    SalesLine.Validate("No.");
                    if SalesLineArchive."Variant Code" <> '' then
                        SalesLine.Validate("Variant Code", SalesLineArchive."Variant Code");
                    if SalesLineArchive."Unit of Measure Code" <> '' then
                        SalesLine.Validate("Unit of Measure Code", SalesLineArchive."Unit of Measure Code");
                    SalesLine.Validate("Location Code", SalesLineArchive."Location Code");
                    if SalesLine.Quantity <> 0 then
                        SalesLine.Validate(Quantity, SalesLineArchive.Quantity);
                    SalesLine.Validate("Unit Price", SalesLineArchive."Unit Price");
                    SalesLine.Validate("Unit Cost (LCY)", SalesLineArchive."Unit Cost (LCY)");
                    SalesLine.Validate("Line Discount %", SalesLineArchive."Line Discount %");
                    SalesLine.Validate("Quote Variant", SalesLineArchive."Quote Variant");
                    if SalesLineArchive."Inv. Discount Amount" <> 0 then
                        SalesLine.Validate("Inv. Discount Amount", SalesLineArchive."Inv. Discount Amount");
                    if SalesLine.Amount <> SalesLineArchive.Amount then
                        SalesLine.Validate(Amount, SalesLineArchive.Amount);
                    SalesLine.Validate(Description, SalesLineArchive.Description);
                end;
                SalesLine."Shortcut Dimension 1 Code" := SalesLineArchive."Shortcut Dimension 1 Code";
                SalesLine."Shortcut Dimension 2 Code" := SalesLineArchive."Shortcut Dimension 2 Code";
                SalesLine."Dimension Set ID" := SalesLineArchive."Dimension Set ID";
                SalesLine."Deferral Code" := SalesLineArchive."Deferral Code";
                RestoreDeferrals(
                    "Deferral Document Type"::Sales.AsInteger(),
                    SalesLineArchive."Document Type".AsInteger(), SalesLineArchive."Document No.", SalesLineArchive."Line No.",
                    SalesHeaderArchive."Doc. No. Occurrence", SalesHeaderArchive."Version No.");
                RecordLinkManagement.CopyLinks(SalesLineArchive, SalesLine);
                SalesLine.Modify(true);
            until SalesLineArchive.Next() = 0;
    end;

    local procedure RestoreSalesLineComments(SalesHeaderArchive: Record "Sales Header Archive"; SalesHeader: Record "Sales Header")
    var
        SalesCommentLine: Record "Sales Comment Line";
        SalesCommentLineArchive: Record "Sales Comment Line Archive";
        NextLine: Integer;
        Text004: Label 'Document restored from Version %1.';
    begin
        SalesCommentLineArchive.SetRange("Document Type", SalesHeaderArchive."Document Type");
        SalesCommentLineArchive.SetRange("No.", SalesHeaderArchive."No.");
        SalesCommentLineArchive.SetRange("Doc. No. Occurrence", SalesHeaderArchive."Doc. No. Occurrence");
        SalesCommentLineArchive.SetRange("Version No.", SalesHeaderArchive."Version No.");
        if SalesCommentLineArchive.FindSet() then
            repeat
                SalesCommentLine.Init();
                SalesCommentLine.TransferFields(SalesCommentLineArchive);
                SalesCommentLine.Insert();
            until SalesCommentLineArchive.Next() = 0;

        SalesCommentLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesCommentLine.SetRange("No.", SalesHeader."No.");
        SalesCommentLine.SetRange("Document Line No.", 0);
        if SalesCommentLine.FindLast() then
            NextLine := SalesCommentLine."Line No.";
        NextLine += 10000;
        SalesCommentLine.Init();
        SalesCommentLine."Document Type" := SalesHeader."Document Type";
        SalesCommentLine."No." := SalesHeader."No.";
        SalesCommentLine."Document Line No." := 0;
        SalesCommentLine."Line No." := NextLine;
        SalesCommentLine.Date := WorkDate();
        SalesCommentLine.Comment := StrSubstNo(Text004, Format(SalesHeaderArchive."Version No."));
        SalesCommentLine.Insert();
    end;

    local procedure RestoreDeferrals(DeferralDocType: Integer; DocType: Integer; DocNo: Code[20]; LineNo: Integer; DocNoOccurrence: Integer; VersionNo: Integer)
    var
        DeferralHeader: Record "Deferral Header";
        DeferralHeaderArchive: Record "Deferral Header Archive";
        DeferralLine: Record "Deferral Line";
        DeferralLineArchive: Record "Deferral Line Archive";
        DeferralUtilities: Codeunit "Deferral Utilities";
    begin
        if DeferralHeaderArchive.Get(DeferralDocType, DocType, DocNo, DocNoOccurrence, VersionNo, LineNo) then begin
            // Updates the header if is exists already and removes all the lines
            DeferralUtilities.SetDeferralRecords(DeferralHeader,
              DeferralDocType, '', '',
              DocType, DocNo, LineNo,
              DeferralHeaderArchive."Calc. Method",
              DeferralHeaderArchive."No. of Periods",
              DeferralHeaderArchive."Amount to Defer",
              DeferralHeaderArchive."Start Date",
              DeferralHeaderArchive."Deferral Code",
              DeferralHeaderArchive."Schedule Description",
              DeferralHeaderArchive."Initial Amount to Defer",
              true,
              DeferralHeaderArchive."Currency Code");

            // Add lines as exist in the archives
            DeferralLineArchive.SetRange("Deferral Doc. Type", DeferralDocType);
            DeferralLineArchive.SetRange("Document Type", DocType);
            DeferralLineArchive.SetRange("Document No.", DocNo);
            DeferralLineArchive.SetRange("Doc. No. Occurrence", DocNoOccurrence);
            DeferralLineArchive.SetRange("Version No.", VersionNo);
            DeferralLineArchive.SetRange("Line No.", LineNo);
            if DeferralLineArchive.FindSet() then
                repeat
                    DeferralLine.Init();
                    DeferralLine.TransferFields(DeferralLineArchive);
                    DeferralLine.Insert();
                until DeferralLineArchive.Next() = 0;
        end else
            // Removes any lines that may have been defaulted
            DeferralUtilities.RemoveOrSetDeferralSchedule('', DeferralDocType, '', '', DocType, DocNo, LineNo, 0, 0D, '', '', true);
    end;
    //---CDU5812---
    PROCEDURE CalcRtngCost2(RtngHeaderNo: Code[20]; MfgItemQtyBase: Decimal; VAR SLCap: Decimal; VAR SLSub: Decimal; VAR SLCapOvhd: Decimal; CodPItemNo: Code[20]);
    VAR
        MfgSetup: Record "Manufacturing Setup";
        RtngHeader: Record "Routing Header";
        RtngLine: Record "Routing Line";
        RtngVersion: Record "Routing Version";
        WorkCenter: Record "Work Center";
        CheckRouting: Codeunit "Check Routing Lines";
        CostCalcMgt: Codeunit "Cost Calculation Management";
        LogErrors: Boolean;
        CodLRunTimeUnit: Code[10];
        CodLSetupTimeUnit: Code[10];
        RtngVersionCode: Code[10];
        CalculationDate: Date;
        CostTime: Decimal;
        DecLRunTime: Decimal;
        DecLSetupTime: Decimal;
        DirUnitCost: Decimal;
        IndirCostPct: Decimal;
        OvhdRate: Decimal;
        UnitCost: Decimal;
        UnitCostCalculation: Option;
    BEGIN
        if RtngLine.CertifiedRoutingVersionExists(RtngHeaderNo, CalculationDate) then begin
            if RtngLine."Version Code" = '' then begin
                RtngHeader.Get(RtngHeaderNo);
                TestRtngVersionIsCertified(RtngLine."Version Code", RtngHeader);
            end;
            REPEAT
                IF (RtngLine.Type = RtngLine.Type::"Work Center") AND
                   (RtngLine."No." <> '')
                THEN
                    WorkCenter.GET(RtngLine."No.")
                ELSE
                    CLEAR(WorkCenter);
                UnitCost := RtngLine."Unit Cost per";
                CalcRtngCostPerUnit(RtngLine.Type, RtngLine."No.", DirUnitCost, IndirCostPct, OvhdRate, UnitCost, UnitCostCalculation);

                //>>FE_LAPIERRETTE_PROD04.001
                IF RtngLine."PWD Fixed-step Prod. Rate time" THEN BEGIN
                    FctGetTimeForCost(RtngLine.Type, RtngLine."No.", CodPItemNo, MfgItemQtyBase,
                                                      DecLSetupTime, DecLRunTime, CodLSetupTimeUnit, CodLRunTimeUnit);
                    CostTime :=
                      CostCalcMgt.CalcCostTime(
                        MfgItemQtyBase,
                        DecLSetupTime, CodLSetupTimeUnit,
                        DecLRunTime, CodLRunTimeUnit, RtngLine."Lot Size",
                        RtngLine."Scrap Factor % (Accumulated)", RtngLine."Fixed Scrap Qty. (Accum.)",
                        RtngLine."Work Center No.", UnitCostCalculation, MfgSetup."Cost Incl. Setup",
                        RtngLine."Concurrent Capacities");

                END ELSE
                    //<<FE_LAPIERRETTE_PROD04.001

                    CostTime :=
                CostCalcMgt.CalcCostTime(
                  MfgItemQtyBase,
                  RtngLine."Setup Time", RtngLine."Setup Time Unit of Meas. Code",
                  RtngLine."Run Time", RtngLine."Run Time Unit of Meas. Code", RtngLine."Lot Size",
                  RtngLine."Scrap Factor % (Accumulated)", RtngLine."Fixed Scrap Qty. (Accum.)",
                  RtngLine."Work Center No.", UnitCostCalculation, MfgSetup."Cost Incl. Setup",
                  RtngLine."Concurrent Capacities");

                IF (RtngLine.Type = RtngLine.Type::"Work Center") AND
                   (WorkCenter."Subcontractor No." <> '')
                THEN
                    IncrCost(SLSub, DirUnitCost, CostTime)
                ELSE
                    IncrCost(SLCap, DirUnitCost, CostTime);
                IncrCost(SLCapOvhd, CostCalcMgt.CalcOvhdCost(DirUnitCost, IndirCostPct, OvhdRate, 1), CostTime);
            UNTIL RtngLine.NEXT() = 0;
        end;
    end;

    PROCEDURE CalcMiddleLotSize(CodPitemNo: Code[20]; DecPLotSizeItem: Decimal): Decimal;
    VAR
        RecLProdOrdLine: Record "Prod. Order Line";
        DatLBegin: Date;
        DatLEnd: Date;
        DecLLotSizeItem: Decimal;
        DecLMiddle: Decimal;
        DecLSum: Decimal;
        IntLCount: Integer;
    BEGIN
        //===Calc Middle for Lot Size========================================
        EVALUATE(DatLBegin, '01/01/' + FORMAT(DATE2DWY(WORKDATE(), 3)));
        EVALUATE(DatLEnd, '31/12/' + FORMAT(DATE2DWY(WORKDATE(), 3)));
        IntLCount := 0;
        DecLSum := 0;
        DecLMiddle := 1;
        DecLLotSizeItem := DecPLotSizeItem;
        RecLProdOrdLine.RESET();
        RecLProdOrdLine.SETRANGE("Item No.", CodPitemNo);
        RecLProdOrdLine.SETRANGE(Status, 4);
        RecLProdOrdLine.SETRANGE("Ending Date", DatLBegin, DatLEnd);
        IF RecLProdOrdLine.FindSet() THEN
            REPEAT
                IntLCount += 1;
                DecLSum += RecLProdOrdLine.Quantity;
            UNTIL RecLProdOrdLine.NEXT() = 0;

        IF IntLCount <> 0 THEN
            DecLMiddle := ROUND(DecLSum / IntLCount, 0.01, '>')
        ELSE
            IF DecLLotSizeItem > DecLMiddle THEN
                DecLMiddle := DecLLotSizeItem;

        EXIT(DecLMiddle);
    END;

    PROCEDURE FctCalcItemMonoLevel(ItemNo: Code[20]; NewUseAssemblyList: Boolean);//TODO: Il y'a 2 fonction local liee a cette fonction et une table temporel chargé au niveau de son codeunit    //TempItem : TEMPORARY Record 27;
    BEGIN
        //     NewCalcMultiLevel := FALSE;
        //     CalculateStandardCost.SetProperties(WORKDATE, NewCalcMultiLevel, NewUseAssemblyList, FALSE, '', FALSE);
        //     IF NewUseAssemblyList THEN
        //         CalcAssemblyItem(ItemNo, Item, 0)
        //     ELSE
        //         CalcMfgItem(ItemNo, Item, 0);
        //     IF TempItem.FIND('-') THEN
        //         REPEAT
        //             ItemCostMgt.UpdateStdCostShares(TempItem);
        //         UNTIL TempItem.NEXT = 0;
    END;

    PROCEDURE CalculateCost(RecPItem: Record Item);
    VAR
        RecLItem: Record "Item";
        RecLProductionBOMHeader: Record "Production BOM Header";
        RecLBOMLine: Record "Production BOM Line";
        RecLRoutingHeader: Record "Routing Header";
        VersionMgt: Codeunit "VersionManagement";
        TxtL50000: label 'Item Cost can''t be calculated. The component %1 is not valued.';
    BEGIN
        //>>TDL290719.001
        //>>TDL100220.001
        //IF (RecPItem."Replenishment System" = RecPItem."Replenishment System"::Purchase) AND (RecPItem."Unit Cost" = 0) THEN
        //    ERROR(TxtL50000,RecPItem."No.");
        IF RecPItem."Replenishment System" = RecPItem."Replenishment System"::Purchase THEN BEGIN
            IF ((RecPItem."Costing Method" = RecPItem."Costing Method"::Standard) AND (RecPItem."Standard Cost" = 0))
               OR
               ((RecPItem."Costing Method" = RecPItem."Costing Method"::Average) AND (RecPItem."Unit Cost" = 0))
            THEN
                //>>NDBI
                //>>NDBI

                IF RecPItem."Inventory Posting Group" <> 'NON_VALO' THEN
                    //    ERROR(TxtL50000,RecPItem."No.");
                    ERROR(TxtL50000, RecPItem."No.");
            //<<NDBI
        END ELSE
            //<<TDL100220.001

            IF (RecPItem."Costing Method" = RecPItem."Costing Method"::Standard) AND (RecPItem."Standard Cost" = 0) THEN
                IF RecPItem."Replenishment System" = RecPItem."Replenishment System"::"Prod. Order" THEN BEGIN

                    RecLRoutingHeader.GET(RecPItem."Routing No.");
                    IF RecLRoutingHeader.Status <> RecLRoutingHeader.Status::Certified THEN
                        RecLRoutingHeader.FIELDERROR(Status);

                    RecLProductionBOMHeader.GET(RecPItem."Production BOM No.");
                    IF RecLProductionBOMHeader.Status <> RecLProductionBOMHeader.Status::Certified THEN
                        RecLProductionBOMHeader.FIELDERROR(Status);

                    // on descend la nomenclature
                    RecLBOMLine.RESET();
                    RecLBOMLine.SETRANGE("Production BOM No.", RecPItem."Production BOM No.");
                    RecLBOMLine.SETRANGE("Version Code", VersionMgt.GetBOMVersion(RecPItem."Production BOM No.", TODAY, TRUE));
                    RecLBOMLine.SETRANGE(Type, RecLBOMLine.Type::Item);
                    RecLBOMLine.SETFILTER("Starting Date", '%1|<=%2', 0D, TODAY);
                    RecLBOMLine.SETFILTER("Ending Date", '%1|>=%2', 0D, TODAY);
                    RecLBOMLine.SETFILTER("Quantity per", '<>%1', 0);
                    IF RecLBOMLine.FINDSET() THEN BEGIN
                        REPEAT
                            RecLItem.GET(RecLBOMLine."No.");
                            CalculateCost(RecLItem);
                        UNTIL RecLBOMLine.NEXT() = 0;
                        // Calculate Cost
                        FctCalcItemMonoLevel(RecPItem."No.", FALSE)
                    END;
                END ELSE
                    //>>NDBI
                    //>>NDBI

                    IF RecPItem."Inventory Posting Group" <> 'NON_VALO' THEN
                        //    ERROR(TxtL50000,RecPItem."No.");
                        ERROR(TxtL50000, RecPItem."No.");
        //<<NDBI
        //<<TDL290719.001
    END;

    procedure GetAndTestCertifiedRtngVersion(Var RtngHeader: Record "Routing Header"; Var RtngVersion: Record "Routing Version"; RtngNo: Code[20]; Date: Date; HideError: Boolean): Code[10];
    begin
        CLEAR(RtngHeader);
        CLEAR(RtngVersion);
        RtngHeader.GET(RtngNo);
        RtngVersion.SETCURRENTKEY("Routing No.", "Starting Date");
        RtngVersion.SETRANGE("Routing No.", RtngNo);
        RtngVersion.SETFILTER("Starting Date", '%1|..%2', 0D, Date);
        IF RtngVersion.FIND('+') THEN BEGIN
            IF NOT HideError THEN
                RtngVersion.TESTFIELD(Status, RtngVersion.Status::Certified);
        END ELSE
            IF NOT HideError THEN
                RtngHeader.TESTFIELD(Status, RtngHeader.Status::Certified);

        EXIT(RtngVersion."Version Code");
    end;

    local procedure TestRtngVersionIsCertified(RtngVersionCode: Code[20]; RtngHeader: Record "Routing Header")//TODO: la fonction InsertInErrBuf est une fonction local et le variable LogErrors se charge dans le codeunit 5812
    begin
        // if RtngVersionCode = '' then begin
        //     if RtngHeader.Status <> RtngHeader.Status::Certified then
        //         if LogErrors then
        //             InsertInErrBuf(RtngHeader."No.", '', true)
        //         else
        //             RtngHeader.TestField(Status, RtngHeader.Status::Certified);
        // end;
    end;

    procedure CalcRtngCostPerUnit(Type: Enum "Capacity Type Routing"; No: Code[20]; var DirUnitCost: Decimal; var IndirCostPct: Decimal; var OvhdRate: Decimal; var UnitCost: Decimal; var UnitCostCalculation: Option Time,Unit)
    Begin
        //TODO: la fonction contient 2 fonction local dans le codeunit 5812    begin
        // case Type of
        //     Type::"Work Center":
        //         GetWorkCenter(No, WorkCenter);
        //     Type::"Machine Center":
        //         GetMachineCenter(No, MachineCenter);
        // end;

        // IsHandled := false;
        // OnCalcRtngCostPerUnitOnBeforeCalc(Type.AsInteger(), DirUnitCost, IndirCostPct, OvhdRate, UnitCost, UnitCostCalculation, WorkCenter, MachineCenter, IsHandled);
        // if IsHandled then
        //     exit;

        // CostCalcMgt.RoutingCostPerUnit(
        //     Type, DirUnitCost, IndirCostPct, OvhdRate, UnitCost, UnitCostCalculation, WorkCenter, MachineCenter);
    end;

    procedure IncrCost(var Cost: Decimal; UnitCost: Decimal; Qty: Decimal)
    begin
        Cost := Cost + (Qty * UnitCost);
    end;

    //---CDU6500---
    procedure BeforeRegisterNewItemTrackingLines(var TempTrackingSpecification: Record "Tracking Specification" temporary)
    var
        ProdOrderComp: Record "Prod. Order Component";
        TempProdOrderComp: Record "Prod. Order Component" TEMPORARY;
        ProdOrderLine: Record "Prod. Order Line";
        cuLotInheritanceMgt: Codeunit "PWD Lot Inheritance Mgt.PW";
    begin
        IF TempTrackingSpecification.FINDSET() THEN
            REPEAT
                //>>FE_PROD01.001
                IF TempTrackingSpecification."Source Type" = DATABASE::"Prod. Order Component" THEN BEGIN
                    TempProdOrderComp.Status := "Production Order Status".FromInteger(TempTrackingSpecification."Source Subtype");
                    TempProdOrderComp."Prod. Order No." := TempTrackingSpecification."Source ID";
                    TempProdOrderComp."Prod. Order Line No." := TempTrackingSpecification."Source Prod. Order Line";
                    TempProdOrderComp."Line No." := TempTrackingSpecification."Source Ref. No.";
                    IF TempProdOrderComp.INSERT() THEN;
                END;
            //<<FE_PROD01.001
            UNTIL TempTrackingSpecification.NEXT() = 0;
        //>>FE_PROD01.001
        IF TempProdOrderComp.FIND('-') THEN
            REPEAT
                ProdOrderComp.GET(
                  TempProdOrderComp.Status,
                  TempProdOrderComp."Prod. Order No.",
                  TempProdOrderComp."Prod. Order Line No.",
                  TempProdOrderComp."Line No.");
                IF ProdOrderComp."PWD Lot Determining" THEN BEGIN
                    ProdOrderLine.GET(ProdOrderComp.Status, ProdOrderComp."Prod. Order No.", ProdOrderComp."Prod. Order Line No.");
                    cuLotInheritanceMgt.AutoCreatePOLTracking(ProdOrderLine);
                END;
            UNTIL TempProdOrderComp.NEXT() = 0;
        //<<FE_PROD01.001
    end;

    PROCEDURE FctCopyItemTrackingSpec(FromRowID: Text[250]; ToRowID: Text[250]; SwapSign: Boolean; DecPQty: Decimal);
    BEGIN
        FctCopyItemTrackingSpec2(FromRowID, ToRowID, SwapSign, FALSE, DecPQty);
    END;

    PROCEDURE FctCopyItemTrackingSpec2(FromRowID: Text[250]; ToRowID: Text[250]; SwapSign: Boolean; SkipReservation: Boolean; DecPQty: Decimal);
    VAR
        ReservEntry: Record "Reservation Entry";
    BEGIN
        ReservEntry.SetPointer(FromRowID);
        ReservEntry.SetPointerFilter();
        FctCopyItemTrackingSpec3(ReservEntry, ToRowID, SwapSign, SkipReservation, DecPQty);
    END;

    PROCEDURE FctCopyItemTrackingSpec3(VAR ReservEntry: Record 337; ToRowID: Text[250]; SwapSign: Boolean; SkipReservation: Boolean; DecPQty: Decimal);
    VAR
        ReservEntry1: Record "Reservation Entry";
        TempReservEntry: Record "Reservation Entry" TEMPORARY;
        LastEntryNo: Integer;
    BEGIN
        IF SkipReservation THEN
            ReservEntry.SETFILTER("Reservation Status", '<>%1', ReservEntry."Reservation Status"::Reservation);
        IF ReservEntry.FINDSET() THEN BEGIN
            REPEAT
                IF (ReservEntry."Lot No." <> '') OR (ReservEntry."Serial No." <> '') THEN BEGIN
                    TempReservEntry := ReservEntry;
                    TempReservEntry."Reservation Status" := TempReservEntry."Reservation Status"::Prospect;
                    TempReservEntry."Quantity (Base)" := DecPQty;
                    TempReservEntry.Quantity := DecPQty;
                    //TempReservEntry."Qty. to Handle (Base)" := DecPQty;
                    //TempReservEntry."Qty. to Invoice (Base)" := DecPQty;
                    //TempReservEntry."Quantity Invoiced (Base)" := DecPQty;
                    TempReservEntry.SetPointer(ToRowID);
                    IF SwapSign THEN BEGIN
                        TempReservEntry."Quantity (Base)" := -TempReservEntry."Quantity (Base)";
                        TempReservEntry.Quantity := -TempReservEntry.Quantity;
                        TempReservEntry."Qty. to Handle (Base)" := -TempReservEntry."Qty. to Handle (Base)";
                        TempReservEntry."Qty. to Invoice (Base)" := -TempReservEntry."Qty. to Invoice (Base)";
                        TempReservEntry."Quantity Invoiced (Base)" := -TempReservEntry."Quantity Invoiced (Base)";
                        TempReservEntry.Positive := TempReservEntry."Quantity (Base)" > 0;
                    END;
                    TempReservEntry.INSERT();
                END;
            UNTIL ReservEntry.NEXT() = 0;

            ModifyTempReservEntrySetIfTransfer(TempReservEntry);

            IF TempReservEntry.FINDSET() THEN BEGIN
                ReservEntry1.RESET();
                ReservEntry1.LOCKTABLE();
                IF ReservEntry1.FINDLAST() THEN
                    LastEntryNo := ReservEntry1."Entry No.";
                REPEAT
                    ReservEntry1 := TempReservEntry;
                    LastEntryNo += 1;
                    ReservEntry1."Entry No." := LastEntryNo;
                    ReservEntry1.INSERT();
                UNTIL TempReservEntry.NEXT() = 0;
            END;
        END;
    END;

    local procedure ModifyTempReservEntrySetIfTransfer(var TempReservEntry: Record "Reservation Entry" temporary)
    var
        TransLine: Record "Transfer Line";
    begin
        if TempReservEntry."Source Type" = DATABASE::"Transfer Line" then begin
            TransLine.Get(TempReservEntry."Source ID", TempReservEntry."Source Ref. No.");
            TempReservEntry.ModifyAll("Reservation Status", TempReservEntry."Reservation Status"::Surplus);
            if TempReservEntry."Source Subtype" = 0 then begin
                TempReservEntry.ModifyAll("Location Code", TransLine."Transfer-from Code");
                TempReservEntry.ModifyAll("Expected Receipt Date", 0D);
                TempReservEntry.ModifyAll("Shipment Date", TransLine."Shipment Date");
            end else begin
                TempReservEntry.ModifyAll("Location Code", TransLine."Transfer-to Code");
                TempReservEntry.ModifyAll("Expected Receipt Date", TransLine."Receipt Date");
                TempReservEntry.ModifyAll("Shipment Date", 0D);
            end;
        end;
    end;
    //---CDU6501---
    PROCEDURE LotSNAvailablePhantom(TrackingSpecification: Record 336 TEMPORARY): Decimal;
    VAR
        TempGlobalEntrySummary: Record 338 TEMPORARY;
        ItemTrackingDataCollection: codeunit "Item Tracking Data Collection";
    BEGIN
        // >> FE_LAPRIERRETTE_GP0003 : APA 16/05/13
        TempGlobalEntrySummary.RESET();
        TempGlobalEntrySummary.DELETEALL();
        ItemTrackingDataCollection.RetrieveLookupData(TrackingSpecification, TRUE);

        TempGlobalEntrySummary.RESET();
        TempGlobalEntrySummary.SETCURRENTKEY("Lot No.", "Serial No.");
        TempGlobalEntrySummary.SETRANGE("Serial No.", '');
        TempGlobalEntrySummary.SETRANGE("Lot No.", TrackingSpecification."Lot No.");
        TempGlobalEntrySummary.CALCSUMS("Total Available Quantity");
        EXIT(TempGlobalEntrySummary."Total Available Quantity");
        // << FE_LAPRIERRETTE_GP0003 : APA 16/05/13
    END;
    //---PAG9245---
    procedure ProdForecastByLocationQtyBase(var SourceProdForecastEntry: Record "Production Forecast Entry"): Decimal
    var
        ProductionForecastEntry: Record "Production Forecast Entry";
    begin
        ProductionForecastEntry.CopyFilters(SourceProdForecastEntry);
        ProductionForecastEntry.SetRange("Location Code", SourceProdForecastEntry."Location Code");
        ProductionForecastEntry.CalcSums("Forecast Quantity (Base)");
        exit(ProductionForecastEntry."Forecast Quantity (Base)");
    end;
    //---CDU6501---
    procedure ShouldExitLookupTrackingAvailability(TempTrackingSpecification: Record "Tracking Specification" temporary; LookupMode: Enum "Item Tracking Type"): Boolean
    begin
        case LookupMode of
            LookupMode::"Serial No.":
                if TempTrackingSpecification."Serial No." = '' then
                    exit(true);
            LookupMode::"Lot No.":
                if TempTrackingSpecification."Lot No." = '' then
                    exit(true);
        end;
    end;
    //---CDU3010801---
    PROCEDURE FctShippedLines(RecPSalesHeader: Record "Sales Header"): Boolean;
    VAR
        RecLSalesLines: Record "Sales Line";
    BEGIN
        RecLSalesLines.RESET();
        RecLSalesLines.SETRANGE("Document Type", RecPSalesHeader."Document Type");
        RecLSalesLines.SETRANGE("Document No.", RecPSalesHeader."No.");
        RecLSalesLines.SETFILTER("Quantity Shipped", '<>%1', 0);
        IF RecLSalesLines.ISEMPTY THEN
            EXIT(FALSE)
        ELSE
            EXIT(TRUE);
    END;
    //---CDU414---
    PROCEDURE FctIsImport(BooPDontExecuteIfImport: Boolean)
    var
        BooGDontExecuteIfImport: boolean;
    BEGIN
        //>>WMS-FE05.001
        BooGDontExecuteIfImport := BooPDontExecuteIfImport;
        //<<WMS-FE05.001
    END;
    // //---CDU703---(REPORT 11511)
    // PROCEDURE SetFromConfiguration()
    // var
    //     BooGFromConfig: Boolean;
    // BEGIN
    //     BooGFromConfig := TRUE;
    // END;

    PROCEDURE CopyFromConfiguration(CodPIntemNo: Code[20]; VAR RecPNewItem: Record Item; CopyItemBuffer: Record "Copy Item Buffer")
    VAR
        RecLFromItem: Record Item;
        RecLItemConfigurator: Record "PWD Item Configurator";
        RecLNewItemConfigurator: Record "PWD Item Configurator";
        RecLSubFamily: Record "PWD SubFamily LPSA";
        CstTxt50000: Label 'There is not configuration for item %1.';
        CstTxt50001: Label '%1 must be define for source item %2.';
        Text010: Label 'Target Item No.%1 already exists.';
        TxtLNumber: Text[5];
    BEGIN
        RecLFromItem.GET(CodPIntemNo);

        RecLItemConfigurator.SETCURRENTKEY("Item Code");
        RecLItemConfigurator.SETRANGE("Item Code", CodPIntemNo);
        IF RecLItemConfigurator.ISEMPTY THEN
            ERROR(CstTxt50000, CodPIntemNo);
        RecLItemConfigurator.FINDLAST();

        IF RecLItemConfigurator."Subfamily Code" = '' THEN
            ERROR(CstTxt50001, RecLItemConfigurator.FIELDCAPTION("Subfamily Code"), CodPIntemNo);

        RecLNewItemConfigurator := RecLItemConfigurator;
        RecLNewItemConfigurator."Entry No." := 0;
        RecLNewItemConfigurator."Item Code" := '';
        RecLNewItemConfigurator."PWD LPSA Description 1" := '';
        RecLNewItemConfigurator."PWD LPSA Description 2" := '';
        RecLNewItemConfigurator."PWD Quartis Description" := '';
        RecLNewItemConfigurator.INSERT(TRUE);

        // Update New "Item Code"
        RecLSubFamily.GET(RecLNewItemConfigurator."Family Code", RecLNewItemConfigurator."Subfamily Code");

        RecLNewItemConfigurator."Item Code" := RecLNewItemConfigurator."Family Code" + RecLNewItemConfigurator."Subfamily Code";
        IF RecLNewItemConfigurator."Phantom Item" THEN BEGIN
            RecLNewItemConfigurator."Item Code" := RecLNewItemConfigurator."Item Code" + 'F';
            RecLSubFamily.NumberF += 1;
            TxtLNumber := FORMAT(RecLSubFamily.NumberF);
            RecLNewItemConfigurator."Item Code" := PADSTR(RecLNewItemConfigurator."Item Code", 8 - STRLEN(TxtLNumber), '0');
            RecLNewItemConfigurator."Item Code" := RecLNewItemConfigurator."Item Code" + TxtLNumber;
        END ELSE BEGIN
            RecLSubFamily.Number += 1;
            TxtLNumber := FORMAT(RecLSubFamily.Number);
            RecLNewItemConfigurator."Item Code" := PADSTR(RecLNewItemConfigurator."Item Code", 8 - STRLEN(TxtLNumber), '0');
            RecLNewItemConfigurator."Item Code" := RecLNewItemConfigurator."Item Code" + TxtLNumber;
        END;

        // Check Item Code not exist
        IF RecPNewItem.GET(RecLNewItemConfigurator."Item Code") THEN
            ERROR(Text010, RecLNewItemConfigurator."Item Code");

        RecLNewItemConfigurator.MODIFY();
        RecLSubFamily.MODIFY();

        // Create New Item
        RecPNewItem."No." := RecLNewItemConfigurator."Item Code";
        IF NOT CopyItemBuffer."General Item Information" THEN
            RecPNewItem.INSERT();
    END;
}
