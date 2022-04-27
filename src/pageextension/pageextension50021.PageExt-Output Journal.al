pageextension 50021 pageextension50021 extends "Output Journal"
{
    // +----------------------------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                                         |
    // | www.prodware.fr                                                                                                                  |
    // +----------------------------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_PROD02.001: NI 28/11/2011:  Commentaire sur feuille production
    //                                           - Display field 50000
    // 
    // FE_LAPIERRETTE_PROD03.001: NI 07/12/2011:  Conformité qualité cloture OF
    //                                           - Display field 50001
    //                                           - C/AL added in PageActions - Post
    //                                                           PageActions - Post and print
    //                                           - Add fucntions FctCheckControlQuality()
    //                                                           FctExistControlQuality()
    // 
    // //>>LAP2.05
    // FE_LAPIERRETTE_PRO12.001: GR 09/10/2012: Non Conformite
    //                                          Deactivate Code from PROD03
    //                                          Modify C/AL Code On Post
    // 
    // +----------------------------------------------------------------------------------------------------------------------------------+
    layout
    {
        addafter("Control 136")
        {
            field("Quartis Comment"; "Quartis Comment")
            {
                ApplicationArea = All;
            }
            field("Conform quality control"; "Conform quality control")
            {
                ApplicationArea = All;
            }
            field("Inventory Posting Group"; "Inventory Posting Group")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Insertion (RunPageLink) on "Action 44".


        //Unsupported feature: Property Insertion (RunPageView) on "Action 46".


        //Unsupported feature: Property Insertion (RunPageLink) on "Action 46".


        //Unsupported feature: Property Insertion (RunPageLink) on "Action 19".


        //Unsupported feature: Property Insertion (RunPageView) on "Action 21".


        //Unsupported feature: Property Insertion (RunPageLink) on "Action 21".


        //Unsupported feature: Property Insertion (RunPageView) on "Action 22".


        //Unsupported feature: Property Insertion (RunPageLink) on "Action 22".


        //Unsupported feature: Property Insertion (RunPageView) on "Action 25".


        //Unsupported feature: Property Insertion (RunPageLink) on "Action 25".


        //Unsupported feature: Property Deletion (RunFormLink) on "Action 44".


        //Unsupported feature: Property Deletion (RunFormView) on "Action 46".


        //Unsupported feature: Property Deletion (RunFormLink) on "Action 46".


        //Unsupported feature: Property Deletion (RunFormLink) on "Action 19".


        //Unsupported feature: Property Deletion (RunFormView) on "Action 21".


        //Unsupported feature: Property Deletion (RunFormLink) on "Action 21".


        //Unsupported feature: Property Deletion (RunFormView) on "Action 22".


        //Unsupported feature: Property Deletion (RunFormLink) on "Action 22".


        //Unsupported feature: Property Deletion (RunFormView) on "Action 25".


        //Unsupported feature: Property Deletion (RunFormLink) on "Action 25".



        //Unsupported feature: Code Insertion (VariableCollection) on "Action 56.OnAction".

        //trigger (Variable: RecLManufacturingSetup)()
        //Parameters and return type have not been exported.
        //begin
        /*
        */
        //end;


        //Unsupported feature: Code Modification on "Action 56.OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post",Rec);
        CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
        CurrPage.UPDATE(FALSE);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        //>>FE_LAPIERRETTE_PROD03.001
        RecLManufacturingSetup.GET;
        //>>FE_LAPIERRETTE_PRO12.001
        //RecLManufacturingSetup.TESTFIELD("Non conformity Prod. Location");
        //<<FE_LAPIERRETTE_PRO12.001
        RecLManufacturingSetup.TESTFIELD("Mach. center - Inventory input");
        RecLItemJnlLineCopy.COPY(Rec);
        IF FctExistControlQuality(RecLItemJnlLineCopy,RecLManufacturingSetup."Mach. center - Inventory input") THEN
          IF NOT FctCheckControlQuality(RecLItemJnlLineCopy,
                                        RecLManufacturingSetup."Mach. center - Inventory input") THEN
            //>>FE_LAPIERRETTE_PRO12.001
            //IF NOT CONFIRM(STRSUBSTNO(CstG00001,RecLManufacturingSetup."Non conformity Prod. Location")) THEN
            IF NOT CONFIRM(CstG00002) THEN
            //<<FE_LAPIERRETTE_PRO12.001
              EXIT;
        //<<FE_LAPIERRETTE_PROD03.001

        #1..3
        */
        //end;


        //Unsupported feature: Code Insertion (VariableCollection) on "Action 57.OnAction".

        //trigger (Variable: RecLManufacturingSetup)()
        //Parameters and return type have not been exported.
        //begin
        /*
        */
        //end;


        //Unsupported feature: Code Modification on "Action 57.OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post+Print",Rec);
        CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
        CurrPage.UPDATE(FALSE);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        //>>FE_LAPIERRETTE_PROD03.001
        RecLManufacturingSetup.GET;
        //>>FE_LAPIERRETTE_PRO12.001
        //RecLManufacturingSetup.TESTFIELD("Non conformity Prod. Location");
        //<<FE_LAPIERRETTE_PRO12.001
        RecLManufacturingSetup.TESTFIELD("Mach. center - Inventory input");
        RecLItemJnlLineCopy.COPY(Rec);
        IF FctExistControlQuality(RecLItemJnlLineCopy,RecLManufacturingSetup."Mach. center - Inventory input") THEN
          IF NOT FctCheckControlQuality(RecLItemJnlLineCopy,
                                        RecLManufacturingSetup."Mach. center - Inventory input") THEN
            //>>FE_LAPIERRETTE_PRO12.001
            //IF NOT CONFIRM(STRSUBSTNO(CstG00001,RecLManufacturingSetup."Non conformity Prod. Location")) THEN
            IF NOT CONFIRM(CstG00002) THEN
            //<<FE_LAPIERRETTE_PRO12.001
              EXIT;
        //<<FE_LAPIERRETTE_PROD03.001

        #1..3
        */
        //end;
    }

    var
        RecLManufacturingSetup: Record "99000765";
        RecLItemJnlLineCopy: Record "83";

    var
        RecLManufacturingSetup: Record "99000765";
        RecLItemJnlLineCopy: Record "83";

    var
        "--FE_LAPIERRETTE_PROD03--": ;
        CstG00001: Label 'The quality control for the Prod. Order is non conform.\Do you want to post the manufactured items in the %1 location.';
        "--PRO12--": ;
        CstG00002: Label 'Lot non conform, do you want to post ?';

    procedure "---FE_LAPIERRETTE_PROD03---"()
    begin
    end;

    procedure FctCheckControlQuality(RecPJnl: Record "83"; CodPMachineCenter: Code[20]): Boolean
    var
        RecLItemJnlLine: Record "83";
        CstL00001: Label 'No lines found.';
    begin
        RecLItemJnlLine.RESET;
        RecLItemJnlLine.SETRANGE("Journal Template Name", RecPJnl."Journal Template Name");
        RecLItemJnlLine.SETRANGE("Journal Batch Name", RecPJnl."Journal Batch Name");
        RecLItemJnlLine.SETRANGE("Item No.", RecPJnl."Item No.");
        RecLItemJnlLine.SETRANGE("Entry Type", RecLItemJnlLine."Entry Type"::Output);

        //>>FE_LAPIERRETTE_PRO12.001
        //RecLItemJnlLine.SETFILTER("Routing No.",'%1',CodPMachineCenter);
        RecLItemJnlLine.SETFILTER("No.", '%1', CodPMachineCenter);
        //<FE_LAPIERRETTE_PRO12.001

        IF RecLItemJnlLine.FINDLAST THEN
            IF NOT RecLItemJnlLine."Conform quality control" THEN
                EXIT(FALSE)
            ELSE
                EXIT(TRUE)
        ELSE
            EXIT(TRUE);
    end;

    procedure FctExistControlQuality(RecPJnl: Record "83"; CodPMachineCenter: Code[10]): Boolean
    var
        RecLItemJnlLine: Record "83";
        CstL00001: Label 'No lines found.';
    begin
        RecLItemJnlLine.RESET;
        RecLItemJnlLine.SETRANGE("Journal Template Name", RecPJnl."Journal Template Name");
        RecLItemJnlLine.SETRANGE("Journal Batch Name", RecPJnl."Journal Batch Name");
        //RecLItemJnlLine.SETRANGE("Item No.",RecPJnl."Item No.");
        RecLItemJnlLine.SETRANGE("Entry Type", RecLItemJnlLine."Entry Type"::Output);
        //RecLItemJnlLine.SETFILTER("Routing No.",'<>%1','');
        //>>FE_LAPIERRETTE_PRO12.001
        //RecLItemJnlLine.SETRANGE(Type,RecLItemJnlLine.Type::"Work Center");
        RecLItemJnlLine.SETRANGE(Type, RecLItemJnlLine.Type::"Machine Center");
        //<<FE_LAPIERRETTE_PRO12.001
        RecLItemJnlLine.SETRANGE("No.", CodPMachineCenter);
        IF NOT RecLItemJnlLine.ISEMPTY THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;
}

