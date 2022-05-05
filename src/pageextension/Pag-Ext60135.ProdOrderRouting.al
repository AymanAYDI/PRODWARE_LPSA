pageextension 60135 "PWD ProdOrderRouting" extends "Prod. Order Routing"
{
    layout
    {
        addbefore("Flushing Method")
        {
            field("PWD Status"; Rec.Status)
            {
                ApplicationArea = All;
            }
        }
        addafter("Routing Status")
        {
            field("PWD Input Quantity"; Rec."Input Quantity")
            {
                ApplicationArea = All;
            }
            field("Starting Date-Time (P1)"; Rec."PWD Start. Date-Time (P1)")
            {
                ApplicationArea = All;
            }
            field("Ending Date-Time (P1)"; Rec."PWD End. Date-Time (P1)")
            {
                ApplicationArea = All;
            }
            field("PWD Routing Link Code"; Rec."Routing Link Code")
            {
                ApplicationArea = All;
            }
        }
        modify("Flushing Method")
        {
            visible = false;
        }
    }
}
