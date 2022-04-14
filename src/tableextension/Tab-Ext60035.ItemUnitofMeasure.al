tableextension 60035 "PWD ItemUnitofMeasure" extends "Item Unit of Measure"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.5
    // WMS-FE02.001:GR  01/07/2011   Connector integration
    //                              - Add fields:  "WMS_Type"
    //                                             "WMS_Stackable"
    //                                             "WMS_Log_unit_lower"
    // +----------------------------------------------------------------------------------------------------------------+
    fields
    {
        field(8073282; "PWD WMS_Type"; Enum "PWD WMS_Type")
        {
            Caption = 'WMS_Type';
        }
        field(8073283; "PWD WMS_Stackable"; Boolean)
        {
            Caption = 'WMS_Stackable';
            InitValue = true;
        }
        field(8073284; "PWD WMS_Item"; Boolean)
        {
            CalcFormula = Lookup(Item."PWD WMS_Item" WHERE("No." = FIELD("Item No.")));
            Caption = 'WMS_Item';
            FieldClass = FlowField;
        }
        field(8073285; "PWD WMS_Log_unit_lower"; Code[10])
        {
            Caption = 'Logistics unit lower';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
    }
}

