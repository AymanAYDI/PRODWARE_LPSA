table 50013 "PWD Tools Instructions"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 28/06/2017 : FICHE SUIVEUSE - PP 1
    //                   - new Table

    Caption = 'Tools Instructions';
    DataCaptionFields = Type, "No.", Description, Criteria;
    DrillDownPageID = "PWD Tools Instructions Setup";
    LookupPageID = "PWD Tools Instructions Setup";
    DataClassification = CustomerContent;

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Method,Quality,Plan,Zone,Targeted dimension';
            OptionMembers = Method,Quality,Plan,Zone,"Targeted dimension";
            DataClassification = CustomerContent;
        }
        field(4; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(5; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(6; Criteria; Text[50])
        {
            Caption = 'Criteria';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; Type, "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Description, Criteria)
        {
        }
    }
}

