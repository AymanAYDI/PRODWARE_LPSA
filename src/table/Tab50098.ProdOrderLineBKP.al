table 50098 "PWD Prod. Order Line BKP"
{
    Caption = 'Prod. Order Line';
    DataCaptionFields = "Prod. Order No.";
    DrillDownPageID = "Prod. Order Line List";
    LookupPageID = "Prod. Order Line List";
    PasteIsValid = false;

    fields
    {
        field(1; Status; Enum "Production Order Status")
        {
            Caption = 'Status';
        }
        field(2; "Prod. Order No."; Code[20])
        {
            Caption = 'Prod. Order No.';
            TableRelation = "Production Order"."No." WHERE(Status = FIELD(Status));
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(11; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;

            trigger OnValidate()
            begin
            end;
        }
        field(12; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."),
                                                       Code = FIELD("Variant Code"));
        }
        field(13; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(14; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(20; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(21; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(22; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(23; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
        }
        field(29; "Cost is Adjusted"; Boolean)
        {
            Caption = 'Cost is Adjusted';
            Editable = false;
            InitValue = true;
        }
        field(30; "Allow Online Adjustment"; Boolean)
        {
            Caption = 'Allow Online Adjustment';
            Editable = false;
            InitValue = true;
        }
        field(40; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(41; "Finished Quantity"; Decimal)
        {
            Caption = 'Finished Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
            MinValue = 0;
        }
        field(42; "Remaining Quantity"; Decimal)
        {
            Caption = 'Remaining Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
            MinValue = 0;
        }
        field(45; "Scrap %"; Decimal)
        {
            Caption = 'Scrap %';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(47; "Due Date"; Date)
        {
            Caption = 'Due Date';
            Editable = false;
        }
        field(48; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(49; "Starting Time"; Time)
        {
            Caption = 'Starting Time';
        }
        field(50; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(51; "Ending Time"; Time)
        {
            Caption = 'Ending Time';
        }
        field(52; "Planning Level Code"; Integer)
        {
            Caption = 'Planning Level Code';
            Editable = false;
        }
        field(53; Priority; Integer)
        {
            Caption = 'Priority';
        }
        field(60; "Production BOM No."; Code[20])
        {
            Caption = 'Production BOM No.';
            TableRelation = "Production BOM Header"."No." WHERE(Status = CONST(Certified));
        }
        field(61; "Routing No."; Code[20])
        {
            Caption = 'Routing No.';
            TableRelation = "Routing Header"."No." WHERE(Status = CONST(Certified));
        }
        field(62; "Inventory Posting Group"; Code[10])
        {
            Caption = 'Inventory Posting Group';
            TableRelation = "Inventory Posting Group";
        }
        field(63; "Routing Reference No."; Integer)
        {
            Caption = 'Routing Reference No.';
            Editable = false;
        }
        field(65; "Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost';
        }
        field(67; "Cost Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Cost Amount';
            Editable = false;
        }
        field(68; "Reserved Quantity"; Decimal)
        {
            CalcFormula = Sum("Reservation Entry".Quantity WHERE("Source ID" = FIELD("Prod. Order No."),
                                                                  "Source Ref. No." = CONST(0),
                                                                  "Source Type" = CONST(5406),
                                                                  "Source Subtype" = FIELD(Status),
                                                                  "Source Batch Name" = CONST(''),
                                                                  "Source Prod. Order Line" = FIELD("Line No."),
                                                                  "Reservation Status" = CONST(Reservation)));
            Caption = 'Reserved Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(70; "Capacity Type Filter"; Option)
        {
            Caption = 'Capacity Type Filter';
            FieldClass = FlowFilter;
            OptionCaption = 'Work Center,Machine Center';
            OptionMembers = "Work Center","Machine Center";
        }
        field(71; "Capacity No. Filter"; Code[20])
        {
            Caption = 'Capacity No. Filter';
            FieldClass = FlowFilter;
            TableRelation = IF ("Capacity Type Filter" = CONST("Work Center")) "Work Center"
            ELSE
            IF ("Capacity Type Filter" = CONST("Machine Center")) "Machine Center";
        }
        field(72; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(80; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(81; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;
        }
        field(82; "Finished Qty. (Base)"; Decimal)
        {
            Caption = 'Finished Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(83; "Remaining Qty. (Base)"; Decimal)
        {
            Caption = 'Remaining Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(84; "Reserved Qty. (Base)"; Decimal)
        {
            CalcFormula = Sum("Reservation Entry"."Quantity (Base)" WHERE("Source ID" = FIELD("Prod. Order No."),
                                                                           "Source Ref. No." = CONST(0),
                                                                           "Source Type" = CONST(5406),
                                                                           "Source Subtype" = FIELD(Status),
                                                                           "Source Batch Name" = CONST(''),
                                                                           "Source Prod. Order Line" = FIELD("Line No."),
                                                                           "Reservation Status" = CONST(Reservation)));
            Caption = 'Reserved Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(90; "Expected Operation Cost Amt."; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Prod. Order Routing Line"."Expected Operation Cost Amt." WHERE(Status = FIELD(Status),
                                                                                               "Prod. Order No." = FIELD("Prod. Order No."),
                                                                                               "Routing No." = FIELD("Routing No."),
                                                                                               "Routing Reference No." = FIELD("Routing Reference No.")));
            Caption = 'Expected Operation Cost Amt.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(91; "Total Exp. Oper. Output (Qty.)"; Decimal)
        {
            CalcFormula = Sum("Prod. Order Line".Quantity WHERE(Status = FIELD(Status),
                                                                 "Prod. Order No." = FIELD("Prod. Order No."),
                                                                 "Routing No." = FIELD("Routing No."),
                                                                 "Routing Reference No." = FIELD("Routing Reference No."),
                                                                 "Ending Date" = FIELD("Date Filter")));
            Caption = 'Total Exp. Oper. Output (Qty.)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(94; "Expected Component Cost Amt."; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Prod. Order Component"."Cost Amount" WHERE(Status = FIELD(Status),
                                                                           "Prod. Order No." = FIELD("Prod. Order No."),
                                                                           "Prod. Order Line No." = FIELD("Line No."),
                                                                           "Due Date" = FIELD("Date Filter")));
            Caption = 'Expected Component Cost Amt.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(150; "Completely Invoiced"; Boolean)
        {
            Caption = 'Completely Invoiced';
            Editable = false;
        }
        field(151; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            Editable = false;
        }
        field(152; "Single-Level Material Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Single-Level Material Cost';
            Editable = false;
        }
        field(153; "Single-Level Capacity Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Single-Level Capacity Cost';
            Editable = false;
        }
        field(154; "Single-Level Subcontrd. Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Single-Level Subcontrd. Cost';
            Editable = false;
        }
        field(155; "Single-Level Cap. Ovhd Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Single-Level Cap. Ovhd Cost';
            Editable = false;
        }
        field(156; "Single-Level Mfg. Ovhd Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Single-Level Mfg. Ovhd Cost';
            Editable = false;
        }
        field(198; "Starting Date-Time"; DateTime)
        {
            Caption = 'Starting Date-Time';
        }
        field(199; "Ending Date-Time"; DateTime)
        {
            Caption = 'Ending Date-Time';
        }
        field(5831; "Cost Amount (ACY)"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 1;
            Caption = 'Cost Amount (ACY)';
            Editable = false;
        }
        field(5832; "Unit Cost (ACY)"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 1;
            Caption = 'Unit Cost (ACY)';
            Editable = false;
        }
        field(50000; "Is Possible Item"; Boolean)
        {
            Caption = 'Is Possible Item';
            Description = 'LAP2.06';
        }
        field(8073282; "Send to OSYS (Released)"; Boolean)
        {
            Caption = 'Send to OSYS (Released)';
        }
        field(8073283; "Send to OSYS (Finished)"; Boolean)
        {
            Caption = 'Send to OSYS (Terminer)';
        }
        field(99000750; "Production BOM Version Code"; Code[20])
        {
            Caption = 'Production BOM Version Code';
            TableRelation = "Production BOM Version"."Version Code" WHERE("Production BOM No." = FIELD("Production BOM No."));
        }
        field(99000751; "Routing Version Code"; Code[20])
        {
            Caption = 'Routing Version Code';
            TableRelation = "Routing Version"."Version Code" WHERE("Routing No." = FIELD("Routing No."));
        }
        field(99000752; "Routing Type"; Option)
        {
            Caption = 'Routing Type';
            OptionCaption = 'Serial,Parallel';
            OptionMembers = Serial,Parallel;
        }
        field(99000753; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(99000754; "MPS Order"; Boolean)
        {
            Caption = 'MPS Order';
        }
        field(99000755; "Planning Flexibility"; Option)
        {
            Caption = 'Planning Flexibility';
            OptionCaption = 'Unlimited,None';
            OptionMembers = Unlimited,"None";
        }
        field(99000764; "Indirect Cost %"; Decimal)
        {
            Caption = 'Indirect Cost %';
            DecimalPlaces = 0 : 5;
        }
        field(99000765; "Overhead Rate"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Overhead Rate';
        }
    }

    keys
    {
        key(Key1; Status, "Prod. Order No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Prod. Order No.", "Line No.", Status)
        {
        }
        key(Key3; Status, "Item No.", "Variant Code", "Location Code", "Ending Date")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = "Remaining Qty. (Base)";
        }
        key(Key4; Status, "Item No.", "Variant Code", "Location Code", "Starting Date")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = "Remaining Qty. (Base)";
        }
        key(Key5; Status, "Item No.", "Variant Code", "Location Code", "Due Date")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = "Remaining Qty. (Base)";
        }
        key(Key6; Status, "Item No.", "Variant Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Location Code", "Due Date")
        {
            Enabled = false;
            MaintainSIFTIndex = false;
            SumIndexFields = "Remaining Qty. (Base)";
        }
        key(Key7; Status, "Prod. Order No.", "Item No.")
        {
        }
        key(Key8; Status, "Prod. Order No.", "Routing No.", "Routing Reference No.")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = Quantity, "Finished Quantity";
        }
        key(Key9; Status, "Prod. Order No.", "Planning Level Code")
        {
        }
        key(Key10; "Planning Level Code", Priority)
        {
            Enabled = false;
        }
        key(Key11; "Item No.", "Variant Code", "Location Code", Status, "Ending Date")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = "Remaining Qty. (Base)";
        }
        key(Key12; "Item No.", "Variant Code", "Location Code", Status, "Due Date")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = "Remaining Qty. (Base)";
        }
        key(Key13; Status, "Completely Invoiced")
        {
            Enabled = false;
        }
        key(Key14; Status, "Cost is Adjusted", "Allow Online Adjustment")
        {
        }
        key(Key16; Status, "Send to OSYS (Released)")
        {
        }
        key(Key17; Status, "Send to OSYS (Finished)")
        {
        }
        key(Key18; Status, "Routing No.", "Routing Version Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
    end;

    // procedure DeleteRelations()
    // begin
    // end;


    // procedure ShowReservation()
    // begin
    // end;


    // procedure ShowReservationEntries(Modal: Boolean)
    // begin
    // end;


    // procedure ItemAvailability(AvailabilityType: Option Date,Variant,Location,Bin)
    // begin
    // end;


    // procedure CheckEndingDate(ShowWarning: Boolean)
    // begin
    // end;


    // procedure BlockDynamicTracking(SetBlock: Boolean)
    // begin
    // end;


    // procedure CreateDim(Type1: Integer; No1: Code[20])
    // begin
    // end;


    // procedure OpenItemTrackingLines()
    // begin
    // end;


    // procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    // begin
    // end;


    // procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    // begin
    // end;


    // procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    // begin
    // end;

    // local procedure GetItem()
    // begin
    // end;

    // local procedure GetSKU(): Boolean
    // begin
    // end;


    // procedure GetUpdateFromSKU()
    // begin
    // end;


    // procedure UpdateDatetime()
    // begin
    // end;


    // procedure ShowDimensions()
    // begin
    // end;

    // local procedure GetGLSetup()
    // begin
    // end;


    procedure GetCurrencyCode(): Code[10]
    begin
    end;


    // procedure RowID1(): Text[250]
    // begin
    // end;

    // local procedure GetLocation(LocationCode: Code[10])
    // begin
    // end;

    // local procedure GetDefaultBin()
    // begin
    // end;


    // procedure IsCompletelyInvoiced(): Boolean
    // begin
    // end;


    // procedure SetStdCost(var ProdOrderLine: Record "Prod. Order Line"; MfgItem: Record Item; CurrencyFactor: Decimal)
    // begin
    // end;


    // procedure FnshdNotInvcdExists(): Boolean
    // begin
    // end;


    // procedure "--OSYS-Int001.001--"()
    // begin
    // end;


    // procedure FctCreateDeleteProdOrderLine()
    // begin
    // end;


    // procedure FctIsRecreateOrderLine()
    // begin
    // end;


    // procedure ItemChange(newItem: Record Item; oldItem: Record Item)
    // begin
    // end;


    // procedure "---FE_LAPRIERRETTE_GP0003-----"()
    // begin
    // end;


    // procedure ExistPhantomItem(): Text[1]
    // begin
    // end;


    // procedure "--- LPSA.TDL ---"()
    // begin
    // end;


    // procedure ResendProdOrdertoQuartis()
    // begin
    // end;
}

