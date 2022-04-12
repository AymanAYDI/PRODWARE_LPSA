table 8073291 "PWD Deleted Prod. Order Line"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.06
    // OSYS-Int001.001:GR 18/10/2011   Connector integration
    //                                   - Create Object
    // 
    // +----------------------------------------------------------------------------------------------------------------+

    Caption = 'Deleted Prod. Order Line';
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
        field(40; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(47; "Due Date"; Date)
        {
            Caption = 'Due Date';
            Editable = false;
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
        field(63; "Routing Reference No."; Integer)
        {
            Caption = 'Routing Reference No.';
            Editable = false;
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
        field(8073282; "Send to OSYS (Released)"; Boolean)
        {
            Caption = 'Send to OSYS (Released)';
        }
        field(8073283; "Send to OSYS (Finished)"; Boolean)
        {
            Caption = 'Send to OSYS (Terminer)';
        }
        field(8073344; "Send to OSYS (Deleted)"; Boolean)
        {
            Caption = 'Send to OSYS (Deleted)';
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
    }

    keys
    {
        key(Key1; Status, "Prod. Order No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; Status, "Send to OSYS (Released)", "Send to OSYS (Deleted)")
        {
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
}

