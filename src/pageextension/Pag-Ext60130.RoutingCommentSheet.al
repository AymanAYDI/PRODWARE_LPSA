pageextension 60130 "PWD RoutingCommentSheet" extends "Routing Comment Sheet"
{
    layout
    {
        addafter(Code)
        {
            field("PWD Routing No."; Rec."Routing No.")
            {
                ApplicationArea = All;
            }
            field("PWD Operation No."; Rec."Operation No.")
            {
                ApplicationArea = All;
            }
            field("PWD Line No."; Rec."Line No.")
            {
                ApplicationArea = All;
            }
        }
    }
}

