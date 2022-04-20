pageextension 50045 pageextension50045 extends "Sales Quote Archive Subform"
{
    // #1..10
    // 
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
        addafter("Control 16")
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

