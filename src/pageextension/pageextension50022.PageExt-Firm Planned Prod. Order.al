pageextension 50022 pageextension50022 extends "Firm Planned Prod. Order"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //PLAW11.0
    // FE_Merge: TO 23/01/2012:  Merge of pbjects Planner One
    //                          - Add Part "Planner One"
    // 
    // //>>LAP2.06
    // FE_LAPRIERRETTE_GP0003 : APA 16/05/13 Add Etat des manquants
    // 
    // //>>LAP.TDL.NICO
    // 19/11/2014 : Add Item Card and Where-Used Pages in "Action page"
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 24/10/2017 : DEMANDES DIVERSES
    //                   - Add Field Source Material Vendor
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    layout
    {

        //Unsupported feature: Property Insertion (SubPageLink) on "ProdOrderLines(Control 26)".


        //Unsupported feature: Property Deletion (SubFormLink) on "ProdOrderLines(Control 26)".

        addafter("Control 15")
        {
            field("End Date Objective"; "End Date Objective")
            {
                ApplicationArea = All;
            }
        }
        addafter("Control 51")
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
        addafter("Control 49")
        {
            field("Transmitted Order No.";"Transmitted Order No.")
            {
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Insertion (RunPageLink) on "Action 62".


        //Unsupported feature: Property Insertion (RunPageLink) on "Action 60".


        //Unsupported feature: Property Insertion (RunPageLink) on "Action 67".


        //Unsupported feature: Property Deletion (RunFormLink) on "Action 62".


        //Unsupported feature: Property Deletion (RunFormLink) on "Action 60".


        //Unsupported feature: Property Deletion (RunFormLink) on "Action 67".

        addafter("Action 74")
        {
            action("<Action1100267004>")
            {
                Caption = 'Item Card';
                RunObject = Page 30;
                                RunPageLink = No.=FIELD(Source No.);
            }
            action("<Action1100267005>")
            {
                Caption = 'Prod. BOM Where-Used';

                trigger OnAction()
                var
                    RecLItem: Record "27";
                begin
                    //>>LPSA.TDL.19112014
                    IF ("Source Type"="Source Type"::Item) AND RecLItem.GET("Source No.") THEN BEGIN
                      ProdBOMWhereUsed.SetItem(RecLItem,WORKDATE);
                      ProdBOMWhereUsed.RUNMODAL;
                    END;
                    //<<LPSA.TDL.19112014
                end;
            }
        }
        addafter("Action 50")
        {
            action("Etat des manquants")
            {
                Caption = 'Etat des manquants';
                Ellipsis = true;
                Image = "Report";
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    RepLListMissing: Report "50020";
                                         RecLProdOrder: Record "5405";
                begin
                    CLEAR(RepLListMissing);
                    RecLProdOrder.SETRANGE(Status,Status);
                    RecLProdOrder.SETRANGE("No.","No.");
                    RepLListMissing.SETTABLEVIEW(RecLProdOrder);
                    RepLListMissing.RUNMODAL;
                end;
            }
        }
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

