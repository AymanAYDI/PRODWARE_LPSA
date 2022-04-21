pageextension 60074 "PWD TransferOrders" extends "Transfer Orders"
{
    layout
    {
        addafter("Receipt Date")
        {
            field("PWD Sales Order No."; "PWD Sales Order No.")
            {
                ApplicationArea = All;
            }
            field("PWD Transfer-to Name"; "Transfer-to Name")
            {
                ApplicationArea = All;
            }
        }
    }
}

