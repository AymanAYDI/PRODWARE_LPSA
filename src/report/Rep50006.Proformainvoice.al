report 50006 "PWD Proforma invoice"
{
    // //>>HOTLINE
    // TI431116: TO 03/10/18: Lgueur Réf art passée de 6 à 8
    // 
    // //>>MODIF HL
    // TI460631 DO.GEPO 03/06/2019 : modify layout to enlarge field LPSADESCRIPTION
    //                               - change copy str for LPSADescription
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
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/Proformainvoice.rdl';

    Caption = 'Order Confirmation';
    UsageCategory = none;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Order));
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Sales Order';
            column(Sales_Header_Document_Type; "Document Type")
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(CustAddr_1_; CustAddr[1])
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
                    column(CustAddr_7_; CustAddr[7])
                    {
                    }
                    column(CustAddr_8_; CustAddr[8])
                    {
                    }
                    column(Sales_Header_No_; "Sales Header"."No.")
                    {
                    }
                    column(CompanyInfo_City; CompanyInfo.City + ', ' + Format(Today, 0, 4))
                    {
                    }
                    column(FORMAT__Sales_Header___Document_Date__0_4_; Format(WorkDate(), 0, 4))
                    {
                    }
                    column(Sales_Header_Document_Date; "Sales Header"."Document Date")
                    {
                    }
                    column(Sales_Header___Sell_to_Customer_No__; CustName)
                    {
                    }
                    column(SalesPersonText; SalesPersonText)
                    {
                    }
                    column(SalesPurchPerson_Name; SalesPurchPerson.Name)
                    {
                    }
                    column(Sales_Header_VAT_Registration_No_; CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(Sales_Header_External_Document_No_; "Sales Header"."External Document No.")
                    {
                    }
                    column(Sales_Header_Your_Reference; BSContact)
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(EnvoiMail; BooGEnvoiMail)
                    {
                    }
                    column(TotalInclVATText; '  ' + TotalInclVATText)
                    {
                    }
                    column(SalesLine__Line_Amount__SalesLine__Inv__Discount_Amount____VATAmount; SalesLine."Line Amount" - SalesLine."Inv. Discount Amount" + VATAmount)
                    {
                        AutoFormatExpression = "Sales Header"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(STRSUBSTNO_Text013_SalesLine_Line_Amount_SalesLine_Inv_Discount_Amount_VATAmount; Text013)
                    {
                    }
                    column(STRSUBSTNO_Text012_Sales_Header_Due_Date; Text012)
                    {
                    }
                    column(TTCAmount; SalesLine."Line Amount" - SalesLine."Inv. Discount Amount" + VATAmount)
                    {
                        AutoFormatExpression = "Sales Header"."Currency Code";
                    }
                    column(Text011_FORMAT_Sales_Header_Payment_Terms_Code; TxTGLabelCondPay)
                    {
                    }
                    column(CompanyInfo_Bank_Name; CompanyInfo."Bank Name")
                    {
                        AutoFormatExpression = "Sales Header"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(CompanyInfo_Bank_Account_No_; CompanyInfo."Bank Account No.")
                    {
                        AutoFormatExpression = "Sales Header"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(CompanyInfo_Bank_Branch_No_; CompanyInfo."Bank Branch No.")
                    {
                        AutoFormatExpression = "Sales Header"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(CompanyInfo_IBAN; CompanyInfo.IBAN)
                    {
                        AutoFormatExpression = "Sales Header"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(CompanyInfo_SWIF__Code; CompanyInfo."SWIFT Code")
                    {
                        AutoFormatExpression = "Sales Header"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(DueDate; Format("Sales Header"."Due Date"))
                    {
                    }
                    column(Sales_Header_No_caption; Sales_Header_No_captionLbl)
                    {
                    }
                    column(Sales_Header_Document_Date_caption; Sales_Header_Document_Date_captionLbl)
                    {
                    }
                    column(Sales_Header___Sell_to_Customer_No__Caption; Sales_Header___Sell_to_Customer_No__CaptionLbl)
                    {
                    }
                    column(Sales_Header_VAT_Registration_No_caption; Sales_Header_VAT_Registration_No_captionLbl)
                    {
                    }
                    column(Sales_Header_External_Document_No_caption; Sales_Header_External_Document_No_captionLbl)
                    {
                    }
                    column(Sales_Header_Your_Reference_caption; Sales_Header_Your_Reference_captionLbl)
                    {
                    }
                    column(Facture_caption; Facture_captionLbl)
                    {
                    }
                    column(CompanyInfo_Bank_Name_caption; CompanyInfo_Bank_Name_captionLbl)
                    {
                    }
                    column(CompanyInfo_Bank_Account_No_caption; CompanyInfo_Bank_Account_No_captionLbl)
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
                    column(PageLoop_Number; Number)
                    {
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
                        column(STRSUBSTNO_Text010_Sales_Header_No_Sales_Header_Document_Date; "Sales Line".Description)
                        {
                        }
                        column(NNC_SalesLineLineAmt; NNC_SalesLineLineAmt)
                        {
                        }
                        column(NNC_SalesLineInvDiscAmt; NNC_SalesLineInvDiscAmt)
                        {
                        }
                        column(NNC_TotalLCY; NNC_TotalLCY)
                        {
                        }
                        column(NNC_TotalExclVAT; NNC_TotalExclVAT)
                        {
                        }
                        column(NNC_VATAmt; NNC_VATAmt)
                        {
                        }
                        column(NNC_TotalInclVAT; NNC_TotalInclVAT)
                        {
                        }
                        column(NNC_PmtDiscOnVAT; NNC_PmtDiscOnVAT)
                        {
                        }
                        column(NNC_TotalInclVAT2; NNC_TotalInclVAT2)
                        {
                        }
                        column(NNC_VatAmt2; NNC_VatAmt2)
                        {
                        }
                        column(NNC_TotalExclVAT2; NNC_TotalExclVAT2)
                        {
                        }
                        column(SalesHeader_VATBaseDiscount; "Sales Header"."VAT Base Discount %")
                        {
                        }
                        column(LotNo; LotNo)
                        {
                        }
                        column(Position; SalesLine.Position)
                        {
                        }
                        column(Sales_Line___No__; CopyStr("Sales Line"."No.", 1, 8))
                        {
                        }
                        column(Item_Description; LPSADescription)
                        {
                        }
                        column(Sales_Line__Quantity; "Sales Line".Quantity)
                        {
                        }
                        column(Sales_Line___Unit_of_Measure_; "Sales Line"."Unit of Measure Code")
                        {
                        }
                        column(Sales_Line___Unit_Price_; "Sales Line"."Unit Price")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 2;
                        }
                        column(Sales_Line___Line_Amount_; "Sales Line"."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
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
                        column(POS_FORMAT_SalesLine_Position; 'POS  ' + Format(SalesLine.Position))
                        {
                        }
                        column(Text014; Text014 + '  ' + Format(LotNo))
                        {
                        }
                        column(ItemType; "Sales Line".Type::Item = "Sales Line".Type)
                        {
                        }
                        column(LigneVide; LigneVide)
                        {
                        }
                        column(TypeItem; TypeItem)
                        {
                        }
                        column(Comment_Line; TxtGComment)
                        {
                        }
                        column(LotNo_test; Format(LotNo))
                        {
                        }
                        column(GetTotalLineAmount; GetTotalLineAmount)
                        {
                        }
                        column(GetTotalInvDiscAmount; GetTotalInvDiscAmount)
                        {
                        }
                        column(SalesLine__Line_Amount__Control70; SalesLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(SalesLine__Inv__Discount_Amount_; -SalesLine."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalText; TotalText)
                        {
                        }
                        column(SalesLine__Line_Amount__SalesLine__Inv__Discount_Amount_; SalesLine."Line Amount" - SalesLine."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine_VATAmountText; Text015 + ' ' + Format(VATAmountLine."VAT %") + ' %')
                        {
                        }
                        column(SalesLine__Line_Amount__SalesLine__Inv__Discount_Amount__Control88; SalesLine."Line Amount" - SalesLine."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmount; VATAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Sales_Line___No__Caption; Sales_Line___No__CaptionLbl)
                        {
                        }
                        column(Sales_Line__Description_Control63Caption; Sales_Line__Description_Control63CaptionLbl)
                        {
                        }
                        column(Sales_Line__QuantityCaption; "Sales Line".FieldCaption(Quantity))
                        {
                        }
                        column(Sales_Line___Unit_of_Measure_Caption; Sales_Line___Unit_of_Measure_CaptionLbl)
                        {
                        }
                        column(Unit_PriceCaption; Unit_PriceCaptionLbl)
                        {
                        }
                        column(AmountCaption; AmountCaptionLbl)
                        {
                        }
                        column(SubtotalCaption; SubtotalCaptionLbl)
                        {
                        }
                        column(SalesLine__Inv__Discount_Amount_Caption; SalesLine__Inv__Discount_Amount_CaptionLbl)
                        {
                        }
                        column(Net_AmountCaption; Net_AmountCaptionLbl)
                        {
                        }
                        column(RoundLoop_Number; Number)
                        {
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

                            NNC_SalesLineLineAmt += SalesLine."Line Amount";
                            NNC_SalesLineInvDiscAmt += SalesLine."Inv. Discount Amount";

                            NNC_TotalLCY := NNC_SalesLineLineAmt - NNC_SalesLineInvDiscAmt;

                            NNC_TotalExclVAT := NNC_TotalLCY;
                            NNC_VATAmt := VATAmount;
                            NNC_TotalInclVAT := NNC_TotalLCY - NNC_VATAmt;

                            NNC_PmtDiscOnVAT := -VATDiscountAmount;

                            NNC_TotalInclVAT2 := TotalAmountInclVAT;

                            NNC_VatAmt2 := VATAmount;
                            NNC_TotalExclVAT2 := VATBaseAmount;

                            LotNo := '';
                            ReservEntry.SetRange("Item No.", "Sales Line"."No.");
                            ReservEntry.SetRange("Source Type", 37);
                            ReservEntry.SetRange("Source Subtype", ReservEntry."Source Subtype"::"1");
                            ReservEntry.SetRange("Source ID", "Sales Line"."Document No.");
                            if ReservEntry.FindFirst() then
                                LotNo := ReservEntry."Lot No.";
                            LPSADescription := '';
                            //>>TI460631
                            //LPSADescription := COPYSTR(SalesLine."PWD LPSA Description 1",1,40);
                            LPSADescription := CopyStr(SalesLine."PWD LPSA Description 1", 1, 60);
                            //<<TI460631


                            //
                            if SalesLine.Type = SalesLine.Type::" " then
                                LigneVide := true
                            else
                                LigneVide := false;

                            if SalesLine.Type = SalesLine.Type::Item then
                                TypeItem := true
                            else
                                TypeItem := false;
                            //

                            //>>Regie
                            Clear(TxtGComment);
                            BooGStopComment := false;
                            RecGSalesCommentLine.Reset();
                            RecGSalesCommentLine.SetRange("Document Type", RecGSalesCommentLine."Document Type"::Order);
                            RecGSalesCommentLine.SetRange("No.", "Sales Line"."Document No.");
                            RecGSalesCommentLine.SetRange("Document Line No.", "Sales Line"."Line No.");
                            if RecGSalesCommentLine.FindSet() then
                                repeat
                                    if StrLen(TxtGComment) + StrLen(RecGSalesCommentLine.Comment) < 1024 then
                                        TxtGComment += RecGSalesCommentLine.Comment + ' '
                                    else
                                        BooGStopComment := true;
                                until (RecGSalesCommentLine.Next() = 0) or (BooGStopComment);
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
                            // CurrReport.CreateTotals(SalesLine."Line Amount", SalesLine."Inv. Discount Amount", VATAmountLine."VAT Base"); 
                        end;
                    }
                    dataitem(VATCounter; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(Text015_____FORMAT_VATAmountLine__VAT__________; Text015 + ' ' + Format(VATAmountLine."VAT %") + ' %')
                        {
                            // DecimalPlaces = 0 : 5;
                        }
                        column(VATAmountLine__VAT_Base__Control106; Text016 + ' ' + Format(VATAmountLine."VAT Base"))
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Amount__Control107; VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__VAT_Identifier_; VATAmountLine."VAT Identifier")
                        {
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
                            if VATAmount = 0 then
                                CurrReport.Break();
                            SetRange(Number, 1, VATAmountLine.Count);
                            // CurrReport.CreateTotals(
                            //   VATAmountLine."Line Amount", VATAmountLine."Inv. Disc. Base Amount",
                            //   VATAmountLine."Invoice Discount Amount", VATAmountLine."VAT Base", VATAmountLine."VAT Amount");
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if "Sales Header"."Bill-to Customer No." = '' then begin
                            CustName := "Sales Header"."Sell-to Customer No.";
                            BSContact := "Sales Header"."Sell-to Contact";
                        end else begin
                            CustName := "Sales Header"."Bill-to Customer No.";
                            BSContact := "Sales Header"."Bill-to Contact";
                        end;
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    PrepmtSalesLine: Record "Sales Line" temporary;
                    TempSalesLine: Record "Sales Line" temporary;
                    SalesPost: Codeunit "Sales-Post";
                begin
                    Clear(SalesLine);
                    Clear(SalesPost);
                    VATAmountLine.DeleteAll();
                    SalesLine.DeleteAll();
                    SalesPost.GetSalesLines("Sales Header", SalesLine, 0);
                    SalesLine.CalcVATAmountLines(0, "Sales Header", SalesLine, VATAmountLine);
                    SalesLine.UpdateVATOnLines(0, "Sales Header", SalesLine, VATAmountLine);
                    VATAmount := VATAmountLine.GetTotalVATAmount();
                    VATBaseAmount := VATAmountLine.GetTotalVATBase();
                    VATDiscountAmount :=
                      VATAmountLine.GetTotalVATDiscount("Sales Header"."Currency Code", "Sales Header"."Prices Including VAT");
                    TotalAmountInclVAT := VATAmountLine.GetTotalAmountInclVAT();

                    PrepmtInvBuf.DeleteAll();
                    SalesPostPrepmt.GetSalesLines("Sales Header", 0, PrepmtSalesLine);

                    if (not PrepmtSalesLine.IsEmpty) then begin
                        SalesPostPrepmt.GetSalesLinesToDeduct("Sales Header", TempSalesLine);
                        if not TempSalesLine.IsEmpty then
                            SalesPostPrepmt.CalcVATAmountLines("Sales Header", TempSalesLine, PrepmtVATAmountLineDeduct, 1);
                    end;
                    SalesPostPrepmt.CalcVATAmountLines("Sales Header", PrepmtSalesLine, PrepmtVATAmountLine, 0);
                    if PrepmtVATAmountLine.FindSet() then
                        repeat
                            PrepmtVATAmountLineDeduct := PrepmtVATAmountLine;
                            if PrepmtVATAmountLineDeduct.Find() then begin
                                PrepmtVATAmountLine."VAT Base" := PrepmtVATAmountLine."VAT Base" - PrepmtVATAmountLineDeduct."VAT Base";
                                PrepmtVATAmountLine."VAT Amount" := PrepmtVATAmountLine."VAT Amount" - PrepmtVATAmountLineDeduct."VAT Amount";
                                PrepmtVATAmountLine."Amount Including VAT" := PrepmtVATAmountLine."Amount Including VAT" -
                                  PrepmtVATAmountLineDeduct."Amount Including VAT";
                                PrepmtVATAmountLine."Line Amount" := PrepmtVATAmountLine."Line Amount" - PrepmtVATAmountLineDeduct."Line Amount";
                                PrepmtVATAmountLine."Inv. Disc. Base Amount" := PrepmtVATAmountLine."Inv. Disc. Base Amount" -
                                  PrepmtVATAmountLineDeduct."Inv. Disc. Base Amount";
                                PrepmtVATAmountLine."Invoice Discount Amount" := PrepmtVATAmountLine."Invoice Discount Amount" -
                                  PrepmtVATAmountLineDeduct."Invoice Discount Amount";
                                PrepmtVATAmountLine."Calculated VAT Amount" := PrepmtVATAmountLine."Calculated VAT Amount" -
                                  PrepmtVATAmountLineDeduct."Calculated VAT Amount";
                                PrepmtVATAmountLine.Modify();
                            end;
                        until PrepmtVATAmountLine.Next() = 0;

                    SalesPostPrepmt.UpdateVATOnLines("Sales Header", PrepmtSalesLine, PrepmtVATAmountLine, 0);
                    SalesPostPrepmt.BuildInvLineBuffer("Sales Header", PrepmtSalesLine, 0, PrepmtInvBuf);
                    // PrepmtVATAmount := PrepmtVATAmountLine.GetTotalVATAmount();
                    // PrepmtVATBaseAmount := PrepmtVATAmountLine.GetTotalVATBase();
                    // PrepmtTotalAmountInclVAT := PrepmtVATAmountLine.GetTotalAmountInclVAT();

                    if Number > 1 then begin
                        CopyText := Text003;
                        OutputNo += 1;
                    end;
                    // CurrReport.PageNo := 1;

                    NNC_TotalLCY := 0;
                    NNC_TotalExclVAT := 0;
                    NNC_VATAmt := 0;
                    NNC_TotalInclVAT := 0;
                    NNC_PmtDiscOnVAT := 0;
                    NNC_TotalInclVAT2 := 0;
                    NNC_VatAmt2 := 0;
                    NNC_TotalExclVAT2 := 0;
                    NNC_SalesLineLineAmt := 0;
                    NNC_SalesLineInvDiscAmt := 0;
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
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CurrReport.Language := Language.GetLanguageID("Language Code");

                if RespCenter.Get("Responsibility Center") then begin
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                end else
                    FormatAddr.Company(CompanyAddr, CompanyInfo);
                DimSetEntry1.SetRange("Dimension Set ID", "Sales Header"."Dimension Set ID");
                // DocDim1.SetRange("Table ID", DATABASE::"Sales Header");
                // DocDim1.SetRange("Document Type", "Sales Header"."Document Type");
                // DocDim1.SetRange("Document No.", "Sales Header"."No.");

                if "Salesperson Code" = '' then begin
                    Clear(SalesPurchPerson);
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
                FormatAddr.SalesHeaderBillTo(CustAddr, "Sales Header");

                if "Payment Terms Code" = '' then
                    PaymentTerms.Init()
                else begin
                    PaymentTerms.Get("Payment Terms Code");
                    PaymentTerms.TranslateDescription(PaymentTerms, "Sales Header"."Language Code");
                    TxTGLabelCondPay := StrSubstNo(Text011, PaymentTerms.Description);
                end;
                if "Prepmt. Payment Terms Code" = '' then
                    PrepmtPaymentTerms.Init()
                else begin
                    PrepmtPaymentTerms.Get("Prepmt. Payment Terms Code");
                    PrepmtPaymentTerms.TranslateDescription(PrepmtPaymentTerms, "Sales Header"."Language Code");
                end;
                if "Prepmt. Payment Terms Code" = '' then
                    PrepmtPaymentTerms.Init()
                else begin
                    PrepmtPaymentTerms.Get("Prepmt. Payment Terms Code");
                    PrepmtPaymentTerms.TranslateDescription(PrepmtPaymentTerms, "Sales Header"."Language Code");
                end;
                if "Shipment Method Code" = '' then
                    ShipmentMethod.Init()
                else begin
                    ShipmentMethod.Get("Shipment Method Code");
                    ShipmentMethod.TranslateDescription(ShipmentMethod, "Sales Header"."Language Code");
                end;

                if not Cust.Get("Sell-to Customer No.") then
                    Clear(Cust);

                FormatAddr.SalesHeaderShipTo(ShipToAddr, CustAddr, "Sales Header");
                // ShowShippingAddr := "Sell-to Customer No." <> "Bill-to Customer No.";
                // for i := 1 to ArrayLen(ShipToAddr) do
                //     if ShipToAddr[i] <> CustAddr[i] then
                //         ShowShippingAddr := true;

                if not CurrReport.Preview then begin
                    if ArchiveDocument then
                        ArchiveManagement.StoreSalesDocument("Sales Header", LogInteraction);

                    if LogInteraction then begin
                        CalcFields("No. of Archived Versions");
                        if "Bill-to Contact No." <> '' then
                            SegManagement.LogDocument(
                              3, "No.", "Doc. No. Occurrence",
                              "No. of Archived Versions", DATABASE::Contact, "Bill-to Contact No."
                              , "Salesperson Code", "Campaign No.", "Posting Description", "Opportunity No.")
                        else
                            SegManagement.LogDocument(
                              3, "No.", "Doc. No. Occurrence",
                              "No. of Archived Versions", DATABASE::Customer, "Bill-to Customer No.",
                              "Salesperson Code", "Campaign No.", "Posting Description", "Opportunity No.");
                    end;
                end;
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
        RecLSalesHeader: Record "Sales Header";
        DocPrint: Codeunit "Document-Print";
    begin
        //>>NDBI
        if not BooGSkipSendEmail and BooGEnvoiMail then begin
            RecLSalesHeader.SetView("Sales Header".GetView());
            // SendPDFMail(RecLSalesHeader);
            DocPrint.EmailSalesHeader(RecLSalesHeader);
        end;
        //<<NDBI
    end;

    var
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        Cust: Record Customer;
        DimSetEntry1: Record "Dimension Set Entry";
        GLSetup: Record "General Ledger Setup";
        PaymentTerms: Record "Payment Terms";
        PrepmtPaymentTerms: Record "Payment Terms";
        PrepmtInvBuf: Record "Prepayment Inv. Line Buffer" temporary;
        ReservEntry: Record "Reservation Entry";
        RespCenter: Record "Responsibility Center";
        SalesSetup: Record "Sales & Receivables Setup";
        RecGSalesCommentLine: Record "Sales Comment Line";
        SalesLine: Record "Sales Line" temporary;
        SalesPurchPerson: Record "Salesperson/Purchaser";
        ShipmentMethod: Record "Shipment Method";
        PrepmtVATAmountLine: Record "VAT Amount Line" temporary;
        PrepmtVATAmountLineDeduct: Record "VAT Amount Line" temporary;
        VATAmountLine: Record "VAT Amount Line" temporary;
        ArchiveManagement: Codeunit ArchiveManagement;
        FormatAddr: Codeunit "Format Address";
        Language: Codeunit Language;
        SalesPostPrepmt: Codeunit "Sales-Post Prepayments";
        SalesCountPrinted: Codeunit "Sales-Printed";
        SegManagement: Codeunit SegManagement;
        ArchiveDocument: Boolean;
        BooGEnvoiMail: Boolean;
        BooGSkipSendEmail: Boolean;
        BooGStopComment: Boolean;
        LigneVide: Boolean;
        LogInteraction: Boolean;
        MoreLines: Boolean;
        ShowInternalInfo: Boolean;
        // ShowShippingAddr: Boolean;
        TypeItem: Boolean;
        CustName: Code[20];
        LotNo: Code[20];
        GetTotalInvDiscAmount: Decimal;
        GetTotalLineAmount: Decimal;
        NNC_PmtDiscOnVAT: Decimal;
        NNC_SalesLineInvDiscAmt: Decimal;
        NNC_SalesLineLineAmt: Decimal;
        NNC_TotalExclVAT: Decimal;
        NNC_TotalExclVAT2: Decimal;
        NNC_TotalInclVAT: Decimal;
        NNC_TotalInclVAT2: Decimal;
        NNC_TotalLCY: Decimal;
        NNC_VATAmt: Decimal;
        NNC_VatAmt2: Decimal;
        // PrepmtTotalAmountInclVAT: Decimal;
        // PrepmtVATAmount: Decimal;
        // PrepmtVATBaseAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        VATAmount: Decimal;
        VATBaseAmount: Decimal;
        VATDiscountAmount: Decimal;
        // i: Integer;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        OutputNo: Integer;
        AmountCaptionLbl: Label 'Total CHF';
        CompanyInfo_Bank_Account_No_captionLbl: Label 'Bank Account';
        CompanyInfo_Bank_Branch_No_captionLbl: Label 'Bank Code';
        CompanyInfo_Bank_Name_captionLbl: Label 'Bank Name';
        CompanyInfo_IBAN_captionLbl: Label 'IBAN Code';
        CompanyInfo_SWIF__Code_captionLbl: Label 'SWIFT/BIC Code';
        Facture_captionLbl: Label 'Proforma Invoice';
        Net_AmountCaptionLbl: Label 'Net Amount';
        Sales_Header___Sell_to_Customer_No__CaptionLbl: Label 'Customer No. : ';
        Sales_Header_Document_Date_captionLbl: Label 'Your document Date : ';
        Sales_Header_External_Document_No_captionLbl: Label 'Your Document No. : ';
        Sales_Header_No_captionLbl: Label 'Document No. : ';
        Sales_Header_VAT_Registration_No_captionLbl: Label 'VAT Registration No. : ';
        Sales_Header_Your_Reference_captionLbl: Label 'Your Reference : ';
        Sales_Line___No__CaptionLbl: Label 'Item Code';
        Sales_Line___Unit_of_Measure_CaptionLbl: Label 'Unit';
        Sales_Line__Description_Control63CaptionLbl: Label 'Description';
        SalesLine__Inv__Discount_Amount_CaptionLbl: Label 'Discount';
        SubtotalCaptionLbl: Label 'Subtotal';
        Text000: Label 'Your contact : ';
        Text001: Label 'Total %1';
        Text002: Label 'Total %1 Incl. VAT';
        Text003: Label 'COPY';
        Text006: Label 'Total %1 Excl. VAT';
        Text011: Label 'Payment Terms  %1';
        Text012: Label 'Due Date';
        Text013: Label 'Amount';
        Text014: Label 'LPSA No.';
        Text015: Label '  VAT';
        Text016: Label 'of';
        Unit_PriceCaptionLbl: Label 'Unit Price';
        CopyText: Text[30];
        SalesPersonText: Text[30];
        BSContact: Text[50];
        CompanyAddr: array[8] of Text[50];
        CustAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        TotalText: Text[50];
        ReferenceText: Text[80];
        VATNoText: Text[80];
        LPSADescription: Text[120];
        TxTGLabelCondPay: Text[250];
        TxtGComment: Text[1024];

    procedure SendPDFMail(var RecPSalesHeader: Record "Sales Header")
    var
        RepLProformaInvoice: Report "PWD Proforma invoice";
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
        RepLProformaInvoice.SkipSendEmail(true);
        RepLProformaInvoice.SetTableView(RecPSalesHeader);
        RepLProformaInvoice.SaveAsPdf(TxtLServerFile);
        Clear(Recipient);
        Clear(CodLMail);

        RecPSalesHeader.FindFirst();

        // pas besoin d'avoir l'adresse destinataire rempli mais ça va peut être évoluer.
        /*
        RecLContBusRel.RESET;
        RecLContBusRel.SETRANGE("Link to Table",RecLContBusRel."Link to Table"::Customer);
        RecLContBusRel.SETRANGE("No.",RecPSalesHeader."Sell-to Customer No.");
        IF RecLContBusRel.FINDFIRST THEN
          IF RecLContact.GET(RecLContBusRel."Contact No.") THEN
            Recipient := RecLContact."E-Mail"
          ELSE
          BEGIN
            IF RecLCustomer.GET(RecPSalesHeader."Sell-to Customer No.") THEN
              Recipient := RecLCustomer."E-Mail";
         END;
        */


        Subject := StrSubstNo(CstL001);
        Body := StrSubstNo(CstL002, RecPSalesHeader."External Document No.");

        TxtLFileName := StrSubstNo('FACTURE Proforma N° %1.pdf', RecPSalesHeader."No.");
        TxtLFileName := DownloadToClientFileName(TxtLServerFile, TxtLFileName);
        //Open E-Mail
        CodLMail.NewMessage(Recipient, '', '', Subject, Body, TxtLFileName, true);

    end;


    procedure DownloadToClientFileName(TxtPServerFile: Text[250]; TxtPFileName: Text[250]): Text[250]
    var
        FileMgt: Codeunit "File Management";
        TxtLClientFileName: Text[250];
        TxtLFinalClientFileName: Text[250];
    //TODO: 'Automation' is not recognized as a valid type
    //AutLFileObjectSystem: Automation;
    begin
        TxtLClientFileName := FileMgt.ClientTempFileName('');
        //TxtLFinalClientFileName := CduLTierAutomationMgt.Path(TxtLClientFileName) + TxtPFileName;
        Download(TxtPServerFile, '', '', '', TxtLClientFileName);
        // Create(AutLFileObjectSystem, false, true);
        // if AutLFileObjectSystem.FileExists(TxtLFinalClientFileName) then
        //     AutLFileObjectSystem.DeleteFile(TxtLFinalClientFileName, true);
        // AutLFileObjectSystem.MoveFile(TxtLClientFileName, TxtLFinalClientFileName);
        exit(TxtLFinalClientFileName);
    end;


    procedure SkipSendEmail(BooPSkipSendEmail: Boolean)
    begin
        BooGSkipSendEmail := BooPSkipSendEmail;
    end;
}

