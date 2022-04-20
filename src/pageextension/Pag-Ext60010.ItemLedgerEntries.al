pageextension 60010 "PWD ItemLedgerEntries" extends "Item Ledger Entries"
{
    // +----------------------------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                                         |
    // | www.prodware.fr                                                                                                                  |
    // +----------------------------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.05
    // FE_LAPIERRETTE_PRO12.001: GR 09/10/2012: Non Conformite
    //                                          - Add Field
    //                                            NC
    // 
    // +----------------------------------------------------------------------------------------------------------------------------------+
    layout
    {
        addafter("Lot No.")
        {
            field("PWD NC"; "PWD NC")
            {
                ApplicationArea = All;
            }
        }
        addafter("Job No.")
        {
            field("Désignation LPSA1"; "PWD Designation LPSA1")
            {
                ApplicationArea = All;
            }
            field("PWD Nom Client"; "PWD Nom Client")
            {
                ApplicationArea = All;
            }
            field("PWD Nom Fournisseur"; "PWD Nom Fournisseur")
            {
                ApplicationArea = All;
            }
        }
        addafter("Job Task No.")
        {
            field("PWD External Document No."; "External Document No.")
            {
                ApplicationArea = All;
            }
            field("PWD Cross-Reference No."; "Cross-Reference No.")
            {
                ApplicationArea = All;
            }
        }
    }
}

