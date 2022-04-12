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
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        CapLedgEntry: Record "Capacity Ledger Entry";
    begin
    end;

    var
        Text000: Label 'A %1 %2 cannot be inserted, modified, or deleted.';
        Text99000000: Label 'You cannot delete %1 %2 because there exists at least one %3 associated with it.';
        Text99000001: Label 'You cannot rename a %1.';
        Text99000002: Label 'You cannot change %1 when %2 is %3.';
        Text99000003: Label 'Change %1 from %2 to %3?';
        Item: Record Item;
        SKU: Record "Stockkeeping Unit";
        ItemVariant: Record "Item Variant";
        ReservEntry: Record "Reservation Entry";
        ProdBOMHeader: Record "Production BOM Header";
        ProdBOMVersion: Record "Production BOM Version";
        RtngHeader: Record "Routing Header";
        RtngVersion: Record "Routing Version";
        ProdOrder: Record "Production Order";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderComp: Record "Prod. Order Component";
        ProdOrderRtngLine: Record "Prod. Order Routing Line";
        GLSetup: Record "General Ledger Setup";
        Location: Record Location;
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        ReserveProdOrderLine: Codeunit "Prod. Order Line-Reserve";
        WhseValidateSourceLine: Codeunit "Whse. Validate Source Line";
        UOMMgt: Codeunit "Unit of Measure Management";
        VersionMgt: Codeunit VersionManagement;
        CalcProdOrder: Codeunit "Calculate Prod. Order";
        DimMgt: Codeunit DimensionManagement;
        Blocked: Boolean;
        GLSetupRead: Boolean;


    procedure DeleteRelations()
    var
        WhseOutputProdRelease: Codeunit "Whse.-Output Prod. Release";
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
    var
        CheckDateConflict: Codeunit "Reservation-Check Date Confl.";
    begin
    end;


    procedure BlockDynamicTracking(SetBlock: Boolean)
    begin
    end;


    procedure CreateDim(Type1: Integer; No1: Code[20])
    var
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
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
    var
        ProdDocDim: Record "Production Document Dimension";
    begin
    end;

    local procedure GetGLSetup()
    begin
    end;


    procedure GetCurrencyCode(): Code[10]
    begin
    end;


    procedure RowID1(): Text[250]
    var
        ItemTrackingMgt: Codeunit "Item Tracking Management";
    begin
    end;

    local procedure GetLocation(LocationCode: Code[10])
    begin
    end;

    local procedure GetDefaultBin()
    var
        WMSManagement: Codeunit "WMS Management";
    begin
    end;


    procedure IsCompletelyInvoiced(): Boolean
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        CapLedgEntry: Record "Capacity Ledger Entry";
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
    var
        "--OSYS-Int001.001---": Integer;
        RecLDeleteProdOrderLine: Record "PWD Deleted Prod. Order Line";
    begin
    end;


    procedure FctIsRecreateOrderLine()
    var
        "--OSYS-Int001.001---": Integer;
        RecLDeleteProdOrderLine: Record "PWD Deleted Prod. Order Line";
    begin
    end;


    procedure ItemChange(newItem: Record Item; oldItem: Record Item)
    var
        ProdOrderLine: Record "Prod. Order Line";
    begin
    end;


    procedure "---FE_LAPRIERRETTE_GP0003-----"()
    begin
    end;


    procedure ExistPhantomItem(): Text[1]
    var
        RecLProdOrderComponent: Record "Prod. Order Component";
        RecLItem: Record Item;
        BooLPhantomFind: Boolean;
    begin
    end;


    procedure "--- LPSA.TDL ---"()
    begin
    end;


    procedure ResendProdOrdertoQuartis()
    begin
    end;


    procedure CheckComponentAvailabilty() IsNotAvailable: Boolean
    var
        BooLIsNotAvailable: Boolean;
        RecLProdOrderCompo: Record "Prod. Order Component";
    begin
    end;


    procedure FctUpdateDelay()
    var
        DaFLDateF: DateTime;
    begin
    end;
}

