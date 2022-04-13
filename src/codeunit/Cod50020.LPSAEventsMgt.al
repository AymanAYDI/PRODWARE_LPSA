codeunit 50020 "PWD LPSA Events Mgt."
{
    SingleInstance = true;
    //---TAB27---
    [EventSubscriber(ObjectType::table, database::Item, 'OnAfterDeleteRelatedData', '', false, false)]
    local procedure TAB27_OnAfterDeleteRelatedData_Item(Item: Record Item)
    var
        ItemConfigurator: Record "PWD Item Configurator";
    begin
        //>>FE_LAPIERRETTE_ART01.001
        ItemConfigurator.RESET;
        ItemConfigurator.SETCURRENTKEY("Item Code");
        ItemConfigurator.SETRANGE("Item Code", Item."No.");
        ItemConfigurator.DELETEALL;
        //<<FE_LAPIERRETTE_ART01.001
    end;

    [EventSubscriber(ObjectType::table, database::Item, 'OnAfterValidateEvent', 'Costing Method', false, false)]
    local procedure TAB27_OnAfterValidateEvent_Item_CostingMethod(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    var
        LotSizeStdCost: Record "PWD Lot Size Standard Cost";
    begin
        //>>TDL_16_02
        Rec.TESTFIELD(Rec."Item Category Code");
        LotSizeStdCost.FctInsertItemLine(Rec."No.", Rec."Item Category Code");
        //<<TDL_16_02
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


    [EventSubscriber(ObjectType::table, database::"Sales Header", 'OnUpdateSalesLinesByFieldNoOnAfterCalcShouldConfirmReservationDateConflict', '', false, false)]
    local procedure Tab36_OnUpdateSalesLinesByFieldNoOnAfterCalcShouldConfirmReservationDateConflict_SalesHeader(var SalesHeader: Record "Sales Header"; ChangedFieldNo: Integer; var ShouldConfirmReservationDateConflict: Boolean)
    begin
        ShouldConfirmReservationDateConflict := ChangedFieldNo in [
                                SalesHeader.FieldNo(SalesHeader."Shipment Date")

                    ];
    end;

}

