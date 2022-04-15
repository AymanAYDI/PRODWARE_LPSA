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

}
