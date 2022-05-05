pageextension 60080 "PWD PostedTransferShipments" extends "Posted Transfer Shipments"
{
    layout
    {
        addafter("Receipt Date")
        {
            field("PWD Transfer-to Name"; Rec."Transfer-to Name")
            {
                ApplicationArea = All;
            }
            field("PWD Transfer Order No."; Rec."Transfer Order No.")
            {
                ApplicationArea = All;
            }
            field("PWD Sales Order No."; Rec."PWD Sales Order No.")
            {
                ApplicationArea = All;
            }
        }
    }
}

