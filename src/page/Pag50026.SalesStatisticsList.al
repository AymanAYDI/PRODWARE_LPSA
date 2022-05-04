page 50026 "PWD Sales Statistics List"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.13
    // P24578_002: RO : 21/11/2017 : Nouvelles demandes Cf. Echange Mail fin octobre 2017
    //                   - new Page

    Caption = 'Sales Statistics List';
    Editable = false;
    PageType = List;
    UsageCategory = none;
    SourceTable = "Sales Line Archive";
    SourceTableView = SORTING("Document Type", "Document No.", "Doc. No. Occurrence", "Version No.", "Line No.") WHERE("Document Type" = FILTER(Order), "Version No." = FILTER(1), Type = FILTER(Item));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field(CustomerName; TxtGCustomerName)
                {
                    Caption = 'Name';
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("Version No."; Rec."Version No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Doc. No. Occurrence"; Rec."Doc. No. Occurrence")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;
                }
                field("PWD LPSA Description 1"; Rec."PWD LPSA Description 1")
                {
                    ApplicationArea = All;
                }
                field(OutstandingQty; DecGOutstandingQty)
                {
                    Caption = 'Outstanding Quantity';
                    ApplicationArea = All;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = All;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = All;
                }
                field(OrderDate; DatGOrderDate)
                {
                    Caption = 'Order Date';
                    ApplicationArea = All;
                }
                field("Promised Delivery Date"; Rec."Promised Delivery Date")
                {
                    ApplicationArea = All;
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        IF RecGCustomer.GET(Rec."Sell-to Customer No.") THEN
            TxtGCustomerName := RecGCustomer.Name
        ELSE
            TxtGCustomerName := '';

        RecGSalesHeaderArchive.GET(Rec."Document Type", Rec."Document No.", Rec."Doc. No. Occurrence", Rec."Version No.");
        DatGOrderDate := RecGSalesHeaderArchive."Order Date";

        IF RecGSalesLine.GET(Rec."Document Type", Rec."Document No.", Rec."Line No.") THEN
            DecGOutstandingQty := RecGSalesLine."Outstanding Quantity"
        ELSE
            DecGOutstandingQty := 0;
    end;

    var
        RecGCustomer: Record Customer;
        RecGSalesHeaderArchive: Record "Sales Header Archive";
        RecGSalesLine: Record "Sales Line";
        DatGOrderDate: Date;
        DecGOutstandingQty: Decimal;
        TxtGCustomerName: Text[50];
}

