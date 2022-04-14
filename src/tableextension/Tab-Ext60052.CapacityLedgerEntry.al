tableextension 60052 "PWD CapacityLedgerEntry" extends "Capacity Ledger Entry"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_PROD02.001: NI 28/11/2011:  Commentaire sur feuille production
    //                                           - Add field 50000
    // 
    // //>>LAP2.00
    // FE_LAPIERRETTE_PRO06.001: TO 19/01/2012: Bilan production par commande
    //                                         - Add key: Item No.,Prod. Order No.,Operation No.,Type,No.
    // 
    // ------------------------------------------------------------------------------------------------------------------
    fields
    {
        field(50000; "PWD Quartis Comment"; Code[5])
        {
            Caption = 'Quartis Comment';
            Description = 'LAP1.00';
            TableRelation = "PWD Quartis Comment".Code;
        }
    }
    keys
    {

        key(Key50000; "Item No.", "Order Type", "Order No.", "Operation No.", Type, "No.")
        {
            SumIndexFields = "Output Quantity", "Scrap Quantity", "Setup Time", "Run Time";
        }
        key(Key50001; "No.")
        {

        }
    }
}

