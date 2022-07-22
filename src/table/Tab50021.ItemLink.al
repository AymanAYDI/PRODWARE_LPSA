table 50021 "PWD Item Link"
{
    Caption = 'Item Link';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Integer)
        {
            Caption = 'No.';
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; URL; Text[250])
        {
            Caption = 'URL';
            DataClassification = ToBeClassified;
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = ToBeClassified;
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
}
