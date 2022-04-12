page 50019 "PWD Archive Sales Lines"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Delivery                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>TDL.LPSA
    // 19/01/2015 : Form Creation
    // 
    // +----------------------------------------------------------------------------------------------------------------+

    PageType = List;
    SourceTable = "Sales Line Archive";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; "Document Type")
                {
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Line No."; "Line No.")
                {
                }
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Posting Group"; "Posting Group")
                {
                }
                field("Quantity Disc. Code"; "Quantity Disc. Code")
                {
                }
                field("Shipment Date"; "Shipment Date")
                {
                }
                field(Description; Description)
                {
                }
                field("Description 2"; "Description 2")
                {
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Outstanding Quantity"; "Outstanding Quantity")
                {
                }
                field("Qty. to Invoice"; "Qty. to Invoice")
                {
                }
                field("Qty. to Ship"; "Qty. to Ship")
                {
                }
                field("Unit Price"; "Unit Price")
                {
                }
                field("Unit Cost (LCY)"; "Unit Cost (LCY)")
                {
                }
                field("VAT %"; "VAT %")
                {
                }
                field("Quantity Disc. %"; "Quantity Disc. %")
                {
                }
                field("Line Discount %"; "Line Discount %")
                {
                }
                field("Line Discount Amount"; "Line Discount Amount")
                {
                }
                field(Amount; Amount)
                {
                }
                field("Amount Including VAT"; "Amount Including VAT")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
                field("Quantity Shipped"; "Quantity Shipped")
                {
                }
                field("Quantity Invoiced"; "Quantity Invoiced")
                {
                }
                field("Shipment No."; "Shipment No.")
                {
                }
                field("Shipment Line No."; "Shipment Line No.")
                {
                }
                field("Line Amount"; "Line Amount")
                {
                }
                field("Quantity (Base)"; "Quantity (Base)")
                {
                }
                field("PWD LPSA Description 1"; "PWD LPSA Description 1")
                {
                }
                field("PWD LPSA Description 2"; "PWD LPSA Description 2")
                {
                }
                field("Scrap Quantity"; "Scrap Quantity")
                {
                }
                field("Requested Delivery Date"; "Requested Delivery Date")
                {
                }
                field("Promised Delivery Date"; "Promised Delivery Date")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action1102601000>")
            {
                Caption = 'O&rder';
                action("<Action1102601009>")
                {
                    Caption = 'S&hipments';
                    RunObject = Page "Posted Sales Shipments";
                    RunPageLink = Order No.=FIELD(Document No.);
                    RunPageView = SORTING(Order No.);
                }
                action("<Action1102601010>")
                {
                    Caption = 'Invoices';
                    Image = Invoice;
                    RunObject = Page "Posted Sales Invoices";
                                    RunPageLink = Order No.=FIELD(Document No.);
                    RunPageView = SORTING(Order No.);
                }
            }
        }
    }
}

