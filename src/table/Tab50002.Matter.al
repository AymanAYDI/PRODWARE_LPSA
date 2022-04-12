table 50002 "PWD Matter"
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

    Caption = 'Matter';
    LookupPageID = "PWD Matter List";

    fields
    {
        field(1; "Option Matter"; Option)
        {
            Caption = 'Option';
            OptionCaption = 'Stone,Preparage,Lifted and ellipses,Semi-finished';
            OptionMembers = Stone,Preparage,"Lifted and ellipses","Semi-finished";
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Option Matter", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

