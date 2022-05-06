report 50008 "PWD Sales Quote"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.00
    // FED-LAPIERRETTE-VTE-02-Documents Vente-V5.001: TUN 26/12/2011:  Documents vente
    //                                                                 - Creation Report 50008
    // 
    // //>>REGIE
    // P24578_005 : LALE.RO : 29/01/2019 Demande par Mail
    //                         Modif Layout
    // 
    // ------------------------------------------------------------------------------------------------------------------
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/SalesQuote.rdl';

    Caption = 'Sales Quote';
    UsageCategory = none;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Quote));
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Sales Quote';
            column(Sales_Header_Document_Type; "Document Type")
            {
            }
            column(Sales_Header_No_; "No.")
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(CustAddr_1_; CstG001)
                    {
                    }
                    column(CompanyAddr_1_; CompanyAddr[1])
                    {
                    }
                    column(CustAddr_2_; "Sales Header"."No.")
                    {
                    }
                    column(CompanyAddr_2_; CompanyAddr[2])
                    {
                    }
                    column(CustAddr_3_; "Sales Header"."Document Date")
                    {
                    }
                    column(CompanyAddr_3_; CompanyAddr[3])
                    {
                    }
                    column(CustAddr_4_; CodGNoCustomer)
                    {
                    }
                    column(CompanyAddr_4_; CompanyAddr[4])
                    {
                    }
                    column(CustAddr_5_; RecGCustomer."VAT Registration No.")
                    {
                    }
                    column(CustAddr_6_; "Sales Header"."External Document No.")
                    {
                    }
                    column(CustAddr_7_; TxTGContact)
                    {
                    }
                    column(CustAddr_8_; RecGSalespersonPurchaser.Name)
                    {
                    }
                    column(CompanyAddr_5_; CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr_6_; CompanyAddr[6])
                    {
                    }
                    column(Sales_Header___Document_Date_; StrSubstNo(CstG002, CompanyInfo.City, Format(WorkDate(), 0, 4)))
                    {
                    }
                    column(CopyText; CopyText)
                    {
                    }
                    column(STRSUBSTNO_Text11500__Sales_Header___No___; StrSubstNo(Text11500, "Sales Header"."No."))
                    {
                    }
                    column(PageCaption; StrSubstNo(Text005, ''))
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(PricesInclVAT_YesNo; Format("Sales Header"."Prices Including VAT"))
                    {
                    }
                    column(Text_MadameMonsieur; CstG004)
                    {
                    }
                    column(Text_Intro; CstG005)
                    {
                    }
                    column(CopyText_Control1150145; CopyText)
                    {
                    }
                    column(STRSUBSTNO_Text005_FORMAT_CurrReport_PAGENO__; StrSubstNo(Text005, Format(CurrReport.PageNo())))
                    {
                    }
                    column(CurrGroupPageNO; CurrGroupPageNO)
                    {
                    }
                    column(CurrPageFooterHiddenFlag; CurrPageFooterHiddenFlag)
                    {
                    }
                    column(CurrPageHeaderHiddenFlag; CurrPageHeaderHiddenFlag)
                    {
                    }
                    column(InnerGroupPageNO; InnerGroupPageNO)
                    {
                    }
                    column(CustAddr_2_Caption; CustAddr_2_CaptionLbl)
                    {
                    }
                    column(CustAddr_3_Caption; CustAddr_3_CaptionLbl)
                    {
                    }
                    column(CustAddr_4_Caption; CustAddr_4_CaptionLbl)
                    {
                    }
                    column(CustAddr_7_Caption; CustAddr_7_CaptionLbl)
                    {
                    }
                    column(CustAddr_6_Caption; CustAddr_6_CaptionLbl)
                    {
                    }
                    column(CustAddr_5_Caption; CustAddr_5_CaptionLbl)
                    {
                    }
                    column(CustAddr_8_Caption; CustAddr_8_CaptionLbl)
                    {
                    }
                    column(PageLoop_Number; Number)
                    {
                    }
                    dataitem(DimensionLoop1; "Integer")
                    {
                        DataItemLinkReference = "Sales Header";
                        DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                        column(DimText; DimText)
                        {
                        }
                        column(DimText_Control80; DimText)
                        {
                        }
                        column(Header_DimensionsCaption; Header_DimensionsCaptionLbl)
                        {
                        }
                        column(DimensionLoop1_Number; Number)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then begin
                                if not DimSetEntry1.Find('-') then
                                    CurrReport.Break();
                            end else
                                if not Continue then
                                    CurrReport.Break();

                            Clear(DimText);
                            Continue := false;
                            repeat
                                OldDimText := DimText;
                                if DimText = '' then
                                    DimText := StrSubstNo(
                                      '%1 %2', DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                else
                                    DimText :=
                                      StrSubstNo(
                                        '%1, %2 %3', DimText,
                                        DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
                                if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                    DimText := OldDimText;
                                    Continue := true;
                                    exit;
                                end;
                            until (DimSetEntry1.Next() = 0);
                        end;

                        trigger OnPreDataItem()
                        begin
                            if not ShowInternalInfo then
                                CurrReport.Break();
                        end;
                    }
                    dataitem("Sales Line"; "Sales Line")
                    {
                        DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                        DataItemLinkReference = "Sales Header";
                        DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");

                        trigger OnPreDataItem()
                        begin
                            CurrReport.Break();
                        end;
                    }
                    dataitem(RoundLoop; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(Sales_Header___Prices_Including_VAT_; "Sales Header"."Prices Including VAT")
                        {
                        }
                        column(AmountCaption; TxTGLabelAmount)
                        {
                        }
                        column(SalesLine__Line_Amount_; SalesLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(SalesLine_Description; "Sales Line"."PWD LPSA Description 1")
                        {
                        }
                        column(SalesLineTypeEqualTitle; SalesLine.Type.AsInteger() >= SalesLine.Type::Title.AsInteger())
                        {
                        }
                        column(Sales_Line___No__; CopyStr("Sales Line"."No.", 1, 8))
                        {
                        }
                        column(Sales_Line__Description; "Sales Line"."PWD LPSA Description 1")
                        {
                        }
                        column(Sales_Line__Quantity; "Sales Line".Quantity)
                        {
                        }
                        column(Sales_Line___Unit_of_Measure_; "Sales Line"."Unit of Measure Code")
                        {
                        }
                        column(Sales_Line___Line_Amount_; "Sales Line"."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Sales_Line___Unit_Price_; "Sales Line"."Unit Price")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 2;
                            DecimalPlaces = 0 : 4;
                        }
                        column(SalesLineType; Format("Sales Line".Type))
                        {
                        }
                        column(SalesLineNo; "Sales Line"."Line No.")
                        {
                        }
                        column(AllowInvoiceDis_YesNo; Format("Sales Line"."Allow Invoice Disc."))
                        {
                        }
                        column(Comment_Line; TxtGComment)
                        {
                        }
                        column(Sales_Line__Description_Control1150111; "Sales Line"."PWD LPSA Description 1")
                        {
                        }
                        column(SalesLine__Subtotal_Net_; SalesLine."Subtotal Net")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(SalesLine__Line_Amount__Control84; SalesLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Sales_Header___Due_Date_; Format("Sales Header"."Due Date"))
                        {
                        }
                        column(RecGSalespersonPurchaser_Name; RecGSalespersonPurchaser.Name)
                        {
                        }
                        column(Text_Fin1; CstG006)
                        {
                        }
                        column(Text_Fin2; CstG007)
                        {
                        }
                        column(Sales_Line__DescriptionCaption; Sales_Line__DescriptionCaptionLbl)
                        {
                        }
                        column(Sales_Line___No__Caption; Sales_Line___No__CaptionLbl)
                        {
                        }
                        column(Sales_Line__QuantityCaption; Sales_Line__QuantityCaptionLbl)
                        {
                        }
                        column(Sales_Line___Unit_of_Measure_Caption; Sales_Line___Unit_of_Measure_CaptionLbl)
                        {
                        }
                        column(Unit_PriceCaption; Unit_PriceCaptionLbl)
                        {
                        }
                        column(ContinuedCaption; ContinuedCaptionLbl)
                        {
                        }
                        column(ContinuedCaption_Control83; ContinuedCaption_Control83Lbl)
                        {
                        }
                        column(To_be_returned_signed_and_dated_for_validationCaption; To_be_returned_signed_and_dated_for_validationCaptionLbl)
                        {
                        }
                        column(Sales_Header___Due_Date_Caption; Sales_Header___Due_Date_CaptionLbl)
                        {
                        }
                        column(RecGSalespersonPurchaser_NameCaption; RecGSalespersonPurchaser_NameCaptionLbl)
                        {
                        }
                        column(RoundLoop_Number; Number)
                        {
                        }
                        dataitem(DimensionLoop2; "Integer")
                        {
                            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                            column(DimText_Control81; DimText)
                            {
                            }
                            column(Line_DimensionsCaption; Line_DimensionsCaptionLbl)
                            {
                            }
                            column(DimensionLoop2_Number; Number)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then begin
                                    if not DimSetEntry2.Find('-') then
                                        CurrReport.Break();
                                end else
                                    if not Continue then
                                        CurrReport.Break();

                                Clear(DimText);
                                Continue := false;
                                repeat
                                    OldDimText := DimText;
                                    if DimText = '' then
                                        DimText := StrSubstNo(
                                          '%1 %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    else
                                        DimText :=
                                          StrSubstNo(
                                            '%1, %2 %3', DimText,
                                            DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
                                    if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                        DimText := OldDimText;
                                        Continue := true;
                                        exit;
                                    end;
                                until (DimSetEntry2.Next() = 0);
                            end;

                            trigger OnPreDataItem()
                            begin
                                if not ShowInternalInfo then
                                    CurrReport.Break();
                                DimSetEntry2.SetRange("Dimension Set ID", DATABASE::"Sales Line");
                                // DocDim2.SetRange("Table ID", DATABASE::"Sales Line");
                                // DocDim2.SetRange("Document Type", "Sales Line"."Document Type");
                                // DocDim2.SetRange("Document No.", "Sales Line"."Document No.");
                                // DocDim2.SetRange("Line No.", "Sales Line"."Line No.");
                            end;
                        }
                        dataitem(PageBreak; "Integer")
                        {
                            DataItemTableView = SORTING(Number) ORDER(Ascending) WHERE(Number = FILTER(1 .. 2));

                            trigger OnPreDataItem()
                            begin
                                // CH4410.BEGIN
                                // CH0004.BEGIN
                                if not ("Sales Line".Type = "Sales Line".Type::"New Page") then begin
                                    CurrPageHeaderHiddenFlag := 0;
                                    CurrReport.Break();
                                end else
                                    if IsServiceTier then begin
                                        CurrGroupPageNO += 1;
                                        InnerGroupPageNO += 1;
                                        CurrPageHeaderHiddenFlag := 1;
                                    end;
                                // CH0004.END
                                // CH4410.END
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then
                                SalesLine.Find('-')
                            else
                                SalesLine.Next();
                            "Sales Line" := SalesLine;

                            if not "Sales Header"."Prices Including VAT" and
                               (SalesLine."VAT Calculation Type" = SalesLine."VAT Calculation Type"::"Full VAT")
                            then
                                SalesLine."Line Amount" := 0;

                            if (SalesLine.Type = SalesLine.Type::"G/L Account") and (not ShowInternalInfo) then
                                "Sales Line"."No." := '';

                            //>>Regie
                            Clear(TxtGComment);
                            BooGStopComment := false;
                            RecGSalesCommentLine.Reset();
                            RecGSalesCommentLine.SetRange("Document Type", RecGSalesCommentLine."Document Type"::Quote);
                            RecGSalesCommentLine.SetRange("No.", "Sales Line"."Document No.");
                            RecGSalesCommentLine.SetRange("Document Line No.", "Sales Line"."Line No.");
                            if RecGSalesCommentLine.FindSet() then
                                repeat
                                    if StrLen(TxtGComment) + StrLen(RecGSalesCommentLine.Comment) < 1024 then
                                        TxtGComment += RecGSalesCommentLine.Comment + ' '
                                    else
                                        BooGStopComment := true;
                                until (RecGSalesCommentLine.Next() = 0) or (BooGStopComment);


                            // CH0004.begin
                            if IsServiceTier then
                                if ("Sales Line".Type = "Sales Line".Type::"New Page") then
                                    CurrPageFooterHiddenFlag := 1
                                else
                                    CurrPageFooterHiddenFlag := 0;
                            // CH0004.end
                        end;

                        trigger OnPostDataItem()
                        begin
                            SalesLine.DeleteAll();
                        end;

                        trigger OnPreDataItem()
                        begin
                            MoreLines := SalesLine.Find('+');
                            while MoreLines and (SalesLine.Description = '') and (SalesLine."Description 2" = '') and
                                  (SalesLine."No." = '') and (SalesLine.Quantity = 0) and
                                  (SalesLine.Amount = 0)
                            do
                                MoreLines := SalesLine.Next(-1) <> 0;
                            if not MoreLines then
                                CurrReport.Break();
                            SalesLine.SetRange("Line No.", 0, SalesLine."Line No.");
                            SetRange(Number, 1, SalesLine.Count);
                            CurrReport.CreateTotals(SalesLine."Line Amount", SalesLine."Inv. Discount Amount");
                        end;
                    }
                    dataitem(VATCounter; "Integer")
                    {
                        DataItemTableView = SORTING(Number);

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                        end;

                        trigger OnPreDataItem()
                        begin
                            if VATAmount = 0 then
                                CurrReport.Break();
                            SetRange(Number, 1, VATAmountLine.Count);
                            CurrReport.CreateTotals(
                              VATAmountLine."Line Amount", VATAmountLine."Inv. Disc. Base Amount",
                              VATAmountLine."Invoice Discount Amount", VATAmountLine."VAT Base", VATAmountLine."VAT Amount");
                        end;
                    }
                    dataitem(VATCounterLCY; "Integer")
                    {
                        DataItemTableView = SORTING(Number);

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);

                            VALVATBaseLCY := Round(CurrExchRate.ExchangeAmtFCYToLCY(
                                               "Sales Header"."Order Date", "Sales Header"."Currency Code",
                                               VATAmountLine."VAT Base", "Sales Header"."Currency Factor"));
                            VALVATAmountLCY := Round(CurrExchRate.ExchangeAmtFCYToLCY(
                                                 "Sales Header"."Order Date", "Sales Header"."Currency Code",
                                                 VATAmountLine."VAT Amount", "Sales Header"."Currency Factor"));
                        end;

                        trigger OnPreDataItem()
                        begin
                            if (not GLSetup."Print VAT specification in LCY") or
                               ("Sales Header"."Currency Code" = '') or
                               (VATAmountLine.GetTotalVATAmount() = 0) then
                                CurrReport.Break();

                            SetRange(Number, 1, VATAmountLine.Count);
                            CurrReport.CreateTotals(VALVATBaseLCY, VALVATAmountLCY);

                            if GLSetup."LCY Code" = '' then
                                VALSpecLCYHeader := Text008 + Text009
                            else
                                VALSpecLCYHeader := Text008 + Format(GLSetup."LCY Code");

                            CurrExchRate.FindCurrency("Sales Header"."Order Date", "Sales Header"."Currency Code", 1);
                            VALExchRate := StrSubstNo(Text010, CurrExchRate."Relational Exch. Rate Amount", CurrExchRate."Exchange Rate Amount");
                        end;
                    }
                    dataitem(Total; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    }
                }

                trigger OnAfterGetRecord()
                var
                    SalesPost: Codeunit "Sales-Post";
                begin
                    Clear(SalesLine);
                    Clear(SalesPost);
                    SalesLine.DeleteAll();
                    VATAmountLine.DeleteAll();
                    SalesPost.GetSalesLines("Sales Header", SalesLine, 0);
                    SalesLine.CalcVATAmountLines(0, "Sales Header", SalesLine, VATAmountLine);
                    SalesLine.UpdateVATOnLines(0, "Sales Header", SalesLine, VATAmountLine);
                    VATAmount := VATAmountLine.GetTotalVATAmount();
                    // VATBaseAmount := VATAmountLine.GetTotalVATBase();
                    // VATDiscountAmount :=
                    //   VATAmountLine.GetTotalVATDiscount("Sales Header"."Currency Code", "Sales Header"."Prices Including VAT");
                    // TotalAmountInclVAT := VATAmountLine.GetTotalAmountInclVAT();

                    if Number > 1 then begin
                        CopyText := Text003;
                        if IsServiceTier then
                            OutputNo += 1;
                    end;
                    CurrReport.PageNo := 1;
                end;

                trigger OnPostDataItem()
                begin
                    if not CurrReport.Preview then
                        SalesCountPrinted.Run("Sales Header");
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopies) + 1;
                    CopyText := '';
                    SetRange(Number, 1, NoOfLoops);
                    if IsServiceTier then
                        OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CurrReport.Language := Language.GetLanguageID("Language Code");

                //>>LAP.001
                RecGCustomer.Get("Sell-to Customer No.");
                RecGSalespersonPurchaser.Get("Salesperson Code");
                RecGGenLedSetup.Get();
                if "Currency Code" <> '' then
                    TxTGLabelAmount := StrSubstNo(CstG003, "Currency Code")
                else
                    TxTGLabelAmount := StrSubstNo(CstG003, RecGGenLedSetup."LCY Code");

                if ("Sell-to Customer No." <> "Bill-to Customer No.") and ("Bill-to Customer No." <> '') then begin
                    FormatAddr.SalesHeaderSellTo(CompanyAddr, "Sales Header");
                    CodGNoCustomer := "Sell-to Customer No.";
                    TxTGContact := "Sell-to Contact";
                end
                else begin
                    FormatAddr.SalesHeaderBillTo(CompanyAddr, "Sales Header");
                    CodGNoCustomer := "Bill-to Customer No.";
                    TxTGContact := "Bill-to Contact";
                end;

                //<<LAP.001

                DimSetEntry1.SetRange("Dimension Set ID", DATABASE::"Sales Header");
                // DocDim1.SetRange("Table ID", DATABASE::"Sales Header");
                // DocDim1.SetRange("Document Type", "Sales Header"."Document Type");
                // DocDim1.SetRange("Document No.", "Sales Header"."No.");

                if "Salesperson Code" = '' then begin
                    SalesPurchPerson.Init();
                    SalesPersonText := '';
                end else begin
                    SalesPurchPerson.Get("Salesperson Code");
                    SalesPersonText := Text000;
                end;
                if "Your Reference" = '' then
                    ReferenceText := ''
                else
                    ReferenceText := FieldCaption("Your Reference");
                if "VAT Registration No." = '' then
                    VATNoText := ''
                else
                    VATNoText := FieldCaption("VAT Registration No.");
                if "Currency Code" = '' then begin
                    GLSetup.TestField("LCY Code");
                    TotalText := StrSubstNo(Text001, GLSetup."LCY Code");
                    TotalInclVATText := StrSubstNo(Text002, GLSetup."LCY Code");
                    TotalExclVATText := StrSubstNo(Text006, GLSetup."LCY Code");
                end else begin
                    TotalText := StrSubstNo(Text001, "Currency Code");
                    TotalInclVATText := StrSubstNo(Text002, "Currency Code");
                    TotalExclVATText := StrSubstNo(Text006, "Currency Code");
                end;

                if "Payment Terms Code" = '' then
                    PaymentTerms.Init()
                else begin
                    PaymentTerms.Get("Payment Terms Code");
                    PaymentTerms.TranslateDescription(PaymentTerms, "Sales Header"."Language Code");
                end;
                if "Shipment Method Code" = '' then
                    ShipmentMethod.Init()
                else begin
                    ShipmentMethod.Get("Shipment Method Code");
                    ShipmentMethod.TranslateDescription(ShipmentMethod, "Sales Header"."Language Code");
                end;

                if not CurrReport.Preview then begin
                    if ArchiveDocument then
                        ArchiveManagement.StoreSalesDocument("Sales Header", LogInteraction);

                    if LogInteraction then begin
                        CalcFields("No. of Archived Versions");
                        if "Bill-to Contact No." <> '' then
                            SegManagement.LogDocument(
                              1, "No.", "Doc. No. Occurrence",
                              "No. of Archived Versions", DATABASE::Contact, "Bill-to Contact No.",
                              "Salesperson Code", "Campaign No.", "Posting Description", "Opportunity No.")
                        else
                            SegManagement.LogDocument(
                              1, "No.", "Doc. No. Occurrence",
                              "No. of Archived Versions", DATABASE::Customer, "Bill-to Customer No.",
                              "Salesperson Code", "Campaign No.", "Posting Description", "Opportunity No.");
                    end;
                end;
                "Sales Header".Mark(true);
            end;

            trigger OnPostDataItem()
            var
                ToDo: Record "To-do";
            begin
                "Sales Header".MarkedOnly := true;
                Commit();
                CurrReport.Language := GlobalLanguage;
                if "Sales Header".Find('-') and ToDo.WritePermission then
                    if not CurrReport.Preview and (NoOfRecords = 1) then
                        if Confirm(Text007) then
                            "Sales Header".CreateTask();
            end;

            trigger OnPreDataItem()
            begin
                NoOfRecords := Count;

                // CH0004.begin
                if IsServiceTier then begin
                    CurrPageHeaderHiddenFlag := 0;
                    CurrPageFooterHiddenFlag := 0;
                    CurrGroupPageNO := 0;
                    InnerGroupPageNO := 1;
                end;
                // CH0004.end
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
                group(Control1900000002)
                {
                    Caption = 'Options';
                    ShowCaption = false;
                    field(NoOfCopies; NoOfCopies)
                    {
                        Caption = 'No. of Copies';
                        ShowCaption = false;
                        ApplicationArea = All;
                    }
                    field(ShowInternalInfo; ShowInternalInfo)
                    {
                        Caption = 'Show Internal Information';
                        ShowCaption = false;
                        ApplicationArea = All;
                    }
                    field(ArchiveDocument; ArchiveDocument)
                    {
                        Caption = 'Archive Document';
                        Enabled = ArchiveDocumentEnable;
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if not ArchiveDocument then
                                LogInteraction := false;
                        end;
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if LogInteraction then
                                ArchiveDocument := ArchiveDocumentEnable;
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            LogInteractionEnable := true;
            ArchiveDocumentEnable := true;
        end;

        trigger OnOpenPage()
        begin
            LogInteraction := SegManagement.FindInteractTmplCode(1) <> '';

            ArchiveDocumentEnable := ArchiveDocument;
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        GLSetup.Get();
        CompanyInfo.Get();
        SalesSetup.Get();

        case SalesSetup."Logo Position on Documents" of
            SalesSetup."Logo Position on Documents"::"No Logo":
                ;
            SalesSetup."Logo Position on Documents"::Left:

                CompanyInfo.CalcFields(Picture);
            SalesSetup."Logo Position on Documents"::Center:
                begin
                    CompanyInfo1.Get();
                    CompanyInfo1.CalcFields(Picture);
                end;
            SalesSetup."Logo Position on Documents"::Right:
                begin
                    CompanyInfo2.Get();
                    CompanyInfo2.CalcFields(Picture);
                end;
        end;
    end;

    var
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CurrExchRate: Record "Currency Exchange Rate";
        RecGCustomer: Record Customer;
        //TODO: Table 'Document Dimension' is missing
        // DocDim1: Record "Document Dimension";
        // DocDim2: Record "Document Dimension";
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        GLSetup: Record "General Ledger Setup";
        RecGGenLedSetup: Record "General Ledger Setup";
        PaymentTerms: Record "Payment Terms";
        SalesSetup: Record "Sales & Receivables Setup";
        RecGSalesCommentLine: Record "Sales Comment Line";
        SalesLine: Record "Sales Line" temporary;
        RecGSalespersonPurchaser: Record "Salesperson/Purchaser";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        ShipmentMethod: Record "Shipment Method";
        VATAmountLine: Record "VAT Amount Line" temporary;
        ArchiveManagement: Codeunit ArchiveManagement;
        FormatAddr: Codeunit "Format Address";

        Language: Codeunit Language;
        SalesCountPrinted: Codeunit "Sales-Printed";
        SegManagement: Codeunit SegManagement;
        ArchiveDocument: Boolean;
        [InDataSet]
        ArchiveDocumentEnable: Boolean;
        BooGStopComment: Boolean;
        Continue: Boolean;
        LogInteraction: Boolean;
        [InDataSet]
        LogInteractionEnable: Boolean;
        MoreLines: Boolean;
        ShowInternalInfo: Boolean;
        CodGNoCustomer: Code[20];
        // TotalAmountInclVAT: Decimal;
        VALVATAmountLCY: Decimal;
        VALVATBaseLCY: Decimal;
        VATAmount: Decimal;
        // VATBaseAmount: Decimal;
        // VATDiscountAmount: Decimal;
        CurrGroupPageNO: Integer;
        CurrPageFooterHiddenFlag: Integer;
        CurrPageHeaderHiddenFlag: Integer;
        InnerGroupPageNO: Integer;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        NoOfRecords: Integer;
        OutputNo: Integer;
        ContinuedCaption_Control83Lbl: Label 'Continued';
        ContinuedCaptionLbl: Label 'Continued';
        CstG001: Label 'Sales Quote';
        CstG002: Label '%1, on %2';
        CstG003: Label 'Amount %1';
        CstG004: Label 'Madam, Sir,';
        CstG005: Label 'We would like to thank you for your request and are pleased to send you this proposal.';
        CstG006: Label 'Validity Date : 1 Month  /  Realization Delay : To be confirmed  /  Payment Terms : 30 days';
        CstG007: Label 'We thank you and are looking for your feedback. ';
        CustAddr_2_CaptionLbl: Label 'Document No. :';
        CustAddr_3_CaptionLbl: Label 'Your document Date :';
        CustAddr_4_CaptionLbl: Label 'Customer No. :';
        CustAddr_5_CaptionLbl: Label 'VAT Registration No. :';
        CustAddr_6_CaptionLbl: Label 'Your Document No. :';
        CustAddr_7_CaptionLbl: Label 'Your Reference :';
        CustAddr_8_CaptionLbl: Label 'Your contact :';
        Header_DimensionsCaptionLbl: Label 'Header Dimensions';
        Line_DimensionsCaptionLbl: Label 'Line Dimensions';
        RecGSalespersonPurchaser_NameCaptionLbl: Label 'Sincerely';
        Sales_Header___Due_Date_CaptionLbl: Label 'Valid Date:';
        Sales_Line___No__CaptionLbl: Label 'Item Code';
        Sales_Line___Unit_of_Measure_CaptionLbl: Label 'Unit';
        Sales_Line__DescriptionCaptionLbl: Label 'Description';
        Sales_Line__QuantityCaptionLbl: Label 'Quantity';
        Text000: Label 'Salesperson';
        Text001: Label 'Total %1';
        Text002: Label 'Total %1 Incl. VAT';
        Text003: Label 'COPY';
        Text005: Label 'Page %1';
        Text006: Label 'Total %1 Excl. VAT';
        Text007: Label 'Do you want to create a follow-up to-do?';
        Text008: Label 'VAT Amount Specification in ';
        Text009: Label 'Local Currency';
        Text010: Label 'Exchange rate: %1/%2';
        Text11500: Label 'Quote %1';
        To_be_returned_signed_and_dated_for_validationCaptionLbl: Label 'To be returned signed and dated for validation';
        Unit_PriceCaptionLbl: Label 'Unit Price';
        CopyText: Text[30];
        SalesPersonText: Text[30];
        CompanyAddr: array[8] of Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        TotalText: Text[50];
        TxTGContact: Text[50];
        TxTGLabelAmount: Text[50];
        VALExchRate: Text[50];
        OldDimText: Text[75];
        ReferenceText: Text[80];
        VALSpecLCYHeader: Text[80];
        VATNoText: Text[80];
        DimText: Text[120];
        TxtGComment: Text[1024];
}

