pageextension 60134 "PWD ProductionOrderList" extends "Production Order List"
{
    // //>>LAP.TDL. NICO
    // 19/02/2015 : Add "Consumption Date"
    // 
    layout
    {
        addafter("Search Description")
        {
            field("PWD Consumption Date"; Rec."PWD Consumption Date")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {

    }
}

