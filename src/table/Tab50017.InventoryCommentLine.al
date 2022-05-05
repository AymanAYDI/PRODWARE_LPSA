table 50017 "PWD Inventory Comment Line"
{
    Caption = 'Inventory Comment Line';
    LookupPageID = "Inventory Comment List";

    fields
    {
        field(1; "Document Type"; Enum "Inventory Comment Document Type")
        {
            Caption = 'Document Type';
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Date"; Date)
        {
            Caption = 'Date';
        }
        field(5; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(6; Comment; Text[80])
        {
            Caption = 'Comment';
        }
        field(50000; "PWD Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            Description = 'TDL.235';
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.", "PWD Document Line No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    procedure SetUpNewLine()
    var
        InvtCommentLine: Record "Inventory Comment Line";
    begin
        InvtCommentLine.SetRange("Document Type", "Document Type");
        InvtCommentLine.SetRange("No.", "No.");
        //>>TDL.235
        InvtCommentLine.SETRANGE("PWD Document Line No.", "PWD Document Line No.");
        //<<TDL.235
        InvtCommentLine.SetRange(Date, WorkDate());
        if InvtCommentLine.IsEmpty then
            Date := WorkDate();
    end;

    procedure CopyCommentLines(FromDocumentType: Enum "Inventory Comment Document Type"; FromNumber: Code[20]; ToDocumentType: Enum "Inventory Comment Document Type"; ToNumber: Code[20])
    var
        InvtCommentLine: Record "Inventory Comment Line";
        InvtCommentLine2: Record "Inventory Comment Line";
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
