report 50011 "PWD Soumission"
{
    // ------------------------------------------------------------------------------------------------------------------------------------
    // Prodware : www.prodware.fr
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 
    // //>>LAP2.00
    //     -Report Creation
    //     -Layout Creation
    // //>> 26/04/2016 SU-DADE cf appel TI324644
    // //   CodYourPlanNo code 20=> 40
    // //<< 26/04/2016 SU-DADE cf appel TI324644
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 17/10/2017 : DEMANDES DIVERSES
    //                   - Change Length for C/AL Global CodGYourPlanNo
    // 
    // ------------------------------------------------------------------------------------------------------------------------------------
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/Soumission.rdl';

    Caption = 'Soumission';
    UsageCategory = none;

    dataset
    {
        dataitem("Transfer Shipment Header"; "Transfer Shipment Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Transfer-from Code", "Transfer-to Code";
            RequestFilterHeading = 'Posted Transfer Shipment';
            column(Transfer_Shipment_Header_No_; "No.")
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(STRSUBSTNO_Text002_FORMAT_CurrReport_PAGENO__; StrSubstNo(Text002, Format(CurrReport.PageNo())))
                    {
                    }
                    column(TransferToAddr_1_; TransferToAddr[1])
                    {
                    }
                    column(TransferToAddr_2_; TransferToAddr[2])
                    {
                    }
                    column(TransferToAddr_3_; TransferToAddr[3])
                    {
                    }
                    column(TransferToAddr_4_; TransferToAddr[4])
                    {
                    }
                    column(TransferToAddr_5_; TransferToAddr[5])
                    {
                    }
                    column(TransferToAddr_6_; TransferToAddr[6])
                    {
                    }
                    column(TransferToAddr_7_; TransferToAddr[7])
                    {
                    }
                    column(TransferToAddr_8_; TransferToAddr[8])
                    {
                    }
                    column(PageCaption; StrSubstNo(Text002, ''))
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(Title; 'Soumission')
                    {
                    }
                    column(Transfer_Shipment_Header___No__; "Transfer Shipment Header"."No.")
                    {
                    }
                    column(DatGDocumentDate; "Transfer Shipment Header"."Posting Date")
                    {
                    }
                    column(CodGCustomerNo; CodGCustomerNo)
                    {
                    }
                    column(RecGCompanyInfo_City; RecGCompanyInfo.City + ', le ' + Format(WorkDate(), 0, 4))
                    {
                    }
                    column(Customer_VATRegistrationNo; RecGCustomer."VAT Registration No.")
                    {
                    }
                    column(SalesHeader_ExternalDocumentNo; RecGSalesHeader."External Document No.")
                    {
                    }
                    column(SalesHeader_SelltoContact; RecGSalesHeader."Sell-to Contact")
                    {
                    }
                    column(RecGSalespersonPurchaser_Name; RecGSalespersonPurchaser.Name)
                    {
                    }
                    column(Transfer_Shipment_Header___No__Caption; Transfer_Shipment_Header___No__CaptionLbl)
                    {
                    }
                    column(DatGDocumentDateCaption; DatGDocumentDateCaptionLbl)
                    {
                    }
                    column(CodGCustomerNoCaption; CodGCustomerNoCaptionLbl)
                    {
                    }
                    column(Customer_VATRegistrationNoCaption; Customer_VATRegistrationNoCaptionLbl)
                    {
                    }
                    column(SalesHeader_ExternalDocumentNoCaption; SalesHeader_ExternalDocumentNoCaptionLbl)
                    {
                    }
                    column(SalesHeader_SelltoContactCaption; SalesHeader_SelltoContactCaptionLbl)
                    {
                    }
                    column(RecGSalespersonPurchaser_NameCaption; RecGSalespersonPurchaser_NameCaptionLbl)
                    {
                    }
                    column(PageLoop_Number; Number)
                    {
                    }
                    dataitem("Transfer Shipment Line"; "Transfer Shipment Line")
                    {
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemLinkReference = "Transfer Shipment Header";
                        DataItemTableView = SORTING("Document No.", "Line No.");
                        column(NoOfCopies; NoOfCopies)
                        {
                        }
                        column(Transfer_Shipment_Header___Sales_Order_No_; "Transfer Shipment Header"."PWD Sales Order No.")
                        {
                        }
                        column(OrderNo; Text003 + ' ' + "Transfer Shipment Header"."PWD Sales Order No." + ' ' + Text004 + ' ' + Format(OrderDate))
                        {
                        }
                        column(Transfer_Shipment_Line__Item_No__; CopyStr("Item No.", 1, 8))
                        {
                        }
                        column(Transfer_Shipment_Line_Description; Description)
                        {
                        }
                        column(Transfer_Shipment_Line_Quantity; Quantity)
                        {
                        }
                        column(Transfer_Shipment_Line__Unit_of_Measure_; "Unit of Measure Code")
                        {
                        }
                        column(Transfer_Shipment_Line__Transfer_Shipment_Line___Line_No__; "Transfer Shipment Line"."Line No.")
                        {
                        }
                        column(Transfer_Shipment_Line__Unit_of_Measure_Caption; Transfer_Shipment_Line__Unit_of_Measure_CaptionLbl)
                        {
                        }
                        column(Transfer_Shipment_Line_QuantityCaption; FieldCaption(Quantity))
                        {
                        }
                        column(Transfer_Shipment_Line_DescriptionCaption; Transfer_Shipment_Line_DescriptionCaptionLbl)
                        {
                        }
                        column(Transfer_Shipment_Line__Item_No__Caption; Transfer_Shipment_Line__Item_No__CaptionLbl)
                        {
                        }
                        column(Transfer_Shipment_Line_Document_No_; "Document No.")
                        {
                        }
                        column(Transfer_Shipment_Line_Item_No_; "Item No.")
                        {
                        }
                        column(Transfer_Shipment_Line_Transfer_from_Code; "Transfer-from Code")
                        {
                        }
                        dataitem("Item Ledger Entry"; "Item Ledger Entry")
                        {
                            DataItemLink = "Document No." = FIELD("Document No."), "Item No." = FIELD("Item No."), "Location Code" = FIELD("Transfer-from Code");
                            DataItemTableView = SORTING("Entry No.") WHERE("Entry Type" = CONST(Transfer));
                            column(ItemLedgerEntry_SerialNo; "Serial No.")
                            {
                            }
                            column(CodGYourItemRef; CodGYourItemRef)
                            {
                            }
                            column(CodGYourPlanNo; CodGYourPlanNo)
                            {
                            }
                            column(ItemLedgerEntry_SerialNoCaption; FieldCaption("Serial No."))
                            {
                            }
                            column(CodGYourItemRefCaption; CodGYourItemRefCaptionLbl)
                            {
                            }
                            column(CodGYourPlanNoCaption; CodGYourPlanNoCaptionLbl)
                            {
                            }
                            column(Item_Ledger_Entry_Entry_No_; "Entry No.")
                            {
                            }
                            column(Item_Ledger_Entry_Document_No_; "Document No.")
                            {
                            }
                            column(Item_Ledger_Entry_Item_No_; "Item No.")
                            {
                            }
                            column(Item_Ledger_Entry_Location_Code; "Location Code")
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                Clear(CodGYourPlanNo);
                                Clear(CodGYourItemRef);

                                if RecGSalesHeader.Get(RecGSalesHeader."Document Type"::Order, "Transfer Shipment Header"."PWD Sales Order No.") then begin
                                    RecGItemCrossReference.Reset();
                                    RecGItemCrossReference.SetRange("Item No.", "Transfer Shipment Line"."Item No.");
                                    RecGItemCrossReference.SetRange("Variant Code", "Transfer Shipment Line"."Variant Code");
                                    RecGItemCrossReference.SetRange("Unit of Measure", "Transfer Shipment Line"."Unit of Measure Code");
                                    RecGItemCrossReference.SetRange("Cross-Reference Type", RecGItemCrossReference."Cross-Reference Type"::Customer);
                                    RecGItemCrossReference.SetRange("Cross-Reference Type No.", RecGSalesHeader."Sell-to Customer No.");

                                    if RecGItemCrossReference.FindFirst() then begin
                                        CodGYourItemRef := RecGItemCrossReference."Cross-Reference No.";
                                        //>>TDL.LPSA.09022015
                                        CodGYourPlanNo := RecGItemCrossReference."PWD Customer Plan No.";
                                        //<<TDL.LPSA.09022015
                                    end;

                                end;

                                if RecGItem.Get("Transfer Shipment Line"."Item No.") then
                                    //>>TDL.LPSA.09022015
                                    if CodGYourPlanNo = '' then
                                        CodGYourPlanNo := RecGItem."PWD Customer Plan No.";
                                //>>TDL.LPSA.09022015
                            end;
                        }

                        trigger OnPreDataItem()
                        begin
                            MoreLines := Find('+');
                            while MoreLines and (Description = '') and ("Item No." = '') and (Quantity = 0) do
                                MoreLines := Next(-1) <> 0;
                            if not MoreLines then
                                CurrReport.Break();
                            SetRange("Line No.", 0, "Line No.");
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                        CopyText := Text000;
                        if IsServiceTier then
                            OutputNo += 1;
                    end;
                    CurrReport.PageNo := 1;
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
                FormatAddr.TransferShptTransferFrom(TransferFromAddr, "Transfer Shipment Header");

                //>>LAP2.02.001
                //STDFormatAddr.TransferShptTransferTo(TransferToAddr,"Transfer Shipment Header");
                LPSAFunctionsMgt.TransferShptFixedTransferTo(TransferToAddr, "Transfer Shipment Header");
                //<<LAP2.02.001

                if not ShipmentMethod.Get("Shipment Method Code") then
                    ShipmentMethod.Init();


                if RecGSalesHeader.Get(RecGSalesHeader."Document Type"::Order, "PWD Sales Order No.") then begin
                    CodGDocumentNo := RecGSalesHeader."No.";
                    OrderDate := RecGSalesHeader."Document Date";
                    CodGCustomerNo := RecGSalesHeader."Sell-to Customer No.";
                    CodFVATRegNo := RecGSalesHeader."VAT Registration No.";
                    CodGExtDocumentNo := RecGSalesHeader."External Document No.";
                    TxtGSellToContact := RecGSalesHeader."Sell-to Contact No.";
                    if RecGCustomer.Get(RecGSalesHeader."Sell-to Customer No.") then;
                    if RecGSalespersonPurchaser.Get(RecGSalesHeader."Salesperson Code") then;
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
        RecGCompanyInfo.Get();
    end;

    var
        RecGCompanyInfo: Record "Company Information";
        RecGCustomer: Record Customer;
        RecGItem: Record Item;
        RecGItemCrossReference: Record "Item Cross Reference";
        RecGSalesHeader: Record "Sales Header";
        RecGSalespersonPurchaser: Record "Salesperson/Purchaser";
        ShipmentMethod: Record "Shipment Method";
        FormatAddr: Codeunit "Format Address";
        LPSAFunctionsMgt: codeunit "PWD LPSA Functions Mgt.";
        MoreLines: Boolean;
        CodFVATRegNo: Code[20];
        CodGCustomerNo: Code[20];
        CodGDocumentNo: Code[20];
        CodGExtDocumentNo: Code[20];
        CodGYourItemRef: Code[20];
        CodGYourPlanNo: Code[100];
        OrderDate: Date;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        OutputNo: Integer;
        CodGCustomerNoCaptionLbl: Label 'Customer No. : ';
        CodGYourItemRefCaptionLbl: Label 'Your Item Ref. =';
        CodGYourPlanNoCaptionLbl: Label 'Your Plan No. =';
        Customer_VATRegistrationNoCaptionLbl: Label 'VAT Registration No. : ';
        DatGDocumentDateCaptionLbl: Label 'Your document date :';
        RecGSalespersonPurchaser_NameCaptionLbl: Label 'Salesperson/Prshaser : ';
        SalesHeader_ExternalDocumentNoCaptionLbl: Label 'External Document No. : ';
        SalesHeader_SelltoContactCaptionLbl: Label 'Your reference : ';
        Text000: Label 'COPY';
        Text002: Label 'Page %1';
        Text003: Label 'Based on order';
        Text004: Label 'of';
        Transfer_Shipment_Header___No__CaptionLbl: Label 'Document No. : ';
        Transfer_Shipment_Line__Item_No__CaptionLbl: Label 'Item No.';
        Transfer_Shipment_Line__Unit_of_Measure_CaptionLbl: Label 'Unit';
        Transfer_Shipment_Line_DescriptionCaptionLbl: Label 'Description';
        CopyText: Text[30];
        TransferFromAddr: array[8] of Text[50];
        TransferToAddr: array[8] of Text[50];
        TxtGSellToContact: Text[50];
}

