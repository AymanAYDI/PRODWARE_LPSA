pageextension 60017 "PWD SalesOrders" extends "Sales Orders"
{
    layout
    {
        addafter("No.")
        {
            field("PWD Requested Delivery Date"; Rec."Requested Delivery Date")
            {
                ApplicationArea = All;
            }
            field("PWD Cust Promised Delivery Date"; Rec."PWD Cust Promis. Delivery Date")
            {
                ApplicationArea = All;
            }
        }
    }
}

