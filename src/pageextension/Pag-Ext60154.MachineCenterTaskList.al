pageextension 60154 "PWD MachineCenterTaskList" extends "Machine Center Task List"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP.TDL
    // 19/06/2015 : Add fields
    //               - Add "Item No.", "LPSA Description 1" , "Search Description", "Due Date"
    // 
    // ------------------------------------------------------------------------------------------------------------------
    layout
    {
        addafter(Description)
        {
            field("PWD Item No."; RecGItem."No.")
            {
                Caption = 'Item No.';
                Editable = false;
                ApplicationArea = All;
            }
            field("PWD LPSA Description 1"; RecGItem."PWD LPSA Description 1")
            {
                Caption = 'LPSA Description 1';
                Editable = false;
                ApplicationArea = All;
            }
            field("PWD Search Description"; RecGItem."Search Description")
            {
                Caption = 'Search Description';
                Editable = false;
                ApplicationArea = All;
            }
            field("PWD DatGDueDate"; DatGDueDate)
            {
                Caption = 'Due Date';
                Editable = false;
                ApplicationArea = All;
            }
            //TODO:'Record "Prod. Order Routing Line"' does not contain a definition for 'Starting Date-Time (P1)' and "Ending Date-Time (P1)"
            // field("Starting Date-Time (P1)"; Rec."Starting Date-Time (P1)")
            // {
            //     ApplicationArea = All;
            // }
            // field("Ending Date-Time (P1)"; Rec."Ending Date-Time (P1)")
            // {
            //     ApplicationArea = All;
            // }
        }
        addafter("Unit Cost per")
        {
            field("PWD Routing Status"; Rec."Routing Status")
            {
                ApplicationArea = All;
            }
            field("PWD Input Quantity"; Rec."Input Quantity")
            {
                ApplicationArea = All;
            }
            field("PWD No."; Rec."No.")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }

    var
        RecGItem: Record Item;
        RecGProdLine: Record "Prod. Order Line";
        DatGDueDate: Date;


    //Unsupported feature: Code Insertion on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //begin
    /*
    //>>TDL.LPSA
    DatGDueDate := 0D;
    IF RecGProdLine.GET(Status,"Prod. Order No.","Routing Reference No.") THEN BEGIN
      DatGDueDate := RecGProdLine."Due Date";
      IF NOT RecGItem.GET(RecGProdLine."Item No.") THEN
        RecGItem.INIT;
    END;
    //<<TDL.LPSA
    */
    //end;
}

