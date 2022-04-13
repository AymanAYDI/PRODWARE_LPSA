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

    //---Tab37---
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

    //---TAB36---
    [EventSubscriber(ObjectType::table, database::"Sales Header", 'OnBeforeModifyEvent', '', false, false)]
    local procedure Tab36_OnBeforeModifyEvent_SalesHeader(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; RunTrigger: Boolean)
    var
        CstG0001: Label 'Order is in Send WMS Status.', Comment = 'FRS="La commande … son status WMS a Transmis."';
    begin
        if not RunTrigger then
            exit;
        if Rec.IsTemporary then
            exit;
        //>>WMS-FE05.001
        IF (Rec."PWD WMS_Status" = Rec."PWD WMS_Status"::Send) AND (NOT DontExecuteIfImport) THEN
            ERROR(CstG0001);
        //<<WMS-FE05.001


    end;
    //---TAB36---
    [EventSubscriber(ObjectType::table, database::"Sales Header", 'OnAfterCopySellToCustomerAddressFieldsFromCustomer', '', false, false)]
    local procedure Tab36_OnAfterCopySellToCustomerAddressFieldsFromCustomer_SalesHeader(var SalesHeader: Record "Sales Header"; SellToCustomer: Record Customer; CurrentFieldNo: Integer; var SkipBillToContact: Boolean)
    var
        LPSAFunctionsMgt: Codeunit "PWD LPSA Functions Mgt.";
    begin
        //>>FE_LAPIERRETTE_VTE01.001: TO 07/12/2011
        SalesHeader."PWD Rolex Bienne" := SellToCustomer."PWD Rolex Bienne";
        //<<FE_LAPIERRETTE_VTE01.001: TO 07/12/2011 
        LPSAFunctionsMgt.RunPageCommentSheet(SalesHeader);
        //>>TDL.LPSA.20.04.15

        //TDL.LPSA.20.04.15
    end;
    //---TAB36---
    [EventSubscriber(ObjectType::table, database::"Sales Header", 'OnAfterSetFieldsBilltoCustomer', '', false, false)]
    local procedure Tab36_OnAfterSetFieldsBilltoCustomer_SalesHeader(var SalesHeader: Record "Sales Header"; Customer: Record Customer; xSalesHeader: Record "Sales Header")
    var
        LPSAFunctionsMgt: Codeunit "PWD LPSA Functions Mgt.";
    begin

        //>>TDL.LPSA.20.04.15
        IF SalesHeader."Bill-to Customer No." <> SalesHeader."Sell-to Customer No." THEN BEGIN
            LPSAFunctionsMgt.RunPageCommentSheet(SalesHeader);
        END;
        //<<TDL.LPSA.20.04.15

    end;

    //---TAB36---
    [EventSubscriber(ObjectType::table, database::"Sales Header", 'OnUpdateSalesLinesByFieldNoOnAfterCalcShouldConfirmReservationDateConflict', '', false, false)]
    local procedure Tab36_OnUpdateSalesLinesByFieldNoOnAfterCalcShouldConfirmReservationDateConflict_SalesHeader(var SalesHeader: Record "Sales Header"; ChangedFieldNo: Integer; var ShouldConfirmReservationDateConflict: Boolean)
    begin
        ShouldConfirmReservationDateConflict := ChangedFieldNo in [
                                SalesHeader.FieldNo(SalesHeader."Shipment Date")

                    ];
    end;
    //---TAB36---
    [EventSubscriber(ObjectType::table, database::"Sales Header", 'OnUpdateSalesLineByChangedFieldName', '', false, false)]
    local procedure Tab36_OOnUpdateSalesLineByChangedFieldName_SalesHeader(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; ChangedFieldName: Text[100]; ChangedFieldNo: Integer)
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
    local procedure Tab39_OnBeforeModifyEvent_PurchaseLine(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line"; RunTrigger: Boolean)

    begin
        if not RunTrigger then
            exit;
        if Rec.IsTemporary then
            exit;
        //>>WMS-EBL1-003.001
        IF NOT BooGFromImport THEN
            //<<WMS-EBL1-003.001
            //>>WMS-FE04.001
            xRec.TESTFIELD("PWD WMS_Status", Rec."PWD WMS_Status"::" ");
        //<<WMS-FE04.001


    end;

    //---TAB39---
    [EventSubscriber(ObjectType::table, database::"Purchase Line", 'OnAfterAssignStdTxtValues', '', false, false)]
    local procedure Tab39_OnAfterAssignStdTxtValues_PurchaseLine(var PurchLine: Record "Purchase Line"; StandardText: Record "Standard Text")
    begin
        //>>FE_LAPIERRETTE_ART02.001
        PurchLine."PWD LPSA Description 1" := StandardText.Description;
        //<<FE_LAPIERRETTE_ART02.001

    end;

    //---TAB39---
    [EventSubscriber(ObjectType::table, database::"Purchase Line", 'OnAfterAssignGLAccountValues', '', false, false)]
    local procedure Tab39_OnAfterAssignGLAccountValues_PurchaseLine(var PurchLine: Record "Purchase Line"; GLAccount: Record "G/L Account")
    begin
        //>>FE_LAPIERRETTE_ART02.001
        PurchLine."PWD LPSA Description 1" := GLAccount.Name;
        //<<FE_LAPIERRETTE_ART02.001
    end;

    //---TAB39---
    [EventSubscriber(ObjectType::table, database::"Purchase Line", 'OnAfterAssignItemValues', '', false, false)]
    local procedure Tab39_OnAfterAssignItemValues_PurchaseLine(var PurchLine: Record "Purchase Line"; Item: Record Item; CurrentFieldNo: Integer)
    begin
        //>>FE_LAPIERRETTE_ART02.001
        PurchLine."PWD LPSA Description 1" := Item."PWD LPSA Description 1";
        PurchLine."PWD LPSA Description 2" := Item."PWD LPSA Description 2";
        //<<FE_LAPIERRETTE_ART02.001
    end;

    //---TAB39---
    [EventSubscriber(ObjectType::table, database::"Purchase Line", 'OnAfterAssignFixedAssetValues', '', false, false)]
    local procedure Tab39_OnAfterAssignFixedAssetValues_PurchaseLine(var PurchLine: Record "Purchase Line"; FixedAsset: Record "Fixed Asset")
    begin
        //>>FE_LAPIERRETTE_ART02.001
        PurchLine."PWD LPSA Description 1" := FixedAsset.Description;
        PurchLine."PWD LPSA Description 2" := FixedAsset."Description 2";
        //<<FE_LAPIERRETTE_ART02.001
    end;

    //---TAB39---
    [EventSubscriber(ObjectType::table, database::"Purchase Line", 'OnAfterAssignItemChargeValues', '', false, false)]
    local procedure Tab39_OOnAfterAssignItemChargeValues_PurchaseLine(var PurchLine: Record "Purchase Line"; ItemCharge: Record "Item Charge")
    begin
        //>>FE_LAPIERRETTE_ART02.001
        PurchLine."PWD LPSA Description 1" := ItemCharge.Description;
        //<<FE_LAPIERRETTE_ART02.001
    end;

    //---TAB39---
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateEvent', 'Description', false, false)]
    local procedure Tab39_OnAfterValidateEvent_PurchaseLine(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line"; CurrFieldNo: Integer)
    begin
        //>>FE_LAPIERRETTE_ART02.001
        IF Rec."PWD LPSA Description 1" = '' THEN
            Rec."PWD LPSA Description 1" := Rec.Description;
        //<<FE_LAPIERRETTE_ART02.001
    end;

    //---TAB39---
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateEvent', 'Description 2', false, false)]
    local procedure Tab39_OnAfterValidateEvent_PurchaseLine_(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line"; CurrFieldNo: Integer)
    begin
        //>>FE_LAPIERRETTE_ART02.001
        IF Rec."PWD LPSA Description 2" = '' THEN
            Rec."PWD LPSA Description 2" := Rec.Description;
        //<<FE_LAPIERRETTE_ART02.001
    end;

    //---TAB39---
    [EventSubscriber(ObjectType::table, database::"Purchase Line", 'OnAfterSetDefaultQuantity', '', false, false)]
    local procedure Tab39_OnAfterSetDefaultQuantity_PurchaseLine(var PurchLine: Record "Purchase Line"; var xPurchLine: Record "Purchase Line")

    begin
        //>>WMS-FE007_15.001
        PurchLine.FctDefaultQuantityIfWMS();
        //<<WMS-FE007_15.001
    end;

    //---TAB111---
    [EventSubscriber(ObjectType::table, database::"Sales Shipment Line", 'OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine', '', false, false)]
    local procedure Tab111_OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine_SalesShptLine(var SalesShptLine: Record "Sales Shipment Line"; var SalesLine: Record "Sales Line"; var NextLineNo: Integer; var Handled: Boolean; TempSalesLine: Record "Sales Line" temporary; SalesInvHeader: Record "Sales Header")
    var
        Text92000: Label 'Shipment No. %1 of %2:';
        SalesShptHeader: Record "Sales Shipment Header";
    begin
        //>>FE_LAPIERRETTE_ART02.001
        SalesShptHeader.Get(SalesShptLine."Document No.");
        SalesLine."PWD LPSA Description 1" := STRSUBSTNO(Text92000, SalesShptLine."Document No.", SalesShptHeader."Shipment Date");
        //<<FE_LAPIERRETTE_ART02.001
    end;

    //---TAB111---
    [EventSubscriber(ObjectType::table, database::"Sales Shipment Line", 'OnBeforeInsertInvLineFromShptLine', '', false, false)]
    local procedure Tab111_OnBeforeInsertInvLineFromShptLine_SalesShptLine(var SalesShptLine: Record "Sales Shipment Line"; var SalesLine: Record "Sales Line"; SalesOrderLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
        //>>FE_LAPIERRETTE_ART02.001
        SalesLine."PWD LPSA Description 1" := SalesShptLine."PWD LPSA Description 1";
        SalesLine."PWD LPSA Description 2" := SalesShptLine."PWD LPSA Description 2";
        //<<FE_LAPIERRETTE_ART02.001
    end;
}

