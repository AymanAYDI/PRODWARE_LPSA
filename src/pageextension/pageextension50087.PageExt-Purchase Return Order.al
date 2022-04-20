pageextension 50087 pageextension50087 extends "Purchase Return Order"
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
        addafter("Control 6")
        {
            field("Buy-from Vendor Name 2"; "Buy-from Vendor Name 2")
            {
                ApplicationArea = All;
            }
        }
        addafter("Control 14")
        {
            field("Vendor Order No."; "Vendor Order No.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Control 96")
        {
            field("Sell-to Customer No."; "Sell-to Customer No.")
            {
                ApplicationArea = All;
            }
        }
    }
}

