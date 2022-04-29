pageextension 60126 "PWD RoutingVersionLines" extends "Routing Version Lines"
{
    layout
    {
        addafter("Unit Cost per")
        {
            field("PWD Fixed-step Prod. Rate time"; "PWD Fixed-step Prod. Rate time")
            {
                ApplicationArea = All;
            }
            field("PWD Flushing Method"; "PWD Flushing Method")
            {
                ApplicationArea = All;
            }
        }
    }
}
