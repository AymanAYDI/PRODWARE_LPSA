pageextension 60112 "PWD PurchaseOrderList" extends "Purchase Order List"
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
        addafter("Shipment Method Code")
        {
            field("PWD Promised Receipt Date"; Rec."Promised Receipt Date")
            {
                ApplicationArea = All;
            }
            field("PWD Order Date"; Rec."Order Date")
            {
                ApplicationArea = All;
            }
        }
        addafter("Requested Receipt Date")
        {
            field("PWD Expected Receipt Date"; Rec."Expected Receipt Date")
            {
                ApplicationArea = All;
            }
            field("PWD Printed"; Rec."PWD Printed")
            {
                ApplicationArea = All;
            }
            field("PWD Intranet Order No."; Rec."PWD Intranet Order No.")
            {
                ApplicationArea = All;
            }
        }
    }
}

