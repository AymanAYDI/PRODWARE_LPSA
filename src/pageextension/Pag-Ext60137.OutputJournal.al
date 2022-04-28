pageextension 60137 "PWD OutputJournal" extends "Output Journal"
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
        addafter("External Document No.")
        {
            field("PWD Quartis Comment"; "PWD Quartis Comment")
            {
                ApplicationArea = All;
            }
            field("PWD Conform quality control"; "PWD Conform quality control")
            {
                ApplicationArea = All;
            }
            field("PWD Inventory Posting Group"; "Inventory Posting Group")
            {
                ApplicationArea = All;
            }
        }
    }

    procedure FctCheckControlQuality(RecPJnl: Record "Item Journal Line"; CodPMachineCenter: Code[20]): Boolean
    var
        RecLItemJnlLine: Record "Item Journal Line";
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
            IF NOT RecLItemJnlLine."PWD Conform quality control" THEN
                EXIT(FALSE)
            ELSE
                EXIT(TRUE)
        ELSE
            EXIT(TRUE);
    end;

    procedure FctExistControlQuality(RecPJnl: Record "Item Journal Line"; CodPMachineCenter: Code[10]): Boolean
    var
        RecLItemJnlLine: Record "Item Journal Line";
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

