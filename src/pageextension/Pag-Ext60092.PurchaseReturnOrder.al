pageextension 60092 "PWD PurchaseReturnOrder" extends "Purchase Return Order"
{
    // #1..12
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LPSA.TDL
    // LPSA.TDL.09/02/2015 : Add Field 50000, 50001
    // LPSA.TDL.12/08/2015 : Add Field "Vendor Order No."
    // +----------------------------------------------------------------------------------------------------------------+
    layout
    {
        addafter("Buy-from Vendor Name")
        {
            field("PWD Buy-from Vendor Name 2"; "Buy-from Vendor Name 2")
            {
                ApplicationArea = All;
            }
        }
        addafter("Vendor Cr. Memo No.")
        {
            field("PWD Vendor Order No."; "Vendor Order No.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Expected Receipt Date")
        {
            field("PWD Sell-to Customer No."; "Sell-to Customer No.")
            {
                ApplicationArea = All;
            }
        }
    }
}

