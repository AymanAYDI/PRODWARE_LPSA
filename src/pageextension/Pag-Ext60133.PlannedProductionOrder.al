pageextension 60133 "PWD PlannedProductionOrder" extends "Planned Production Order"
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


        addafter("Last Date Modified")
        {
            field("PWD Source Material Vendor"; "PWD Source Material Vendor")
            {
                ApplicationArea = All;
            }
        }
    }
}

