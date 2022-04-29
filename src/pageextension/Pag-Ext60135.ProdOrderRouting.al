pageextension 60135 "PWD ProdOrderRouting" extends "Prod. Order Routing"
{
    layout
    {
        addbefore("Flushing Method")
        {
            field("PWD Status"; Status)
            {
                ApplicationArea = All;
            }
        }
        addafter("Routing Status")
        {
            field("PWD Input Quantity"; "Input Quantity")
            {
                ApplicationArea = All;
            }
            field("Starting Date-Time (P1)"; "PWD Start. Date-Time (P1)")
            {
                ApplicationArea = All;
            }
            field("Ending Date-Time (P1)"; "PWD End. Date-Time (P1)")
            {
                ApplicationArea = All;
            }
            field("PWD Routing Link Code"; "Routing Link Code")
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
