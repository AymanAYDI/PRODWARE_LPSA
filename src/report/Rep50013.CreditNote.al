report 50013 "PWD Credit Note"
{
    // ------------------------------------------------------------------------------------------------------------------------------------
    // Prodware : www.prodware.fr
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 
    // //>>LAP2.00
    //     -Report Creation
    //     -Layout Creation
    // 
    // //>>LAP2.02:TU 22/06/2012 : Modify Code : Sales Cr.Memo Header - OnAfterGetRecord()
    // 
    // //>>LAP2.03:BE/PMI 18/10/2012 : Modify Code
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 17/10/2017 : DEMANDES DIVERSES
    //                   - Change Length for C/AL Global TxtGCustPlanNo_C
    // 
    // 
    // //>>HOTLINE
    // TI414158: TO 18/05/2018 Change CstG012, Add CstG014
    //                         Add C/AL in Trigger  Sales Cr.Memo Header - OnAfterGetRecord()
    // 
    // //>>MODIF HL
    // TI426405 DO.GEPO 21/08/2018 : modify the last change by visibility always and change the expression.
    // 
    // //>>NDBI
    // P27818_002 : LALE.PA : 01/03/2021 : cf. demande mail client TI528820
    //                   - Modif C/AL Code in trigger FindCrossRef
    // 
    // //>>NDBI
    // P27818_004 LALE.PA 22/04/2021 : cf. demande mail client TI531940 Ajout Option Envoi par mail.
    //                            Add C/AL Globals BooGEnvoiMail, BooGSkipSendEmail
    //                            Modif RequestPage
    //                            Add Functions SendPDFMail,
    //                                          DownloadToClientFileName,
    //                                          SkipSendEmail
    //                            Add C/AL Code in triggers Report - OnInitReport()
    //                                                      Report - OnPostReport()
    //                            Modif Layout/section
    // 
    // P27818_003 LALE.PA 27/05/2021 : cf. demande mail client TI531940 Ajout Option Envoi par mail. Ajustement suite mise en PROD
    //                            Modif Layout
    // 
    // ------------------------------------------------------------------------------------------------------------------------------------
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/CreditNote.rdl';

    Caption = 'Sales - Credit Memo';
    Permissions = TableData "Sales Shipment Buffer" = rimd;
    UsageCategory = none;

    dataset
    {
        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Posted Sales Credit Memo';
            column(Sales_Cr_Memo_Header_No_; "No.")
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(CustAddr_2_; CustAddr[2])
                    {
                    }
                    column(CustAddr_3_; CustAddr[3])
                    {
                    }
                    column(CustAddr_4_; CustAddr[4])
                    {
                    }
                    column(CustAddr_5_; CustAddr[5])
                    {
                    }
                    column(CustAddr_6_; CustAddr[6])
                    {
                    }
                    column(CompanyInfo_City; FORMAT(CompanyInfo.City) + ',' + FORMAT(TODAY, 0, 4))
                    {
                    }
                    column(FORMAT__Sales_Header___Document_Date__0_4_; FORMAT(WORKDATE(), 0, 4))
                    {
                    }
                    column(Sales_Header___Sell_to_Customer_No__; CustName)
                    {
                    }
                    column(SalesPersonText; Text000)
                    {
                    }
                    column(SalesPurchPerson_Name; SalesPurchPerson.Name)
                    {
                    }
                    column(Sales_Header_VAT_Registration_No_; "Sales Cr.Memo Header"."VAT Registration No.")
                    {
                    }
                    column(Sales_Header_Your_Contact; BSContact)
                    {
                    }
                    column(Sales_Header_No_; "Sales Cr.Memo Header"."No.")
                    {
                    }
                    column(CustAddr_1_; CustAddr[1])
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(CompanyInfo__VAT_Registration_No__; CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(Sales_Cr_Memo_Header___External_Document_No__; "Sales Cr.Memo Header"."External Document No.")
                    {
                    }
                    column(Sales_Header_Document_Date_; "Sales Cr.Memo Header"."Document Date")
                    {
                    }
                    column(Sales_Header_Your_Ref_; "Sales Cr.Memo Header"."Your Reference")
                    {
                    }
                    column(EnvoiMail; BooGEnvoiMail)
                    {
                    }
                    column(STRSUBSTNO_Text013_SalesLine_Line_Amount_SalesLine_Inv_Discount_Amount_VATAmount; STRSUBSTNO(Text013, "Sales Cr.Memo Line"."Amount Including VAT"))
                    {
                    }
                    column(STRSUBSTNO_Text012_Sales_Header_Due_Date; STRSUBSTNO(Text012, "Sales Cr.Memo Header"."Due Date"))
                    {
                    }
                    column(CompanyInfo_Bank_Branch_No_; CompanyInfo."Bank Branch No.")
                    {
                        AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(CompanyInfo_IBAN; CompanyInfo.IBAN)
                    {
                        AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(CompanyInfo_SWIF__Code; CompanyInfo."SWIFT Code")
                    {
                        AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(CompanyInfo_Bank_Account_No_; CompanyInfo."Bank Account No.")
                    {
                        AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Text011_FORMAT_Sales_Header_Payment_Terms_Code; TxTGLabelCondPay)
                    {
                    }
                    column(CompanyInfo_Bank_Name; CompanyInfo."Bank Name")
                    {
                        AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Facture_caption; Facture_captionLbl)
                    {
                    }
                    column(Sales_Header___Sell_to_Customer_No__Caption; Sales_Header___Sell_to_Customer_No__CaptionLbl)
                    {
                    }
                    column(Sales_Header_VAT_Registration_No_caption; Sales_Header_VAT_Registration_No_captionLbl)
                    {
                    }
                    column(Sales_Header_Your_Contact_caption; Sales_Header_Your_Contact_captionLbl)
                    {
                    }
                    column(Sales_Header_No_caption; Sales_Header_No_captionLbl)
                    {
                    }
                    column(Sales_Header_Document_Date_caption; Sales_Header_Document_Date_captionLbl)
                    {
                    }
                    column(Sales_Header_Your_Ref_caption; Sales_Header_Your_Ref_captionLbl)
                    {
                    }
                    column(CompanyInfo_Bank_Branch_No_caption; CompanyInfo_Bank_Branch_No_captionLbl)
                    {
                    }
                    column(CompanyInfo_SWIF__Code_caption; CompanyInfo_SWIF__Code_captionLbl)
                    {
                    }
                    column(CompanyInfo_IBAN_caption; CompanyInfo_IBAN_captionLbl)
                    {
                    }
                    column(CompanyInfo_Bank_Account_No_caption; CompanyInfo_Bank_Account_No_captionLbl)
                    {
                    }
                    column(CompanyInfo_Bank_Name_caption; CompanyInfo_Bank_Name_captionLbl)
                    {
                    }
                    column(PageLoop_Number; Number)
                    {
                    }
                    dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
                    {
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemLinkReference = "Sales Cr.Memo Header";
                        DataItemTableView = SORTING("Document No.", "Line No.");
                        column(AmountCaption; TotalInclVATText)
                        {
                        }
                        column(Sales_Cr_Memo_Line_Description; Description)
                        {
                        }
                        column(Sales_Cr_Memo_Line__No__; "No.")
                        {
                        }
                        column(Sales_Cr_Memo_Line_Description_Control62; "Sales Cr.Memo Line"."PWD LPSA Description 1")
                        {
                        }
                        column(Sales_Cr_Memo_Line_Quantity; Quantity)
                        {
                        }
                        column(Sales_Cr_Memo_Line__Unit_of_Measure_; "Unit of Measure Code")
                        {
                        }
                        column(Sales_Cr_Memo_Line__Unit_Price_; "Unit Price")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Line".GetCurrencyCode();
                            AutoFormatType = 2;
                        }
                        column(Sales_Cr_Memo_Line__Line_Discount___; "Line Discount %")
                        {
                        }
                        column(Sales_Cr_Memo_Line__Line_Amount__Control67; "Line Amount")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Line".GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(Sales_Cr_Memo_Line__VAT_Identifier_; "VAT Identifier")
                        {
                        }
                        column(PostedReceiptDate; FORMAT(PostedReceiptDate))
                        {
                        }
                        column(SalesCrMemoLineType; FORMAT(Type))
                        {
                        }
                        column(NNC_TotalLineAmount; NNC_TotalLineAmount)
                        {
                        }
                        column(NNC_TotalInvDiscAmount; NNC_TotalInvDiscAmount)
                        {
                        }
                        column(Text014; Text014 + '  ' + FORMAT(TempItemLedgEntry."Lot No."))
                        {
                        }
                        column(POS_FORMAT_SalesLine_Position; 'POS  ' + FORMAT("Sales Cr.Memo Line".Position))
                        {
                        }
                        column(ItemType; "Sales Cr.Memo Line".Type::Item = "Sales Cr.Memo Line".Type)
                        {
                        }
                        column(Sales_Cr_Memo_Line_Line_No_; "Sales Cr.Memo Line"."Line No.")
                        {
                        }
                        column(Text015; Text015 + ' ' + FORMAT(CrossReferenceNo))
                        {
                        }
                        column(Text016___FORMAT_Item__Customer_Plan_No___; Text016 + ' ' + TxtGCustPlanNo_C)
                        {
                        }
                        column(Position; "Sales Cr.Memo Line".Position)
                        {
                        }
                        column(LotNo; TempItemLedgEntry."Lot No.")
                        {
                        }
                        column(CrossReferenceNo; CrossReferenceNo)
                        {
                        }
                        column(Item_Customer_Plan_No; Item."PWD Customer Plan No.")
                        {
                        }
                        column(Comment_Line; TxtGComment)
                        {
                        }
                        column(Inv__Discount_Amount_; -"Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Line".GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(Sales_Cr_Memo_Line__Line_Amount__Control96; "Line Amount")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalInclVATText; TotalInclVATText)
                        {
                        }
                        column(Sales_Cr_Memo_Line__Amount_Including_VAT_; "Amount Including VAT")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Line".GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(Amount_Including_VAT____Amount; "Amount Including VAT" - Amount)
                        {
                            AutoFormatExpression = "Sales Cr.Memo Line".GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine_VATAmountText; CstG011 + ' ' + FORMAT(VATAmountLine."VAT %") + '%')
                        {
                        }
                        column(Sales_Cr_Memo_Line_Amount_Control69; Amount)
                        {
                            AutoFormatExpression = "Sales Cr.Memo Line".GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(CstG_012; CstG012)
                        {
                        }
                        column(BooGImpText; IntGImpText)
                        {
                        }
                        column(CstG_014; CstG014)
                        {
                        }
                        column(Sales_Cr_Memo_Line__No__Caption; Sales_Cr_Memo_Line__No__CaptionLbl)
                        {
                        }
                        column(Sales_Cr_Memo_Line_Description_Control62Caption; Sales_Cr_Memo_Line_Description_Control62CaptionLbl)
                        {
                        }
                        column(Sales_Cr_Memo_Line_QuantityCaption; FIELDCAPTION(Quantity))
                        {
                        }
                        column(Sales_Cr_Memo_Line__Unit_of_Measure_Caption; Sales_Cr_Memo_Line__Unit_of_Measure_CaptionLbl)
                        {
                        }
                        column(Unit_PriceCaption; Unit_PriceCaptionLbl)
                        {
                        }
                        column(Sales_Cr_Memo_Line__Line_Discount___Caption; Sales_Cr_Memo_Line__Line_Discount___CaptionLbl)
                        {
                        }
                        column(Sales_Cr_Memo_Line__VAT_Identifier_Caption; FIELDCAPTION("VAT Identifier"))
                        {
                        }
                        column(PostedReceiptDateCaption; PostedReceiptDateCaptionLbl)
                        {
                        }
                        column(SalesLine__Inv__Discount_Amount_Caption; SalesLine__Inv__Discount_Amount_CaptionLbl)
                        {
                        }
                        column(SubtotalCaption; SubtotalCaptionLbl)
                        {
                        }
                        column(Net_AmountCaption; Net_AmountCaptionLbl)
                        {
                        }
                        column(Sales_Cr_Memo_Line_Document_No_; "Document No.")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            NNC_TotalLineAmount += "Line Amount";
                            NNC_TotalAmountInclVat += "Amount Including VAT";
                            NNC_TotalInvDiscAmount += "Inv. Discount Amount";
                            NNC_TotalLCY := NNC_TotalLineAmount - NNC_TotalInvDiscAmount;
                            NNC_TotalAmount += Amount;

                            SalesShipmentBuffer.DELETEALL();
                            PostedReceiptDate := 0D;

                            IF (Type = Type::"G/L Account") AND (NOT ShowInternalInfo) THEN
                                "No." := '';

                            VATAmountLine.INIT();
                            VATAmountLine."VAT Identifier" := "VAT Identifier";
                            VATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
                            VATAmountLine."Tax Group Code" := "Tax Group Code";
                            VATAmountLine."VAT %" := "VAT %";
                            VATAmountLine."VAT Base" := Amount;
                            VATAmountLine."Amount Including VAT" := "Amount Including VAT";
                            VATAmountLine."Line Amount" := "Line Amount";
                            IF "Allow Invoice Disc." THEN
                                VATAmountLine."Inv. Disc. Base Amount" := "Line Amount";
                            VATAmountLine."Invoice Discount Amount" := "Inv. Discount Amount";
                            VATAmountLine.InsertLine();

                            //>>TI414158
                            IF (("Sales Cr.Memo Line".Type = "Sales Cr.Memo Line".Type::Item) AND ("Sales Cr.Memo Line"."Item Category Code" <> 'ACI')) THEN
                                IntGImpText := 1;
                            //<<TI414158

                            SearchLot();
                            //>>TDL.LPSA.09022015
                            TxtGCustPlanNo_C := '';
                            //>>TDL.LPSA.09022015
                            IF Type = Type::Item THEN BEGIN
                                SearchLot();
                                Item.GET("No.");
                                FindCrossRef();
                                //>>TDL.LPSA.09022015
                                IF TxtGCustPlanNo_C = '' THEN
                                    TxtGCustPlanNo_C := Item."PWD Customer Plan No.";
                                //>>TDL.LPSA.09022015
                            END;

                            //>>Regie
                            CLEAR(TxtGComment);
                            BooGStopComment := FALSE;
                            RecGSalesCommentLine.RESET();
                            RecGSalesCommentLine.SETRANGE("Document Type", RecGSalesCommentLine."Document Type"::"Posted Credit Memo");
                            RecGSalesCommentLine.SETRANGE("No.", "Document No.");
                            RecGSalesCommentLine.SETRANGE("Document Line No.", "Line No.");
                            IF RecGSalesCommentLine.FINDSET() THEN
                                REPEAT
                                    IF STRLEN(TxtGComment) + STRLEN(RecGSalesCommentLine.Comment) < 1024 THEN
                                        TxtGComment += RecGSalesCommentLine.Comment + ' '
                                    ELSE
                                        BooGStopComment := TRUE;
                                UNTIL (RecGSalesCommentLine.NEXT() = 0) OR (BooGStopComment);
                        end;

                        // trigger OnPostDataItem()
                        // begin
                        //     TrackingSpecCount := ItemTrackingDocMgt.RetrieveDocumentItemTracking(TrackingSpecBuffer, "Sales Cr.Memo Header"."No.",
                        //       DATABASE::"Sales Shipment Header", 0);
                        // end;

                        trigger OnPreDataItem()
                        begin
                            VATAmountLine.DELETEALL();
                            SalesShipmentBuffer.RESET();
                            SalesShipmentBuffer.DELETEALL();
                            // FirstValueEntryNo := 0;
                            MoreLines := FIND('+');
                            WHILE MoreLines AND (Description = '') AND ("No." = '') AND (Quantity = 0) AND (Amount = 0) DO
                                MoreLines := NEXT(-1) <> 0;
                            IF NOT MoreLines THEN
                                CurrReport.BREAK();
                            SETRANGE("Line No.", 0, "Line No.");
                            // CurrReport.CREATETOTALS(Amount, "Amount Including VAT", "Inv. Discount Amount", VATAmountLine."VAT Base");
                        end;
                    }
                    dataitem(VATAcounter; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(VATAmountLine__VAT_Identifier_; VATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATAmountLine__VAT___; Text018 + ' ' + FORMAT(VATAmountLine."VAT %") + '%')
                        {
                            //DecimalPlaces = 0 : 5;
                        }
                        column(VATAmountLine__VAT_Base__Control105; Text019 + ' ' + FORMAT(VATAmountLine."VAT Base"))
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Amount__Control106; VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TxtGVAT; TxtGVAT)
                        {
                        }
                        column(VATAcounter_Number; Number)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);

                            //>>LAP2.03
                            IF VATAmountLine."VAT %" <> 0 THEN
                                TxtGVAT := Text018 + ' ' + FORMAT(VATAmountLine."VAT %") + '%';
                            //<<LAP2.03
                        end;

                        trigger OnPreDataItem()
                        begin
                            IF VATAmountLine.GetTotalVATAmount() = 0 THEN
                                CurrReport.BREAK();
                            SETRANGE(Number, 1, VATAmountLine.COUNT);
                            // CurrReport.CREATETOTALS(
                            //   VATAmountLine."Line Amount", VATAmountLine."Inv. Disc. Base Amount",
                            //   VATAmountLine."Invoice Discount Amount", VATAmountLine."VAT Base", VATAmountLine."VAT Amount");

                            NNC_VATAmount := VATAmountLine.GetTotalVATAmount();

                            //>>LAP2.03
                            CLEAR(TxtGVAT);
                            //<<LAP2.03
                        end;
                    }
                    dataitem(Total; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                        column(NNC_TotalAmount; NNC_TotalLCY)
                        {
                        }
                        column(NNC_VATAmount; NNC_VATAmount)
                        {
                        }
                        column(NNC_TotalAmountInclVat; NNC_TotalAmountInclVat)
                        {
                        }
                        column(NetAmountCaption; CstG013)
                        {
                        }
                        column(VATCaption; STRSUBSTNO(CstG011, VATAmountLine."VAT %"))
                        {
                        }
                        column(TotalAmountInclVatCaption; TotalText)
                        {
                        }
                        column(Total_Number; Number)
                        {
                        }
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF "Sales Cr.Memo Header"."Bill-to Customer No." = '' THEN BEGIN
                            CustName := "Sales Cr.Memo Header"."Sell-to Customer No.";
                            BSContact := "Sales Cr.Memo Header"."Sell-to Contact";
                        END
                        ELSE BEGIN
                            CustName := "Sales Cr.Memo Header"."Bill-to Customer No.";
                            BSContact := "Sales Cr.Memo Header"."Bill-to Contact";
                        END;
                    end;
                }

                trigger OnAfterGetRecord()
                begin

                    IF Number > 1 THEN BEGIN
                        CopyText := Text004;
                        OutputNo += 1;
                    END;

                    // CurrReport.PAGENO := 1;

                    NNC_TotalLineAmount := 0;
                    NNC_TotalAmountInclVat := 0;
                    NNC_TotalInvDiscAmount := 0;
                    NNC_TotalAmount := 0;
                    NNC_TotalLCY := 0;
                    NNC_VATAmount := 0;
                end;

                trigger OnPostDataItem()
                begin
                    IF NOT CurrReport.PREVIEW THEN
                        SalesCrMemoCountPrinted.RUN("Sales Cr.Memo Header");
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := ABS(NoOfCopies) + 1;
                    CopyText := '';
                    SETRANGE(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

                //>>TI414158
                IntGImpText := 0;
                //<<TI414158

                CompanyInfo.GET();

                IF RespCenter.GET("Responsibility Center") THEN BEGIN
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                END ELSE
                    FormatAddr.Company(CompanyAddr, CompanyInfo);
                DimSetEntry1.SETRANGE("Dimension Set ID", DATABASE::"Sales Cr.Memo Header");
                // PostedDocDim1.SETRANGE("Table ID", DATABASE::"Sales Cr.Memo Header");
                // PostedDocDim1.SETRANGE("Document No.", "Sales Cr.Memo Header"."No.");

                IF "Return Order No." = '' THEN
                    ReturnOrderNoText := ''
                ELSE
                    ReturnOrderNoText := FIELDCAPTION("Return Order No.");
                IF "Salesperson Code" = '' THEN BEGIN
                    SalesPurchPerson.INIT();
                    SalesPersonText := '';
                END ELSE BEGIN
                    SalesPurchPerson.GET("Salesperson Code");
                    SalesPersonText := Text000;
                END;
                IF "Your Reference" = '' THEN
                    ReferenceText := ''
                ELSE
                    ReferenceText := FIELDCAPTION("Your Reference");
                IF "VAT Registration No." = '' THEN
                    VATNoText := ''
                ELSE
                    VATNoText := FIELDCAPTION("VAT Registration No.");
                IF "Currency Code" = '' THEN BEGIN
                    GLSetup.TESTFIELD("LCY Code");
                    TotalText := STRSUBSTNO(Text001, GLSetup."LCY Code");
                    TotalInclVATText := STRSUBSTNO(Text002, GLSetup."LCY Code");
                    TotalExclVATText := STRSUBSTNO(Text007, GLSetup."LCY Code");
                END ELSE BEGIN
                    TotalText := STRSUBSTNO(Text001, "Currency Code");
                    TotalInclVATText := STRSUBSTNO(Text002, "Currency Code");
                    TotalExclVATText := STRSUBSTNO(Text007, "Currency Code");
                END;

                //>>LAP2.02
                //STD FormatAddr.SalesCrMemoBillTo(CustAddr,"Sales Cr.Memo Header");
                LPSAFunctionsMgt.SalesCrMemoBillToFixedAddr(CustAddr, "Sales Cr.Memo Header");
                //<<LAP2.02

                IF "Applies-to Doc. No." = '' THEN
                    AppliedToText := ''
                ELSE
                    AppliedToText := STRSUBSTNO(Text003, "Applies-to Doc. Type", "Applies-to Doc. No.");

                FormatAddr.SalesCrMemoShipTo(ShipToAddr, CustAddr, "Sales Cr.Memo Header");
                // ShowShippingAddr := "Sell-to Customer No." <> "Bill-to Customer No.";
                // FOR i := 1 TO ARRAYLEN(ShipToAddr) DO
                //     IF ShipToAddr[i] <> CustAddr[i] THEN
                //         ShowShippingAddr := TRUE;

                IF LogInteraction THEN
                    IF NOT CurrReport.PREVIEW THEN
                        SegManagement.LogDocument(
                          6, "No.", 0, 0, DATABASE::Customer, "Sell-to Customer No.", "Salesperson Code",
                          "Campaign No.", "Posting Description", '');

                IF "Payment Terms Code" = '' THEN
                    PaymentTerms.INIT()
                ELSE BEGIN
                    PaymentTerms.GET("Payment Terms Code");
                    PaymentTerms.TranslateDescription(PaymentTerms, "Sales Cr.Memo Header"."Language Code");
                    TxTGLabelCondPay := STRSUBSTNO(Text017, PaymentTerms.Description);
                END;
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
                    field(NoOfCopiesF; NoOfCopies)
                    {
                        Caption = 'No. of Copies';
                        ApplicationArea = All;
                    }
                    field("Envoyer par email"; BooGEnvoiMail)
                    {
                        Caption = 'Send by email';
                        ApplicationArea = All;
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
    }

    trigger OnInitReport()
    begin
        GLSetup.GET();

        //>>NDBI
        BooGEnvoiMail := TRUE;
        //<<NDBI
    end;

    trigger OnPostReport()
    var
        RecLSalesCrMHeader: Record "Sales Cr.Memo Header";
    begin
        //>>NDBI
        IF NOT BooGSkipSendEmail AND BooGEnvoiMail THEN BEGIN
            RecLSalesCrMHeader.SETVIEW("Sales Cr.Memo Header".GETVIEW());
            //SendPDFMail(RecLSalesCrMHeader);
            RecLSalesCrMHeader.EmailRecords(true);
        END;
        //<<NDBI
    end;

    trigger OnPreReport()
    begin
        IF NOT CurrReport.USEREQUESTPAGE THEN;
    end;

    var
        CompanyInfo: Record "Company Information";
        //TODO: Table 'Posted Document Dimension' is missing
        // PostedDocDim1: Record "Posted Document Dimension";
        // PostedDocDim2: Record "Posted Document Dimension";
        DimSetEntry1: Record "Dimension Set Entry";
        GLSetup: Record "General Ledger Setup";
        Item: Record Item;
        ItemCrossRef: Record "Item Reference";
        ItemLedgEntry: Record "Item Ledger Entry";
        TempItemLedgEntry: Record "Item Ledger Entry";
        PaymentTerms: Record "Payment Terms";
        RespCenter: Record "Responsibility Center";
        RecGSalesCommentLine: Record "Sales Comment Line";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        SalesShipmentBuffer: Record "Sales Shipment Buffer" temporary;
        // TrackingSpecBuffer: Record "Tracking Specification" temporary;
        ValueEntry: Record "Value Entry";
        ValueEntryRelation: Record "Value Entry Relation";
        VATAmountLine: Record "VAT Amount Line" temporary;
        FormatAddr: Codeunit "Format Address";
        // ItemTrackingMgt: Codeunit "Item Tracking Management";
        // ItemTrackingDocMgt: Codeunit "Item Tracking Doc. Management";
        Language: Codeunit Language;
        LPSAFunctionsMgt: codeunit "PWD LPSA Functions Mgt.";
        SalesCrMemoCountPrinted: Codeunit "Sales Cr. Memo-Printed";
        SegManagement: Codeunit SegManagement;
        BooGEnvoiMail: Boolean;
        BooGSkipSendEmail: Boolean;
        BooGStopComment: Boolean;
        LogInteraction: Boolean;
        MoreLines: Boolean;
        ShowInternalInfo: Boolean;
        // ShowShippingAddr: Boolean;
        CrossReferenceNo: Code[20];
        CustName: Code[20];
        PostedReceiptDate: Date;
        NNC_TotalAmount: Decimal;
        NNC_TotalAmountInclVat: Decimal;
        NNC_TotalInvDiscAmount: Decimal;
        NNC_TotalLCY: Decimal;
        NNC_TotalLineAmount: Decimal;
        NNC_VATAmount: Decimal;
        // FirstValueEntryNo: Integer;
        // i: Integer;
        IntGImpText: Integer;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        OutputNo: Integer;
        // TrackingSpecCount: Integer;
        CompanyInfo_Bank_Account_No_captionLbl: Label 'Bank Account';
        CompanyInfo_Bank_Branch_No_captionLbl: Label 'Bank Code';
        CompanyInfo_Bank_Name_captionLbl: Label 'Bank Name';
        CompanyInfo_IBAN_captionLbl: Label 'IBAN Code';
        CompanyInfo_SWIF__Code_captionLbl: Label 'SWIFT/BIC Code';
        CstG011: Label '%1% VAT';
        CstG012: Label 'Origine non préférentielle: Les marchandises auxquelles se rapporte le présent document commercial sont originaires de Suisse selon les dispositions des articles 9 à 16 de l''ordonnance du 9 avril 2008 sur l''attestation de l''origine non préférentielle des marchandises (OOr) et de l''ordonnance du DEFR du 9 avril 2008 sur l''attestation de l''origine non préférentielle des marchandises (OOr-DEFR).La marchandise a été produite par notre entreprise.L''auteur de la présente déclaration d''origine a pris connaissance du fait que l''indication inexacte de l''origine selon les art. 9 ss OOr et les art. 2 ss OOr-DEFR entraîne des mesures de droit administratif et des poursuites pénales.';
        CstG013: Label 'Net Amount';
        CstG014: Label 'Origine préférentielle: Nous attestons par la présente que les marchandises susmentionnées, sont originaires de Suisse et satisfont aux règles d''origine régissant les échanges préférentiels avec CE, AELE, SACU, AL, CA CL, CO EG, FO, HR, HK, IL, JO, JP, KR, LB, ME, MK, MA, MX, PE, RS, SG, TN, TR, UA, CN, CR, PA, GCC. Peut être complétée, selon les cas avec :Aucun cumul appliqué (no cumulation applied) / " PSR " : fabriqué en Suisse ou en Chine en utilisant des matières non originaires et remplissant les " Products Specific Rules " et autres conditions du chapitre 3 de l''accord de libre-échange avec la Chine (suffisamment ouvré).';
        Facture_captionLbl: Label 'Credit Note';
        Net_AmountCaptionLbl: Label 'Net Amount';
        PostedReceiptDateCaptionLbl: Label 'Posted Return Receipt Date';
        Sales_Cr_Memo_Line__Line_Discount___CaptionLbl: Label 'Disc. %';
        Sales_Cr_Memo_Line__No__CaptionLbl: Label 'No.';
        Sales_Cr_Memo_Line__Unit_of_Measure_CaptionLbl: Label 'Unit';
        Sales_Cr_Memo_Line_Description_Control62CaptionLbl: Label 'Description';
        Sales_Header___Sell_to_Customer_No__CaptionLbl: Label 'Customer No. : ';
        Sales_Header_Document_Date_captionLbl: Label 'Your Document Date: ';
        Sales_Header_No_captionLbl: Label 'Document No. : ';
        Sales_Header_VAT_Registration_No_captionLbl: Label 'VAT Registration No. : ';
        Sales_Header_Your_Contact_captionLbl: Label 'Your Contact: ';
        Sales_Header_Your_Ref_captionLbl: Label 'Your Document No. :  ';
        SalesLine__Inv__Discount_Amount_CaptionLbl: Label 'Discount';
        SubtotalCaptionLbl: Label 'Subtotal';
        Text000: Label 'Your contact : ';
        Text001: Label 'Total %1';
        Text002: Label 'Total %1 Incl. VAT';
        Text003: Label '(Applies to %1 %2)';
        Text004: Label 'COPY';
        Text007: Label 'Total %1 Excl. VAT';
        Text012: Label 'Due Date';
        Text013: Label 'Montant %1';
        Text014: Label 'LPSA No.';
        Text015: Label 'Your Item Ref.';
        Text016: Label 'You Pan No.';
        Text017: Label 'Payment Terms   %1';
        Text018: Label '  VAT';
        Text019: Label 'of';
        Unit_PriceCaptionLbl: Label 'Unit Price';
        TxtGVAT: Text[10];
        CopyText: Text[30];
        SalesPersonText: Text[30];
        AppliedToText: Text[40];
        BSContact: Text[50];
        CompanyAddr: array[8] of Text[50];
        CustAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        TotalText: Text[50];
        ReferenceText: Text[80];
        ReturnOrderNoText: Text[80];
        VATNoText: Text[80];
        TxtGCustPlanNo_C: Text[100];
        TxTGLabelCondPay: Text[250];
        TxtGComment: Text[1024];


    procedure SearchLot()
    begin
        CLEAR(TempItemLedgEntry);
        ValueEntryRelation.SETCURRENTKEY("Source RowId");
        ValueEntryRelation.SETRANGE("Source RowId", "Sales Cr.Memo Line".RowID1());
        IF ValueEntryRelation.FIND('-') THEN
            REPEAT
                ValueEntry.GET(ValueEntryRelation."Value Entry No.");
                ItemLedgEntry.GET(ValueEntry."Item Ledger Entry No.");
                TempItemLedgEntry := ItemLedgEntry;
                TempItemLedgEntry.Quantity := ValueEntry."Invoiced Quantity";
            UNTIL ValueEntryRelation.NEXT() = 0;
    end;


    procedure FindCrossRef()
    begin
        CLEAR(CrossReferenceNo);
        ItemCrossRef.SETRANGE("Item No.", "Sales Cr.Memo Line"."No.");
        ItemCrossRef.SETRANGE("Variant Code", "Sales Cr.Memo Line"."Variant Code");
        ItemCrossRef.SETRANGE("Unit of Measure", "Sales Cr.Memo Line"."Unit of Measure Code");
        ItemCrossRef.SETRANGE("Reference Type", ItemCrossRef."Reference Type"::Customer);
        ItemCrossRef.SETRANGE("Reference Type No.", "Sales Cr.Memo Header"."Sell-to Customer No.");
        IF ItemCrossRef.FINDFIRST() THEN BEGIN
            CrossReferenceNo := ItemCrossRef."Reference No.";
            //>>TDL.LPSA.09022015
            TxtGCustPlanNo_C := ItemCrossRef."PWD Customer Plan No.";
            //>>TDL.LPSA.09022015
        END;

        //>>NDBI
        IF "Sales Cr.Memo Line"."Item Reference No." <> '' THEN BEGIN
            CrossReferenceNo := "Sales Cr.Memo Line"."Item Reference No.";
            IF ItemCrossRef.GET("Sales Cr.Memo Line"."No.",
                                "Sales Cr.Memo Line"."Variant Code",
                                "Sales Cr.Memo Line"."Unit of Measure Code",
                                ItemCrossRef."Reference Type"::Customer,
                                "Sales Cr.Memo Header"."Sell-to Customer No.",
                                "Sales Cr.Memo Line"."Item Reference No.") THEN
                TxtGCustPlanNo_C := ItemCrossRef."PWD Customer Plan No.";
        END;
        //<<NDBI
    end;

    procedure SendPDFMail(var RecPSalesCrMHeader: Record "Sales Cr.Memo Header")
    var
        RepLCreditNote: Report "PWD Credit Note";
        CodLMail: Codeunit Mail;
        FileMgt: Codeunit "File Management";
        CstL001: Label 'LA PIERRETTE SA : Sales Invoice %1';
        CstL002: Label 'Next the invoice following your order %1';
        Recipient: Text[80];
        Body: Text[100];
        Subject: Text[100];
        TxtLFileName: Text[250];
        TxtLServerFile: Text[250];
    begin
        TxtLServerFile := FileMgt.ServerTempFileName('');
        RepLCreditNote.SkipSendEmail(TRUE);
        RepLCreditNote.SETTABLEVIEW(RecPSalesCrMHeader);
        RepLCreditNote.SAVEASPDF(TxtLServerFile);
        CLEAR(Recipient);
        CLEAR(CodLMail);

        RecPSalesCrMHeader.FINDFIRST();

        // pas besoin d'avoir l'adresse destinataire rempli mais ça va peut être évoluer.
        /*
        RecLContBusRel.RESET;
        RecLContBusRel.SETRANGE("Link to Table",RecLContBusRel."Link to Table"::Customer);
        RecLContBusRel.SETRANGE("No.",RecPSalesCrMHeader."Sell-to Customer No.");
        IF RecLContBusRel.FINDFIRST THEN
          IF RecLContact.GET(RecLContBusRel."Contact No.") THEN
            Recipient := RecLContact."E-Mail"
          ELSE
          BEGIN
            IF RecLCustomer.GET(RecPSalesCrMHeader."Sell-to Customer No.") THEN
              Recipient := RecLCustomer."E-Mail";
         END;
        */


        Subject := STRSUBSTNO(CstL001, RecPSalesCrMHeader."No.");
        Body := STRSUBSTNO(CstL002, RecPSalesCrMHeader."Your Reference");

        TxtLFileName := STRSUBSTNO('AVOIR N° %1.pdf', RecPSalesCrMHeader."No.");
        TxtLFileName := DownloadToClientFileName(TxtLServerFile, TxtLFileName);
        //Open E-Mail
        CodLMail.NewMessage(Recipient, '', '', Subject, Body, TxtLFileName, TRUE);

    end;


    procedure DownloadToClientFileName(TxtPServerFile: Text[250]; TxtPFileName: Text[250]): Text[250]
    var
        FileManagement: Codeunit "File Management";
        TxtLClientFileName: Text[250];
        TxtLFinalClientFileName: Text[250];
    //TODO: 'Automation' is not recognized as a valid type
    //AutLFileObjectSystem: Automation;
    //TODO: Codeunit '3-Tier Automation Mgt.' is missing
    // CduLTierAutomationMgt: Codeunit "3-Tier Automation Mgt.";
    begin
        //TODO: Codeunit '3-Tier Automation Mgt.' is missing
        // TxtLClientFileName := CduLTierAutomationMgt.ClientTempFileName('', '');
        // TxtLFinalClientFileName := CduLTierAutomationMgt.Path(TxtLClientFileName) + TxtPFileName;
        // DOWNLOAD(TxtPServerFile, '', '', '', TxtLClientFileName);
        FileManagement.DownloadHandler(TxtPServerFile, '', '', '', TxtLClientFileName);
        //TODO: 'Automation' is not recognized as a valid type
        // CREATE(AutLFileObjectSystem, FALSE, TRUE);
        // IF AutLFileObjectSystem.FileExists(TxtLFinalClientFileName) THEN
        //     AutLFileObjectSystem.DeleteFile(TxtLFinalClientFileName, TRUE);
        // AutLFileObjectSystem.MoveFile(TxtLClientFileName, TxtLFinalClientFileName);
        EXIT(TxtLFinalClientFileName);
    end;


    procedure SkipSendEmail(BooPSkipSendEmail: Boolean)
    begin
        BooGSkipSendEmail := BooPSkipSendEmail;
    end;
}

