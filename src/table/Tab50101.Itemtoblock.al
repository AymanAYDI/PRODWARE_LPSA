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
        fieldgroup(DropDown; "No.", Description, Field8, Field18)
        {
        }
    }

    trigger OnDelete()
    var
        BinContent: Record "Bin Content";
    begin
    end;

    var
        Text000: Label 'You cannot delete %1 %2 because there is at least one outstanding Purchase %3 that includes this item.';
        Text001: Label 'You cannot delete %1 %2 because there is at least one outstanding Sales %3 that includes this item.';
        Text002: Label 'You cannot delete %1 %2 because there are one or more outstanding production orders that include this item.';
        Text003: Label 'Do you want to change %1?';
        Text004: Label 'You cannot delete %1 %2 because there are one or more certified Production BOM that include this item.';
        Text006: Label 'Prices including VAT cannot be calculated when %1 is %2.';
        Text007: Label 'You cannot change %1 because there are one or more ledger entries for this item.';
        Text008: Label 'You cannot change %1 because there is at least one outstanding Purchase %2 that include this item.';
        Text014: Label 'You cannot delete %1 %2 because there are one or more production order component lines that include this item with a remaining quantity that is not 0.';
        Text016: Label 'You cannot delete %1 %2 because there are one or more outstanding transfer orders that include this item.';
        Text017: Label 'You cannot delete %1 %2 because there is at least one outstanding Service %3 that includes this item.';
        Text018: Label '%1 must be %2 in %3 %4 when %5 is %6.';
        Text019: Label 'You cannot change %1 because there are one or more open ledger entries for this item.';
        Text020: Label 'There may be orders and open ledger entries for the item. ';
        Text021: Label 'If you change %1 it may affect new orders and entries.\\';
        Text022: Label 'Do you want to change %1?';
        GLSetup: Record "General Ledger Setup";
        InvtSetup: Record "Inventory Setup";
        Text023: Label 'You cannot delete %1 %2 because there is at least one %3 that includes this item.';
        Text024: Label 'If you change %1 it may affect existing production orders.\';
        Text025: Label '%1 must be an integer because %2 %3 is set up to use %4.';
        Text026: Label '%1 cannot be changed because the %2 has work in process and changing the value may offset the WIP account.';
        Text7380: Label 'If you change the %1, the %2 is calculated.\Do you still want to change the %1?';
        Text7381: Label 'Cancelled.';
        Text99000000: Label 'The change will not affect existing entries.\';
        CommentLine: Record "Comment Line";
        Text99000001: Label 'If you want to generate %1 for existing entries, you must run a regenerative planning.';
        ItemVend: Record "Item Vendor";
        Text99000002: Label 'tracking,tracking and action messages';
        SalesPrice: Record "Sales Price";
        SalesLineDisc: Record "Sales Line Discount";
        SalesPrepmtPct: Record "Sales Prepayment %";
        PurchPrice: Record "Purchase Price";
        PurchLineDisc: Record "Purchase Line Discount";
        PurchPrepmtPct: Record "Purchase Prepayment %";
        ItemTranslation: Record "Item Translation";
        PurchOrderLine: Record "Purchase Line";
        SalesOrderLine: Record "Sales Line";
        VATPostingSetup: Record "VAT Posting Setup";
        ExtTextHeader: Record "Extended Text Header";
        GenProdPostingGrp: Record "Gen. Product Posting Group";
        ItemUnitOfMeasure: Record "Item Unit of Measure";
        ItemVariant: Record "Item Variant";
        ItemJnlLine: Record "Item Journal Line";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderComp: Record "Prod. Order Component";
        PlanningAssignment: Record "Planning Assignment";
        SKU: Record "Stockkeeping Unit";
        ItemTrackingCode: Record "Item Tracking Code";
        ItemTrackingCode2: Record "Item Tracking Code";
        ServInvLine: Record "Service Line";
        ItemSub: Record "Item Substitution";
        ItemCategory: Record "Item Category";
        TransLine: Record "Transfer Line";
        Vend: Record Vendor;
        NonstockItem: Record "Nonstock Item";
        ProdBOMHeader: Record "Production BOM Header";
        ProdBOMLine: Record "Production BOM Line";
        ItemIdent: Record "Item Identifier";
        RequisitionLine: Record "Requisition Line";
        ItemBudgetEntry: Record "Item Budget Entry";
        ItemAnalysisViewEntry: Record "Item Analysis View Entry";
        ItemAnalysisBudgViewEntry: Record "Item Analysis View Budg. Entry";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        MoveEntries: Codeunit MoveEntries;
        DimMgt: Codeunit DimensionManagement;
        NonstockItemMgt: Codeunit "Nonstock Item Management";
        ItemCostMgt: Codeunit ItemCostManagement;
        ResSkillMgt: Codeunit "Resource Skill Mgt.";
        MobSalesMgt: Codeunit "PWD Mobile Sales Management";
        HasInvtSetup: Boolean;
        TroubleshSetup: Record "Troubleshooting Setup";
        ServiceItem: Record "Service Item";
        ServiceContractLine: Record "Service Contract Line";
        ServiceItemComponent: Record "Service Item Component";
        ProductGrp: Record "Product Group";
        GLSetupRead: Boolean;
        Text25000: Label '%1 %2 already has a different value in %3. Do you want to continue?';


    procedure AssistEdit(): Boolean
    begin
    end;


    procedure FindItemVend(var ItemVend: Record "Item Vendor"; LocationCode: Code[10])
    var
        GetPlanningParameters: Codeunit "Planning-Get Parameters";
    begin
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
    end;


    procedure TestNoEntriesExist(CurrentFieldName: Text[100])
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
    end;


    procedure TestNoOpenEntriesExist(CurrentFieldName: Text[100])
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
    end;


    procedure ItemSKUGet(var Item: Record Item; LocationCode: Code[10]; VariantCode: Code[10])
    var
        SKU: Record "Stockkeeping Unit";
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
    var
        ReqLine: Record "Requisition Line";
    begin
    end;


    procedure PlanningReleaseQty() "Sum": Decimal
    var
        ReqLine: Record "Requisition Line";
    begin
    end;


    procedure CalcSalesReturn(): Decimal
    var
        SalesLine: Record "Sales Line";
    begin
    end;


    procedure CalcResvQtyOnSalesReturn(): Decimal
    var
        ReservationEntry: Record "Reservation Entry";
    begin
    end;


    procedure CalcPurchReturn(): Decimal
    var
        PurchLine: Record "Purchase Line";
    begin
    end;


    procedure CalcResvQtyOnPurchReturn(): Decimal
    var
        ReservationEntry: Record "Reservation Entry";
    begin
    end;


    procedure CheckSerialNoQty(ItemNo: Code[20]; FieldName: Text[30]; Quantity: Decimal)
    var
        ItemRec: Record Item;
        ItemTrackingCode3: Record "Item Tracking Code";
    begin
    end;


    procedure CheckForProductionOutput(ItemNo: Code[20])
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
    end;
}

