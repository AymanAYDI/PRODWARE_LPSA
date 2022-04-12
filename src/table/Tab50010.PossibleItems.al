table 50010 "PWD Possible Items"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise                                                                                      |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.06
    // FE_LAPRIERRETTE_GP0004.001 :GR  23/05/13 Create
    // 
    // +----------------------------------------------------------------------------------------------------------------+

    Caption = 'Possible Items';

    fields
    {
        field(1; "Item Code"; Code[20])
        {
            Caption = 'Item Code';
            NotBlank = true;
            TableRelation = Item."No.";
        }
        field(2; "Work Center Code"; Code[20])
        {
            Caption = 'Work Center Code';
            NotBlank = true;
            TableRelation = "Work Center"."No.";
        }
        field(3; "Item Description 1"; Text[100])
        {
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("Item Code")));
            Caption = 'Item Description 1';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "Item Description 2"; Text[50])
        {
            CalcFormula = Lookup(Item."Description 2" WHERE("No." = FIELD("Item Code")));
            Caption = 'Item Description 2';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Possible Item Code"; Code[20])
        {
            Caption = 'Possible Item Code';
            NotBlank = true;
            TableRelation = Item."No.";
        }
        field(6; "Possible Item Description"; Text[100])
        {
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("Possible Item Code")));
            Caption = 'Possible Item Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Last Modified Date"; DateTime)
        {
            Caption = 'Last Modified Date';
        }
    }

    keys
    {
        key(Key1; "Item Code", "Work Center Code", "Possible Item Code")
        {
            Clustered = true;
        }
        key(Key2; "Item Code", "Last Modified Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        RecLPossibleItems.Reset;
        RecLPossibleItems.SetRange("Item Code", "Item Code");
        RecLPossibleItems.SetFilter("Work Center Code", '<>%1', "Work Center Code");
        RecLPossibleItems.SetFilter("Possible Item Code", '<>%1', "Possible Item Code");
        RecLPossibleItems.ModifyAll("Last Modified Date", CurrentDateTime);
    end;

    trigger OnInsert()
    begin
        RecLPossibleItems.Reset;
        RecLPossibleItems.SetRange("Item Code", "Item Code");
        RecLPossibleItems.SetFilter("Work Center Code", '<>%1', "Work Center Code");
        RecLPossibleItems.SetFilter("Possible Item Code", '<>%1', "Possible Item Code");
        RecLPossibleItems.ModifyAll("Last Modified Date", CurrentDateTime);
        "Last Modified Date" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        RecLPossibleItems.Reset;
        RecLPossibleItems.SetRange("Item Code", "Item Code");
        RecLPossibleItems.SetFilter("Work Center Code", '<>%1', "Work Center Code");
        RecLPossibleItems.SetFilter("Possible Item Code", '<>%1', "Possible Item Code");
        RecLPossibleItems.ModifyAll("Last Modified Date", CurrentDateTime);
        "Last Modified Date" := CurrentDateTime;
    end;

    var
        RecLPossibleItems: Record "PWD Possible Items";
}

