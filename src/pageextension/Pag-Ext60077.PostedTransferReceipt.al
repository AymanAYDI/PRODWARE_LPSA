pageextension 60077 "PWD PostedTransferReceipt" extends "Posted Transfer Receipt"
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
        addafter("Shortcut Dimension 2 Code")
        {
            field("PWD Sales Order No."; Rec."PWD Sales Order No.")
            {
                ApplicationArea = All;
            }
        }
    }
}

