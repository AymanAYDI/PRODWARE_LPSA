pageextension 60101 "PWD SalesPrices" extends "Sales Prices"
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
        addafter("Item No.")
        {
            field("PWD Search Description"; "PWD Search Description")
            {
                ApplicationArea = All;
            }
        }
        addafter("VAT Bus. Posting Gr. (Price)")
        {
            field("PWD Fixed Price"; "PWD Fixed Price")
            {
                ApplicationArea = All;
            }
        }
    }
}

