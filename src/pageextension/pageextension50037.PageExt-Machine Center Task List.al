pageextension 50037 pageextension50037 extends "Machine Center Task List"
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
        addafter("Control 8")
        {
            field("Item No."; RecGItem."No.")
            {
                Caption = 'Item No.';
                Editable = false;
                ApplicationArea = All;
            }
            field("LPSA Description 1"; RecGItem."LPSA Description 1")
            {
                Caption = 'LPSA Description 1';
                Editable = false;
                ApplicationArea = All;
            }
            field(RecGItem."Search Description";
                RecGItem."Search Description")
            {
                Caption = 'Search Description';
                Editable = false;
                ApplicationArea = All;
            }
            field(DatGDueDate; DatGDueDate)
            {
                Caption = 'Due Date';
                Editable = false;
                ApplicationArea = All;
            }
            field("Starting Date-Time (P1)"; "Starting Date-Time (P1)")
            {
                ApplicationArea = All;
            }
            field("Ending Date-Time (P1)"; "Ending Date-Time (P1)")
            {
                ApplicationArea = All;
            }
        }
        addafter("Control 38")
        {
            field("Routing Status"; "Routing Status")
            {
                ApplicationArea = All;
            }
            field("Input Quantity"; "Input Quantity")
            {
                ApplicationArea = All;
            }
            field("No."; "No.")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Insertion (RunPageView) on "Action 65".


        //Unsupported feature: Property Insertion (RunPageLink) on "Action 65".


        //Unsupported feature: Property Insertion (RunPageView) on "Action 66".


        //Unsupported feature: Property Insertion (RunPageLink) on "Action 66".


        //Unsupported feature: Property Insertion (RunPageLink) on "Action 67".


        //Unsupported feature: Property Insertion (RunPageLink) on "Action 69".


        //Unsupported feature: Property Deletion (RunFormView) on "Action 65".


        //Unsupported feature: Property Deletion (RunFormLink) on "Action 65".


        //Unsupported feature: Property Deletion (RunFormView) on "Action 66".


        //Unsupported feature: Property Deletion (RunFormLink) on "Action 66".


        //Unsupported feature: Property Deletion (RunFormLink) on "Action 67".


        //Unsupported feature: Property Deletion (RunFormLink) on "Action 69".

    }

    var
        RecGItem: Record "27";
        RecGProdLine: Record "5406";
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

