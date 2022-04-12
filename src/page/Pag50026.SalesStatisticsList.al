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
    SourceTable = "Sales Line Archive";
    SourceTableView = SORTING(Document Type, Document No., Doc. No. Occurrence, Version No., Line No.) WHERE(Document Type=FILTER(Order),Version No.=FILTER(1),Type=FILTER(Item));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                }
                field(CustomerName; TxtGCustomerName)
                {
                    Caption = 'Name';
                }
                field("Document No."; "Document No.")
                {
                }
                field("Line No."; "Line No.")
                {
                }
                field("Version No."; "Version No.")
                {
                    Visible = false;
                }
                field("Doc. No. Occurrence"; "Doc. No. Occurrence")
                {
                    Visible = false;
                }
                field("No."; "No.")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("PWD LPSA Description 1"; "PWD LPSA Description 1")
                {
                }
                field(OutstandingQty; DecGOutstandingQty)
                {
                    Caption = 'Outstanding Quantity';
                }
                field("Unit Price"; "Unit Price")
                {
                }
                field("Unit Cost"; "Unit Cost")
                {
                }
                field("Line Discount %";"Line Discount %")
                {
                }
                field("Line Amount"; "Line Amount")
                {
                }
                field(OrderDate; DatGOrderDate)
                {
                    Caption = 'Order Date';
                }
                field("Promised Delivery Date"; "Promised Delivery Date")
                {
                }
                field("Shipment Date"; "Shipment Date")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        IF RecGCustomer.GET("Sell-to Customer No.") THEN
           TxtGCustomerName := RecGCustomer.Name
        ELSE
           TxtGCustomerName := '';

        RecGSalesHeaderArchive.GET("Document Type","Document No.","Doc. No. Occurrence","Version No.");
        DatGOrderDate := RecGSalesHeaderArchive."Order Date";

        IF RecGSalesLine.GET("Document Type","Document No.","Line No.") THEN
           DecGOutstandingQty := RecGSalesLine."Outstanding Quantity"
        ELSE
           DecGOutstandingQty := 0;
    end;

    var
        TxtGCustomerName: Text[50];
        DecGOutstandingQty: Decimal;
        DatGOrderDate: Date;
        RecGCustomer: Record Customer;
        RecGSalesLine: Record "Sales Line";
        RecGSalesHeaderArchive: Record "Sales Header Archive";
}

