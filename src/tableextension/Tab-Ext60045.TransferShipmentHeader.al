tableextension 60045 "PWD TransferShipmentHeader" extends "Transfer Shipment Header"
{
    // ------------------------------------------------------------------------------------------------------------------------------------
    // Prodware : www.prodware.fr
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 
    // //>>LAP2.00
    //       -Add Field "Sales Order No." ID : 50005
    // 
    // ------------------------------------------------------------------------------------------------------------------------------------
    fields
    {
        field(50005; "PWD Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            Description = 'LAP2.00';
            Editable = false;
            DataClassification = CustomerContent;
        }
    }
}

