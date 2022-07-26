table 8073305 "PWD Sales Line Buffer"
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

    Caption = 'Sales Line Buffer';
    DataClassification = CustomerContent;

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
            Editable = false;
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
        field(20; "Document Type"; Option)
        {
            Caption = 'Document Type';
            Editable = false;
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
            DataClassification = CustomerContent;
        }
        field(21; "Document No."; Text[30])
        {
            Caption = 'Document No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(22; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)';
            OptionMembers = " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)";
            DataClassification = CustomerContent;
        }
        field(23; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(24; "Unit Price"; Text[15])
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
            DataClassification = CustomerContent;
        }
        field(25; Quantity; Text[15])
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
        }
        field(26; "Line Amount"; Text[15])
        {
            AutoFormatType = 1;
            Caption = 'Line Amount';
            DataClassification = CustomerContent;
        }
        field(27; "Document Line No."; Text[20])
        {
            Caption = 'Document Line No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(28; "Variant Code"; Text[30])
        {
            Caption = 'Variant Code';
            DataClassification = CustomerContent;
        }
        field(29; "Unit of Measure"; Text[20])
        {
            Caption = 'Unit of Measure';
            DataClassification = CustomerContent;
        }
        field(30; "Initial Quantity (Base)"; Text[15])
        {
            Caption = 'Initial Quantity (Base)';
            DataClassification = CustomerContent;
        }
        field(40; "Qty. to Ship (Base)"; Text[15])
        {
            Caption = 'Qty. to Ship (Base)';
            DataClassification = CustomerContent;
        }
        field(41; "Expiration Date"; Text[10])
        {
            Caption = 'Expiration Date';
            DataClassification = CustomerContent;
        }
        field(42; "Serial No."; Text[30])
        {
            Caption = 'Serial No.';
            DataClassification = CustomerContent;
        }
        field(43; "Lot No."; Text[30])
        {
            Caption = 'Lot No.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Document Type", "Document No.")
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
        CduLBufferManagement.FctDeleteBufferLine(DATABASE::"PWD PEB Sales Line Buffer", "Entry No.");
        CduLBufferManagement.FctDeleteBufferLine(DATABASE::"PWD WMS Sales Line Buffer", "Entry No.");
    end;
}

