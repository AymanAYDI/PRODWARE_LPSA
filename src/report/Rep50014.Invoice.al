report 50014 "PWD Invoice"
{
    // ------------------------------------------------------------------------------------------------------------------------------------
    // Prodware : www.prodware.fr
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 
    // //>>LAP2.00
    //     -Report Creation
    //     -Layout Creation
    // 
    // //>>LAP2.01 :TU 14/06/2012
    //                   -Correction Vat % Caption
    // 
    // //>>LAP2.03 :TO 11/09/2012      (PT TDL 115)
    //                   - Modify Code : Sales Invoice Header - OnAfterGetRecord()
    // 
    // //>>TDL.125
    // Point125 LY.NIBO 12/03/2013 : MIssing total when multipage
    // 
    // //>>MODIF HL
    // TI302984 DO.GEPO 01/12/2015 : add test in Sales Invoice Line - OnAfterGetRecord()
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 17/10/2017 : DEMANDES DIVERSES
    //                   - Change Length for C/AL Global TxtGCustPlanNo_C
    // 
    // //>>HOTLINE
    // TI397445: TO 17/12/2017 Change CstG013
    // 
    // TI406733: TO 26/02/2018 Modify Report Properties on Layout: Print on first page = true
    // 
    // //>>MODIF HL
    // TI472449 DO.GEPO 28/10/2019 : add condition on Sales Invoice Line - OnAfterGetRecord()
    // 
    // //>>MODIF HL
    // TI512076 DO.GEPO 01/10/2020 : add logo and text in footer like report 50009
    // 
    // //>>NDBI
    // P27818_001 LALE.PA 13/10/2020 : Ajout Option Envoi par mail.
    //                            Add C/AL Globals BooGEnvoiMail, BooGSkipSendEmail
    //                            Modif RequestPage
    //                            Add Functions SendPDFMail,
    //                                          DownloadToClientFileName,
    //                                          SkipSendEmail
    //                            Add C/AL Code in triggers Report - OnInitReport()
    //                                                      Report - OnPostReport()
    //                            Modif Layout/section
    // 
    // //>>NDBI
    // P27818_002 : LALE.PA : 01/03/2021 : cf. demande mail client TI528820
    //                   - Modif C/AL Code in trigger FindCrossRef
    // 
    // P27818_004 LALE.PA 22/04/2021 : cf. demande mail client TI531940 Ajout Option Envoi par mail.
    //                   - Modif C/AL Code in trigger CopyLoop - OnPreDataItem()
    // 
    // P27818_003 LALE.PA 27/05/2021 : cf. demande mail client TI531940 Ajout Option Envoi par mail. Ajustement suite mise en PROD
    //                            Modif Layout
    // 
    // ------------------------------------------------------------------------------------------------------------------------------------
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/Invoice.rdl';

    Caption = 'Sales - Invoice';
    Permissions = TableData "Sales Shipment Buffer" = rimd;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Posted Sales Invoice';
            column(Sales_Invoice_Header_No_; "No.")
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(Sales_Header_No_; "Sales Invoice Header"."No.")
                    {
                    }
                    column(Sales_Header___Sell_to_Customer_No__; CustName)
                    {
                    }
                    column(Sales_Header_VAT_Registration_No_; "Sales Invoice Header"."VAT Registration No.")
                    {
                    }
                    column(Sales_Header_Your_Contact; BSContact)
                    {
                    }
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
                    column(CompanyInfo_City; CompanyInfo.City + ', ' + Format(Today, 0, 4))
                    {
                    }
                    column(SalesPersonText; Text000)
                    {
                    }
                    column(CustAddr_1_; CustAddr[1])
                    {
                    }
                    column(SalesPurchPerson_Name; SalesPurchPerson.Name)
                    {
                    }
                    column(FORMAT__Sales_Header___Document_Date__0_4_; Format(WorkDate(), 0, 4))
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(codebarre; "Sales Invoice Header"."External Document No.")
                    {
                    }
                    column(Sales_Header_VAT_Registration_No__; "Sales Invoice Header"."VAT Registration No.")
                    {
                    }
                    column(Sales_Header_Your_Ref_; "Sales Invoice Header"."Your Reference")
                    {
                    }
                    column(Sales_Header_Document_Date_; "Sales Invoice Header"."Document Date")
                    {
                    }
                    column(CompanyInfo__VAT_Registration_No__; CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(EnvoiMail; BooGEnvoiMail)
                    {
                    }
                    column(Facture_caption; Facture_captionLbl)
                    {
                    }
                    column(Sales_Header_No_caption; Sales_Header_No_captionLbl)
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
                    column(Sales_Header_Your_Ref_caption; Sales_Header_Your_Ref_captionLbl)
                    {
                    }
                    column(Sales_Header_Document_Date_caption; Sales_Header_Document_Date_captionLbl)
                    {
                    }
                    column(PageLoop_Number; Number)
                    {
                    }
                    dataitem("Sales Invoice Line"; "Sales Invoice Line")
                    {
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemLinkReference = "Sales Invoice Header";
                        DataItemTableView = SORTING("Document No.", "Line No.");
                        column(AmountCaption; TotalInclVATText)
                        {
                        }
                        column(Sales_Invoice_Line_Description; Description)
                        {
                        }
                        column(Sales_Invoice_Line_Type; Type)
                        {
                        }
                        column(Sales_Invoice_Line__No__; CopyStr("No.", 1, 8))
                        {
                        }
                        column(Sales_Invoice_Line__Sales_Invoice_Line___LPSA_Description_1_; "Sales Invoice Line"."PWD LPSA Description 1")
                        {
                        }
                        column(Sales_Invoice_Line_Quantity; Quantity)
                        {
                        }
                        column(Sales_Invoice_Line__Unit_of_Measure_; "Unit of Measure Code")
                        {
                        }
                        column(Sales_Invoice_Line__Unit_Price_; "Unit Price")
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode();
                            AutoFormatType = 2;
                        }
                        column(Sales_Invoice_Line__Line_Discount___; "Line Discount %")
                        {
                        }
                        column(Sales_Invoice_Line__Line_Amount__Control70; "Line Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(Sales_Invoice_Line__VAT_Identifier_; "VAT Identifier")
                        {
                        }
                        column(PostedShipmentDate; Format(PostedShipmentDate))
                        {
                        }
                        column(SalesLineType; Format("Sales Invoice Line".Type))
                        {
                        }
                        column(AfficherligneComptegeneral; AfficherligneComptegeneral)
                        {
                        }
                        column(POS_FORMAT_SalesLine_Position; 'POS ' + '' + Format("Sales Invoice Line".Position))
                        {
                        }
                        column(Your_Item_Reference; Text015 + ' ' + Format(CrossReferenceNo))
                        {
                        }
                        column(You_Plan_No; Text016 + ' ' + TxtGCustPlanNo_C)
                        {
                        }
                        column(SalesLineNo; "Sales Invoice Line"."Line No.")
                        {
                        }
                        column(ItemType; "Sales Invoice Line".Type::Item = "Sales Invoice Line".Type)
                        {
                        }
                        column(Position; "Sales Invoice Line".Position)
                        {
                        }
                        column(LotNo; TempItemLedgEntry."Lot No.")
                        {
                        }
                        column(Text014____FORMAT_TempItemLedgEntry__Lot_No___; Text014 + ' ' + Format(TempItemLedgEntry."Lot No."))
                        {
                        }
                        column(Item_Customer_Plan_No; Item."Customer Plan No.")
                        {
                        }
                        column(CrossReferenceNo; CrossReferenceNo)
                        {
                        }
                        column(GetTotalInvDiscAmount; GetTotalInvDiscAmount)
                        {
                        }
                        column(GetTotalLineAmount; GetTotalLineAmount)
                        {
                        }
                        column(GetTotalAmount; GetTotalAmount)
                        {
                        }
                        column(GetTotalAmountIncVAT; GetTotalAmountIncVAT)
                        {
                        }
                        column(Inv__Discount_Amount_; -"Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(Sales_Invoice_Line__Line_Amount__Control99; "Line Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalSubTotal; TotalSubTotal)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalInvoiceDiscountAmount; TotalInvoiceDiscountAmount)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Sales_Invoice_Line_Amount_Control90; Amount)
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(Amount_Including_VAT____Amount; "Amount Including VAT" - Amount)
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(Sales_Invoice_Line__Amount_Including_VAT_; "Amount Including VAT")
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine_VATAmountText; StrSubstNo(CstG012, VATAmountLine."VAT %") + '%')
                        {
                        }
                        column(TotalInclVATText__; TotalInclVATText)
                        {
                        }
                        column(TotalAmountInclVAT; TotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmountVAT; TotalAmountVAT)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmount; TotalAmount)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(CstG_013; CstG013)
                        {
                        }
                        column(CstG_014; CstG014)
                        {
                        }
                        column(BooGImpText; IntGImpText)
                        {
                        }
                        column(STRSUBSTNO_Text012_Sales_Header_Due_Date; Text012)
                        {
                        }
                        column(CompanyInfo_IBAN; CompanyInfo.IBAN)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(CompanyInfo_SWIF__Code; CompanyInfo."SWIFT Code")
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(CompanyInfo_Bank_Branch_No_; CompanyInfo."Bank Branch No.")
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(CompanyInfo_Bank_Account_No_; CompanyInfo."Bank Account No.")
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(STRSUBSTNO_Text013_SalesLine_Line_Amount_SalesLine_Inv_Discount_Amount_VATAmount; Text013)
                        {
                        }
                        column(Text011_FORMAT_Sales_Header_Payment_Terms_Code; TxTGLabelCondPay)
                        {
                        }
                        column(CompanyInfo_Bank_Name; CompanyInfo."Bank Name")
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(DueDate; Format("Sales Invoice Header"."Due Date"))
                        {
                        }
                        column(Sales_Invoice_Line__No__Caption; Sales_Invoice_Line__No__CaptionLbl)
                        {
                        }
                        column(Sales_Invoice_Line_Description_Control65Caption; Sales_Invoice_Line_Description_Control65CaptionLbl)
                        {
                        }
                        column(Sales_Invoice_Line_QuantityCaption; FieldCaption(Quantity))
                        {
                        }
                        column(Sales_Invoice_Line__Unit_of_Measure_Caption; Sales_Invoice_Line__Unit_of_Measure_CaptionLbl)
                        {
                        }
                        column(Unit_PriceCaption; Unit_PriceCaptionLbl)
                        {
                        }
                        column(Sales_Invoice_Line__Line_Discount___Caption; Sales_Invoice_Line__Line_Discount___CaptionLbl)
                        {
                        }
                        column(Sales_Invoice_Line__VAT_Identifier_Caption; FieldCaption("VAT Identifier"))
                        {
                        }
                        column(PostedShipmentDateCaption; PostedShipmentDateCaptionLbl)
                        {
                        }
                        column(Inv__Discount_Amount_Caption; Inv__Discount_Amount_CaptionLbl)
                        {
                        }
                        column(SubtotalCaption; SubtotalCaptionLbl)
                        {
                        }
                        column(TotalExclVATText; TotalExclVATTextLbl)
                        {
                        }
                        column(CompanyInfo_SWIF__Code_caption; CompanyInfo_SWIF__Code_captionLbl)
                        {
                        }
                        column(CompanyInfo_IBAN_caption; CompanyInfo_IBAN_captionLbl)
                        {
                        }
                        column(CompanyInfo_Bank_Branch_No_caption; CompanyInfo_Bank_Branch_No_captionLbl)
                        {
                        }
                        column(CompanyInfo_Bank_Account_No_caption; CompanyInfo_Bank_Account_No_captionLbl)
                        {
                        }
                        column(CompanyInfo_Bank_Name_caption; CompanyInfo_Bank_Name_captionLbl)
                        {
                        }
                        column(Sales_Invoice_Line_Document_No_; "Document No.")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            Clear(CrossReferenceNo);
                            if (Type = Type::"G/L Account") and (not ShowInternalInfo) then
                                "No." := '';

                            //>>TI302984
                            if "Sales Invoice Line".Type <> "Sales Invoice Line".Type::" " then begin
                                //<<TI302984
                                VATAmountLine.Init();
                                VATAmountLine."VAT Identifier" := "VAT Identifier";
                                VATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
                                VATAmountLine."Tax Group Code" := "Tax Group Code";
                                VATAmountLine."VAT %" := "VAT %";
                                VATAmountLine."VAT Base" := Amount;
                                VATAmountLine."Amount Including VAT" := "Amount Including VAT";
                                VATAmountLine."Line Amount" := "Line Amount";
                                if "Allow Invoice Disc." then
                                    VATAmountLine."Inv. Disc. Base Amount" := "Line Amount";
                                VATAmountLine."Invoice Discount Amount" := "Inv. Discount Amount";
                                VATAmountLine.InsertLine();
                                //>>TI302984
                            end;
                            //<<TI302984

                            //>>TI397445
                            if (("Sales Invoice Line".Type = "Sales Invoice Line".Type::Item) and ("Sales Invoice Line"."Item Category Code" <> 'ACI')
                              //>>TI472449
                              and ("Sales Invoice Line"."Item Category Code" <> 'ACI_PF')) then
                                //<<TI472449
                                IntGImpText := 1;
                            //<<TI397445

                            if IsServiceTier then begin
                                TotalSubTotal += "Line Amount";
                                TotalInvoiceDiscountAmount -= "Inv. Discount Amount";
                                TotalAmount += Amount;
                                TotalAmountVAT += "Amount Including VAT" - Amount;
                                TotalAmountInclVAT += "Amount Including VAT";
                                TotalPaymentDiscountOnVAT += -("Line Amount" - "Inv. Discount Amount" - "Amount Including VAT");
                            end;
                            SearchLot();

                            //>>TDL.LPSA.09022015
                            TxtGCustPlanNo_C := '';
                            //<<TDL.LPSA.09022015
                            if Type = Type::Item then begin
                                Item.Get("No.");
                                FindCrossRef();
                                //>>TDL.LPSA.09022015
                                if TxtGCustPlanNo_C = '' then
                                    TxtGCustPlanNo_C := Item."Customer Plan No.";
                                //<<TDL.LPSA.09022015
                            end;

                            if ("Sales Invoice Line".Type = 0) then
                                AfficherligneComptegeneral := true
                            else
                                AfficherligneComptegeneral := false;
                        end;

                        trigger OnPreDataItem()
                        begin
                            VATAmountLine.DeleteAll();
                            SalesShipmentBuffer.Reset();
                            SalesShipmentBuffer.DeleteAll();
                            FirstValueEntryNo := 0;
                            MoreLines := Find('+');
                            while MoreLines and (Description = '') and ("No." = '') and (Quantity = 0) and (Amount = 0) do
                                MoreLines := Next(-1) <> 0;
                            if not MoreLines then
                                CurrReport.Break();
                            SetRange("Line No.", 0, "Line No.");
                            CurrReport.CreateTotals("Line Amount", Amount, "Amount Including VAT", "Inv. Discount Amount", VATAmountLine."VAT Base");

                            if IsServiceTier then begin
                                GetTotalLineAmount := 0;
                                GetTotalInvDiscAmount := 0;
                                GetTotalAmount := 0;
                                GetTotalAmountIncVAT := 0;
                            end;
                        end;
                    }
                    dataitem(VATCounter; "Integer")
                    {
                        column(VATAmountLine__VAT_Identifier_; VATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATAmountLine__VAT_Amount__Control107; VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Base__Control106; Text018 + ' ' + Format(VATAmountLine."VAT Base"))
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Text015_____FORMAT_VATAmountLine__VAT__________; Text017 + ' ' + Format(VATAmountLine."VAT %") + '%')
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATCounter_Number; Number)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                        end;

                        trigger OnPreDataItem()
                        begin
                            if VATAmountLine.GetTotalVATAmount() = 0 then
                                CurrReport.Break();
                            SetRange(Number, 1, VATAmountLine.Count);
                            CurrReport.CreateTotals(
                              VATAmountLine."Line Amount", VATAmountLine."Inv. Disc. Base Amount",
                              VATAmountLine."Invoice Discount Amount", VATAmountLine."VAT Base", VATAmountLine."VAT Amount");
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if "Sales Invoice Header"."Bill-to Customer No." = '' then begin
                            CustName := "Sales Invoice Header"."Sell-to Customer No.";
                            BSContact := "Sales Invoice Header"."Sell-to Contact";
                        end
                        else begin
                            CustName := "Sales Invoice Header"."Bill-to Customer No.";
                            BSContact := "Sales Invoice Header"."Bill-to Contact";
                        end;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                        CopyText := Text003;
                        if IsServiceTier then
                            OutputNo += 1;
                    end;
                    CurrReport.PageNo := 1;

                    if IsServiceTier then begin
                        TotalSubTotal := 0;
                        TotalInvoiceDiscountAmount := 0;
                        TotalAmount := 0;
                        TotalAmountVAT := 0;
                        TotalAmountInclVAT := 0;
                        TotalPaymentDiscountOnVAT := 0;
                    end
                end;

                trigger OnPostDataItem()
                begin
                    if not CurrReport.Preview then
                        SalesInvCountPrinted.Run("Sales Invoice Header");
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopies) + Cust."Invoice Copies" + 1;
                    if NoOfLoops <= 0 then
                        NoOfLoops := 1;

                    //>>NDBI
                    if BooGSkipSendEmail then
                        NoOfLoops := 1;
                    //<<NDBI

                    CopyText := '';
                    SetRange(Number, 1, NoOfLoops);
                    if IsServiceTier then
                        OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CurrReport.Language := Language.GetLanguageID("Language Code");

                //>>TI397445
                IntGImpText := 0;
                //<<TI397445

                if RespCenter.Get("Responsibility Center") then begin
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                end else
                    FormatAddr.Company(CompanyAddr, CompanyInfo);

                PostedDocDim1.SetRange("Table ID", DATABASE::"Sales Invoice Header");
                PostedDocDim1.SetRange("Document No.", "Sales Invoice Header"."No.");

                if "Order No." = '' then
                    OrderNoText := ''
                else
                    OrderNoText := FieldCaption("Order No.");
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
                    TotalInclVATText := StrSubstNo(Text001, GLSetup."LCY Code");
                    TotalExclVATText := StrSubstNo(Text006, GLSetup."LCY Code");
                end else begin
                    TotalText := StrSubstNo(Text001, "Currency Code");
                    TotalInclVATText := StrSubstNo(Text001, "Currency Code");
                    TotalExclVATText := StrSubstNo(Text006, "Currency Code");
                end;

                //>>LAP2.03 :TO 11/09/2012      (PT TDL 114)
                //FormatAddr.SalesInvBillTo(CustAddr,"Sales Invoice Header");
                FormatAddr.SalesInvBillToFixedAddr(CustAddr, "Sales Invoice Header");
                //<<LAP2.03 :TO 11/09/2012      (PT TDL 114)

                if not Cust.Get("Bill-to Customer No.") then
                    Clear(Cust);

                if "Payment Terms Code" = '' then
                    PaymentTerms.Init()
                else begin
                    PaymentTerms.Get("Payment Terms Code");
                    PaymentTerms.TranslateDescription(PaymentTerms, "Language Code");
                    TxTGLabelCondPay := StrSubstNo(Text011, PaymentTerms.Description)
                end;

                if "Shipment Method Code" = '' then
                    ShipmentMethod.Init()
                else begin
                    ShipmentMethod.Get("Shipment Method Code");
                    ShipmentMethod.TranslateDescription(ShipmentMethod, "Language Code");
                end;
                FormatAddr.SalesInvShipTo(ShipToAddr, "Sales Invoice Header");
                ShowShippingAddr := "Sell-to Customer No." <> "Bill-to Customer No.";
                for i := 1 to ArrayLen(ShipToAddr) do
                    if ShipToAddr[i] <> CustAddr[i] then
                        ShowShippingAddr := true;

                if LogInteraction then
                    if not CurrReport.Preview then
                        if "Bill-to Contact No." <> '' then
                            SegManagement.LogDocument(
                              4, "No.", 0, 0, DATABASE::Contact, "Bill-to Contact No.", "Salesperson Code",
                              "Campaign No.", "Posting Description", '')
                        else
                            SegManagement.LogDocument(
                              4, "No.", 0, 0, DATABASE::Customer, "Bill-to Customer No.", "Salesperson Code",
                              "Campaign No.", "Posting Description", '');
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
                    field(NoOfCopies; NoOfCopies)
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

        trigger OnInit()
        begin
            LogInteractionEnable := true;
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

        //>>NDBI
        BooGEnvoiMail := true;
        //<<NDBI
    end;

    trigger OnPostReport()
    var
        RecLSalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        //>>NDBI
        if not BooGSkipSendEmail and BooGEnvoiMail then begin
            RecLSalesInvoiceHeader.SetView("Sales Invoice Header".GetView());
            SendPDFMail(RecLSalesInvoiceHeader);
        end;
        //<<NDBI
    end;

    var
        Text000: Label 'Your contact : ';
        Text001: Label 'Total %1';
        Text003: Label 'COPY';
        Text006: Label 'Total %1 Excl. VAT';
        GLSetup: Record "General Ledger Setup";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        Cust: Record Customer;
        VATAmountLine: Record "VAT Amount Line" temporary;
        PostedDocDim1: Record "Posted Document Dimension";
        RespCenter: Record "Responsibility Center";
        Language: Record Language;
        SalesInvCountPrinted: Codeunit "Sales Inv.-Printed";
        FormatAddr: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        SalesShipmentBuffer: Record "Sales Shipment Buffer" temporary;
        PostedShipmentDate: Date;
        CustAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        OrderNoText: Text[80];
        SalesPersonText: Text[30];
        VATNoText: Text[80];
        ReferenceText: Text[80];
        TotalText: Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        ShowShippingAddr: Boolean;
        i: Integer;
        FirstValueEntryNo: Integer;
        ShowInternalInfo: Boolean;
        LogInteraction: Boolean;
        OutputNo: Integer;
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalAmountVAT: Decimal;
        TotalInvoiceDiscountAmount: Decimal;
        TotalPaymentDiscountOnVAT: Decimal;
        Item: Record Item;
        GetTotalLineAmount: Decimal;
        GetTotalInvDiscAmount: Decimal;
        GetTotalAmount: Decimal;
        GetTotalAmountIncVAT: Decimal;
        [InDataSet]
        LogInteractionEnable: Boolean;
        BSContact: Text[50];
        CustName: Code[20];
        Text011: Label 'Payment terms   %1';
        Text012: Label 'Due Date';
        Text013: Label 'Amount';
        Text014: Label 'LPSA No.';
        ValueEntryRelation: Record "Value Entry Relation";
        ValueEntry: Record "Value Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
        TempItemLedgEntry: Record "Item Ledger Entry";
        Text015: Label 'Your Item Ref.';
        Text016: Label 'You Pan No.';
        ItemCrossRef: Record "Item Cross Reference";
        CrossReferenceNo: Code[20];
        Text017: Label 'VAT';
        Text018: Label 'of';
        TxTGLabelCondPay: Text[250];
        AfficherligneComptegeneral: Boolean;
        CstG012: Label '%1 VAT';
        TxtGCustPlanNo_C: Text[100];
        CstG013: Label 'Origine non préférentielle: Les marchandises auxquelles se rapporte le présent document commercial sont originaires de Suisse selon les dispositions des articles 9 à 16 de l''ordonnance du 9 avril 2008 sur l''attestation de l''origine non préférentielle des marchandises (OOr) et de l''ordonnance du DEFR du 9 avril 2008 sur l''attestation de l''origine non préférentielle des marchandises (OOr-DEFR).La marchandise a été produite par notre entreprise.L''auteur de la présente déclaration d''origine a pris connaissance du fait que l''indication inexacte de l''origine selon les art. 9 ss OOr et les art. 2 ss OOr-DEFR entraîne des mesures de droit administratif et des poursuites pénales.';
        CstG014: Label 'Origine préférentielle: Nous attestons par la présente que les marchandises susmentionnées, sont originaires de Suisse et satisfont aux règles d''origine régissant les échanges préférentiels avec CE, AELE, SACU, AL, CA CL, CO EG, FO, HR, HK, IL, JO, JP, KR, LB, ME, MK, MA, MX, PE, RS, SG, TN, TR, UA, CN, CR, PA, GCC. Peut être complétée, selon les cas avec :Aucun cumul appliqué (no cumulation applied) / " PSR " : fabriqué en Suisse ou en Chine en utilisant des matières non originaires et remplissant les " Products Specific Rules " et autres conditions du chapitre 3 de l''accord de libre-échange avec la Chine (suffisamment ouvré).';
        IntGImpText: Integer;
        BooGEnvoiMail: Boolean;
        BooGSkipSendEmail: Boolean;
        Facture_captionLbl: Label 'Invoice';
        Sales_Header_No_captionLbl: Label 'Document No. : ';
        Sales_Header___Sell_to_Customer_No__CaptionLbl: Label 'Customer No. :  ';
        Sales_Header_VAT_Registration_No_captionLbl: Label 'VAT Registration No. : ';
        Sales_Header_Your_Contact_captionLbl: Label 'Your Contact: ';
        Sales_Header_Your_Ref_captionLbl: Label 'Your Document No. :  ';
        Sales_Header_Document_Date_captionLbl: Label 'Your Document Date: ';
        Sales_Invoice_Line__No__CaptionLbl: Label 'No.';
        Sales_Invoice_Line_Description_Control65CaptionLbl: Label 'Description';
        Sales_Invoice_Line__Unit_of_Measure_CaptionLbl: Label 'Unit';
        Unit_PriceCaptionLbl: Label 'Unit Price';
        Sales_Invoice_Line__Line_Discount___CaptionLbl: Label 'Disc. %';
        PostedShipmentDateCaptionLbl: Label 'Posted Shipment Date';
        Inv__Discount_Amount_CaptionLbl: Label 'Discount';
        SubtotalCaptionLbl: Label 'Subtotal';
        TotalExclVATTextLbl: Label 'Net Amount';
        CompanyInfo_SWIF__Code_captionLbl: Label 'SWIFT/BIC Code';
        CompanyInfo_IBAN_captionLbl: Label 'IBAN Code';
        CompanyInfo_Bank_Branch_No_captionLbl: Label 'Bank Code';
        CompanyInfo_Bank_Account_No_captionLbl: Label 'Bank Account';
        CompanyInfo_Bank_Name_captionLbl: Label 'Bank Name';


    procedure SearchLot()
    begin
        Clear(TempItemLedgEntry);
        ValueEntryRelation.SetCurrentKey("Source RowId");
        ValueEntryRelation.SetRange("Source RowId", "Sales Invoice Line".RowID1());
        if ValueEntryRelation.Find('-') then
            repeat
                ValueEntry.Get(ValueEntryRelation."Value Entry No.");
                ItemLedgEntry.Get(ValueEntry."Item Ledger Entry No.");
                TempItemLedgEntry := ItemLedgEntry;
                TempItemLedgEntry.Quantity := ValueEntry."Invoiced Quantity";
            until ValueEntryRelation.Next() = 0;
    end;


    procedure FindCrossRef()
    begin
        Clear(CrossReferenceNo);
        ItemCrossRef.SetRange("Item No.", "Sales Invoice Line"."No.");
        ItemCrossRef.SetRange("Variant Code", "Sales Invoice Line"."Variant Code");
        ItemCrossRef.SetRange("Unit of Measure", "Sales Invoice Line"."Unit of Measure Code");
        ItemCrossRef.SetRange("Cross-Reference Type", ItemCrossRef."Cross-Reference Type"::Customer);
        ItemCrossRef.SetRange("Cross-Reference Type No.", "Sales Invoice Header"."Sell-to Customer No.");
        if ItemCrossRef.FindFirst() then begin
            CrossReferenceNo := ItemCrossRef."Cross-Reference No.";
            //>>TDL.LPSA.09022015
            TxtGCustPlanNo_C := ItemCrossRef."Customer Plan No.";
            //<<TDL.LPSA.09022015
        end;

        //>>NDBI
        if "Sales Invoice Line"."Cross-Reference No." <> '' then begin
            CrossReferenceNo := "Sales Invoice Line"."Cross-Reference No.";
            if ItemCrossRef.Get("Sales Invoice Line"."No.",
                                "Sales Invoice Line"."Variant Code",
                                "Sales Invoice Line"."Unit of Measure Code",
                                ItemCrossRef."Cross-Reference Type"::Customer,
                                "Sales Invoice Header"."Sell-to Customer No.",
                                "Sales Invoice Line"."Cross-Reference No.") then
                TxtGCustPlanNo_C := ItemCrossRef."Customer Plan No.";
        end;
        //<<NDBI
    end;


    procedure "---- NDBI -----"()
    begin
    end;


    procedure SendPDFMail(var RecPSalesInvoiceHeader: Record "Sales Invoice Header")
    var
        CstL001: Label 'LA PIERRETTE SA : Sales Invoice %1';
        CstL002: Label 'Next the invoice following your order %1';
        Recipient: Text[80];
        CodLMail: Codeunit Mail;
        Subject: Text[100];
        Body: Text[100];
        CduLTierAutomationMgt: Codeunit "3-Tier Automation Mgt.";
        TxtLFileName: Text[250];
        TxtLServerFile: Text[250];
        RepLSalesInvoice: Report Invoice;
    begin
        TxtLServerFile := CduLTierAutomationMgt.ServerTempFileName('', '');
        RepLSalesInvoice.SkipSendEmail(true);
        RepLSalesInvoice.SetTableView(RecPSalesInvoiceHeader);
        RepLSalesInvoice.SaveAsPdf(TxtLServerFile);
        Clear(Recipient);
        Clear(CodLMail);

        RecPSalesInvoiceHeader.FindFirst();

        // pas besoin d'avoir l'adresse destinataire rempli mais ça va peut être évoluer.
        /*
        RecLContBusRel.RESET;
        RecLContBusRel.SETRANGE("Link to Table",RecLContBusRel."Link to Table"::Customer);
        RecLContBusRel.SETRANGE("No.",RecPSalesInvoiceHeader."Sell-to Customer No.");
        IF RecLContBusRel.FINDFIRST THEN
          IF RecLContact.GET(RecLContBusRel."Contact No.") THEN
            Recipient := RecLContact."E-Mail"
          ELSE
          BEGIN
            IF RecLCustomer.GET(RecPSalesInvoiceHeader."Sell-to Customer No.") THEN
              Recipient := RecLCustomer."E-Mail";
         END;
        */


        Subject := StrSubstNo(CstL001, RecPSalesInvoiceHeader."No.");
        Body := StrSubstNo(CstL002, RecPSalesInvoiceHeader."Your Reference");

        TxtLFileName := StrSubstNo('FACTURE N° %1.pdf', RecPSalesInvoiceHeader."No.");
        TxtLFileName := DownloadToClientFileName(TxtLServerFile, TxtLFileName);
        //Open E-Mail
        CodLMail.NewMessage(Recipient, '', Subject, Body, TxtLFileName, true);

    end;


    procedure DownloadToClientFileName(TxtPServerFile: Text[250]; TxtPFileName: Text[250]): Text[250]
    var
        TxtLClientFileName: Text[250];
        TxtLFinalClientFileName: Text[250];
        AutLFileObjectSystem: Automation;
        CduLTierAutomationMgt: Codeunit "3-Tier Automation Mgt.";
    begin
        TxtLClientFileName := CduLTierAutomationMgt.ClientTempFileName('', '');
        TxtLFinalClientFileName := CduLTierAutomationMgt.Path(TxtLClientFileName) + TxtPFileName;
        Download(TxtPServerFile, '', '', '', TxtLClientFileName);
        Create(AutLFileObjectSystem, false, true);
        if AutLFileObjectSystem.FileExists(TxtLFinalClientFileName) then
            AutLFileObjectSystem.DeleteFile(TxtLFinalClientFileName, true);
        AutLFileObjectSystem.MoveFile(TxtLClientFileName, TxtLFinalClientFileName);
        exit(TxtLFinalClientFileName);
    end;


    procedure SkipSendEmail(BooPSkipSendEmail: Boolean)
    begin
        BooGSkipSendEmail := BooPSkipSendEmail;
    end;
}

