pageextension 60006 "PWD VendorCard" extends "Vendor Card"
{
    // #1..64
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_ACH03.001: NI 22/11/2011:  Montant Minimun de commande
    //                                           - Display field 50000 "Order Min. Amount" on Tab [GENERAL]
    // ------------------------------------------------------------------------------------------------------------------
    layout
    {
        addafter("Primary Contact No.")
        {
            field("PWD Order Min. Amount"; "PWD Order Min. Amount")
            {
                ApplicationArea = All;
            }
        }
    }
}

