tableextension 60005 "PWD ItemLedgerEntry" extends "Item Ledger Entry"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.6
    // OSYS-Int001.001:GR 24/10/2011   Connector integration
    //                                - Add key: Open,Item Tracking,Item No.,Variant Code,Lot No.,Serial No.
    // 
    // //>>LAP2.00
    // FE_LAPIERRETTE_PRO06.001: TO 19/01/2012: Bilan production par commande
    //                                         - Add key: Item No.,Prod. Order No.,Entry Type
    // 
    // //>>LAP2.05
    // FE_LAPIERRETTE_PRO12.001: GR 09/10/2012: Non Conformite
    //                                          - Add Field
    //                                            NC  No Editable
    // 
    // //>>HOTLINE
    // cf TI468326 : LALE.RO : 11/09/2019
    //          - Add key: Item No.,Posting Date,Entry Type,Variant Code,Drop Shipment,Location Code
    // 
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    fields
    {
        field(50000; "PWD NC"; Boolean)
        {
            Description = 'LAP2.05';
            Editable = false;
        }
        field(50001; "PWD Designation LPSA1"; Text[120])
        {
            CalcFormula = Lookup(Item."PWD LPSA Description 1" WHERE("No." = FIELD("Item No.")));
            Description = 'SU';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002; "PWD Nom Client"; Text[100])
        {
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Source No.")));
            Description = 'SU';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50003; "PWD Nom Fournisseur"; Text[100])
        {
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("Source No.")));
            Description = 'SU';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004; "PWD Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "PWD Product Group".Code WHERE("Item Category Code" = FIELD("Item Category Code"));
        }
    }
    keys
    {
        key(Key50000; Open, "Item Tracking", "Item No.", "Variant Code", "Lot No.", "Serial No.")
        {
            SumIndexFields = "Remaining Quantity";
        }
        key(Key50001; "Item No.", "Order No.", "Entry Type")
        {
            SumIndexFields = Quantity;
        }
        key(Key50002; "Item No.", "Posting Date", "Entry Type", "Variant Code", "Drop Shipment", "Location Code")
        {
        }
        key(Key50003; "Item No.", "Lot No.")
        {
            SumIndexFields = Quantity;
        }
    }
}

