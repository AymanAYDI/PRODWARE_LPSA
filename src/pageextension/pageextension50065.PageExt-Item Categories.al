pageextension 50065 pageextension50065 extends "Item Categories"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_PROD01.001: TO 13/12/2011:  No Commande vente identique OF-LOT
    //                                           - Add field "Transmitted Order No."
    // 
    // 
    // ------------------------------------------------------------------------------------------------------------------
    layout
    {
        addafter("Control 14")
        {
            field("Transmitted Order No."; "Transmitted Order No.")
            {
                ApplicationArea = All;
            }
        }
    }
}

