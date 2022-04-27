pageextension 50012 pageextension50012 extends "Routing Comment Sheet"
{
    layout
    {
        addafter("Control 6")
        {
            field("Routing No."; "Routing No.")
            {
                ApplicationArea = All;
            }
            field("Operation No."; "Operation No.")
            {
                ApplicationArea = All;
            }
            field("Line No."; "Line No.")
            {
                ApplicationArea = All;
            }
        }
    }
}

