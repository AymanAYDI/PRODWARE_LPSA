pageextension 60003 "PWD LocationList" extends "Location List"
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
    // +----------------------------------------------------------------------------------------------------------------+
    layout
    {
        addlast(Control1)
        {
            field("PWD WMS_Location"; Rec."PWD WMS_Location")
            {
                ApplicationArea = All;
            }
        }
    }
}

