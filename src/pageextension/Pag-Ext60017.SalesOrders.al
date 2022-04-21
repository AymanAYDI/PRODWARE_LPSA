pageextension 60017 "PWD SalesOrders" extends "Sales Orders"
{
    layout
    {
        addafter("No.")
        {
            field("PWD Requested Delivery Date"; "Requested Delivery Date")
            {
                ApplicationArea = All;
            }
            field("PWD Cust Promised Delivery Date"; "PWD Cust Promised Delivery Date")
            {
                ApplicationArea = All;
            }
        }
    }
}
