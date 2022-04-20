pageextension 50111 pageextension50111 extends "Sales Order List"
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
        addafter("Control 17")
        {
            field("Order Date"; "Order Date")
            {
                ApplicationArea = All;
            }
        }
        addafter("Control 1102601037")
        {
            field(ConfirmedLPSA; ConfirmedLPSA)
            {
                ApplicationArea = All;
            }
            field(Planned; Planned)
            {
                ApplicationArea = All;
            }
            field("Posting No."; "Posting No.")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {


        //Unsupported feature: Code Insertion (VariableCollection) on "Action 151.OnAction".

        //trigger (Variable: CduLTierAutomationMgt)()
        //Parameters and return type have not been exported.
        //begin
        /*
        */
        //end;
        addafter("Action 151")
        {
            action("<Action1100267000>")
            {
                Caption = 'Invoice Proforma';
                Image = Print;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    SalesHead.SETRANGE("Document Type", "Document Type");
                    SalesHead.SETRANGE("No.", "No.");
                    REPORT.RUN(REPORT::"Proforma invoice", TRUE, FALSE, SalesHead);
                end;
            }
        }
    }

    var
        CduLTierAutomationMgt: Codeunit "419";
        TxtLServerFile: Text[250];

    var
        SalesHead: Record "36";
}

