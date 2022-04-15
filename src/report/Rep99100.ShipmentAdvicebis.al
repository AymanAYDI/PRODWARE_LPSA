report 99100 "PWD Shipment Advice bis"
{
    // +----------------------------------------------------------------------------------------------------------------------------------+
    // | Prodware : www.prodware.fr                                                                                                       |
    // +----------------------------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.00
    //     -Report Creation
    //     -Layout Creation
    // 
    // 
    // //>>LAP2.02
    // FE-VTE-07.001:GR 09/05/2012 : Lot No on Shipment Advice
    //                               Add Lot On Section Sales Shipment Line
    //                               Show Line With Lot No only if Lot No <> ''
    // 
    // //>>LAP2.02.001:TU 22/06/2012 : Modify Code : Sales Shipment Header - OnAfterGetRecord()
    // 
    // //>>FE-VTE-07.002:SURSITE 29/06/2012 : Item No on 8 car
    // +----------------------------------------------------------------------------------------------------------------------------------+
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/ShipmentAdvicebis.rdl';

    Caption = 'Sales - Shipment';

    dataset
    {
        dataitem("Sales Shipment Header"; "Sales Shipment Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Posted Sales Shipment';
            column(Sales_Shipment_Header_No_; "No.")
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(Sales_Header_No_; "Sales Shipment Header"."No.")
                    {
                    }
                    column(CompanyInfo_City; CompanyInfo.City + ' , ' + Format(Today, 0, 4))
                    {
                    }
                    column(Sales_Header_Document_Date; "Sales Shipment Header"."Order Date")
                    {
                    }
                    column(Sales_Header___Sell_to_Customer_No__; CustName)
                    {
                    }
                    column(SalesPersonText; Text000)
                    {
                    }
                    column(Sales_Header_VAT_Registration_No_; CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(Sales_Header_External_Document_No_; "Sales Shipment Header"."External Document No.")
                    {
                    }
                    column(Sales_Header_Your_Reference; BSContact)
                    {
                    }
                    column(SalesPurchPerson_Name; SalesPurchPerson.Name)
                    {
                    }
                    column(FORMAT__Sales_Header___Document_Date__0_4_; Format(Today, 0, 4))
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(ShipToAddr_8_; ShipToAddr[8])
                    {
                    }
                    column(ShipToAddr_7_; ShipToAddr[7])
                    {
                    }
                    column(ShipToAddr_5_; ShipToAddr[5])
                    {
                    }
                    column(ShipToAddr_6_; ShipToAddr[6])
                    {
                    }
                    column(ShipToAddr_3_; ShipToAddr[3])
                    {
                    }
                    column(ShipToAddr_4_; ShipToAddr[4])
                    {
                    }
                    column(ShipToAddr_2_; ShipToAddr[2])
                    {
                    }
                    column(ShipToAddr_1_; ShipToAddr[1])
                    {
                    }
                    column(Facture_caption; Facture_captionLbl)
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
                    column(PageLoop_Number; Number)
                    {
                    }
                    dataitem("Sales Shipment Line"; "Sales Shipment Line")
                    {
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemLinkReference = "Sales Shipment Header";
                        DataItemTableView = SORTING("Document No.", "Line No.");
                        column(Sales_Shipment_Line_Description; Description)
                        {
                        }
                        column(ShowInternalInfo; ShowInternalInfo)
                        {
                        }
                        column(LogInteraction; LogInteraction)
                        {
                        }
                        column(ShowCorrectionLines; ShowCorrectionLines)
                        {
                        }
                        column(ShowLotSN; ShowLotSN)
                        {
                        }
                        column(Sales_Shipment_Line__Type; Format("Sales Shipment Line".Type, 0, 2))
                        {
                        }
                        column(Scrap_Quantity; "PWD Scrap Quantity")
                        {
                        }
                        column(ItemType; "Sales Shipment Line".Type::Item = "Sales Shipment Line".Type)
                        {
                        }
                        column(TxtItemNo8Car; TxtItemNo8Car)
                        {
                        }
                        column(Sales_Shipment_Line__No__; "No.")
                        {
                        }
                        column(Sales_Shipment_Line_Description_Control44; "Sales Shipment Line"."PWD LPSA Description 1" + ' ' + "Sales Shipment Line"."PWD LPSA Description 2")
                        {
                        }
                        column(OrdredQty; OrdredQty)
                        {
                        }
                        column(Sales_Shipment_Line__Unit_of_Measure__Control46; "Unit of Measure Code")
                        {
                        }
                        column(Qty_Shipped; Quantity)
                        {
                        }
                        column(OutstandingQtytoShip; OutstandingQtytoShip)
                        {
                        }
                        column(STRSUBSTNO_Text004__Sales_Shipment_Line___Scrap_Quantity____Sales_Shipment_Line___Unit_of_Measure__; StrSubstNo(Text004, "Sales Shipment Line"."PWD Scrap Quantity", "Sales Shipment Line"."Unit of Measure"))
                        {
                        }
                        column(Text005; Text005 + ' ' + Format(CrossReferenceNo))
                        {
                        }
                        column(Text006___FORMAT_Item__Customer_Plan_No___; Text006 + ' ' + Format(Item."PWD Customer Plan No."))
                        {
                        }
                        column(CrossReferenceNo; CrossReferenceNo)
                        {
                        }
                        column(Item_Customer_Plan_No; Item."PWD Customer Plan No.")
                        {
                        }
                        column(Sales_Shipment_Line__Scrap_Quantity_; "PWD Scrap Quantity")
                        {
                        }
                        column(Text014____FORMAT_TempItemLedgEntry__Lot_No___; TxtGLotNo)
                        {
                        }
                        column(Sales_Shipment_Line__Unit_of_Measure__Control46Caption; Sales_Shipment_Line__Unit_of_Measure__Control46CaptionLbl)
                        {
                        }
                        column(Qty_Ordred_caption; Qty_Ordred_captionLbl)
                        {
                        }
                        column(Sales_Shipment_Line_Description_Control44Caption; Sales_Shipment_Line_Description_Control44CaptionLbl)
                        {
                        }
                        column(Sales_Shipment_Line__No__Caption; FieldCaption("No."))
                        {
                        }
                        column(Qty_Shipped_caption; Qty_Shipped_captionLbl)
                        {
                        }
                        column(Rest_to_Ship_caption; Rest_to_Ship_captionLbl)
                        {
                        }
                        column(Sales_Shipment_Line_Document_No_; "Document No.")
                        {
                        }
                        column(Sales_Shipment_Line_Line_No_; "Line No.")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            OrdredQty := 0;
                            SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                            SalesLine.SetRange("Document No.", "Order No.");
                            SalesLine.SetRange(Type, "Sales Shipment Line".Type);
                            SalesLine.SetRange("Line No.", "Order Line No.");
                            if SalesLine.FindFirst() then begin
                                OrdredQty := SalesLine.Quantity;
                                if OrdredQty <> 0 then
                                    OutstandingQtytoShip := OrdredQty - SalesLine."Quantity Shipped" - "Sales Shipment Line"."PWD Scrap Quantity";
                            end
                            else begin
                                SalesInvoiceLine.SetRange("Order No.", "Order No.");
                                SalesInvoiceLine.SetRange(Type, "Sales Shipment Line".Type);
                                SalesInvoiceLine.SetRange("Order Line No.", "Order Line No.");
                                if SalesInvoiceLine.FindFirst() then begin
                                    repeat
                                        OrdredQty := OrdredQty + SalesInvoiceLine.Quantity;
                                    until SalesInvoiceLine.Next() = 0;

                                    if OrdredQty <> 0 then
                                        OutstandingQtytoShip := CalcOustandingQty("Order No.", "Order Line No.");
                                    //OutstandingQtytoShip := OrdredQty-"Sales Shipment Line"."Scrap Quantity"-"Sales Shipment Line".Quantity ;

                                end;
                            end;

                            if (OutstandingQtytoShip < 0) then
                                OutstandingQtytoShip := 0;

                            if not ShowCorrectionLines and Correction then
                                CurrReport.Skip();

                            PostedDocDim2.SetRange("Table ID", DATABASE::"Sales Shipment Line");
                            PostedDocDim2.SetRange("Document No.", "Sales Shipment Line"."Document No.");
                            PostedDocDim2.SetRange("Line No.", "Sales Shipment Line"."Line No.");
                            if Type = Type::Item then begin
                                if Item.Get("No.") then;
                                FindCrossRef();
                            end;
                            SearchLot();

                            //>>FE-VTE-07.001
                            TxtGLotNo := '';
                            if TempItemLedgEntry."Lot No." <> '' then
                                TxtGLotNo := CstGTxt014 + '  ' + Format(TempItemLedgEntry."Lot No.");
                            //<FE-VTE-07.001

                            //>>FE-VTE-07.002
                            TxtItemNo8Car := '';
                            TxtItemNo8Car := CopyStr("No.", 1, 8)
                            //>>FE-VTE-07.002
                        end;

                        trigger OnPostDataItem()
                        begin
                            // Item Tracking:
                            if ShowLotSN then
                                TrackingSpecCount := ItemTrackingMgt.RetrieveDocumentItemTracking(TrackingSpecBuffer, "Sales Shipment Header"."No.",
                                  DATABASE::"Sales Shipment Header", 0);
                        end;

                        trigger OnPreDataItem()
                        begin
                            MoreLines := Find('+');
                            while MoreLines and (Description = '') and ("No." = '') and (Quantity = 0) do
                                MoreLines := Next(-1) <> 0;
                            if not MoreLines then
                                CurrReport.Break();
                            SetRange("Line No.", 0, "Line No.");

                            /*SETRANGE(Number,1,TrackingSpecCount);
                            TrackingSpecBuffer.SETCURRENTKEY("Source ID","Source Type","Source Subtype","Source Batch Name",
                              "Source Prod. Order Line","Source Ref. No.");*/

                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if "Sales Shipment Header"."Bill-to Customer No." = '' then begin
                            CustName := "Sales Shipment Header"."Sell-to Customer No.";
                            BSContact := "Sales Shipment Header"."Sell-to Contact";
                        end
                        else begin
                            CustName := "Sales Shipment Header"."Bill-to Customer No.";
                            BSContact := "Sales Shipment Header"."Bill-to Contact";
                        end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SalesHeader.SetRange("Document Type", SalesLine."Document Type"::Order);
                        SalesHeader.SetRange("No.", "Sales Shipment Header"."Order No.");
                        if SalesHeader.FindFirst() then begin
                            DocumentDate := SalesHeader."Document Date";
                            YourDocumentNo := SalesHeader."External Document No.";
                        end;

                        // Item Tracking:
                        if ShowLotSN then begin
                            TrackingSpecCount := 0;
                            OldRefNo := 0;
                            ShowGroup := false;
                        end;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                        CopyText := Text001;
                        if IsServiceTier then
                            OutputNo += 1;
                    end;
                    CurrReport.PageNo := 1;
                    TotalQty := 0;           // Item Tracking
                end;

                trigger OnPostDataItem()
                begin
                    if not CurrReport.Preview then
                        ShptCountPrinted.Run("Sales Shipment Header");
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := 1 + Abs(NoOfCopies);
                    CopyText := '';
                    SetRange(Number, 1, NoOfLoops);
                    if IsServiceTier then
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

                PostedDocDim1.SetRange("Table ID", DATABASE::"Sales Shipment Header");
                PostedDocDim1.SetRange("Document No.", "Sales Shipment Header"."No.");

                if "Salesperson Code" = '' then begin
                    SalesPurchPerson.Init();
                    SalesPersonText := '';
                end else begin
                    if SalesPurchPerson.Get("Salesperson Code") then;
                    SalesPersonText := Text000;
                end;
                if "Your Reference" = '' then
                    ReferenceText := ''
                else
                    ReferenceText := FieldCaption("Your Reference");

                //>>LAP2.02.001
                //STD FormatAddr.SalesShptShipTo(ShipToAddr,"Sales Shipment Header");
                FormatAddr.SalesShptShipToFixedAddr(ShipToAddr, "Sales Shipment Header");
                //<<LAP2.02.001

                FormatAddr.SalesShptBillTo(CustAddr, "Sales Shipment Header");

                ShowCustAddr := "Bill-to Customer No." <> "Sell-to Customer No.";
                for i := 1 to ArrayLen(CustAddr) do
                    if CustAddr[i] <> ShipToAddr[i] then
                        ShowCustAddr := true;

                if LogInteraction then
                    if not CurrReport.Preview then
                        SegManagement.LogDocument(
                          5, "No.", 0, 0, DATABASE::Customer, "Sell-to Customer No.", "Salesperson Code",
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
        Text000: Label 'Your contact : ';
        Text001: Label 'COPY';
        Text002: Label 'Sales - Shipment %1';
        Text003: Label 'Page %1';
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        PostedDocDim1: Record "Posted Document Dimension";
        PostedDocDim2: Record "Posted Document Dimension";
        SalesSetup: Record "Sales & Receivables Setup";
        Language: Record Language;
        TrackingSpecBuffer: Record "Tracking Specification" temporary;
        ShptCountPrinted: Codeunit "Sales Shpt.-Printed";
        SegManagement: Codeunit SegManagement;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        RespCenter: Record "Responsibility Center";
        ItemTrackingAppendix: Report "Item Tracking Appendix";
        CustAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        SalesPersonText: Text[50];
        ReferenceText: Text[80];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        OutputNo: Integer;
        NoOfLoops: Integer;
        TrackingSpecCount: Integer;
        Quantity_itemtracking: Integer;
        OldRefNo: Integer;
        OldNo: Code[20];
        CopyText: Text[30];
        ShowCustAddr: Boolean;
        i: Integer;
        FormatAddr: Codeunit "Format Address";
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        LogInteraction: Boolean;
        ShowCorrectionLines: Boolean;
        ShowLotSN: Boolean;
        ShowTotal: Boolean;
        ShowGroup: Boolean;
        TotalQty: Decimal;
        NewPage: Boolean;
        Cust: Record Customer;
        Item: Record Item;
        GetSalesShipLineType: Integer;
        [InDataSet]
        LogInteractionEnable: Boolean;
        OrdredQty: Decimal;
        OutstandingQtytoShip: Decimal;
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        DocumentDate: Date;
        YourDocumentNo: Code[20];
        CustName: Code[20];
        BSContact: Text[50];
        Text004: Label 'Scrap : %1 %2';
        Text005: Label 'Your Item Ref.';
        Text006: Label 'You Plan No.';
        ItemCrossRef: Record "Item Cross Reference";
        CrossReferenceNo: Code[20];
        TempItemLedgEntry: Record "Item Ledger Entry";
        ValueEntryRelation: Record "Value Entry Relation";
        SalesInvoiceLine: Record "Sales Invoice Line";
        "--LAP2.02--": ;
        CstGTxt014: Label 'LPSA No.:';
        "-LAP2.02-": Integer;
        RecGItemRelation: Record "Item Entry Relation";
        RecGItemLedgEntry: Record "Item Ledger Entry";
        TxtGLotNo: Text[50];
        TxtItemNo8Car: Text[8];
        Facture_captionLbl: Label 'Shipment Advice';
        Sales_Header_No_captionLbl: Label 'Document No. : ';
        Sales_Header_Document_Date_captionLbl: Label 'Your document Date : ';
        Sales_Header___Sell_to_Customer_No__CaptionLbl: Label 'Customer No. : ';
        Sales_Header_VAT_Registration_No_captionLbl: Label 'VAT Registration No. : ';
        Sales_Header_External_Document_No_captionLbl: Label 'Your Document No. :  ';
        Sales_Header_Your_Reference_captionLbl: Label 'Your Reference : ';
        Sales_Shipment_Line__Unit_of_Measure__Control46CaptionLbl: Label 'Unit';
        Qty_Ordred_captionLbl: Label 'Qty Ordred';
        Sales_Shipment_Line_Description_Control44CaptionLbl: Label 'Description';
        Qty_Shipped_captionLbl: Label 'Qty Shipped';
        Rest_to_Ship_captionLbl: Label 'Rest to Ship';


    procedure FindCrossRef()
    begin
        Clear(CrossReferenceNo);
        ItemCrossRef.SetRange("Item No.", "Sales Shipment Line"."No.");
        ItemCrossRef.SetRange("Variant Code", "Sales Shipment Line"."Variant Code");
        ItemCrossRef.SetRange("Unit of Measure", "Sales Shipment Line"."Unit of Measure Code");
        ItemCrossRef.SetRange("Cross-Reference Type", ItemCrossRef."Cross-Reference Type"::Customer);
        ItemCrossRef.SetRange("Cross-Reference Type No.", "Sales Shipment Header"."Sell-to Customer No.");
        if ItemCrossRef.FindFirst() then
            CrossReferenceNo := ItemCrossRef."Cross-Reference No."
    end;


    procedure SearchLot()
    begin
        //>>FE-VTE-07.001
        Clear(TempItemLedgEntry);
        RecGItemRelation.Reset();
        RecGItemRelation.SetRange("Source Type", DATABASE::"Sales Shipment Line");
        RecGItemRelation.SetRange("Source ID", "Sales Shipment Line"."Document No.");
        RecGItemRelation.SetRange("Source Ref. No.", "Sales Shipment Line"."Line No.");
        if RecGItemRelation.FindFirst() then begin
            RecGItemLedgEntry.Get(RecGItemRelation."Item Entry No.");
            TempItemLedgEntry := RecGItemLedgEntry;
        end;
        //<<FE-VTE-07.001
    end;


    procedure CalcOustandingQty(OrderNo: Code[20]; OrderLineNo: Integer) Return: Decimal
    var
        SalesShipmentLine: Record "Sales Shipment Line";
        ScrapQt: Decimal;
        Qt: Decimal;
    begin
        SalesShipmentLine.Reset();
        Qt := 0;
        ScrapQt := 0;
        SalesShipmentLine.SetRange("Order No.", OrderNo);
        SalesShipmentLine.SetRange("Order Line No.", OrderLineNo);
        if SalesShipmentLine.FindFirst() then
            repeat
                Qt := Qt + SalesShipmentLine.Quantity;
                ScrapQt := ScrapQt + SalesShipmentLine."PWD Scrap Quantity";

            until SalesShipmentLine.Next() = 0;
        Return := OrdredQty - Qt - ScrapQt;
    end;
}

