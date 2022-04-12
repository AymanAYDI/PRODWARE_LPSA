table 8073310 "PWD Sales Comment Line Buffer"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.50
    // WMS-FEMOT.001:GR 29/06/2011  Connector management
    //                                   - Create Object
    // +----------------------------------------------------------------------------------------------------------------+

    Caption = 'Sales Comment Line Buffer';

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
            Editable = false;
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
        field(20; "Document Type"; Option)
        {
            Caption = 'Document Type';
            Editable = false;
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Shipment,Posted Invoice,Posted Credit Memo,Posted Return Receipt';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Shipment,"Posted Invoice","Posted Credit Memo","Posted Return Receipt";
        }
        field(21; "Document No."; Text[30])
        {
            Caption = 'Document No.';
            Editable = false;
        }
        field(22; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            Editable = false;
        }
        field(23; "Date"; Text[10])
        {
            Caption = 'Date';
        }
        field(24; "Code"; Text[30])
        {
            Caption = 'Code';
        }
        field(25; Comment; Text[80])
        {
            Caption = 'Comment';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Document Type", "Document No.", "Document Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        CduLBufferManagement: Codeunit "PWD Buffer Management";
    begin
        CduLBufferManagement.FctDeleteBufferLine(DATABASE::"PWD PEB Sales Comm Line Buffer", "Entry No.");
        CduLBufferManagement.FctDeleteBufferLine(DATABASE::"PWD WMS Sales Comm Line Buffer", "Entry No.");
    end;
}

