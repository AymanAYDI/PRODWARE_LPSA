pageextension 60116 "PWD FinishedProductionOrders" extends "Finished Production Orders"
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
        addfirst(Control1)
        {
            field("PWD Source Material Vendor"; Rec."PWD Source Material Vendor")
            {
                ApplicationArea = All;
            }
        }
        addafter("Bin Code")
        {
            field("PWD Consumption Date"; Rec."PWD Consumption Date")
            {
                ApplicationArea = All;
            }
        }
    }
}

