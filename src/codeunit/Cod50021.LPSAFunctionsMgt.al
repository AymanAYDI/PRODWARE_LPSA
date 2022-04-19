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
        RecLNegReservEntry: Record "Reservation Entry";
        RecLPosReservEntry: Record "Reservation Entry";
        RecLProdOrderLine: Record "Prod. Order Line";
        RecLLinkedProdOrder: Record "Production Order";
        RecLPlannerOneSetup: Record 8076502;  //TODO: Table n'existe pas
        RecLPlannerOneUtil: Codeunit 8076503; //TODO: CodeUnit n'existe pas
        CduLCalcProdOrder: Codeunit 99000773;
        DecLRemQty: Decimal;
        DecLBaseRemQty: Decimal;
        CstL50000: Label 'More than on product order is linked to item %1, lot %2. Update is stopped.';
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
        IF NOT (RecLPlannerOneSetup.FINDFIRST
           AND (RecLPlannerOneSetup.ProductionSchedulerEnabled AND RecLPlannerOneUtil.ProdOrderFilter(RecLProdOrderLine.Status, RecPProdOrderLine."Prod. Order No.", RecPProdOrderLine."Line No."))) THEN
            CduLCalcProdOrder.Recalculate(RecLProdOrderLine, 1);
        //<<FE_PROD01.002
    END;
    //---CDU80---
    PROCEDURE FctBooGFromWMS(); //TODO: Fonction WMS CodeUnit 80
    var
        BooGFromWMS: Boolean;
    BEGIN
        BooGFromWMS := TRUE;
    END;

    PROCEDURE FctSalesLineFilterWMS(VAR RecPSalesLine: Record 37); //TODO: Fonction WMS CodeUnit 80
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

    PROCEDURE FctBooGFromConnector();  //TODO: Fonction WMS CodeUnit 80
    var
        BooGFromConnector: Boolean;
    BEGIN
        BooGFromConnector := TRUE;
    END;
    //---CDU241---
    PROCEDURE FctRecreateJournalLine(Var ItemJnlLine: Record 83);
    VAR
        RecLProdOrderLine: Record "Prod. Order Line";
        CduLLotInheritanceMgt: Codeunit "PWD Lot Inheritance Mgt.PW";
        RecLItem: Record Item;
        RecLProdOrderComponent: Record "Prod. Order Component";
        RecLReservationEntry: Record "Reservation Entry";
        RecLItemJournalLine: Record "Item Journal Line";
        CduLProductionJournalMgt: Codeunit "Production Journal Mgt";
        RecLProdOrder: Record "Production Order";
        RecLItemLedgerEntry: Record "Item Ledger Entry";
        RecLProdOrderRoutingLine: Record "Prod. Order Routing Line";
    BEGIN
        IF ItemJnlLine."Entry Type" = ItemJnlLine."Entry Type"::Output THEN BEGIN
            RecLItemJournalLine.RESET;

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
            IF RecLItemJournalLine.FINDLAST THEN BEGIN

                //On v‚rifie si le journal line est associ‚ … la derniŠre ligne de gamme pour pouvoir y associer la tra‡a
                RecLProdOrderRoutingLine.SETRANGE(Status, RecLProdOrderLine.Status::Released);
                RecLProdOrderRoutingLine.SETRANGE(RecLProdOrderRoutingLine."Prod. Order No.", ItemJnlLine."Order No.");
                RecLProdOrderRoutingLine.SETRANGE(RecLProdOrderRoutingLine."Routing Reference No.", ItemJnlLine."Order Line No.");
                RecLProdOrderRoutingLine.SETRANGE(RecLProdOrderRoutingLine."Routing No.", ItemJnlLine."Routing No.");
                //RecLProdOrderRoutingLine.SETRANGE(RecLProdOrderRoutingLine."Operation No.",ItemJnlLine."Operation No.");
                RecLProdOrderRoutingLine.SETRANGE(RecLProdOrderRoutingLine."Operation No.", RecLItemJournalLine."Operation No.");
                IF RecLProdOrderRoutingLine.FINDFIRST THEN
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
                                    IF RecLProdOrderComponent.FINDFIRST THEN BEGIN
                                        RecLReservationEntry.SETRANGE(RecLReservationEntry."Item No.", RecLProdOrderComponent."Item No.");
                                        RecLReservationEntry.SETRANGE(RecLReservationEntry."Source Subtype", RecLReservationEntry."Source Subtype"::"3");
                                        RecLReservationEntry.SETRANGE(RecLReservationEntry."Source ID", RecLProdOrderComponent."Prod. Order No.");
                                        RecLReservationEntry.SETRANGE(RecLReservationEntry."Source Prod. Order Line",
                                        RecLProdOrderComponent."Prod. Order Line No.");
                                        RecLReservationEntry.SETRANGE(RecLReservationEntry."Source Ref. No.", RecLProdOrderComponent."Line No.");
                                        RecLReservationEntry.SETFILTER(RecLReservationEntry."Lot No.", '<>%1', '');
                                        //Si il exite une ecriture r‚servation alors on copie le num‚ro de lot
                                        IF RecLReservationEntry.FINDFIRST THEN BEGIN
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
                                            IF RecLItemLedgerEntry.FINDFIRST THEN BEGIN
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
    END;

    PROCEDURE FctCheckJnlTemplateIsFromOF(RecPItemJournalLine: Record 83): Boolean;
    VAR
        RecLItemJnlTemplate: Record "Item Journal Template";
    BEGIN
        //On regarde si on est en train de valider le journal depuis l'OF ou depuis la feuille de production
        RecLItemJnlTemplate.RESET;
        RecLItemJnlTemplate.SETRANGE("Page ID", Page::"Production Journal");
        RecLItemJnlTemplate.SETRANGE(Recurring, FALSE);
        RecLItemJnlTemplate.SETRANGE(Type, RecLItemJnlTemplate.Type::"Prod. Order");
        IF RecLItemJnlTemplate.FINDFIRST THEN BEGIN
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
        CduLProductionJournalMgt: Codeunit "Production Journal Mgt";
        RecLProdOrder: Record "Production Order";
        CduLLotInheritanceMgt: Codeunit "PWD Lot Inheritance Mgt.PW";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
    BEGIN
        //Suppression et Recr‚ation des lignes de journal avec le num‚ro de lot du composant
        RecLProdOrder.GET(RecPProdOrderLine.Status, RecPProdOrderLine."Prod. Order No.");

        //CduLProductionJournalMgt.DeleteReservEntryFromOF(RecPProdOrderLine."Prod. Order No.",RecPProdOrderLine."Line No.");
        //COMMIT;

        CduLLotInheritanceMgt.AutoCreatePOLTrackingPWD(RecPProdOrderLine, ItemJnlLine.Quantity);
        COMMIT;

        //CduLProductionJournalMgt.CreateJnlLines(RecLProdOrder,RecPProdOrderLine."Line No.");
        //ItemTrackingMgt.CopyItemTracking(RecPProdOrderLine.RowID1,ItemJnlLine.RowID1,FALSE);
        ItemTrackingMgt.FctCopyItemTrackingSpec(RecPProdOrderLine.RowID1, ItemJnlLine.RowID1, FALSE, ItemJnlLine.Quantity);
        COMMIT;
    END;

    PROCEDURE FctRecreateJournalFromProd(RecPProdOrderLine: Record 5406; RecPItemJournalLine: Record 83);
    VAR
        CduLProductionJournalMgt: Codeunit "Production Journal Mgt";
        RecLProdOrder: Record "Production Order";
        CduLLotInheritanceMgt: Codeunit "PWD Lot Inheritance Mgt.PW";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
    BEGIN
        //Suppression et Recr‚ation des lignes de journal avec le num‚ro de lot du composant
        CduLProductionJournalMgt.InitJnalName(RecPItemJournalLine."Journal Template Name",
                                              RecPItemJournalLine."Journal Batch Name");
        //CduLProductionJournalMgt.DeleteReservEntry(RecPProdOrderLine."Prod. Order No.",RecPProdOrderLine."Line No.");
        //COMMIT;

        CduLLotInheritanceMgt.AutoCreatePOLTrackingPWD(RecPProdOrderLine, RecPItemJournalLine.Quantity);
        COMMIT;

        //CduLProductionJournalMgt.InsertOutputJnlLine2(RecPItemJournalLine,RecPProdOrderLine);
        //ItemTrackingMgt.CopyItemTracking(RecPProdOrderLine.RowID1,RecPItemJournalLine.RowID1,FALSE);
        ItemTrackingMgt.FctCopyItemTrackingSpec(RecPProdOrderLine.RowID1, RecPItemJournalLine.RowID1, FALSE, RecPItemJournalLine.Quantity);
        COMMIT;
    END;

    PROCEDURE ClearWrongReservEntries(Var ItemJnlLine: Record 83);
    VAR
        RecLReservEntry: Record "Reservation Entry";
        RecLReservEntry2: Record "Reservation Entry";
        RecLItemJnlLine: Record "Item Journal Line";
        ItemJnlTemplate: Record "Item Journal Template";
    BEGIN
        ItemJnlTemplate.Get(ItemJnlLine."Journal Template Name");
        RecLReservEntry.RESET;
        RecLReservEntry.SETRANGE("Source Type", DATABASE::"Item Journal Line");
        RecLReservEntry.SETRANGE("Source Subtype", RecLReservEntry."Source Subtype"::"5");
        RecLReservEntry.SETRANGE("Source ID", ItemJnlTemplate.Name);
        RecLReservEntry.SETRANGE("Source Batch Name", ItemJnlLine."Journal Batch Name");
        IF NOT RecLReservEntry.ISEMPTY THEN BEGIN
            RecLReservEntry.LOCKTABLE;
            RecLReservEntry.FINDSET;
            REPEAT
                IF NOT RecLItemJnlLine.GET(RecLReservEntry."Source ID", RecLReservEntry."Source Batch Name", RecLReservEntry."Source Ref. No.")
                THEN BEGIN
                    IF RecLReservEntry2.GET(RecLReservEntry."Entry No.", NOT RecLReservEntry.Positive) THEN
                        RecLReservEntry2.DELETE;
                    RecLReservEntry.DELETE;
                END;
            UNTIL RecLReservEntry.NEXT = 0;
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
        RecLPurchSetup.GET;
        IF PurchHeader."No. Series" = RecLPurchSetup."Order Nos." THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
        //<<FE_LAPIERRETTE_NDT01.001
    END;

    //---CDU99000854---
    procedure Fct_OnBeforeCreateSupply_InventoryProfileOffsetting(var Supply: Record "Inventory Profile"; var Demand: Record "Inventory Profile")
    var
        //SalesLine: Record "Sales Line";
        ReqLine: Record "Requisition Line";
        ProdOrder: Record "Production Order";
    //Counter: Integer;
    begin
        //TODO: table extension "Inventory Profile" n'exsiste pas
        CASE Demand."Source Type" OF
            DATABASE::"Sales Line":
                //IF RecLSalesLine.GET(Demand."Source Order Status",Demand."Source ID",Demand."Source Ref. No.") THEN BEGIN
                IF Demand."Transmitted Order No." THEN BEGIN
                    Supply."Original Source Id" := Demand."Original Source Id";
                    Supply."Original Source No." := Demand."Original Source No.";
                    Supply."Original Source Position" := Demand."Original Source Position";
                    Supply."Original Counter" := 0;
                    Supply."Transmitted Order No." := TRUE;
                END;
            DATABASE::"Planning Component":
                IF ReqLine.GET(Demand."Source ID", Demand."Source Batch Name", Demand."Source Prod. Order Line") THEN
                    IF ReqLine."Transmitted Order No." THEN BEGIN
                        Supply."Original Source Id" := ReqLine."Original Source Id";
                        Supply."Original Source No." := ReqLine."Original Source No.";
                        Supply."Original Source Position" := ReqLine."Original Source Position";
                        Supply."Transmitted Order No." := TRUE;

                        ReqLine.RESET();
                        ReqLine.SETRANGE("Original Source Id", Supply."Original Source Id");
                        ReqLine.SETRANGE("Original Source No.", Supply."Original Source No.");
                        ReqLine.SETRANGE("Original Source Position", Supply."Original Source Position");
                        IF ReqLine.FINDLAST() THEN
                            Supply."Original Counter" := ReqLine."Original Counter" + 1;
                    END;
            DATABASE::"Prod. Order Component":
                IF ProdOrder.GET(Demand."Source Order Status", Demand."Source ID") THEN
                    IF ProdOrder."Transmitted Order No." THEN BEGIN
                        Supply."Original Source Id" := Demand."Source Type";
                        Supply."Original Source No." := ProdOrder."Original Source No.";
                        Supply."Original Source Position" := ProdOrder."Original Source Position";
                        Supply."Original Counter" := 1;
                        Supply."Transmitted Order No." := TRUE;
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
        //>>TDL_12_06_18.001
        IF ReqLine.FINDSET() THEN
            REPEAT
                IF IntLCounter < ReqLine."PWD Original Counter" THEN
                    IntLCounter := ReqLine."PWD Original Counter";
            UNTIL ReqLine.NEXT = 0;
        //<<TDL_12_06_18.001
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

        WITH NewProdOrderComp DO BEGIN
            IF Status = Status::Finished THEN
                EXIT;
            //TODO: SetSourceForProdOrderComp procedure local dans le codeunit "Reservation Management"  
            //ReservMgt.SetSourceForProdOrderComp();
            IF "Qty. per Unit of Measure" <> OldProdOrderComp."Qty. per Unit of Measure" THEN
                ReservMgt.ModifyUnitOfMeasure();
            IF "Remaining Qty. (Base)" * OldProdOrderComp."Remaining Qty. (Base)" < 0 THEN
                ReservMgt.DeleteReservEntries(TRUE, 0)
            ELSE
                ReservMgt.DeleteReservEntries(FALSE, "Remaining Qty. (Base)");
            ReservMgt.ClearSurplus();
            ReservMgt.AutoTrack("Remaining Qty. (Base)");
            //TODO: AssignForPlanning procedure local dans le codeunit "Prod. Order Comp.-Reserve"
            //AssignForPlanning(NewProdOrderComp);
        END;
    END;
    //---CDU99000835---
    PROCEDURE SetgFromTheSameLot(piSet: Boolean)
    BEGIN
        gFromTheSameLot := piSet;
    END;

    PROCEDURE SetgLotDeterminingData(piSetLotCode: Code[30]; piSetExpirDate: Date): Code[20]
    BEGIN
        gLotDeterminingLotCode := piSetLotCode;
        gLotDeterminingExpirDate := piSetExpirDate;
        IF piSetLotCode <> '' THEN
            gFromTheSameLot := TRUE;
    END;
    //---CDU99000813---
    PROCEDURE FctGetTime(OptPType: option "Work Center","Machine Center"; CodPNo: Code[20]; CodPItemNo: Code[20]; DecPQty: Decimal; VAR DecPSetupTime: Decimal; VAR DecPRunTime: Decimal; VAR CodPSetupTimeUnit: Code[10]; VAR CodPRunTimeUnit: Code[10])
    VAR
        RecLManufCyclesSetup: Record "PWD Manufacturing cycles Setup";
        DecLQm: Decimal;
        DecLQ: Decimal;
        DecLn: Decimal;
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

    PROCEDURE FctGetTimeForCost(OptPType: option "Work Center","Machine Center"; CodPNo: Code[20]; CodPItemNo: Code[20]; DecPQty: Decimal; VAR DecPSetupTime: Decimal; VAR DecPRunTime: Decimal; VAR CodPSetupTimeUnit: Code[10]; VAR CodPRunTimeUnit: Code[10])
    VAR
        RecLManufCyclesSetup: Record "PWD Manufacturing cycles Setup";
        DecLQm: Decimal;
        DecLQ: Decimal;
        DecLn: Decimal;
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
        WorkCenter: Record "Work Center";
        MachineCenter: Record "Machine Center";
        PlanningRtngLine: Record "Planning Routing Line";
        ProdOrderRtngLine: Record "Prod. Order Routing Line";
        RecLRoutingLine: Record "Routing Line";
        DecLSetupTime: Decimal;
        DecLRunTime: Decimal;
        CodLSetupTimeUnit: Code[10];
        CodLRunTimeUnit: Code[10];
    BEGIN
        PlanningRtngLine.SETRANGE("Worksheet Template Name", ReqLine."Worksheet Template Name");
        PlanningRtngLine.SETRANGE("Worksheet Batch Name", ReqLine."Journal Batch Name");
        PlanningRtngLine.SETRANGE("Worksheet Line No.", ReqLine."Line No.");
        IF PlanningRtngLine.FIND('-') THEN
            REPEAT
                ProdOrderRtngLine.INIT;
                ProdOrderRtngLine.Status := ProdOrder.Status;
                ProdOrderRtngLine."Prod. Order No." := ProdOrder."No.";
                ProdOrderRtngLine."Routing No." := RoutingNo;
                ProdOrderRtngLine."Routing Reference No." := RoutingRefNo;
                ProdOrderRtngLine."Operation No." := PlanningRtngLine."Operation No.";
                ProdOrderRtngLine."Next Operation No." := PlanningRtngLine."Next Operation No.";
                //TODO: 'Record "Prod. Order Routing Line"' does not contain a definition for 'Next Operation Link Type'
                //ProdOrderRtngLine."Next Operation Link Type" := PlanningRtngLine."Next Operation Link Type";
                ProdOrderRtngLine."Previous Operation No." := PlanningRtngLine."Previous Operation No.";
                ProdOrderRtngLine.Type := PlanningRtngLine.Type;
                ProdOrderRtngLine."No." := PlanningRtngLine."No.";
                ProdOrderRtngLine."Work Center No." := PlanningRtngLine."Work Center No.";
                ProdOrderRtngLine."Work Center Group Code" := PlanningRtngLine."Work Center Group Code";
                ProdOrderRtngLine.Description := PlanningRtngLine.Description;
                //>>FE_LAPIERRETTE_PROD04.001
                RecLRoutingLine.RESET;
                RecLRoutingLine.SETRANGE(RecLRoutingLine."Routing No.", RecPProdOrderLine."Routing No.");
                RecLRoutingLine.SETRANGE(RecLRoutingLine."Version Code", RecPProdOrderLine."Routing Version Code");
                RecLRoutingLine.SETRANGE(RecLRoutingLine."Operation No.", ProdOrderRtngLine."Operation No.");
                IF RecLRoutingLine.FINDFIRST THEN BEGIN
                    //TODO: table extension "Routing Line" n'exsiste pas
                    IF RecLRoutingLine."Fixed-step Prod. Rate time" THEN BEGIN
                        FctGetTime(RecLRoutingLine.Type, RecLRoutingLine."No.", RecPProdOrderLine."Item No.",
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
                RecLRoutingLine.RESET;
                RecLRoutingLine.SETRANGE(RecLRoutingLine."Routing No.", RecPProdOrderLine."Routing No.");
                RecLRoutingLine.SETRANGE(RecLRoutingLine."Version Code", RecPProdOrderLine."Routing Version Code");
                RecLRoutingLine.SETRANGE(RecLRoutingLine."Operation No.", ProdOrderRtngLine."Operation No.");
                IF RecLRoutingLine.FINDFIRST THEN BEGIN
                    IF RecLRoutingLine."Fixed-step Prod. Rate time" THEN BEGIN
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

                ProdOrderRtngLine.UpdateDatetime;
                ProdOrderRtngLine.INSERT;
            UNTIL PlanningRtngLine.NEXT = 0;
    END;

    PROCEDURE SetNoFinishCOntrol(BooPAvoidControl: Boolean);
    BEGIN
        BooGAvoidControl := BooPAvoidControl;
    END;

    PROCEDURE GetNoFinishCOntrol(): Boolean;//TODO: A vérifier cette fonction de get avec la fonction SetNoFinishCOntrol et le variable globale BooGAvoidControl
    BEGIN
        Exit(BooGAvoidControl);
    END;

    PROCEDURE TransProdOrderRtngLineAlt(Var FromProdOrder: Record 5405);
    VAR
        FromProdOrderRtngLineAlt: Record 8076509;//TODO: Record n'existe pas 
        ToProdOrderRoutLineAlt: Record 8076509; //TODO: Record n'existe pas 
        ApplicationManagement: Codeunit 1; //TODO: CodeUnite 1 n'existe pas 
        ToProdOrder: Record "Production Order";
    BEGIN
        ToProdOrder := FromProdOrder;
        // PLAW1 2.1
        // PLAW12.2 Check LICENSE
        IF NOT ApplicationManagement.CheckPlannerOneLicence THEN EXIT;
        WITH FromProdOrderRtngLineAlt DO BEGIN
            SETRANGE(Status, FromProdOrder.Status);
            SETRANGE("Prod. Order No.", FromProdOrder."No.");
            LOCKTABLE;
            IF FINDSET THEN BEGIN
                REPEAT
                    ToProdOrderRoutLineAlt := FromProdOrderRtngLineAlt;
                    ToProdOrderRoutLineAlt.Status := ToProdOrder.Status;
                    ToProdOrderRoutLineAlt."Prod. Order No." := ToProdOrder."No.";
                    ToProdOrderRoutLineAlt.INSERT;
                UNTIL NEXT = 0;
                DELETEALL;
            END;
        END;
        // PLAW1 2.1 END
    END;

    PROCEDURE TransProdOrderLink(Var FromProdOrder: Record 5405);
    VAR
        FromProdOrderLink: Record 8076507;  //TODO: Record n'existe pas 
        ToProdOrderLink: Record 8076507;  //TODO: Record n'existe pas 
        ApplicationManagement: Codeunit 1;  //TODO: CodeUnite 1 n'existe pas 
        ToProdOrder: Record "Production Order";
    BEGIN
        ToProdOrder := FromProdOrder;
        //PLAW1 2.1
        // PLAW12.2 Check LICENSE
        IF NOT ApplicationManagement.CheckPlannerOneLicence THEN EXIT;
        WITH FromProdOrderLink DO BEGIN
            SETRANGE(Status, FromProdOrder.Status);
            SETRANGE("Prod. Order No.", FromProdOrder."No.");
            IF NewStatus = NewStatus::Finished THEN
                DELETEALL
            ELSE BEGIN
                LOCKTABLE;
                IF FINDSET THEN BEGIN
                    REPEAT
                        ToProdOrderLink := FromProdOrderLink;
                        ToProdOrderLink.Status := ToProdOrder.Status;
                        ToProdOrderLink."Prod. Order No." := ToProdOrder."No.";
                        ToProdOrderLink.INSERT;
                    UNTIL NEXT = 0;
                    DELETEALL;
                END;
            END;

            RESET;
            SETRANGE("Next Status", FromProdOrder.Status);
            SETRANGE("Next Prod. Order No.", FromProdOrder."No.");
            IF NewStatus = NewStatus::Finished THEN
                DELETEALL
            ELSE BEGIN
                LOCKTABLE;
                IF FINDSET THEN BEGIN
                    REPEAT
                        ToProdOrderLink := FromProdOrderLink;
                        ToProdOrderLink."Next Status" := ToProdOrder.Status;
                        ToProdOrderLink."Next Prod. Order No." := ToProdOrder."No.";
                        ToProdOrderLink.INSERT;
                    UNTIL NEXT = 0;
                    DELETEALL;
                END;
            END;
        END;
        //PLAW1 2.1 END
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
    PROCEDURE FindFirsRecord() Tracking: Text[250]
    VAR
        TrackingExists: Boolean;
        //TODO: a vérifier : les variables TempReservEntryList,TrackingEntry, EntryNo, ItemLedgEntry2 sont des variables globales dans le codeunit OrderTrackingManagement
        TempReservEntryList: Record "Reservation Entry" temporary;
        TrackingEntry: Record "Order Tracking Entry" temporary;
        EntryNo: Integer;
        Window: Dialog;
        ItemLedgEntry2: Record "Item Ledger Entry";
        Text000: label 'Counting records...';
    BEGIN
        //>>LAP2.06
        TempReservEntryList.DELETEALL;
        TrackingEntry.DELETEALL;
        EntryNo := 1;

        WITH TrackingEntry DO BEGIN
            Window.OPEN(Text000);
            INIT;
            "Entry No." := 0;
            //TODO: DrillOrdersUp procedure local dans le codeunit OrderTrackingManagement
            //DrillOrdersUp(ReservEntry, 1);
            ItemLedgEntry2.SETCURRENTKEY("Entry No.");
            ItemLedgEntry2.MARKEDONLY(TRUE);
            IF ItemLedgEntry2.FIND('-') THEN
                REPEAT
                //TODO: InsertItemLedgTrackEntry procedure local dans le codeunit OrderTrackingManagement
                //InsertItemLedgTrackEntry(1, ItemLedgEntry2, ItemLedgEntry2."Remaining Quantity", ItemLedgEntry2);
                UNTIL ItemLedgEntry2.NEXT = 0;
            TrackingExists := FIND('-');
            IF TrackingExists THEN
                EXIT(FORMAT(-Quantity) + ' - ' + "Supplied by")
            ELSE
                EXIT('Pas de chainage');
        END;
        //<<LAP2.06
    END;

    Var
        BooGAvoidControl: Boolean;
        gFromTheSameLot: Boolean;
        gLotDeterminingLotCode: Code[30];
        gLotDeterminingExpirDate: Date;


}
