pageextension 50062 pageextension50062 extends "Location Card"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.5
    // WMS-FE10.001:GR 01/07/2011   Connector integration
    //                              - Add field "WMS_Location"
    // 
    // //>>LAP2.05
    // FE_LAPIERRETTE_NDT01.001: LY 17/04/2013:  New Demand
    //                                           Add fields
    //                                             "Req. Wksh. Template"
    //                                             "Req. Wksh. Name"
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    layout
    {
        addafter("Control 24")
        {
            field(WMS_Location; WMS_Location)
            {
                ApplicationArea = All;
            }
            field("Req. Wksh. Template"; "Req. Wksh. Template")
            {
                ApplicationArea = All;
            }
            field("Req. Wksh. Name"; "Req. Wksh. Name")
            {
                ApplicationArea = All;
            }
        }
    }
}

