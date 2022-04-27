pageextension 50030 pageextension50030 extends "Finished Production Order"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 12/09/2017 : DEMANDES DIVERSES
    //                   - Add Field Source Material Vendor
    layout
    {

        //Unsupported feature: Property Insertion (SubPageLink) on "ProdOrderLines(Control 26)".


        //Unsupported feature: Property Deletion (SubFormLink) on "ProdOrderLines(Control 26)".

        addafter("Control 44")
        {
            field("End Date Objective"; "End Date Objective")
            {
                ApplicationArea = All;
            }
        }
        addafter("Control 45")
        {
            field("Source Material Vendor"; "Source Material Vendor")
            {
                ApplicationArea = All;
            }
        }
        addafter(ProdOrderLines)
        {
            part(PlannerOne; 8076500)
            {
                Caption = 'PlannerOne Production Scheduler';
                SubPageLink = No.=                ApplicationArea = All;
FIELD(No.)    ApplicationArea = All;
,Status=FIELD(Status);
                Visible = PlannerOneEnabled;
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Insertion (RunPageView) on "Action 49".


        //Unsupported feature: Property Insertion (RunPageLink) on "Action 49".


        //Unsupported feature: Property Insertion (RunPageView) on "Action 66".


        //Unsupported feature: Property Insertion (RunPageLink) on "Action 66".


        //Unsupported feature: Property Insertion (RunPageView) on "Action 76".


        //Unsupported feature: Property Insertion (RunPageLink) on "Action 76".


        //Unsupported feature: Property Insertion (RunPageView) on "Action 7300".


        //Unsupported feature: Property Insertion (RunPageLink) on "Action 7300".


        //Unsupported feature: Property Insertion (RunPageLink) on "Action 69".


        //Unsupported feature: Property Insertion (RunPageLink) on "Action 162".


        //Unsupported feature: Property Modification (Image) on "Action 71".


        //Unsupported feature: Property Insertion (RunPageLink) on "Action 71".


        //Unsupported feature: Property Insertion (RunPageView) on "Action 7301".


        //Unsupported feature: Property Insertion (RunPageLink) on "Action 7301".


        //Unsupported feature: Property Deletion (RunFormView) on "Action 49".


        //Unsupported feature: Property Deletion (RunFormLink) on "Action 49".


        //Unsupported feature: Property Deletion (RunFormView) on "Action 66".


        //Unsupported feature: Property Deletion (RunFormLink) on "Action 66".


        //Unsupported feature: Property Deletion (RunFormView) on "Action 76".


        //Unsupported feature: Property Deletion (RunFormLink) on "Action 76".


        //Unsupported feature: Property Deletion (RunFormView) on "Action 7300".


        //Unsupported feature: Property Deletion (RunFormLink) on "Action 7300".


        //Unsupported feature: Property Deletion (RunFormLink) on "Action 69".


        //Unsupported feature: Property Deletion (RunFormLink) on "Action 162".


        //Unsupported feature: Property Deletion (RunFormLink) on "Action 71".


        //Unsupported feature: Property Deletion (RunFormView) on "Action 7301".


        //Unsupported feature: Property Deletion (RunFormLink) on "Action 7301".

    }

    var
        [InDataSet]
        PlannerOneEnabled: Boolean;
        P1Setup: Record "8076502";
        ApplicationManagement: Codeunit "1";


    //Unsupported feature: Code Insertion on "OnInit".

    //trigger OnInit()
    //Parameters and return type have not been exported.
    //begin
        /*
        // PLAW1 2.0
        // PLAW12.2 Check LICENSE
        IF ApplicationManagement.CheckPlannerOneLicence AND P1Setup.FINDFIRST() AND P1Setup.ProductionSchedulerEnabled THEN
          PlannerOneEnabled := TRUE
        ELSE
          PlannerOneEnabled := FALSE;
        // PLAW1 END
        */
    //end;
}

