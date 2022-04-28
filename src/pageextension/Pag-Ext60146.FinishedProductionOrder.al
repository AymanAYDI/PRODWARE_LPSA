pageextension 60146 "PWD FinishedProductionOrder" extends "Finished Production Order"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 12/09/2017 : DEMANDES DIVERSES
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
    actions
    {

    }
}

