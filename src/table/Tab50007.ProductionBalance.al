table 50007 "PWD Production Balance"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.00
    // FE_LAPIERRETTE_PRO06.001: TO 19/01/2012: Bilan production par commande
    //                                           - Creation Table
    // 
    // ------------------------------------------------------------------------------------------------------------------

    Caption = 'Production Balance';

    fields
    {
        field(1; "User ID"; Code[50])
        {
            Caption = 'User ID';
            NotBlank = true;
            TableRelation = User."User Name";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                UserSelection: Codeunit "User Selection";
            begin
                UserSelection.ValidateUserName("User ID");
            end;
        }
        field(2; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(3; "Planned Order No."; Code[20])
        {
            Caption = 'Planned Order No.';
        }
        field(4; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(5; "Order No."; Code[20])
        {
            Caption = 'Order No.';
        }
        field(6; "Line Type"; Option)
        {
            Caption = 'Line Type';
            OptionCaption = 'Component,Operation';
            OptionMembers = Component,Operation;
        }
        field(7; "Operation No."; Code[10])
        {
            Caption = 'Operation No.';
        }
        field(8; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Work Center,Machine Center,Item';
            OptionMembers = "Work Center","Machine Center",Item;
        }
        field(9; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(10; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(11; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Simulated,Planned,Firm Planned,Released,Finished, ';
            OptionMembers = Simulated,Planned,"Firm Planned",Released,Finished," ";
        }
        field(12; "Expected Quantity"; Decimal)
        {
            Caption = 'Expected Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(13; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(14; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
        }
        field(15; "Scrap Quantity"; Decimal)
        {
            Caption = 'Scrap Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(16; "Expected Flushing Quantity"; Decimal)
        {
            Caption = 'Expected Flushing Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(17; "Realized Flushing Quantity"; Decimal)
        {
            Caption = 'Realized Flushing Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(18; "Cost Amount (Expected)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Cost Amount (Expected)';
        }
        field(19; "Cost Amount (Actual)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Cost Amount (Actual)';
        }
        field(20; "Cost Difference"; Decimal)
        {
            Caption = 'Cost Difference';
        }
        field(21; "Actual Cost MP"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Actual Cost MP';
        }
        field(22; "Actual Cost STR"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Actual Cost STR';
        }
        field(23; "Actual Cost MO"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Actual Cost MO';
        }
        field(24; Productivity; Decimal)
        {
            Caption = 'Productivity';
        }
        field(25; Output; Decimal)
        {
            Caption = 'Rendement';
        }
        field(26; "Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
            MinValue = 0;
        }
        field(27; "Planned Order Index"; Text[2])
        {
            Caption = 'Planned Order Index';
        }
        field(28; "Current Quantity Total"; Decimal)
        {
            CalcFormula = Sum("PWD Production Balance"."Expected Quantity" WHERE("Line Type" = CONST(Operation)));
            Caption = 'Current Quantity Total';
            FieldClass = FlowField;
        }
        field(29; "Scrap Quantity Total"; Decimal)
        {
            CalcFormula = Sum("PWD Production Balance"."Scrap Quantity" WHERE("Line Type" = CONST(Operation)));
            Caption = 'Scrap Quantity Total';
            DecimalPlaces = 0 : 5;
            FieldClass = FlowField;
        }
        field(30; "Quantity Total"; Decimal)
        {
            CalcFormula = Sum("PWD Production Balance".Quantity WHERE("Line Type" = CONST(Operation)));
            Caption = 'Quantity Total';
            DecimalPlaces = 0 : 5;
            FieldClass = FlowField;
        }
        field(31; "Expected Flushing Quantity Tot"; Decimal)
        {
            CalcFormula = Sum("PWD Production Balance"."Expected Flushing Quantity" WHERE("Line Type" = CONST(Operation)));
            Caption = 'Expected Flushing Quantity Tot';
            DecimalPlaces = 0 : 5;
            FieldClass = FlowField;
        }
        field(32; "Realized Flushing Quantity Tot"; Decimal)
        {
            CalcFormula = Sum("PWD Production Balance"."Realized Flushing Quantity" WHERE("Line Type" = CONST(Operation)));
            Caption = 'Realized Flushing Quantity Tot';
            DecimalPlaces = 0 : 5;
            FieldClass = FlowField;
        }
        field(33; "Entry No. Negative"; Integer)
        {
            Caption = 'N° séquence négatif';
        }
        field(34; "Cost Amount (Actual) Total"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("PWD Production Balance"."Cost Amount (Actual)" WHERE("Item No." = FIELD("Item No.")));
            Caption = 'Cost Amount (Actual) Total';
            FieldClass = FlowField;
        }
        field(35; "Current Quantity Total Order"; Decimal)
        {
            CalcFormula = Sum("PWD Production Balance"."Expected Quantity" WHERE("Line Type" = CONST(Operation),
                                                                              "Item No." = FIELD("Item No.")));
            Caption = 'Current Quantity Total Order';
            FieldClass = FlowField;
        }
        field(36; "Scrap Quantity Total Order"; Decimal)
        {
            CalcFormula = Sum("PWD Production Balance"."Scrap Quantity" WHERE("Line Type" = CONST(Operation),
                                                                           "Item No." = FIELD("Item No.")));
            Caption = 'Scrap Quantity Total Order';
            DecimalPlaces = 0 : 5;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "User ID", "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "User ID", "Line Type", Type, "No.", "Item No.")
        {
            SumIndexFields = "Expected Quantity", "Scrap Quantity", Quantity, "Expected Flushing Quantity", "Realized Flushing Quantity", "Cost Amount (Actual)";
        }
        key(Key3; "User ID", "Line Type", "Operation No.", Type, "No.", "Item No.")
        {
            SumIndexFields = "Expected Quantity", "Scrap Quantity", Quantity;
        }
        key(Key4; "User ID", "Planned Order Index", "Entry No. Negative")
        {
        }
    }

    fieldgroups
    {
    }
}

