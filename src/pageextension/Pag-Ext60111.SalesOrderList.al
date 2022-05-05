pageextension 60111 "PWD SalesOrderList" extends "Sales Order List"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_VTE06.001: NI 23/11/2011:  Statut Commande vente
    //                                           - Display field 50000..50001
    // ------------------------------------------------------------------------------------------------------------------
    layout
    {
        addafter("External Document No.")
        {
            field("PWD Order Date"; Rec."Order Date")
            {
                ApplicationArea = All;
            }
        }
        addafter("Shipping Advice")
        {
            field("PWD ConfirmedLPSA"; Rec."PWD ConfirmedLPSA")
            {
                ApplicationArea = All;
            }
            field("PWD Planned"; Rec."PWD Planned")
            {
                ApplicationArea = All;
            }
            field("PWD Posting No."; Rec."Posting No.")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addbefore("Work Order")
        {
            action("PWD Action1100267000")
            {
                Caption = 'Invoice Proforma';
                Image = Print;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    SalesHead.SETRANGE("Document Type", Rec."Document Type");
                    SalesHead.SETRANGE("No.", Rec."No.");
                    REPORT.RUN(REPORT::"PWD Proforma invoice", TRUE, FALSE, SalesHead);
                end;
            }
        }
    }

    var
        SalesHead: Record "Sales Header";
}

