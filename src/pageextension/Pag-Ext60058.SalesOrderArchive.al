pageextension 60058 "PWD SalesOrderArchive" extends "Sales Order Archive"
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
        addafter(Status)
        {
            field("PWD Confirmed"; "PWD Confirmed")
            {
                ApplicationArea = All;
            }
            field("PWD Planned"; "PWD Planned")
            {
                ApplicationArea = All;
            }
        }
    }
}

