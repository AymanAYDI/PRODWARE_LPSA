report 50070 "PWD Customer - Order Detail"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/CustomerOrderDetail.rdl';
    ApplicationArea = All;
    Caption = 'Customer - Order Detail';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Customer; Customer)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", Priority;
            column(ShipmentPeriodDate; StrSubstNo(Text000, PeriodText))
            {
            }
            column(CompanyName; COMPANYPROPERTY.DisplayName())
            {
            }
            column(PrintAmountsInLCY; PrintAmountsInLCY)
            {
            }
            column(CustTableCapCustFilter; TableCaption + ': ' + CustFilter)
            {
            }
            column(CustFilter; CustFilter)
            {
            }
            column(SalesOrderLineFilter; StrSubstNo(Text001, SalesLineFilter))
            {
            }
            column(SalesLineFilter; SalesLineFilter)
            {
            }
            column(No_Customer; "No.")
            {
                IncludeCaption = true;
            }
            column(Name_Customer; Name)
            {
            }
            column(PageGroupNo; PageGroupNo)
            {
            }
            column(CustOrderDetailCaption; CustOrderDetailCaptionLbl)
            {
            }
            column(PageCaption; PageCaptionLbl)
            {
            }
            column(AllAmtAreInLCYCaption; AllAmtAreInLCYCaptionLbl)
            {
            }
            column(ShipmentDateCaption; ShipmentDateCaptionLbl)
            {
            }
            column(QtyOnBackOrderCaption; QtyOnBackOrderCaptionLbl)
            {
            }
            column(OutstandingOrdersCaption; OutstandingOrdersCaptionLbl)
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Bill-to Customer No." = FIELD("No."), "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                DataItemTableView = SORTING("Document Type", "Bill-to Customer No.", "Currency Code") WHERE("Document Type" = CONST(Order), "Outstanding Quantity" = FILTER(<> 0));
                RequestFilterFields = "Shipment Date";
                RequestFilterHeading = 'Sales Order Line';
                column(SalesHeaderNo; SalesHeader."No.")
                {
                }
                column(SalesHeaderNoCaption; SalesHeader.FieldCaption("No."))
                {
                }

                column(SalesHeaderOrderDate; SalesHeader."Order Date")
                {
                }
                column(Description_SalesLine; Description)
                {
                    IncludeCaption = true;
                }
                column(Description_SalesLineCaption; FieldCaption(Description))
                {
                }

                column(No_SalesLine; "No.")
                {
                    IncludeCaption = true;
                }
                column(No_SalesLineCaption; FieldCaption("No."))
                {
                }
                column(Type_SalesLine; Type)
                {
                    IncludeCaption = true;
                }
                column(Type_SalesLineCaption; FieldCaption(Type))
                {
                }
                column(ShipmentDate_SalesLine; Format("Shipment Date"))
                {
                }
                column(ShipmentDate_SalesLineCaption; FieldCaption("Shipment Date"))
                {
                }
                column(Quantity_SalesLine; Quantity)
                {
                    IncludeCaption = true;
                }
                column(OutStandingQty_SalesLine; "Outstanding Quantity")
                {
                    IncludeCaption = true;
                }
                column(BackOrderQty; BackOrderQty)
                {
                    DecimalPlaces = 0 : 5;
                }
                column(UnitPrice_SalesLine; "Unit Price")
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 2;
                    IncludeCaption = true;
                }
                column(UnitPrice_SalesLineCaption; FieldCaption("Unit Price"))
                {
                }
                column(LineDiscAmt_SalesLine; "Line Discount Amount")
                {
                    IncludeCaption = true;
                }
                column(LineDiscAmt_SalesLineCaption; FieldCaption("Line Discount Amount"))
                {
                }
                column(InvDiscAmt_SalesLine; "Inv. Discount Amount")
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 2;
                    IncludeCaption = true;
                }
                column(InvDiscAmt_SalesLineCaption; FieldCaption("Inv. Discount Amount"))
                {
                }
                column(SalesOrderAmount; SalesOrderAmount)
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                }
                column(SalesHeaderCurrCode; SalesHeader."Currency Code")
                {
                }
                column(RecGItemSearchDescription; RecGItem."Search Description")
                {

                }
                column(RecGItemSearchDescriptionCaption; RecGItem.FieldCaption("Search Description"))
                {

                }



                trigger OnAfterGetRecord()
                begin
                    NewOrder := "Document No." <> SalesHeader."No.";
                    if NewOrder then
                        SalesHeader.Get(1, "Document No.");
                    if "Shipment Date" <= WorkDate() then
                        BackOrderQty := "Outstanding Quantity"
                    else
                        BackOrderQty := 0;
                    Currency.InitRoundingPrecision();
                    if "VAT Calculation Type" in ["VAT Calculation Type"::"Normal VAT", "VAT Calculation Type"::"Reverse Charge VAT"] then
                        SalesOrderAmount :=
                          Round(
                            (Amount + "VAT Base Amount" * "VAT %" / 100) * "Outstanding Quantity" / Quantity / (1 + "VAT %" / 100),
                            Currency."Amount Rounding Precision")
                    else
                        SalesOrderAmount :=
                          Round(
                            "Outstanding Amount" / (1 + "VAT %" / 100),
                            Currency."Amount Rounding Precision");
                    SalesOrderAmountLCY := SalesOrderAmount;
                    if SalesHeader."Currency Code" <> '' then begin
                        if SalesHeader."Currency Factor" <> 0 then
                            SalesOrderAmountLCY :=
                              Round(
                                CurrExchRate.ExchangeAmtFCYToLCY(
                                  WorkDate(), SalesHeader."Currency Code",
                                  SalesOrderAmountLCY, SalesHeader."Currency Factor"));
                        if PrintAmountsInLCY then begin
                            "Unit Price" :=
                              Round(
                                CurrExchRate.ExchangeAmtFCYToLCY(
                                  WorkDate(), SalesHeader."Currency Code",
                                  "Unit Price", SalesHeader."Currency Factor"));
                            SalesOrderAmount := SalesOrderAmountLCY;
                        end;
                    end;
                    if SalesHeader."Prices Including VAT" then begin
                        "Unit Price" := "Unit Price" / (1 + "VAT %" / 100);
                        "Inv. Discount Amount" := "Inv. Discount Amount" / (1 + "VAT %" / 100);
                    end;
                    "Inv. Discount Amount" := "Inv. Discount Amount" * "Outstanding Quantity" / Quantity;
                    CurrencyCode2 := SalesHeader."Currency Code";
                    if PrintAmountsInLCY then
                        CurrencyCode2 := '';
                    CurrencyTotalBuffer.UpdateTotal(
                      CurrencyCode2,
                      SalesOrderAmount,
                      Counter1,
                      Counter1);
                    //>>LAP2.12
                    IF ("Sales Line".Type <> "Sales Line".Type::Item) OR
                       (NOT RecGItem.GET("Sales Line"."No.")) THEN
                        RecGItem.INIT();
                    //<<LAP2.12
                end;

                trigger OnPreDataItem()
                begin
                    Clear(SalesOrderAmountLCY);
                    Clear(SalesOrderAmount);
                end;
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                column(TotalAmt_CurrTotalBuff; CurrencyTotalBuffer."Total Amount")
                {
                    AutoFormatExpression = CurrencyTotalBuffer."Currency Code";
                    AutoFormatType = 1;
                }
                column(CurrCode_CurrTotalBuff; CurrencyTotalBuffer."Currency Code")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                        OK := CurrencyTotalBuffer.Find('-')
                    else
                        OK := CurrencyTotalBuffer.Next() <> 0;
                    if not OK then
                        CurrReport.Break();

                    CurrencyTotalBuffer2.UpdateTotal(
                      CurrencyTotalBuffer."Currency Code",
                      CurrencyTotalBuffer."Total Amount",
                      Counter1,
                      Counter1);
                end;

                trigger OnPostDataItem()
                begin
                    CurrencyTotalBuffer.DeleteAll();
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if PrintOnlyOnePerPage then
                    PageGroupNo := PageGroupNo + 1;
            end;

            trigger OnPreDataItem()
            begin
                PageGroupNo := 1;
                Clear(SalesOrderAmountLCY);
            end;
        }
        dataitem(Integer2; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
            column(TotalAmt_CurrTotalBuff2; CurrencyTotalBuffer2."Total Amount")
            {
                AutoFormatExpression = CurrencyTotalBuffer2."Currency Code";
                AutoFormatType = 1;
            }
            column(CurrCode_CurrTotalBuff2; CurrencyTotalBuffer2."Currency Code")
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then
                    OK := CurrencyTotalBuffer2.Find('-')
                else
                    OK := CurrencyTotalBuffer2.Next() <> 0;
                if not OK then
                    CurrReport.Break();
            end;

            trigger OnPostDataItem()
            begin
                CurrencyTotalBuffer2.DeleteAll();
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ShowAmountsInLCYF; PrintAmountsInLCY)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Amounts in LCY';
                    }
                    field(NewPagePerCustomerF; PrintOnlyOnePerPage)
                    {
                        ApplicationArea = All;
                        Caption = 'New Page per Customer';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        OrderNoCaption = 'Order No.';
    }

    trigger OnPreReport()
    var
        FormatDocument: Codeunit "Format Document";
    begin
        CustFilter := FormatDocument.GetRecordFiltersWithCaptions(Customer);
        SalesLineFilter := "Sales Line".GetFilters;
        PeriodText := "Sales Line".GetFilter("Shipment Date");
    end;

    var
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        CurrencyTotalBuffer: Record "Currency Total Buffer" temporary;
        CurrencyTotalBuffer2: Record "Currency Total Buffer" temporary;
        RecGItem: Record Item;
        SalesHeader: Record "Sales Header";
        NewOrder: Boolean;
        OK: Boolean;
        PrintAmountsInLCY: Boolean;
        PrintOnlyOnePerPage: Boolean;
        CurrencyCode2: Code[10];
        BackOrderQty: Decimal;
        SalesOrderAmount: Decimal;
        SalesOrderAmountLCY: Decimal;
        Counter1: Integer;
        PageGroupNo: Integer;
        AllAmtAreInLCYCaptionLbl: Label 'All amounts are in LCY';
        CustOrderDetailCaptionLbl: Label 'Customer - Order Detail';
        OutstandingOrdersCaptionLbl: Label 'Outstanding Orders';
        PageCaptionLbl: Label 'Page';
        QtyOnBackOrderCaptionLbl: Label 'Quantity on Back Order';
        ShipmentDateCaptionLbl: Label 'Shipment Date';
        Text000: Label 'Shipment Date: %1';
        Text001: Label 'Sales Order Line: %1';
        TotalCaptionLbl: Label 'Total';
        CustFilter: Text;
        PeriodText: Text;
        SalesLineFilter: Text;

    procedure InitializeRequest(ShowAmountInLCY: Boolean; NewPagePerCustomer: Boolean)
    begin
        PrintAmountsInLCY := ShowAmountInLCY;
        PrintOnlyOnePerPage := NewPagePerCustomer;
    end;
}

