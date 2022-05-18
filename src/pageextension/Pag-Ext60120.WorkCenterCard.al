pageextension 60120 "PWD WorkCenterCard" extends "Work Center Card"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_PROD04.001: NI 13/12/2011:  FRAPPES - Temps de cycle incompressible
    //                                           - Add Action [Manufacturing cycles] on Page Actions
    // 
    // //PLAW11.0
    // FE_Merge: TO 23/01/2012:  Merge of pbjects Planner One
    //                                           - Add fields "MoveUseCalendars", "ResourceBehavior"
    //                                           - Add part "PlannerOne"
    // 
    // ------------------------------------------------------------------------------------------------------------------
    // PLAW1 -----------------------------------------------------------------------------
    // PLAW1-4.0   06/02/2014 PO-3706 add setup parameter part
    // PLAW1 -----------------------------------------------------------------------------
    layout
    {
    }
    actions
    {

        addafter(Statistics)
        {
            action("PWD Manufacturing cycles")
            {
                Caption = 'Manufacturing cycles';
                RunObject = Page "PWD Manuf. cycles Setup - List";
                RunPageLink = Type = CONST("Work Center"), "No." = FIELD("No.");
                ApplicationArea = all;
                Image = Capacities;
            }
        }
    }
}

