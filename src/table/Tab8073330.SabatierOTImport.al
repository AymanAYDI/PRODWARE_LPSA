table 8073330 "PWD Sabatier OT Import"
{
    DataClassification = CustomerContent;
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // //>>ProdConnect1.5
    // FE_ProdConnect.001:GR 22/03/2011  Connector integration
    //                                   - Create Object
    // 
    // +----------------------------------------------------------------------------------------------------------------+


    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(9; "Error Blob"; BLOB)
        {
            Caption = 'Error Blob';
            SubType = Memo;
            DataClassification = CustomerContent;
        }
        field(10; "Connector Values Entry No."; Integer)
        {
            Caption = 'Connector Values Entry No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(11; "Partner Code"; Code[20])
        {
            Caption = 'Partner Code';
            Editable = false;
            TableRelation = "PWD Partner Connector".Code;
            DataClassification = CustomerContent;
        }
        field(12; "Message Code"; Code[20])
        {
            Caption = 'Message Code';
            Editable = false;
            TableRelation = "PWD Connector Messages".Code;
            DataClassification = CustomerContent;
        }
        field(13; Status; Enum "PWD Status Buffer")
        {
            Caption = 'Status';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14; Processed; Boolean)
        {
            Caption = 'Processed';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(15; "Processed Date"; DateTime)
        {
            Caption = 'Processed Date';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(16; "Error Message"; Text[250])
        {
            Caption = 'Error Message';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(17; "Action"; Option)
        {
            Caption = 'Action';
            OptionCaption = 'Skip,Insert,Modify,Delete';
            OptionMembers = Skip,Insert,Modify,Delete;
            DataClassification = CustomerContent;
        }
        field(18; "RecordID Created"; RecordID)
        {
            Caption = 'RecordID Created';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(19; "Creation Date"; DateTime)
        {
            Caption = 'Creation Date';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(20; IDOT; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(21; RefOT; Text[150])
        {
            DataClassification = CustomerContent;
        }
        field(22; IDMission; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(23; RefMission; Text[150])
        {
            DataClassification = CustomerContent;
        }
        field(24; IDEtatOT; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(25; DateHeureDebut; Text[20])
        {
            DataClassification = CustomerContent;
        }
        field(26; Commentaire; Text[200])
        {
            DataClassification = CustomerContent;
        }
        field(27; Latitude; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(28; Longitude; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(29; Fix; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(30; NbSat; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(31; Vitesse; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(32; Cap; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(33; Contact; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(34; TOR; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(35; ANA1; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(36; ANA2; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(37; ANA3; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(38; ANA4; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(39; CodeChauffeur; Text[30])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

