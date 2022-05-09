report 50004 "PWD Purchase - Quote LAP"
{
    // <changelog>
    //   <add id="dach0001"
    //        dev="mnommens"
    //        date="2008-03-20"
    //        area="ENHARCHDOC"
    //        releaseversion="DACH6.00"
    //        feature="NAVCORS16928">
    //        Enhanced Arch. Doc Mgmt.
    //   </add>
    //   <change id="AG0001" dev="AUGMENTUM" date="2008-04-23" area="ENHARCHDOC"
    //     baseversion="DACH6.00" releaseversion="DACH6.00" feature="NAVCORS2447">
    //     Localized - Report Transformation</change>
    //   <change id="CH4401" dev="SRYSER" request="CH-START-400" date="2004-09-15" area="SR"
    //     baseversion="CH3.70A" releaseversion="CH4.00">
    //     Complete Redesign</change>
    //   <change id="CH4402" dev="SRYSER" request="CH-START-400A" date="2005-06-30" area="SR"
    //     baseversion="CH4.00" releaseversion="CH4.00A">
    //     RoundLoop, Header(1) Print on Every Page Set</change>
    //   <change id="CH9111" dev="SRYSER" feature="CH-ST4.00.03-CL" date="2006-05-11" area="SR"
    //     baseversion="CH4.00A" releaseversion="CH4.00.03">
    //     Cleanup</change>
    //   <change id="CH4412" dev="SRYSER" feature="NAVCORS4658" date="2006-10-12" area="SR"
    //     baseversion="CH4.00.03" releaseversion="CH5.00">
    //     Changed Customer No. on Header to Vendor No.</change>
    //   <change id="ch0010" dev="SRYSER" date="2007-10-25" feature="NAVCORS14757" area="SR"
    //     baseversion="CH5.00" releaseversion="CH6.00.01" >
    //     Changed ID to local range</change>
    //   <change id="CH0002" dev="all-e" date="2009-01-27" feature="NAVCORS23101" area="SR"
    //     baseversion="CH5.00" releaseversion="CH6.00.01">
    //     Translation of Payment Terms and Shipment Method printed</change>
    //   <change id="CH0003" dev="AUGMENTUM" date="2009-03-19" feature="NAVCORS20803" area="SR"
    //     baseversion="CH6.00" releaseversion="CH6.00.01">
    //     Updated the NNC client according to the change between original client and GDLGlobal version</change>
    //   <change id="CH0004" dev="AUGMENTUM" date="2009-05-20" feature="NAVCORS20803" area="SR"
    //     baseversion="CH6.00" releaseversion="CH6.00.01">
    //     Fixed the bug of wrong date format on page header</change>
    // </changelog>
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_ACH02.001: TO 07/12/2011:  Documents achat
    //                                           - Creation Report by copy R404
    // 
    // ------------------------------------------------------------------------------------------------------------------
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/PurchaseQuoteLAP.rdl';

    Caption = 'Purchase - Quote';
    UsageCategory = none;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Quote));
            RequestFilterFields = "No.", "Buy-from Vendor No.", "No. Printed";
            RequestFilterHeading = 'Purchase Quote';
            column(Purchase_Header_Document_Type; "Document Type")
            {
            }
            column(Purchase_Header_No_; "No.")
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(VendAddr_1_; VendAddr[1])
                    {
                    }
                    column(CompanyAddr_1_; CompanyAddr[1])
                    {
                    }
                    column(VendAddr_2_; VendAddr[2])
                    {
                    }
                    column(CompanyAddr_2_; CompanyAddr[2])
                    {
                    }
                    column(VendAddr_3_; VendAddr[3])
                    {
                    }
                    column(CompanyAddr_3_; CompanyAddr[3])
                    {
                    }
                    column(VendAddr_4_; VendAddr[4])
                    {
                    }
                    column(CompanyAddr_4_; CompanyAddr[4])
                    {
                    }
                    column(VendAddr_5_; VendAddr[5])
                    {
                    }
                    column(CompanyInfo__Phone_No__; CompanyInfo."Phone No.")
                    {
                    }
                    column(VendAddr_6_; VendAddr[6])
                    {
                    }
                    column(CompanyInfo__Fax_No__; CompanyInfo."Fax No.")
                    {
                    }
                    column(CompanyInfo__VAT_Registration_No__; CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(VendAddr_7_; VendAddr[7])
                    {
                    }
                    column(VendAddr_8_; VendAddr[8])
                    {
                    }
                    column(CompanyAddr_5_; CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr_6_; CompanyAddr[6])
                    {
                    }
                    column(Purchase_Header___Pay_to_Vendor_No__; "Purchase Header"."Pay-to Vendor No.")
                    {
                    }
                    column(Purchase_Header___Document_Date_; "Purchase Header"."Document Date")
                    {
                    }
                    column(HeaderTxt_1_; HeaderTxt[1])
                    {
                    }
                    column(HeaderLabel_1_; HeaderLabel[1])
                    {
                    }
                    column(HeaderTxt_2_; HeaderTxt[2])
                    {
                    }
                    column(HeaderLabel_2_; HeaderLabel[2])
                    {
                    }
                    column(HeaderTxt_3_; HeaderTxt[3])
                    {
                    }
                    column(HeaderLabel_3_; HeaderLabel[3])
                    {
                    }
                    column(HeaderLabel_4_; HeaderLabel[4])
                    {
                    }
                    column(HeaderTxt_4_; HeaderTxt[4])
                    {
                    }
                    column(CopyText; CopyText)
                    {
                    }
                    column(STRSUBSTNO_Text11500__Purchase_Header___No___; StrSubstNo(Text11500, "Purchase Header"."No."))
                    {
                    }
                    column(STRSUBSTNO_Text004; StrSubstNo(CstGText004, CompanyInfo.City, "Purchase Header"."Document Date"))
                    {
                    }
                    column(Text005; CstGText005)
                    {
                    }
                    column(STRSUBSTNO_Text006__Purchase_Header___No___; StrSubstNo(CstGText006, "Purchase Header"."No."))
                    {
                    }
                    column(Text008; CstGText008)
                    {
                    }
                    column(RecGVendor_Fax_No; RecGVendor."Fax No.")
                    {
                    }
                    column(Text009; TxtGText009)
                    {
                    }
                    column(Purchase_Header_Vendor_Order_No; "Purchase Header"."Vendor Order No.")
                    {
                    }
                    column(Text010; CstGText010)
                    {
                    }
                    column(Purchase_Header_Your_Reference; "Purchase Header"."Your Reference")
                    {
                    }
                    column(Text011; CstGText011)
                    {
                    }
                    column(Purchase_Header_Quote_No; "Purchase Header"."Quote No.")
                    {
                    }
                    column(STRSUBSTNO_Text012__SalesPurch_Person_Name; StrSubstNo(CstGText012, SalesPurchPerson.Name))
                    {
                    }
                    column(Text007; CstGText007)
                    {
                    }
                    column(STRSUBSTNO_Text003_FORMAT_CurrReport_PAGENO__; StrSubstNo(Text003, Format(CurrReport.PageNo())))
                    {
                    }
                    column(CopyText_Control1150106; CopyText)
                    {
                    }
                    column(STRSUBSTNO_Text11500__Purchase_Header___No____Control1150107; StrSubstNo(Text11500, "Purchase Header"."No."))
                    {
                    }
                    column(OutpuNo; OutputNo)
                    {
                    }
                    column(CompanyInfo__Phone_No__Caption; CompanyInfo__Phone_No__CaptionLbl)
                    {
                    }
                    column(CompanyInfo__Fax_No__Caption; CompanyInfo__Fax_No__CaptionLbl)
                    {
                    }
                    column(CompanyInfo__VAT_Registration_No__Caption; CompanyInfo__VAT_Registration_No__CaptionLbl)
                    {
                    }
                    column(DateCaption; DateCaptionLbl)
                    {
                    }
                    column(Purchase_Header___Pay_to_Vendor_No__Caption; Purchase_Header___Pay_to_Vendor_No__CaptionLbl)
                    {
                    }
                    column(PageLoop_Number; Number)
                    {
                    }
                    dataitem(DimensionLoop1; "Integer")
                    {
                        DataItemLinkReference = "Purchase Header";
                        DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                        column(DimText; DimText)
                        {
                        }
                        column(DimensionLoop1_Number; DimensionLoop1.Number)
                        {
                        }
                        column(DimText_Control58; DimText)
                        {
                        }
                        column(Header_DimensionsCaption; Header_DimensionsCaptionLbl)
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
                                      '%1 - %2', DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                else
                                    DimText :=
                                      StrSubstNo(
                                        '%1; %2 - %3', DimText,
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
                    dataitem("Purchase Line"; "Purchase Line")
                    {
                        DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                        DataItemLinkReference = "Purchase Header";
                        DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");

                        trigger OnPreDataItem()
                        begin
                            CurrReport.Break();
                        end;
                    }
                    dataitem(RoundLoop; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(ShowInternalInfo; ShowInternalInfo)
                        {
                        }
                        column(GArchiveDocument; GArchiveDocument)
                        {
                        }
                        column(LogInteraction; LogInteraction)
                        {
                        }
                        column(PurchaseLineType; Format("Purchase Line".Type, 0, 2))
                        {
                        }
                        column(PurchaseLine_LineNo; "Purchase Line"."Line No.")
                        {
                        }
                        column(Purchase_Line__Description; "Purchase Line".Description)
                        {
                        }
                        column(Purchase_Line__Description_Control46; "Purchase Line".Description)
                        {
                        }
                        column(Purchase_Line__Quantity; "Purchase Line".Quantity)
                        {
                        }
                        column(Purchase_Line___Unit_of_Measure_; "Purchase Line"."Unit of Measure")
                        {
                        }
                        column(Purchase_Line___Expected_Receipt_Date_; Format("Purchase Line"."Expected Receipt Date"))
                        {
                        }
                        column(Purchase_Line___Expected_Receipt_Date__Control55; Format("Purchase Line"."Expected Receipt Date"))
                        {
                        }
                        column(Purchase_Line___Unit_of_Measure__Control54; "Purchase Line"."Unit of Measure")
                        {
                        }
                        column(Purchase_Line__Quantity_Control53; "Purchase Line".Quantity)
                        {
                        }
                        column(Purchase_Line__Description_Control52; "Purchase Line"."PWD LPSA Description 1" + '  ' + "Purchase Line"."PWD LPSA Description 2")
                        {
                        }
                        column(Purchase_Line___No__; "Purchase Line"."No.")
                        {
                        }
                        column(Purchase_Line___Vendor_Item_No__; CopyStr("Purchase Line"."Vendor Item No.", 1, 8))
                        {
                        }
                        column(Purchase_Line_Line_No; "Purchase Line"."Line No." / 1000)
                        {
                            DecimalPlaces = 0 : 0;
                        }
                        column(CstGText013; CstGText013)
                        {
                            //DecimalPlaces = 0 : 0;
                        }
                        column(Purchase_Line___LPSA_Description_2_; "Purchase Line"."PWD LPSA Description 2")
                        {
                        }
                        column(Purchase_Line___Unit_of_Measure__Code; "Purchase Line"."Unit of Measure Code")
                        {
                        }
                        column(Comment_Line; TxtGComment)
                        {
                        }
                        column(Purchase_Line___Expected_Receipt_Date__Control55Caption; Purchase_Line___Expected_Receipt_Date__Control55CaptionLbl)
                        {
                        }
                        column(Purchase_Line___Unit_of_Measure__Control54Caption; "Purchase Line".FieldCaption("Unit of Measure"))
                        {
                        }
                        column(Purchase_Line__Quantity_Control53Caption; "Purchase Line".FieldCaption(Quantity))
                        {
                        }
                        column(Purchase_Line__Description_Control52Caption; Purchase_Line__Description_Control52CaptionLbl)
                        {
                        }
                        column(Purchase_Line___No__Caption; Purchase_Line___No__CaptionLbl)
                        {
                        }
                        column(Purchase_Line___Vendor_Item_No__Caption; Purchase_Line___Vendor_Item_No__CaptionLbl)
                        {
                        }
                        column(RoundLoop_Number; Number)
                        {
                        }
                        dataitem(DimensionLoop2; "Integer")
                        {
                            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                            column(DimText_Control60; DimText)
                            {
                            }
                            column(DimensionLoop2_Number; DimensionLoop2.Number)
                            {
                            }
                            column(DimText_Control80; DimText)
                            {
                            }
                            column(Line_DimensionsCaption; Line_DimensionsCaptionLbl)
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
                                          '%1 - %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    else
                                        DimText :=
                                          StrSubstNo(
                                            '%1; %2 - %3', DimText,
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
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then
                                PurchLine.Find('-')
                            else
                                PurchLine.Next();
                            "Purchase Line" := PurchLine;

                            //>>Regie
                            Clear(TxtGComment);
                            BooGStopComment := false;
                            RecGPurchCommentLine.Reset();
                            RecGPurchCommentLine.SetRange("Document Type", RecGPurchCommentLine."Document Type"::Quote);
                            RecGPurchCommentLine.SetRange("No.", "Purchase Line"."Document No.");
                            RecGPurchCommentLine.SetRange("Document Line No.", "Purchase Line"."Line No.");
                            if RecGPurchCommentLine.FindSet() then
                                repeat
                                    if StrLen(TxtGComment) + StrLen(RecGPurchCommentLine.Comment) < 1024 then
                                        TxtGComment += RecGPurchCommentLine.Comment + ' '
                                    else
                                        BooGStopComment := true;
                                until (RecGPurchCommentLine.Next() = 0) or (BooGStopComment);


                            DimSetEntry2.SetRange("Dimension Set ID", DATABASE::"Purchase Line");
                            // DocDim2.SetRange("Table ID", DATABASE::"Purchase Line");
                            // DocDim2.SetRange("Document Type", "Purchase Line"."Document Type");
                            // DocDim2.SetRange("Document No.", "Purchase Line"."Document No.");
                            // DocDim2.SetRange("Line No.", "Purchase Line"."Line No.");
                        end;

                        trigger OnPostDataItem()
                        begin
                            PurchLine.DeleteAll();
                        end;

                        trigger OnPreDataItem()
                        begin
                            MoreLines := PurchLine.Find('+');
                            while MoreLines and (PurchLine.Description = '') and (PurchLine."Description 2" = '') and
                                  (PurchLine."No." = '') and (PurchLine.Quantity = 0) and
                                  (PurchLine.Amount = 0)
                            do
                                MoreLines := PurchLine.Next(-1) <> 0;
                            if not MoreLines then
                                CurrReport.Break();
                            PurchLine.SetRange("Line No.", 0, PurchLine."Line No.");
                            SetRange(Number, 1, PurchLine.Count);
                        end;
                    }
                    dataitem(Total; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                        column(FooterTxt_8_; FooterTxt[8])
                        {
                        }
                        column(FooterTxt_7_; FooterTxt[7])
                        {
                        }
                        column(FooterTxt_6_; FooterTxt[6])
                        {
                        }
                        column(FooterLabel_6_; FooterLabel[6])
                        {
                        }
                        column(FooterLabel_8_; FooterLabel[8])
                        {
                        }
                        column(FooterLabel_7_; FooterLabel[7])
                        {
                        }
                        column(FooterTxt_5_; FooterTxt[5])
                        {
                        }
                        column(FooterLabel_5_; FooterLabel[5])
                        {
                        }
                        column(FooterTxt_4_; FooterTxt[4])
                        {
                        }
                        column(FooterLabel_4_; FooterLabel[4])
                        {
                        }
                        column(FooterTxt_3_; FooterTxt[3])
                        {
                        }
                        column(FooterLabel_3_; FooterLabel[3])
                        {
                        }
                        column(FooterTxt_2_; FooterTxt[2])
                        {
                        }
                        column(FooterLabel_2_; FooterLabel[2])
                        {
                        }
                        column(FooterTxt_1_; FooterTxt[1])
                        {
                        }
                        column(FooterLabel_1_; FooterLabel[1])
                        {
                        }
                        column(Total_Number; Number)
                        {
                        }
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    Clear(PurchLine);
                    Clear(PurchPost);
                    PurchLine.DeleteAll();
                    PurchPost.GetPurchLines("Purchase Header", PurchLine, 0);

                    if Number > 1 then begin
                        CopyText := Text001;
                            OutputNo += 1;
                    end;
                    // CurrReport.PageNo := 1;
                end;

                trigger OnPostDataItem()
                begin
                    if not CurrReport.Preview then
                        PurchCountPrinted.Run("Purchase Header");
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

                CompanyInfo.Get();

                RecGVendor.Get("Purchase Header"."Buy-from Vendor No.");

                if "Purchase Header"."Vendor Order No." <> '' then
                    TxtGText009 := CstGText009
                else
                    TxtGText009 := '';

                // CH4401.begin
                PrepareHeader();
                PrepareFooter();
                // CH4401.end

                if RespCenter.Get("Responsibility Center") then begin
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                end else
                    FormatAddr.Company(CompanyAddr, CompanyInfo);
                DimSetEntry1.SetRange("Dimension Set ID", DATABASE::"Purchase Header");
                // DocDim1.SetRange("Table ID", DATABASE::"Purchase Header");
                // DocDim1.SetRange("Document Type", "Purchase Header"."Document Type");
                // DocDim1.SetRange("Document No.", "Purchase Header"."No.");

                if "Purchaser Code" = '' then begin
                    SalesPurchPerson.Init();
                    PurchaserText := '';
                end else begin
                    SalesPurchPerson.Get("Purchaser Code");
                    PurchaserText := Text000
                end;
                if "Your Reference" = '' then
                    ReferenceText := ''
                else
                    ReferenceText := FieldCaption("Your Reference");
                if "VAT Registration No." = '' then
                    VATNoText := ''
                else
                    VATNoText := FieldCaption("VAT Registration No.");
                FormatAddr.PurchHeaderPayTo(VendAddr, "Purchase Header");

                if "Shipment Method Code" = '' then
                    ShipmentMethod.Init()
                else begin
                    ShipmentMethod.Get("Shipment Method Code");
                    ShipmentMethod.TranslateDescription(ShipmentMethod, "Language Code");
                end;


                FormatAddr.PurchHeaderShipTo(ShipToAddr, "Purchase Header");

                if not CurrReport.Preview then begin
                    if GArchiveDocument then
                        ArchiveManagement.StorePurchDocument("Purchase Header", LogInteraction);

                    if LogInteraction then begin
                        CalcFields("No. of Archived Versions");
                        SegManagement.LogDocument(
                          11, "No.", "Doc. No. Occurrence", "No. of Archived Versions", DATABASE::Vendor, "Pay-to Vendor No.",
                          "Purchaser Code", '', "Posting Description", '');
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
                group(Control1900000002)
                {
                    Caption = 'Options';
                    ShowCaption = false;
                    field(NoOfCopiesF; NoOfCopies)
                    {
                        Caption = 'No. of Copies';
                        ShowCaption = false;
                        ApplicationArea = All;
                    }
                    field(ShowInternalInfoF; ShowInternalInfo)
                    {
                        Caption = 'Show Internal Information';
                        ShowCaption = false;
                        ApplicationArea = All;
                    }
                    field(ArchiveDocumentF; GArchiveDocument)
                    {
                        Caption = 'Archive Document';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if not GArchiveDocument then
                                LogInteraction := false;
                        end;
                    }
                    field(LogInteractionF; LogInteraction)
                    {
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if LogInteraction then
                                GArchiveDocument := ArchiveDocumentEnable;
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
        end;

        trigger OnOpenPage()
        begin
            // dach0001.begin
            // GArchiveDocument := PurchSetup."Archive Quotes and Orders";
            case PurchSetup."Archive Quotes" of
                PurchSetup."Archive Quotes"::Never:
                    GArchiveDocument := false;
                PurchSetup."Archive Quotes"::Always:
                    GArchiveDocument := true;
            end;
            // dach0001.end
            LogInteraction := SegManagement.FindInteractTmplCode(11) <> '';

            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        PurchSetup.Get();
    end;

    var
        CompanyInfo: Record "Company Information";
        //TODO: Table 'Document Dimension' is missing
        // DocDim1: Record "Document Dimension";
        // DocDim2: Record "Document Dimension";
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        RecGPurchCommentLine: Record "Purch. Comment Line";
        PurchLine: Record "Purchase Line" temporary;
        PurchSetup: Record "Purchases & Payables Setup";

        RespCenter: Record "Responsibility Center";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        ShipmentMethod: Record "Shipment Method";
        RecGVendor: Record Vendor;
        ArchiveManagement: Codeunit ArchiveManagement;
        FormatAddr: Codeunit "Format Address";
        Language: Codeunit Language;
        PurchPost: Codeunit "Purch.-Post";
        PurchCountPrinted: Codeunit "Purch.Header-Printed";
        SegManagement: Codeunit SegManagement;
        GArchiveDocument: Boolean;
        [InDataSet]
        ArchiveDocumentEnable: Boolean;
        BooGStopComment: Boolean;
        Continue: Boolean;
        LogInteraction: Boolean;
        [InDataSet]
        LogInteractionEnable: Boolean;
        MoreLines: Boolean;
        ShowInternalInfo: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        OutputNo: Integer;
        CompanyInfo__Fax_No__CaptionLbl: Label 'Fax No.';
        CompanyInfo__Phone_No__CaptionLbl: Label 'Phone No.';
        CompanyInfo__VAT_Registration_No__CaptionLbl: Label 'VAT Reg. No.';
        CstGText004: Label '%1, on %2';
        CstGText005: Label 'Purchase Quote';
        CstGText006: Label 'Document No.: %1';
        CstGText007: Label 'No. to be mentionned in all documents.';
        CstGText008: Label 'Vendor Fax No.:';
        CstGText009: Label 'Your Document No.:';
        CstGText010: Label 'Your reference:';
        CstGText011: Label 'Quote No.:';
        CstGText012: Label 'Your contact : %1';
        CstGText013: Label ' / ';
        DateCaptionLbl: Label 'Date';
        Header_DimensionsCaptionLbl: Label 'Header Dimensions';
        Line_DimensionsCaptionLbl: Label 'Line Dimensions';
        ML_InvAdr: Label 'Invoice Address';
        ML_OrderAdr: Label 'Order Address';
        ML_PmtTerms: Label 'Payment Terms';
        ML_PurchPerson: Label 'Purchaser';
        ML_Reference: Label 'Reference';
        ML_ShipAdr: Label 'Shipping Address';
        ML_ShipCond: Label 'Shipping Conditions';
        ML_ShipDate: Label 'Shipping Date';
        Purchase_Header___Pay_to_Vendor_No__CaptionLbl: Label 'Vendor No.:';
        Purchase_Line___Expected_Receipt_Date__Control55CaptionLbl: Label 'Expected Date';
        Purchase_Line___No__CaptionLbl: Label 'Our No.';
        Purchase_Line___Vendor_Item_No__CaptionLbl: Label 'Item No.';
        Purchase_Line__Description_Control52CaptionLbl: Label 'Description';
        Text000: Label 'Purchaser';
        Text001: Label 'COPY';
        Text003: Label 'Page %1';
        Text11500: Label 'Quote %1';
        CopyText: Text[30];
        FooterLabel: array[20] of Text[30];
        HeaderLabel: array[20] of Text[30];
        PurchaserText: Text[30];
        TxtGText009: Text[30];
        CompanyAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        VendAddr: array[8] of Text[50];
        OldDimText: Text[75];
        ReferenceText: Text[80];
        VATNoText: Text[80];
        DimText: Text[120];
        FooterTxt: array[20] of Text[120];
        HeaderTxt: array[20] of Text[120];
        TxtGComment: Text[1024];


    procedure PrepareHeader()
    begin
        Clear(HeaderLabel);
        Clear(HeaderTxt);

        FormatAddr.PurchHeaderBuyFrom(VendAddr, "Purchase Header");

        if SalesPurchPerson.Get("Purchase Header"."Purchaser Code") then begin
            HeaderLabel[2] := ML_PurchPerson;
            HeaderTxt[2] := SalesPurchPerson.Name;
        end;

        if "Purchase Header"."Your Reference" <> '' then begin
            HeaderLabel[3] := ML_Reference;
            HeaderTxt[3] := "Purchase Header"."Your Reference";
        end;

        CompressArray(HeaderLabel);
        CompressArray(HeaderTxt);
    end;


    procedure PrepareFooter()
    var
        PmtMethod: Record "Payment Terms";
        ShipMethod: Record "Shipment Method";
    begin
        Clear(FooterLabel);
        Clear(FooterTxt);

        if PmtMethod.Get("Purchase Header"."Payment Terms Code") then begin
            FooterLabel[1] := ML_PmtTerms;
            // CH0002.begin
            PmtMethod.TranslateDescription(PmtMethod, "Purchase Header"."Language Code");
            // CH0002.end
            FooterTxt[1] := PmtMethod.Description;
        end;

        // Shipping Conditions
        if ShipMethod.Get("Purchase Header"."Shipment Method Code") then begin
            FooterLabel[2] := ML_ShipCond;
            // CH0002.begin
            ShipMethod.TranslateDescription(ShipMethod, "Purchase Header"."Language Code");
            // CH0002.begin
            FooterTxt[2] := ShipMethod.Description;
        end;

        // Shipping Address
        if "Purchase Header"."Ship-to Code" <> '' then begin
            FooterLabel[3] := ML_ShipAdr;
            FooterTxt[3] := "Purchase Header"."Ship-to Name" + ' ' + "Purchase Header"."Ship-to City";
        end;

        // Invoice and Order Address
        if "Purchase Header"."Buy-from Vendor No." <> "Purchase Header"."Pay-to Vendor No." then begin
            FooterLabel[4] := ML_InvAdr;
            FooterTxt[4] := "Purchase Header"."Pay-to Name" + ', ' + "Purchase Header"."Pay-to City";
            FooterLabel[5] := ML_OrderAdr;
            FooterTxt[5] := "Purchase Header"."Buy-from Vendor Name" + ', ' + "Purchase Header"."Buy-from City";
        end;

        // Shipping Date if <> Document Date
        if not ("Purchase Header"."Expected Receipt Date" in ["Purchase Header"."Document Date", 0D]) then begin
            FooterLabel[6] := ML_ShipDate;
            FooterTxt[6] := Format("Purchase Header"."Expected Receipt Date", 0, 4);
        end;

        CompressArray(FooterLabel);
        CompressArray(FooterTxt);
    end;
}

