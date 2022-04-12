table 50012 "Tracking Specification Phantom"
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

    Caption = 'Tracking Specification Phantom';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(3; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(4; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;
        }
        field(7; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(8; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
        }
        field(10; "Source Type"; Integer)
        {
            Caption = 'Source Type';
        }
        field(11; "Source Subtype"; Option)
        {
            Caption = 'Source Subtype';
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
        }
        field(12; "Source ID"; Code[20])
        {
            Caption = 'Source ID';
        }
        field(13; "Source Batch Name"; Code[10])
        {
            Caption = 'Source Batch Name';
        }
        field(14; "Source Prod. Order Line"; Integer)
        {
            Caption = 'Source Prod. Order Line';
        }
        field(15; "Source Ref. No."; Integer)
        {
            Caption = 'Source Ref. No.';
        }
        field(16; "Appl.-to Item Entry"; Integer)
        {
            Caption = 'Appl.-to Item Entry';
            TableRelation = "Item Ledger Entry";
        }
        field(17; "Transfer Item Entry No."; Integer)
        {
            Caption = 'Transfer Item Entry No.';
            TableRelation = "Item Ledger Entry";
        }
        field(24; "Serial No."; Code[20])
        {
            Caption = 'Serial No.';
        }
        field(28; Positive; Boolean)
        {
            Caption = 'Positive';
        }
        field(29; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(40; "Warranty Date"; Date)
        {
            Caption = 'Warranty Date';
        }
        field(41; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
        }
        field(50; "Qty. to Handle (Base)"; Decimal)
        {
            Caption = 'Qty. to Handle (Base)';
            DecimalPlaces = 0 : 5;
        }
        field(51; "Qty. to Invoice (Base)"; Decimal)
        {
            Caption = 'Qty. to Invoice (Base)';
            DecimalPlaces = 0 : 5;
        }
        field(52; "Quantity Handled (Base)"; Decimal)
        {
            Caption = 'Quantity Handled (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(53; "Quantity Invoiced (Base)"; Decimal)
        {
            Caption = 'Quantity Invoiced (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(60; "Qty. to Handle"; Decimal)
        {
            Caption = 'Qty. to Handle';
            DecimalPlaces = 0 : 5;
        }
        field(61; "Qty. to Invoice"; Decimal)
        {
            Caption = 'Qty. to Invoice';
            DecimalPlaces = 0 : 5;
        }
        field(70; "Buffer Status"; Option)
        {
            Caption = 'Buffer Status';
            Editable = false;
            OptionCaption = ' ,MODIFY,INSERT';
            OptionMembers = " ",MODIFY,INSERT;
        }
        field(71; "Buffer Status2"; Option)
        {
            Caption = 'Buffer Status2';
            Editable = false;
            OptionCaption = ',ExpDate blocked';
            OptionMembers = ,"ExpDate blocked";
        }
        field(72; "Buffer Value1"; Decimal)
        {
            Caption = 'Buffer Value1';
            Editable = false;
        }
        field(73; "Buffer Value2"; Decimal)
        {
            Caption = 'Buffer Value2';
            Editable = false;
        }
        field(74; "Buffer Value3"; Decimal)
        {
            Caption = 'Buffer Value3';
            Editable = false;
        }
        field(75; "Buffer Value4"; Decimal)
        {
            Caption = 'Buffer Value4';
            Editable = false;
        }
        field(76; "Buffer Value5"; Decimal)
        {
            Caption = 'Buffer Value5';
            Editable = false;
        }
        field(80; "New Serial No."; Code[20])
        {
            Caption = 'New Serial No.';
        }
        field(81; "New Lot No."; Code[20])
        {
            Caption = 'New Lot No.';
        }
        field(5400; "Lot No."; Code[20])
        {
            Caption = 'Lot No.';
        }
        field(5401; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(5402; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Location Code"));
        }
        field(5811; "Appl.-from Item Entry"; Integer)
        {
            Caption = 'Appl.-from Item Entry';
            MinValue = 0;

            trigger OnLookup()
            var
                ItemLedgEntry: Record "Item Ledger Entry";
            begin
            end;

            trigger OnValidate()
            var
                ItemLedgEntry: Record "Item Ledger Entry";
            begin
            end;
        }
        field(5817; Correction; Boolean)
        {
            Caption = 'Correction';
        }
        field(6505; "New Expiration Date"; Date)
        {
            Caption = 'New Expiration Date';
        }
        field(7300; "Quantity actual Handled (Base)"; Decimal)
        {
            Caption = 'Quantity actual Handled (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50000; "Lot Number"; Code[20])
        {
            Caption = 'Lot Number';
        }
        field(50001; "Trading Unit Number"; Code[20])
        {
            Caption = 'Trading Unit Number';
        }
        field(50002; "No. of Units"; Integer)
        {
            Caption = 'No. of Units';
            InitValue = 1;
        }
        field(50003; NC; Boolean)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Source ID", "Source Type", "Source Subtype", "Source Batch Name", "Source Prod. Order Line", "Source Ref. No.")
        {
            MaintainSIFTIndex = false;
            MaintainSQLIndex = false;
            SumIndexFields = "Qty. to Handle (Base)", "Qty. to Invoice (Base)", "Quantity Handled (Base)", "Quantity Invoiced (Base)";
        }
        key(Key3; "Lot No.", "Serial No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Text000: Label 'You cannot invoice more than %1 units.';
        Text001: Label 'You cannot handle more than %1 units.';
        Text002: Label 'must not be less than %1';
        Text003: Label '%1 must be -1, 0 or 1 when %2 is stated.';
        Text004: Label 'Expiration date has been established by existing entries and cannot be changed.';
        WMSManagement: Codeunit "WMS Management";
        Text005: Label '%1 in %2 for %3 %4, %5: %6, %7: %8 is currently %9. It must be %10.';
        SkipSerialNoQtyValidation: Boolean;

    procedure InitQtyToShip()
    begin
    end;

    procedure InitQtyToInvoice()
    begin
    end;

    procedure CheckSerialNoQty()
    begin
    end;

    procedure CopyPointerFilters(var ReservEntry: Record "Reservation Entry")
    begin
    end;

    procedure CalcQty(BaseQty: Decimal): Decimal
    begin
    end;

    procedure InitExpirationDate()
    var
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        ExpDate: Date;
        EntriesExist: Boolean;
    begin
    end;

    procedure IsReclass(): Boolean
    begin
    end;

    procedure TestFieldError(FieldCaptionText: Text[80]; CurrFieldValue: Decimal; CompareValue: Decimal)
    begin
    end;

    procedure SetSkipSerialNoQtyValidation(NewVal: Boolean)
    begin
    end;
}

