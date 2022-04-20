pageextension 50042 pageextension50042 extends "Sales Order Archive"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_VTE06.001: NI 23/11/2011:  Statut Commande vente
    //                                           - Display field 50000..50001 on Tab [GENERAL]
    // ------------------------------------------------------------------------------------------------------------------
    layout
    {
        addafter("Control 34")
        {
            field(Confirmed; Confirmed)
            {
                ApplicationArea = All;
            }
            field(Planned; Planned)
            {
                ApplicationArea = All;
            }
        }
    }
}

