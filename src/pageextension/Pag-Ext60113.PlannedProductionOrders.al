pageextension 60113 "PWD PlannedProductionOrders" extends "Planned Production Orders"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 24/10/2017 : DEMANDES DIVERSES
    //                   - Add Field Source Material Vendor
    layout
    {
        addafter("Bin Code")
        {
            field("PWD Source Material Vendor"; Rec."PWD Source Material Vendor")
            {
                ApplicationArea = All;
            }
        }
    }
}

