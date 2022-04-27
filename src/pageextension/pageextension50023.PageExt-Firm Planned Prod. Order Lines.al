pageextension 50023 pageextension50023 extends "Firm Planned Prod. Order Lines"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //PLAW11.0
    // FE_Merge: TO 23/01/2012:  Merge of pbjects Planner One
    //                          - Add fields:  "Prod. Starting Date-Time"
    //                                         "Prod. Ending Date-Time"
    //                                         "Earliest Start Date"
    //                                         PlannerOneCustom
    //                                         SchedulingPriority
    // //>>LAP2.06
    // FE_LAPRIERRETTE_GP0003 : APA 16/05/13 Add ExistPhantomItem
    // 
    // +----------------------------------------------------------------------------------------------------------------+
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
        addafter("Control 32")
        {
            field(ExistPhantomItem; ExistPhantomItem)
            {
                Caption = 'Phantom Item';
                ApplicationArea = All;
            }
        }
        addafter("Control 310")
        {
            field(SchedulingPriority; SchedulingPriority)
            {
                Caption = 'Scheduling Priority';
                ApplicationArea = All;
            }
            field(DatGHeureDeb; DatGHeureDeb)
            {
                Caption = 'Launch. Prod. Starting Date-Time';
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
            field("Planning Level Code"; "Planning Level Code")
            {
                ApplicationArea = All;
            }
        }
    }

    var
        RecLRoutingLine: Record "5409";
        CodLienGamme: Code[20];
        BooLFound: Boolean;

    var
        vUserColors: Text[50];
        util: Codeunit "8076503";
        ApplicationManagement: Codeunit "1";
        DatGHeureDeb: DateTime;


    //Unsupported feature: Code Insertion (VariableCollection) on "OnAfterGetRecord".

    //trigger (Variable: RecLRoutingLine)()
    //Parameters and return type have not been exported.
    //begin
    /*
    */
    //end;


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

    //>>LPSA
    CLEAR(DatGHeureDeb);
    CLEAR(BooLFound);
    CLEAR(CodLienGamme);
    RecLRoutingLine.RESET;
    RecLRoutingLine.SETRANGE(Status,Status);
    RecLRoutingLine.SETRANGE("Prod. Order No.","Prod. Order No.");
    IF RecLRoutingLine.FINDSET THEN
      REPEAT
        IF CodLienGamme <> '' THEN BEGIN
          DatGHeureDeb := RecLRoutingLine."Starting Date-Time";
          BooLFound := FALSE;
        END;
        CodLienGamme := RecLRoutingLine."Routing Link Code";
      UNTIL (RecLRoutingLine.NEXT = 0) OR BooLFound;
    //<<LPSA
    */
    //end;

    //Unsupported feature: Deletion (VariableCollection) on "ShowTracking(PROCEDURE 3).TrackingForm(Variable 1000)".

}

