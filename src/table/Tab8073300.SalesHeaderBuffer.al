table 8073300 "PWD Sales Header Buffer"
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

    Caption = 'Sales Header Buffer';
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
            OptionCaption = 'Skip,Insert,Modify,Delete';
            OptionMembers = Skip,Insert,Modify,Delete;
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                RecLSalesCommentLineBuffer: Record "PWD Sales Comment Line Buffer";
                RecLSalesLineBuffer: Record "PWD Sales Line Buffer";
            begin
                RecLSalesLineBuffer.SetCurrentKey("Document Type", "Document No.");
                RecLSalesLineBuffer.SetRange("Document Type", "Document Type");
                RecLSalesLineBuffer.SetRange("Document No.", "Document No.");
                RecLSalesLineBuffer.ModifyAll(Action, Action);

                RecLSalesCommentLineBuffer.SetCurrentKey("Document Type", "Document No.", "Document Line No.");
                RecLSalesCommentLineBuffer.SetRange("Document Type", "Document Type");
                RecLSalesCommentLineBuffer.SetRange("Document No.", "Document No.");
                RecLSalesCommentLineBuffer.ModifyAll(Action, Action);
            end;
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
        field(22; "Sell-to Customer No."; Text[30])
        {
            Caption = 'Sell-to Customer No.';
            DataClassification = CustomerContent;
        }
        field(23; "External Document No."; Text[30])
        {
            Caption = 'External Document No.';
            DataClassification = CustomerContent;
        }
        field(24; "Posting Date"; Text[10])
        {
            Caption = 'Posting Date';
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
        RecLSalesCommentLineBuffer: Record "PWD Sales Comment Line Buffer";
        RecLSalesLineBuffer: Record "PWD Sales Line Buffer";
        CduLBufferManagement: Codeunit "PWD Buffer Management";
    begin
        CduLBufferManagement.FctDeleteBufferLine(DATABASE::"PWD PEB Sales Header Buffer", "Entry No.");
        CduLBufferManagement.FctDeleteBufferLine(DATABASE::"PWD WMS Sales Header Buffer", "Entry No.");

        RecLSalesLineBuffer.SetCurrentKey("Document Type", "Document No.");
        RecLSalesLineBuffer.SetRange("Document Type", "Document Type");
        RecLSalesLineBuffer.SetRange("Document No.", "Document No.");
        RecLSalesLineBuffer.DeleteAll(true);

        RecLSalesCommentLineBuffer.SetCurrentKey("Document Type", "Document No.", "Document Line No.");
        RecLSalesCommentLineBuffer.SetRange("Document Type", "Document Type");
        RecLSalesCommentLineBuffer.SetRange("Document No.", "Document No.");
        RecLSalesCommentLineBuffer.DeleteAll(true);
    end;
}

