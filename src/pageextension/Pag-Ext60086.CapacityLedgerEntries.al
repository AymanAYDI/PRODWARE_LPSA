pageextension 60086 "PWD CapacityLedgerEntries" extends "Capacity Ledger Entries"
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
        addafter("Entry No.")
        {
            field("PWD Quartis Comment"; "PWD Quartis Comment")
            {
                ApplicationArea = All;
            }
        }
    }
}

