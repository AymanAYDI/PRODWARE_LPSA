pageextension 60125 "PWD RoutingLines" extends "Routing Lines"
{
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
                ApplicationArea = All;
                trigger OnAction()
                var
                    RecLRoutingLine: Record "Routing Line";
                    RepUpdate: Report "PWD Update Routing Line";
                begin
                    //>>TDL.LPSA.001
                    RecLRoutingLine.GET("Routing No.", "Version Code", "Operation No.");
                    RecLRoutingLine.SETRECFILTER;
                    RepUpdate.SETTABLEVIEW(RecLRoutingLine);
                    RepUpdate.RUNMODAL;
                    //<<TDL.LPSA.001
                end;
            }
        }
    }
}
