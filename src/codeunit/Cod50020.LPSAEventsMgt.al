codeunit 50020 "PWD LPSA Events Mgt."
{
    SingleInstance = true;
    //---TAB27---
    [EventSubscriber(ObjectType::table, database::Item, 'OnAfterDeleteRelatedData', '', false, false)]
    local procedure TAB27_OnAfterDeleteRelatedData_Item(Item: Record Item)
    var
        ItemConfigurator: Record "PWD Item Configurator";
    begin
        ItemConfigurator.RESET();
        ItemConfigurator.SETCURRENTKEY("Item Code");
        ItemConfigurator.SETRANGE("Item Code", Item."No.");
        ItemConfigurator.DELETEALL();
    end;

    [EventSubscriber(ObjectType::table, database::Item, 'OnAfterValidateEvent', 'Costing Method', false, false)]
    local procedure TAB27_OnAfterValidateEvent_Item_CostingMethod(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    var
        LotSizeStdCost: Record "PWD Lot Size Standard Cost";
    begin
        Rec.TESTFIELD(Rec."Item Category Code");
        LotSizeStdCost.FctInsertItemLine(Rec."No.", Rec."Item Category Code");
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterModifyEvent', '', false, false)]
    local procedure TAB27_OnAfterModifyEvent_Item(var Rec: Record Item; var xRec: Record Item; RunTrigger: Boolean)
    var
        ProdOrderLine: Record "Prod. Order Line";
    begin
        if not RunTrigger then
            exit;
        if Rec.IsTemporary then
            exit;
        ProdOrderLine.ItemChange(Rec, xRec);
    end;

    [EventSubscriber(ObjectType::table, database::Item, 'OnbeforeValidateEvent', 'Replenishment System', false, false)]
    local procedure TAB27_OnbeforeValidateEvent_Item_ReplenishmentSystem(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    begin
        IF Rec.TestNoEntriesExist_Cost() THEN
            IF Rec."Replenishment System" = "Replenishment System"::Purchase THEN
                Rec.VALIDATE("Costing Method", "Costing Method"::Average)
            ELSE
                Rec.VALIDATE("Costing Method", "Costing Method"::Standard);
    end;

    [EventSubscriber(ObjectType::table, database::Item, 'OnAfterValidateEvent', 'Item Category Code', false, false)]
    local procedure TAB27_OnAfterValidateEvent_Item_ItemCategoryCode(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    var
        CduClosingMgt: Codeunit "PWD Closing Management";
    begin
        CduClosingMgt.UpdtItemDimValue(DATABASE::"Item Category", Rec."No.", Rec."Item Category Code");
    end;
    //TODO: "Product Group Code" is removed
    // [EventSubscriber(ObjectType::table, database::Item, 'OnAfterValidateEvent', 'Product Group Code', false, false)]
    // local procedure TAB27_OnAfterValidateEvent_Item_ProductGroupCode(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    // var
    //     CduClosingMgt: Codeunit "PWD Closing Management";
    // begin
    //     CduClosingMgt.UpdtItemDimValue(DATABASE::"Product Group",Rec."No.",Rec."Product Group Code");
    // end;
    //---TAB36---
    [EventSubscriber(ObjectType::table, database::"Sales Header", 'OnBeforeModifyEvent', '', false, false)]
    local procedure TAB36_OnBeforeModifyEvent_SalesHeader(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; RunTrigger: Boolean)
    var
        CstG0001: Label 'Order is in Send WMS Status.';
    begin
        if not RunTrigger then
            exit;
        if Rec.IsTemporary then
            exit;
        //>>WMS-FE05.001
        IF (Rec."PWD WMS_Status" = Rec."PWD WMS_Status"::Send) AND (NOT DontExecuteIfImport) THEN   //TODO: Probleme au niveau de chargement de notre variable(DontExecuteIfImport) et l'appel de la fonction(la fonction est déclare dans l'extention de la table) 
            ERROR(CstG0001);
        //<<WMS-FE05.001
    end;

    [EventSubscriber(ObjectType::table, database::"Sales Header", 'OnAfterCopySellToCustomerAddressFieldsFromCustomer', '', false, false)]
    local procedure TAB36_OnAfterCopySellToCustomerAddressFieldsFromCustomer_SalesHeader(var SalesHeader: Record "Sales Header"; SellToCustomer: Record Customer; CurrentFieldNo: Integer; var SkipBillToContact: Boolean)
    var
        LPSAFunctionsMgt: Codeunit "PWD LPSA Functions Mgt.";
    begin
        //>>FE_LAPIERRETTE_VTE01.001: TO 07/12/2011
        SalesHeader."PWD Rolex Bienne" := SellToCustomer."PWD Rolex Bienne";
        //<<FE_LAPIERRETTE_VTE01.001: TO 07/12/2011 
        LPSAFunctionsMgt.RunPageCommentSheet(SalesHeader);
    end;

    [EventSubscriber(ObjectType::table, database::"Sales Header", 'OnAfterSetFieldsBilltoCustomer', '', false, false)]
    local procedure TAB36_OnAfterSetFieldsBilltoCustomer_SalesHeader(var SalesHeader: Record "Sales Header"; Customer: Record Customer; xSalesHeader: Record "Sales Header")
    var
        LPSAFunctionsMgt: Codeunit "PWD LPSA Functions Mgt.";
    begin
        //>>TDL.LPSA.20.04.15
        IF SalesHeader."Bill-to Customer No." <> SalesHeader."Sell-to Customer No." THEN
            LPSAFunctionsMgt.RunPageCommentSheet(SalesHeader);
        //<<TDL.LPSA.20.04.15
    end;

    [EventSubscriber(ObjectType::table, database::"Sales Header", 'OnUpdateSalesLinesByFieldNoOnAfterCalcShouldConfirmReservationDateConflict', '', false, false)]
    local procedure TAB36_OnUpdateSalesLinesByFieldNoOnAfterCalcShouldConfirmReservationDateConflict_SalesHeader(var SalesHeader: Record "Sales Header"; ChangedFieldNo: Integer; var ShouldConfirmReservationDateConflict: Boolean)
    begin
        ShouldConfirmReservationDateConflict := ChangedFieldNo in [SalesHeader.FieldNo(SalesHeader."Shipment Date")];
    end;

    [EventSubscriber(ObjectType::table, database::"Sales Header", 'OnUpdateSalesLineByChangedFieldName', '', false, false)]
    local procedure TAB36_OOnUpdateSalesLineByChangedFieldName_SalesHeader(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; ChangedFieldName: Text[100]; ChangedFieldNo: Integer)
    begin
        case ChangedFieldNo of
            SalesHeader.FieldNo("Requested Delivery Date"):
                iF SalesLine."No." <> '' THEN begin
                    //>>TDL.LPSA.17.05.15:NBO
                    IF SalesLine."Promised Delivery Date" = 0D THEN
                        SalesLine.VALIDATE("Promised Delivery Date", SalesHeader."Requested Delivery Date");
                    IF SalesLine."PWD Cust Promised Delivery Date" = 0D THEN
                        SalesLine.VALIDATE("PWD Cust Promised Delivery Date", SalesHeader."Requested Delivery Date");
                    IF SalesLine."PWD Initial Shipment Date" = 0D THEN BEGIN
                        SalesLine.VALIDATE("Planned Delivery Date", SalesHeader."Requested Delivery Date");
                        SalesLine.VALIDATE("Planned Shipment Date", SalesHeader."Requested Delivery Date");
                        SalesLine.VALIDATE("PWD Initial Shipment Date", SalesHeader."Requested Delivery Date");
                        SalesLine.VALIDATE("Shipment Date", SalesHeader."Requested Delivery Date");
                    END;
                END;
            //>>TDL.LPSA.20.04.15
            SalesHeader.FieldNo("PWD Cust Promised Delivery Date"):
                IF SalesLine."No." <> '' THEN
                    SalesLine.VALIDATE("PWD Cust Promised Delivery Date", SalesHeader."PWD Cust Promised Delivery Date");
        //<<TDL.LPSA.20.04.15
        //<<TDL.LPSA.17.05.15:NBO
        end;
    end;

    //---TAB37---
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeModifyEvent', '', false, false)]
    local procedure TAB37_OnBeforeModifyEvent_SalesLine(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; RunTrigger: Boolean)
    begin
        if not RunTrigger then
            exit;
        if Rec.IsTemporary then
            exit;
        IF NOT BooGFromImport THEN
            xRec.TESTFIELD("PWD WMS_Status", Rec."PWD WMS_Status"::" ");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnValidateNoOnCopyFromTempSalesLine', '', false, false)]
    local procedure TAB37_OnValidateNoOnCopyFromTempSalesLine_SalesLine(var SalesLine: Record "Sales Line"; var TempSalesLine: Record "Sales Line" temporary; xSalesLine: Record "Sales Line")
    begin
        SalesLine.Position := TempSalesLine.Position;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnValidateNoOnBeforeUpdateDates', '', false, false)]
    local procedure TAB37_OnValidateNoOnBeforeUpdateDates_SalesLine(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; CallingFieldNo: Integer; var IsHandled: Boolean; var TempSalesLine: Record "Sales Line" temporary)
    var
        FunctionsMgt: Codeunit "PWD LPSA Functions Mgt.";
    begin
        FunctionsMgt.Fct_OnValidateNoOnBeforeUpdateDates_SalesLine(SalesLine, SalesHeader);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterAssignStdTxtValues', '', false, false)]
    local procedure TAB37_OnAfterAssignStdTxtValues_SalesLine(var SalesLine: Record "Sales Line"; StandardText: Record "Standard Text")
    begin
        SalesLine."PWD LPSA Description 1" := StandardText.Description;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterAssignGLAccountValues', '', false, false)]
    local procedure TAB37_OnAfterAssignGLAccountValues_SalesLine(var SalesLine: Record "Sales Line"; GLAccount: Record "G/L Account")
    begin
        SalesLine."PWD LPSA Description 1" := GLAccount.Name;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnCopyFromItemOnAfterCheck', '', false, false)]
    local procedure TAB37_OnCopyFromItemOnAfterCheck_SalesLine(var SalesLine: Record "Sales Line"; Item: Record Item)
    begin
        SalesLine."PWD LPSA Description 1" := Item."PWD LPSA Description 1";
        SalesLine."PWD LPSA Description 2" := Item."PWD LPSA Description 2";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterAssignResourceValues', '', false, false)]
    local procedure TAB37_OnAfterAssignResourceValues_SalesLine(var SalesLine: Record "Sales Line"; Resource: Record Resource)
    begin
        SalesLine."PWD LPSA Description 1" := Resource.Name;
        SalesLine."PWD LPSA Description 2" := Resource."Name 2";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterAssignFixedAssetValues', '', false, false)]
    local procedure TAB37_OnAfterAssignFixedAssetValues_SalesLine(var SalesLine: Record "Sales Line"; FixedAsset: Record "Fixed Asset")
    begin
        SalesLine."PWD LPSA Description 1" := FixedAsset.Description;
        SalesLine."PWD LPSA Description 2" := FixedAsset."Description 2";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterAssignItemChargeValues', '', false, false)]
    local procedure TAB37_OnAfterAssignItemChargeValues_SalesLine(var SalesLine: Record "Sales Line"; ItemCharge: Record "Item Charge")
    begin
        SalesLine."PWD LPSA Description 1" := ItemCharge.Description;
    end;

    [EventSubscriber(ObjectType::table, database::"Sales Line", 'OnAfterValidateEvent', 'Shipment Date', false, false)]
    local procedure TAB37_OnAfterValidateEvent_SalesLine(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        Rec."Planned Delivery Date" := Rec."Shipment Date";
        Rec."Planned Shipment Date" := Rec."Shipment Date";
    end;

    [EventSubscriber(ObjectType::table, database::"Sales Line", 'OnAfterValidateEvent', 'Description', false, false)]
    local procedure TAB37_OnAfterValidateEvent_SalesLine_Description(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        IF Rec."PWD LPSA Description 1" = '' THEN
            Rec."PWD LPSA Description 1" := Rec.Description;
    end;

    [EventSubscriber(ObjectType::table, database::"Sales Line", 'OnAfterValidateEvent', 'Description 2', false, false)]
    local procedure TAB37_OnAfterValidateEvent_SalesLine_Description2(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        IF Rec."PWD LPSA Description 2" = '' THEN
            Rec."PWD LPSA Description 2" := Rec."Description 2";
    end;

    [EventSubscriber(ObjectType::table, database::"Sales Line", 'OnAfterValidateEvent', 'Promised Delivery Date', false, false)]
    local procedure TAB37_OnAfterValidateEvent_SalesLine_PromisedDeliveryDate(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        IF Rec."Promised Delivery Date" = 0D THEN
            Rec.VALIDATE(Rec."Requested Delivery Date");
    end;

    [EventSubscriber(ObjectType::table, database::"Sales Line", 'OnAfterValidateEvent', 'Planned Delivery Date', false, false)]
    local procedure TAB37_OnAfterValidateEvent_SalesLine_PlannedDeliveryDate(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        Rec."Shipment Date" := Rec."Planned Delivery Date";
        Rec."Planned Shipment Date" := Rec."Planned Delivery Date";
    end;

    [EventSubscriber(ObjectType::table, database::"Sales Line", 'OnBeforeUpdateDates', '', false, false)]
    local procedure TAB37_OnBeforeUpdateDates_SalesLine(var SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
        // IsHandled := true; //TODO : A vérifier CurrFieldNo ne fonctionne pas
        // if CurrFieldNo = 0 then begin
        //     PlannedShipmentDateCalculated := false;
        //     PlannedDeliveryDateCalculated := false;
        // end;
    end;

    [EventSubscriber(ObjectType::table, database::"Sales Line", 'OnAfterSetDefaultQuantity', '', false, false)]
    local procedure TAB37_OnAfterSetDefaultQuantity_SalesLine(var SalesLine: Record "Sales Line"; var xSalesLine: Record "Sales Line")
    begin
        SalesLine.FctDefaultQuantityIfWMS();
    end;
    //---TAB38---
    [EventSubscriber(ObjectType::table, database::"Purchase Header", 'OnAfterCopyBuyFromVendorAddressFieldsFromVendor', '', false, false)]
    local procedure Tab38_OnAfterCopyBuyFromVendorAddressFieldsFromVendor_PurchaseHeader(var PurchaseHeader: Record "Purchase Header"; BuyFromVendor: Record Vendor)
    begin
        //>>FE_LAPIERRETTE_ACH03.001
        IF PurchaseHeader."Document Type" IN [PurchaseHeader."Document Type"::Order] THEN
            PurchaseHeader."PWD Order Min. Amount" := BuyFromVendor."PWD Order Min. Amount";
        //<<FE_LAPIERRETTE_ACH03.001
    end;
    //---TAB39---
    [EventSubscriber(ObjectType::table, database::"Purchase Line", 'OnBeforeModifyEvent', '', false, false)]
    local procedure TAB39_OnBeforeModifyEvent_PurchaseLine(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line"; RunTrigger: Boolean)
    begin
        if not RunTrigger then
            exit;
        if Rec.IsTemporary then
            exit;
        //>>WMS-EBL1-003.001
        IF NOT BooGFromImport THEN
            //<<WMS-EBL1-003.001
            //>>WMS-FE04.001
            xRec.TESTFIELD("PWD WMS_Status", Rec."PWD WMS_Status"::" "); //TODO: Probleme au niveau de chargement de notre variable(BooGFromImport) et l'appel de la fonction(la fonction est déclare dans l'extention de la table)
        //<<WMS-FE04.001
    end;

    [EventSubscriber(ObjectType::table, database::"Purchase Line", 'OnAfterAssignStdTxtValues', '', false, false)]
    local procedure TAB39_OnAfterAssignStdTxtValues_PurchaseLine(var PurchLine: Record "Purchase Line"; StandardText: Record "Standard Text")
    begin
        //>>FE_LAPIERRETTE_ART02.001
        PurchLine."PWD LPSA Description 1" := StandardText.Description;
        //<<FE_LAPIERRETTE_ART02.001
    end;

    [EventSubscriber(ObjectType::table, database::"Purchase Line", 'OnAfterAssignGLAccountValues', '', false, false)]
    local procedure TAB39_OnAfterAssignGLAccountValues_PurchaseLine(var PurchLine: Record "Purchase Line"; GLAccount: Record "G/L Account")
    begin
        //>>FE_LAPIERRETTE_ART02.001
        PurchLine."PWD LPSA Description 1" := GLAccount.Name;
        //<<FE_LAPIERRETTE_ART02.001
    end;

    [EventSubscriber(ObjectType::table, database::"Purchase Line", 'OnAfterAssignItemValues', '', false, false)]
    local procedure TAB39_OnAfterAssignItemValues_PurchaseLine(var PurchLine: Record "Purchase Line"; Item: Record Item; CurrentFieldNo: Integer)
    begin
        //>>FE_LAPIERRETTE_ART02.001
        PurchLine."PWD LPSA Description 1" := Item."PWD LPSA Description 1";
        PurchLine."PWD LPSA Description 2" := Item."PWD LPSA Description 2";
        //<<FE_LAPIERRETTE_ART02.001
    end;

    [EventSubscriber(ObjectType::table, database::"Purchase Line", 'OnAfterAssignFixedAssetValues', '', false, false)]
    local procedure TAB39_OnAfterAssignFixedAssetValues_PurchaseLine(var PurchLine: Record "Purchase Line"; FixedAsset: Record "Fixed Asset")
    begin
        //>>FE_LAPIERRETTE_ART02.001
        PurchLine."PWD LPSA Description 1" := FixedAsset.Description;
        PurchLine."PWD LPSA Description 2" := FixedAsset."Description 2";
        //<<FE_LAPIERRETTE_ART02.001
    end;

    [EventSubscriber(ObjectType::table, database::"Purchase Line", 'OnAfterAssignItemChargeValues', '', false, false)]
    local procedure TAB39_OOnAfterAssignItemChargeValues_PurchaseLine(var PurchLine: Record "Purchase Line"; ItemCharge: Record "Item Charge")
    begin
        //>>FE_LAPIERRETTE_ART02.001
        PurchLine."PWD LPSA Description 1" := ItemCharge.Description;
        //<<FE_LAPIERRETTE_ART02.001
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateEvent', 'Description', false, false)]
    local procedure TAB39_OnAfterValidateEvent_PurchaseLine(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line"; CurrFieldNo: Integer)
    begin
        //>>FE_LAPIERRETTE_ART02.001
        IF Rec."PWD LPSA Description 1" = '' THEN
            Rec."PWD LPSA Description 1" := Rec.Description;
        //<<FE_LAPIERRETTE_ART02.001
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateEvent', 'Description 2', false, false)]
    local procedure TAB39_OnAfterValidateEvent_PurchaseLine_(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line"; CurrFieldNo: Integer)
    begin
        //>>FE_LAPIERRETTE_ART02.001
        IF Rec."PWD LPSA Description 2" = '' THEN
            Rec."PWD LPSA Description 2" := Rec.Description;
        //<<FE_LAPIERRETTE_ART02.001
    end;

    [EventSubscriber(ObjectType::table, database::"Purchase Line", 'OnAfterSetDefaultQuantity', '', false, false)]
    local procedure TAB39_OnAfterSetDefaultQuantity_PurchaseLine(var PurchLine: Record "Purchase Line"; var xPurchLine: Record "Purchase Line")
    begin
        //>>WMS-FE007_15.001
        PurchLine.FctDefaultQuantityIfWMS();
        //<<WMS-FE007_15.001
    end;
    //---TAB83---
    [EventSubscriber(ObjectType::table, database::"Item Journal Line", 'OnValidateItemNoOnBeforeSetDescription', '', false, false)]
    local procedure TAB83_OnValidateItemNoOnBeforeSetDescription_ItemJournalLine(var ItemJournalLine: Record "Item Journal Line"; Item: Record Item)
    begin
        Item.TESTFIELD("PWD Phantom Item", FALSE);
    end;

    [EventSubscriber(ObjectType::table, database::"Item Journal Line", 'OnAfterCopyFromWorkCenter', '', false, false)]
    local procedure TAB83_OnAfterCopyFromWorkCenter_ItemJournalLine(var ItemJournalLine: Record "Item Journal Line"; WorkCenter: Record "Work Center")
    var
        ManufSetup: Record "Manufacturing Setup";
    //RecLProdOrderLine: Record "Prod. Order Line";
    begin
        ManufSetup.GET();
        IF ItemJournalLine."Work Center No." = ManufSetup."Mach. center - Inventory input" THEN
            ItemJournalLine.VALIDATE("Location Code", ManufSetup."Non conformity Prod. Location")
        ELSE
            //TODO: A vérifier le champ "Prod. Order No." devient "Order No." et le champ"Prod. Order Line No." devient " Order Line No."
            ItemJournalLine.VALIDATE("Location Code", ItemJournalLine.FctGetProdOrderLine(ItemJournalLine."Order No.", ItemJournalLine."Order Line No."));
    end;
    //---TAB111---
    [EventSubscriber(ObjectType::table, database::"Sales Shipment Line", 'OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine', '', false, false)]
    local procedure TAB111_OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine_SalesShptLine(var SalesShptLine: Record "Sales Shipment Line"; var SalesLine: Record "Sales Line"; var NextLineNo: Integer; var Handled: Boolean; TempSalesLine: Record "Sales Line" temporary; SalesInvHeader: Record "Sales Header")
    var
        Text92000: Label 'Shipment No. %1 of %2:';
        SalesShptHeader: Record "Sales Shipment Header";
    begin
        //>>FE_LAPIERRETTE_ART02.001
        SalesShptHeader.Get(SalesShptLine."Document No.");
        SalesLine."PWD LPSA Description 1" := STRSUBSTNO(Text92000, SalesShptLine."Document No.", SalesShptHeader."Shipment Date");
        //<<FE_LAPIERRETTE_ART02.001
    end;

    [EventSubscriber(ObjectType::table, database::"Sales Shipment Line", 'OnBeforeInsertInvLineFromShptLine', '', false, false)]
    local procedure TAB111_OnBeforeInsertInvLineFromShptLine_SalesShptLine(var SalesShptLine: Record "Sales Shipment Line"; var SalesLine: Record "Sales Line"; SalesOrderLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
        //>>FE_LAPIERRETTE_ART02.001
        SalesLine."PWD LPSA Description 1" := SalesShptLine."PWD LPSA Description 1";
        SalesLine."PWD LPSA Description 2" := SalesShptLine."PWD LPSA Description 2";
        //<<FE_LAPIERRETTE_ART02.001
    end;
    //---TAB204---
    [EventSubscriber(ObjectType::table, database::"Unit of Measure", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure TAB204_OnBeforeDeleteEvent_UnitofMeasure(var Rec: Record "Unit of Measure"; RunTrigger: Boolean)
    var
    // ApplicationManagement: Codeunit 1; //TODO: Cette fonction utilise le codeUnit 1
    // PlannerOneSetup: Record 8076502; //TODO: La table 8076502 n'existe pas 
    // Text001: Label 'The time base unit for PlannerOne cannot be deleted.';
    begin
        // // PLAW12.0 Prevent deletion of Time Base Unit
        // // PLAW12.2 Check LICENSE
        // IF ApplicationManagement.CheckPlannerOneLicence THEN
        //     IF (PlannerOneSetup.FINDFIRST() AND (PlannerOneSetup.TimeBaseUnit = Rec.Code)) THEN
        //         ERROR(Text001);
        // // PLAW12.0 End
    end;


    //---TAB121---
    [EventSubscriber(ObjectType::table, database::"Purch. Rcpt. Line", 'OnBeforeInsertInvLineFromRcptLineBeforeInsertTextLine', '', false, false)]
    local procedure TAB121_OnBeforeInsertInvLineFromRcptLineBeforeInsertTextLine_PurchRcptLine(var PurchRcptLine: Record "Purch. Rcpt. Line"; var PurchLine: Record "Purchase Line"; var NextLineNo: Integer; var Handled: Boolean)
    var
        Text000: Label 'Receipt No. %1:';
    begin
        PurchLine."PWD LPSA Description 1" := STRSUBSTNO(Text000, PurchRcptLine."Document No.");
    end;

    [EventSubscriber(ObjectType::table, database::"Purch. Rcpt. Line", 'OnBeforeInsertInvLineFromRcptLine', '', false, false)]
    local procedure TAB121_OnBeforeInsertInvLineFromRcptLine_PurchRcptLine(var PurchRcptLine: Record "Purch. Rcpt. Line"; var PurchLine: Record "Purchase Line"; PurchOrderLine: Record "Purchase Line"; var IsHandled: Boolean)
    begin
        PurchLine."PWD LPSA Description 1" := PurchRcptLine."PWD LPSA Description 1";
        PurchLine."PWD LPSA Description 2" := PurchRcptLine."PWD LPSA Description 2";
    end;
    //---TAB246---
    [EventSubscriber(ObjectType::table, database::"Requisition Line", 'OnAfterValidateEvent', 'Routing No.', false, false)]
    local procedure TAB246_OnAfterValidateEvent_RequisitionLine_RoutingNo(var Rec: Record "Requisition Line"; var xRec: Record "Requisition Line"; CurrFieldNo: Integer)
    begin
        //TODO: champ PlanningGroup n'existe pas car a un table relation avec la table PlannerOnePlanningGroup
        //Rec.PlanningGroup := RoutingHeader.PlanningGroup;
    end;
    //---TAB5404---
    [EventSubscriber(ObjectType::Table, Database::"Item Unit of Measure", 'OnAfterModifyEvent', '', false, false)]
    local procedure TAB5404_OnAfterModifyEvent_ItemUnitofMeasure(var Rec: Record "Item Unit of Measure"; var xRec: Record "Item Unit of Measure"; RunTrigger: Boolean)
    var
        OSYSSetup: Record "PWD OSYS Setup";
    begin
        if not RunTrigger then
            exit;
        if Rec.IsTemporary then
            exit;
        OSYSSetup.FctUnitOfMeasureModify(xRec, Rec);
    end;

    //---TAB205---
    [EventSubscriber(ObjectType::table, database::"Resource Unit of Measure", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure TAB205_OnBeforeDeleteEvent_ResourceUnitOfMeasure(var Rec: Record "Resource Unit of Measure"; RunTrigger: Boolean)
    var
    // PlannerOneSetup: Record 8076502;  //TODO: La table 8076502 n'existe pas 
    // Text001: Label 'Deleting this unit will remove the resource from PlannerOne. Do you confirm deletion?;'
    // ApplicationManagement: Codeunit 1;  //TODO: Cette fonction utilise le codeUnit 1
    begin
        // PLAW12.0 Confirm deletion of time base unit
        // PLAW12.2 Check LICENSE
        // IF ApplicationManagement.CheckPlannerOneLicence THEN
        //     IF (PlannerOneSetup.FINDFIRST() AND (PlannerOneSetup.TimeBaseUnit = Rec.Code)) THEN
        //         IF NOT (CONFIRM(Text001)) THEN
        //             ERROR('');
        // PLAW12.0 End
    end;

    [EventSubscriber(ObjectType::Table, Database::"Resource Unit of Measure", 'OnAfterValidateEvent', 'Related to Base Unit of Meas.', false, false)]
    local procedure TAB205_OnAfterValidateEvent_ResourceUnitOfMeasure_(var Rec: Record "Resource Unit of Measure"; var xRec: Record "Resource Unit of Measure"; CurrFieldNo: Integer)
    var
    // PlannerOneSetup: Record 8076502;  //TODO: La table 8076502 n'existe pas 
    // ApplicationManagement: Codeunit 1;  //TODO: Cette fonction utilise le codeUnit 1
    // Text002: Label 'If the unit %1 does not convert to the base unit, the resource will be removed from PlannerOne. Do you wish to continue?;'
    begin
        // PLAW12.0 Confirm convertibility of time base unit
        // PLAW12.2 Check LICENSE
        // IF ApplicationManagement.CheckPlannerOneLicence THEN
        //     IF (PlannerOneSetup.FINDFIRST() AND (PlannerOneSetup.TimeBaseUnit = Rec.Code)) THEN
        //         IF (xRec."Related to Base Unit of Meas." <> Rec."Related to Base Unit of Meas.")
        //           AND (Rec."Related to Base Unit of Meas." = FALSE) THEN
        //             IF NOT (CONFIRM(Text002, FALSE, Rec.Code)) THEN
        //                 ERROR('');
        // PLAW12.0 End
    end;
    //---TAB5722---
    [EventSubscriber(ObjectType::Table, Database::"Item Category", 'OnAfterInsertEvent', '', false, false)]
    local procedure TAB5722_OnAfterInsertEvent_ItemCategory(var Rec: Record "Item Category"; RunTrigger: Boolean)
    var
        CduGClosingMgt: Codeunit "PWD Closing Management";
    begin
        if not RunTrigger then
            exit;
        if Rec.IsTemporary then
            exit;
        //>>P24578_008.001
        CduGClosingMgt.UpdateDimValue(DATABASE::"Item Category", Rec.Code, Rec.Description);
        //<<P24578_008.001
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Category", 'OnAfterModifyEvent', '', false, false)]
    local procedure TAB5722_OnAfterModifyEvent_ItemCategory(var Rec: Record "Item Category"; RunTrigger: Boolean)
    var
        CduGClosingMgt: Codeunit "PWD Closing Management";
    begin
        if not RunTrigger then
            exit;
        if Rec.IsTemporary then
            exit;
        //>>P24578_008.001
        CduGClosingMgt.UpdateDimValue(DATABASE::"Item Category", Rec.Code, Rec.Description);
        //<<P24578_008.001
    end;
    //---TAB5723---
    // [EventSubscriber(ObjectType::Table, Database::"Product Group", 'OnAfterInsertEvent', '', false, false)] //TODO: La table "Product Group" n'exist pas(Propriété : ObsoleteState = Removed;) 
    // local procedure TAB5723_OnAfterInsertEvent_ProductGroup(var Rec: Record "Product Group"; RunTrigger: Boolean)
    // var
    //     CduGClosingMgt: Codeunit "PWD Closing Management";
    // begin
    //     if not RunTrigger then
    //         exit;
    //     if Rec.IsTemporary then
    //         exit;
    //     //>>P24578_008.001
    //     CduGClosingMgt.UpdateDimValue(DATABASE::"Product Group", Rec.Code, Rec.Description);
    //     //<<P24578_008.001
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Product Group", 'OnAfterModifyEvent', '', false, false)]  //TODO: La table "Product Group" n'exist pas(Propriété : ObsoleteState = Removed;) 
    // local procedure TAB5723_OnAfterModifyEvent_ProductGroup(var Rec: Record "Product Group"; RunTrigger: Boolean)
    // var
    //     CduGClosingMgt: Codeunit 50004;
    // begin
    //     if not RunTrigger then
    //         exit;
    //     if Rec.IsTemporary then
    //         exit;
    //     //>>P24578_008.001
    //     CduGClosingMgt.UpdateDimValue(DATABASE::"Product Group", Rec.Code, Rec.Description);
    //     //<<P24578_008.001
    // end;

    //---TAB5741---
    [EventSubscriber(ObjectType::Table, Database::"Transfer Line", 'OnAfterValidateEvent', 'Description', false, false)]
    local procedure TAB5741_OnAfterValidateEvent_TransferLine(var Rec: Record "Transfer Line"; var xRec: Record "Transfer Line"; CurrFieldNo: Integer)
    begin
        //>>FE_LAPIERRETTE_ART02.001
        IF Rec."PWD LPSA Description 1" = '' THEN
            Rec."PWD LPSA Description 1" := Rec.Description;
        //<<FE_LAPIERRETTE_ART02.001
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Line", 'OnAfterValidateEvent', 'Description 2', false, false)]
    local procedure TAB5741_OnAfterValidateEvent_TransferLine_(var Rec: Record "Transfer Line"; var xRec: Record "Transfer Line"; CurrFieldNo: Integer)
    begin
        //>>FE_LAPIERRETTE_ART02.001
        IF Rec."PWD LPSA Description 2" = '' THEN
            Rec."PWD LPSA Description 2" := Rec."Description 2";
        //<<FE_LAPIERRETTE_ART02.001
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Line", 'OnAfterValidateEvent', 'PWD LPSA Description 1', false, false)]
    local procedure TAB5741_OnAfterValidateEvent_TransferLine_LPSA_D1(var Rec: Record "Transfer Line"; var xRec: Record "Transfer Line"; CurrFieldNo: Integer)
    begin
        //>>FE_LAPIERRETTE_ART02.001
        IF STRLEN(Rec."PWD LPSA Description 1") > 50 THEN
            Rec.Description := PADSTR(Rec."PWD LPSA Description 1", 50)
        ELSE
            Rec.Description := Rec."PWD LPSA Description 1";
        //<<FE_LAPIERRETTE_ART02.001
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Line", 'OnAfterValidateEvent', 'PWD LPSA Description 2', false, false)]
    local procedure TAB5741_OnAfterValidateEvent_TransferLine_LPSA_D2(var Rec: Record "Transfer Line"; var xRec: Record "Transfer Line"; CurrFieldNo: Integer)
    begin
        //>>FE_LAPIERRETTE_ART02.001
        IF STRLEN(Rec."PWD LPSA Description 2") > 50 THEN
            Rec."Description 2" := PADSTR(Rec."PWD LPSA Description 2", 50)
        ELSE
            Rec."Description 2" := Rec."PWD LPSA Description 2";
        //<<FE_LAPIERRETTE_ART02.001
    end;
    //---TAB5405---
    [EventSubscriber(ObjectType::Table, Database::"Production Order", 'OnBeforeAssignItemNo', '', false, false)]
    local procedure TAB5405_OnBeforeAssignItemNo_ProductionOrder(var ProdOrder: Record "Production Order"; xProdOrder: Record "Production Order"; var Item: Record Item; CallingFieldNo: Integer)
    begin
        ProdOrder."Search Description" := Item."Search Description";
    end;
    //---TAB5406---
    [EventSubscriber(ObjectType::Table, Database::"Prod. Order Line", 'OnAfterModifyEvent', '', false, false)]
    local procedure TAB5406_OnAfterModifyEvent_ProdOrderLine(var Rec: Record "Prod. Order Line"; var xRec: Record "Prod. Order Line"; RunTrigger: Boolean)
    begin
        if not RunTrigger then
            exit;
        if Rec.IsTemporary then
            exit;
        IF Rec.Status = Rec.Status::Released THEN BEGIN
            Rec.ResendProdOrdertoQuartis();
            Rec.FctUpdateDelay();
        END;
        IF Rec.Status = Rec.Status::"Firm Planned" THEN
            Rec.FctUpdateDelay();
    end;

    [EventSubscriber(ObjectType::table, database::"Prod. Order Line", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure TAB5406_OnBeforeDeleteEvent_ProdOrderLine(var Rec: Record "Prod. Order Line"; RunTrigger: Boolean)
    var
        Text000: Label 'A %1 %2 cannot be inserted, modified, or deleted.';
        Text99000000: Label 'You cannot delete %1 %2 because there is at least one %3 associated with it.', Comment = '%1 = Table Caption; %2 = Field Value; %3 = Table Caption';
        ItemLedgEntry: Record "Item Ledger Entry";
        CapLedgEntry: Record "Capacity Ledger Entry";
        PurchLine: Record "Purchase Line";
        CduFunctionsMgt: Codeunit "PWD LPSA Functions Mgt.";
    begin
        if not RunTrigger then
            exit;
        if Rec.IsTemporary then
            exit;
        if Rec.Status = Rec.Status::Finished then
            Error(Text000, Rec.Status, Rec.TableCaption);
        Rec.FctCreateDeleteProdOrderLine();
    end;
    //---TAB5407---
    [EventSubscriber(ObjectType::Table, Database::"Prod. Order Component", 'OnAfterInsertEvent', '', false, false)]
    local procedure TAB5407_OnAfterInsertEvent_ProdOrderComponent(var Rec: Record "Prod. Order Component"; RunTrigger: Boolean)
    var
        ProdOrder: Record "Production Order";
        LotInheritanceMgt: Codeunit "PWD Lot Inheritance Mgt.PW";
    begin
        if not RunTrigger then
            exit;
        if Rec.IsTemporary then
            exit;
        LotInheritanceMgt.CheckPOCompOnInsert(Rec);
        IF ProdOrder.GET(ProdOrder.Status, Rec."Prod. Order No.") THEN
            IF ProdOrder."PWD Component No." = '' THEN BEGIN
                ProdOrder."PWD Component No." := Rec."Item No.";
                ProdOrder.MODIFY();
            END;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Prod. Order Component", 'OnValidateItemNoOnAfterUpdateUOMFromItem', '', false, false)]
    local procedure TAB5407_OnValidateItemNoOnAfterUpdateUOMFromItem_ProdOrderComponent(var ProdOrderComponent: Record "Prod. Order Component"; xProdOrderComponent: Record "Prod. Order Component"; Item: Record Item)
    begin
        ProdOrderComponent."PWD Lot Determining" := Item."PWD Lot Determining";

        IF ProdOrderComponent.Status = ProdOrderComponent.Status::Released THEN
            Item.TESTFIELD("PWD Phantom Item", FALSE);
    end;
    //---TAB5409---
    [EventSubscriber(ObjectType::Table, Database::"Prod. Order Routing Line", 'OnAfterModifyEvent', '', false, false)]
    local procedure TAB5409_OnAfterModifyEvent_ProdOrderRoutingLine(var Rec: Record "Prod. Order Routing Line"; var xRec: Record "Prod. Order Routing Line"; RunTrigger: Boolean)
    var
        ProdOrderLine: Record "Prod. Order Line";
    begin
        if not RunTrigger then
            exit;
        if Rec.IsTemporary then
            exit;
        //TODO: CheckAlternate utilise la table PlannerOneProdOrdRoutLineAlt et le codeunit 1
        //Rec.CheckAlternate();
        Rec.CalculateRoutingLine();
        IF (Rec.Status = Rec.Status::Released) AND (ProdOrderLine.GET(Rec.Status, Rec."Prod. Order No.", Rec."Routing Reference No.")) THEN
            ProdOrderLine.ResendProdOrdertoQuartis();
    end;
    //---TAB5411---
    [EventSubscriber(ObjectType::table, database::"Prod. Order Routing Tool", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure TAB5411_OnAfterValidateEvent_ProdOrderRoutingTool_No(var Rec: Record "Prod. Order Routing Tool"; var xRec: Record "Prod. Order Routing Tool"; CurrFieldNo: Integer)
    var
        ToolsInstructions: Record "PWD Tools Instructions";
        Item: Record Item;
    begin
        CASE Rec."PWD Type" OF
            Rec."PWD Type"::Method, Rec."PWD Type"::Quality, Rec."PWD Type"::Plan, Rec."PWD Type"::Zone, Rec."PWD Type"::"Targeted dimension":
                BEGIN
                    ToolsInstructions.GET(Rec."PWD Type", Rec."No.");
                    Rec.Description := ToolsInstructions.Description;
                    Rec."PWD Criteria" := ToolsInstructions.Criteria;
                END;
            Rec."PWD Type"::Item:
                BEGIN
                    Item.GET(Rec."No.");
                    Rec.Description := COPYSTR(Item."PWD LPSA Description 1", 1, 50);
                END;
        END;
    end;
    //---TAB6651---
    [EventSubscriber(ObjectType::Table, Database::"Return Shipment Line", 'OnInsertInvLineFromRetShptLineOnBeforePurchLineInsert', '', false, false)]
    local procedure TAB6651_OnInsertInvLineFromRetShptLineOnBeforePurchLineInsert_ReturnShipmentLine(var ReturnShipmentLine: Record "Return Shipment Line"; var PurchaseLine: Record "Purchase Line"; var NextLineNo: Integer; var IsHandled: Boolean)
    var
        Text000: Label 'Return Shipment No. %1:';
    begin
        //>>FE_LAPIERRETTE_ART02.001
        PurchaseLine."PWD LPSA Description 1" := STRSUBSTNO(Text000, ReturnShipmentLine."Document No.");
        //<<FE_LAPIERRETTE_ART02.001
    end;

    [EventSubscriber(ObjectType::Table, Database::"Return Shipment Line", 'OnInsertInvLineFromRetShptLineOnBeforeClearLineNumbers', '', false, false)]
    local procedure TAB6651_OnInsertInvLineFromRetShptLineOnBeforeClearLineNumbers_ReturnShipmentLine(var ReturnShipmentLine: Record "Return Shipment Line"; var PurchLine: Record "Purchase Line"; var NextLineNo: Integer; var TempPurchLine: Record "Purchase Line" temporary)
    begin
        //>>FE_LAPIERRETTE_ART02.001
        PurchLine."PWD LPSA Description 1" := ReturnShipmentLine."PWD LPSA Description 1";
        PurchLine."PWD LPSA Description 2" := ReturnShipmentLine."PWD LPSA Description 2";
        //<<FE_LAPIERRETTE_ART02.001
    end;
    //---TAB6661---
    [EventSubscriber(ObjectType::Table, Database::"Return Receipt Line", 'OnBeforeInsertInvLineFromRetRcptLineBeforeInsertTextLine', '', false, false)]
    local procedure TAB6661_OnBeforeInsertInvLineFromRetRcptLineBeforeInsertTextLine_ReturnReceiptLine(var ReturnReceiptLine: Record "Return Receipt Line"; var SalesLine: Record "Sales Line"; var NextLineNo: Integer; var IsHandled: Boolean)
    var
        Text000: Label 'Return Receipt No. %1:';
    begin
        //>>FE_LAPIERRETTE_ART02.001
        SalesLine."PWD LPSA Description 1" := STRSUBSTNO(Text000, ReturnReceiptLine."Document No.");
        //<<FE_LAPIERRETTE_ART02.001
    end;

    [EventSubscriber(ObjectType::Table, Database::"Return Receipt Line", 'OnBeforeInsertInvLineFromRetRcptLine', '', false, false)]
    local procedure TAB6661_OnBeforeInsertInvLineFromRetRcptLine_ReturnReceiptLine(var SalesLine: Record "Sales Line"; SalesOrderLine: Record "Sales Line"; var ReturnReceiptLine: Record "Return Receipt Line"; var IsHandled: Boolean)
    begin
        //>>FE_LAPIERRETTE_ART02.001
        SalesLine."PWD LPSA Description 1" := ReturnReceiptLine."PWD LPSA Description 1";
        SalesLine."PWD LPSA Description 2" := ReturnReceiptLine."PWD LPSA Description 2";
        //<<FE_LAPIERRETTE_ART02.001
    end;
    //---TAB7317--
    [EventSubscriber(ObjectType::table, database::"Warehouse Receipt Line", 'OnAfterValidateEvent', 'Description', false, false)]
    local procedure TAB7317_OnAfterValidateEvent_WarehouseReceiptLine_Description(var Rec: Record "Warehouse Receipt Line"; var xRec: Record "Warehouse Receipt Line"; CurrFieldNo: Integer)
    begin
        //>>FE_LAPIERRETTE_ART02.001
        IF Rec."PWD LPSA Description 1" = '' THEN
            Rec."PWD LPSA Description 1" := Rec.Description;
        //<<FE_LAPIERRETTE_ART02.001
    end;

    [EventSubscriber(ObjectType::table, database::"Warehouse Receipt Line", 'OnAfterValidateEvent', 'Description 2', false, false)]
    local procedure TAB7317_OnAfterValidateEvent_WarehouseReceiptLine_Description2(var Rec: Record "Warehouse Receipt Line"; var xRec: Record "Warehouse Receipt Line"; CurrFieldNo: Integer)
    begin
        //>>FE_LAPIERRETTE_ART02.001
        IF Rec."PWD LPSA Description 2" = '' THEN
            Rec."PWD LPSA Description 2" := Rec."Description 2";
        //<<FE_LAPIERRETTE_ART02.001
    end;
    //---CDU22--
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnPostOutputOnAfterUpdateProdOrderLine', '', false, false)]
    local procedure CDU22_OnPostOutputOnAfterUpdateProdOrderLine_ItemJnlPostLine(var ItemJournalLine: Record "Item Journal Line"; var WhseJnlLine: Record "Warehouse Journal Line"; var GlobalItemLedgEntry: Record "Item Ledger Entry");
    var
        PWDLPSAFunctionsMgt: Codeunit "PWD LPSA Functions Mgt.";
        ProdOrderLine: Record "Prod. Order Line";
    begin
        //>>FE_PROD01.002
        ProdOrderLine.Get(ProdOrderLine.Status::Released, ItemJournalLine."Order No.", ItemJournalLine."Order Line No.");
        PWDLPSAFunctionsMgt.UpdateNextLevelProdLine(ProdOrderLine, ItemJournalLine."Lot No.");
        //<<FE_PROD01.002
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnPostItemOnBeforeCheckInventoryPostingGroup', '', false, false)]
    local procedure CDU22_OnPostItemOnBeforeCheckInventoryPostingGroup_ItemJnlPostLine(var ItemJnlLine: Record "Item Journal Line"; var CalledFromAdjustment: Boolean; var Item: Record Item; var ItemTrackingCode: Record "Item Tracking Code")
    begin
        // >>FE_LAPRIERRETTE_GP0003
        Item.TESTFIELD("PWD Phantom Item", FALSE);
        // <<FE_LAPRIERRETTE_GP0003
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertCapLedgEntry', '', false, false)]
    local procedure CDU22_OnBeforeInsertCapLedgEntry_ItemJnlPostLine(var CapLedgEntry: Record "Capacity Ledger Entry"; ItemJournalLine: Record "Item Journal Line")
    begin
        //>>FE_LAPIERRETTE_PROD02.001
        CapLedgEntry."PWD Quartis Comment" := ItemJournalLine."PWD Quartis Comment";
        //<<FE_LAPIERRETTE_PROD02.001
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', false, false)]
    local procedure CDU22_OnAfterInitItemLedgEntry_ItemJnlPostLine(var NewItemLedgEntry: Record "Item Ledger Entry"; var ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer)
    begin
        //>>FE_LAPIERRETTE_PRO12.001
        IF NOT (ItemJournalLine."PWD Conform quality control") THEN
            NewItemLedgEntry.VALIDATE("PWD NC", TRUE);
        //<<FE_LAPIERRETTE_PRO12.001
    end;
    //---CDU241--
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post", 'OnCodeOnBeforeItemJnlPostBatchRun', '', false, false)]
    local procedure CDU241_OnCodeOnBeforeItemJnlPostBatchRun_ItemJnlPost(var ItemJournalLine: Record "Item Journal Line")
    var
        "PWDLPSAFunctionsMgt.": Codeunit "PWD LPSA Functions Mgt.";
    begin
        //>>FE_PROD01.001
        "PWDLPSAFunctionsMgt.".FctRecreateJournalLine(ItemJournalLine);
        //<<FE_PROD01.001
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post", 'OnCodeOnAfterItemJnlPostBatchRun', '', false, false)]
    local procedure CDU241_OnCodeOnAfterItemJnlPostBatchRun_ItemJnlPost(var ItemJournalLine: Record "Item Journal Line"; var HideDialog: Boolean; SuppressCommit: Boolean)
    var
        "PWDLPSAFunctionsMgt.": Codeunit "PWD LPSA Functions Mgt.";
    begin
        //>>LAP2.08
        "PWDLPSAFunctionsMgt.".ClearWrongReservEntries(ItemJournalLine);
        //<<LAP2.08 
    end;
    //---CDU313--
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Printed", 'OnBeforeModify', '', false, false)]
    local procedure CDU313_OnBeforeModify_SalesPrinted(var SalesHeader: Record "Sales Header")
    begin
        //>>FE_LAPIERRETTE_VTE06.001
        SalesHeader."PWD ConfirmedLPSA" := TRUE;
        //<<FE_LAPIERRETTE_VTE06.001

        //>>TDL.LPSA.01.06.15:APA
        IF SalesHeader."PWD Print confirmation Date" = 0D THEN
            SalesHeader."PWD Print confirmation Date" := TODAY;
        //<<TDL.LPSA.01.06.15:APA
    end;
    //---CDU317--
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.Header-Printed", 'OnBeforeModify', '', false, false)]
    local procedure CDU317_OnBeforeModify_PurchHeaderPrinted(var PurchaseHeader: Record "Purchase Header")
    begin
        //>>TDL.LPSA.20.04.2015
        IF (NOT PurchaseHeader."PWD Printed") THEN
            PurchaseHeader."PWD Printed" := TRUE;
        //<<TDL.LPSA.20.04.2015 
    end;
    //---CDU333--
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Wksh.-Make Order", 'OnAfterInitPurchOrderLine', '', false, false)]
    local procedure CDU333_OnAfterInitPurchOrderLine_ReqWkshMakeOrder(var PurchaseLine: Record "Purchase Line"; RequisitionLine: Record "Requisition Line")
    begin
        //>>TDL.LPSA.001
        IF RequisitionLine."Prod. Order No." <> '' THEN
            PurchaseLine.Description := RequisitionLine."Prod. Order No.";
        //<<TDL.LPSA.001
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Wksh.-Make Order", 'OnFinalizeOrderHeaderOnAfterSetFiltersForNonRecurringReqLine', '', false, false)]
    local procedure CDU333_OOnFinalizeOrderHeaderOnAfterSetFiltersForNonRecurringReqLine_ReqWkshMakeOrder(var RequisitionLine: Record "Requisition Line"; PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    var
        CduLReleasePurchOrder: Codeunit "Release Purchase Document";
        ReqWkshMakeOrder: Codeunit "Req. Wksh.-Make Order";
    begin
        if not IsHandled then
            if RequisitionLine.FindSet then begin
                repeat
                    if ReqWkshMakeOrder.PurchaseOrderLineMatchReqLine(RequisitionLine) then begin
                        //>>FE_LAPIERRETTE_NDT01.001
                        //IF ReqLine2."Prod. Order No." <> '' THEN BEGIN
                        // Release Order
                        CduLReleasePurchOrder.RUN(PurchaseHeader);
                        //END;
                        //<<FE_LAPIERRETTE_NDT01.001  
                    end;
                until RequisitionLine.Next() = 0;
            end;
    end;
    //---CDU391--
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Shipment Header - Edit", 'OnBeforeSalesShptHeaderModify', '', false, false)]
    local procedure CDU391_OnBeforeSalesShptHeaderModify_ShipmentHeaderEdit(var SalesShptHeader: Record "Sales Shipment Header"; FromSalesShptHeader: Record "Sales Shipment Header")
    begin
        //>>TDL.LPSA.30.07.15:NBO
        SalesShptHeader."Ship-to Contact" := FromSalesShptHeader."Ship-to Contact";
        //<<TDL.LPSA.30.07.15:NBO
    end;
    //---CDU414--
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnCodeOnAfterCheckCustomerCreated', '', false, false)]
    local procedure CDU414_OnCodeOnAfterCheckCustomerCreated_ReleaseSalesDocument(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; var IsHandled: Boolean)
    var
        SalesLine: Record "Sales Line";
    begin
        //>>TDL.LPSA.001 19/01/2014
        IF SalesHeader."Document Type" = SalesHeader."Document Type"::Order THEN BEGIN
            //>>TDL.LPSA.20.04.15
            IF SalesHeader."PWD Cust Promised Delivery Date" = 0D THEN
                SalesHeader."PWD Cust Promised Delivery Date" := SalesHeader."Shipment Date";
            //<<TDL.LPSA.20.04.15
            SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
            SalesLine.SETRANGE("Document No.", SalesHeader."No.");
            SalesLine.SETRANGE(Type, SalesLine.Type::Item);
            SalesLine.SETFILTER(Quantity, '<>0');
            IF SalesLine.FINDFIRST THEN
                REPEAT
                    IF SalesLine."PWD Initial Shipment Date" = 0D THEN BEGIN
                        SalesLine."PWD Initial Shipment Date" := SalesLine."Shipment Date";
                        SalesLine.MODIFY;
                    END;
                    //>>TDL.LPSA.20.04.15
                    IF SalesLine."PWD Cust Promised Delivery Date" = 0D THEN BEGIN
                        SalesLine."PWD Cust Promised Delivery Date" := SalesLine."Planned Delivery Date";
                        SalesLine.MODIFY;
                    END;
                //<<TDL.LPSA.20.04.15
                UNTIL SalesLine.NEXT = 0;
            SalesLine.RESET;
        END;
        //<<TDL.LPSA.001 19/01/2014

        //---CDU99000854---
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Inventory Profile Offsetting", 'OnBeforeCreateSupply', '', false, false)]
    local procedure CDU99000854_OnBeforeCreateSupply_InventoryProfileOffsetting(var SupplyInvtProfile: Record "Inventory Profile"; var DemandInvtProfile: Record "Inventory Profile")
    var
        FunctionsMgt: Codeunit "PWD LPSA Functions Mgt.";
    begin
        FunctionsMgt.Fct_OnBeforeCreateSupply_InventoryProfileOffsetting(SupplyInvtProfile, DemandInvtProfile);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Inventory Profile Offsetting", 'OnMaintainPlanningLineOnBeforeAdjustPlanLine', '', false, false)]
    local procedure CDU99000854_OnMaintainPlanningLineOnBeforeAdjustPlanLine_InventoryProfileOffsetting(var RequisitionLine: Record "Requisition Line"; InventoryProfile: Record "Inventory Profile"; StockkeepingUnit: Record "Stockkeeping Unit")
    begin
        //TODO: table extension "Inventory Profile" n'exsiste pas
        RequisitionLine."PWD Original Source Id" := InventoryProfile."Original Source Id";
        RequisitionLine."PWD Original Source No." := InventoryProfile."Original Source No.";
        RequisitionLine."PWD Original Source Position" := InventoryProfile."Original Source Position";
        RequisitionLine."PWD Original Counter" := InventoryProfile."Original Counter";
        RequisitionLine."PWD Transmitted Order No." := InventoryProfile."Transmitted Order No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Inventory Profile Offsetting", 'OnAfterTransferAttributes', '', false, false)]
    local procedure CDU99000854_OnAfterTransferAttributes_InventoryProfileOffsetting(var ToInventoryProfile: Record "Inventory Profile"; var FromInventoryProfile: Record "Inventory Profile"; var TempSKU: Record "Stockkeeping Unit" temporary; SpecificLotTracking: Boolean; SpecificSNTracking: Boolean)
    begin
        //TODO: table extension "Inventory Profile" n'exsiste pas
        ToInventoryProfile."Original Source Id" := FromInventoryProfile."Original Source Id";
        ToInventoryProfile."Original Source No." := FromInventoryProfile."Original Source No.";
        ToInventoryProfile."Original Source Position" := FromInventoryProfile."Original Source Position";
        ToInventoryProfile."Original Counter" := FromInventoryProfile."Original Counter";
        ToInventoryProfile."Transmitted Order No." := FromInventoryProfile."Transmitted Order No.";
        IF ((ToInventoryProfile."Transmitted Order No." = TRUE) AND (ToInvProfile."Original Source Id" = 5407)) THEN
            ToInventoryProfile."Original Counter" := Fct_CalcCounter(ToInventoryProfile."Original Source No.", ToInventoryProfile."Original Source Position");
    end;
    //---CDU99000840---
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Plng. Component-Reserve", 'OnAfterCallItemTracking', '', false, false)]
    local procedure CDU99000840_OnAfterCallItemTracking_PlngComponentReserve(var PlanningComponent: Record "Planning Component")
    var
        ReqLine: Record "Requisition Line";
        cuLotInheritanceMgt: Codeunit "PWD Lot Inheritance Mgt.PW";
    begin
        //TODO: table extension "Planning Component" n'exsiste pas
        IF PlanningComponent."Lot Determining" THEN BEGIN
            ReqLine.GET(
              PlanningComponent."Worksheet Template Name",
              PlanningComponent."Worksheet Batch Name",
              PlanningComponent."Worksheet Line No.");
            cuLotInheritanceMgt.AutoCreatePlanLineTracking(ReqLine);
        END;
    end;

    //---CDU99000837---
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Prod. Order Line-Reserve", 'OnCallItemTrackingOnBeforeItemTrackingLinesRunModal', '', false, false)]
    local procedure CDU99000837_OnCallItemTrackingOnBeforeItemTrackingLinesRunModal_ProdOrderLineReserve(var ProdOrderLine: Record "Prod. Order Line"; var ItemTrackingLines: Page "Item Tracking Lines")
    var
        LotInheritanceMgt: Codeunit "PWD Lot Inheritance Mgt.PW";
        Item: Record Item;
        TxtG001: label 'You cannot set Lot No on item %1. Lot No is set by a component.';
    begin
        Item.GET(ProdOrderLine."Item No.");
        IF LotInheritanceMgt.CheckItemDetermined(Item) THEN
            MESSAGE(STRSUBSTNO(TxtG001, Item."No."));
        //ItemTrackingForm.EDITABLE := FALSE;
    end;
    //---CDU99000813---
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Carry Out Action", 'OnProdOrderChgAndResheduleOnAfterValidateQuantity', '', false, false)]
    local procedure CDU99000813_OnProdOrderChgAndResheduleOnAfterValidateQuantity_CarryOutAction(var ProdOrderLine: Record "Prod. Order Line"; var RequisitionLine: Record "Requisition Line")
    begin
        //TODO: "End Date Objective" and "Earliest Start Date" does not exist
        // ProdOrderLine.VALIDATE("End Date Objective", 0DT);
        // ProdOrderLine.VALIDATE("Earliest Start Date", 0D);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Carry Out Action", 'OnInsertProdOrderOnAfterProdOrderInsert', '', false, false)]
    local procedure CDU99000813_OnInsertProdOrderOnAfterProdOrderInsert_CarryOutAction(var ProdOrder: Record "Production Order"; ReqLine: Record "Requisition Line")
    var
        Item: Record Item;
    begin
        Item.Get(ReqLine."No.");
        ProdOrder."Search Description" := Item."Search Description";
        //TODO: 'Record "Production Order"' does not contain a definition for 'End Date Objective'
        // ProdOrder."End Date Objective" := CREATEDATETIME(ProdOrder."Ending Date", ProdOrder."Ending Time");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Carry Out Action", 'OnAfterTransferPlanningComp', '', false, false)]
    local procedure CDU99000813_OnAfterTransferPlanningComp_CarryOutAction(var PlanningComponent: Record "Planning Component"; var ProdOrderComponent: Record "Prod. Order Component")
    begin
        //TODO: table extension "Planning Component" n'exsiste pas
        ProdOrderComponent."PWD Lot Determining" := PlanningComponent."Lot Determining";
    end;
    //---CDU99000809---
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Planning Line Management", 'OnBeforeInsertAsmPlanningComponent', '', false, false)]
    local procedure CDU99000809_OnBeforeInsertAsmPlanningComponent_PlanningLineManagement(var ReqLine: Record "Requisition Line"; var BOMComponent: Record "BOM Component"; var PlanningComponent: Record "Planning Component")
    begin
        //TODO: Level?
        PlanningComponent."Lot Determining" := BOMComponent[Level]."Lot Determining";
    end;

    var
        DontExecuteIfImport: Boolean;
        BooGFromImport: Boolean;
}