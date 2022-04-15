table 50099 "Prod. Order Routing Line BKP"
{
    Caption = 'Prod. Order Routing Line';
    DrillDownPageID = "Prod. Order Routing";
    LookupPageID = "Prod. Order Routing";
    Permissions = TableData "Prod. Order Capacity Need" = rimd;

    fields
    {
        field(1; "Routing No."; Code[20])
        {
            Caption = 'Routing No.';
            TableRelation = "Routing Header";
        }
        field(3; "Routing Reference No."; Integer)
        {
            Caption = 'Routing Reference No.';
            Editable = false;
        }
        field(4; "Operation No."; Code[10])
        {
            Caption = 'Operation No.';
            NotBlank = true;
        }
        field(5; "Next Operation No."; Code[30])
        {
            Caption = 'Next Operation No.';
        }
        field(6; "Previous Operation No."; Code[30])
        {
            Caption = 'Previous Operation No.';
        }
        field(7; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Work Center,Machine Center';
            OptionMembers = "Work Center","Machine Center";
        }
        field(8; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type = CONST("Work Center")) "Work Center"
            ELSE
            IF (Type = CONST("Machine Center")) "Machine Center";
        }
        field(9; "Work Center No."; Code[20])
        {
            Caption = 'Work Center No.';
            Editable = false;
            TableRelation = "Work Center";
        }
        field(10; "Work Center Group Code"; Code[10])
        {
            Caption = 'Work Center Group Code';
            Editable = false;
            TableRelation = "Work Center Group";
        }
        field(11; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(12; "Setup Time"; Decimal)
        {
            Caption = 'Setup Time';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(13; "Run Time"; Decimal)
        {
            Caption = 'Run Time';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(14; "Wait Time"; Decimal)
        {
            Caption = 'Wait Time';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(15; "Move Time"; Decimal)
        {
            Caption = 'Move Time';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(16; "Fixed Scrap Quantity"; Decimal)
        {
            Caption = 'Fixed Scrap Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(17; "Lot Size"; Decimal)
        {
            Caption = 'Lot Size';
            DecimalPlaces = 0 : 5;
        }
        field(18; "Scrap Factor %"; Decimal)
        {
            Caption = 'Scrap Factor %';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(19; "Setup Time Unit of Meas. Code"; Code[10])
        {
            Caption = 'Setup Time Unit of Meas. Code';
            TableRelation = "Capacity Unit of Measure";
        }
        field(20; "Run Time Unit of Meas. Code"; Code[10])
        {
            Caption = 'Run Time Unit of Meas. Code';
            TableRelation = "Capacity Unit of Measure";
        }
        field(21; "Wait Time Unit of Meas. Code"; Code[10])
        {
            Caption = 'Wait Time Unit of Meas. Code';
            TableRelation = "Capacity Unit of Measure";
        }
        field(22; "Move Time Unit of Meas. Code"; Code[10])
        {
            Caption = 'Move Time Unit of Meas. Code';
            TableRelation = "Capacity Unit of Measure";
        }
        field(27; "Minimum Process Time"; Decimal)
        {
            Caption = 'Minimum Process Time';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(28; "Maximum Process Time"; Decimal)
        {
            Caption = 'Maximum Process Time';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(30; "Concurrent Capacities"; Decimal)
        {
            Caption = 'Concurrent Capacities';
            DecimalPlaces = 0 : 5;
            InitValue = 1;
            MinValue = 0;
        }
        field(31; "Send-Ahead Quantity"; Decimal)
        {
            Caption = 'Send-Ahead Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(34; "Routing Link Code"; Code[10])
        {
            Caption = 'Routing Link Code';
            TableRelation = "Routing Link";
        }
        field(35; "Standard Task Code"; Code[10])
        {
            Caption = 'Standard Task Code';
            TableRelation = "Standard Task";

            trigger OnValidate()
            var
                StandardTask: Record "Standard Task";
                StdTaskTool: Record "Standard Task Tool";
                StdTaskPersonnel: Record "Standard Task Personnel";
                StdTaskQltyMeasure: Record "Standard Task Quality Measure";
                StdTaskComment: Record "Standard Task Description";
            begin
            end;
        }
        field(40; "Unit Cost per"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost per';
            MinValue = 0;
        }
        field(41; Recalculate; Boolean)
        {
            Caption = 'Recalculate';
        }
        field(50; "Sequence No. (Forward)"; Integer)
        {
            Caption = 'Sequence No. (Forward)';
            Editable = false;
        }
        field(51; "Sequence No. (Backward)"; Integer)
        {
            Caption = 'Sequence No. (Backward)';
            Editable = false;
        }
        field(52; "Fixed Scrap Qty. (Accum.)"; Decimal)
        {
            Caption = 'Fixed Scrap Qty. (Accum.)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(53; "Scrap Factor % (Accumulated)"; Decimal)
        {
            Caption = 'Scrap Factor % (Accumulated)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(55; "Sequence No. (Actual)"; Integer)
        {
            Caption = 'Sequence No. (Actual)';
            Editable = false;
        }
        field(56; "Direct Unit Cost"; Decimal)
        {
            Caption = 'Direct Unit Cost';
            DecimalPlaces = 2 : 5;
        }
        field(57; "Indirect Cost %"; Decimal)
        {
            Caption = 'Indirect Cost %';
            DecimalPlaces = 0 : 5;
        }
        field(58; "Overhead Rate"; Decimal)
        {
            Caption = 'Overhead Rate';
            DecimalPlaces = 0 : 5;
        }
        field(70; "Starting Time"; Time)
        {
            Caption = 'Starting Time';
        }
        field(71; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(72; "Ending Time"; Time)
        {
            Caption = 'Ending Time';
        }
        field(73; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(74; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Simulated,Planned,Firm Planned,Released,Finished';
            OptionMembers = Simulated,Planned,"Firm Planned",Released,Finished;
        }
        field(75; "Prod. Order No."; Code[20])
        {
            Caption = 'Prod. Order No.';
            Editable = false;
            NotBlank = true;
            TableRelation = "Production Order"."No." WHERE(Status = FIELD(Status));
        }
        field(76; "Unit Cost Calculation"; Option)
        {
            Caption = 'Unit Cost Calculation';
            OptionCaption = 'Time,Units';
            OptionMembers = Time,Units;
        }
        field(77; "Input Quantity"; Decimal)
        {
            Caption = 'Input Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(78; "Critical Path"; Boolean)
        {
            Caption = 'Critical Path';
            Editable = false;
        }
        field(79; "Routing Status"; Option)
        {
            Caption = 'Routing Status';
            OptionCaption = ' ,Planned,In Progress,Finished';
            OptionMembers = " ",Planned,"In Progress",Finished;
        }
        field(81; "Flushing Method"; Option)
        {
            Caption = 'Flushing Method';
            InitValue = Manual;
            OptionCaption = 'Manual,Forward,Backward';
            OptionMembers = Manual,Forward,Backward;
        }
        field(90; "Expected Operation Cost Amt."; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Expected Operation Cost Amt.';
            Editable = false;
        }
        field(91; "Expected Capacity Need"; Decimal)
        {
            Caption = 'Expected Capacity Need';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = Normal;
        }
        field(96; "Expected Capacity Ovhd. Cost"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Expected Capacity Ovhd. Cost';
            Editable = false;
        }
        field(98; "Starting Date-Time"; DateTime)
        {
            Caption = 'Starting Date-Time';
        }
        field(99; "Ending Date-Time"; DateTime)
        {
            Caption = 'Ending Date-Time';
        }
        field(100; "Schedule Manually"; Boolean)
        {
            Caption = 'Schedule Manually';
        }
        field(8076500; "Planned Ress. Type"; Option)
        {
            Caption = 'Planned Ress. Type';
            Description = 'Type of the resource on which the operation is scheduled in PlannerOne.';
            Editable = true;
            OptionCaption = 'Work Center,Machine Center';
            OptionMembers = "Work Center","Machine Center";
        }
        field(8076501; "Planned Ress. No."; Code[20])
        {
            Caption = 'Planned Ress. No.';
            Description = 'No. of the resource on which the operation is scheduled in PlannerOne.';
            Editable = true;
            TableRelation = IF ("Planned Ress. Type" = CONST("Work Center")) "Work Center"
            ELSE
            IF ("Planned Ress. Type" = CONST("Machine Center")) "Machine Center";
            ValidateTableRelation = true;
        }
        field(8076502; Markers; Text[250])
        {
            Caption = 'Markers';
            Description = 'Markers set on the operation in PlannerOne.';
            Editable = true;
            Enabled = true;
        }
        field(8076503; "Next Operation Link Type"; Text[250])
        {
            Caption = 'Next Operation Link Type';
            Description = 'Type of the link with next operation.';
        }
        field(8076504; "Fixed Date"; DateTime)
        {
            Caption = 'Fixed Date';
            Description = 'PlannerOne Fix Start Date';
        }
        field(8076505; "Fixed Date Activated"; Boolean)
        {
            Caption = 'Fixed Date Activated';
            Description = 'PlannerOne Fix Start Date Activated';
        }
        field(8076506; "Forced Placement"; Boolean)
        {
            Caption = 'Forced Placement';
            Description = 'Placement forced in PlannerOne';
        }
        field(8076507; MarkersBlob; BLOB)
        {
            Caption = 'Markers BLOB';
        }
        field(8076508; "Material Fixed Date"; DateTime)
        {
            Caption = 'Material Fixed Date';
            Description = 'Fix Start Date driven by component availability check';
        }
        field(8076509; "Material Fixed Date Activated"; Boolean)
        {
            Caption = 'Material Fixed Date Activated';
            Description = 'Material Fix Start Date Activated';
            InitValue = true;
        }
        field(8076510; ResourceSequenceOrder; Integer)
        {
            Caption = 'Resource Sequence Order';
            Description = 'Order in the resource sequence. Used for re-initialization of PlannerOne.';
        }
        field(8076511; PlannerOneCustom; Text[250])
        {
            Caption = 'PlannerOne Custom Field';
            Description = 'Free field displayed in Planner One detail panel';
        }
        field(8076512; PlannerOneCustom2; Text[250])
        {
            Caption = 'PlannerOne Custom Field(2)';
            Description = 'Free field displayed in Planner One detail panel';
        }
    }

    keys
    {
        key(Key1; Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.")
        {
            Clustered = true;
            SumIndexFields = "Expected Operation Cost Amt.", "Expected Capacity Need", "Expected Capacity Ovhd. Cost";
        }
        key(Key2; "Prod. Order No.", "Routing Reference No.", Status, "Routing No.", "Operation No.")
        {
            MaintainSIFTIndex = false;
        }
        key(Key3; Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Sequence No. (Forward)")
        {
        }
        key(Key4; Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Sequence No. (Backward)")
        {
        }
        key(Key5; Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Sequence No. (Actual)")
        {
        }
        key(Key6; "Work Center No.")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = "Expected Operation Cost Amt.";
        }
        key(Key7; Type, "No.", "Starting Date")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = "Expected Operation Cost Amt.";
        }
        key(Key8; Status, "Work Center No.")
        {
        }
        key(Key9; "Prod. Order No.", Status, "Flushing Method")
        {
        }
        key(Key10; "Starting Date", "Starting Time")
        {
            MaintainSIFTIndex = false;
            MaintainSQLIndex = false;
        }
        key(Key11; "Ending Date", "Ending Time")
        {
            MaintainSIFTIndex = false;
            MaintainSQLIndex = false;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
    end;

    trigger OnModify()
    begin
    end;


    procedure Caption(): Text[100]
    begin
    end;


    procedure GetLine()
    begin
    end;


    procedure DeleteRelations()
    begin
    end;


    procedure WorkCenterTransferfields()
    begin
    end;


    procedure MachineCtrTransferfields()
    begin
    end;


    procedure CalcStartingEndingDates(Direction1: Option Forward,Backward)
    begin
    end;


    procedure SetRecalcStatus()
    begin
    end;


    procedure RunTimePer(): Decimal
    begin
    end;


    procedure CalculateRoutingBack()
    begin
    end;


    procedure CalculateRoutingForward()
    begin
    end;


    procedure ModifyCapNeedEntries()
    begin
    end;


    procedure AdjustComponents(var ProdOrderLine: Record "Prod. Order Line")
    begin
    end;


    procedure UpdateDatetime()
    begin
    end;


    procedure "CheckPrevious&Next"()
    begin
    end;


    procedure SetNextOperations(var RtngLine: Record "Prod. Order Routing Line")
    begin
    end;


    procedure SubcontractPurchOrderExist(): Boolean
    begin
    end;


    procedure SetProdOrderLineDates()
    begin
    end;


    procedure RecalculateComponents()
    begin
    end;


    procedure RecalculateComponent(ProdOrderComp: Record "Prod. Order Component")
    begin
    end;


    procedure CheckAlternate()
    begin
    end;


    procedure CalculateRoutingLine()
    begin
    end;
}

