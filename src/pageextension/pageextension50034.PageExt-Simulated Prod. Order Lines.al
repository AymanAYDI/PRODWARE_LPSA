pageextension 50034 pageextension50034 extends "Simulated Prod. Order Lines"
{
    // PLAW1 -----------------------------------------------------------------------------
    // PLAW1-4.0 2014-02-21 PO-4400: enable assistEdit on UserColors for web client
    // PLAW1 -----------------------------------------------------------------------------
    layout
    {
        addafter("Control 8")
        {
            field("End Date Objective"; "End Date Objective")
            {
                ApplicationArea = All;
            }
        }
        addafter("Control 310")
        {
            field("Prod. Starting Date-Time"; "Prod. Starting Date-Time")
            {
                Editable = false;
                ApplicationArea = All;
            }
            field("Prod. Ending Date-Time"; "Prod. Ending Date-Time")
            {
                Editable = false;
                ApplicationArea = All;
            }
            field("Earliest Start Date"; "Earliest Start Date")
            {
                ApplicationArea = All;
            }
            field(PlannerOneCustom; PlannerOneCustom)
            {
                ApplicationArea = All;
            }
            field(PlannerOneCustom2; PlannerOneCustom2)
            {
                ApplicationArea = All;
            }
            field(SchedulingPriority; SchedulingPriority)
            {
                ApplicationArea = All;
            }
            field(UserColors; vUserColors)
            {
                AssistEdit = true;
                Caption = 'User Colors';
                ApplicationArea = All;

                trigger OnAssistEdit()
                var
                    Colors: Page "8076504";
                begin
                    //PLAW11.0
                    UpdateForm(TRUE);
                    COMMIT;
                    Colors.SETRECORD(Rec);
                    Colors.RUNMODAL();
                    //PLAW11.0 END
                end;
            }
            field(Customer; Customer)
            {
                ApplicationArea = All;
            }
            field(PublishedByPlannerOne; PublishedByPlannerOne)
            {
                Editable = false;
                ApplicationArea = All;
            }
            field(PlanningGroup; PlanningGroup)
            {
                Lookup = true;
                LookupPageID = PlannerOnePlanningGroupPS;
                ApplicationArea = All;
            }
            field("Manufacturing Code"; "Manufacturing Code")
            {
                ApplicationArea = All;
            }
        }
    }

    var
        vUserColors: Text[50];
        util: Codeunit "8076503";
        ApplicationManagement: Codeunit "1";


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    DescriptionIndent := 0;
    ShowShortcutDimCode(ShortcutDimCode);
    DescriptionOnFormat;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..3
    //PLAW11.0
    // PLAW12.2 Check LICENSE
    IF ApplicationManagement.CheckPlannerOneLicence THEN
    vUserColors := util.GetUserColors(Rec);
    //PLAW11.0 End
    */
    //end;

    //Unsupported feature: Deletion (VariableCollection) on "ShowTracking(PROCEDURE 5).TrackingForm(Variable 1000)".

}

