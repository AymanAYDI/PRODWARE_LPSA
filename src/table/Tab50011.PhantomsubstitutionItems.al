table 50011 "PWD Phantom substitution Items"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.06
    // FE_LAPRIERRETTE_GP0003 : APA 16/05/13 Create
    // 
    // +----------------------------------------------------------------------------------------------------------------+

    Caption = 'Phantom substitution Items';
    DrillDownPageID = "PWD Phantom subs. Items List";
    LookupPageID = "PWD Phantom subs. Items List";

    fields
    {
        field(1; "Phantom Item No."; Code[20])
        {
            Caption = 'Phantom Item No.';
            TableRelation = Item."No.";
        }
        field(10; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
        }
        field(20; "Lot No."; Code[20])
        {

            trigger OnValidate()
            var
                RecLItemLedgentry: Record "Item Ledger Entry";
            begin
                IF "Lot No." <> xRec."Lot No." THEN BEGIN
                    RecLItemLedgentry.SETRANGE("Item No.", "Item No.");
                    RecLItemLedgentry.SETRANGE("Lot No.", "Lot No.");
                    IF NOT RecLItemLedgentry.FIND('-') THEN
                        ERROR(Text1, "Lot No.", "Item No.");
                END;
            end;
        }
        field(25; "Expected Quantity"; Decimal)
        {
            Caption = 'Expected Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(30; Priority; Integer)
        {
            Caption = 'Priority';
        }
        field(40; Inventory; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Item No."), "Lot No." = FIELD("Lot No.")));
            Caption = 'Inventory';
            DecimalPlaces = 0 : 5;
            FieldClass = FlowField;
        }
        field(41; "Total Available Quantity"; Decimal)
        {
            Caption = 'Total Available Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(42; "Reserved Qty. on Inventory"; Decimal)
        {
            CalcFormula = Sum("Reservation Entry"."Quantity (Base)" WHERE("Item No." = FIELD("Item No."), "Lot No." = FIELD("Lot No.")));
            Caption = 'Reserved Qty. on Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50000; "Quantity Requested"; Decimal)
        {
            Caption = 'Quantity Requested';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                IF "Quantity Requested" > "Total Available Quantity" THEN
                    ERROR(Text2, "Total Available Quantity");
            end;
        }
        field(50005; Description; Text[100])
        {
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("Item No.")));
            Caption = 'Description';
            FieldClass = FlowField;
        }
        field(50006; "Description 2"; Text[50])
        {
            CalcFormula = Lookup(Item."Description 2" WHERE("No." = FIELD("Item No.")));
            Caption = 'Description 2';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Phantom Item No.", "Item No.", Priority, "Lot No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Text1: Label 'There is no Lot No. %1 for item No. %2';
        Text2: Label 'You can not enter more than 1%';

    procedure AssistEditLotNo()
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        CLEAR(ItemLedgEntry);
        ItemLedgEntry.SETCURRENTKEY(Open, "Item Tracking", "Item No.", "Variant Code", "Lot No.", "Serial No.");
        ItemLedgEntry.SETRANGE(Open, TRUE);
        ItemLedgEntry.SETRANGE("Item No.", "Item No.");
        ItemLedgEntry.SETFILTER("Lot No.", '<>%1', '');
        IF PAGE.RUNMODAL(0, ItemLedgEntry) = ACTION::LookupOK THEN
            VALIDATE("Lot No.", ItemLedgEntry."Lot No.");
    end;
}

