pageextension 50088 pageextension50088 extends "Purchase Return Order Subform"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_ART02.001: NI 23/11/2011:  Désignation article 120 caracteres
    //                                           - Display field 50004..50005
    // ------------------------------------------------------------------------------------------------------------------
    layout
    {
        addafter("Control 6")
        {
            field("LPSA Description 1"; "LPSA Description 1")
            {
                ApplicationArea = All;
            }
            field("LPSA Description 2"; "LPSA Description 2")
            {
                ApplicationArea = All;
            }
        }
    }
}

