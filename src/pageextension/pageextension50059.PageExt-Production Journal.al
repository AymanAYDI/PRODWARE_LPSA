pageextension 50059 pageextension50059 extends "Production Journal"
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
    //                                                           PageActions - Post and Print
    //                                           - Functions added FctCheckControlQuality()
    //                                                             FctExistControlQuality()
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
        }
    }
    actions
    {


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
        DeleteRecTemp;

        CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post",Rec);

        InsertTempRec;

        SetFilterGroup;
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
          IF NOT FctCheckControlQuality(RecLItemJnlLineCopy) THEN
            //>>FE_LAPIERRETTE_PRO12.001
            //IF NOT CONFIRM(STRSUBSTNO(CstG00001,RecLManufacturingSetup."Non conformity Prod. Location")) THEN
            IF NOT CONFIRM(CstG00002) THEN
            //<<FE_LAPIERRETTE_PRO12.001
              EXIT;
        //<<FE_LAPIERRETTE_PROD03.001

        #1..8
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
        DeleteRecTemp;

        CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post+Print",Rec);

        InsertTempRec;

        SetFilterGroup;
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
          IF NOT FctCheckControlQuality(RecLItemJnlLineCopy) THEN
            //>>FE_LAPIERRETTE_PRO12.001
            //IF NOT CONFIRM(STRSUBSTNO(CstG00001,RecLManufacturingSetup."Non conformity Prod. Location")) THEN
            IF NOT CONFIRM(CstG00002) THEN
            //<<FE_LAPIERRETTE_PRO12.001
              EXIT;
        //<<FE_LAPIERRETTE_PROD03.001

        #1..8
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

    procedure FctCheckControlQuality(RecPJnl: Record "83"): Boolean
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
        IF RecLItemJnlLine.FINDLAST THEN
            IF NOT RecLItemJnlLine."Conform quality control" THEN
                EXIT(FALSE)
            ELSE
                EXIT(TRUE)
        ELSE
            ERROR(CstL00001);
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

