pageextension 50066 pageextension50066 extends "Transfer Order"
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
        addafter("Control 6")
        {
            field("Sales Order No."; "Sales Order No.")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunFormLink) on "Action 28".

    }
}

