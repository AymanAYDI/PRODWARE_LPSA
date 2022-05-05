pageextension 60119 "PWD SalesOrderArchives" extends "Sales Order Archives"
{
    layout
    {
        addafter("Version No.")
        {
            field("PWD No."; Rec."No.")
            {
                Editable = false;
                ApplicationArea = All;
            }
        }
        addafter("Time Archived")
        {
            field("PWD Amount"; Rec.Amount)
            {
                ApplicationArea = All;
            }
        }
        addafter("Due Date")
        {
            field("PWD Order Date"; Rec."Order Date")
            {
                ApplicationArea = All;
            }
        }
    }
}

