pageextension 50074 pageextension50074 extends "Posted Transfer Shipments"
{
    layout
    {
        addafter("Control 1102601007")
        {
            field("Transfer-to Name"; "Transfer-to Name")
            {
                ApplicationArea = All;
            }
            field("Transfer Order No."; "Transfer Order No.")
            {
                ApplicationArea = All;
            }
            field("Sales Order No."; "Sales Order No.")
            {
                ApplicationArea = All;
            }
        }
    }
}

