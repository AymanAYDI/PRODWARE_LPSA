page 50014 "Archived Lines Order Version 1"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 17/10/2017 : DEMANDES DIVERSES
    //                   - New page

    Caption = 'Archived Lines Order Version 1';
    Editable = false;
    PageType = List;
    SourceTable = "Sales Line Archive";
    SourceTableView = SORTING(Document Type, Document No., Doc. No. Occurrence, Version No., Line No.) WHERE(Document Type=FILTER(Order),Version No.=FILTER(1));

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
                field("Unit Price"; "Unit Price")
                {
                }
                field("Unit Cost (LCY)";"Unit Cost (LCY)")
                {
                }
                field("VAT %";"VAT %")
                {
                }
                field("Quantity Disc. %";"Quantity Disc. %")
                {
                }
                field("Line Discount %";"Line Discount %")
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
                field("Allow Invoice Disc."; "Allow Invoice Disc.")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
                field("Currency Code"; "Currency Code")
                {
                }
                field("Line Amount"; "Line Amount")
                {
                }
                field("Version No."; "Version No.")
                {
                }
                field("Requested Delivery Date"; "Requested Delivery Date")
                {
                }
                field("Promised Delivery Date"; "Promised Delivery Date")
                {
                }
                field("Planned Delivery Date"; "Planned Delivery Date")
                {
                }
                field("Planned Shipment Date"; "Planned Shipment Date")
                {
                }
                field("PWD LPSA Description 1"; "PWD LPSA Description 1")
                {
                }
                field("PWD LPSA Description 2"; "PWD LPSA Description 2")
                {
                }
            }
        }
    }

    actions
    {
    }
}

