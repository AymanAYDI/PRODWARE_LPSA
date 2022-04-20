pageextension 50056 pageextension50056 extends "Item Units of Measure"
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
        addafter("Control 19")
        {
            field(WMS_Type; WMS_Type)
            {
                ApplicationArea = All;
            }
            field(WMS_Stackable; WMS_Stackable)
            {
                ApplicationArea = All;
            }
            field(WMS_Log_unit_lower; WMS_Log_unit_lower)
            {
                ApplicationArea = All;
            }
        }
    }
}

