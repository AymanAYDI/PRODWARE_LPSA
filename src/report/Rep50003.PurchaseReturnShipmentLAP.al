report 50003 "Purchase - Return Shipment LAP"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_ACH02.001: TO 07/12/2011:  Documents achat
    //                                           - Creation Report by copy R6636
    // 
    // //>>MODIF HL
    // TI128158 DO.GEPO 29/10/2012 : Modify return shipment header - onaftergetrecord
    // 
    // //>>TDL.128
    // Point128 LY.NIBO 07/03/2013 : Add field "Vendor Order No." / Replace Your ref. by Contact
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 17/10/2017 : DEMANDES DIVERSES
    //                   - Change Length for C/AL Global TxtGCustPlanNo
    // 
    // ------------------------------------------------------------------------------------------------------------------
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/PurchaseReturnShipmentLAP.rdl';

    Caption = 'Purchase - Return Shipment';
    UsageCategory = none;

    dataset
    {
        dataitem("Return Shipment Header"; "Return Shipment Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Buy-from Vendor No.", "No. Printed";
            RequestFilterHeading = 'Posted Return Shipment';
            column(Return_Shipment_Header_No_; "No.")
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(STRSUBSTNO_Text002_CopyText_; STRSUBSTNO(Text002, CopyText))
                    {
                    }
                    column(STRSUBSTNO_Text003_FORMAT_CurrReport_PAGENO__; STRSUBSTNO(Text003, FORMAT(CurrReport.PAGENO())))
                    {
                    }
                    column(CompanyAddr_1_; CompanyAddr[1])
                    {
                    }
                    column(CompanyAddr_2_; CompanyAddr[2])
                    {
                    }
                    column(CompanyAddr_3_; CompanyAddr[3])
                    {
                    }
                    column(CompanyAddr_4_; CompanyAddr[4])
                    {
                    }
                    column(CompanyInfo__Phone_No__; CompanyInfo."Phone No.")
                    {
                    }
                    column(CompanyInfo__Fax_No__; CompanyInfo."Fax No.")
                    {
                    }
                    column(CompanyInfo__VAT_Registration_No__; CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(CompanyInfo__Giro_No__; CompanyInfo."Giro No.")
                    {
                    }
                    column(CompanyInfo__Bank_Name_; CompanyInfo."Bank Name")
                    {
                    }
                    column(CompanyInfo__Bank_Account_No__; CompanyInfo."Bank Account No.")
                    {
                    }
                    column(FORMAT__Return_Shipment_Header___Document_Date__0_4_; FORMAT("Return Shipment Header"."Document Date", 0, 4))
                    {
                    }
                    column(PurchaserText; PurchaserText)
                    {
                    }
                    column(SalesPurchPerson_Name; SalesPurchPerson.Name)
                    {
                    }
                    column(Return_Shipment_Header___No__; "Return Shipment Header"."No.")
                    {
                    }
                    column(ReferenceText; ReferenceText)
                    {
                    }
                    column(Return_Shipment_Header___Your_Reference_; "Return Shipment Header"."Your Reference")
                    {
                    }
                    column(CompanyAddr_5_; CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr_6_; CompanyAddr[6])
                    {
                    }
                    column(Return_Shipment_Header___Buy_from_Vendor_No__; "Return Shipment Header"."Buy-from Vendor No.")
                    {
                    }
                    column(ShipToAddr_1_; ShipToAddr[1])
                    {
                    }
                    column(ShipToAddr_2_; ShipToAddr[2])
                    {
                    }
                    column(ShipToAddr_3_; ShipToAddr[3])
                    {
                    }
                    column(ShipToAddr_4_; ShipToAddr[4])
                    {
                    }
                    column(ShipToAddr_5_; ShipToAddr[5])
                    {
                    }
                    column(ShipToAddr_6_; ShipToAddr[6])
                    {
                    }
                    column(ShipToAddr_7_; ShipToAddr[7])
                    {
                    }
                    column(ShipToAddr_8_; ShipToAddr[8])
                    {
                    }
                    column(PageCaption; STRSUBSTNO(Text003, ''))
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(Text007; CstGText007)
                    {
                    }
                    column(Text005; CstGText005)
                    {
                    }
                    column(STRSUBSTNO_Text006__Return_Shipment_Header___No___; STRSUBSTNO(CstGText006, "Return Shipment Header"."No."))
                    {
                    }
                    column(STRSUBSTNO_Text004; STRSUBSTNO(CstGText004, CompanyInfo.City, "Return Shipment Header"."Document Date"))
                    {
                    }
                    column(Text010; CstGText010)
                    {
                    }
                    column(Return_Shipment_Header_Buy_From_Contact; "Return Shipment Header"."Buy-from Contact")
                    {
                    }
                    column(Text008; CstGText008)
                    {
                    }
                    column(RecGVendor_Fax_No; RecGVendor."Fax No.")
                    {
                    }
                    column(STRSUBSTNO_Text012__SalesPurch_Person_Name; STRSUBSTNO(CstGText012, SalesPurchPerson.Name))
                    {
                    }
                    column(Text009; TxtGText009)
                    {
                    }
                    column(RecGPurchHderArch_Vendor_Order_No; RecGPurchHderArch."Vendor Order No.")
                    {
                    }
                    column(CstGText014; CstGText014)
                    {
                    }
                    column(CstGText015; CstGText015)
                    {
                    }
                    column(Return_Shipment_Header__VAT_Registration; RecGVendor."VAT Registration No.")
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
                    column(CompanyInfo__Giro_No__Caption; CompanyInfo__Giro_No__CaptionLbl)
                    {
                    }
                    column(CompanyInfo__Bank_Name_Caption; CompanyInfo__Bank_Name_CaptionLbl)
                    {
                    }
                    column(CompanyInfo__Bank_Account_No__Caption; CompanyInfo__Bank_Account_No__CaptionLbl)
                    {
                    }
                    column(Return_Shipment_Header___No__Caption; Return_Shipment_Header___No__CaptionLbl)
                    {
                    }
                    column(Return_Shipment_Header___Buy_from_Vendor_No__Caption; Return_Shipment_Header___Buy_from_Vendor_No__CaptionLbl)
                    {
                    }
                    column(PageLoop_Number; Number)
                    {
                    }
                    dataitem(DimensionLoop1; "Integer")
                    {
                        DataItemLinkReference = "Return Shipment Header";
                        DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                        column(DimText; DimText)
                        {
                        }
                        column(DimensionLoop1_Number; DimensionLoop1.Number)
                        {
                        }
                        column(DimText_Control47; DimText)
                        {
                        }
                        column(Header_DimensionsCaption; Header_DimensionsCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            IF Number = 1 THEN BEGIN
                                IF NOT DimSetEntry1.FIND('-') THEN
                                    CurrReport.BREAK();
                            END ELSE
                                IF NOT Continue THEN
                                    CurrReport.BREAK();

                            CLEAR(DimText);
                            Continue := FALSE;
                            REPEAT
                                OldDimText := DimText;
                                IF DimText = '' THEN
                                    DimText := STRSUBSTNO(
                                      '%1 - %2', DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                ELSE
                                    DimText :=
                                      STRSUBSTNO(
                                        '%1; %2 - %3', DimText,
                                        DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
                                IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                    DimText := OldDimText;
                                    Continue := TRUE;
                                    EXIT;
                                END;
                            UNTIL (DimSetEntry1.NEXT() = 0);
                        end;

                        trigger OnPreDataItem()
                        begin
                            IF NOT ShowInternalInfo THEN
                                CurrReport.BREAK();
                        end;
                    }
                    dataitem("Return Shipment Line"; "Return Shipment Line")
                    {
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemLinkReference = "Return Shipment Header";
                        DataItemTableView = SORTING("Document No.", "Line No.");
                        column(TypeInt; TypeInt)
                        {
                        }
                        column(ShowInternalInfo; ShowInternalInfo)
                        {
                        }
                        column(Return_Shipment_Line_Description; Description)
                        {
                        }
                        column(Return_Shipment_Line__Unit_of_Measure_; "Unit of Measure")
                        {
                        }
                        column(Return_Shipment_Line_Quantity; Quantity)
                        {
                        }
                        column(Return_Shipment_Line_Description_Control38; Description)
                        {
                        }
                        column(Return_Shipment_Line__No__; COPYSTR("No.", 1, 8))
                        {
                        }
                        column(Return_Shipment_Line_Description_Control42; Description)
                        {
                        }
                        column(Return_Shipment_Line_Quantity_Control43; Quantity)
                        {
                        }
                        column(Return_Shipment_Line__Unit_of_Measure__Control44; "Unit of Measure")
                        {
                        }
                        column(Return_Shipment_Line_Line_No; "Return Shipment Line"."Line No." / 1000)
                        {
                            DecimalPlaces = 0 : 0;
                        }
                        column(CstGText013; CstGText013)
                        {
                            //DecimalPlaces = 0 : 0;
                        }
                        column(Return_Shipment_Line___LPSA_Description_1_; "Return Shipment Line"."PWD LPSA Description 1")
                        {
                        }
                        column(RecGItem_LPSA_Plan_No; TxtGCustPlanNo)
                        {
                        }
                        column(RecGItem_Customer_Plan_No; TxtGCustRefNo)
                        {
                        }
                        column(Return_Shipment_Line__Unit_of_Measure__Code; "Unit of Measure Code")
                        {
                        }
                        column(Comment_Line; TxtGComment)
                        {
                        }
                        column(Return_Shipment_Line__Unit_of_Measure__Control44Caption; FIELDCAPTION("Unit of Measure"))
                        {
                        }
                        column(Return_Shipment_Line_Quantity_Control43Caption; FIELDCAPTION(Quantity))
                        {
                        }
                        column(Return_Shipment_Line_Description_Control42Caption; Return_Shipment_Line_Description_Control42CaptionLbl)
                        {
                        }
                        column(Return_Shipment_Line__No__Caption; Return_Shipment_Line__No__CaptionLbl)
                        {
                        }
                        column(RecGItem_LPSA_Plan_No_Caption; RecGItem_LPSA_Plan_No_CaptionLbl)
                        {
                        }
                        column(RecGItem_Customer_Plan_No_Caption; RecGItem_Customer_Plan_No_CaptionLbl)
                        {
                        }
                        column(Return_Shipment_Line_Document_No_; "Document No.")
                        {
                        }
                        column(Return_Shipment_Line_Line_No_; "Line No.")
                        {
                        }
                        dataitem(DimensionLoop2; "Integer")
                        {
                            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                            column(DimText_Control65; DimText)
                            {
                            }
                            column(DimensionLoop2_Number; DimensionLoop2.Number)
                            {
                            }
                            column(DimText_Control67; DimText)
                            {
                            }
                            column(Line_DimensionsCaption; Line_DimensionsCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                IF Number = 1 THEN BEGIN
                                    IF NOT DimSetEntry2.FIND('-') THEN
                                        CurrReport.BREAK();
                                END ELSE
                                    IF NOT Continue THEN
                                        CurrReport.BREAK();

                                CLEAR(DimText);
                                Continue := FALSE;
                                REPEAT
                                    OldDimText := DimText;
                                    IF DimText = '' THEN
                                        DimText := STRSUBSTNO(
                                          '%1 - %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    ELSE
                                        DimText :=
                                          STRSUBSTNO(
                                            '%1; %2 - %3', DimText,
                                            DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
                                    IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                        DimText := OldDimText;
                                        Continue := TRUE;
                                        EXIT;
                                    END;
                                UNTIL (DimSetEntry2.NEXT() = 0);
                            end;

                            trigger OnPreDataItem()
                            begin
                                IF NOT ShowInternalInfo THEN
                                    CurrReport.BREAK();
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            IF "Return Shipment Line".Type = "Return Shipment Line".Type::Item THEN
                                RecGItem.GET("Return Shipment Line"."No.");

                            //>>TD.LPSA.09022015
                            TxtGCustPlanNo := '';
                            TxtGCustRefNo := '';
                            RecGItemCrossRef.SETRANGE("Item No.", RecGItem."No.");
                            RecGItemCrossRef.SETRANGE("Variant Code", "Variant Code");
                            RecGItemCrossRef.SETRANGE("Unit of Measure", "Unit of Measure Code");
                            RecGItemCrossRef.SETRANGE("Reference Type", RecGItemCrossRef."Reference Type"::Customer);
                            RecGItemCrossRef.SETRANGE("Reference Type No.", "Return Shipment Header"."Sell-to Customer No.");
                            IF RecGItemCrossRef.FINDFIRST() THEN
                                TxtGCustRefNo := RecGItemCrossRef."Reference No.";
                            TxtGCustPlanNo := RecGItemCrossRef."PWD Customer Plan No.";

                            IF TxtGCustPlanNo = '' THEN
                                TxtGCustPlanNo := RecGItem."PWD Customer Plan No.";

                            //<<TD.LPSA.09022015

                            //>>Regie
                            CLEAR(TxtGComment);
                            BooGStopComment := FALSE;
                            RecGPurchCommentLine.RESET();
                            RecGPurchCommentLine.SETRANGE("Document Type", RecGPurchCommentLine."Document Type"::"Posted Return Shipment");
                            RecGPurchCommentLine.SETRANGE("No.", "Document No.");
                            RecGPurchCommentLine.SETRANGE("Document Line No.", "Line No.");
                            IF RecGPurchCommentLine.FINDSET() THEN
                                REPEAT
                                    IF STRLEN(TxtGComment) + STRLEN(RecGPurchCommentLine.Comment) < 1024 THEN
                                        TxtGComment += RecGPurchCommentLine.Comment + ' '
                                    ELSE
                                        BooGStopComment := TRUE;
                                UNTIL (RecGPurchCommentLine.NEXT() = 0) OR (BooGStopComment);


                            IF (NOT ShowCorrectionLines) AND Correction THEN
                                CurrReport.SKIP();
                            DimSetEntry2.SETRANGE("Dimension Set ID", DATABASE::"Return Shipment Line");
                            // PostedDocDim2.SETRANGE("Table ID", DATABASE::"Return Shipment Line");
                            // PostedDocDim2.SETRANGE("Document No.", "Return Shipment Line"."Document No.");
                            // PostedDocDim2.SETRANGE("Line No.", "Return Shipment Line"."Line No.");

                                TypeInt := "Return Shipment Line".Type.AsInteger();
                        end;

                        trigger OnPreDataItem()
                        begin
                            MoreLines := FIND('+');
                            WHILE MoreLines AND (Description = '') AND ("No." = '') AND (Quantity = 0) DO
                                MoreLines := NEXT(-1) <> 0;
                            IF NOT MoreLines THEN
                                CurrReport.BREAK();
                            SETRANGE("Line No.", 0, "Line No.");
                        end;
                    }
                    dataitem(Total; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                        column(Return_Shipment_Header___Pay_to_Vendor_No__; "Return Shipment Header"."Pay-to Vendor No.")
                        {
                        }
                        column(Return_Shipment_Header___Pay_to_Vendor_No__Caption; "Return Shipment Header".FIELDCAPTION("Pay-to Vendor No."))
                        {
                        }
                        column(Total_Number; Number)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                                PayToVendorNo := "Return Shipment Header"."Pay-to Vendor No.";
                                BuyFromVendorNo := "Return Shipment Header"."Buy-from Vendor No.";
                                PayToCaption := "Return Shipment Header".FIELDCAPTION("Pay-to Vendor No.");
                        end;

                        trigger OnPreDataItem()
                        begin
                            IF "Return Shipment Header"."Buy-from Vendor No." = "Return Shipment Header"."Pay-to Vendor No." THEN
                                CurrReport.BREAK();
                        end;
                    }
                    dataitem(Total2; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                        column(VendAddr_1_; VendAddr[1])
                        {
                        }
                        column(VendAddr_2_; VendAddr[2])
                        {
                        }
                        column(VendAddr_3_; VendAddr[3])
                        {
                        }
                        column(VendAddr_4_; VendAddr[4])
                        {
                        }
                        column(VendAddr_5_; VendAddr[5])
                        {
                        }
                        column(VendAddr_6_; VendAddr[6])
                        {
                        }
                        column(VendAddr_7_; VendAddr[7])
                        {
                        }
                        column(VendAddr_8_; VendAddr[8])
                        {
                        }
                        column(PayToVendorNo; PayToVendorNo)
                        {
                        }
                        column(BuyFromVendorNo; BuyFromVendorNo)
                        {
                        }
                        column(PayToVendorNo_Control75; PayToCaption)
                        {
                        }
                        column(Pay_to_AddressCaption; Pay_to_AddressCaptionLbl)
                        {
                        }
                        column(Total2_Number; Number)
                        {
                        }
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    IF Number > 1 THEN BEGIN
                        CopyText := Text001;
                            OutputNo += 1;
                    END;
                    // CurrReport.PAGENO := 1;
                end;

                trigger OnPostDataItem()
                begin
                    IF NOT CurrReport.PREVIEW THEN
                        ShptCountPrinted.RUN("Return Shipment Header");
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
                CompanyInfo.GET();

                RecGVendor.GET("Return Shipment Header"."Buy-from Vendor No.");

                IF RespCenter.GET("Responsibility Center") THEN BEGIN
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                END ELSE
                    FormatAddr.Company(CompanyAddr, CompanyInfo);
                DimSetEntry1.SETRANGE("Dimension Set ID", DATABASE::"Return Shipment Header");
                // PostedDocDim1.SETRANGE("Table ID", DATABASE::"Return Shipment Header");
                // PostedDocDim1.SETRANGE("Document No.", "Return Shipment Header"."No.");

                IF "Purchaser Code" = '' THEN BEGIN
                    SalesPurchPerson.INIT();
                    PurchaserText := '';
                END ELSE BEGIN
                    SalesPurchPerson.GET("Purchaser Code");
                    PurchaserText := Text000
                END;
                IF "Your Reference" = '' THEN
                    ReferenceText := ''
                ELSE
                    ReferenceText := FIELDCAPTION("Your Reference");

                //>>TI128158
                //FormatAddr.PurchShptBuyFrom(ShipToAddr,"Return Shipment Header");
                LPSAFunctionsMgt.PurchShptBuyFromFixedAddr(ShipToAddr, "Return Shipment Header");
                //<<TI128158
                FormatAddr.PurchShptPayTo(VendAddr, "Return Shipment Header");
                IF GLogInteraction THEN
                    IF NOT CurrReport.PREVIEW THEN
                        SegManagement.LogDocument(
                          21, "No.", 0, 0, DATABASE::Vendor, "Buy-from Vendor No.", "Purchaser Code", '', "Posting Description", '');

                RecGPurchHderArch.RESET();
                RecGPurchHderArch.SETRANGE("Document Type", RecGPurchHderArch."Document Type"::"Return Order");
                RecGPurchHderArch.SETRANGE("No.", "Return Shipment Header"."Return Order No.");
                IF ((RecGPurchHderArch.FINDFIRST()) AND (RecGPurchHderArch."Vendor Order No." <> '')) THEN
                    TxtGText009 := CstGText009
                ELSE
                    TxtGText009 := '';
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
                    field(ShowCorrectionLinesF; ShowCorrectionLines)
                    {
                        Caption = 'Show Correction Lines';
                        ShowCaption = false;
                        ApplicationArea = All;
                    }
                    field(LogInteractionF; GLogInteraction)
                    {
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
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
            LogInteractionEnable := TRUE;
        end;

        trigger OnOpenPage()
        begin
            GLogInteraction := SegManagement.FindInteractTmplCode(21) <> '';
            LogInteractionEnable := GLogInteraction;
        end;
    }

    labels
    {
    }

    var
        CompanyInfo: Record "Company Information";
        //TODO: Table 'Posted Document Dimension' is missing
        // PostedDocDim1: Record "Posted Document Dimension";
        // PostedDocDim2: Record "Posted Document Dimension";
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        RecGItem: Record Item;
        RecGItemCrossRef: Record "Item Reference";
        RecGPurchCommentLine: Record "Purch. Comment Line";
        RecGPurchHderArch: Record "Purchase Header Archive";
        RespCenter: Record "Responsibility Center";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        RecGVendor: Record Vendor;
        FormatAddr: Codeunit "Format Address";
        LPSAFunctionsMgt: Codeunit "PWD LPSA Functions Mgt.";
        ShptCountPrinted: Codeunit "Return Shipment - Printed";
        SegManagement: Codeunit SegManagement;
        BooGStopComment: Boolean;
        Continue: Boolean;
        GLogInteraction: Boolean;
        [InDataSet]
        LogInteractionEnable: Boolean;
        MoreLines: Boolean;
        ShowCorrectionLines: Boolean;
        ShowInternalInfo: Boolean;
        BuyFromVendorNo: Code[20];
        PayToVendorNo: Code[20];
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        OutputNo: Integer;
        TypeInt: Integer;
        CompanyInfo__Bank_Account_No__CaptionLbl: Label 'Account No.';
        CompanyInfo__Bank_Name_CaptionLbl: Label 'Bank';
        CompanyInfo__Fax_No__CaptionLbl: Label 'Fax No.';
        CompanyInfo__Giro_No__CaptionLbl: Label 'Giro No.';
        CompanyInfo__Phone_No__CaptionLbl: Label 'Phone No.';
        CompanyInfo__VAT_Registration_No__CaptionLbl: Label 'VAT Reg. No.';
        CstGText004: Label '%1, on %2';
        CstGText005: Label 'Purchase Quote';
        CstGText006: Label 'Document No.: %1';
        CstGText007: Label 'No. to be mentionned in all documents.';
        CstGText008: Label 'Vendor Fax No.:';
        CstGText009: Label 'Your Document No.:';
        CstGText010: Label 'Your contact:';
        CstGText012: Label 'Your contact : %1';
        CstGText013: Label ' / ';
        CstGText014: Label 'Document No.: ';
        CstGText015: Label 'VAT No. :';
        Header_DimensionsCaptionLbl: Label 'Header Dimensions';
        Line_DimensionsCaptionLbl: Label 'Line Dimensions';
        Pay_to_AddressCaptionLbl: Label 'Pay-to Address';
        RecGItem_Customer_Plan_No_CaptionLbl: Label 'Your Item Ref. = ';
        RecGItem_LPSA_Plan_No_CaptionLbl: Label 'Your Plan No. = ';
        Return_Shipment_Header___Buy_from_Vendor_No__CaptionLbl: Label 'Vendor No.:';
        Return_Shipment_Header___No__CaptionLbl: Label 'Shipment No.';
        Return_Shipment_Line__No__CaptionLbl: Label 'Item Code';
        Return_Shipment_Line_Description_Control42CaptionLbl: Label 'Description';
        Text000: Label 'Purchaser';
        Text001: Label 'COPY';
        Text002: Label 'Purchase - Return Shipment %1';
        Text003: Label 'Page %1';
        TxtGCustRefNo: Text[20];
        CopyText: Text[30];
        PayToCaption: Text[30];
        PurchaserText: Text[30];
        TxtGText009: Text[30];
        CompanyAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        VendAddr: array[8] of Text[50];
        OldDimText: Text[75];
        ReferenceText: Text[80];
        TxtGCustPlanNo: Text[100];
        DimText: Text[120];
        TxtGComment: Text[1024];
}

