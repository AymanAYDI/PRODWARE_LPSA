table 50004 "PWD SubFamily LPSA"
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

    Caption = 'Subfamily LPSA';
    DrillDownPageID = "PWD Subfamily LPSA List";
    LookupPageID = "PWD Subfamily LPSA List";

    fields
    {
        field(1; "Family Code"; Code[2])
        {
            Caption = 'Family Code';
            TableRelation = "PWD Family LPSA".Code;
        }
        field(2; "Code"; Code[3])
        {
            Caption = 'Code';
        }
        field(3; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(4; Number; Integer)
        {
            Caption = 'Number';
        }
        field(5; NumberF; Integer)
        {
            Caption = 'NumberF';
        }
    }

    keys
    {
        key(Key1; "Family Code", "Code")
        {
            Clustered = true;
        }
        key(Key2; Description)
        {
        }
        key(Key3; Number)
        {
        }
    }

    fieldgroups
    {
    }
}

