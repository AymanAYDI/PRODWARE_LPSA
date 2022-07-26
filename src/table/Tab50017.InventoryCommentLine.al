table 50017 "PWD Inventory Comment Line"
{
    Caption = 'Inventory Comment Line';
    LookupPageID = "PWD Inventory Comment List";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document Type"; Enum "Inventory Comment Document Type")
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(4; "Date"; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;
        }
        field(5; "Code"; Code[10])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(6; Comment; Text[80])
        {
            Caption = 'Comment';
            DataClassification = CustomerContent;
        }
        field(50000; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            Description = 'TDL.235';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.", "Document Line No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    procedure SetUpNewLine()
    var
        InvtCommentLine: Record "PWD Inventory Comment Line";
    begin
        InvtCommentLine.SetRange("Document Type", "Document Type");
        InvtCommentLine.SetRange("No.", "No.");
        //>>TDL.235
        InvtCommentLine.SETRANGE("Document Line No.", "Document Line No.");
        //<<TDL.235
        InvtCommentLine.SetRange(Date, WorkDate());
        if InvtCommentLine.IsEmpty then
            Date := WorkDate();
    end;

    procedure CopyCommentLines(FromDocumentType: Enum "Inventory Comment Document Type"; FromNumber: Code[20]; ToDocumentType: Enum "Inventory Comment Document Type"; ToNumber: Code[20])
    var
        InvtCommentLine: Record "PWD Inventory Comment Line";
        InvtCommentLine2: Record "PWD Inventory Comment Line";
    begin
        InvtCommentLine.SetRange("Document Type", FromDocumentType);
        InvtCommentLine.SetRange("No.", FromNumber);
        if InvtCommentLine.Find('-') then
            repeat
                InvtCommentLine2 := InvtCommentLine;
                InvtCommentLine2."Document Type" := ToDocumentType;
                InvtCommentLine2."No." := ToNumber;
                InvtCommentLine2.Insert();
            until InvtCommentLine.Next() = 0;
    end;
}
