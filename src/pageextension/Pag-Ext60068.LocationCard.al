pageextension 60068 "PWD LocationCard" extends "Location Card"
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
        addafter("Use As In-Transit")
        {
            field("PWD WMS_Location"; Rec."PWD WMS_Location")
            {
                ApplicationArea = All;
            }
            field("PWD Req. Wksh. Template"; Rec."PWD Req. Wksh. Template")
            {
                ApplicationArea = All;
            }
            field("PWD Req. Wksh. Name"; Rec."PWD Req. Wksh. Name")
            {
                ApplicationArea = All;
            }
        }
    }
}

