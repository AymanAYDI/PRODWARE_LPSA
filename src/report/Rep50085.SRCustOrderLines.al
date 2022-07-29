report 50085 "PWD SR Cust. Order Lines"
{
    // <changelog>
    //   <add id="CH4400" dev="SRYSER" request="CH-START-400" date="2004-09-15" area="SR"
    //     releaseversion="CH4.00">Swiss Report</add>
    //   <change id="CH4401" dev="SRYSER" request="CH-START-400A-EX" date="2005-06-30" area="SR"
    //     baseversion="CH4.00" releaseversion="CH4.00A">
    //     Redesign for Excel Feature</change>
    //   <change id="CH9111" dev="SRYSER" feature="CH-ST4.00.03-CL" date="2006-05-11" area="SR"
    //     baseversion="CH4.00A" releaseversion="CH4.00.03">
    //     Cleanup</change>
    //   <change id="CH9115" dev="SRYSER" feature="PSCORS1300" date="2006-10-14" area="SR"
    //     baseversion="CH4.00.03" releaseversion="CH5.00">
    //     PreCall Cleanup</change>
    //   <change id="CH4403" dev="SRYSER" feature="NAVCORS9587" date="2007-08-10" area="SR"
    //     baseversion="CH5.00" releaseversion="CH6.00.01">
    //     Text012 not contain the right Caption renamed to Text012E</change>
    //   <change id="CH4404" dev="AUGMENTUM" date="2008-01-09" area="SR"
    //     baseversion="CH6.00.01" releaseversion="CH6.00.01" feature="NAVCORS764">
    //     Report Transformation - local Report Layout</change>
    //   <change id="CH4405" dev="AUGMENTUM" date="2009-02-19" area="SR"
    //     baseversion="CH6.00" releaseversion="CH6.00.01" feature="NAVCORS14993">
    //     Fixed bugs about report's visibility,add some code in new client </change>
    // </changelog>
    // 
    // //>>TDL.LPSA Add Column "Inventory Qty."
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/SRCustOrderLines.rdl';

    Caption = 'Customer Order Lines';
    ApplicationArea = All;
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Customer; Customer)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", Priority;
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
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
            column(FilterTxt; FilterTxt)
            {
            }
            column(AmtFilterTxt; AmtFilterTxt)
            {
            }
            column(PrintToExcel; PrintToExcel)
            {
            }
            column(PrintAmountsInLCY; PrintAmountsInLCY)
            {
            }
            column(NewOrder; NewOrder)
            {
            }
            column(PrintOnlyOnePerPage; PrintOnlyOnePerPage)
            {
            }
            column(Customer__No__; "No.")
            {
            }
            column(Name__________Post_Code__________City; Name + ' ' + "Post Code" + ' ' + City)
            {
            }
            column(CurrTxt; CurrTxt)
            {
            }
            column(Customer_Order_LinesCaption; Customer_Order_LinesCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(AmountCaption; AmountCaptionLbl)
            {
            }
            column(Disc___Caption; Disc___CaptionLbl)
            {
            }
            column(Price_per_Pce_Caption; Price_per_Pce_CaptionLbl)
            {
            }
            column(BacklogCaption; BacklogCaptionLbl)
            {
            }
            column(Sales_Line__Outstanding_Quantity_Caption; Sales_Line__Outstanding_Quantity_CaptionLbl)
            {
            }
            column(Sales_Line_QuantityCaption; "Sales Line".FIELDCAPTION(Quantity))
            {
            }
            column(Sales_Line_DescriptionCaption; "Sales Line".FIELDCAPTION(Description))
            {
            }
            column(Sales_Line__No__Caption; "Sales Line".FIELDCAPTION("No."))
            {
            }
            column(TypeCaption; TypeCaptionLbl)
            {
            }
            column(Ship_DateCaption; Ship_DateCaptionLbl)
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
                RequestFilterFields = "Shipment Date", "Location Code", Type, "No.", "Posting Group";
                RequestFilterHeading = 'Salesline';
                column(FORMAT_SalesHeader__Order_Date__; FORMAT(SalesHeader."Order Date"))
                {
                }
                column(SalesHeader__No__; SalesHeader."No.")
                {
                }
                column(FORMAT_SalesHeader_Status_; FORMAT(SalesHeader.Status))
                {
                }
                column(FORMAT__Shipment_Date__; FORMAT("PWD Cust Promis. Delivery Date"))
                {
                }
                column(COPYSTR_FORMAT_Type__1_1_; COPYSTR(FORMAT(Type), 1, 1))
                {
                }
                column(Sales_Line__No__; "No.")
                {
                }
                column(Sales_Line_Description; Description)
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
                column(Sales_Line__Line_Discount___; "Line Discount %")
                {
                }
                column(SalesOrderAmount; SalesOrderAmount)
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                }
                column(FORMAT__Shipment_Date___Control45; FORMAT("PWD Cust Promis. Delivery Date"))
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
                column(Sales_Line__Line_Discount____Control53; "Line Discount %")
                {
                }
                column(SalesOrderAmount_Control55; SalesOrderAmount)
                {
                    AutoFormatExpression = SalesHeader."Currency Code";
                    AutoFormatType = 1;
                }
                column(SalesHeader__Currency_Code_; SalesHeader."Currency Code")
                {
                }
                column(COPYSTR_FORMAT_Type__1_1__Control22; COPYSTR(FORMAT(Type), 1, 1))
                {
                }
                column(SalesHeader__No__Caption; SalesHeader__No__CaptionLbl)
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
                        SalesHeader.GET("Document Type", "Document No.");

                    IF "Shipment Date" <= WORKDATE() THEN
                        BackOrderQty := "Outstanding Quantity"
                    ELSE
                        BackOrderQty := 0;

                    SalesOrderAmount := ROUND("Outstanding Amount" / (1 + "VAT %" / 100));

                    SalesOrderAmountLCY := SalesOrderAmount;
                    IF SalesHeader."Currency Code" <> '' THEN BEGIN

                        IF SalesHeader."Currency Factor" <> 0 THEN
                            SalesOrderAmountLCY := ROUND(CurrExchRate.ExchangeAmtFCYToLCY
                                (WORKDATE(), SalesHeader."Currency Code", SalesOrderAmountLCY, SalesHeader."Currency Factor"));

                        IF PrintAmountsInLCY THEN BEGIN
                            "Unit Price" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY
                                (WORKDATE(), SalesHeader."Currency Code", "Unit Price", SalesHeader."Currency Factor"));
                            SalesOrderAmount := SalesOrderAmountLCY;
                        END;
                    END;

                    IF SalesHeader."Prices Including VAT" THEN
                        "Unit Price" := "Unit Price" / (1 + "VAT %" / 100);

                    CurrencyCode2 := SalesHeader."Currency Code";
                    IF PrintAmountsInLCY THEN
                        CurrencyCode2 := '';

                    CurrencyTotalBuffer.UpdateTotal(CurrencyCode2, SalesOrderAmount, SalesOrderAmountLCY, Counter1);
                    // CH4401.begin
                    IF PrintToExcel THEN
                        MakeExcelDataBody();
                    // CH4401.end
                end;

                trigger OnPreDataItem()
                begin
                    CurrReport.CREATETOTALS(SalesOrderAmountLCY, SalesOrderAmount);
                end;
            }
            dataitem(CurrencyRecapPerAccount; Integer)
            {
                DataItemTableView = SORTING(Number)
                                    WHERE(Number = FILTER(1 ..));
                column(CurrencyTotalBuffer__Total_Amount_; CurrencyTotalBuffer."Total Amount")
                {
                    AutoFormatExpression = CurrencyTotalBuffer."Currency Code";
                    AutoFormatType = 1;
                }
                column(CurrencyTotalBuffer__Currency_Code_; CurrencyTotalBuffer."Currency Code")
                {
                }
                column(Text007___Customer_Name; Text007 + Customer.Name)
                {
                }
                column(CurrencyRecapPerAccount_Number; Number)
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

                    GlSetup.GET();
                    IF GlSetup."LCY Code" = '' THEN
                        GlSetup."LCY Code" := 'CHF';
                    IF CurrencyTotalBuffer."Currency Code" = '' THEN
                        CurrencyTotalBuffer."Currency Code" := GlSetup."LCY Code";

                    CurrencyTotalBuffer2.UpdateTotal(
                      CurrencyTotalBuffer."Currency Code",
                      CurrencyTotalBuffer."Total Amount",
                      CurrencyTotalBuffer."Total Amount (LCY)",
                      Counter1);
                end;

                trigger OnPostDataItem()
                begin
                    CurrencyTotalBuffer.DELETEALL();
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CurrTxt := '';
                IF ("Currency Code" <> '') AND (NOT PrintAmountsInLCY) THEN
                    CurrTxt := Text005 + ' ' + "Currency Code";
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.NEWPAGEPERRECORD := PrintOnlyOnePerPage;
                CurrReport.CREATETOTALS(SalesOrderAmountLCY);
            end;
        }
        dataitem(CurrRecap; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = FILTER(1 ..));
            column(CurrencyTotalBuffer2__Total_Amount_; CurrencyTotalBuffer2."Total Amount")
            {
                AutoFormatExpression = CurrencyTotalBuffer2."Currency Code";
                AutoFormatType = 1;
            }
            column(CurrencyTotalBuffer2__Currency_Code_; CurrencyTotalBuffer2."Currency Code")
            {
            }
            column(CurrencyTotalBuffer2__Currency_Code__Control8; CurrencyTotalBuffer2."Currency Code")
            {
            }
            column(CurrencyTotalBuffer2__Total_Amount__LCY__; CurrencyTotalBuffer2."Total Amount (LCY)")
            {
                AutoFormatExpression = CurrencyTotalBuffer2."Currency Code";
                AutoFormatType = 1;
            }
            column(GlSetup__LCY_Code_; GlSetup."LCY Code")
            {
            }
            column(GlSetup__LCY_Code__Control1150002; GlSetup."LCY Code")
            {
            }
            column(CurrRecap_CurrRecap_Number; CurrRecap.Number)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(TotalCaption_Control33; TotalCaption_Control33Lbl)
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

            trigger OnPreDataItem()
            begin
                CurrReport.CREATETOTALS(CurrencyTotalBuffer2."Total Amount (LCY)");
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
            // CH4401.begin
            PrintToExcel := FALSE;
            // CH4401.end
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        // CH4401.begin
        IF PrintToExcel THEN
            CreateExcelbook();
        // CH4401.end
    end;

    trigger OnPreReport()
    begin
        FilterTxt := Text000;
        IF Customer.GETFILTERS <> '' THEN
            FilterTxt := FilterTxt + ' ' + Text001 + ' ' + Customer.GETFILTERS;
        IF "Sales Line".GETFILTERS <> '' THEN
            FilterTxt := FilterTxt + ' ' + Text002 + ' ' + "Sales Line".GETFILTERS;

        IF PrintAmountsInLCY THEN
            AmtFilterTxt := Text003
        ELSE
            AmtFilterTxt := Text004;
        // CH4401.begin
        IF PrintToExcel THEN
            MakeExcelInfo();
        // CH4401.end
    end;

    var
        Text000: Label 'Filter';
        Text001: Label ' Customer:';
        Text002: Label ' Orderline:';
        Text003: Label 'All amounts in LCY';
        Text004: Label 'Amounts in Currency of Customer';
        Text005: Label 'Main Currency ';
        Text007: Label 'Total ';
        CurrExchRate: Record 330;
        CurrencyTotalBuffer: Record 332 temporary;
        CurrencyTotalBuffer2: Record 332 temporary;
        SalesHeader: Record 36;
        ExcelBuf: Record 370 temporary;
        GlSetup: Record 98;
        FilterTxt: Text[250];
        AmtFilterTxt: Text[50];
        SalesOrderAmount: Decimal;
        SalesOrderAmountLCY: Decimal;
        PrintAmountsInLCY: Boolean;
        PrintOnlyOnePerPage: Boolean;
        BackOrderQty: Decimal;
        NewOrder: Boolean;
        OK: Boolean;
        Counter1: Integer;
        CurrencyCode2: Code[10];
        CurrTxt: Text[50];
        PrintToExcel: Boolean;
        Text002E: Label 'Data';
        Text003E: Label 'SR Cust. Order Lines';
        Text004E: Label 'Company Name';
        Text005E: Label 'Report No.';
        Text006E: Label 'Report Name';
        Text007E: Label 'User ID';
        Text008: Label 'Date';
        Text009: Label 'Customer Filters';
        Text010: Label 'Sales Order Lines Filters';
        Text011: Label 'Quantity on Back Order';
        Text012E: Label 'Amount';
        Text013: Label 'All amounts are in LCY';
        Text014: Label ' ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)';
        Text015: Label 'Item';
        Text016: Label 'Order';
        TxtG001: Label 'Inventory Qty.';
        Customer_Order_LinesCaptionLbl: Label 'Customer Order Lines';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        AmountCaptionLbl: Label 'Amount';
        Disc___CaptionLbl: Label 'Disc. %';
        Price_per_Pce_CaptionLbl: Label 'Price per Pce.';
        BacklogCaptionLbl: Label 'Backlog';
        Sales_Line__Outstanding_Quantity_CaptionLbl: Label 'Rem. Qty.';
        TypeCaptionLbl: Label 'Type';
        Ship_DateCaptionLbl: Label 'Ship Date';
        SalesHeader__No__CaptionLbl: Label 'Order No.';
        TotalCaptionLbl: Label 'Total';
        TotalCaption_Control33Lbl: Label 'Total';

    procedure MakeExcelInfo()
    begin
        ExcelBuf.SetUseInfoSheet();
        ExcelBuf.AddInfoColumn(FORMAT(Text004E), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(COMPANYNAME, FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow();
        ExcelBuf.AddInfoColumn(FORMAT(Text006E), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(FORMAT(Text003E), FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow();
        ExcelBuf.AddInfoColumn(FORMAT(Text005E), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(REPORT::"PWD SR Cust. Order Lines", FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow();
        ExcelBuf.AddInfoColumn(FORMAT(Text007E), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
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
    begin
        ExcelBuf.NewRow();
        ExcelBuf.AddColumn(Customer.FIELDCAPTION("No."), FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Customer.FIELDCAPTION(Name), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(Text016 + '  ' + SalesHeader.FIELDCAPTION("No.")), FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesHeader.FIELDCAPTION("Order Date"), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION("PWD Cust Promis. Delivery Date"), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION(Type), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(Text015 + ' ' + "Sales Line".FIELDCAPTION("No.")), FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION(Description), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION(Quantity), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION("Outstanding Quantity"), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(Text011), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        //>>TDL.LPSA
        ExcelBuf.AddColumn(FORMAT(TxtG001), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        //<<TDL.LPSA
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION("Unit Price"), FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION("Line Discount Amount"), FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION("Inv. Discount Amount"), FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(Text012E), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        IF NOT PrintAmountsInLCY THEN
            ExcelBuf.AddColumn(SalesHeader.FIELDCAPTION("Currency Code"), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
    end;

    procedure MakeExcelDataBody()
    var
        RecLItem: Record 27;
    begin
        ExcelBuf.NewRow();
        ExcelBuf.AddColumn(Customer."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Customer.Name, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesHeader."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesHeader."Order Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line"."PWD Cust Promis. Delivery Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(SELECTSTR("Sales Line".Type + 1, Text014)), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line".Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line".Quantity, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line"."Outstanding Quantity", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(BackOrderQty, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //>>TDL.LPSA
        IF "Sales Line".Type = "Sales Line".Type::Item THEN BEGIN
            RecLItem.GET("Sales Line"."No.");
            RecLItem.CALCFIELDS(RecLItem.Inventory);
            ExcelBuf.AddColumn(RecLItem.Inventory, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        END ELSE
            ExcelBuf.AddColumn(0, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //<<TDL.LPSA

        ExcelBuf.AddColumn("Sales Line"."Unit Price", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line"."Line Discount Amount", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line"."Inv. Discount Amount", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesOrderAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        IF NOT PrintAmountsInLCY THEN
            ExcelBuf.AddColumn(SalesHeader."Currency Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
    end;

    procedure CreateExcelbook()
    begin
        ExcelBuf.CreateBook('', 'Feuil1');
        ExcelBuf.WriteSheet(Text003E, COMPANYNAME, USERID);
        ExcelBuf.CloseBook();
        ExcelBuf.OpenExcel();
        ERROR('');
    end;
}

