table 50018 "PWD Product Group"
{
    Caption = 'Product Group';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            NotBlank = true;
            TableRelation = "Item Category".Code;
            ValidateTableRelation = false;
        }
        field(2; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(7300; "Warehouse Class Code"; Code[10])
        {
            Caption = 'Warehouse Class Code';
            TableRelation = "Warehouse Class";
            ValidateTableRelation = false;
        }
    }

    keys
    {
        key(Key1; "Item Category Code", "Code")
        {
            Clustered = true;
        }
    }
    VAR
        CduGClosingMgt: Codeunit "PWD Closing Management";

    trigger OnInsert()
    begin
        //>>P24578_008.001
        CduGClosingMgt.UpdateDimValue(DATABASE::"PWD Product Group", Code, Description);
        //<<P24578_008.001
    end;

    trigger OnModify()
    begin
        //>>P24578_008.001
        CduGClosingMgt.UpdateDimValue(DATABASE::"Pwd Product Group", Code, Description);
        //<<P24578_008.001
    end;
}
