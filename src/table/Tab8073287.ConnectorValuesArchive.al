table 8073287 "PWD Connector Values Archive"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect.1.00
    // 
    // FE_ProdConnect.001:GR 22/03/2011  Connector integration
    //                                   - Create Object
    // +----------------------------------------------------------------------------------------------------------------+

    Caption = 'Values From Connector Archive';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(2; "Partner Code"; Code[20])
        {
            Caption = 'Partner Code';
            TableRelation = "PWD Partner Connector".Code;
            DataClassification = CustomerContent;
        }
        field(3; "File Name"; Text[250])
        {
            Caption = 'File Name';
            DataClassification = CustomerContent;
        }
        field(4; Function; Code[30])
        {
            Caption = 'Function';
            DataClassification = CustomerContent;
        }
        field(5; Direction; Option)
        {
            Caption = 'Direction';
            OptionCaption = 'Import,Export';
            OptionMembers = Import,Export;
            DataClassification = CustomerContent;
        }
        field(6; "File format"; Option)
        {
            Caption = 'File format';
            OptionCaption = 'Xml,with separator,File Position';
            OptionMembers = Xml,"with separator","File Position";
            DataClassification = CustomerContent;
        }
        field(7; Separator; Text[1])
        {
            Caption = 'Separator';
            DataClassification = CustomerContent;
        }
        field(8; "Blob"; BLOB)
        {
            Caption = 'Blob';
            DataClassification = CustomerContent;
        }
        field(9; "Linked Entry No."; Integer)
        {
            Caption = 'Linked Entry No.';
            DataClassification = CustomerContent;
        }
        field(10; "Message Code"; Code[20])
        {
            Caption = 'Message Code';
            TableRelation = "PWD Connector Messages".Code;
            DataClassification = CustomerContent;
        }
        field(11; Succes; Boolean)
        {
            Caption = 'Succes';
            DataClassification = CustomerContent;
        }
        field(12; "Communication Mode"; Option)
        {
            Caption = 'Communication Mode';
            OptionCaption = ' ,MSMQ,File,Web Service';
            OptionMembers = " ",MSMQ,File,"Web Service";
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

