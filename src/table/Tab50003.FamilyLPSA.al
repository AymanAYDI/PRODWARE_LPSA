table 50003 "PWD Family LPSA"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_ART01.001: TO 07/12/2011:  Configurateur article
    //                                           - Create Table
    // 
    // ------------------------------------------------------------------------------------------------------------------

    Caption = 'Family LPSA';
    DrillDownPageID = "PWD Family LPSA List";
    LookupPageID = "PWD Family LPSA List";

    fields
    {
        field(1; "Code"; Code[2])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(3; Description; Text[30])
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
        key(Key2; Description)
        {
        }
    }

    fieldgroups
    {
    }
}

