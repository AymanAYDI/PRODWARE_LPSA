report 50007 "PWD Production Balance"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.00
    // FE_LAPIERRETTE_PRO06.001: TO 19/01/2012: Bilan production par commande
    //                                           - Creation Report
    // 
    // FE_LAPIERRETTE_PRO06.002:GR 27/03/2012: Bilan production par commande
    //                                         - add FctCalcProductivityTot
    //                                         - add FctGetLastAmountsFromProdBal
    // 
    // ------------------------------------------------------------------------------------------------------------------
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/ProductionBalance.rdl';

    Caption = 'Production Balance';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Production Balance"; "PWD Production Balance")
        {
            CalcFields = "Current Quantity Total", "Scrap Quantity Total", "Quantity Total", "Expected Flushing Quantity Tot", "Realized Flushing Quantity Tot", "Cost Amount (Actual) Total", "Current Quantity Total Order", "Scrap Quantity Total Order";
            column(Planned_Order_No; "Planned Order No.")
            {
            }
            column(Item_No; "Item No.")
            {
            }
            column(Order_No; "Order No.")
            {
            }
            column(Operation_No; "Operation No.")
            {
            }
            column(Production_Balance_Type; Type)
            {
            }
            column(Production_Balance__No__; "No.")
            {
            }
            column(Production_Balance_Description; Description)
            {
            }
            column(Production_Balance_Status; Status)
            {
            }
            column(Line_Type; "Line Type")
            {
            }
            column(Production_Balance__Expected_Quantity_; "Expected Quantity")
            {
            }
            column(Production_Balance_Quantity; Quantity)
            {
            }
            column(Production_Balance__Unit_of_Measure_Code_; "Unit of Measure Code")
            {
            }
            column(Production_Balance__Scrap_Quantity_; "Scrap Quantity")
            {
            }
            column(Production_Balance__Expected_Flushing_Quantity_; "Expected Flushing Quantity")
            {
            }
            column(Production_Balance__Realized_Flushing_Quantity_; "Realized Flushing Quantity")
            {
            }
            column(Production_Balance__Cost_Amount__Expected__; "Cost Amount (Expected)")
            {
            }
            column(Production_Balance__Cost_Amount__Actual__; "Cost Amount (Actual)")
            {
            }
            column(Production_Balance__Cost_Difference_; "Cost Difference")
            {
            }
            column(Production_Balance__Actual_Cost_MP_; "Actual Cost MP")
            {
            }
            column(Production_Balance__Actual_Cost_STR_; "Actual Cost STR")
            {
            }
            column(Production_Balance__Actual_Cost_MO_; "Actual Cost MO")
            {
            }
            column(Production_Balance_Productivity; Productivity)
            {
            }
            column(Production_Balance_Output; Output)
            {
            }
            column(Production_Balance__Unit_Price_; "Unit Price")
            {
            }
            column(Production_Balance__Planned_Order_Index_; "Planned Order Index")
            {
            }
            column(OptGFilter; OptGFilter)
            {
            }
            column(IntTypeLine; IntTypeLine)
            {
            }
            column(RecGItem_Unit_Price; RecGItem."Unit Price")
            {
            }
            column(OptGStatus; OptGStatus)
            {
                OptionCaption = 'Released,Finished';
            }
            column(RecGSalesHeader_Sellto_Customer_No; RecGSalesHeader."Sell-to Customer No.")
            {
            }
            column(RecGSalesHeader_Name; RecGSalesHeader."Bill-to Name")
            {
            }
            column(Production_Balance__Planned_Order_Index__Control1100267071; "Planned Order Index")
            {
            }
            column(Production_Balance__Current_Quantity_Total_; "Current Quantity Total")
            {
            }
            column(Production_Balance__Scrap_Quantity_Total_; "Scrap Quantity Total")
            {
            }
            column(Production_Balance__Quantity_Total_; "Quantity Total")
            {
            }
            column(Production_Balance__Expected_Flushing_Quantity_Tot_; "Expected Flushing Quantity Tot")
            {
            }
            column(Production_Balance__Realized_Flushing_Quantity_Tot_; "Realized Flushing Quantity Tot")
            {
            }
            column(Production_Balance__Cost_Amount__Actual__Total_; "Cost Amount (Actual) Total")
            {
            }
            column(Production_Balance__Current_Quantity_Total_Order_; "Current Quantity Total Order")
            {
            }
            column(Production_Balance__Scrap_Quantity_Total_Order_; "Scrap Quantity Total Order")
            {
            }
            column(DecGLastQuantity; DecGLastQuantity)
            {
            }
            column(DecGLastUnitPrice; DecGLastUnitPrice)
            {
            }
            column(DecGLastExpectedQty; DecGLastExpectedQty)
            {
            }
            column(DecGLastAmountCost; DecGLastAmountCost)
            {
            }
            column(Productivity_Tot; DecGProducitvityTot)
            {
            }
            column(Planned_Order_No_Caption; Planned_Order_No_CaptionLbl)
            {
            }
            column(Item_No_Caption; FieldCaption("Item No."))
            {
            }
            column(Order_No_Caption; FieldCaption("Order No."))
            {
            }
            column(Operation_No_Caption; FieldCaption("Operation No."))
            {
            }
            column(Production_Balance_TypeCaption; FieldCaption(Type))
            {
            }
            column(Production_Balance__No__Caption; FieldCaption("No."))
            {
            }
            column(Production_Balance_DescriptionCaption; FieldCaption(Description))
            {
            }
            column(Production_Balance_StatusCaption; Production_Balance_StatusCaptionLbl)
            {
            }
            column(Line_Type_Caption; FieldCaption("Line Type"))
            {
            }
            column(Title; TitleLbl)
            {
            }
            column(Production_Balance__Expected_Quantity_Caption; Production_Balance__Expected_Quantity_CaptionLbl)
            {
            }
            column(Production_Balance_QuantityCaption; Production_Balance_QuantityCaptionLbl)
            {
            }
            column(Production_Balance__Unit_of_Measure_Code_Caption; Production_Balance__Unit_of_Measure_Code_CaptionLbl)
            {
            }
            column(Production_Balance__Scrap_Quantity_Caption; Production_Balance__Scrap_Quantity_CaptionLbl)
            {
            }
            column(Production_Balance__Expected_Flushing_Quantity_Caption; FieldCaption("Expected Flushing Quantity"))
            {
            }
            column(Production_Balance__Realized_Flushing_Quantity_Caption; FieldCaption("Realized Flushing Quantity"))
            {
            }
            column(Production_Balance__Cost_Amount__Expected__Caption; Production_Balance__Cost_Amount__Expected__CaptionLbl)
            {
            }
            column(Production_Balance__Cost_Amount__Actual__Caption; Production_Balance__Cost_Amount__Actual__CaptionLbl)
            {
            }
            column(Production_Balance__Cost_Difference_Caption; FieldCaption("Cost Difference"))
            {
            }
            column(Production_Balance__Actual_Cost_MP_Caption; FieldCaption("Actual Cost MP"))
            {
            }
            column(Production_Balance__Actual_Cost_STR_Caption; FieldCaption("Actual Cost STR"))
            {
            }
            column(Production_Balance__Actual_Cost_MO_Caption; FieldCaption("Actual Cost MO"))
            {
            }
            column(Production_Balance_ProductivityCaption; Production_Balance_ProductivityCaptionLbl)
            {
            }
            column(Production_Balance_OutputCaption; Production_Balance_OutputCaptionLbl)
            {
            }
            column(Production_Balance__Unit_Price_Caption; FieldCaption("Unit Price"))
            {
            }
            column(Production_Balance__Planned_Order_Index_Caption; FieldCaption("Planned Order Index"))
            {
            }
            column(Production_Balance__Expected_Quantity_Caption_2; Production_Balance__Expected_Quantity_Caption_2Lbl)
            {
            }
            column(Production_Balance_QuantityCaption_2; Production_Balance_QuantityCaption_2Lbl)
            {
            }
            column(Production_Balance__Expected_Flushing_Quantity_Caption_2; Production_Balance__Expected_Flushing_Quantity_Caption_2Lbl)
            {
            }
            column(Production_Balance__Realized_Flushing_Quantity_Caption_2; Production_Balance__Realized_Flushing_Quantity_Caption_2Lbl)
            {
            }
            column(Production_Balance_CurrentQuantity_Caption; Production_Balance_CurrentQuantity_CaptionLbl)
            {
            }
            column(RecGItem_Unit_Price__Caption; RecGItem_Unit_Price__CaptionLbl)
            {
            }
            column(Production_Balance__Prod_Order_Total_Caption; Production_Balance__Prod_Order_Total_CaptionLbl)
            {
            }
            column(Production_Balance__Prod_Order_Total_Caption2; Production_Balance__Prod_Order_Total_Caption2Lbl)
            {
            }
            column(Production_Balance__Current_Value_Caption; Production_Balance__Current_Value_CaptionLbl)
            {
            }
            column(Production_Balance__Unit_Value_Caption; Production_Balance__Unit_Value_CaptionLbl)
            {
            }
            column(Production_Balance__Margin_Caption; Production_Balance__Margin_CaptionLbl)
            {
            }
            column(OptGStatus__Caption; OptGStatus__CaptionLbl)
            {
            }
            column(RecGSalesHeader_Sellto_Customer_No_Caption; RecGSalesHeader_Sellto_Customer_No_CaptionLbl)
            {
            }
            column(RecGSalesHeader_Name_Caption; RecGSalesHeader_Name_CaptionLbl)
            {
            }
            column(Production_Balance__Planned_Order_Index__Control1100267071Caption; FieldCaption("Planned Order Index"))
            {
            }
            column(Pourcent; PourcentLbl)
            {
            }
            column(Production_Balance__Current_Quantity_Total_Caption; FieldCaption("Current Quantity Total"))
            {
            }
            column(Production_Balance__Scrap_Quantity_Total_Caption; FieldCaption("Scrap Quantity Total"))
            {
            }
            column(Production_Balance__Quantity_Total_Caption; FieldCaption("Quantity Total"))
            {
            }
            column(Production_Balance__Expected_Flushing_Quantity_Tot_Caption; FieldCaption("Expected Flushing Quantity Tot"))
            {
            }
            column(Production_Balance__Realized_Flushing_Quantity_Tot_Caption; FieldCaption("Realized Flushing Quantity Tot"))
            {
            }
            column(Production_Balance__Cost_Amount__Actual__Total_Caption; FieldCaption("Cost Amount (Actual) Total"))
            {
            }
            column(Production_Balance__Current_Quantity_Total_Order_Caption; FieldCaption("Current Quantity Total Order"))
            {
            }
            column(Production_Balance__Scrap_Quantity_Total_Order_Caption; FieldCaption("Scrap Quantity Total Order"))
            {
            }
            column(Production_Balance_User_ID; "User ID")
            {
            }
            column(Production_Balance_Entry_No_; "Entry No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                if IsServiceTier then
                    IntTypeLine := "Production Balance"."Line Type";

                if ((OptGFilter = OptGFilter::Order) and ("Production Balance"."Order No." <> '')) then
                    RecGSalesHeader.Get(RecGSalesHeader."Document Type"::Order, "Production Balance"."Order No.");
            end;

            trigger OnPostDataItem()
            begin
                RecGProductionBalance.Reset();
                RecGProductionBalance.SetRange("User ID", UserId);
                RecGProductionBalance.DeleteAll();
            end;

            trigger OnPreDataItem()
            begin
                RecGProductionBalance.Reset();
                RecGProductionBalance.SetRange("User ID", UserId);
                RecGProductionBalance.DeleteAll();

                if CodGList = '' then
                    Error(CstGT001);

                case OptGFilter of
                    OptGFilter::"Production Order":
                        FctProductionOrder();
                    OptGFilter::Item:
                        FctItem();
                    OptGFilter::Order:
                        FctOrder();
                end;

                "Production Balance".SetRange("User ID", UserId);
                //>>FE_LAPIERRETTE_PRO06.002
                DecGProducitvityTot := FctCalcProductivityTot();
                //<<FE_LAPIERRETTE_PRO06.002
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(OptGFilterF; OptGFilter)
                {
                    Caption = 'Grouping';
                    OptionCaption = 'Production Order,Item,Order';
                    ShowCaption = false;
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        OptGStatusEditable := false;
                        if OptGFilter = OptGFilter::Item then begin
                            OptGStatusEditable := true;
                            OptGDateEditable := true;
                        end;
                        if OptGFilter = OptGFilter::Order then
                            OptGDateEditable := true;
                    end;
                }
                field(CodGListF; CodGList)
                {
                    Caption = 'Selection';
                    ShowCaption = false;
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        case OptGFilter of
                            OptGFilter::"Production Order":
                                begin
                                    RecGProductionOrder.Reset();
                                    RecGProductionOrder.SetRange(RecGProductionOrder.Status, RecGProductionOrder.Status::Released,
                                                                                            RecGProductionOrder.Status::Finished);
                                    if PAGE.RunModal(PAGE::"Production Order List", RecGProductionOrder) = ACTION::LookupOK then begin
                                        CodGList := RecGProductionOrder."No.";
                                        if RecGProductionOrder.Status = RecGProductionOrder.Status::Released then
                                            OptGStatus := OptGStatus::Released
                                        else
                                            if RecGProductionOrder.Status = RecGProductionOrder.Status::Finished then
                                                OptGStatus := OptGStatus::Finished
                                    end;
                                end;
                            OptGFilter::Item:
                                begin
                                    RecGItem.Reset();
                                    if PAGE.RunModal(PAGE::"Item List", RecGItem) = ACTION::LookupOK then
                                        CodGList := RecGItem."No.";
                                end;
                            OptGFilter::Order:
                                begin
                                    RecGSalesHeader.Reset();
                                    RecGSalesHeader.SetRange(RecGSalesHeader."Document Type", RecGSalesHeader."Document Type"::Order);
                                    if PAGE.RunModal(PAGE::"Sales List", RecGSalesHeader) = ACTION::LookupOK then
                                        CodGList := RecGSalesHeader."No.";
                                end;
                        end;
                    end;
                }
                field(OptGStatusF; OptGStatus)
                {
                    Caption = 'Status';
                    Editable = OptGStatusEditable;
                    OptionCaption = 'Released,Finished';
                    ShowCaption = false;
                    ApplicationArea = All;
                }
                field(DatGBeginDateF; DatGBeginDate)
                {
                    Caption = 'Begin Date';
                    Editable = OptGDateEditable;
                    ShowCaption = false;
                    ApplicationArea = All;
                }
                field(DatGEndDateF; DatGEndDate)
                {
                    Caption = 'End Date';
                    Editable = OptGDateEditable;
                    ShowCaption = false;
                    ApplicationArea = All;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        RecGCapacityLedgerEntry: Record "Capacity Ledger Entry";
        RecGItem: Record Item;
        RecGItemLedgerEntry: Record "Item Ledger Entry";
        RecGProdOrderComponent: Record "Prod. Order Component";
        RecGProdOrderLine: Record "Prod. Order Line";
        RecGProdOrderRoutingLine: Record "Prod. Order Routing Line";
        RecGProductionOrder: Record "Production Order";
        RecGProductionBalance: Record "PWD Production Balance";
        RecGSalesHeader: Record "Sales Header";
        [InDataSet]
        OptGDateEditable: Boolean;
        [InDataSet]
        OptGStatusEditable: Boolean;
        CodGList: Code[20];
        DatGBeginDate: Date;
        DatGEndDate: Date;
        DecGCostAmountActual: Decimal;
        DecGDirectCost: Decimal;
        DecGLastAmountCost: Decimal;
        DecGLastExpectedQty: Decimal;
        DecGLastQuantity: Decimal;
        DecGLastUnitPrice: Decimal;
        DecGProducitvityTot: Decimal;
        IntGI: Integer;
        IntTypeLine: Integer;
        CstGT001: Label 'Mandatory selection.';
        OptGStatus__CaptionLbl: Label 'Status Filter';
        Planned_Order_No_CaptionLbl: Label 'Planned Order No.';
        PourcentLbl: Label '%';
        Production_Balance__Cost_Amount__Actual__CaptionLbl: Label 'Cost Amount (Actual)';
        Production_Balance__Cost_Amount__Expected__CaptionLbl: Label 'Cost Amount (Expected)';
        Production_Balance__Current_Value_CaptionLbl: Label 'Current Value';
        Production_Balance__Expected_Flushing_Quantity_Caption_2Lbl: Label 'Expected Time';
        Production_Balance__Expected_Quantity_Caption_2Lbl: Label 'Prod. Order Qty';
        Production_Balance__Expected_Quantity_CaptionLbl: Label 'Expected Quantity';
        Production_Balance__Margin_CaptionLbl: Label 'Margin';
        Production_Balance__Prod_Order_Total_Caption2Lbl: Label 'Total';
        Production_Balance__Prod_Order_Total_CaptionLbl: Label 'Prod. Order Total';
        Production_Balance__Realized_Flushing_Quantity_Caption_2Lbl: Label 'Real Time';
        Production_Balance__Scrap_Quantity_CaptionLbl: Label 'Scrap Quantity';
        Production_Balance__Unit_of_Measure_Code_CaptionLbl: Label 'Unit of Measure Code';
        Production_Balance__Unit_Value_CaptionLbl: Label 'Unit Value';
        Production_Balance_CurrentQuantity_CaptionLbl: Label 'Current Quantity';
        Production_Balance_OutputCaptionLbl: Label 'Output %';
        Production_Balance_ProductivityCaptionLbl: Label 'Productivity %';
        Production_Balance_QuantityCaption_2Lbl: Label 'Produced Quantity';
        Production_Balance_QuantityCaptionLbl: Label 'Quantity';
        Production_Balance_StatusCaptionLbl: Label 'Status';
        RecGItem_Unit_Price__CaptionLbl: Label 'Unit Price';
        RecGSalesHeader_Name_CaptionLbl: Label 'Sell-to Customer Name';
        RecGSalesHeader_Sellto_Customer_No_CaptionLbl: Label 'Sell-to Customer No.';
        TitleLbl: Label 'Production Balance';
        OptGFilter: Option "Production Order",Item,"Order";
        OptGStatus: Option Released,Finished;
        TxtGFilterPO2: Text[30];
        TxtGFilterPO: Text[1000];


    procedure FctProductionOrder()
    begin
        IntGI := 0;

        //* Components Lines
        RecGProdOrderComponent.Reset();
        if OptGStatus = OptGStatus::Released then
            RecGProdOrderComponent.SetRange(Status, RecGProdOrderComponent.Status::Released)
        else
            if OptGStatus = OptGStatus::Finished then
                RecGProdOrderComponent.SetRange(Status, RecGProdOrderComponent.Status::Finished);
        RecGProdOrderComponent.SetRange("Prod. Order No.", CodGList);
        if RecGProdOrderComponent.FindSet() then
            repeat
                IntGI := IntGI + 1;
                RecGProductionBalance.Init();
                RecGProductionBalance."User ID" := UserId;
                RecGProductionBalance."Entry No." := IntGI;
                RecGProductionBalance."Planned Order No." := RecGProdOrderComponent."Prod. Order No.";
                RecGProductionBalance."Line Type" := RecGProductionBalance."Line Type"::Component;
                RecGProductionBalance.Type := RecGProductionBalance.Type::Item;
                RecGProductionBalance."No." := RecGProdOrderComponent."Item No.";
                RecGProductionBalance.Description := RecGProdOrderComponent.Description;
                RecGProductionBalance.Status := RecGProdOrderComponent.Status.AsInteger();
                RecGProductionBalance."Expected Quantity" := RecGProdOrderComponent."Expected Quantity";
                FctFindItemLedgerEntry();
                RecGProductionBalance.Quantity := -RecGItemLedgerEntry.Quantity;
                RecGProductionBalance."Unit of Measure Code" := RecGProdOrderComponent."Unit of Measure Code";
                RecGProductionBalance."Scrap Quantity" := RecGProductionBalance.Quantity - RecGProductionBalance."Expected Quantity";
                RecGProductionBalance."Expected Flushing Quantity" := RecGProdOrderComponent."Expected Quantity";
                RecGProductionBalance."Realized Flushing Quantity" := RecGProductionBalance.Quantity;
                RecGProductionBalance."Cost Amount (Expected)" := RecGProdOrderComponent."Cost Amount";
                RecGProductionBalance."Cost Amount (Actual)" := -DecGCostAmountActual;
                RecGProductionBalance."Cost Difference" := -DecGCostAmountActual - RecGProdOrderComponent."Cost Amount";
                RecGProductionBalance."Actual Cost MP" := -DecGCostAmountActual;
                if RecGProductionOrder.Get(RecGProdOrderComponent.Status, RecGProdOrderComponent."Prod. Order No.") then begin
                    RecGItem.Get(RecGProductionOrder."Source No.");
                    RecGProductionBalance."Unit Price" := RecGItem."Unit Price";
                end;
                RecGProductionBalance.Insert();
            until RecGProdOrderComponent.Next() = 0;

        //* Operations Lines
        RecGProdOrderRoutingLine.Reset();
        if OptGStatus = OptGStatus::Released then
            RecGProdOrderRoutingLine.SetRange(Status, RecGProdOrderRoutingLine.Status::Released)
        else
            if OptGStatus = OptGStatus::Finished then
                RecGProdOrderRoutingLine.SetRange(Status, RecGProdOrderRoutingLine.Status::Finished);
        RecGProdOrderRoutingLine.SetRange("Prod. Order No.", CodGList);
        if RecGProdOrderRoutingLine.FindSet() then
            repeat
                IntGI := IntGI + 1;
                RecGProductionBalance.Init();
                RecGProductionBalance."User ID" := UserId;
                RecGProductionBalance."Entry No." := IntGI;
                RecGProductionBalance."Planned Order No." := RecGProdOrderRoutingLine."Prod. Order No.";
                RecGProductionBalance."Line Type" := RecGProductionBalance."Line Type"::Operation;
                RecGProductionBalance."Operation No." := RecGProdOrderRoutingLine."Operation No.";
                RecGProductionBalance.Type := RecGProdOrderRoutingLine.Type.AsInteger();
                RecGProductionBalance."No." := RecGProdOrderRoutingLine."No.";
                RecGProductionBalance.Description := RecGProdOrderRoutingLine.Description;
                RecGProductionBalance.Status := RecGProdOrderRoutingLine.Status.AsInteger();
                FctFindProdOrderLine();
                RecGProductionBalance."Expected Quantity" := RecGProdOrderLine.Quantity;
                FctFindCapacityLedgerEntry();
                RecGProductionBalance.Quantity := RecGCapacityLedgerEntry."Output Quantity";
                RecGProductionBalance."Unit of Measure Code" := RecGCapacityLedgerEntry."Cap. Unit of Measure Code";
                RecGProductionBalance."Scrap Quantity" := RecGCapacityLedgerEntry."Scrap Quantity";
                RecGProductionBalance."Expected Flushing Quantity" := RecGProdOrderRoutingLine."Expected Capacity Need";
                RecGProductionBalance."Realized Flushing Quantity" := RecGCapacityLedgerEntry."Setup Time" + RecGCapacityLedgerEntry."Run Time";
                RecGProductionBalance."Cost Amount (Expected)" := RecGProdOrderRoutingLine."Expected Operation Cost Amt.";
                RecGProductionBalance."Cost Amount (Actual)" := RecGCapacityLedgerEntry."Direct Cost";
                RecGProductionBalance."Cost Difference" := RecGCapacityLedgerEntry."Direct Cost" -
                                                           RecGProdOrderRoutingLine."Expected Operation Cost Amt.";
                if RecGProductionBalance."Expected Flushing Quantity" <> 0 then
                    RecGProductionBalance.Productivity := (1 - (RecGProductionBalance."Realized Flushing Quantity" -
                                        RecGProductionBalance."Expected Flushing Quantity") / RecGProductionBalance."Expected Flushing Quantity") *
                100;
                if RecGProductionBalance."Expected Quantity" <> 0 then
                    RecGProductionBalance.Output := RecGProductionBalance.Quantity / RecGProductionBalance."Expected Quantity" * 100;
                RecGProductionBalance.Insert();

            until RecGProdOrderRoutingLine.Next() = 0;
        //>>FE_LAPIERRETTE_PRO06.002
        FctGetLastAmountsFromProdBal();
        //<<FE_LAPIERRETTE_PRO06.002
    end;


    procedure FctItem()
    var
        RecLProductionBalance: Record "PWD Production Balance";
    begin
        IntGI := 0;
        TxtGFilterPO := '';
        RecGItem.Get(CodGList);
        RecGProdOrderLine.Reset();
        RecGProdOrderLine.SetCurrentKey(Status, "Item No.", "Variant Code", "Location Code", "Starting Date");
        if OptGStatus = OptGStatus::Released then
            RecGProdOrderLine.SetRange(Status, RecGProdOrderLine.Status::Released)
        else
            if OptGStatus = OptGStatus::Finished then
                RecGProdOrderLine.SetRange(Status, RecGProdOrderLine.Status::Finished);
        RecGProdOrderLine.SetRange("Item No.", CodGList);
        if ((DatGBeginDate <> 0D) or (DatGEndDate <> 0D)) then
            RecGProdOrderLine.SetFilter("Due Date", '%1..%2', DatGBeginDate, DatGEndDate);
        if RecGProdOrderLine.FindSet() then
            repeat
                if TxtGFilterPO = '' then
                    TxtGFilterPO := RecGProdOrderLine."Prod. Order No."
                else
                    TxtGFilterPO := TxtGFilterPO + '|' + RecGProdOrderLine."Prod. Order No.";
            until RecGProdOrderLine.Next() = 0;

        //* Components Lines
        RecGProdOrderComponent.Reset();
        if OptGStatus = OptGStatus::Released then
            RecGProdOrderComponent.SetRange(Status, RecGProdOrderComponent.Status::Released)
        else
            if OptGStatus = OptGStatus::Finished then
                RecGProdOrderComponent.SetRange(Status, RecGProdOrderComponent.Status::Finished);
        RecGProdOrderComponent.SetFilter("Prod. Order No.", TxtGFilterPO);
        if RecGProdOrderComponent.FindSet() then
            repeat
                RecLProductionBalance.Reset();
                RecLProductionBalance.SetCurrentKey("User ID", "Line Type", Type, "No.");
                RecLProductionBalance.SetRange("User ID", UserId);
                RecLProductionBalance.SetRange("Line Type", RecLProductionBalance."Line Type"::Component);
                RecLProductionBalance.SetRange(Type, RecLProductionBalance.Type::Item);
                RecLProductionBalance.SetRange("No.", RecGProdOrderComponent."Item No.");
                if RecLProductionBalance.FindFirst() then begin
                    RecLProductionBalance."Expected Quantity" := RecLProductionBalance."Expected Quantity" +
                                                                 RecGProdOrderComponent."Expected Quantity";
                    RecLProductionBalance."Cost Amount (Expected)" := RecLProductionBalance."Cost Amount (Expected)" +
                                                                      RecGProdOrderComponent."Direct Cost Amount";
                    RecLProductionBalance."Scrap Quantity" := RecLProductionBalance.Quantity - RecLProductionBalance."Expected Quantity";
                    RecLProductionBalance."Expected Flushing Quantity" := RecLProductionBalance."Expected Quantity";
                    RecLProductionBalance."Cost Difference" := RecLProductionBalance."Cost Amount (Actual)" -
                                                               RecLProductionBalance."Cost Amount (Expected)";
                    RecLProductionBalance.Modify();
                end else begin
                    IntGI := IntGI + 1;
                    RecGProductionBalance.Init();
                    RecGProductionBalance."User ID" := UserId;
                    RecGProductionBalance."Entry No." := IntGI;
                    RecGProductionBalance."Item No." := CodGList;
                    RecGProductionBalance."Line Type" := RecGProductionBalance."Line Type"::Component;
                    RecGProductionBalance.Type := RecGProductionBalance.Type::Item;
                    RecGProductionBalance."No." := RecGProdOrderComponent."Item No.";
                    RecGProductionBalance.Description := RecGProdOrderComponent.Description;
                    RecGProductionBalance.Status := RecGProductionBalance.Status::" ";
                    RecGProductionBalance."Expected Quantity" := RecGProdOrderComponent."Expected Quantity";
                    FctFindItemLedgerEntry2();
                    RecGProductionBalance.Quantity := -RecGItemLedgerEntry.Quantity;
                    RecGProductionBalance."Unit of Measure Code" := RecGProdOrderComponent."Unit of Measure Code";
                    RecGProductionBalance."Scrap Quantity" := RecGProductionBalance.Quantity - RecGProductionBalance."Expected Quantity";
                    RecGProductionBalance."Expected Flushing Quantity" := RecGProdOrderComponent."Expected Quantity";
                    RecGProductionBalance."Realized Flushing Quantity" := RecGProductionBalance.Quantity;
                    RecGProductionBalance."Cost Amount (Expected)" := RecGProdOrderComponent."Direct Cost Amount";
                    RecGProductionBalance."Cost Amount (Actual)" := -DecGCostAmountActual;
                    RecGProductionBalance."Cost Difference" := -DecGCostAmountActual - RecGProdOrderComponent."Direct Cost Amount";
                    RecGProductionBalance."Actual Cost MP" := -DecGCostAmountActual;
                    RecGProductionBalance."Unit Price" := RecGItem."Unit Price";
                    RecGProductionBalance.Insert();
                end;

            until RecGProdOrderComponent.Next() = 0;

        //* Operations Lines
        RecGProdOrderRoutingLine.Reset();
        if OptGStatus = OptGStatus::Released then
            RecGProdOrderRoutingLine.SetRange(Status, RecGProdOrderRoutingLine.Status::Released)
        else
            if OptGStatus = OptGStatus::Finished then
                RecGProdOrderRoutingLine.SetRange(Status, RecGProdOrderRoutingLine.Status::Finished);
        RecGProdOrderRoutingLine.SetFilter("Prod. Order No.", TxtGFilterPO);
        if RecGProdOrderRoutingLine.FindSet() then
            repeat
                RecLProductionBalance.Reset();
                RecLProductionBalance.SetCurrentKey("User ID", "Line Type", "Operation No.", Type, "No.");
                RecLProductionBalance.SetRange("User ID", UserId);
                RecLProductionBalance.SetRange("Line Type", RecLProductionBalance."Line Type"::Operation);
                RecLProductionBalance.SetRange("Operation No.", RecGProdOrderRoutingLine."Operation No.");
                RecLProductionBalance.SetRange(Type, RecGProdOrderRoutingLine.Type);
                RecLProductionBalance.SetRange("No.", RecGProdOrderRoutingLine."No.");
                if RecLProductionBalance.FindFirst() then begin
                    RecLProductionBalance."Expected Quantity" := RecLProductionBalance."Expected Quantity" +
                                                                 RecGProdOrderRoutingLine."Input Quantity";
                    RecLProductionBalance."Cost Amount (Expected)" := RecLProductionBalance."Cost Amount (Expected)" +
                                                                      RecGProdOrderRoutingLine."Expected Operation Cost Amt.";
                    RecLProductionBalance."Expected Flushing Quantity" := RecLProductionBalance."Expected Flushing Quantity" +
                                                                          RecGProdOrderRoutingLine."Expected Capacity Need";
                    RecLProductionBalance."Cost Difference" := RecLProductionBalance."Cost Amount (Actual)" -
                                                               RecLProductionBalance."Cost Amount (Expected)";
                    if RecLProductionBalance."Expected Flushing Quantity" <> 0 then
                        RecLProductionBalance.Productivity := (1 - (RecLProductionBalance."Realized Flushing Quantity" -
                                          RecLProductionBalance."Expected Flushing Quantity") / RecLProductionBalance."Expected Flushing Quantity") *
                  100;
                    if RecLProductionBalance."Expected Quantity" <> 0 then
                        RecLProductionBalance.Output := RecLProductionBalance.Quantity / RecLProductionBalance."Expected Quantity" * 100;

                    //>>TDL_PROD04_28_02_2012.001
                    FctFindCapacityLedgerEntry2();
                    RecLProductionBalance."Unit of Measure Code" := RecGCapacityLedgerEntry."Cap. Unit of Measure Code";
                    //<<TDL_PROD04_28_02_2012.001

                    RecLProductionBalance.Modify();
                end else begin
                    IntGI := IntGI + 1;
                    RecGProductionBalance.Init();
                    RecGProductionBalance."User ID" := UserId;
                    RecGProductionBalance."Entry No." := IntGI;
                    RecGProductionBalance."Planned Order No." := RecGProdOrderRoutingLine."Prod. Order No.";
                    RecGProductionBalance."Line Type" := RecGProductionBalance."Line Type"::Operation;
                    RecGProductionBalance."Operation No." := RecGProdOrderRoutingLine."Operation No.";
                    RecGProductionBalance.Type := RecGProdOrderRoutingLine.Type.AsInteger();
                    RecGProductionBalance."No." := RecGProdOrderRoutingLine."No.";
                    RecGProductionBalance.Description := RecGProdOrderRoutingLine.Description;
                    RecGProductionBalance.Status := RecGProductionBalance.Status::" ";
                    RecGProductionBalance."Expected Quantity" := RecGProdOrderRoutingLine."Input Quantity";
                    FctFindCapacityLedgerEntry2();
                    RecGProductionBalance.Quantity := RecGCapacityLedgerEntry."Output Quantity";
                    RecGProductionBalance."Unit of Measure Code" := RecGCapacityLedgerEntry."Cap. Unit of Measure Code";
                    RecGProductionBalance."Scrap Quantity" := RecGCapacityLedgerEntry."Scrap Quantity";
                    RecGProductionBalance."Expected Flushing Quantity" := RecGProdOrderRoutingLine."Expected Capacity Need";
                    RecGProductionBalance."Realized Flushing Quantity" := RecGCapacityLedgerEntry."Setup Time" + RecGCapacityLedgerEntry.
                "Run Time";
                    RecGProductionBalance."Cost Amount (Expected)" := RecGProdOrderRoutingLine."Expected Operation Cost Amt.";
                    RecGProductionBalance."Cost Amount (Actual)" := DecGDirectCost;
                    RecGProductionBalance."Cost Difference" := DecGDirectCost - RecGProdOrderRoutingLine."Expected Operation Cost Amt.";
                    if RecGProductionBalance."Expected Flushing Quantity" <> 0 then
                        RecGProductionBalance.Productivity := (1 - (RecGProductionBalance."Realized Flushing Quantity" -
                                          RecGProductionBalance."Expected Flushing Quantity") / RecGProductionBalance."Expected Flushing Quantity") *
                  100;
                    if RecGProductionBalance."Expected Quantity" <> 0 then
                        RecGProductionBalance.Output := RecGProductionBalance.Quantity / RecGProductionBalance."Expected Quantity" * 100;
                    RecGProductionBalance.Insert();
                end;

            until RecGProdOrderRoutingLine.Next() = 0;
        //>>FE_LAPIERRETTE_PRO06.002
        FctGetLastAmountsFromProdBal();
        //<<FE_LAPIERRETTE_PRO06.002
    end;


    procedure FctOrder()
    var
        RecLProdOrderLine: Record "Prod. Order Line";
        RecLTempProdOrderLine: Record "Prod. Order Line" temporary;
        RecLProductionBalance: Record "PWD Production Balance";
        IntL1: Integer;
    begin
        IntGI := 0;
        TxtGFilterPO2 := '';

        //>>* TDL_31/01/12: modification de la numérotation des OF
        /*
        IF EVALUATE(IntL1,CodGList) THEN
          TxtGFilterPO2 := FORMAT(IntL1)
        ELSE
          IF EVALUATE(IntL1,COPYSTR(CodGList,3,(STRLEN(CodGList) -2))) THEN
            TxtGFilterPO2 := COPYSTR(CodGList,3,(STRLEN(CodGList) -2));
        TxtGFilterPO2 := 'OF' + TxtGFilterPO2 + '*';
        */
        if Evaluate(IntL1, CodGList) then
            TxtGFilterPO2 := Format(IntL1)
        else
            if Evaluate(IntL1, CopyStr(CodGList, 3, 6)) then
                TxtGFilterPO2 := CopyStr(CodGList, 3, 6);
        TxtGFilterPO2 := TxtGFilterPO2 + '*';


        //<<* TDL_31/01/12: modification de la numérotation des OF
        //>>TDL_29_02_2012.001
        //Old RecGProdOrderLine.RESET;
        //Old RecGProdOrderLine.SETFILTER(Status,'%1..%2',RecGProdOrderLine.Status::Released,RecGProdOrderLine.Status::Finished);
        //Old RecGProdOrderLine.SETFILTER("Prod. Order No.",TxtGFilterPO2);
        RecGProductionOrder.Reset();
        RecGProductionOrder.SetFilter(Status, '%1..%2', RecGProdOrderLine.Status::Released, RecGProdOrderLine.Status::Finished);
        RecGProductionOrder.SetRange("PWD Original Source No.", CodGList);
        if RecGProductionOrder.FindFirst() then
            repeat
                RecLProdOrderLine.Reset();
                RecLProdOrderLine.SetFilter(Status, '%1..%2', RecGProdOrderLine.Status::Released, RecGProdOrderLine.Status::Finished);
                RecLProdOrderLine.SetRange("Prod. Order No.", RecGProductionOrder."No.");
                if ((DatGBeginDate <> 0D) or (DatGEndDate <> 0D)) then
                    RecLProdOrderLine.SetFilter("Due Date", '%1..%2', DatGBeginDate, DatGEndDate);
                if RecLProdOrderLine.FindFirst() then
                    repeat
                        RecLTempProdOrderLine.Copy(RecLProdOrderLine);
                        RecLTempProdOrderLine.Insert(false);
                    until RecLProdOrderLine.Next() = 0;
            until RecGProductionOrder.Next() = 0;




        //IF RecGProdOrderLine.FINDSET THEN REPEAT
        //  IF  TxtGFilterPO = '' THEN
        //    TxtGFilterPO := RecGProdOrderLine."Prod. Order No."
        //  ELSE
        //    TxtGFilterPO := TxtGFilterPO + '|' + RecGProdOrderLine."Prod. Order No.";
        //UNTIL RecGProdOrderLine.NEXT = 0;

        //<<TDL_29_02_2012.001

        RecLTempProdOrderLine.Reset();

        if RecLTempProdOrderLine.FindSet() then
            repeat
                RecGItem.Get(RecLTempProdOrderLine."Item No.");
                RecLProductionBalance.Reset();
                RecLProductionBalance.SetCurrentKey("User ID", "Planned Order Index");
                RecLProductionBalance.SetRange("User ID", UserId);

                //* Components Lines
                RecGProdOrderComponent.Reset();
                RecGProdOrderComponent.SetFilter(Status, '%1..%2', RecGProdOrderComponent.Status::Released, RecGProdOrderComponent.Status::Finished
              );
                RecGProdOrderComponent.SetFilter("Prod. Order No.", RecLTempProdOrderLine."Prod. Order No.");
                if RecGProdOrderComponent.FindSet() then
                    repeat
                        RecLProductionBalance.Reset();
                        RecLProductionBalance.SetCurrentKey("User ID", "Line Type", Type, "No.");
                        RecLProductionBalance.SetRange("User ID", UserId);
                        RecLProductionBalance.SetRange("Line Type", RecLProductionBalance."Line Type"::Component);
                        RecLProductionBalance.SetRange(Type, RecLProductionBalance.Type::Item);
                        RecLProductionBalance.SetRange("No.", RecGProdOrderComponent."Item No.");
                        RecLProductionBalance.SetRange("Item No.", RecLTempProdOrderLine."Item No.");
                        if RecLProductionBalance.FindFirst() then begin
                            RecLProductionBalance."Expected Quantity" := RecLProductionBalance."Expected Quantity" +
                                                                         RecGProdOrderComponent."Expected Quantity";
                            RecLProductionBalance."Cost Amount (Expected)" := RecLProductionBalance."Cost Amount (Expected)" +
                                                                              RecGProdOrderComponent."Direct Cost Amount";
                            RecLProductionBalance."Scrap Quantity" := RecLProductionBalance.Quantity - RecLProductionBalance."Expected Quantity";
                            RecLProductionBalance."Expected Flushing Quantity" := RecLProductionBalance."Expected Quantity";
                            RecLProductionBalance."Cost Difference" := RecLProductionBalance."Cost Amount (Actual)" -
                                                                       RecLProductionBalance."Cost Amount (Expected)";
                            RecLProductionBalance.Modify();
                        end else begin
                            IntGI := IntGI + 1;
                            RecGProductionBalance.Init();
                            RecGProductionBalance."User ID" := UserId;
                            RecGProductionBalance."Entry No." := IntGI;
                            RecGProductionBalance."Order No." := CodGList;
                            RecGProductionBalance."Item No." := RecLTempProdOrderLine."Item No.";
                            RecGProductionBalance."Line Type" := RecGProductionBalance."Line Type"::Component;
                            RecGProductionBalance.Type := RecGProductionBalance.Type::Item;
                            RecGProductionBalance."No." := RecGProdOrderComponent."Item No.";
                            RecGProductionBalance.Description := RecGProdOrderComponent.Description;
                            RecGProductionBalance.Status := RecGProductionBalance.Status::" ";
                            RecGProductionBalance."Expected Quantity" := RecGProdOrderComponent."Expected Quantity";
                            FctFindItemLedgerEntry2();
                            RecGProductionBalance.Quantity := -RecGItemLedgerEntry.Quantity;
                            RecGProductionBalance."Unit of Measure Code" := RecGProdOrderComponent."Unit of Measure Code";
                            RecGProductionBalance."Scrap Quantity" := RecGProductionBalance.Quantity - RecGProductionBalance."Expected Quantity";
                            RecGProductionBalance."Expected Flushing Quantity" := RecGProdOrderComponent."Expected Quantity";
                            RecGProductionBalance."Realized Flushing Quantity" := RecGProductionBalance.Quantity;
                            RecGProductionBalance."Cost Amount (Expected)" := RecGProdOrderComponent."Direct Cost Amount";
                            RecGProductionBalance."Cost Amount (Actual)" := -DecGCostAmountActual;
                            RecGProductionBalance."Cost Difference" := -DecGCostAmountActual - RecGProdOrderComponent."Direct Cost Amount";
                            RecGProductionBalance."Actual Cost MP" := -DecGCostAmountActual;
                            RecGProductionBalance."Unit Price" := RecGItem."Unit Price";
                            RecGProductionBalance."Planned Order Index" := CopyStr(RecLTempProdOrderLine."Prod. Order No.",
                                                                           (StrLen(RecLTempProdOrderLine."Prod. Order No.") - 1), 2);
                            RecGProductionBalance."Entry No. Negative" := -IntGI;
                            RecGProductionBalance.Insert();
                        end;

                    until RecGProdOrderComponent.Next() = 0;

                //* Operations Lines
                RecGProdOrderRoutingLine.Reset();
                RecGProdOrderRoutingLine.SetFilter(Status, '%1..%2', RecGProdOrderRoutingLine.Status::Released,
                                                                  RecGProdOrderRoutingLine.Status::Finished);
                //RecGProdOrderRoutingLine.SETFILTER("Prod. Order No.",TxtGFilterPO2);
                RecGProdOrderRoutingLine.SetFilter("Prod. Order No.", RecLTempProdOrderLine."Prod. Order No.");
                if RecGProdOrderRoutingLine.FindSet() then
                    repeat
                        RecLProductionBalance.Reset();
                        RecLProductionBalance.SetCurrentKey("User ID", "Line Type", "Operation No.", Type, "No.");
                        RecLProductionBalance.SetRange("User ID", UserId);
                        RecLProductionBalance.SetRange("Line Type", RecLProductionBalance."Line Type"::Operation);
                        RecLProductionBalance.SetRange("Operation No.", RecGProdOrderRoutingLine."Operation No.");
                        RecLProductionBalance.SetRange(Type, RecGProdOrderRoutingLine.Type);
                        RecLProductionBalance.SetRange("No.", RecGProdOrderRoutingLine."No.");
                        RecLProductionBalance.SetRange("Item No.", RecLTempProdOrderLine."Item No.");
                        if RecLProductionBalance.FindFirst() then begin
                            RecLProductionBalance."Expected Quantity" := RecLProductionBalance."Expected Quantity" +
                                                                         RecGProdOrderRoutingLine."Input Quantity";
                            RecLProductionBalance."Cost Amount (Expected)" := RecLProductionBalance."Cost Amount (Expected)" +
                                                                              RecGProdOrderRoutingLine."Expected Operation Cost Amt.";
                            RecLProductionBalance."Expected Flushing Quantity" := RecLProductionBalance."Expected Flushing Quantity" +
                                                                                  RecGProdOrderRoutingLine."Expected Capacity Need";
                            RecLProductionBalance."Cost Difference" := RecLProductionBalance."Cost Amount (Actual)" -
                                                                       RecLProductionBalance."Cost Amount (Expected)";
                            if RecLProductionBalance."Expected Flushing Quantity" <> 0 then
                                RecLProductionBalance.Productivity := (1 - (RecLProductionBalance."Realized Flushing Quantity" -
                                                  RecLProductionBalance."Expected Flushing Quantity") /
                                                  RecLProductionBalance."Expected Flushing Quantity") * 100;
                            if RecLProductionBalance."Expected Quantity" <> 0 then
                                RecLProductionBalance.Output := RecLProductionBalance.Quantity / RecLProductionBalance."Expected Quantity" * 100;

                            RecLProductionBalance.Modify();
                        end else begin
                            IntGI := IntGI + 1;
                            RecGProductionBalance.Init();
                            RecGProductionBalance."User ID" := UserId;
                            RecGProductionBalance."Entry No." := IntGI;
                            RecGProductionBalance."Order No." := CodGList;
                            RecGProductionBalance."Item No." := RecLTempProdOrderLine."Item No.";
                            RecGProductionBalance."Line Type" := RecGProductionBalance."Line Type"::Operation;
                            RecGProductionBalance."Operation No." := RecGProdOrderRoutingLine."Operation No.";
                            RecGProductionBalance.Type := RecGProdOrderRoutingLine.Type.AsInteger();
                            RecGProductionBalance."No." := RecGProdOrderRoutingLine."No.";
                            RecGProductionBalance.Description := RecGProdOrderRoutingLine.Description;
                            RecGProductionBalance.Status := RecGProductionBalance.Status::" ";
                            RecGProductionBalance."Expected Quantity" := RecGProdOrderRoutingLine."Input Quantity";
                            //>>TDL_29_02_2012.001
                            //Old FctFindCapacityLedgerEntry3;
                            FctFindTempCapacityLedgerEntry(RecLTempProdOrderLine);
                            //<<TDL_29_02_2012.001
                            RecGProductionBalance.Quantity := RecGCapacityLedgerEntry."Output Quantity";
                            RecGProductionBalance."Unit of Measure Code" := RecGCapacityLedgerEntry."Cap. Unit of Measure Code";
                            RecGProductionBalance."Scrap Quantity" := RecGCapacityLedgerEntry."Scrap Quantity";
                            RecGProductionBalance."Expected Flushing Quantity" := RecGProdOrderRoutingLine."Expected Capacity Need";
                            RecGProductionBalance."Realized Flushing Quantity" := RecGCapacityLedgerEntry."Setup Time" +
                                                                                  RecGCapacityLedgerEntry."Run Time";
                            RecGProductionBalance."Cost Amount (Expected)" := RecGProdOrderRoutingLine."Expected Operation Cost Amt.";
                            RecGProductionBalance."Cost Amount (Actual)" := DecGDirectCost;
                            RecGProductionBalance."Cost Difference" := DecGDirectCost - RecGProdOrderRoutingLine."Expected Operation Cost Amt.";
                            if RecGProductionBalance."Expected Flushing Quantity" <> 0 then
                                RecGProductionBalance.Productivity := (1 - (RecGProductionBalance."Realized Flushing Quantity" -
                                                  RecGProductionBalance."Expected Flushing Quantity") /
                                                  RecGProductionBalance."Expected Flushing Quantity") * 100;
                            if RecGProductionBalance."Expected Quantity" <> 0 then
                                RecGProductionBalance.Output := RecGProductionBalance.Quantity / RecGProductionBalance."Expected Quantity" * 100;
                            RecGProductionBalance."Unit Price" := RecGItem."Unit Price";
                            RecGProductionBalance."Planned Order Index" := CopyStr(RecLTempProdOrderLine."Prod. Order No.",
                                                                           (StrLen(RecLTempProdOrderLine."Prod. Order No.") - 1), 2);
                            RecGProductionBalance."Entry No. Negative" := -IntGI;
                            RecGProductionBalance.Insert();
                        end;

                    until RecGProdOrderRoutingLine.Next() = 0;
            until RecLTempProdOrderLine.Next() = 0;
        //>>FE_LAPIERRETTE_PRO06.002
        FctGetLastAmountsFromProdBal();
        /*
        "Production Balance".SETCURRENTKEY("User ID","Planned Order Index","Entry No. Negative");
        "Production Balance".ASCENDING(FALSE);
        IF "Production Balance".FINDLAST THEN BEGIN
          DecGLastExpectedQty := "Production Balance"."Expected Quantity";
          DecGLastQuantity := "Production Balance".Quantity;
          DecGLastUnitPrice := "Production Balance"."Unit Price";
          DecGLastAmountCost := "Production Balance"."Cost Amount (Actual)";
        END;
        */
        //<<FE_LAPIERRETTE_PRO06.002

    end;


    procedure FctFindItemLedgerEntry()
    begin
        DecGCostAmountActual := 0;
        RecGItemLedgerEntry.Reset();
        RecGItemLedgerEntry.SetCurrentKey("Order No.", "Order Line No.", "Entry Type", "Prod. Order Comp. Line No.");
        RecGItemLedgerEntry.SetRange("Order No.", RecGProdOrderComponent."Prod. Order No.");
        RecGItemLedgerEntry.SetRange("Order Line No.", RecGProdOrderComponent."Prod. Order Line No.");
        RecGItemLedgerEntry.SetRange("Entry Type", RecGItemLedgerEntry."Entry Type"::Consumption);
        RecGItemLedgerEntry.SetRange("Prod. Order Comp. Line No.", RecGProdOrderComponent."Line No.");
        if RecGItemLedgerEntry.FindSet() then
            repeat
                RecGItemLedgerEntry.CalcFields("Cost Amount (Actual)");
                DecGCostAmountActual := DecGCostAmountActual + RecGItemLedgerEntry."Cost Amount (Actual)";
            until RecGItemLedgerEntry.Next() = 0;
        if RecGItemLedgerEntry.FindSet() then
            RecGItemLedgerEntry.CalcSums(Quantity)
        else
            RecGItemLedgerEntry.Init();
    end;


    procedure FctFindProdOrderLine()
    begin
        RecGProdOrderLine.Reset();
        if OptGStatus = OptGStatus::Released then
            RecGProdOrderLine.SetRange(Status, RecGProdOrderLine.Status::Released)
        else
            if OptGStatus = OptGStatus::Finished then
                RecGProdOrderLine.SetRange(Status, RecGProdOrderLine.Status::Finished);
        RecGProdOrderLine.SetRange("Prod. Order No.", CodGList);
        if RecGProdOrderLine.FindSet() then
            RecGProdOrderLine.CalcSums(Quantity)
        else
            RecGProdOrderLine.Init();
    end;


    procedure FctFindCapacityLedgerEntry()
    begin
        RecGCapacityLedgerEntry.Reset();
        RecGCapacityLedgerEntry.SetCurrentKey("Order No.", "Order Line No.", "Routing No.", "Routing Reference No.",
                                              "Operation No.", "Last Output Line");
        RecGCapacityLedgerEntry.SetRange("Order No.", CodGList);
        if RecGCapacityLedgerEntry.FindSet() then begin
            RecGCapacityLedgerEntry.CalcSums("Output Quantity");
            RecGCapacityLedgerEntry.CalcSums("Scrap Quantity");
        end else
            RecGCapacityLedgerEntry.Init();
    end;


    procedure FctFindItemLedgerEntry2()
    begin
        RecGItemLedgerEntry.Reset();
        RecGItemLedgerEntry.SetCurrentKey("Item No.", "Order No.", "Entry Type");
        RecGItemLedgerEntry.SetRange("Item No.", RecGProdOrderComponent."Item No.");
        RecGItemLedgerEntry.SetFilter("Order No.", TxtGFilterPO);
        RecGItemLedgerEntry.SetRange("Entry Type", RecGItemLedgerEntry."Entry Type"::Consumption);
        DecGCostAmountActual := 0;
        if RecGItemLedgerEntry.FindSet() then
            repeat
                RecGItemLedgerEntry.CalcFields("Cost Amount (Actual)");
                DecGCostAmountActual := DecGCostAmountActual + RecGItemLedgerEntry."Cost Amount (Actual)";
            until RecGItemLedgerEntry.Next() = 0;
        if RecGItemLedgerEntry.FindSet() then
            RecGItemLedgerEntry.CalcSums(Quantity)
        else
            RecGItemLedgerEntry.Init();
    end;


    procedure FctFindCapacityLedgerEntry2()
    begin
        RecGCapacityLedgerEntry.Reset();
        RecGCapacityLedgerEntry.SetCurrentKey("Item No.", "Order No.", "Operation No.", Type, "No.");
        RecGCapacityLedgerEntry.SetRange("Item No.", CodGList);
        RecGCapacityLedgerEntry.SetFilter("Order No.", TxtGFilterPO);
        RecGCapacityLedgerEntry.SetRange("Operation No.", RecGProdOrderRoutingLine."Operation No.");
        RecGCapacityLedgerEntry.SetRange(Type, RecGProdOrderRoutingLine.Type);
        RecGCapacityLedgerEntry.SetRange("No.", RecGProdOrderRoutingLine."No.");
        DecGDirectCost := 0;
        if RecGCapacityLedgerEntry.FindSet() then
            repeat
                RecGCapacityLedgerEntry.CalcFields("Direct Cost");
                DecGDirectCost := DecGDirectCost + RecGCapacityLedgerEntry."Direct Cost";
            until RecGCapacityLedgerEntry.Next() = 0;
        if RecGCapacityLedgerEntry.FindSet() then begin
            RecGCapacityLedgerEntry.CalcSums("Output Quantity");
            RecGCapacityLedgerEntry.CalcSums("Scrap Quantity");
            RecGCapacityLedgerEntry.CalcSums("Setup Time");
            RecGCapacityLedgerEntry.CalcSums("Run Time");
        end else
            RecGCapacityLedgerEntry.Init();
    end;


    procedure FctFindCapacityLedgerEntry3()
    begin
        RecGCapacityLedgerEntry.Reset();
        RecGCapacityLedgerEntry.SetCurrentKey("Item No.", "Order No.", "Operation No.", Type, "No.");
        RecGCapacityLedgerEntry.SetRange("Item No.", RecGProdOrderLine."Item No.");
        RecGCapacityLedgerEntry.SetFilter("Order No.", TxtGFilterPO);
        RecGCapacityLedgerEntry.SetRange("Operation No.", RecGProdOrderRoutingLine."Operation No.");
        RecGCapacityLedgerEntry.SetRange(Type, RecGProdOrderRoutingLine.Type);
        RecGCapacityLedgerEntry.SetRange("No.", RecGProdOrderRoutingLine."No.");
        DecGDirectCost := 0;
        if RecGCapacityLedgerEntry.FindSet() then
            repeat
                RecGCapacityLedgerEntry.CalcFields("Direct Cost");
                DecGDirectCost := DecGDirectCost + RecGCapacityLedgerEntry."Direct Cost";
            until RecGCapacityLedgerEntry.Next() = 0;
        if RecGCapacityLedgerEntry.FindSet() then begin
            RecGCapacityLedgerEntry.CalcSums("Output Quantity");
            RecGCapacityLedgerEntry.CalcSums("Scrap Quantity");
            RecGCapacityLedgerEntry.CalcSums("Setup Time");
            RecGCapacityLedgerEntry.CalcSums("Run Time");
        end else
            RecGCapacityLedgerEntry.Init();
    end;


    procedure FctFindTempCapacityLedgerEntry(RecPprodOrderLine: Record "Prod. Order Line")
    begin
        RecGCapacityLedgerEntry.Reset();
        RecGCapacityLedgerEntry.SetCurrentKey("Item No.", "Order No.", "Operation No.", Type, "No.");
        RecGCapacityLedgerEntry.SetRange("Item No.", RecPprodOrderLine."Item No.");
        RecGCapacityLedgerEntry.SetFilter("Order No.", TxtGFilterPO);
        RecGCapacityLedgerEntry.SetRange("Operation No.", RecGProdOrderRoutingLine."Operation No.");
        RecGCapacityLedgerEntry.SetRange(Type, RecGProdOrderRoutingLine.Type);
        RecGCapacityLedgerEntry.SetRange("No.", RecGProdOrderRoutingLine."No.");
        DecGDirectCost := 0;
        if RecGCapacityLedgerEntry.FindSet() then
            repeat
                RecGCapacityLedgerEntry.CalcFields("Direct Cost");
                DecGDirectCost := DecGDirectCost + RecGCapacityLedgerEntry."Direct Cost";
            until RecGCapacityLedgerEntry.Next() = 0;
        if RecGCapacityLedgerEntry.FindSet() then begin
            RecGCapacityLedgerEntry.CalcSums("Output Quantity");
            RecGCapacityLedgerEntry.CalcSums("Scrap Quantity");
            RecGCapacityLedgerEntry.CalcSums("Setup Time");
            RecGCapacityLedgerEntry.CalcSums("Run Time");
        end else
            RecGCapacityLedgerEntry.Init();
    end;


    procedure FctCalcProductivityTot(): Decimal
    begin
        RecGProductionBalance.CalcFields(RecGProductionBalance."Realized Flushing Quantity Tot",
        RecGProductionBalance."Expected Flushing Quantity Tot");
        //EXIT((1-(RecGProductionBalance."Realized Flushing Quantity Tot"-RecGProductionBalance."Expected Flushing Quantity Tot")
        ///RecGProductionBalance."Expected Flushing Quantity Tot")*100);
        if RecGProductionBalance."Expected Flushing Quantity Tot" <> 0 then
            exit((1 - (RecGProductionBalance."Realized Flushing Quantity Tot" -
              RecGProductionBalance."Expected Flushing Quantity Tot") / RecGProductionBalance."Expected Flushing Quantity Tot") * 100)
        else
            exit(100);
    end;


    procedure FctGetLastAmountsFromProdBal()
    var
        RecLProductionBalance: Record "PWD Production Balance";
    begin
        RecLProductionBalance.SetCurrentKey("User ID", "Planned Order Index", "Entry No. Negative");
        RecLProductionBalance.SetRange(RecLProductionBalance."Line Type", RecLProductionBalance."Line Type"::Operation);
        RecLProductionBalance.Ascending(false);
        if RecLProductionBalance.FindLast() then begin
            DecGLastExpectedQty := RecLProductionBalance."Expected Quantity";
            DecGLastQuantity := RecLProductionBalance.Quantity;
            DecGLastUnitPrice := RecLProductionBalance."Unit Price";
            DecGLastAmountCost := RecLProductionBalance."Cost Amount (Actual)";
        end;
    end;
}

