pageextension 50071 pageextension50071 extends "Posted Transfer Receipt"
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

