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
        ProductGrp: Record "PWD Product Group";
        CduClosingMgt: Codeunit "PWD Closing Management";
    begin
        CduClosingMgt.UpdtItemDimValue(DATABASE::"Item Category", Rec."No.", Rec."Item Category Code");
        IF Rec."Item Category Code" <> xRec."Item Category Code" THEN
            IF NOT ProductGrp.GET(Rec."Item Category Code", Rec."PWD Product Group Code") THEN
                Rec.VALIDATE("PWD Product Group Code", '')
            ELSE
                Rec.VALIDATE("PWD Product Group Code");
    end;

    [EventSubscriber(ObjectType::table, database::Item, 'OnAfterValidateEvent', 'PWD Product Group Code', false, false)]
    local procedure TAB27_OnAfterValidateEvent_Item_ProductGroupCode(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    var
        CduClosingMgt: Codeunit "PWD Closing Management";
    begin
        CduClosingMgt.UpdtItemDimValue(DATABASE::"PWD Product Group", Rec."No.", Rec."PWD Product Group Code");
    end;
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
        IF (Rec."PWD WMS_Status" = Rec."PWD WMS_Status"::Send) /*AND (NOT DontExecuteIfImport)*/ THEN
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
                    IF SalesLine."PWD Cust Promis. Delivery Date" = 0D THEN
                        SalesLine.VALIDATE("PWD Cust Promis. Delivery Date", SalesHeader."Requested Delivery Date");
                    IF SalesLine."PWD Initial Shipment Date" = 0D THEN BEGIN
                        SalesLine.VALIDATE("Planned Delivery Date", SalesHeader."Requested Delivery Date");
                        SalesLine.VALIDATE("Planned Shipment Date", SalesHeader."Requested Delivery Date");
                        SalesLine.VALIDATE("PWD Initial Shipment Date", SalesHeader."Requested Delivery Date");
                        SalesLine.VALIDATE("Shipment Date", SalesHeader."Requested Delivery Date");
                    END;
                END;
            //>>TDL.LPSA.20.04.15
            SalesHeader.FieldNo("PWD Cust Promised Deliv. Date"):
                IF SalesLine."No." <> '' THEN
                    SalesLine.VALIDATE("PWD Cust Promis. Delivery Date", SalesHeader."PWD Cust Promised Deliv. Date");
        //<<TDL.LPSA.20.04.15
        //<<TDL.LPSA.17.05.15:NBO
        end;
    end;

    //---TAB37---
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeModifyEvent', '', false, false)]
    local procedure TAB37_OnBeforeModifyEvent_SalesLine(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; RunTrigger: Boolean)
    Var
        LPSASetGetFunctions: Codeunit "PWD LPSA Set/Get Functions.";
    begin
        if not RunTrigger then
            exit;
        if Rec.IsTemporary then
            exit;
        IF NOT LPSASetGetFunctions.GetFctFromImportSaleLine() THEN
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
        SalesLine."PWD Product Group Code" := Item."PWD Product Group Code";
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
        if Rec."Requested Delivery Date" <> 0D then begin
            IF Rec."Planned Shipment Date" > Rec."Planned Delivery Date" THEN
                Rec."Planned Delivery Date" := Rec."Planned Shipment Date";
            //inter support temporaire
            Rec."Shipment Date" := xRec."Shipment Date";
            Rec."Planned Shipment Date" := xRec."Planned Shipment Date";
            IF Rec."Promised Delivery Date" = 0D THEN
                Rec.VALIDATE(Rec."Requested Delivery Date");
        end;
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
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::table, database::"Sales Line", 'OnUpdateUnitPriceOnBeforeFindPrice', '', false, false)]
    local procedure TAB37_OnUpdateUnitPriceOnBeforeFindPrice_SalesLine(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; CalledByFieldNo: Integer; CallingFieldNo: Integer; var IsHandled: Boolean)
    begin
        IF SalesHeader."PWD ConfirmedLPSA" THEN
            IsHandled := true;
    end;

    [EventSubscriber(ObjectType::table, database::"Sales Line", 'OnAfterSetDefaultQuantity', '', false, false)]
    local procedure TAB37_OnAfterSetDefaultQuantity_SalesLine(var SalesLine: Record "Sales Line"; var xSalesLine: Record "Sales Line")
    begin
        SalesLine.FctDefaultQuantityIfWMS();
    end;

    [EventSubscriber(ObjectType::table, database::"Sales Line", 'OnAfterUpdateUnitPrice', '', false, false)]
    local procedure TAB37_OnAfterUpdateUnitPrice_SalesLine(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line"; CalledByFieldNo: Integer; CurrFieldNo: Integer)
    begin
        //>>FE_LAPIERRETTE_VTE03.001
        IF (SalesLine."pwd Fixed Price") AND (SalesLine.Quantity <> 0) THEN
            SalesLine.VALIDATE(SalesLine."Line Amount", SalesLine."Unit Price");
        //<<FE_LAPIERRETTE_VTE03.001
    end;

    [EventSubscriber(ObjectType::table, database::"Sales Line", 'OnValidateNoOnBeforeCalcShipmentDateForLocation', '', false, false)]
    local procedure TAB37_OnValidateNoOnBeforeCalcShipmentDateForLocation_SalesLine(var IsHandled: Boolean; var SalesLine: Record "Sales Line")
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::table, database::"Sales Line", 'OnBeforeValidatePlannedDeliveryDate', '', false, false)]
    local procedure TAB37_OnBeforeValidatePlannedDeliveryDate_SalesLine(var IsHandled: Boolean; var SalesLine: Record "Sales Line")
    Var
        LPSASetGetFunctions: codeunit "PWD LPSA Set/Get Functions.";
    begin
        IsHandled := true;
        //if not LPSASetGetFunctions.GetValidatePlannedDeliveryDate() then begin
        SalesLine.TestStatusOpen();
        if SalesLine."Planned Delivery Date" <> 0D then begin
            if SalesLine."Planned Shipment Date" > SalesLine."Planned Delivery Date" then
                SalesLine."Planned Delivery Date" := SalesLine."Planned Shipment Date";
            //inter support temporaire
            SalesLine."Shipment Date" := SalesLine."Planned Delivery Date";
            SalesLine."Planned Shipment Date" := SalesLine."Planned Delivery Date";
            //inter support temporaire
        end;

        //end
    end;

    [EventSubscriber(ObjectType::table, database::"Sales Line", 'OnAfterValidateEvent', 'Requested Delivery Date', false, false)]
    local procedure TAB37_OnAfterValidateEvent_SalesLine_RequestedDeliveryDate(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        if Rec."Requested Delivery Date" <> 0D then begin
            IF Rec."Planned Shipment Date" > Rec."Planned Delivery Date" THEN
                Rec."Planned Delivery Date" := Rec."Planned Shipment Date";
            //inter support temporaire
            Rec."Shipment Date" := xRec."Shipment Date";
            Rec."Planned Shipment Date" := xRec."Planned Shipment Date";
        end
        else begin
            //inter support temporaire
            Rec."Planned Delivery Date" := xRec."Planned Delivery Date";
            Rec."Planned Shipment Date" := xRec."Planned Shipment Date";
            //inter support temporaire
        end;
    end;

    [EventSubscriber(ObjectType::table, database::"Sales Line", 'OnBeforeValidatePlannedShipmentDate', '', false, false)]
    local procedure TAB37_OnBeforeValidatePlannedShipmentDate_SalesLine(var IsHandled: Boolean; var SalesLine: Record "Sales Line")
    begin
        IsHandled := true;
        SalesLine.TestStatusOpen();
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
    var
        "PWDLPSASet/GetFunctions": Codeunit "PWD LPSA Set/Get Functions.";
    begin
        if not RunTrigger then
            exit;
        if Rec.IsTemporary then
            exit;
        //>>WMS-EBL1-003.001
        IF NOT "PWDLPSASet/GetFunctions".GetFctFromImport() THEN
            //<<WMS-EBL1-003.001
            //>>WMS-FE04.001
            xRec.TESTFIELD("PWD WMS_Status", Rec."PWD WMS_Status"::" ");
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

    [EventSubscriber(ObjectType::table, database::"Purchase Line", 'OnCopyFromItemOnAfterCheck', '', false, false)]
    local procedure TAB39_OnCopyFromItemOnAfterCheck_PurchaseLine(PurchaseLine: Record "Purchase Line"; Item: Record Item; CallingFieldNo: Integer)
    begin
        PurchaseLine."PWD Product Group Code" := Item."PWD Product Group Code";
    end;

    //---TAB83---
    [EventSubscriber(ObjectType::table, database::"Item Journal Line", 'OnValidateItemNoOnBeforeSetDescription', '', false, false)]
    local procedure TAB83_OnValidateItemNoOnBeforeSetDescription_ItemJournalLine(var ItemJournalLine: Record "Item Journal Line"; Item: Record Item)
    begin
        Item.TESTFIELD("PWD Phantom Item", FALSE);
        ItemJournalLine."PWD Product Group Code" := Item."PWD Product Group Code";
    end;

    [EventSubscriber(ObjectType::table, database::"Item Journal Line", 'OnAfterCopyFromWorkCenter', '', false, false)]
    local procedure TAB83_OnAfterCopyFromWorkCenter_ItemJournalLine(var ItemJournalLine: Record "Item Journal Line"; WorkCenter: Record "Work Center")
    var
        ManufSetup: Record "Manufacturing Setup";
    //RecLProdOrderLine: Record "Prod. Order Line";
    begin
        ManufSetup.GET();
        IF ItemJournalLine."Work Center No." = ManufSetup."PWD Mach. center-Invent. input" THEN
            ItemJournalLine.VALIDATE("Location Code", ManufSetup."PWD Non conformity Prod. Loca.")
        ELSE
            ItemJournalLine.VALIDATE("Location Code", ItemJournalLine.FctGetProdOrderLine(ItemJournalLine."Order No.", ItemJournalLine."Order Line No."));
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromSalesLine', '', false, false)]
    local procedure TAB83_OnAfterCopyItemJnlLineFromSalesLine_ItemJournalLine(var ItemJnlLine: Record "Item Journal Line"; SalesLine: Record "Sales Line")
    begin
        ItemJnlLine."PWD Product Group Code" := SalesLine."PWD Product Group Code";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromServShptLine', '', false, false)]
    local procedure TAB83_OnAfterCopyItemJnlLineFromServShptLine_ItemJournalLine(var ItemJnlLine: Record "Item Journal Line"; ServShptLine: Record "Service Shipment Line")
    begin
        ItemJnlLine."PWD Product Group Code" := ServShptLine."PWD Product Group Code";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromServLine', '', false, false)]
    local procedure TAB83_OnAfterCopyItemJnlLineFromServLine_ItemJournalLine(var ItemJnlLine: Record "Item Journal Line"; ServLine: Record "Service Line")
    begin
        ItemJnlLine."PWD Product Group Code" := ServLine."PWD Product Group Code";
    end;
    //---TAB111---
    [EventSubscriber(ObjectType::table, database::"Sales Shipment Line", 'OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine', '', false, false)]
    local procedure TAB111_OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine_SalesShptLine(var SalesShptLine: Record "Sales Shipment Line"; var SalesLine: Record "Sales Line"; var NextLineNo: Integer; var Handled: Boolean; TempSalesLine: Record "Sales Line" temporary; SalesInvHeader: Record "Sales Header")
    var
        SalesShptHeader: Record "Sales Shipment Header";
        Text92000: Label 'Shipment No. %1 of %2:';
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
    [EventSubscriber(ObjectType::table, database::"Requisition Line", 'OnAfterCopyFromItem', '', false, false)]
    local procedure TAB246_OnAfterCopyFromItem_RequisitionLine(var RequisitionLine: Record "Requisition Line"; Item: Record Item)
    begin
        RequisitionLine."PWD Product Group Code" := Item."PWD Product Group Code";
    end;
    //---TAB753---
    [EventSubscriber(ObjectType::table, database::"Standard Item Journal Line", 'OnValidateItemNoOnAfterCopyItemValues', '', false, false)]
    local procedure TAB753_OnValidateItemNoOnAfterCopyItemValues_StandardItemJournalLine(var StandardItemJournalLine: Record "Standard Item Journal Line"; Item: Record Item)
    begin
        StandardItemJournalLine."PWD Product Group Code" := Item."PWD Product Group Code";
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

    [EventSubscriber(ObjectType::Table, Database::"Transfer Line", 'OnAfterAssignItemValues', '', false, false)]
    local procedure TAB5741_OnAfterAssignItemValues_TransferLine(var TransferLine: Record "Transfer Line"; Item: Record Item)
    begin
        TransferLine."PWD Product Group Code" := Item."PWD Product Group Code";
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
        IF Rec.Status = Rec.Status::Released THEN
            Rec.ResendProdOrdertoQuartis();
        //Rec.FctUpdateDelay();
        //IF Rec.Status = Rec.Status::"Firm Planned" THEN
        //Rec.FctUpdateDelay();
    end;

    [EventSubscriber(ObjectType::table, database::"Prod. Order Line", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure TAB5406_OnBeforeDeleteEvent_ProdOrderLine(var Rec: Record "Prod. Order Line"; RunTrigger: Boolean)
    var
        Text000: Label 'A %1 %2 cannot be inserted, modified, or deleted.';
    begin
        if not RunTrigger then
            exit;
        if Rec.IsTemporary then
            exit;
        if Rec.Status = Rec.Status::Finished then
            Error(Text000, Rec.Status, Rec.TableCaption);
        Rec.FctCreateDeleteProdOrderLine();
    end;

    [EventSubscriber(ObjectType::table, database::"Prod. Order Line", 'OnValidateItemNoOnAfterAssignItemValues', '', false, false)]
    local procedure TAB5406_OnValidateItemNoOnAfterAssignItemValues_ProdOrderLine(var ProdOrderLine: Record "Prod. Order Line"; Item: Record Item)
    begin
        //PLAW11.0 : calculate earliest start date
        //ProdOrderLine.VALIDATE("PWD Earliest Start Date", 0D);
        //PLAW11.0 END
        //PLAW12.0 End Date Objective
        ProdOrderLine.UpdateDatetime();
        //ProdOrderLine.VALIDATE("PWD End Date Objective", 0DT);
        //PLAW12.0 END
        //IF routing.GET(ProdOrderLine."Routing No.") THEN
        //ProdOrderLine."PWD PlanningGroup" := routing."PWD PlanningGroup";
        //PLAW12.1 END
        //>>LAP2.10
        ProdOrderLine."PWD Manufacturing Code" := Item."PWD Manufacturing Code";
        //<<LAP2.10
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
    //---TAB5411---
    [EventSubscriber(ObjectType::table, database::"Prod. Order Routing Tool", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure TAB5411_OnAfterValidateEvent_ProdOrderRoutingTool_No(var Rec: Record "Prod. Order Routing Tool"; var xRec: Record "Prod. Order Routing Tool"; CurrFieldNo: Integer)
    var
        Item: Record Item;
        ToolsInstructions: Record "PWD Tools Instructions";
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
    //---TAB5902---
    [EventSubscriber(ObjectType::table, database::"Service Line", 'OnAfterAssignItemValues', '', false, false)]
    local procedure TAB5902_OnAfterAssignItemValues_ServiceLine(var ServiceLine: Record "Service Line"; Item: Record Item; xServiceLine: Record "Service Line"; CallingFieldNo: Integer; ServiceHeader: Record "Service Header")
    begin
        ServiceLine."PWD Product Group Code" := Item."PWD Product Group Code";
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
        ProdOrderLine: Record "Prod. Order Line";
        PWDLPSAFunctionsMgt: Codeunit "PWD LPSA Functions Mgt.";
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
        NewItemLedgEntry."PWD Product Group Code" := ItemJournalLine."PWD Product Group Code";
    end;
    //---CDU80---
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', false, false)]
    local procedure CDU80_OnBeforePostSalesDoc(var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var HideProgressWindow: Boolean)
    BEGIN
        IF Not GUIALLOWED THEN
            HideProgressWindow := true;
    END;
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
            if RequisitionLine.FindSet() then
                repeat
                    if ReqWkshMakeOrder.PurchaseOrderLineMatchReqLine(RequisitionLine) then
                        //>>FE_LAPIERRETTE_NDT01.001
                        //IF ReqLine2."Prod. Order No." <> '' THEN BEGIN
                        // Release Order
                        CduLReleasePurchOrder.RUN(PurchaseHeader);
                //END;
                //<<FE_LAPIERRETTE_NDT01.001  
                until RequisitionLine.Next() = 0;
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
            IF SalesHeader."PWD Cust Promised Deliv. Date" = 0D THEN
                SalesHeader."PWD Cust Promised Deliv. Date" := SalesHeader."Shipment Date";
            //<<TDL.LPSA.20.04.15
            SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
            SalesLine.SETRANGE("Document No.", SalesHeader."No.");
            SalesLine.SETRANGE(Type, SalesLine.Type::Item);
            SalesLine.SETFILTER(Quantity, '<>0');
            IF SalesLine.FindSet() THEN
                REPEAT
                    IF SalesLine."PWD Initial Shipment Date" = 0D THEN BEGIN
                        SalesLine."PWD Initial Shipment Date" := SalesLine."Shipment Date";
                        SalesLine.MODIFY();
                    END;
                    //>>TDL.LPSA.20.04.15
                    IF SalesLine."PWD Cust Promis. Delivery Date" = 0D THEN BEGIN
                        SalesLine."PWD Cust Promis. Delivery Date" := SalesLine."Planned Delivery Date";
                        SalesLine.MODIFY();
                    END;
                //<<TDL.LPSA.20.04.15
                UNTIL SalesLine.NEXT() = 0;
            SalesLine.RESET();
        END;
        //<<TDL.LPSA.001 19/01/2014
    end;
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
        RequisitionLine."PWD Original Source Id" := InventoryProfile."PWD Original Source Id";
        RequisitionLine."PWD Original Source No." := InventoryProfile."PWD Original Source No.";
        RequisitionLine."PWD Original Source Position" := InventoryProfile."PWD Original Source Position";
        RequisitionLine."PWD Original Counter" := InventoryProfile."PWD Original Counter";
        RequisitionLine."PWD Transmitted Order No." := InventoryProfile."PWD Transmitted Order No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Inventory Profile Offsetting", 'OnAfterTransferAttributes', '', false, false)]
    local procedure CDU99000854_OnAfterTransferAttributes_InventoryProfileOffsetting(var ToInventoryProfile: Record "Inventory Profile"; var FromInventoryProfile: Record "Inventory Profile"; var TempSKU: Record "Stockkeeping Unit" temporary; SpecificLotTracking: Boolean; SpecificSNTracking: Boolean)
    var
        LPSAFunctionsMgt: Codeunit "PWD LPSA Functions Mgt.";
    begin
        ToInventoryProfile."PWD Original Source Id" := FromInventoryProfile."PWD Original Source Id";
        ToInventoryProfile."PWD Original Source No." := FromInventoryProfile."PWD Original Source No.";
        ToInventoryProfile."PWD Original Source Position" := FromInventoryProfile."PWD Original Source Position";
        ToInventoryProfile."PWD Original Counter" := FromInventoryProfile."PWD Original Counter";
        ToInventoryProfile."PWD Transmitted Order No." := FromInventoryProfile."PWD Transmitted Order No.";
        IF ((ToInventoryProfile."PWD Transmitted Order No." = TRUE) AND (ToInventoryProfile."PWD Original Source Id" = 5407)) THEN
            ToInventoryProfile."PWD Original Counter" := LPSAFunctionsMgt.Fct_CalcCounter(ToInventoryProfile."PWD Original Source No.", ToInventoryProfile."PWD Original Source Position");
    end;
    //---CDU99000840---
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Plng. Component-Reserve", 'OnAfterCallItemTracking', '', false, false)]
    local procedure CDU99000840_OnAfterCallItemTracking_PlngComponentReserve(var PlanningComponent: Record "Planning Component")
    var
        ReqLine: Record "Requisition Line";
        cuLotInheritanceMgt: Codeunit "PWD Lot Inheritance Mgt.PW";
    begin
        IF PlanningComponent."PWD Lot Determining" THEN BEGIN
            ReqLine.GET(
              PlanningComponent."Worksheet Template Name",
              PlanningComponent."Worksheet Batch Name",
              PlanningComponent."Worksheet Line No.");
            cuLotInheritanceMgt.AutoCreatePlanLineTracking(ReqLine);
        END;
    end;
    //---CDU99000845---
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Management", 'OnAfterSetReservSource', '', false, false)]
    local procedure CDU99000845_OnAfterSetReservSource_ReservationManagement(var SourceRecRef: RecordRef; var CalcReservEntry: Record "Reservation Entry"; var Direction: Enum "Transfer Direction")
    var
        LPSASetGetFunctions: codeunit "PWD LPSA Set/Get Functions.";
    begin
        LPSASetGetFunctions.SetSourceRecRef(SourceRecRef);
        LPSASetGetFunctions.SetCalcReservEntry(CalcReservEntry);
    end;

    //---CDU99000837---
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Prod. Order Line-Reserve", 'OnCallItemTrackingOnBeforeItemTrackingLinesRunModal', '', false, false)]
    local procedure CDU99000837_OnCallItemTrackingOnBeforeItemTrackingLinesRunModal_ProdOrderLineReserve(var ProdOrderLine: Record "Prod. Order Line"; var ItemTrackingLines: Page "Item Tracking Lines")
    var
        Item: Record Item;
        LotInheritanceMgt: Codeunit "PWD Lot Inheritance Mgt.PW";
        TxtG001: label 'You cannot set Lot No on item %1. Lot No is set by a component.';
    begin
        Item.GET(ProdOrderLine."Item No.");
        IF LotInheritanceMgt.CheckItemDetermined(Item) THEN
            MESSAGE(STRSUBSTNO(TxtG001, Item."No."));
        //ItemTrackingForm.EDITABLE := FALSE;
    end;
    //---CDU99000813---

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Carry Out Action", 'OnInsertProdOrderOnAfterProdOrderInsert', '', false, false)]
    local procedure CDU99000813_OnInsertProdOrderOnAfterProdOrderInsert_CarryOutAction(var ProdOrder: Record "Production Order"; ReqLine: Record "Requisition Line")
    var
        Item: Record Item;
    begin
        Item.Get(ReqLine."No.");
        ProdOrder."Search Description" := Item."Search Description";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Carry Out Action", 'OnAfterTransferPlanningComp', '', false, false)]
    local procedure CDU99000813_OnAfterTransferPlanningComp_CarryOutAction(var PlanningComponent: Record "Planning Component"; var ProdOrderComponent: Record "Prod. Order Component")
    begin
        ProdOrderComponent."PWD Lot Determining" := PlanningComponent."PWD Lot Determining";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Carry Out Action", 'OnInsertProdOrderOnBeforeProdOrderInsert', '', false, false)]
    local procedure CDU99000813_OnInsertProdOrderOnBeforeProdOrderInsert_CarryOutAction(var ProdOrder: Record "Production Order"; ReqLine: Record "Requisition Line")
    var
        CstG001: label 'Series No for orders is not correct to renum Production Orders';
    begin
        IF ReqLine."PWD Transmitted Order No." THEN
            IF STRLEN(ReqLine."PWD Original Source No.") = 8 THEN
                ProdOrder."No." := COPYSTR(ReqLine."PWD Original Source No.", 3, 6) + '-'
                               + FORMAT(ReqLine."PWD Original Source Position") + '-0'
                               + FORMAT(ReqLine."PWD Original Counter")
            ELSE BEGIN
                ERROR(CstG001);
                ProdOrder."PWD Transmitted Order No." := TRUE;
                ProdOrder."PWD Original Source No." := ReqLine."PWD Original Source No.";
                ProdOrder."PWD Original Source Position" := ReqLine."PWD Original Source Position";
                ProdOrder."No. Series" := '';
            end;
    end;
    //---CDU99000809---
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Planning Line Management", 'OnBeforeInsertPlanningComponent', '', false, false)]
    local procedure CDU99000809_OnBeforeInsertPlanningComponent_PlanningLineManagement(var ReqLine: Record "Requisition Line"; var ProductionBOMLine: Record "Production BOM Line"; var PlanningComponent: Record "Planning Component"; LineQtyPerUOM: Decimal; ItemQtyPerUOM: Decimal)
    begin
        PlanningComponent."PWD Lot Determining" := ProductionBOMLine."PWD Lot Determining";
    end;
    //---CDU5063---
    [EventSubscriber(ObjectType::Codeunit, Codeunit::ArchiveManagement, 'OnBeforeRestoreSalesDocument', '', false, false)] //TODO: A verifier cette fonction(evenement utilisé avec IsHandled pour modifier le standard )
    local procedure CDU5063_OnBeforeRestoreSalesDocument_ArchiveManagement(var SalesHeaderArchive: Record "Sales Header Archive"; var IsHandled: Boolean)
    var
        PWDLPSAFunctionsMgt: Codeunit "PWD LPSA Functions Mgt.";
    begin
        IsHandled := true;
        PWDLPSAFunctionsMgt.BeforeRestoreSalesDocument(SalesHeaderArchive);
    end;
    //---CDU5406---
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Output Jnl.-Expl. Route", 'OnBeforeOutputItemJnlLineInsert', '', false, false)]
    local procedure CDU5406_OnBeforeOutputItemJnlLineInsert_OutputJnlExplRoute(var ItemJournalLine: Record "Item Journal Line"; LastOperation: Boolean)
    VAR
        RecLManufacturingSetup: Record "Manufacturing Setup";
        CodLWorkCenter: Code[10];
    begin
        //>>FE_LAPIERRETTE_PROD03.001
        RecLManufacturingSetup.GET();
        //>>FE_LAPIERRETTE_PRO12.001
        //RecLManufacturingSetup.TESTFIELD("Non conformity Prod. Location");
        //<<FE_LAPIERRETTE_PRO12.001
        RecLManufacturingSetup.TESTFIELD("PWD Mach. center-Invent. input");
        //CodLWorkCenter := RecLManufacturingSetup."PWD Mach. center-Invent. input"; 
    end;
    //---CDU5407---
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Prod. Order Status Management", 'OnBeforeShowStatusMessage', '', false, false)]
    local procedure CDU5407_OnBeforeShowStatusMessage_ProdOrderStatusManagement(ProdOrder: Record "Production Order"; ToProdOrder: Record "Production Order"; var IsHandled: Boolean)
    Var
        RecLProductionOrder: Record "Production Order";
        Text000: Label '%2 %3  with status %1 has been changed to %5 %6 with status %4.';
    begin
        IsHandled := true;
        Message(Text000, ProdOrder.Status, ProdOrder.TableCaption, ProdOrder."No.", ToProdOrder.Status, ToProdOrder.TableCaption, ToProdOrder."No.");
        //>>LAP2.17
        IF ToProdOrder.Status = ToProdOrder.Status::Released THEN BEGIN
            RecLProductionOrder.RESET();
            RecLProductionOrder.SETRANGE(Status, ToProdOrder.Status);
            RecLProductionOrder.SETRANGE("No.", ToProdOrder."No.");
            //>>LAP2.20
            //   REPORT.RUNMODAL(50022,FALSE,FALSE,RecLProductionOrder);
            REPORT.RUNMODAL(Report::"PWD Tracking Card", TRUE, TRUE, RecLProductionOrder);
            //<<LAP2.20
            //>>REGIE
            //   REPORT.RUNMODAL(50019,FALSE,FALSE,RecLProductionOrder);
            IF RecLProductionOrder.FINDFIRST() THEN
                RecLProductionOrder.FctPrintPDF();
            //<<REGIE
        END;
        //<<LAP2.17
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Prod. Order Status Management", 'OnBeforeCheckBeforeFinishProdOrder', '', false, false)]
    local procedure CDU5407_OnBeforeCheckBeforeFinishProdOrder_ProdOrderStatusManagement(var ProductionOrder: Record "Production Order"; var IsHandled: Boolean)
    var
        LPSASetGetFunctions: Codeunit "PWD LPSA Set/Get Functions.";
    begin
        //>>DEVTDL10/01/2014
        IF Not LPSASetGetFunctions.GetNoFinishCOntrol() THEN
            IsHandled := true;
        //<<DEVTDL10/01/2014
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Prod. Order Status Management", 'OnCopyFromProdOrder', '', false, false)]
    local procedure CDU5407_OnCopyFromProdOrder_ProdOrderStatusManagement(var ToProdOrder: Record "Production Order"; FromProdOrder: Record "Production Order")
    begin
        //>>LPSA2.06
        ToProdOrder."PWD Selection" := FALSE;
        //<<LPSA2.06
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Prod. Order Status Management", 'OnAfterTransProdOrder', '', false, false)]
    // local procedure CDU5407_OnAfterTransProdOrder_ProdOrderStatusManagement(var FromProdOrder: Record "Production Order"; var ToProdOrder: Record "Production Order")
    // var
    //     PWDLPSAFunctionsMgt: Codeunit "PWD LPSA Functions Mgt.";
    // begin
    //     // PLAW1 2.1
    //     PWDLPSAFunctionsMgt.TransProdOrderRtngLineAlt(FromProdOrder);
    //     // PLAW1 2.1 END  
    //     //PLAW1 2.1 transport prod order links
    //     PWDLPSAFunctionsMgt.TransProdOrderLink(FromProdOrder);
    //     //PLAW1 2.1 END
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Prod. Order Status Management", 'OnTransProdOrderLineOnAfterFromProdOrderLineFindSet', '', false, false)]
    local procedure CDU5407_OnTransProdOrderLineOnAfterFromProdOrderLineFindSet_ProdOrderStatusManagement(FromProdOrderLine: Record "Prod. Order Line"; var ToProdOrderLine: Record "Prod. Order Line"; NewStatus: Enum "Production Order Status")
    var
        Txt50000: Label 'There is a phantom item for Line no. %1';
    begin
        //>>FE_LAPRIERRETTE_GP0003 : APA 16/05/2013
        IF (FromProdOrderLine.ExistPhantomItem() <> '') AND (NewStatus = NewStatus::Released) THEN
            ERROR(Txt50000, FromProdOrderLine."Line No.");
        //<<FE_LAPRIERRETTE_GP0003 : APA 16/05/2013  
    end;
    //---CDU99000787---
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Prod. Order Lines", 'OnBeforeProdOrderLineInsert', '', false, false)]
    local procedure CDU99000787_OnBeforeProdOrderLineInsert_CreateProdOrderLines(var ProdOrderLine: Record "Prod. Order Line"; var ProductionOrder: Record "Production Order"; SalesLineIsSet: Boolean; var SalesLine: Record "Sales Line")
    begin
        ProdOrderLine.FctIsRecreateOrderLine();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Prod. Order Lines", 'OnBeforeInsertProdOrderLine', '', false, false)]
    local procedure CDU99000787_OnBeforeInsertProdOrderLine_CreateProdOrderLines(var ProdOrderLine: Record "Prod. Order Line"; var ProdOrderLine3: Record "Prod. Order Line"; var InsertNew: Boolean; var IsHandled: Boolean)
    begin
        if InsertNew and not (ProdOrderLine3.FindFirst()) then
            ProdOrderLine.FctIsRecreateOrderLine();
    end;
    //---CDU99000773---
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calculate Prod. Order", 'OnTransferBOMProcessItemOnBeforeGetPlanningParameters', '', false, false)]
    local procedure CDU99000773_OnTransferBOMProcessItemOnBeforeGetPlanningParameters_CalculateProdOrder(var ProdOrderComponent: Record "Prod. Order Component"; ProductionBOMLine: Record "Production BOM Line")
    begin
        ProdOrderComponent."PWD Lot Determining" := ProductionBOMLine."PWD Lot Determining";
    end;
    //---CDU5510---
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Production Journal Mgt", 'OnBeforeInsertOutputItemJnlLine', '', false, false)]
    local procedure CDU5510_OnBeforeInsertOutputItemJnlLine_ProductionJournalMgt(ProdOrderRtngLine: Record "Prod. Order Routing Line"; ProdOrderLine: Record "Prod. Order Line"; var IsHandled: Boolean)
    Var
        RecLManufacturingSetup: Record "Manufacturing Setup";
        CodLWorkCenter: Code[10];
    begin
        //>>FE_LAPIERRETTE_PROD03.001
        RecLManufacturingSetup.GET();
        //>>FE_LAPIERRETTE_PRO12.001
        //RecLManufacturingSetup.TESTFIELD("Non conformity Prod. Location");
        //<<FE_LAPIERRETTE_PRO12.001
        RecLManufacturingSetup.TESTFIELD("PWD Mach. center-Invent. input");
        //CodLWorkCenter := RecLManufacturingSetup."PWD Mach. center-Invent. input"; 
        //<FE_LAPIERRETTE_PROD03.001
    end;

    //---CDU5704---
    [EventSubscriber(ObjectType::Table, Database::"Transfer Shipment Header", 'OnAfterCopyFromTransferHeader', '', false, false)]
    local procedure CDU5704_OnAfterCopyFromTransferHeader_TransferShipmentHeader(var TransferShipmentHeader: Record "Transfer Shipment Header"; TransferHeader: Record "Transfer Header")
    begin
        //>>LAP2.00
        TransferShipmentHeader."PWD Sales Order No." := TransferHeader."PWD Sales Order No.";
        //<<LAP2.00
    end;
    //---CDU5705---
    [EventSubscriber(ObjectType::Table, Database::"Transfer Receipt Header", 'OnAfterCopyFromTransferHeader', '', false, false)]
    local procedure CDU5705_OnAfterCopyFromTransferHeader_TransferReceiptHeader(var TransferReceiptHeader: Record "Transfer Receipt Header"; TransferHeader: Record "Transfer Header")
    begin
        //>>LAP2.00
        TransferReceiptHeader."PWD Sales Order No." := TransferHeader."PWD Sales Order No.";
        //<<LAP2.00
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Header", 'OnBeforeCheckTransferFromAndToCodesNotTheSame', '', false, false)]
    local procedure CDU5705_OnBeforeCheckTransferFromAndToCodesNotTheSame_TransferHeader(TransferHeader: Record "Transfer Header"; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;
    //---CDU5708---
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Transfer Document", 'OnBeforeCheckTransferCode', '', false, false)]
    local procedure CDU5708_OnBeforeCheckTransferCode_ReleaseTransferDocument(var TransferHeader: Record "Transfer Header"; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;
    //---TAB99000802---
    [EventSubscriber(ObjectType::table, database::"Routing Tool", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure TAB99000802_OnAfterValidateEvent_RoutingTool_No(var Rec: Record "Routing Tool"; var xRec: Record "Routing Tool"; CurrFieldNo: Integer)
    var
        RecLItem: Record Item;
        RecLToolsInstructions: Record "PWD Tools Instructions";
    begin
        //>>LAP2.12
        CASE Rec."PWD Type" OF
            "PWD Type"::Method, "PWD Type"::Quality, "PWD Type"::Plan, "PWD Type"::Zone, "PWD Type"::"Targeted dimension":
                BEGIN
                    RecLToolsInstructions.GET(Rec."PWD Type", Rec."No.");
                    Rec.Description := RecLToolsInstructions.Description;
                    Rec."PWD Criteria" := RecLToolsInstructions.Criteria;
                END;
            "PWD Type"::Item:
                BEGIN
                    RecLItem.GET(Rec."No.");
                    Rec.Description := COPYSTR(RecLItem."PWD LPSA Description 1", 1, 50);
                END;
        END;
        //<<LAP2.12
    end;
    //---TAB99000851---
    [EventSubscriber(ObjectType::table, database::"Production Forecast Name", 'OnAfterDeleteEvent', '', false, false)]
    local procedure TAB99000851_OnAfterDeleteEvent_ProductionForecastName(var Rec: Record "Production Forecast Name"; RunTrigger: Boolean)
    var
        ProdForecastEntry: Record "Production Forecast Entry";
        Confirmed: Boolean;
        Text001: label 'The Production Forecast %1 has entries. Do you want to delete it anyway?';
    begin
        if not RunTrigger then
            exit;
        if Rec.IsTemporary then
            exit;
        ProdForecastEntry.SETRANGE("Production Forecast Name", Rec.Name);
        IF ProdForecastEntry.FINDSET() THEN
            IF NOT GUIALLOWED THEN
                Confirmed := TRUE
            ELSE
                Confirmed := CONFIRM(Text001, FALSE, Rec.Name);

        IF NOT Confirmed THEN
            ERROR('');

        ProdForecastEntry.DELETEALL();

    end;
    //---TAB99000852---
    [EventSubscriber(ObjectType::Table, Database::"Production Forecast Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure TAB99000852_OnAfterInsertEvent_ProductionForecastEntry(var Rec: Record "Production Forecast Entry"; RunTrigger: Boolean)
    var
        CompanyInfo: Record "Company Information";
        TargetCustomizedCalendarChange: Record "Customized Calendar Change";
        CalendarMgmt: Codeunit "Calendar Management";
        Nonworking: Boolean;
        NewDate: Date;
    begin
        if not RunTrigger then
            exit;
        if Rec.IsTemporary then
            exit;
        CompanyInfo.GET();
        CompanyInfo.TESTFIELD("Base Calendar Code");
        NewDate := Rec."Forecast Date";
        TargetCustomizedCalendarChange.Get();
        REPEAT
            Nonworking := CalendarMgmt.IsNonworkingDay(NewDate, TargetCustomizedCalendarChange);
            IF Nonworking THEN
                NewDate := CALCDATE('<-1D>', NewDate);
        UNTIL Nonworking = FALSE;
        Rec."Forecast Date" := NewDate;
    end;
    //TAB99000853
    [EventSubscriber(ObjectType::Table, Database::"Inventory Profile", 'OnAfterTransferFromSalesLine', '', false, false)]
    local procedure TAB99000853_OnAfterTransferFromSalesLine_InventoryProfile(var InventoryProfile: Record "Inventory Profile"; SalesLine: Record "Sales Line")
    begin
        IF InventoryProfile.Fct_TransmitOrderNo(InventoryProfile."Item No.") THEN BEGIN
            InventoryProfile."PWD Original Source Id" := DATABASE::"Sales Line";
            InventoryProfile."PWD Original Source No." := SalesLine."Document No.";
            InventoryProfile."PWD Original Source Position" := SalesLine.Position;
            InventoryProfile."PWD Original Counter" := 0;
            InventoryProfile."PWD Transmitted Order No." := TRUE;
        END;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Inventory Profile", 'OnAfterTransferFromComponent', '', false, false)]
    local procedure TAB99000853_OnAfterTransferFromComponent_InventoryProfile(var InventoryProfile: Record "Inventory Profile"; ProdOrderComp: Record "Prod. Order Component")
    var
        ProductionOrder: Record "Production Order";
    begin
        IF ProductionOrder.GET(ProdOrderComp.Status, ProdOrderComp."Prod. Order No.") THEN BEGIN
            InventoryProfile."PWD Original Source Id" := DATABASE::"Prod. Order Component";
            InventoryProfile."PWD Original Source No." := ProductionOrder."PWD Original Source No.";
            InventoryProfile."PWD Original Source Position" := ProductionOrder."PWD Original Source Position";
            //"Original Counter" := "Original Counter" + 1;
            InventoryProfile."PWD Transmitted Order No." := ProductionOrder."PWD Transmitted Order No.";
        END;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Inventory Profile", 'OnAfterTransferFromPlanComponent', '', false, false)]
    local procedure TAB99000853_OnAfterTransferFromPlanComponent_InventoryProfile(var InventoryProfile: Record "Inventory Profile"; PlanningComponent: Record "Planning Component")
    var
        ReqLine: Record "Requisition Line";
    begin
        IF ReqLine.GET(InventoryProfile."Source ID", InventoryProfile."Source Batch Name", InventoryProfile."Source Prod. Order Line") THEN BEGIN
            InventoryProfile."PWD Original Source Id" := DATABASE::"Planning Component";
            InventoryProfile."PWD Original Source No." := ReqLine."PWD Original Source No.";
            InventoryProfile."PWD Original Source Position" := ReqLine."PWD Original Source Position";
            InventoryProfile."PWD Original Counter" := ReqLine."PWD Original Counter" + 1;
            InventoryProfile."PWD Transmitted Order No." := ReqLine."PWD Transmitted Order No.";
        END;
    end;
    //---TAB99000829---
    [EventSubscriber(ObjectType::Table, Database::"Planning Component", 'OnItemNoOnValidateOnAfterInitFromItem', '', false, false)]
    local procedure TAB99000829_OnItemNoOnValidateOnAfterInitFromItem_PlanningComponent(var PlanningComponent: Record "Planning Component"; Item: Record Item)
    begin
        PlanningComponent."PWD Lot Determining" := Item."PWD Lot Determining";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Planning Component", 'OnAfterTransferFromComponent', '', false, false)]
    local procedure TAB99000829_OnAfterTransferFromComponent_PlanningComponent(var PlanningComponent: Record "Planning Component"; var ProdOrderComp: Record "Prod. Order Component")
    begin
        PlanningComponent."PWD Lot Determining" := ProdOrderComp."PWD Lot Determining";
    end;
    //---TAB99000772---
    [EventSubscriber(ObjectType::Table, Database::"Production BOM Line", 'OnValidateNoOnAfterAssignItemFields', '', false, false)]
    local procedure TAB99000772_OnValidateNoOnAfterAssignItemFields_ProductionBOMLine(var ProductionBOMLine: Record "Production BOM Line"; Item: Record Item; var xProductionBOMLine: Record "Production BOM Line"; CallingFieldNo: Integer)
    begin
        ProductionBOMLine."PWD Lot Determining" := FALSE;
        ProductionBOMLine.VALIDATE(ProductionBOMLine."PWD Lot Determining", Item."PWD Lot Determining");
    end;
    //---TAB99000764---
    [EventSubscriber(ObjectType::Table, Database::"Routing Line", 'OnAfterWorkCenterTransferFields', '', false, false)]
    local procedure TAB99000764_OnAfterWorkCenterTransferFields_RoutingLine(var RoutingLine: Record "Routing Line"; WorkCenter: Record "Work Center")
    begin
        RoutingLine."PWD Flushing Method" := WorkCenter."Flushing Method";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Routing Line", 'OnAfterMachineCtrTransferFields', '', false, false)]
    local procedure TAB99000764_OnAfterMachineCtrTransferFields_RoutingLine(var RoutingLine: Record "Routing Line"; WorkCenter: Record "Work Center"; MachineCenter: Record "Machine Center")
    begin
        RoutingLine."PWD Flushing Method" := MachineCenter."Flushing Method";
    end;
    //---PAG50---
    [EventSubscriber(ObjectType::Page, Page::"Purchase Order", 'OnAfterActionEvent', '&Print', false, false)]
    local procedure PAG50_OnAfterActionEvent_PurchaseOrder_Print(var Rec: Record "Purchase Header")
    begin
        Rec.TESTFIELD(Rec.Status, Rec.Status::Released);
    end;
    //---CDU5750---
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Create Source Document", 'OnAfterInitNewWhseShptLine', '', false, false)]
    local procedure CDU5750_OnAfterInitNewWhseShptLine_WhseCreateSourceDocument(var WhseShptLine: Record "Warehouse Shipment Line"; WhseShptHeader: Record "Warehouse Shipment Header"; SalesLine: Record "Sales Line"; AssembleToOrder: Boolean)
    begin
        //<<LAP2.08
        WhseShptLine."PWD LPSA Description 1" := SalesLine."PWD LPSA Description 1";
        WhseShptLine."PWD LPSA Description 2" := SalesLine."PWD LPSA Description 2";
        IF STRLEN(WhseShptLine."PWD LPSA Description 1") > 50 THEN
            WhseShptLine.Description := PADSTR(WhseShptLine."PWD LPSA Description 1", 50)
        ELSE
            WhseShptLine.Description := WhseShptLine."PWD LPSA Description 1";
        IF STRLEN(WhseShptLine."PWD LPSA Description 2") > 50 THEN
            WhseShptLine."Description 2" := PADSTR(WhseShptLine."PWD LPSA Description 2", 50)
        ELSE
            WhseShptLine."Description 2" := WhseShptLine."PWD LPSA Description 2";
        //<<LAP2.08
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Create Source Document", 'OnSalesLine2ReceiptLineOnAfterInitNewLine', '', false, false)]
    local procedure CDU5750_OnSalesLine2ReceiptLineOnAfterInitNewLine_WhseCreateSourceDocument(var WhseReceiptLine: Record "Warehouse Receipt Line"; WhseReceiptHeader: Record "Warehouse Receipt Header"; SalesLine: Record "Sales Line")
    begin
        //<<LAP2.08
        WhseReceiptLine."PWD LPSA Description 1" := SalesLine."PWD LPSA Description 1";
        WhseReceiptLine."PWD LPSA Description 2" := SalesLine."PWD LPSA Description 2";
        IF STRLEN(WhseReceiptLine."PWD LPSA Description 1") > 50 THEN
            WhseReceiptLine.Description := PADSTR(WhseReceiptLine."PWD LPSA Description 1", 50)
        ELSE
            WhseReceiptLine.Description := WhseReceiptLine."PWD LPSA Description 1";
        IF STRLEN(WhseReceiptLine."PWD LPSA Description 2") > 50 THEN
            WhseReceiptLine."Description 2" := PADSTR(WhseReceiptLine."PWD LPSA Description 2", 50)
        ELSE
            WhseReceiptLine."Description 2" := WhseReceiptLine."PWD LPSA Description 2";
        //<<LAP2.08
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Create Source Document", 'OnPurchLine2ReceiptLineOnAfterInitNewLine', '', false, false)]
    local procedure CDU5750_OnPurchLine2ReceiptLineOnAfterInitNewLine_WhseCreateSourceDocument(var WhseReceiptLine: Record "Warehouse Receipt Line"; WhseReceiptHeader: Record "Warehouse Receipt Header"; PurchaseLine: Record "Purchase Line")
    begin
        //>>LAP2.08
        WhseReceiptLine."PWD LPSA Description 1" := PurchaseLine."PWD LPSA Description 1";
        WhseReceiptLine."PWD LPSA Description 2" := PurchaseLine."PWD LPSA Description 2";
        IF STRLEN(WhseReceiptLine."PWD LPSA Description 1") > 50 THEN
            WhseReceiptLine.Description := PADSTR(WhseReceiptLine."PWD LPSA Description 1", 50)
        ELSE
            WhseReceiptLine.Description := WhseReceiptLine."PWD LPSA Description 1";
        IF STRLEN(WhseReceiptLine."PWD LPSA Description 2") > 50 THEN
            WhseReceiptLine."Description 2" := PADSTR(WhseReceiptLine."PWD LPSA Description 2", 50)
        ELSE
            WhseReceiptLine."Description 2" := WhseReceiptLine."PWD LPSA Description 2";
        //<<LAP2.08  
    end;
    //---CDU5812---
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calculate Standard Cost", 'OnAfterSetProdBOMFilters', '', false, false)]
    local procedure CDU5812_OnAfterSetProdBOMFilters_CalculateStandardCost(var ProdBOMLine: Record "Production BOM Line"; var PBOMVersionCode: Code[20]; var ProdBOMNo: Code[20])
    begin
        //>>TDL290719.001
        ProdBOMLine.SETFILTER("Quantity per", '<>%1', 0);
        //<<TDL290719.001
    end;
    //---CDU5895---
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Inventory Adjustment", 'OnBeforeOpenWindow', '', false, false)]
    local procedure CDU5895_OnBeforeOpenWindow_InventoryAdjustment(var IsHandled: Boolean)
    Begin
        IF Not GUIALLOWED THEN
            IsHandled := true;
    End;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Inventory Adjustment", 'OnBeforeUpdateWindow', '', false, false)]
    local procedure CDU5895_OnBeforeUpdateWindow_InventoryAdjustment(var IsHandled: Boolean)
    begin
        IF Not GUIALLOWED THEN
            IsHandled := true;
    end;

    //---CDU6500---
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Management", 'OnBeforeRegisterNewItemTrackingLines', '', false, false)]
    local procedure CDU6500_OnBeforeRegisterNewItemTrackingLines_ItemTrackingManagement(var TempTrackingSpecification: Record "Tracking Specification" temporary)
    var
        PWDLPSAFunctionsMgt: codeunit "PWD LPSA Functions Mgt.";
    begin
        PWDLPSAFunctionsMgt.BeforeRegisterNewItemTrackingLines(TempTrackingSpecification);
    end;

    //---CDU6501---
    [EventSubscriber(ObjectType::Table, Database::"Reservation Entry", 'OnAfterCopyTrackingFromItemLedgEntry', '', false, false)]
    local procedure CDU6501_OnAfterCopyTrackingFromItemLedgEntry_ReservationEntry(var ReservationEntry: Record "Reservation Entry"; ItemLedgerEntry: Record "Item Ledger Entry")
    begin
        //>>FE_LAPIERRETTE_PRO12.001
        IF ItemLedgerEntry."PWD NC" THEN
            ReservationEntry."PWD NC" := ItemLedgerEntry."PWD NC";
        //<<FE_LAPIERRETTE_PRO12.001
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Data Collection", 'OnCreateEntrySummary2OnAfterSetDoubleEntryAdjustment', '', false, false)]
    local procedure CDU6501_OnCreateEntrySummary2OnAfterSetDoubleEntryAdjustment_ItemTrackingDataCollection(var TempGlobalEntrySummary: Record "Entry Summary"; var TempReservEntry: Record "Reservation Entry")
    begin
        //>>FE_LAPIERRETTE_PRO12.001
        IF TempReservEntry."PWD NC" THEN
            TempGlobalEntrySummary."PWD NC" := TempReservEntry."PWD NC";
        //<<FE_LAPIERRETTE_PRO12.001 
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Data Collection", 'OnCreateEntrySummary2OnBeforeInsertOrModify', '', false, false)]
    local procedure CDU6501_OnCreateEntrySummary2OnBeforeInsertOrModify_ItemTrackingDataCollection(var TempGlobalEntrySummary: Record "Entry Summary" temporary; TempReservEntry: Record "Reservation Entry" temporary; TrackingSpecification: Record "Tracking Specification")
    begin
        //>>FE_LAPIERRETTE_PRO12.001
        IF TempReservEntry."PWD NC" THEN
            TempGlobalEntrySummary."PWD NC" := TempReservEntry."PWD NC";
        //<<FE_LAPIERRETTE_PRO12.001 
    end;
    //---CDU6620---
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnBeforeCopySalesToPurchDoc', '', false, false)]
    local procedure CDU6620_OnBeforeCopySalesToPurchDoc_CopyDocumentMgt(var ToPurchLine: Record "Purchase Line"; var FromSalesLine: Record "Sales Line")
    begin
        IF FromSalesLine.Type = FromSalesLine.Type::" " THEN
            //>>FE_LAPIERRETTE_ART02.001
            ToPurchLine."PWD LPSA Description 1" := FromSalesLine.Description;
        //<<FE_LAPIERRETTE_ART02.001
    end;
    //---PAG5510---
    [EventSubscriber(ObjectType::Page, Page::"Production Journal", 'OnBeforeActionEvent', 'Post', false, false)]
    local procedure PAG5510_OnBeforeActionEvent_ProductionJournal_Post(var Rec: Record "Item Journal Line")
    var
        ItemJnlLineCopy: Record "Item Journal Line";
        ManufacturingSetup: Record "Manufacturing Setup";
        ProductionJournal: page "Production Journal";
        CstG00002: Label 'Lot non conform, do you want to post ?';
    begin
        ManufacturingSetup.GET();
        //RecLManufacturingSetup.TESTFIELD("Non conformity Prod. Location");
        ManufacturingSetup.TESTFIELD("PWD Mach. center-Invent. input");
        ItemJnlLineCopy.COPY(Rec);
        IF ProductionJournal.FctExistControlQuality(ItemJnlLineCopy, ManufacturingSetup."PWD Mach. center-Invent. input") THEN
            IF NOT ProductionJournal.FctCheckControlQuality(ItemJnlLineCopy) THEN
                //IF NOT CONFIRM(STRSUBSTNO(CstG00001,RecLManufacturingSetup."Non conformity Prod. Location")) THEN
                IF NOT CONFIRM(CstG00002) THEN
                    EXIT;

    end;

    [EventSubscriber(ObjectType::Page, Page::"Production Journal", 'OnBeforeActionEvent', 'Post and &Print', false, false)]
    local procedure PAG5510_OnBeforeActionEvent_ProductionJournal_PostandPrint(var Rec: Record "Item Journal Line")
    var
        ItemJnlLineCopy: Record "Item Journal Line";
        ManufacturingSetup: Record "Manufacturing Setup";
        ProductionJournal: page "Production Journal";
        CstG00002: Label 'Lot non conform, do you want to post ?';
    begin
        ManufacturingSetup.GET();
        //RecLManufacturingSetup.TESTFIELD("Non conformity Prod. Location");
        ManufacturingSetup.TESTFIELD("PWD Mach. center-Invent. input");
        ItemJnlLineCopy.COPY(Rec);
        IF ProductionJournal.FctExistControlQuality(ItemJnlLineCopy, ManufacturingSetup."PWD Mach. center-Invent. input") THEN
            IF NOT ProductionJournal.FctCheckControlQuality(ItemJnlLineCopy) THEN
                //IF NOT CONFIRM(STRSUBSTNO(CstG00001,RecLManufacturingSetup."Non conformity Prod. Location")) THEN
                IF NOT CONFIRM(CstG00002) THEN
                    EXIT;
    end;
    //---PAG6510---
    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnInsertRecordOnBeforeTempItemTrackLineInsert', '', false, false)]
    local procedure PAG6510_OnInsertRecordOnBeforeTempItemTrackLineInsert_ItemTrackingLines(var TempTrackingSpecificationInsert: Record "Tracking Specification" temporary; var TempTrackingSpecification: Record "Tracking Specification" temporary)
    var
    begin
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnBeforeSetSourceSpec', '', false, false)]
    local procedure PAG6510_OnBeforeSetSourceSpec_ItemTrackingLines(var TrackingSpecification: Record "Tracking Specification"; var ReservationEntry: Record "Reservation Entry"; var ExcludePostedEntries: Boolean)
    var
        gCurrSourceSpecification: Record "Tracking Specification";
        gCurrSourceSpecificationSet: Boolean;
    begin
        gCurrSourceSpecification := TrackingSpecification;
        gCurrSourceSpecificationSet := TRUE;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterSetSourceSpec', '', false, false)]
    local procedure OnAfterSetSourceSpec(var TrackingSpecification: Record "Tracking Specification"; var CurrTrackingSpecification: Record "Tracking Specification"; var AvailabilityDate: Date; var BlockCommit: Boolean; FunctionsDemandVisible: Boolean; FunctionsSupplyVisible: Boolean; var QtyToHandleBaseEditable: Boolean; var QuantityBaseEditable: Boolean; var InsertIsBlocked: Boolean)
    var
        gCurrSourceSpecDueDate: Date;
    begin
        gCurrSourceSpecDueDate := AvailabilityDate;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnSetSourceSpecOnAfterAssignCurrentEntryStatus', '', false, false)]
    local procedure PAG6510_OnSetSourceSpecOnAfterAssignCurrentEntryStatus_ItemTrackingLines(var TrackingSpecification: Record "Tracking Specification"; var CurrentEntryStatus: Option)
    var
        ReservEntry: Record "Reservation Entry";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        CurrentSignFactor: Integer;
    begin
        ReservEntry."Source Type" := TrackingSpecification."Source Type";
        ReservEntry."Source Subtype" := TrackingSpecification."Source Subtype";
        CurrentSignFactor := CreateReservEntry.SignFactor(ReservEntry);
    end;

    // [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnBeforeAssignLotNo', '', false, false)]
    // local procedure PAG6510_OnBeforeAssignLotNo_ItemTrackingLines(var TrackingSpecification: Record "Tracking Specification"; var TempItemTrackLineInsert: Record "Tracking Specification" temporary; SourceQuantityArray: array[5] of Decimal; var IsHandled: Boolean)
    // var
    // // CstGErr0002: Label 'Lot Inheritance: You can''t assign a Lot No.,\because there is no Lot assigned to the lot determining component.';
    // begin
    //     // TODO: gNoAssignLotDetLotNo et gLotDeterminingLotCode sont des variables globales dans la page "Item Tracking Lines"(Il n'y a pas des appel pour cette fonction)
    //     // IF gNoAssignLotDetLotNo AND (gLotDeterminingLotCode = '') THEN
    //     //     ERROR(CstGErr0002);
    // end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnBeforeAssignNewLotNo', '', false, false)]
    local procedure PAG6510_OnBeforeAssignNewLotNo_ItemTrackingLines(var TrackingSpecification: Record "Tracking Specification"; var IsHandled: Boolean; var SourceTrackingSpecification: Record "Tracking Specification")
    var
        Item: Record Item;
        NoSeriesMgt: Codeunit "NoSeriesManagement";
        cuLSAvailMgt: Codeunit "PWD Lot Inheritance Mgt.PW";
    begin
        //TODO: gLotDeterminingLotCode est une variables globale dans la page "Item Tracking Lines" (Il n'y a pas des appel pour cette fonction)
        Item.Get(TrackingSpecification."Item No.");
        Item.TestField("Lot Nos.");
        //IF gLotDeterminingLotCode = '' THEN BEGIN
        TrackingSpecification.VALIDATE(TrackingSpecification."Lot No.", NoSeriesMgt.GetNextNo(Item."Lot Nos.", WORKDATE, TRUE));
        // END ELSE
        //     TrackingSpecification.VALIDATE(TrackingSpecification."Lot No.", gLotDeterminingLotCode);
        cuLSAvailMgt.CheckItemTrackingAssignment(
          TrackingSpecification."Source Type",
          TrackingSpecification."Source Subtype",
          TrackingSpecification."Source ID",
          TrackingSpecification."Source Batch Name",
          TrackingSpecification."Source Prod. Order Line",
          TrackingSpecification."Source Ref. No.",
          TrackingSpecification."PWD Lot Number",
          TrackingSpecification."PWD Trading Unit Number",
          TrackingSpecification."Lot No.",
          TrackingSpecification."Serial No.",
          TRUE);
        IsHandled := true;
    end;
    //---PAG9063---
    [EventSubscriber(ObjectType::Page, Page::"Purchase Agent Activities", 'OnOpenPageEvent', '', false, false)]
    local procedure PAG9063_OnOpenPageEvent_PurchaseAgentActivities(var Rec: Record "Purchase Cue")
    begin
        //>>TEST NICO
        Rec.SETFILTER(Rec."PWD UserID Filter", USERID);
        //<<TEST NICO
    end;
    //---PAG9245---
    [EventSubscriber(ObjectType::Page, Page::"Demand Forecast Matrix", 'OnMatrixOnDrillDownOnAfterSetFilters', '', false, false)]
    local procedure PAG9245_OnMatrixOnDrillDownOnAfterSetFilters_DemandForecastMatrix(var Item: Record Item; MatrixRecord: Record Date; ColumnID: Integer; ForecastType: Enum "Demand Forecast Type"; ProductionForecastName: Text[30]; LocationFilter: Text; var ProductionForecastEntry: Record "Production Forecast Entry");
    Var
        LPSASetGetFunctions: Codeunit "PWD LPSA Set/Get Functions.";
    begin
        //>>LAP080615
        IF LPSASetGetFunctions.GetCustomerFilter() <> '' THEN
            ProductionForecastEntry.SETFILTER("PWD Customer No.", LPSASetGetFunctions.GetCustomerFilter())
        ELSE
            ProductionForecastEntry.SETRANGE("PWD Customer No.");
        //<<LAP080615
    end;

    [EventSubscriber(ObjectType::Page, Page::"Demand Forecast Matrix", 'OnMATRIXOnAfterGetRecordOnAfterSetFilters', '', false, false)]

    local procedure PAG9245_OnMATRIXOnAfterGetRecordOnAfterSetFilters_DemandForecastMatrix(var Item: Record Item; ColumnID: Integer; ForecastType: Enum "Demand Forecast Type"; ProductionForecastName: Text[30]; LocationFilter: Text)
    Var
        LPSASetGetFunctions: Codeunit "PWD LPSA Set/Get Functions.";
    begin
        //>>LAP080615
        IF LPSASetGetFunctions.GetCustomerFilter() <> '' THEN
            Item.SETFILTER("PWD Customer Filter", LPSASetGetFunctions.GetCustomerFilter())
        ELSE
            Item.SETRANGE("PWD Customer Filter");
        //<<LAP080615
        //>>LAP080615
        //FILTERGROUP(2);

    end;

    // [EventSubscriber(ObjectType::Page, Page::"Demand Forecast Matrix", 'OnAfterGetRecordEvent', '', false, false)]
    // local procedure PAG99000919_OnAfterGetRecordEvent_DemandForecastMatrix(var Rec: Record Item)
    // Var
    //     LPSASetGetFunctions: Codeunit "PWD LPSA Set/Get Functions.";
    // begin
    //     Rec.CLEARMARKS();
    //     IF LPSASetGetFunctions.GetCustomerFilter() <> '' THEN BEGIN
    //         Rec.SETFILTER("PWD Customer Filter", LPSASetGetFunctions.GetCustomerFilter());
    //         Rec.CALCFIELDS("PWD ToForecast");
    //         Rec.SETRANGE("PWD ToForecast", TRUE);
    //     END
    //     ELSE BEGIN
    //         Rec.SETRANGE("PWD Customer Filter");
    //         Rec.SETRANGE("PWD ToForecast");
    //     END;
    //     //FILTERGROUP(0);
    //     //   Window.OPEN(TxtL001);
    //     //   CurrPage.UPDATE(FALSE);
    //     //   Window.CLOSE;
    //     //<<LAP080615
    // end;

    [EventSubscriber(ObjectType::Page, Page::"Demand Forecast Matrix", 'OnEnterBaseQtyOnBeforeValidateProdForecastQty', '', false, false)]
    local procedure PAG9245_OnEnterBaseQtyOnBeforeValidateProdForecastQty_DemandForecastMatrix(var Item: Record Item; ColumnID: Integer; MatrixRecords: array[32] of Record Date)
    Var
        LPSASetGetFunctions: Codeunit "PWD LPSA Set/Get Functions.";
    begin
        //>>LAP080615
        IF LPSASetGetFunctions.GetCustomerFilter() <> '' THEN
            Item.SETFILTER("PWD Customer Filter", LPSASetGetFunctions.GetCustomerFilter())
        ELSE
            Item.SETRANGE("PWD Customer Filter");
        //<<LAP080615
        //>>LAP181016
        Item.SETRANGE("Date Filter", MatrixRecords[ColumnID]."Period End");
        //<<LAP181016
    end;

    [EventSubscriber(ObjectType::Page, Page::"Demand Forecast Matrix", 'OnEnterBaseQtyOnAfterValidateProdForecastQty', '', false, false)]
    local procedure PAG9245_OnEnterBaseQtyOnAfterValidateProdForecastQty_DemandForecastMatrix(var Item: Record Item; ColumnID: Integer; MatrixRecords: array[32] of Record Date; QtyType: Enum "Analysis Amount Type")
    begin
        //>>LAP181016
        IF QtyType = QtyType::"Net Change" THEN
            Item.SETRANGE("Date Filter", MatrixRecords[ColumnID]."Period Start", MatrixRecords[ColumnID]."Period End")
        ELSE
            Item.SETRANGE("Date Filter", 0D, MatrixRecords[ColumnID]."Period End");
        //<<LAP181016
    end;

    [EventSubscriber(ObjectType::Page, Page::"Demand Forecast Matrix", 'OnBeforeProdForecastQtyBase_OnValidate', '', false, false)]
    local procedure PAG9245_OnBeforeProdForecastQtyBase_OnValidate_DemandForecastMatrix(var Item: Record Item; ColumnID: Integer; var IsHandled: Boolean; MatrixRecords: array[32] of Record Date; QtyType: Enum "Analysis Amount Type");
    var
        ProdForecastEntry: Record "Production Forecast Entry";
        ProdForecastEntry2: Record "Production Forecast Entry";
        LPSAFunctionsMgt: Codeunit "PWD LPSA Functions Mgt.";
        CustomerNo: Code[20];
        ForecastType: Enum "Demand Forecast Type";
        Text000: Label 'The Forecast On field must be Sales Items or Component.';
        Text003: Label 'You must set a location filter.';
        Text005: Label 'You must set a customer filter.';
    begin
        if ForecastType = ForecastType::Both then
            Error(Text000);

        ProdForecastEntry.SetCurrentKey("Production Forecast Name", "Item No.", "Location Code", "Forecast Date", "Component Forecast");
        ProdForecastEntry.SetRange("Production Forecast Name", Item.GetFilter("Production Forecast Name"));
        ProdForecastEntry.SetRange("Item No.", Item."No.");
        ProdForecastEntry.SetFilter("Location Code", Item.GetFilter("Location Filter"));
        //>>LAP080615
        ProdForecastEntry.SETRANGE("PWD Customer No.", Item.GETFILTER("PWD Customer Filter"));
        //<<LAP080615
        ProdForecastEntry.SetRange(
          "Forecast Date",
          MatrixRecords[ColumnID]."Period Start",
          MatrixRecords[ColumnID]."Period End");
        ProdForecastEntry.SetFilter("Component Forecast", Item.GetFilter("Component Forecast"));
        ProdForecastEntry2.SetCurrentKey(
          "Production Forecast Name", "Item No.", "Location Code", "Forecast Date", "Component Forecast");
        if Item.GetFilter("Location Filter") = '' then begin
            ProdForecastEntry2.CopyFilters(ProdForecastEntry);
            ProdForecastEntry2.SetFilter("Location Code", '>%1', '');
            if ProdForecastEntry2.FindSet() then
                repeat
                    if LPSAFunctionsMgt.ProdForecastByLocationQtyBase(ProdForecastEntry2) <> 0 then
                        Error(Text003);
                    ProdForecastEntry2.SetFilter("Location Code", '>%1', ProdForecastEntry2."Location Code");
                until ProdForecastEntry2.Next() = 0;
        end;
        //>>LAP080615
        IF Item.GETFILTER("PWD Customer Filter") = '' THEN BEGIN
            ProdForecastEntry2.COPYFILTERS(ProdForecastEntry);
            ProdForecastEntry2.SETRANGE("PWD Customer No.");
            IF ProdForecastEntry2.FindFirst() THEN BEGIN
                CustomerNo := ProdForecastEntry2."PWD Customer No.";
                ProdForecastEntry2.FindLast();
                IF ProdForecastEntry2."PWD Customer No." <> CustomerNo THEN
                    ERROR(Text005);
            END;
        END;
        //<<LAP080615
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnUpdateSalesLine', '', false, false)]
    local procedure CDU6620_OnUpdateSalesLine_CopyDocumentMgt(var ToSalesLine: Record "Sales Line"; var FromSalesLine: Record "Sales Line")
    begin
        //>>TI327233
        IF FromSalesLine."PWD LPSA Description 1" <> '' THEN
            ToSalesLine.VALIDATE("PWD LPSA Description 1", FromSalesLine."PWD LPSA Description 1");
        IF FromSalesLine."PWD LPSA Description 2" <> '' THEN
            ToSalesLine.VALIDATE("PWD LPSA Description 2", FromSalesLine."PWD LPSA Description 2");
        //<<TI327233
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnBeforeInsertOldSalesDocNoLine', '', false, false)]
    local procedure CDU6620_OnBeforeInsertOldSalesDocNoLine_CopyDocumentMgt(var ToSalesHeader: Record "Sales Header"; var ToSalesLine: Record "Sales Line"; OldDocType: Option; OldDocNo: Code[20]; var IsHandled: Boolean)
    var
        Text013: Label 'Shipment No.,Invoice No.,Return Receipt No.,Credit Memo No.';
        Text015: Label '%1 %2:';
    begin
        //>>FE_LAPIERRETTE_ART02.001
        ToSalesLine."PWD LPSA Description 1" := STRSUBSTNO(Text015, SELECTSTR(OldDocType, Text013), OldDocNo);
        //<<FE_LAPIERRETTE_ART02.001
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnBeforeInsertOldSalesCombDocNoLine', '', false, false)]
    local procedure CDU6620_OnBeforeInsertOldSalesCombDocNoLine_CopyDocumentMgt(var ToSalesHeader: Record "Sales Header"; var ToSalesLine: Record "Sales Line"; CopyFromInvoice: Boolean; OldDocNo: Code[20]; OldDocNo2: Code[20]; var IsHandled: Boolean)
    var
        Text016: Label 'Inv. No. ,Shpt. No. ,Cr. Memo No. ,Rtrn. Rcpt. No. ';
        Text018: Label '%1 - %2:';
    begin
        IF CopyFromInvoice THEN
            //>>FE_LAPIERRETTE_ART02.001
            ToSalesLine."PWD LPSA Description 1" :=
          STRSUBSTNO(
            Text018,
            COPYSTR(SELECTSTR(1, Text016) + OldDocNo, 1, 23),
            COPYSTR(SELECTSTR(2, Text016) + OldDocNo2, 1, 23))
        else
            //>>FE_LAPIERRETTE_ART02.001
            ToSalesLine."PWD LPSA Description 1" :=
          STRSUBSTNO(
            Text018,
            COPYSTR(SELECTSTR(3, Text016) + OldDocNo, 1, 23),
            COPYSTR(SELECTSTR(4, Text016) + OldDocNo2, 1, 23));
        //<<FE_LAPIERRETTE_ART02.001
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnBeforeInsertOldPurchDocNoLine', '', false, false)]
    local procedure CDU6620_OnBeforeInsertOldPurchDocNoLine_CopyDocumentMgt(ToPurchHeader: Record "Purchase Header"; var ToPurchLine: Record "Purchase Line"; OldDocType: Option; OldDocNo: Code[20]; var IsHandled: Boolean)
    var
        Text014: Label 'Receipt No.,Invoice No.,Return Shipment No.,Credit Memo No.';
        Text015: Label '%1 %2:';
    begin
        //>>FE_LAPIERRETTE_ART02.001
        ToPurchLine."PWD LPSA Description 1" := STRSUBSTNO(Text015, SELECTSTR(OldDocType, Text014), OldDocNo);
        //<<FE_LAPIERRETTE_ART02.001
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnBeforeInsertOldPurchCombDocNoLine', '', false, false)]
    local procedure CDU6620_OnBeforeInsertOldPurchCombDocNoLine_CopyDocumentMgt(var ToPurchHeader: Record "Purchase Header"; var ToPurchLine: Record "Purchase Line"; CopyFromInvoice: Boolean; OldDocNo: Code[20]; OldDocNo2: Code[20])
    var
        Text017: label 'Inv. No. ,Rcpt. No. ,Cr. Memo No. ,Rtrn. Shpt. No. ';
        Text018: label '%1 - %2:';
    begin
        //>>FE_LAPIERRETTE_ART02.001
        IF CopyFromInvoice THEN
            ToPurchLine."PWD LPSA Description 1" :=
              STRSUBSTNO(
                Text018,
                COPYSTR(SELECTSTR(1, Text017) + OldDocNo, 1, 23),
                COPYSTR(SELECTSTR(2, Text017) + OldDocNo2, 1, 23))
        //<<FE_LAPIERRETTE_ART02.001
        Else
            //>>FE_LAPIERRETTE_ART02.001
            ToPurchLine."PWD LPSA Description 1" :=
          STRSUBSTNO(
            Text018,
            COPYSTR(SELECTSTR(3, Text017) + OldDocNo, 1, 23),
            COPYSTR(SELECTSTR(4, Text017) + OldDocNo2, 1, 23));
        //<<FE_LAPIERRETTE_ART02.001
    End;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Transfer Extended Text", 'OnBeforeToSalesLineInsert', '', false, false)]
    local procedure CDU378_OnBeforeToSalesLineInsert_TransferExtendedText(var ToSalesLine: Record "Sales Line"; SalesLine: Record "Sales Line"; TempExtTextLine: Record "Extended Text Line" temporary; var NextLineNo: Integer; LineSpacing: Integer; var IsHandled: Boolean)
    begin
        //>>FE_LAPIERRETTE_ART02.001
        ToSalesLine."PWD LPSA Description 1" := SalesLine."PWD LPSA Description 1";
        ToSalesLine."PWD LPSA Description 2" := SalesLine."PWD LPSA Description 2";
        //<<FE_LAPIERRETTE_ART02.001
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Transfer Extended Text", 'OnBeforeToPurchLineInsert', '', false, false)]
    local procedure CDU378_OnBeforeToPurchLineInsert_TransferExtendedText(var ToPurchLine: Record "Purchase Line"; PurchLine: Record "Purchase Line"; TempExtTextLine: Record "Extended Text Line" temporary; var NextLineNo: Integer; LineSpacing: Integer)
    begin
        //>>FE_LAPIERRETTE_ART02.001
        ToPurchLine."PWD LPSA Description 1" := PurchLine."PWD LPSA Description 1";
        ToPurchLine."PWD LPSA Description 2" := PurchLine."PWD LPSA Description 2";
        //<<FE_LAPIERRETTE_ART02.001   
    end;
    //---CDU6620---
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Price Calc. Mgt.", 'OnFindSalesLinePriceOnItemTypeOnAfterSetUnitPrice', '', false, false)]
    local procedure CDU7000_OnFindSalesLinePriceOnItemTypeOnAfterSetUnitPrice(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var TempSalesPrice: Record "Sales Price" temporary; CalledByFieldNo: Integer; FoundSalesPrice: Boolean)
    begin
        //>>FE_LAPIERRETTE_VTE03.001
        SalesLine."PWD Fixed Price" := TempSalesPrice."PWD Fixed Price";
        //<<FE_LAPIERRETTE_VTE03.001
    end;
    //---PAG30---
    // [EventSubscriber(ObjectType::Page, Page::"Item Card", 'OnAfterInitControls', '', false, false)]
    // local procedure OnAfterInitControls()
    // Var
    // "LPSASetGetFunctions": Codeunit "PWD LPSA Set/Get Functions.";
    // begin
    //     //>>FE_LAPIERRETTE_PROD01.001: TO 13/12/2011
    //     LPSASetGetFunctions.SetFctFromLotDeterminingEnablee(FALSE);
    //     //<<FE_LAPIERRETTE_PROD01.001: TO 13/12/2011
    // end;

    [EventSubscriber(ObjectType::Page, Page::"Item Card", 'OnAfterValidateEvent', 'Item Category Code', false, false)]
    local procedure PAG30_OnAfterValidateEvent_ItemCard_ItemCategoryCode(var Rec: Record Item; var xRec: Record Item)
    var
        ItemCard: Page "Item Card";
    begin
        //>>FE_LAPIERRETTE_PROD01.001: TO 13/12/2011
        ItemCard.Fct_EnableLotDeterm();
        //<<FE_LAPIERRETTE_PROD01.001: TO 13/12/2011
    end;

    //---CDU3010801---
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"QuoteMgt", 'OnBeforeReCalc', '', false, false)]
    local procedure CDU3010801_OnBeforeReCalc_QuoteMgt(var SalesHeader: Record "Sales Header"; ShowMessage: Boolean; var IsHandled: Boolean)
    var
        PWDLPSAFunctionsMgt: Codeunit "PWD LPSA Functions Mgt.";
        CstG0001: Label 'Warning, the order status must be Open to recalculate the lines. ';
        CstG0002: Label 'Warning, the order must not  be Confirmed to recalculate the lines. ';
        CstG0003: Label 'Warning, the order must not  be Planned to recalculate the lines. ';
        CstG0004: Label 'Warning, this order has already been shipped (partly or totally), you cannot recalculate the lines. ';
        CstG0005: Label 'Do you really want to recalculate the lines ?';
    begin
        //>>FE_LAPIERRETTE_VTE05.001
        //Test on Sales Order
        IF SalesHeader."Document Type" IN [SalesHeader."Document Type"::Order] THEN BEGIN
            IF SalesHeader.Status IN [SalesHeader.Status::Released] THEN ERROR(CstG0001);
            IF SalesHeader."PWD ConfirmedLPSA" THEN ERROR(CstG0002);
            IF SalesHeader."PWD Planned" THEN ERROR(CstG0003);
            IF PWDLPSAFunctionsMgt.FctShippedLines(SalesHeader) THEN ERROR(CstG0004);
            IF NOT CONFIRM(CstG0005) THEN
                IsHandled := true;
        END;

        //<<FE_LAPIERRETTE_VTE05.001
    end;
    //---Rep99003803---
    [EventSubscriber(ObjectType::Report, Report::"Copy Production Forecast", 'OnBeforeProdForecastEntryInsert', '', false, false)]
    local procedure Rep99003803_OnBeforeProdForecastEntryInsert_CopyProductionForecast(var ProdForecastEntry: Record "Production Forecast Entry"; ToProdForecastEntry: Record "Production Forecast Entry")
    begin
        //>>LAP080615
        IF ToProdForecastEntry."PWD Customer No." <> '' THEN
            ProdForecastEntry."PWD Customer No." := ToProdForecastEntry."PWD Customer No.";
        //<<LAP080615
    end;
    //---CDU703---(REPORT 11511)
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Item", 'OnBeforeCopyItem', '', false, false)]
    // local procedure CDU703_OnBeforeCopyItem_CopyItem(SourceItem: Record Item; var TargetItem: Record Item; CopyCounter: Integer)
    // begin
    //     //>>TI409818: TO 22/03/2018:
    //     TargetItem."Standard Cost" := 0;
    //     TargetItem."Unit Cost" := 0;
    //     //<<TI409818: TO 22/03/2018:
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Item", 'OnAfterCopyItem', '', false, false)]
    local procedure CDU703_OnAfterCopyItem_CopyItem(var CopyItemBuffer: Record "Copy Item Buffer"; SourceItem: Record Item; var TargetItem: Record Item)
    var
        RecGItemConfigurator: Record "PWD Item Configurator";
        RecGItemConfiguratorNew: Record "PWD Item Configurator";
        LPSAFunctionsMgt: codeunit "PWD LPSA Functions Mgt.";
        LPSASetGetFunctions: codeunit "PWD LPSA Set/Get Functions.";
    begin
        //>>FE_LAPIERRETTE_NDT01.001
        IF LPSASetGetFunctions.GetFromConfiguration THEN
            LPSAFunctionsMgt.CopyFromConfiguration(SourceItem."No.", TargetItem, CopyItemBuffer);
        //<<FE_LAPIERRETTE_NDT01.001
        //>>TI409818: TO 22/03/2018:
        TargetItem."Standard Cost" := 0;
        TargetItem."Unit Cost" := 0;
        //<<TI409818: TO 22/03/2018:
        //>>FE_LAPIERRETTE_NDT01.001
        IF LPSASetGetFunctions.GetFromConfiguration THEN BEGIN
            TargetItem.Description := '';
            TargetItem."PWD LPSA Description 1" := '';
            TargetItem."PWD LPSA Description 2" := '';
            TargetItem."PWD Quartis Description" := '';
            TargetItem.MODIFY();
        END ELSE BEGIN
            //<<FE_LAPIERRETTE_NDT01.001
            //>>FE_LAPIERRETTE_ART01.001
            RecGItemConfigurator.RESET();
            RecGItemConfigurator.SETCURRENTKEY("Item Code");
            RecGItemConfigurator.SETRANGE("Item Code", SourceItem."No.");
            IF RecGItemConfigurator.FINDFIRST() THEN BEGIN
                RecGItemConfiguratorNew.INIT();
                RecGItemConfiguratorNew.COPY(RecGItemConfigurator);
                RecGItemConfigurator."Item Code" := TargetItem."No.";
                RecGItemConfigurator.INSERT(TRUE);
            END;
            //<<FE_LAPIERRETTE_ART01.001
            //>>FE_LAPIERRETTE_NDT01.001
        END;
        //<<FE_LAPIERRETTE_NDT01.001
    end;
    //---PAG729---(REPORT 11511)
    // [EventSubscriber(ObjectType::Page, Page::"Copy Item", 'OnAfterInitCopyItemBuffer', '', false, false)]
    // local procedure PAG729_OnAfterInitCopyItemBuffer_CopyItem(var CopyItemBuffer: Record "Copy Item Buffer")
    // begin
    //     //>>FE_LAPIERRETTE_NDT01.001
    //     BooGToItemVisible := NOT BooGFromConfig;
    //     //<<FE_LAPIERRETTE_NDT01.001
    // end;
    //---PAG99000811---
    [EventSubscriber(ObjectType::Page, Page::"Prod. BOM Where-Used", 'OnAfterGetRecordEvent', '', false, false)]
    local procedure PAG99000811_OnAfterGetRecordEvent_ProdBOMWhereUsed(var Rec: Record "Where-Used Line")
    var
        RecGItem: Record Item;
    begin
        //>>TDL.LPSA.05.10.2015
        IF NOT RecGItem.GET(Rec."Item No.") THEN
            RecGItem.INIT();
        //<<TDL.LPSA.05.10.2015
    end;
    //---PAG99000830---
    [EventSubscriber(ObjectType::Page, Page::"Firm Planned Prod. Order Lines", 'OnAfterGetRecordEvent', '', false, false)]
    local procedure PAG99000830_OnAfterGetRecordEvent_FirmPlannedProdOrderLines(var Rec: Record "Prod. Order Line")
    var
        RecLRoutingLine: Record "Prod. Order Routing Line";
        BooLFound: Boolean;
        CodLienGamme: Code[20];
        DatGHeureDeb: DateTime;
    begin
        //>>LPSA
        CLEAR(DatGHeureDeb);
        CLEAR(BooLFound);
        CLEAR(CodLienGamme);
        RecLRoutingLine.RESET();
        RecLRoutingLine.SETRANGE(Status, Rec.Status);
        RecLRoutingLine.SETRANGE("Prod. Order No.", Rec."Prod. Order No.");
        IF RecLRoutingLine.FINDSET() THEN
            REPEAT
                IF CodLienGamme <> '' THEN BEGIN
                    DatGHeureDeb := RecLRoutingLine."Starting Date-Time";
                    BooLFound := FALSE;
                END;
                CodLienGamme := RecLRoutingLine."Routing Link Code";
            UNTIL (RecLRoutingLine.NEXT() = 0) OR BooLFound;
        //<<LPSA
    end;
    //---PAG99000832---
    [EventSubscriber(ObjectType::Page, Page::"Released Prod. Order Lines", 'OnAfterGetRecordEvent', '', false, false)]
    local procedure PAG99000832_OnAfterGetRecordEvent_ReleasedProdOrderLines(var Rec: Record "Prod. Order Line")
    var
        RecLRoutingLine: Record "Prod. Order Routing Line";
        BooLFound: Boolean;
        CodLienGamme: Code[20];
        DatGHeureDeb: DateTime;
    begin
        //>>LPSA
        CLEAR(DatGHeureDeb);
        CLEAR(BooLFound);
        CLEAR(CodLienGamme);
        RecLRoutingLine.RESET();
        RecLRoutingLine.SETRANGE(Status, Rec.Status);
        RecLRoutingLine.SETRANGE("Prod. Order No.", Rec."Prod. Order No.");
        IF RecLRoutingLine.FINDSET() THEN
            REPEAT
                IF CodLienGamme <> '' THEN BEGIN
                    DatGHeureDeb := RecLRoutingLine."Starting Date-Time";
                    BooLFound := FALSE;
                END;
                CodLienGamme := RecLRoutingLine."Routing Link Code";
            UNTIL (RecLRoutingLine.NEXT() = 0) OR BooLFound;
        //<<LPSA
    end;
    //---PAG99000823---
    [EventSubscriber(ObjectType::Page, Page::"Output Journal", 'OnBeforeActionEvent', 'Post', false, false)]
    local procedure PAG99000823_OnAfterActionEvent_OutputJournal_Post(var Rec: Record "Item Journal Line")
    var
        RecLItemJnlLineCopy: Record "Item Journal Line";
        RecLManufacturingSetup: Record "Manufacturing Setup";
        OutputJournal: Page "Output Journal";
        CstG00002: Label 'Lot non conform, do you want to post ?';
    begin
        RecLManufacturingSetup.GET();
        RecLManufacturingSetup.TESTFIELD("PWD Mach. center-Invent. input");
        RecLItemJnlLineCopy.COPY(Rec);
        IF OutputJournal.FctExistControlQuality(RecLItemJnlLineCopy, RecLManufacturingSetup."PWD Mach. center-Invent. input") THEN
            IF NOT OutputJournal.FctCheckControlQuality(RecLItemJnlLineCopy,
                                          RecLManufacturingSetup."PWD Mach. center-Invent. input") THEN
                IF NOT CONFIRM(CstG00002) THEN
                    EXIT;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Output Journal", 'OnBeforeActionEvent', 'Post and &Print', false, false)]
    local procedure PAG99000823_OnAfterActionEvent_OutputJournal_PostandPrint(var Rec: Record "Item Journal Line")
    var
        RecLItemJnlLineCopy: Record "Item Journal Line";
        RecLManufacturingSetup: Record "Manufacturing Setup";
        OutputJournal: Page "Output Journal";
        CstG00002: Label 'Lot non conform, do you want to post ?';
    begin
        RecLManufacturingSetup.GET();
        RecLManufacturingSetup.TESTFIELD("PWD Mach. center-Invent. input");
        RecLItemJnlLineCopy.COPY(Rec);
        IF OutputJournal.FctExistControlQuality(RecLItemJnlLineCopy, RecLManufacturingSetup."PWD Mach. center-Invent. input") THEN
            IF NOT OutputJournal.FctCheckControlQuality(RecLItemJnlLineCopy,
                                          RecLManufacturingSetup."PWD Mach. center-Invent. input") THEN
                IF NOT CONFIRM(CstG00002) THEN
                    EXIT;
    end;
    //---REP698---
    [EventSubscriber(ObjectType::Report, Report::"Get Sales Orders", 'OnBeforeInsertReqWkshLine', '', false, false)]
    local procedure REP698_OnBeforeInsertReqWkshLine_GetSalesOrders(var ReqLine: Record "Requisition Line"; SalesLine: Record "Sales Line"; SpecOrder: Integer)
    begin
        ReqLine."PWD Product Group Code" := SalesLine."PWD Product Group Code";
    end;
    //---TAB5705---
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnAfterPostItemJnlLine', '', false, false)]
    local procedure TAB5705_OnAfterPostItemJnlLine_TransferOrderPostReceipt(ItemJnlLine: Record "Item Journal Line"; var TransLine3: Record "Transfer Line"; var TransRcptHeader2: Record "Transfer Receipt Header"; var TransRcptLine2: Record "Transfer Receipt Line"; var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line")
    begin
        ItemJnlLine."PWD Product Group Code" := TransLine3."PWD Product Group Code";
    end;
    //---CDU333---
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Wksh.-Make Order", 'OnInitPurchOrderLineOnAfterValidateLineDiscount', '', false, false)]
    local procedure CDU333_OnInitPurchOrderLineOnAfterValidateLineDiscount_ReqWkshMakeOrder(var PurchOrderLine: Record "Purchase Line"; PurchOrderHeader: Record "Purchase Header"; RequisitionLine: Record "Requisition Line")
    begin
        PurchOrderLine."PWD Product Group Code" := RequisitionLine."PWD Product Group Code";
    end;

    //---TAB5740---
    [EventSubscriber(ObjectType::Table, Database::"Transfer Header", 'OnBeforeValidateTransferToCode', '', false, false)]
    local procedure TAB5740_OnBeforeValidateTransferToCode_TransferHeader(var TransferHeader: Record "Transfer Header"; var xTransferHeader: Record "Transfer Header"; var IsHandled: Boolean; var HideValidationDialog: Boolean)
    Var
        Confirmed: Boolean;
        Text002: Label 'Do you want to change %1?';
    begin
        IsHandled := true;
        /*>>LAP2.00
                                                                //using the same location for transfer
                                                                {//STD
        if TransferHeader."Transfer-to Code" <> '' then
            if TransferHeader."Transfer-from Code" = TransferHeader."Transfer-to Code" then
                Error(
                  Text001,
                  TransferHeader.FieldCaption("Transfer-from Code"), TransferHeader.FieldCaption("Transfer-to Code"),
                  TransferHeader.TableCaption, TransferHeader."No.");
                  */
        //STD
        //<<LAP2.00

        if TransferHeader."Direct Transfer" then
            TransferHeader.VerifyNoInboundWhseHandlingOnLocation(TransferHeader."Transfer-to Code");

        if xTransferHeader."Transfer-to Code" <> TransferHeader."Transfer-to Code" then begin
            if HideValidationDialog or (xTransferHeader."Transfer-to Code" = '') then
                Confirmed := true
            else
                Confirmed := Confirm(Text002, false, TransferHeader.FieldCaption("Transfer-to Code"));
            if Confirmed then begin
                //>>LAP2.00
                IF TransferHeader."PWD Sales Order No." = '' THEN
                    /*//STD
                    if Location.Get(TransferHeader."Transfer-to Code") then begin
                        TransferHeader."Transfer-to Name" := Location.Name;
                        TransferHeader."Transfer-to Name 2" := Location."Name 2";
                        TransferHeader."Transfer-to Address" := Location.Address;
                        TransferHeader."Transfer-to Address 2" := Location."Address 2";
                        TransferHeader."Transfer-to Post Code" := Location."Post Code";
                        TransferHeader."Transfer-to City" := Location.City;
                        TransferHeader."Transfer-to County" := Location.County;
                        TransferHeader."Trsf.-to Country/Region Code" := Location."Country/Region Code";
                        TransferHeader."Transfer-to Contact" := Location.Contact;
                        if not TransferHeader."Direct Transfer" then begin
                            TransferHeader."Inbound Whse. Handling Time" := Location."Inbound Whse. Handling Time";
                            TransferRoute.GetTransferRoute(
                              TransferHeader."Transfer-from Code", TransferHeader."Transfer-to Code", TransferHeader."In-Transit Code",
                              TransferHeader."Shipping Agent Code", TransferHeader."Shipping Agent Service Code");
                            TransferRoute.GetShippingTime(
                              TransferHeader."Transfer-from Code", TransferHeader."Transfer-to Code",
                              TransferHeader."Shipping Agent Code", TransferHeader."Shipping Agent Service Code",
                              TransferHeader."Shipping Time");
                            TransferRoute.CalcReceiptDate(
                            TransferHeader."Shipment Date",
                            TransferHeader."Receipt Date",
                            TransferHeader."Shipping Time",
                            TransferHeader."Outbound Whse. Handling Time",
                            TransferHeader."Inbound Whse. Handling Time",
                            TransferHeader."Transfer-from Code",
                            TransferHeader."Transfer-to Code",
                            TransferHeader."Shipping Agent Code",
                            TransferHeader."Shipping Agent Service Code");
                        end;
                        TransLine.LockTable();
                        TransLine.SetRange("Document No.", TransferHeader."No.");
                    end;
                                                                                          */
                    //STD
                    TransferHeader.FillTransferToInfoLocation()
                ELSE
                    TransferHeader.FillTransferToInfoWithCmd();
                //<<LAP2.00
                TransferHeader.UpdateTransLines(TransferHeader, TransferHeader.FieldNo("Transfer-to Code"));
            end else
                TransferHeader."Transfer-to Code" := xTransferHeader."Transfer-to Code";
        end;
    end;
    //---TAB5745--- 
    [EventSubscriber(ObjectType::Table, Database::"Transfer Shipment Line", 'OnAfterCopyFromTransferLine', '', false, false)]
    local procedure TAB5745_OnAfterCopyFromTransferLine_TransferShipmentLine(var TransferShipmentLine: Record "Transfer Shipment Line"; TransferLine: Record "Transfer Line")
    begin
        TransferShipmentLine."PWD Product Group Code" := TransferLine."PWD Product Group Code";
    end;
    //---TAB83--- 
    [EventSubscriber(ObjectType::codeunit, codeunit::"Item Jnl. Line-Reserve", 'OnBeforeCallItemTracking', '', false, false)]
    local procedure TAB83_OnBeforeCallItemTracking_ItemJnlLineReserve(var ItemJournalLine: Record "Item Journal Line"; IsReclass: Boolean; var IsHandled: Boolean)

    VAR
        cuLotInheritanceMgt: Codeunit "PWD Lot Inheritance Mgt.PW";
        LPSASetGetFunctions: codeunit "PWD LPSA Set/Get Functions.";
        LotDetLotCode: Code[30];
        LotDetExpirDate: Date;
    begin
        //>>FE_LAPIERRETTE_PROD01.001: TO 13/12/2011
        LPSASetGetFunctions.SetgFromTheSameLot(cuLotInheritanceMgt.GetCompIsFromTheSameLot(ItemJournalLine));
        IF ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Output THEN BEGIN
            cuLotInheritanceMgt.GetLotDeterminingData(ItemJournalLine, LotDetLotCode, LotDetExpirDate);
            LPSASetGetFunctions.SetgLotDeterminingData(LotDetLotCode, LotDetExpirDate);
        END;
        //>>FE_LAPIERRETTE_PROD01.001: TO 13/12/2011
    end;

    //---99000919---
    [EventSubscriber(ObjectType::Page, Page::"Demand Forecast", 'OnBeforeActionEvent', 'Previous Set', false, false)]
    local procedure PAG99000919_OnAfterActionEvent_DemandForecast_PreviousSet()
    var
        DemandForecast: page "Demand Forecast";
    begin
        DemandForecast.SetMatrix();
    end;

    [EventSubscriber(ObjectType::Page, Page::"Demand Forecast", 'OnBeforeActionEvent', 'Previous Column', false, false)]
    local procedure PAG99000919_OnAfterActionEvent_DemandForecast_PreviousColumn()
    var
        DemandForecast: page "Demand Forecast";
    begin
        DemandForecast.SetMatrix();
    end;

    [EventSubscriber(ObjectType::Page, Page::"Demand Forecast", 'OnBeforeActionEvent', 'Next Column', false, false)]
    local procedure PAG99000919_OnAfterActionEvent_DemandForecast_NextColumn()
    var
        DemandForecast: page "Demand Forecast";
    begin
        DemandForecast.SetMatrix();
    end;

    [EventSubscriber(ObjectType::Page, Page::"Demand Forecast", 'OnbeforeValidateEvent', 'PeriodType', false, false)]
    local procedure PAG99000919_OnbeforeValidateEvent_DemandForecast_PeriodType()
    var
        DemandForecast: page "Demand Forecast";
    begin
        DemandForecast.SetMatrix();
    end;

    [EventSubscriber(ObjectType::Page, Page::"Demand Forecast", 'OnbeforeValidateEvent', 'DateFilter', false, false)]
    local procedure PAG99000919_OnbeforeValidateEvent_DemandForecast_DateFilter()
    var
        DemandForecast: page "Demand Forecast";
    begin
        DemandForecast.SetMatrix();
    end;

    [EventSubscriber(ObjectType::Page, Page::"Demand Forecast", 'OnOpenPageEvent', '', false, false)]
    local procedure PAG99000919_OnOpenPageEvent_DemandForecast()
    var
        LPSASetGetFunctions: Codeunit "PWD LPSA Set/Get Functions.";
    begin
        LPSASetGetFunctions.SetCustomerFilter('');
    end;

    var
    // BooGFromConfig: Boolean;
    // BooGFromImport: Boolean;
    // [INDATASET]
    // BooGToItemVisible: Boolean;
    //DontExecuteIfImport: Boolean;
    // [InDataSet]
    // LotDeterminingEnable: Boolean;
    //CustomerFilter: Code[20];
}