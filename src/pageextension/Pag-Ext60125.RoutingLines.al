pageextension 60125 "PWD RoutingLines" extends "Routing Lines"
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
        modify("Operation No.")
        {
            Style = Attention;
            StyleExpr = BooGStyle;
        }
        modify("Previous Operation No.")
        {
            Style = Attention;
            StyleExpr = BooGStyle;
        }
        modify("Next Operation No.")
        {
            Style = Attention;
            StyleExpr = BooGStyle;
        }
        modify(Type)
        {
            Style = Attention;
            StyleExpr = BooGStyle;
        }
        modify("No.")
        {
            Style = Attention;
            StyleExpr = BooGStyle;
        }
        modify("Standard Task Code")
        {
            Style = Attention;
            StyleExpr = BooGStyle;
        }
        modify("Routing Link Code")
        {
            Style = Attention;
            StyleExpr = BooGStyle;
        }
        modify(Description)
        {
            Style = Attention;
            StyleExpr = BooGStyle;
        }
        modify("Setup Time")
        {
            Style = Attention;
            StyleExpr = BooGStyle;
        }
        modify("Setup Time Unit of Meas. Code")
        {
            Style = Attention;
            StyleExpr = BooGStyle;
        }
        modify("Run Time")
        {
            Style = Attention;
            StyleExpr = BooGStyle;
        }
        modify("Run Time Unit of Meas. Code")
        {
            Style = Attention;
            StyleExpr = BooGStyle;
        }
        modify("Wait Time")
        {
            Style = Attention;
            StyleExpr = BooGStyle;
        }
        modify("Wait Time Unit of Meas. Code")
        {
            Style = Attention;
            StyleExpr = BooGStyle;
        }
        modify("Move Time")
        {
            Style = Attention;
            StyleExpr = BooGStyle;
        }
        modify("Move Time Unit of Meas. Code")
        {
            Style = Attention;
            StyleExpr = BooGStyle;
        }
        modify("Fixed Scrap Quantity")
        {
            Style = Attention;
            StyleExpr = BooGStyle;
        }
        modify("Scrap Factor %")
        {
            Style = Attention;
            StyleExpr = BooGStyle;
        }
        modify("Minimum Process Time")
        {
            Style = Attention;
            StyleExpr = BooGStyle;
        }
        modify("Maximum Process Time")
        {
            Style = Attention;
            StyleExpr = BooGStyle;
        }
        modify("Concurrent Capacities")
        {
            Style = Attention;
            StyleExpr = BooGStyle;
        }
        modify("Send-Ahead Quantity")
        {
            Style = Attention;
            StyleExpr = BooGStyle;
        }
        modify("Unit Cost per")
        {
            Style = Attention;
            StyleExpr = BooGStyle;
        }
    }
    actions
    {
        modify("&Personnel")
        {
            Caption = '&Target measures';
            Visible = false;
        }
        addafter("&Quality Measures")
        {
            action("PWD Updateroutingsandprodorders")
            {
                Caption = 'Update routings and prod. orders.';
                Image= UpdateDescription;
                ApplicationArea = All;
                trigger OnAction()
                var
                    RecLRoutingLine: Record "Routing Line";
                    RepUpdate: Report "PWD Update Routing Line";
                begin
                    //>>TDL.LPSA.001
                    RecLRoutingLine.GET(Rec."Routing No.", Rec."Version Code", Rec."Operation No.");
                    RecLRoutingLine.SETRECFILTER();
                    RepUpdate.SETTABLEVIEW(RecLRoutingLine);
                    RepUpdate.RUNMODAL();
                    //<<TDL.LPSA.001
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    BEGIN
        BooGStyle := (Rec.Type = Rec.Type::"Machine Center");
    END;

    var
        [INDATASET]
        BooGStyle: Boolean;


}
