pageextension 60038 "PWD PostedPurchaseInvoices" extends "Posted Purchase Invoices"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // TDL.LPSA.29.06.15:AFR 29/06/15: Add Field "Order No."
    layout
    {
        addafter("Buy-from Vendor Name")
        {
            field("PWD Vendor Invoice No."; "Vendor Invoice No.")
            {
                ApplicationArea = All;
            }
            field("PWD Order No."; "Order No.")
            {
                Caption = 'N° commande';
                ApplicationArea = All;
            }
        }
    }
}

