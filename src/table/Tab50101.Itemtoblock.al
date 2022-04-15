table 50101 "PWD Item to block"
{
    Caption = 'Item';
    DataCaptionFields = "No.", Description;
    DrillDownPageID = "Item List";
    LookupPageID = "Item List";
    Permissions =;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(54; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(11503; "Sale blocked"; Boolean)
        {
            Caption = 'Sale blocked';
        }
        field(11504; "Purchase blocked"; Boolean)
        {
            Caption = 'Purchase blocked';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Description)
        {
        }
    }

    trigger OnDelete()
    begin
    end;


    procedure AssistEdit(): Boolean
    begin
    end;


    procedure FindItemVend(var ItemVend: Record "Item Vendor"; LocationCode: Code[10])
    begin
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
    end;


    procedure TestNoEntriesExist(CurrentFieldName: Text[100])
    begin
    end;


    procedure TestNoOpenEntriesExist(CurrentFieldName: Text[100])
    begin
    end;


    procedure ItemSKUGet(var Item: Record Item; LocationCode: Code[10]; VariantCode: Code[10])
    begin
    end;


    procedure GetInvtSetup()
    begin
    end;


    procedure IsMfgItem(): Boolean
    begin
    end;

    local procedure GetGLSetup()
    begin
    end;


    procedure ProdOrderExist(): Boolean
    begin
    end;


    procedure PlanningTransferShptQty() "Sum": Decimal
    begin
    end;


    procedure PlanningReleaseQty() "Sum": Decimal
    begin
    end;


    procedure CalcSalesReturn(): Decimal
    begin
    end;


    procedure CalcResvQtyOnSalesReturn(): Decimal
    begin
    end;


    procedure CalcPurchReturn(): Decimal
    begin
    end;


    procedure CalcResvQtyOnPurchReturn(): Decimal
    begin
    end;


    procedure CheckSerialNoQty(ItemNo: Code[20]; FieldName: Text[30]; Quantity: Decimal)
    begin
    end;


    procedure CheckForProductionOutput(ItemNo: Code[20])
    begin
    end;
}

