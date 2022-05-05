pageextension 60118 "PWD SalesQuoteArchives" extends "Sales Quote Archives"
{
    layout
    {
        addfirst(Control1)
        {
            field("PWD No."; Rec."No.")
            {
                ApplicationArea = All;
            }
        }
    }
}

