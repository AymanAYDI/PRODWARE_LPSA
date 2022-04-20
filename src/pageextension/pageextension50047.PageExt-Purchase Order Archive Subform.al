pageextension 50047 pageextension50047 extends "Purchase Order Archive Subform"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // //>>LAP1.00
    // FE_LAPIERRETTE_ART02.001: NI 23/11/2011:  Désignation article 120 caracteres
    //                                           - Add field 50004..50005
    // ------------------------------------------------------------------------------------------------------------------
    layout
    {
        addafter("Control 14")
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

