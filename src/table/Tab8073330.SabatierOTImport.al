table 8073330 "PWD Sabatier OT Import"
{
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
        }
        field(9; "Error Blob"; BLOB)
        {
            Caption = 'Error Blob';
            SubType = Memo;
        }
        field(10; "Connector Values Entry No."; Integer)
        {
            Caption = 'Connector Values Entry No.';
            Editable = false;
        }
        field(11; "Partner Code"; Code[20])
        {
            Caption = 'Partner Code';
            Editable = false;
            TableRelation = "PWD Partner Connector".Code;
        }
        field(12; "Message Code"; Code[20])
        {
            Caption = 'Message Code';
            Editable = false;
            TableRelation = "PWD Connector Messages".Code;
        }
        field(13; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = ' ,Inserted,Modified,Deleted';
            OptionMembers = " ",Inserted,Modified,Deleted;
        }
        field(14; Processed; Boolean)
        {
            Caption = 'Processed';
            Editable = false;
        }
        field(15; "Processed Date"; DateTime)
        {
            Caption = 'Processed Date';
            Editable = false;
        }
        field(16; "Error Message"; Text[250])
        {
            Caption = 'Error Message';
            Editable = false;
        }
        field(17; "Action"; Option)
        {
            Caption = 'Action';
            OptionCaption = 'Skip,Insert,Modify,Delete';
            OptionMembers = Skip,Insert,Modify,Delete;
        }
        field(18; "RecordID Created"; RecordID)
        {
            Caption = 'RecordID Created';
            Editable = false;
        }
        field(19; "Creation Date"; DateTime)
        {
            Caption = 'Creation Date';
            Editable = false;
        }
        field(20; IDOT; Text[30])
        {
        }
        field(21; RefOT; Text[150])
        {
        }
        field(22; IDMission; Text[30])
        {
        }
        field(23; RefMission; Text[150])
        {
        }
        field(24; IDEtatOT; Text[30])
        {
        }
        field(25; DateHeureDebut; Text[20])
        {
        }
        field(26; Commentaire; Text[200])
        {
        }
        field(27; Latitude; Text[30])
        {
        }
        field(28; Longitude; Text[30])
        {
        }
        field(29; Fix; Text[30])
        {
        }
        field(30; NbSat; Text[30])
        {
        }
        field(31; Vitesse; Text[30])
        {
        }
        field(32; Cap; Text[30])
        {
        }
        field(33; Contact; Text[30])
        {
        }
        field(34; TOR; Text[30])
        {
        }
        field(35; ANA1; Text[30])
        {
        }
        field(36; ANA2; Text[30])
        {
        }
        field(37; ANA3; Text[30])
        {
        }
        field(38; ANA4; Text[30])
        {
        }
        field(39; CodeChauffeur; Text[30])
        {
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

