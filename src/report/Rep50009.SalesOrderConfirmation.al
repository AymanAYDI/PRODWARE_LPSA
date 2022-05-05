report 50009 "PWD Sales Order Confirmation"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.00
    // FED-LAPIERRETTE-VTE-02-Documents Vente-V5.001: TUN 26/12/2011:  Documents vente
    //                                                                 - Creation Report 50009
    // 
    // //>>LAP2.02 :TU 13/06/2012
    //                   -Correction Company Addr : Get Fixed Address order
    // 
    // //>>LAP2.03 :TO 11/09/2012      (PT TDL 86)
    //      Mofify addr in layout (overlap)
    // 
    // //>>MODIF HL
    // TI256005 DO.GEPO 26/12/2014 : modify design
    // 
    // //>>MODIF HL
    // TI262415 DO.GEPO Modify Layout (create function SetDec and GetDec)
    // 
    // TDL.LPSA.20.04.15:APA 20/04/15: Modify RoundLoop - OnAfterGetRecord
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 17/10/2017 : DEMANDES DIVERSES
    //                   - Change Length for C/AL Global TxtGCustPlanNo
    // 
    // //>>REGIE
    // P24578_005 : LALE.RO : 29/01/2019 Demande par Mail
    //                         Modif Layout
    // 
    // //>>NDBI
    // P27818_002 : LALE.PA : 01/03/2021 : cf. demande mail client TI528820
    //                   - Modif C/AL Code in trigger FindCrossRef
    // 
    // P27818_004 LALE.PA 18/05/2021 : cf. demande mail client TI531940 Modification Option Envoi par mail.
    //                            Add C/AL Code in trigger SendPDFMail
    //                            Modif Layout (Brasus => Brassus)
    // 
    // ------------------------------------------------------------------------------------------------------------------
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/SalesOrderConfirmation.rdl';

    Caption = 'Sales Order Confirmation';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Order));
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Sales Order Confirmation';
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
                    column(CustAddr_5_; CompanyInfo."VAT Registration No.")
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
                    column(Sales_Header___Document_Date_; Format(CompanyInfo.City) + ',' + Format(WorkDate(), 0, 4))
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
                    column(EnvoiMail; BooGEnvoiMail)
                    {
                    }
                    column(Sales_Header_ShipToAdress; "Sales Header"."Ship-to Address")
                    {
                    }
                    column(Sales_Header_ShipToAdress2; "Sales Header"."Ship-to Address 2")
                    {
                    }
                    column(Sales_Header_ShipToAdress_City; "Sales Header"."Ship-to Post Code" + ' ' + "Sales Header"."Ship-to City")
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
                    column(TotalText; TotalText)
                    {
                    }
                    column(SalesLine__Line_Amount__SalesLine__Inv__Discount_Amount____VATAmount; SalesLine."Line Amount" - SalesLine."Inv. Discount Amount" + VATAmount)
                    {
                        AutoFormatExpression = "Sales Header"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(CompanyInfo__Bank_Name_; CompanyInfo."Bank Name")
                    {
                    }
                    column(CompanyInfo__Bank_Account_No__; CompanyInfo."Bank Account No.")
                    {
                    }
                    column(CompanyInfo__Bank_Branch_No__; CompanyInfo."Bank Branch No.")
                    {
                    }
                    column(CompanyInfo__SWIFT_Code_; CompanyInfo."SWIFT Code")
                    {
                    }
                    column(CompanyInfo_IBAN; CompanyInfo.IBAN)
                    {
                    }
                    column(TxTGLabelCondPay; TxTGLabelCondPay)
                    {
                    }
                    column(STRSUBSTNO_CstG007__Sales_Header___Due_Date__; StrSubstNo(CstG007, "Sales Header"."Due Date"))
                    {
                    }
                    column(SalesLine__Line_Amount__SalesLine__Inv__Discount_Amount____VATAmount_Control1100267047; SalesLine."Line Amount" - SalesLine."Inv. Discount Amount" + VATAmount)
                    {
                        AutoFormatExpression = "Sales Header"."Currency Code";
                    }
                    column(STRSUBSTNO_CstG008_SalesLine__Line_Amount__SalesLine__Inv__Discount_Amount____VATAmount_; CstG008)
                    {
                        AutoFormatExpression = "Sales Header"."Currency Code";
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
                    column(Sales_Header_ShipToAdress_Caption; Sales_Header_ShipToAdress_CaptionLbl)
                    {
                    }
                    column(CompanyInfo__Bank_Name_Caption; CompanyInfo__Bank_Name_CaptionLbl)
                    {
                    }
                    column(CompanyInfo__Bank_Account_No__Caption; CompanyInfo__Bank_Account_No__CaptionLbl)
                    {
                    }
                    column(CompanyInfo__Bank_Branch_No__Caption; CompanyInfo__Bank_Branch_No__CaptionLbl)
                    {
                    }
                    column(CompanyInfo__SWIFT_Code_Caption; CompanyInfo__SWIFT_Code_CaptionLbl)
                    {
                    }
                    column(CompanyInfo_IBANCaption; CompanyInfo_IBANCaptionLbl)
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
                        column(Sales_Header___Prices_Including_VAT_; "Sales Header"."Prices Including VAT")
                        {
                        }
                        column(AmountCaption; TotalText)
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
                        column(NNC_SalesLineLineAmt; NNC_SalesLineLineAmt)
                        {
                        }
                        column(NNC_SalesLineInvDiscAmt; NNC_SalesLineInvDiscAmt)
                        {
                        }
                        column(NNC_TotalLCY; NNC_TotalLCY)
                        {
                        }
                        column(NNC_VATAmt; NNC_VATAmt)
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
                        column(Comptegenral; Comptegenral)
                        {
                        }
                        column(ISitem; ISitem)
                        {
                        }
                        column(Vide; Vide)
                        {
                        }
                        column(Sales_Line___No___Control1100267013; "Sales Line"."No.")
                        {
                        }
                        column(Sales_Line___LPSA_Description_1_; "Sales Line"."PWD LPSA Description 1")
                        {
                        }
                        column(Sales_Line__Quantity_Control1100267015; "Sales Line".Quantity)
                        {
                        }
                        column(Sales_Line___Unit_of_Measure__Control1100267016; "Sales Line"."Unit of Measure Code")
                        {
                        }
                        column(Sales_Line___Line_Amount__Control1100267017; "Sales Line"."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Sales_Line___Unit_Price__Control1100267018; "Sales Line"."Unit Price")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 2;
                        }
                        column(STRSUBSTNO_CstG004__Sales_Line__Position_; StrSubstNo(CstG004, "Sales Line".Position))
                        {
                        }
                        column(TxTGLabelLot; TxTGLabelLot)
                        {
                        }
                        column(SalesLineType_Control1100267019; Format("Sales Line".Type))
                        {
                        }
                        column(TxTGQuantity; TxTGQuantity)
                        {
                        }
                        column(TxTGLabelLot_Control1000000000; Text016 + ' ' + TxtGCustPlanNo)
                        {
                        }
                        column(Text015______FORMAT_CrossReferenceNo_; Text015 + ' ' + Format(CrossReferenceNo))
                        {
                        }
                        column(Comment_Line; TxtGComment)
                        {
                        }
                        column(Sales_Line__Description_Control1150111; "Sales Line"."PWD LPSA Description 1")
                        {
                        }
                        column(SalesLine__Subtotal_Net_; SalesLine."PWD Scrap Quantity")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(SalesLine__Line_Amount__Control84; SalesLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(SalesLine__Inv__Discount_Amount_; -SalesLine."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(SalesLine__Line_Amount__Control1100267026; SalesLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(SalesLine__Line_Amount__SalesLine__Inv__Discount_Amount_; SalesLine."Line Amount" - SalesLine."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine__Line_Amount__Control72; VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(STRSUBSTNO_CstG011_VATAmountLine__VAT________; StrSubstNo(CstG011, VATAmountLine."VAT %") + '%')
                        {
                            // DecimalPlaces = 0 : 5;
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
                        column(SalesLine__Inv__Discount_Amount_Caption; SalesLine__Inv__Discount_Amount_CaptionLbl)
                        {
                        }
                        column(SubtotalCaption; SubtotalCaptionLbl)
                        {
                        }
                        column(SalesLine__Line_Amount__SalesLine__Inv__Discount_Amount_Caption; SalesLine__Line_Amount__SalesLine__Inv__Discount_Amount_CaptionLbl)
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

                            if IsServiceTier then begin
                                if ("Sales Line".Type = "Sales Line".Type::"New Page") then
                                    CurrPageFooterHiddenFlag := 1
                                else
                                    CurrPageFooterHiddenFlag := 0;
                                NNC_SalesLineLineAmt += SalesLine."Line Amount";
                                NNC_SalesLineInvDiscAmt += SalesLine."Inv. Discount Amount";
                                NNC_TotalLCY := NNC_SalesLineLineAmt - NNC_SalesLineInvDiscAmt;
                                NNC_VATAmt := VATAmount;
                            end;

                            //>>TDL.LPSA.09022015
                            TxtGCustPlanNo := '';
                            //<<TDL.LPSA.09022015
                            if SalesLine.Type = SalesLine.Type::Item then begin
                                if Item.Get(SalesLine."No.") then;
                                FindCrossRef();
                                //>>TDL.LPSA.09022015
                                if TxtGCustPlanNo = '' then
                                    TxtGCustPlanNo := Item."PWD Customer Plan No.";
                                //<<TDL.LPSA.09022015
                            end;


                            if "Sales Line"."PWD Scrap Quantity" + "Sales Line"."Quantity Shipped" < "Sales Line".Quantity then
                                //>>TDL.LPSA.20.04.15
                                //TxTGQuantity := STRSUBSTNO(CstG009,"Sales Line"."Shipment Date")
                                TxTGQuantity := StrSubstNo(CstG009, "Sales Line"."PWD Cust Promised Delivery Date")
                            //<<TDL.LPSA.20.04.15
                            else
                                TxTGQuantity := StrSubstNo(CstG010);


                            if (SalesLine.Type.AsInteger() = 0) then
                                Vide := true
                            else
                                Vide := false;

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


                            if (SalesLine.Type = SalesLine.Type::Item) then
                                ISitem := true
                            else
                                ISitem := false;
                            if (SalesLine.Type <> SalesLine.Type::Item) and (SalesLine.Type.AsInteger() = 0) then
                                Comptegenral := true
                            else
                                Comptegenral := false;
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
                            CurrReport.CreateTotals(
                              VATAmountLine."Line Amount", VATAmountLine."Inv. Disc. Base Amount",
                              VATAmountLine."Invoice Discount Amount", VATAmountLine."VAT Base", VATAmountLine."VAT Amount");
                        end;
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
                    VATBaseAmount := VATAmountLine.GetTotalVATBase();
                    VATDiscountAmount :=
                      VATAmountLine.GetTotalVATDiscount("Sales Header"."Currency Code", "Sales Header"."Prices Including VAT");
                    TotalAmountInclVAT := VATAmountLine.GetTotalAmountInclVAT();

                    if Number > 1 then begin
                        CopyText := Text003;
                        if IsServiceTier then
                            OutputNo += 1;
                    end;
                    CurrReport.PageNo := 1;
                    if IsServiceTier then begin
                        NNC_TotalLCY := 0;
                        NNC_VATAmt := 0;
                        NNC_SalesLineLineAmt := 0;
                        NNC_SalesLineInvDiscAmt := 0;
                    end;
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
            var
                "Sell-to Country": Text[50];
            begin
                CurrReport.Language := Language.GetLanguageID("Language Code");

                if RecGCustomer.Get("Sell-to Customer No.") then;
                if RecGSalespersonPurchaser.Get("Salesperson Code") then;
                if ("Sell-to Customer No." <> "Bill-to Customer No.") and ("Bill-to Customer No." <> '') then begin
                    //>>LAP2.02
                    //STD FormatAddr.SalesHeaderSellTo(CompanyAddr,"Sales Header");
                    LPSAFunctionsMgt.SalesHeaderSellToFixedAddr(CompanyAddr, "Sales Header");
                    //<<LAP2.02
                    CodGNoCustomer := "Sell-to Customer No.";
                    TxTGContact := "Sell-to Contact";
                end
                else begin
                    //>>LAP2.02
                    //STD FormatAddr.SalesHeaderBillTo(CompanyAddr,"Sales Header");
                    LPSAFunctionsMgt.SalesHeaderSellToFixedAddr(CompanyAddr, "Sales Header");
                    //<<LAP2.02
                    //>>TDL.001
                    //CodGNoCustomer := "Bill-to Customer No.";
                    //TxTGContact    := "Bill-to Contact";
                    CodGNoCustomer := "Sell-to Customer No.";
                    TxTGContact := "Sell-to Contact";
                    //<<TDL.001
                end;

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

                Clear(TxTGLabelCondPay);
                if "Payment Terms Code" = '' then
                    PaymentTerms.Init()
                else begin
                    if PaymentTerms.Get("Payment Terms Code") then;
                    PaymentTerms.TranslateDescription(PaymentTerms, "Sales Header"."Language Code");
                    TxTGLabelCondPay := StrSubstNo(CstG006, PaymentTerms.Description);
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
            end;

            trigger OnPostDataItem()
            var
                ToDo: Record "To-do";
            begin
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
        BooGEnvoiMail := true;
    end;

    trigger OnPostReport()
    var
        RecLSalesHeader: Record "Sales Header";
    begin
        if not BooGSkipSendEmail and BooGEnvoiMail then begin
            RecLSalesHeader.SetView("Sales Header".GetView());
            SendPDFMail(RecLSalesHeader);
        end;
    end;

    var
        CompanyInfo: Record "Company Information";
        RecGCustomer: Record Customer;
        GLSetup: Record "General Ledger Setup";
        Item: Record Item;
        ItemCrossRef: Record "Item Cross Reference";
        PaymentTerms: Record "Payment Terms";
        RecGSalesCommentLine: Record "Sales Comment Line";
        SalesLine: Record "Sales Line" temporary;
        RecGSalespersonPurchaser: Record "Salesperson/Purchaser";
        VATAmountLine: Record "VAT Amount Line" temporary;
        ArchiveManagement: Codeunit ArchiveManagement;
        Language: Codeunit Language;
        LPSAFunctionsMgt: codeunit "PWD LPSA Functions Mgt.";
        SalesCountPrinted: Codeunit "Sales-Printed";
        SegManagement: Codeunit SegManagement;
        ArchiveDocument: Boolean;
        [InDataSet]
        ArchiveDocumentEnable: Boolean;
        BooGEnvoiMail: Boolean;
        BooGSkipSendEmail: Boolean;
        BooGStopComment: Boolean;
        Comptegenral: Boolean;
        ISitem: Boolean;
        LogInteraction: Boolean;
        [InDataSet]
        LogInteractionEnable: Boolean;
        MoreLines: Boolean;
        ShowInternalInfo: Boolean;
        Vide: Boolean;
        CodGNoCustomer: Code[20];
        CrossReferenceNo: Code[20];
        NNC_SalesLineInvDiscAmt: Decimal;
        NNC_SalesLineLineAmt: Decimal;
        NNC_TotalLCY: Decimal;
        NNC_VATAmt: Decimal;
        TotalAmountInclVAT: Decimal;
        VATAmount: Decimal;
        VATBaseAmount: Decimal;
        VATDiscountAmount: Decimal;
        CurrGroupPageNO: Integer;
        CurrPageFooterHiddenFlag: Integer;
        CurrPageHeaderHiddenFlag: Integer;
        InnerGroupPageNO: Integer;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        NoOfRecords: Integer;
        OutputNo: Integer;
        CompanyInfo__Bank_Account_No__CaptionLbl: Label 'Bank Account';
        CompanyInfo__Bank_Branch_No__CaptionLbl: Label 'Bank Code';
        CompanyInfo__Bank_Name_CaptionLbl: Label 'Bank Name';
        CompanyInfo__SWIFT_Code_CaptionLbl: Label 'SWIFT/BIC Code';
        CompanyInfo_IBANCaptionLbl: Label 'IBAN Code';
        ContinuedCaption_Control83Lbl: Label 'Continued';
        ContinuedCaptionLbl: Label 'Continued';
        CstG001: Label 'Sales Order Confirmation';
        CstG004: Label 'POS. : %1';
        CstG006: Label 'Payment Terms : %1';
        CstG007: Label 'Due Date : %1';
        CstG008: Label 'Amount :';
        CstG009: Label 'Shipment Date : %1';
        CstG010: Label 'Shipment Done';
        CstG011: Label '%1 VAT';
        CustAddr_2_CaptionLbl: Label 'Document No. :';
        CustAddr_3_CaptionLbl: Label 'Your document Date :';
        CustAddr_4_CaptionLbl: Label 'Customer No. :';
        CustAddr_5_CaptionLbl: Label 'VAT Registration No. :';
        CustAddr_6_CaptionLbl: Label 'Your Document No. :';
        CustAddr_7_CaptionLbl: Label 'Your Reference :';
        CustAddr_8_CaptionLbl: Label 'Your contact :';
        Sales_Header_ShipToAdress_CaptionLbl: Label 'Ship-to Address :';
        Sales_Line___No__CaptionLbl: Label 'Item Code';
        Sales_Line___Unit_of_Measure_CaptionLbl: Label 'Unit';
        Sales_Line__DescriptionCaptionLbl: Label 'Description';
        Sales_Line__QuantityCaptionLbl: Label 'Quantity';
        SalesLine__Inv__Discount_Amount_CaptionLbl: Label 'Discount';
        SalesLine__Line_Amount__SalesLine__Inv__Discount_Amount_CaptionLbl: Label 'Net Amount';
        SubtotalCaptionLbl: Label 'Subtotal';
        Text001: Label 'Total %1';
        Text002: Label 'Total %1 Incl. VAT';
        Text003: Label 'COPY';
        Text005: Label 'Page %1';
        Text006: Label 'Total %1 Excl. VAT';
        Text015: Label 'Your Item Ref.';
        Text016: Label 'You Pan No.';
        Text11500: Label 'Quote %1';
        Unit_PriceCaptionLbl: Label 'Unit Price';
        CopyText: Text[30];
        CompanyAddr: array[8] of Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        TotalText: Text[50];
        TxTGContact: Text[50];
        TxTGLabelLot: Text[50];
        TxTGQuantity: Text[50];
        TxtGCustPlanNo: Text[100];
        TxTGLabelCondPay: Text[250];
        TxtGComment: Text[1024];


    procedure FindCrossRef()
    begin
        Clear(CrossReferenceNo);
        ItemCrossRef.SetRange("Item No.", "Sales Line"."No.");
        ItemCrossRef.SetRange("Variant Code", "Sales Line"."Variant Code");
        ItemCrossRef.SetRange("Unit of Measure", "Sales Line"."Unit of Measure Code");
        ItemCrossRef.SetRange("Cross-Reference Type", ItemCrossRef."Cross-Reference Type"::Customer);
        ItemCrossRef.SetRange("Cross-Reference Type No.", "Sales Header"."Sell-to Customer No.");
        if ItemCrossRef.FindFirst() then begin
            CrossReferenceNo := ItemCrossRef."Cross-Reference No.";
            //>>TDL.LPSA.09022015
            TxtGCustPlanNo := ItemCrossRef."PWD Customer Plan No.";
        end;
        //<<TD.LPSA.09022015

        //>>NDBI
        if "Sales Line"."Cross-Reference No." <> '' then begin
            CrossReferenceNo := "Sales Line"."Cross-Reference No.";
            if ItemCrossRef.Get("Sales Line"."No.",
                                "Sales Line"."Variant Code",
                                "Sales Line"."Unit of Measure Code",
                                ItemCrossRef."Cross-Reference Type"::Customer,
                                "Sales Header"."Sell-to Customer No.",
                                "Sales Line"."Cross-Reference No.") then
                TxtGCustPlanNo := ItemCrossRef."PWD Customer Plan No.";
        end;
        //<<NDBI
    end;


    procedure SendPDFMail(var RecPSalesHeader: Record "Sales Header")
    var
        RepLSalesOrderConfirmation: Report "PWD Sales Order Confirmation";
        CodLMail: Codeunit Mail;
        CstL001: Label 'LA PIERRETTE SA : Sales Order Confirmation';
        CstL002: Label 'Next the order confirmation following your order %1';
        Recipient: Text[80];
        Body: Text[100];
        Subject: Text[100];
        FileManagement: Codeunit "File Management";
        TxtLFileName: Text[250];
        TxtLServerFile: Text[250];
    begin
        TxtLServerFile := FileManagement.ServerTempFileName('');
        RepLSalesOrderConfirmation.SkipSendEmail(true);
        RepLSalesOrderConfirmation.SetTableView(RecPSalesHeader);
        RepLSalesOrderConfirmation.SaveAsPdf(TxtLServerFile);
        Clear(Recipient);
        Clear(CodLMail);

        //>>NDBI
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

        Subject := CstL001;
        //Body := CstL002;
        Body := StrSubstNo(CstL002, RecPSalesHeader."External Document No.");

        //<<NDBI

        TxtLFileName := StrSubstNo('CONFIRM No. %1.pdf', RecPSalesHeader."No.");
        TxtLFileName := DownloadToClientFileName(TxtLServerFile, TxtLFileName);

        //Open E-Mail
        CodLMail.NewMessage(Recipient, '', '', Subject, Body, TxtLFileName, true);

    end;


    procedure DownloadToClientFileName(TxtPServerFile: Text[250]; TxtPFileName: Text[250]): Text[250]
    var
        TxtLClientFileName: Text[250];
        TxtLFinalClientFileName: Text[250];
        //TODO: 'Automation' is not recognized as a valid type
        //AutLFileObjectSystem: Automation;
        FileManagement: Codeunit "File Management";
    begin
        TxtLClientFileName := FileManagement.ClientTempFileName('');
        //TODO:'Codeunit "File Management"' does not contain a definition for 'Path'
        //TxtLFinalClientFileName := CduLTierAutomationMgt.Path(TxtLClientFileName) + TxtPFileName;
        Download(TxtPServerFile, '', '', '', TxtLClientFileName);
        //TODO: 'Automation' is not recognized as a valid type
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

