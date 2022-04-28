pageextension 60130 "PWD RoutingCommentSheet" extends "Routing Comment Sheet"
{
    layout
    {
        addafter(Code)
        {
            field("PWD Routing No."; "Routing No.")
            {
                ApplicationArea = All;
            }
            field("PWD Operation No."; "Operation No.")
            {
                ApplicationArea = All;
            }
            field("PWD Line No."; "Line No.")
            {
                ApplicationArea = All;
            }
        }
    }
}

