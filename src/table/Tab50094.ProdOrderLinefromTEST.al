table 50094 "PWD Prod. Order Line from TEST"
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
        field(50; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(51; "Ending Time"; Time)
        {
            Caption = 'Ending Time';
        }
        field(199; "Ending Date-Time"; DateTime)
        {
            Caption = 'Ending Date-Time';
        }
    }

    keys
    {
        key(Key1; Status, "Prod. Order No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
    end;


    procedure DeleteRelations()
    begin
    end;


    procedure ShowReservation()
    begin
    end;


    procedure ShowReservationEntries(Modal: Boolean)
    begin
    end;


    procedure ItemAvailability(AvailabilityType: Option Date,Variant,Location,Bin)
    begin
    end;


    procedure CheckEndingDate(ShowWarning: Boolean)
    begin
    end;


    procedure BlockDynamicTracking(SetBlock: Boolean)
    begin
    end;


    procedure CreateDim(Type1: Integer; No1: Code[20])
    begin
    end;


    procedure OpenItemTrackingLines()
    begin
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
    end;


    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
    end;


    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
    end;

    local procedure GetItem()
    begin
    end;

    local procedure GetSKU(): Boolean
    begin
    end;


    procedure GetUpdateFromSKU()
    begin
    end;


    procedure UpdateDatetime()
    begin
    end;


    procedure ShowDimensions()
    begin
    end;

    local procedure GetGLSetup()
    begin
    end;


    procedure GetCurrencyCode(): Code[10]
    begin
    end;


    procedure RowID1(): Text[250]
    begin
    end;

    local procedure GetLocation(LocationCode: Code[10])
    begin
    end;

    local procedure GetDefaultBin()
    begin
    end;


    procedure IsCompletelyInvoiced(): Boolean
    begin
    end;


    procedure SetStdCost(var ProdOrderLine: Record "Prod. Order Line"; MfgItem: Record Item; CurrencyFactor: Decimal)
    begin
    end;


    procedure FnshdNotInvcdExists(): Boolean
    begin
    end;


    procedure "--OSYS-Int001.001--"()
    begin
    end;


    procedure FctCreateDeleteProdOrderLine()
    begin
    end;


    procedure FctIsRecreateOrderLine()
    begin
    end;


    procedure ItemChange(newItem: Record Item; oldItem: Record Item)
    begin
    end;


    procedure "---FE_LAPRIERRETTE_GP0003-----"()
    begin
    end;


    procedure ExistPhantomItem(): Text[1]
    begin
    end;


    procedure "--- LPSA.TDL ---"()
    begin
    end;


    procedure ResendProdOrdertoQuartis()
    begin
    end;


    procedure CheckComponentAvailabilty() IsNotAvailable: Boolean
    begin
    end;


    procedure FctUpdateDelay()
    begin
    end;
}

