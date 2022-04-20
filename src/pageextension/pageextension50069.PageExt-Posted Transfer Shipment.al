pageextension 50069 pageextension50069 extends "Posted Transfer Shipment"
{
    // ------------------------------------------------------------------------------------------------------------------------------------
    // Prodware : www.prodware.fr
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 
    // //>>LAP2.00
    //       -Add Field "Sales Order No."
    // 
    // ------------------------------------------------------------------------------------------------------------------------------------
    layout
    {
        addafter("Control 14")
        {
            field("Sales Order No."; "Sales Order No.")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunFormLink) on "Action 57".

    }
}

