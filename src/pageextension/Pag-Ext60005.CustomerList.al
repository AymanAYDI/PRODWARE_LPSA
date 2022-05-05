pageextension 60005 "PWD CustomerList" extends "Customer List"
{
    layout
    {
        addafter(Name)
        {
            field("PWD Name 2"; Rec."Name 2")
            {
                ApplicationArea = All;
            }
            field("PWD Address"; Rec.Address)
            {
                ApplicationArea = All;
            }
            field("PWD Address 2"; Rec."Address 2")
            {
                ApplicationArea = All;
            }
            field("PWD City"; Rec.City)
            {
                ApplicationArea = All;
            }
            field("PWD Post Code"; Rec."Post Code")
            {
                ApplicationArea = All;
            }
            field("PWD Country/Region Code"; Rec."Country/Region Code")
            {
                ApplicationArea = All;
            }
            field("PWD E-Mail"; Rec."E-Mail")
            {
                ApplicationArea = All;
            }
        }
    }
}

