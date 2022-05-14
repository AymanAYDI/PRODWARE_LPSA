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
        field(13; Status; Enum "PWD Status Buffer")
        {
            Caption = 'Status';
            Editable = false;
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
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(21; "Document No."; Text[30])
        {
            Caption = 'Document No.';
            Editable = false;
        }
        field(22; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)';
            OptionMembers = " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)";
        }
        field(23; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(24; "Unit Price"; Text[15])
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
        }
        field(25; Quantity; Text[15])
        {
            Caption = 'Quantity';
        }
        field(26; "Line Amount"; Text[15])
        {
            AutoFormatType = 1;
            Caption = 'Line Amount';
        }
        field(27; "Document Line No."; Text[20])
        {
            Caption = 'Document Line No.';
            Editable = false;
        }
        field(28; "Variant Code"; Text[30])
        {
            Caption = 'Variant Code';
        }
        field(29; "Unit of Measure"; Text[20])
        {
            Caption = 'Unit of Measure';
        }
        field(30; "Initial Quantity (Base)"; Text[15])
        {
            Caption = 'Initial Quantity (Base)';
        }
        field(40; "Qty. to Ship (Base)"; Text[15])
        {
            Caption = 'Qty. to Ship (Base)';
        }
        field(41; "Expiration Date"; Text[10])
        {
            Caption = 'Expiration Date';
        }
        field(42; "Serial No."; Text[30])
        {
            Caption = 'Serial No.';
        }
        field(43; "Lot No."; Text[30])
        {
            Caption = 'Lot No.';
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

