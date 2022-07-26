table 8073286 "PWD Connector Values"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect.1.00
    // FE_ProdConnect.001:GR 22/03/2011  Connector integration
    //                                   - Create Object
    // 
    // //>>ProdConnect1.6
    // OSYS-Int001.001:GR 25/10/2011   Connector integration
    //                                 - Add field : "Auto-Post Document"
    // 
    // +----------------------------------------------------------------------------------------------------------------+

    Caption = 'Values From Connector';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            NotBlank = true;
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
        field(12; "Communication Mode"; Option)
        {
            Caption = 'Communication Mode';
            OptionCaption = ' ,MSMQ,File,Web Service';
            OptionMembers = " ",MSMQ,File,"Web Service";
            DataClassification = CustomerContent;
        }
        field(13; "Auto-Post Document"; Boolean)
        {
            Caption = 'Auto-Post Document';
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

