pageextension 60018 "PWD PurchaseOrder" extends "Purchase Order"
{
    // #1..30
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.5
    // WMS-FE04.001:GR  01/07/2011   Connector integration
    //                              - Add pages actions "Send Order To WMS" in Functions Part
    // 
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_ACH03.001: NI 22/11/2011:  Montant Minimun de commande
    //                                           - Display field 50000 "Order Min. Amount" on Tab [GENERAL]
    // 
    // FE_LAPIERRETTE_ACH02.001: TO 07/12/2011:  Documents achat
    //                                          - Add C/AL in button Print
    // 
    // TDL.LPSA.20.04.15:APA 20/04/15: - Display Field 50001 on Tab [GENERAL]
    // 
    // //>>TDL.231
    // TDL.LPSA.231:CSC 14/06/16 : Add field "Intranet Order No." in General Tab
    // 
    // ------------------------------------------------------------------------------------------------------------------
    layout
    {
        addafter("Posting Date")
        {
            field("PWD Order Min. Amount"; Rec."PWD Order Min. Amount")
            {
                ApplicationArea = All;
            }
        }
        addafter("Quote No.")
        {
            field("PWD Intranet Order No."; Rec."PWD Intranet Order No.")
            {
                ApplicationArea = All;
            }
        }
        addafter(Status)
        {
            field("PWD Printedt"; Rec."PWD Printed")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addlast("F&unctions")
        {

            action("PWD Action1100294001")
            {
                Caption = 'Send Order To WMS';
                ApplicationArea = All;
                Image = SendTo;
                trigger OnAction()
                var
                    RecLPurchaseLines: Record "Purchase Line";
                    CduLConnectorWMSParseData: Codeunit "PWD Connector WMS Parse Data";
                begin
                    //>>WMS-FE04.001
                    RecLPurchaseLines.RESET();
                    RecLPurchaseLines.SETRANGE("Document Type", Rec."Document Type");
                    RecLPurchaseLines.SETRANGE("Document No.", Rec."No.");
                    IF RecLPurchaseLines.FINDSET() THEN
                        REPEAT
                            CduLConnectorWMSParseData.FctChangePurchOrderStatus(RecLPurchaseLines);
                            RecLPurchaseLines.MODIFY();
                        UNTIL RecLPurchaseLines.NEXT() = 0;
                    //<<WMS-FE04.001
                end;
            }
        }
    }
}

