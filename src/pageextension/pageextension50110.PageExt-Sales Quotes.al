pageextension 50110 pageextension50110 extends "Sales Quotes"
{
    // TDL.LPSA.05.10.15:NBO 05/10/15: Add Field 50005
    layout
    {
        addafter("Control 1102601007")
        {
            field("Validity Quote Date"; "Validity Quote Date")
            {
                ApplicationArea = All;
            }
            field("Sell-to Address"; "Sell-to Address")
            {
                ApplicationArea = All;
            }
            field("Sell-to Address 2"; "Sell-to Address 2")
            {
                ApplicationArea = All;
            }
            field("Sell-to Post Code"; "Sell-to Post Code")
            {
                ApplicationArea = All;
            }
            field("Sell-to City"; "Sell-to City")
            {
                ApplicationArea = All;
            }
            field("Sell-to Contact"; "Sell-to Contact")
            {
                ApplicationArea = All;
            }
        }
    }
}

