pageextension 50112 pageextension50112 extends "Purchase Order List"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // TDL.LPSA.20.04.15:APA 20/04/15: - Display Field 50001
    // 
    // //>>TDL.231
    // TDL.LPSA.231:CSC 14/06/16 : Add field "Intranet Order No."
    layout
    {
        addafter("Control 1102601013")
        {
            field("Promised Receipt Date"; "Promised Receipt Date")
            {
                ApplicationArea = All;
            }
            field("Order Date"; "Order Date")
            {
                ApplicationArea = All;
            }
        }
        addafter("Control 1102601027")
        {
            field("Expected Receipt Date"; "Expected Receipt Date")
            {
                ApplicationArea = All;
            }
            field(Printed; Printed)
            {
                ApplicationArea = All;
            }
            field("Intranet Order No."; "Intranet Order No.")
            {
                ApplicationArea = All;
            }
        }
    }
}

