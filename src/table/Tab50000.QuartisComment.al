table 50000 "PWD Quartis Comment"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_PROD02.001: NI 28/11/2011:  Commentaire sur feuille production
    //                                           - Create table
    // 
    // ------------------------------------------------------------------------------------------------------------------

    Caption = 'Quartis Comment';
    DrillDownPageID = "PWD Quartis Comment";
    LookupPageID = "PWD Quartis Comment";

    fields
    {
        field(1; "Code"; Code[5])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[20])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

