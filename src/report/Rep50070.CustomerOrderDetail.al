report 50070 "PWD Customer - Order Detail"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>TDL.001
    // TDL.001: ONSITE 29/06/2012:  Modifications
    //                                           - Add External Doc No.
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 12/09/2017 : DEMANDES DIVERSES
    //                        Add C/AL Globals RecGItem
    //                        Add C/AL Code in triggers Sales Line - OnAfterGetRecord()
    //                                                  MakeExcelDataHeader()
    //                                                  MakeExcelDataBody()
    //                        Modif Section/Layout
    // 
    // ------------------------------------------------------------------------------------------------------------------
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/CustomerOrderDetail.rdl';
    Caption = 'Customer - Order Detail';
    PreviewMode = PrintLayout;
    UsageCategory = None;

    dataset
    {
        dataitem(Customer; Customer)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", Priority;
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(STRSUBSTNO_Text000_PeriodText_; STRSUBSTNO(Text000, PeriodText))
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO())
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column("USERID"; USERID)
            {
            }
            column(PrintAmountsInLCY; PrintAmountsInLCY)
            {
            }
            column(PrintOnlyOnePerPage; PrintOnlyOnePerPage)
            {
            }
            column(Customer_TABLECAPTION__________CustFilter; Customer.TABLECAPTION + ': ' + CustFilter)
            {
            }
            column(CustFilter; CustFilter)
            {
            }
            column(STRSUBSTNO_Text001_SalesLineFilter_; STRSUBSTNO(Text001, SalesLineFilter))
            {
            }
            column(SalesLineFilter; SalesLineFilter)
            {
            }
            column(RecGItemSearchDescriptionCaption; RecGItem.FIELDCAPTION("Search Description"))
            {
            }
            column(Customer__No__; "No.")
            {
            }
            column(Customer_Name; Name)
            {
            }
            column(PageGroupNo; PageGroupNo)
            {
            }
            column(Customer___Order_DetailCaption; Customer___Order_DetailCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(All_amounts_are_in_LCYCaption; All_amounts_are_in_LCYCaptionLbl)
            {
            }
            column(Sales_Line__Shipment_Date__Control34Caption; Sales_Line__Shipment_Date__Control34CaptionLbl)
            {
            }
            column(Sales_Line_Type_Control35Caption; "Sales Line".FIELDCAPTION(Type))
            {
            }
            column(Sales_Line__No___Control36Caption; "Sales Line".FIELDCAPTION("No."))
            {
            }
            column(Sales_Line_Description_Control37Caption; "Sales Line".FIELDCAPTION(Description))
            {
            }
            column(Sales_Line_Quantity_Control38Caption; "Sales Line".FIELDCAPTION(Quantity))
            {
            }
            column(Sales_Line__Outstanding_Quantity__Control39Caption; "Sales Line".FIELDCAPTION("Outstanding Quantity"))
            {
            }
            column(BackOrderQty_Control40Caption; BackOrderQty_Control40CaptionLbl)
            {
            }
            column(Sales_Line__Unit_Price__Control41Caption; "Sales Line".FIELDCAPTION("Unit Price"))
            {
            }
            column(Sales_Line__Line_Discount_Amount__Control42Caption; "Sales Line".FIELDCAPTION("Line Discount Amount"))
            {
            }
            column(Sales_Line__Inv__Discount_Amount__Control43Caption; "Sales Line".FIELDCAPTION("Inv. Discount Amount"))
            {
            }
            column(SalesOrderAmount_Control44Caption; SalesOrderAmount_Control44CaptionLbl)
            {
            }
            column(Customer_Global_Dimension_1_Filter; "Global Dimension 1 Filter")
            {
            }
            column(Customer_Global_Dimension_2_Filter; "Global Dimension 2 Filter")
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Bill-to Customer No." = FIELD("No."),
                               "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                               "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                DataItemTableView = SORTING("Document Type", "Bill-to Customer No.", "Currency Code")
                                    WHERE("Document Type" = CONST(Order),
                                          "Outstanding Quantity" = FILTER(<> 0));
                RequestFilterFields = "Shipment Date";
                RequestFilterHeading = 'Sales Order Line';
                column(SalesHeader__No__; SalesHeader."No.")
                {
                }
                column(SalesHeader__Order_Date_; SalesHeader."Order Date")
                {
                }
                column(Sales_Line_Description; Description)
                {
                }
                column(Sales_Line__No__; "No.")
                {
                }
                column(Sales_Line_Type; Type)
                {
                }
                column(Sales_Line__Shipment_Date_; FORMAT("PWD Cust Promis. Delivery Date"))
                {
                }
                column(Sales_Line_Quantity; Quantity)
                {
                }
                column(Sales_Line__Outstanding_Quantity_; "Outstanding Quantity")
                {
                }
                column(BackOrderQty; BackOrderQty)
                {
                    DecimalPlaces = 0 : 5;
                }
                column(Sales_Line__Unit_Price_; "Unit Price")
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 2;
                }
                column(Sales_Line__Line_Discount_Amount_; "Line Discount Amount")
                {
                }
                column(Sales_Line__Inv__Discount_Amount_; "Inv. Discount Amount")
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 2;
                }
                column(SalesOrderAmount; SalesOrderAmount)
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                }
                column(RecGItemSearchDescription; RecGItem."Search Description")
                {
                }
                column(Sales_Line__Shipment_Date__Control59; "PWD Cust Promis. Delivery Date")
                {
                }
                column(Sales_Line_Type_Control60; Type)
                {
                }
                column(Sales_Line__No___Control61; "No.")
                {
                }
                column(Sales_Line_Description_Control62; Description)
                {
                }
                column(Sales_Line_Quantity_Control63; Quantity)
                {
                }
                column(Sales_Line__Outstanding_Quantity__Control64; "Outstanding Quantity")
                {
                }
                column(BackOrderQty_Control65; BackOrderQty)
                {
                    DecimalPlaces = 0 : 5;
                }
                column(Sales_Line__Unit_Price__Control66; "Unit Price")
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 2;
                }
                column(Sales_Line__Line_Discount_Amount__Control67; "Line Discount Amount")
                {
                }
                column(Sales_Line__Inv__Discount_Amount__Control68; "Inv. Discount Amount")
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                }
                column(SalesOrderAmount_Control69; SalesOrderAmount)
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                }
                column(Sales_Line__Shipment_Date__Control34; FORMAT("PWD Cust Promis. Delivery Date"))
                {
                }
                column(Sales_Line_Type_Control35; Type)
                {
                }
                column(Sales_Line__No___Control36; "No.")
                {
                }
                column(SalesHeader__No___Control32; SalesHeader."No.")
                {
                }
                column(Sales_Line_Description_Control37; Description)
                {
                }
                column(SalesHeader__Order_Date__Control33; SalesHeader."Order Date")
                {
                }
                column(Sales_Line_Quantity_Control38; Quantity)
                {
                }
                column(Sales_Line__Outstanding_Quantity__Control39; "Outstanding Quantity")
                {
                }
                column(BackOrderQty_Control40; BackOrderQty)
                {
                    DecimalPlaces = 0 : 5;
                }
                column(Sales_Line__Unit_Price__Control41; "Unit Price")
                {
                    AutoFormatExpression = SalesHeader."Currency Code";
                    AutoFormatType = 2;
                }
                column(Sales_Line__Line_Discount_Amount__Control42; "Line Discount Amount")
                {
                }
                column(Sales_Line__Inv__Discount_Amount__Control43; "Inv. Discount Amount")
                {
                    AutoFormatExpression = SalesHeader."Currency Code";
                    AutoFormatType = 1;
                }
                column(SalesOrderAmount_Control44; SalesOrderAmount)
                {
                    AutoFormatExpression = SalesHeader."Currency Code";
                    AutoFormatType = 1;
                }
                column(SalesHeader__Currency_Code_; SalesHeader."Currency Code")
                {
                }
                column(Sales_Line__Shipment_Date__Control45; FORMAT("PWD Cust Promis. Delivery Date"))
                {
                }
                column(Sales_Line_Type_Control46; Type)
                {
                }
                column(Sales_Line__No___Control47; "No.")
                {
                }
                column(Sales_Line_Description_Control48; Description)
                {
                }
                column(Sales_Line_Quantity_Control49; Quantity)
                {
                }
                column(Sales_Line__Outstanding_Quantity__Control50; "Outstanding Quantity")
                {
                }
                column(BackOrderQty_Control51; BackOrderQty)
                {
                    DecimalPlaces = 0 : 5;
                }
                column(Sales_Line__Unit_Price__Control52; "Unit Price")
                {
                    AutoFormatExpression = SalesHeader."Currency Code";
                    AutoFormatType = 2;
                }
                column(Sales_Line__Line_Discount_Amount__Control53; "Line Discount Amount")
                {
                }
                column(Sales_Line__Inv__Discount_Amount__Control54; "Inv. Discount Amount")
                {
                    AutoFormatExpression = SalesHeader."Currency Code";
                    AutoFormatType = 1;
                }
                column(SalesOrderAmount_Control55; SalesOrderAmount)
                {
                    AutoFormatExpression = SalesHeader."Currency Code";
                    AutoFormatType = 1;
                }
                column(SalesHeader__Currency_Code__Control26; SalesHeader."Currency Code")
                {
                }
                column(SalesHeader__No__Caption; SalesHeader__No__CaptionLbl)
                {
                }
                column(SalesHeader__No___Control32Caption; SalesHeader__No___Control32CaptionLbl)
                {
                }
                column(Sales_Line_Document_Type; "Document Type")
                {
                }
                column(Sales_Line_Document_No_; "Document No.")
                {
                }
                column(Sales_Line_Line_No_; "Line No.")
                {
                }
                column(Sales_Line_Bill_to_Customer_No_; "Bill-to Customer No.")
                {
                }
                column(Sales_Line_Shortcut_Dimension_1_Code; "Shortcut Dimension 1 Code")
                {
                }
                column(Sales_Line_Shortcut_Dimension_2_Code; "Shortcut Dimension 2 Code")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    NewOrder := "Document No." <> SalesHeader."No.";
                    IF NewOrder THEN
                        SalesHeader.GET(1, "Document No.");
                    IF "Shipment Date" <= WORKDATE() THEN
                        BackOrderQty := "Outstanding Quantity"
                    ELSE
                        BackOrderQty := 0;
                    SalesOrderAmount := "Outstanding Amount" / (1 + "VAT %" / 100);
                    SalesOrderAmountLCY := SalesOrderAmount;
                    IF SalesHeader."Currency Code" <> '' THEN BEGIN
                        IF SalesHeader."Currency Factor" <> 0 THEN
                            SalesOrderAmountLCY :=
                              ROUND(
                                CurrExchRate.ExchangeAmtFCYToLCY(
                                  WORKDATE(), SalesHeader."Currency Code",
                                  SalesOrderAmountLCY, SalesHeader."Currency Factor"));
                        IF PrintAmountsInLCY THEN BEGIN
                            "Unit Price" :=
                              ROUND(
                                CurrExchRate.ExchangeAmtFCYToLCY(
                                  WORKDATE(), SalesHeader."Currency Code",
                                  "Unit Price", SalesHeader."Currency Factor"));
                            SalesOrderAmount := SalesOrderAmountLCY;
                        END;
                    END;
                    IF SalesHeader."Prices Including VAT" THEN BEGIN
                        "Unit Price" := "Unit Price" / (1 + "VAT %" / 100);
                        "Inv. Discount Amount" := "Inv. Discount Amount" / (1 + "VAT %" / 100);
                    END;
                    "Inv. Discount Amount" := "Inv. Discount Amount" * "Outstanding Quantity" / Quantity;
                    CurrencyCode2 := SalesHeader."Currency Code";
                    IF PrintAmountsInLCY THEN
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

                    IF PrintToExcel THEN
                        MakeExcelDataBody();
                end;

                trigger OnPreDataItem()
                begin
                    CurrReport.CREATETOTALS(SalesOrderAmountLCY, SalesOrderAmount);
                end;
            }
            dataitem(DataItem5444; Integer)
            {
                DataItemTableView = SORTING(Number)
                                    WHERE(Number = FILTER(1 ..));
                column(Customer_Name_Control56; Customer.Name)
                {
                }
                column(CurrencyTotalBuffer__Total_Amount_; CurrencyTotalBuffer."Total Amount")
                {
                    AutoFormatExpression = CurrencyTotalBuffer."Currency Code";
                    AutoFormatType = 1;
                }
                column(CurrencyTotalBuffer__Total_Amount__Control27; CurrencyTotalBuffer."Total Amount")
                {
                    AutoFormatExpression = CurrencyTotalBuffer."Currency Code";
                    AutoFormatType = 1;
                }
                column(CurrencyTotalBuffer__Currency_Code_; CurrencyTotalBuffer."Currency Code")
                {
                }
                column(Customer_Name_Control58; Customer.Name)
                {
                }
                column(Integer_Number; Number)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    IF Number = 1 THEN
                        OK := CurrencyTotalBuffer.FIND('-')
                    ELSE
                        OK := CurrencyTotalBuffer.NEXT() <> 0;
                    IF NOT OK THEN
                        CurrReport.BREAK();

                    CurrencyTotalBuffer2.UpdateTotal(
                      CurrencyTotalBuffer."Currency Code",
                      CurrencyTotalBuffer."Total Amount",
                      Counter1,
                      Counter1);
                end;

                trigger OnPostDataItem()
                begin
                    CurrencyTotalBuffer.DELETEALL();
                end;
            }

            trigger OnAfterGetRecord()
            begin
                IF PrintOnlyOnePerPage THEN
                    PageGroupNo := PageGroupNo + 1;
            end;

            trigger OnPreDataItem()
            begin
                PageGroupNo := 1;
                CurrReport.NEWPAGEPERRECORD := PrintOnlyOnePerPage;
                CurrReport.CREATETOTALS(SalesOrderAmountLCY);
            end;
        }
        dataitem(Integer2; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = FILTER(1 ..));
            column(CurrencyTotalBuffer2__Total_Amount_; CurrencyTotalBuffer2."Total Amount")
            {
                AutoFormatExpression = CurrencyTotalBuffer2."Currency Code";
                AutoFormatType = 1;
            }
            column(CurrencyTotalBuffer2__Total_Amount__Control29; CurrencyTotalBuffer2."Total Amount")
            {
                AutoFormatExpression = CurrencyTotalBuffer2."Currency Code";
                AutoFormatType = 1;
            }
            column(CurrencyTotalBuffer2__Currency_Code_; CurrencyTotalBuffer2."Currency Code")
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(TotalCaption_Control28; TotalCaption_Control28Lbl)
            {
            }
            column(Integer2_Number; Number)
            {
            }

            trigger OnAfterGetRecord()
            begin
                IF Number = 1 THEN
                    OK := CurrencyTotalBuffer2.FIND('-')
                ELSE
                    OK := CurrencyTotalBuffer2.NEXT() <> 0;
                IF NOT OK THEN
                    CurrReport.BREAK();
            end;

            trigger OnPostDataItem()
            begin
                CurrencyTotalBuffer2.DELETEALL();
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
                    field(PrintAmountsInLCY; PrintAmountsInLCY)
                    {
                        Caption = 'Show Amounts in LCY';
                    }
                    field(PrintOnlyOnePerPage; PrintOnlyOnePerPage)
                    {
                        Caption = 'New Page per Customer';
                    }
                    field(PrintToExcel; PrintToExcel)
                    {
                        Caption = 'Print to Excel';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            PrintToExcel := FALSE;
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        IF PrintToExcel THEN
            CreateExcelbook();
    end;

    trigger OnPreReport()
    begin
        CustFilter := Customer.GETFILTERS;
        SalesLineFilter := "Sales Line".GETFILTERS;
        PeriodText := "Sales Line".GETFILTER("Shipment Date");

        IF PrintToExcel THEN
            MakeExcelInfo();
    end;

    var
        CurrExchRate: Record "Currency Exchange Rate";
        CurrencyTotalBuffer: Record "Currency Total Buffer" temporary;
        CurrencyTotalBuffer2: Record "Currency Total Buffer" temporary;
        SalesHeader: Record "Sales Header";
        ExcelBuf: Record "Excel Buffer" temporary;
        RecGItem: Record "Item";
        CustFilter: Text[250];
        SalesLineFilter: Text[250];
        SalesOrderAmount: Decimal;
        SalesOrderAmountLCY: Decimal;
        PrintAmountsInLCY: Boolean;
        PeriodText: Text[30];
        PrintOnlyOnePerPage: Boolean;
        BackOrderQty: Decimal;
        Text000: Label 'Shipment Date: %1';
        Text001: Label 'Sales Order Line: %1';
        NewOrder: Boolean;
        OK: Boolean;
        Counter1: Integer;
        CurrencyCode2: Code[10];
        PrintToExcel: Boolean;
        Text003: Label 'Customer - Order Detail';
        Text004: Label 'Company Name';
        Text005: Label 'Report No.';
        Text006: Label 'Report Name';
        Text007: Label 'User ID';
        Text008: Label 'Date';
        Text009: Label 'Customer Filters';
        Text010: Label 'Sales Order Lines Filters';
        Text013: Label 'All amounts are in LCY';
        PageGroupNo: Integer;
        Customer___Order_DetailCaptionLbl: Label 'Customer - Order Detail';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        All_amounts_are_in_LCYCaptionLbl: Label 'All amounts are in LCY';
        Sales_Line__Shipment_Date__Control34CaptionLbl: Label 'Shipment Date';
        BackOrderQty_Control40CaptionLbl: Label 'Quantity on Back Order';
        SalesOrderAmount_Control44CaptionLbl: Label 'Outstanding Orders';
        SalesHeader__No__CaptionLbl: Label 'Order No.';
        SalesHeader__No___Control32CaptionLbl: Label 'Order No.';
        TotalCaptionLbl: Label 'Total';
        TotalCaption_Control28Lbl: Label 'Total';

    procedure MakeExcelInfo()
    begin
        ExcelBuf.SetUseInfoSheet();
        ExcelBuf.AddInfoColumn(FORMAT(Text004), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(COMPANYNAME, FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow();
        ExcelBuf.AddInfoColumn(FORMAT(Text006), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(FORMAT(Text003), FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow();
        ExcelBuf.AddInfoColumn(FORMAT(Text005), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(REPORT::"PWD Customer - Order Detail", FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow();
        ExcelBuf.AddInfoColumn(FORMAT(Text007), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(USERID, FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow();
        ExcelBuf.AddInfoColumn(FORMAT(Text008), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(TODAY, FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow();
        ExcelBuf.AddInfoColumn(FORMAT(Text009), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(Customer.GETFILTERS, FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow();
        ExcelBuf.AddInfoColumn(FORMAT(Text010), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn("Sales Line".GETFILTERS, FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        IF PrintAmountsInLCY THEN BEGIN
            ExcelBuf.NewRow();
            ExcelBuf.AddInfoColumn(FORMAT(Text013), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddInfoColumn(PrintAmountsInLCY, FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        END;
        ExcelBuf.ClearNewRow();
        MakeExcelDataHeader();
    end;

    local procedure MakeExcelDataHeader()
    var
        TxtC001: Label 'Delivered';
        TxtC002: Label 'Delivery Date';
    begin
        //>>TDL.001
        ExcelBuf.NewRow();
        ExcelBuf.AddColumn(SalesHeader.FIELDCAPTION("Order Date"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Customer.FIELDCAPTION(Name), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION("No."), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION(Description), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //>>LAP2.12
        ExcelBuf.AddColumn(RecGItem.FIELDCAPTION("Search Description"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //<<LAP2.12
        ExcelBuf.AddColumn(SalesHeader.FIELDCAPTION("No."), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION(Quantity), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(TxtC001, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesHeader.FIELDCAPTION("External Document No."), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION(Position), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION("PWD Cust Promis. Delivery Date"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(TxtC002, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesHeader.FIELDCAPTION("PWD Planned"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesHeader.FIELDCAPTION("PWD ConfirmedLPSA"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION("Line Amount"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        /*
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(Customer.FIELDCAPTION("No."),FALSE,'',TRUE,FALSE,TRUE,'@');
        ExcelBuf.AddColumn(Customer.FIELDCAPTION(Name),FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn(FORMAT(Text016 + '  ' + SalesHeader.FIELDCAPTION("No.")),FALSE,'',TRUE,FALSE,TRUE,'@');
        ExcelBuf.AddColumn(SalesHeader.FIELDCAPTION("Order Date"),FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION("Shipment Date"),FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION(Type),FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn(FORMAT(Text015 + ' ' + "Sales Line".FIELDCAPTION("No.")),FALSE,'',TRUE,FALSE,TRUE,'@');
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION(Description),FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION(Quantity),FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION("Outstanding Quantity"),FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn(FORMAT(Text011),FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION("Unit Price"),FALSE,'',TRUE,FALSE,TRUE,'@');
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION("Line Discount Amount"),FALSE,'',TRUE,FALSE,TRUE,'@');
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION("Inv. Discount Amount"),FALSE,'',TRUE,FALSE,TRUE,'@');
        ExcelBuf.AddColumn(FORMAT(Text012),FALSE,'',TRUE,FALSE,TRUE,'');
        IF NOT PrintAmountsInLCY THEN
          ExcelBuf.AddColumn(SalesHeader.FIELDCAPTION("Currency Code"),FALSE,'',TRUE,FALSE,TRUE,'');
        */
        //<<TDL.001

    end;

    procedure MakeExcelDataBody()
    begin
        //>>TDL.001
        ExcelBuf.NewRow();
        ExcelBuf.AddColumn(SalesHeader."Order Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Customer.Name, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line".Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //>>LAP2.12
        ExcelBuf.AddColumn(RecGItem."Search Description", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //<<LAP2.12
        ExcelBuf.AddColumn(SalesHeader."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line".Quantity, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesHeader."External Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line".Position, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line"."PWD Cust Promis. Delivery Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesHeader."PWD Planned", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesHeader."PWD ConfirmedLPSA", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line"."Line Amount", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        /*
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(Customer."No.",FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn(Customer.Name,FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn(SalesHeader."No.",FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn(SalesHeader."Order Date",FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn("Sales Line"."Shipment Date",FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn(FORMAT(SELECTSTR("Sales Line".Type + 1,Text014)),FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn("Sales Line"."No.",FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn("Sales Line".Description,FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn("Sales Line".Quantity,FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn("Sales Line"."Outstanding Quantity",FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn(BackOrderQty,FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn("Sales Line"."Unit Price",FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn("Sales Line"."Line Discount Amount",FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn("Sales Line"."Inv. Discount Amount",FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn(SalesOrderAmount,FALSE,'',FALSE,FALSE,FALSE,'');
        IF NOT PrintAmountsInLCY THEN
          ExcelBuf.AddColumn(SalesHeader."Currency Code",FALSE,'',FALSE,FALSE,FALSE,'');
        */
        //<<TDL.001

    end;

    procedure CreateExcelbook()
    begin
        ExcelBuf.CreateBook('', 'Feuil1');
        ExcelBuf.WriteSheet(Text003, COMPANYNAME, USERID);
        ExcelBuf.CloseBook();
        ExcelBuf.OpenExcel();
        ERROR('');
    end;
}

