pageextension 60037 "PWD PostedPurchaseReceipts" extends "Posted Purchase Receipts"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // TDL.LPSA.29.06.15:AFR 29/06/15: Add Field "Order No."
    layout
    {
        addafter("Order Address Code")
        {
            field("N° de Commande"; "Order No.")
            {
                Caption = 'N° de Commande';
                ApplicationArea = All;
            }
        }
    }
}

