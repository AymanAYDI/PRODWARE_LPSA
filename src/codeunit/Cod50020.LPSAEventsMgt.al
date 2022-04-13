codeunit 50020 "PWD LPSA Events Mgt."
{
    SingleInstance = true;
    //---TAB27---
    [EventSubscriber(ObjectType::table, database::Item, 'OnAfterDeleteRelatedData', '', false, false)]
    local procedure TAB27_OnAfterDeleteRelatedData_Item(Item: Record Item)
    var
        ItemConfigurator: Record "PWD Item Configurator";
    begin
        ItemConfigurator.RESET;
        ItemConfigurator.SETCURRENTKEY("Item Code");
        ItemConfigurator.SETRANGE("Item Code", Item."No.");
        ItemConfigurator.DELETEALL;
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
        IF Rec.TestNoEntriesExist_Cost THEN
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
        IF SalesHeader."Bill-to Customer No." <> SalesHeader."Sell-to Customer No." THEN BEGIN
            LPSAFunctionsMgt.RunPageCommentSheet(SalesHeader);
        END;
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
    var
        PlannedShipmentDateCalculated: Boolean;
        PlannedDeliveryDateCalculated: Boolean;
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
        ManufSetup.GET;
        IF ItemJournalLine."Work Center No." = ManufSetup."Mach. center - Inventory input" THEN
            ItemJournalLine.VALIDATE("Location Code", ManufSetup."Non conformity Prod. Location")
        ELSE
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
        if not RunTrigger then
            exit;
        if Rec.IsTemporary then
            exit;
        // // PLAW12.0 Prevent deletion of Time Base Unit
        // // PLAW12.2 Check LICENSE
        // IF ApplicationManagement.CheckPlannerOneLicence THEN
        //     IF (PlannerOneSetup.FINDFIRST() AND (PlannerOneSetup.TimeBaseUnit = Rec.Code)) THEN
        //         ERROR(Text001);
        // // PLAW12.0 End
    end;
    //---TAB205---
    [EventSubscriber(ObjectType::table, database::"Resource Unit of Measure", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure TAB205_OnBeforeDeleteEvent_ResourceUnitOfMeasure(var Rec: Record "Resource Unit of Measure"; RunTrigger: Boolean)
    var
    // PlannerOneSetup: Record 8076502;  //TODO: La table 8076502 n'existe pas 
    // Text001: Label 'ENU=Deleting this unit will remove the resource from PlannerOne. Do you confirm deletion?;'
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
    // Text002: Label 'ENU=If the unit %1 does not convert to the base unit, the resource will be removed from PlannerOne. Do you wish to continue?;'
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

    [EventSubscriber(ObjectType::Table, Database::"Transfer Line", 'OnAfterValidateEvent', 'Description 2', false, false)]
    local procedure TAB5741_OnAfterValidateEvent_TransferLine_LPSA_D1(var Rec: Record "Transfer Line"; var xRec: Record "Transfer Line"; CurrFieldNo: Integer)
    begin
        //>>FE_LAPIERRETTE_ART02.001
        IF STRLEN(Rec."PWD LPSA Description 1") > 50 THEN
            Rec.Description := PADSTR(Rec."PWD LPSA Description 1", 50)
        ELSE
            Rec.Description := Rec."PWD LPSA Description 1";
        //<<FE_LAPIERRETTE_ART02.001
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Line", 'OnAfterValidateEvent', 'Description 2', false, false)]
    local procedure TAB5741_OnAfterValidateEvent_TransferLine_LPSA_D2(var Rec: Record "Transfer Line"; var xRec: Record "Transfer Line"; CurrFieldNo: Integer)
    begin
        //>>FE_LAPIERRETTE_ART02.001
        IF STRLEN(Rec."PWD LPSA Description 2") > 50 THEN
            Rec."Description 2" := PADSTR(Rec."PWD LPSA Description 2", 50)
        ELSE
            Rec."Description 2" := Rec."PWD LPSA Description 2";
        //<<FE_LAPIERRETTE_ART02.001
    end;


    var
        DontExecuteIfImport: Boolean;
        BooGFromImport: Boolean;
}