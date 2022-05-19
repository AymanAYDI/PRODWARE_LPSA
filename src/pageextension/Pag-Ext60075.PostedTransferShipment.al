pageextension 60075 "PWD PostedTransferShipment" extends "Posted Transfer Shipment"
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
