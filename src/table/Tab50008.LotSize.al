table 50008 "PWD Lot Size"
{
    // +----------------------------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                                         |
    // | www.prodware.fr                                                                                                                  |
    // +----------------------------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.01
    // FE_LAPIERRETTE_PRO08.001: GR 15/02/2012: Multiple Standard Cost Calculate
    //                                          Creation
    // 
    // +----------------------------------------------------------------------------------------------------------------------------------+


    fields
    {
        field(1; "Item Category Code"; Code[10])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(2; "Minimum Lot Qty."; Decimal)
        {
            Caption = 'Lot Minimum Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(3; "Maximum Lot Qty."; Decimal)
        {
            Caption = 'Lot Maximum Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(4; "Lot Size"; Decimal)
        {
            Caption = 'Lot Size';
            DecimalPlaces = 0 : 5;
            MinValue = 1;
        }
    }

    keys
    {
        key(Key1; "Item Category Code", "Lot Size")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

