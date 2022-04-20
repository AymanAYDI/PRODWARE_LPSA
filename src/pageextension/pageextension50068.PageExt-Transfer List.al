pageextension 50068 pageextension50068 extends "Transfer List"
{
    layout
    {
        addafter("Control 1102601029")
        {
            field("Sales Order No."; "Sales Order No.")
            {
                ApplicationArea = All;
            }
            field("Transfer-to Name"; "Transfer-to Name")
            {
                ApplicationArea = All;
            }
        }
    }
}

