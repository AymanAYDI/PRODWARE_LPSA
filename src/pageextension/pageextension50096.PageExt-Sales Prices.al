pageextension 50096 pageextension50096 extends "Sales Prices"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_VTE03.001: NI 23/11/2011:  Prix de vente forfaitaire
    //                                           - Display field 50000
    // 
    // TDL.LPSA.09.02.2015: ONSITE 09/02/2015: Modification
    //                                           - Add Item Search Description
    // 
    // ------------------------------------------------------------------------------------------------------------------
    layout
    {
        addafter("Control 4")
        {
            field("Search Description"; "Search Description")
            {
                ApplicationArea = All;
            }
        }
        addafter("Control 46")
        {
            field("Fixed Price"; "Fixed Price")
            {
                ApplicationArea = All;
            }
        }
    }
}

