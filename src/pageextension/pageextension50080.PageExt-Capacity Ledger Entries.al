pageextension 50080 pageextension50080 extends "Capacity Ledger Entries"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_PROD02.001: NI 28/11/2011:  Commentaire sur feuille production
    //                                           - Display field 50000
    // 
    // ------------------------------------------------------------------------------------------------------------------
    layout
    {
        addafter("Control 56")
        {
            field("Quartis Comment"; "Quartis Comment")
            {
                ApplicationArea = All;
            }
        }
    }
}

