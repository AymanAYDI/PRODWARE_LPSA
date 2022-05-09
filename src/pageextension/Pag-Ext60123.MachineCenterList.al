pageextension 60123 "PWD MachineCenterList" extends "Machine Center List"
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
    // TDL.NAV : Suivi avancement sur Excel.
    //                                           - Add field 50000,50010,50020
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 14/06/2017 :  DEMANDES DIVERSES
    //                - Add Field "To Exclure In Tracking Card"
    // 
    // ------------------------------------------------------------------------------------------------------------------


    layout
    {
        addafter("Flushing Method")
        {
            field("PWD Planning"; Rec."PWD Planning")
            {
                ApplicationArea = All;
            }
            field("PWD Planning Status Name"; Rec."PWD Planning Status Name")
            {
                ApplicationArea = All;
            }
            field("PWD Planning Order No."; Rec."PWD Planning Order No.")
            {
                ApplicationArea = All;
            }
            field("PWD To Exclure In Tracking Card"; Rec."PWD To Excl. In Tracking Card")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {

        addafter(Statistics)
        {
            action("PWD Manufacturing cycles")
            {
                Caption = 'Manufacturing cycles';
                RunObject = Page "PWD Manuf. cycles Setup - List";
                RunPageLink = Type = CONST("Machine Center"), "No." = FIELD("No.");
                ApplicationArea = All;
                Image= Capacities;
            }
        }
    }

}

