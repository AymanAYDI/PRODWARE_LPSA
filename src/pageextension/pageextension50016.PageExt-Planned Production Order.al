pageextension 50016 pageextension50016 extends "Planned Production Order"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 24/10/2017 : DEMANDES DIVERSES
    //                   - Add Field Source Material Vendor
    layout
    {

        //Unsupported feature: Property Insertion (SubPageLink) on "ProdOrderLines(Control 26)".


        //Unsupported feature: Property Deletion (SubFormLink) on "ProdOrderLines(Control 26)".

        addafter("Control 36")
        {
            field("End Date Objective"; "End Date Objective")
            {
                ApplicationArea = All;
            }
        }
        addafter("Control 18")
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

        //Unsupported feature: Property Insertion (RunPageLink) on "Action 23".


        //Unsupported feature: Property Insertion (RunPageLink) on "Action 20".


        //Unsupported feature: Property Modification (Image) on "Action 54".


        //Unsupported feature: Property Insertion (RunPageLink) on "Action 54".


        //Unsupported feature: Property Deletion (RunFormLink) on "Action 23".


        //Unsupported feature: Property Deletion (RunFormLink) on "Action 20".


        //Unsupported feature: Property Deletion (RunFormLink) on "Action 54".

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


    //Unsupported feature: Code Modification on "ShortcutDimension1CodeOnAfterV(PROCEDURE 19029405)".

    //procedure ShortcutDimension1CodeOnAfterV();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        CurrPage.ProdOrderLines.FORM.UpdateForm(TRUE);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        CurrPage.ProdOrderLines.PAGE.UpdateForm(TRUE);
        */
    //end;


    //Unsupported feature: Code Modification on "ShortcutDimension2CodeOnAfterV(PROCEDURE 19008725)".

    //procedure ShortcutDimension2CodeOnAfterV();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        CurrPage.ProdOrderLines.FORM.UpdateForm(TRUE);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        CurrPage.ProdOrderLines.PAGE.UpdateForm(TRUE);
        */
    //end;
}

