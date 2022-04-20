pageextension 50119 pageextension50119 extends "Sales Order Archives"
{
    layout
    {
        addafter("Control 2")
        {
            field("No."; "No.")
            {
                Editable = false;
                ApplicationArea = All;
            }
        }
        addafter("Control 6")
        {
            field(Amount; Amount)
            {
                ApplicationArea = All;
            }
        }
        addafter("Control 1102601009")
        {
            field("Order Date"; "Order Date")
            {
                ApplicationArea = All;
            }
        }
    }
}

