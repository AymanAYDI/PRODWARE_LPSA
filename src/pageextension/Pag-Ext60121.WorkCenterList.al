pageextension 60121 "PWD WorkCenterList" extends "Work Center List"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_PROD04.001: NI 13/12/2011:  FRAPPES - Temps de cycle incompressible
    //                                           - Add Action [Manufacturing cycles] on Page Actions
    // ------------------------------------------------------------------------------------------------------------------

    actions
    {


        addafter(Statistics)
        {
            action("PWD Manufacturing cycles")
            {
                Caption = 'Manufacturing cycles';
                RunObject = Page "PWD Manuf. cycles Setup - List";
                RunPageLink = Type = CONST("Work Center"), "No." = FIELD("No.");
                ApplicationArea = All;
                Image = Capacities;
            }
        }
    }

}

