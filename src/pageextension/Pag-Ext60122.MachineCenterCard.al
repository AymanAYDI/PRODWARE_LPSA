pageextension 60122 "PWD MachineCenterCard" extends "Machine Center Card"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.6
    // OSYS-Int001.001:GR 21/10/2011   Connector integration
    //                                   - Add  field : Type
    // 
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
    //                                           - Add fields , "ResourceBehavior"
    //                                           - Add part "PlannerOne"
    // 
    // TDL.NAV : Suivi avancement sur Excel.
    //                                           - Add field 50000,50010,50020
    // 
    // ------------------------------------------------------------------------------------------------------------------
    // PLAW1 -----------------------------------------------------------------------------
    // PLAW1-4.0   06/02/2014 PO-3706 add setup parameter part
    // PLAW1 -----------------------------------------------------------------------------
    // 
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 27/04/2017 : FICHE SUIVEUSE - PP 1
    //                   - Add Field To Exclure In Tracking Card
    layout
    {
        addafter("Last Date Modified")
        {
            field("PWD Type"; Rec."PWD Type")
            {
                ApplicationArea = All;
            }
            field("PWD To Exclure In Tracking Card"; Rec."PWD To Excl. In Tracking Card")
            {
                ApplicationArea = All;
            }
        }
        addafter("Queue Time Unit of Meas. Code")
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
        }
    }
    actions
    {
        addafter(Statistics)
        {
            action("PWD Action1100294002")
            {
                Caption = 'Manufacturing cycles';
                RunObject = Page "PWD Manuf. cycles Setup - List";
                RunPageLink = Type = CONST("Machine Center"), "No." = FIELD("No.");
                ApplicationArea = All;
                Image = Capacities;
            }
        }
    }
}

