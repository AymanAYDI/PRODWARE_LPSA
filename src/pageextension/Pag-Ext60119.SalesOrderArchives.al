pageextension 60119 "PWD SalesOrderArchives" extends "Sales Order Archives"
{
    layout
    {
        addafter("Version No.")
        {
            field("PWD No."; "No.")
            {
                Editable = false;
                ApplicationArea = All;
            }
        }
        addafter("Time Archived")
        {
            field("PWD Amount"; Amount)
            {
                ApplicationArea = All;
            }
        }
        addafter("Due Date")
        {
            field("PWD Order Date"; "Order Date")
            {
                ApplicationArea = All;
            }
        }
    }
}

