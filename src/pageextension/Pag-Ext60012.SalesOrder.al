pageextension 60012 "PWD SalesOrder" extends "Sales Order"
{
    // #1..33
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_VTE06.001: NI 23/11/2011:  Statut Commande vente
    //                                           - Display field 50000..50001 on Tab [GENERAL]
    // 
    // FE_LAPIERRETTE_VTE01.001: TO 07/12/2011:  Export Role
    //                                           - Displayd field 50002 "Rolex Bienne" on Tab [GENERAL]
    // 
    // TDL.LPSA.20.04.15:APA 20/04/15: - Display Field "Customer Comment", "Cust Promised Delivery Date" on Tab [GENERAL]
    // 
    // TDL.LPSA.01.06.15:APA 01/06/15: - Display Field "Print confirmation Date" on Tab [GENERAL]
    // 
    // 
    // ------------------------------------------------------------------------------------------------------------------
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field("PWD Sell-to Customer Name 2"; "Sell-to Customer Name 2")
            {
                ApplicationArea = All;
            }
        }
        addafter("Promised Delivery Date")
        {
            field("PWD Cust Promised Delivery Date"; "PWD Cust Promised Delivery Date")
            {
                ApplicationArea = All;
            }
        }
        addafter(Status)
        {
            field("PWD ConfirmedLPSA"; "PWD ConfirmedLPSA")
            {
                ApplicationArea = All;
            }
            field("PWD Print confirmation Date"; "PWD Print confirmation Date")
            {
                ApplicationArea = All;
            }
            field("PWD Planned"; "PWD Planned")
            {
                ApplicationArea = All;
            }
            field("PWD Rolex Bienne"; "PWD Rolex Bienne")
            {
                ApplicationArea = All;
            }
            field("PWD BooGComment"; BooGComment)
            {
                Caption = 'Customer Comment';
                Editable = false;
                ApplicationArea = All;
            }
        }
        addafter("Bill-to Name")
        {
            field("PWD Bill-to Name 2"; "Bill-to Name 2")
            {
                ApplicationArea = All;
            }
        }
        addafter("Ship-to Name")
        {
            field("PWD Ship-to Name 2"; "Ship-to Name 2")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addbefore("Work Order")
        {
            action("PWD Action224")
            {
                Caption = 'Order Confirmation';
                Ellipsis = true;
                Image = Print;
                ApplicationArea = All;

                trigger OnAction()
                var
                    DocPrint: Codeunit "Document-Print";
                    Usage: Option "Order Confirmation","Work Order";
                begin
                    CurrPage.SETSELECTIONFILTER(Rec);
                    IF RecGSalesSetup.GET THEN BEGIN
                        RecGSalesSetup.TESTFIELD("PWD PDFDirectory");
                    END;
                    REPORT.SAVEASPDF(50009, RecGSalesSetup."PWD PDFDirectory" + '\' + STRSUBSTNO('CONFIRM No. %1.pdf', "No."), Rec);
                    Rec.RESET;

                    SLEEP(1000);
                    DocPrint.PrintSalesOrder(Rec, Usage::"Order Confirmation");
                end;
            }
            action("PWD Invoice Proforma")
            {
                Caption = 'Invoice Proforma';
                Image = Print;
                ApplicationArea = All;

                trigger OnAction()
                var
                    SalesHead: Record "Sales Header";
                begin
                    SalesHead.SETRANGE("Document Type", "Document Type");
                    SalesHead.SETRANGE("No.", "No.");
                    REPORT.RUN(REPORT::"PWD Proforma invoice", TRUE, FALSE, SalesHead);
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        RecLComment: Record "Comment Line";
    begin
        RecLComment.RESET;
        RecLComment.SETRANGE("Table Name", RecLComment."Table Name"::Customer);
        RecLComment.SETFILTER("No.", '%1|%2', "Sell-to Customer No.", "Bill-to Customer No.");
        BooGComment := RecLComment.FINDFIRST;
    end;

    var
        RecGSalesSetup: Record "Sales & Receivables Setup";
        BooGComment: Boolean;

}
