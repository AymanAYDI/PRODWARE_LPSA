pageextension 60110 "PWD SalesQuotes" extends "Sales Quotes"
{
    // TDL.LPSA.05.10.15:NBO 05/10/15: Add Field 50005
    layout
    {
        addafter(Status)
        {
            field("PWD Validity Quote Date"; Rec."PWD Validity Quote Date")
            {
                ApplicationArea = All;
            }
            field("PWD Sell-to Address"; Rec."Sell-to Address")
            {
                ApplicationArea = All;
            }
            field("PWD Sell-to Address 2"; Rec."Sell-to Address 2")
            {
                ApplicationArea = All;
            }
            field("PWD Sell-to Post Code"; Rec."Sell-to Post Code")
            {
                ApplicationArea = All;
            }
            field("PWD Sell-to City"; Rec."Sell-to City")
            {
                ApplicationArea = All;
            }
            field("PWD Sell-to Contact"; Rec."Sell-to Contact")
            {
                ApplicationArea = All;
            }
        }
    }
}

