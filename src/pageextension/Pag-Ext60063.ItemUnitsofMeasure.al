pageextension 60063 "PWD ItemUnitsofMeasure" extends "Item Units of Measure"
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
    layout
    {
        addafter(Weight)
        {
            field("PWD WMS_Type"; Rec."PWD WMS_Type")
            {
                ApplicationArea = All;
            }
            field("PWD WMS_Stackable"; Rec."PWD WMS_Stackable")
            {
                ApplicationArea = All;
            }
            field("PWD WMS_Log_unit_lower"; Rec."PWD WMS_Log_unit_lower")
            {
                ApplicationArea = All;
            }
        }
    }
}

