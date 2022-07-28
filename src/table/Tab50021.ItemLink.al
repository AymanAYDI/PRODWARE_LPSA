table 50021 "PWD Item Link"
{
    Caption = 'Item Link';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; BigInteger)
        {
            Caption = 'No.';
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }
        field(2; URL; Text[250])
        {
            Caption = 'URL';
            DataClassification = CustomerContent;
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(5; "User Id"; Code[50])
        {
            Caption = 'User Id';
            DataClassification = CustomerContent;
        }
        field(6; "Creation Date"; DateTime)
        {
            Caption = 'Creation Date';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        Rec."User Id" := UserId;
        Rec."Creation Date" := CreateDateTime(Today, Time);
    end;
}
