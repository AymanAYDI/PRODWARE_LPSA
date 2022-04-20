pageextension 60007 "PWD VendorList" extends "Vendor List"
{
    layout
    {
        addafter(Name)
        {
            field("PWD Name 2"; "Name 2")
            {
                ApplicationArea = All;
            }
            field("PWD Address"; Address)
            {
                ApplicationArea = All;
            }
            field("PWD Address 2"; "Address 2")
            {
                ApplicationArea = All;
            }
            field("PWD City"; City)
            {
                ApplicationArea = All;
            }
            field("PWD Post Code"; "Post Code")
            {
                ApplicationArea = All;
            }
            field("PWD Country/Region Code"; "Country/Region Code")
            {
                ApplicationArea = All;
            }
            field("PWD E-Mail"; "E-Mail")
            {
                ApplicationArea = All;
            }
        }
    }
}

