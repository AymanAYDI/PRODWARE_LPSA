pageextension 60126 "PWD RoutingVersionLines" extends "Routing Version Lines"
{
    layout
    {
        addafter("Unit Cost per")
        {
            field("PWD Fixed-step Prod. Rate time"; Rec."PWD Fixed-step Prod. Rate time")
            {
                ApplicationArea = All;
            }
            field("PWD Flushing Method"; Rec."PWD Flushing Method")
            {
                ApplicationArea = All;
            }
        }
    }
}
