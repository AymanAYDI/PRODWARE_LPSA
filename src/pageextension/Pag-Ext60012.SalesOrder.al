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
            field("PWD Sell-to Customer Name 2"; Rec."Sell-to Customer Name 2")
            {
                ApplicationArea = All;
            }
        }
        addafter("Promised Delivery Date")
        {
            field("PWD Cust Promised Delivery Date"; Rec."PWD Cust Promised Deliv. Date")
            {
                ApplicationArea = All;
            }
        }
        addafter(Status)
        {
            field("PWD ConfirmedLPSA"; Rec."PWD ConfirmedLPSA")
            {
                ApplicationArea = All;
            }
            field("PWD Print confirmation Date"; Rec."PWD Print confirmation Date")
            {
                ApplicationArea = All;
            }
            field("PWD Planned"; Rec."PWD Planned")
            {
                ApplicationArea = All;
            }
            field("PWD Rolex Bienne"; Rec."PWD Rolex Bienne")
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
            field("PWD Bill-to Name 2"; Rec."Bill-to Name 2")
            {
                ApplicationArea = All;
            }
        }
        addafter("Ship-to Name")
        {
            field("PWD Ship-to Name 2"; Rec."Ship-to Name 2")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter("&Order Confirmation")
        {
            group("PWD Pro Forma Invoice")
            {
                Caption = 'Pro Forma Invoice';
                Image = Email;
                action("PWD SendEmailProFormaInvoice")
                {
                    ApplicationArea = All;
                    Caption = 'Email Pro Forma Invoice';
                    Ellipsis = true;
                    Image = Email;
                    Promoted = true;
                    PromotedCategory = Category11;
                    PromotedIsBig = true;
                    ToolTip = 'Send a sales order Pro Forma Invoice by email. The attachment is sent as a .pdf.';

                    trigger OnAction()
                    var
                        LPSAFunctionsMgt: Codeunit "PWD LPSA Functions Mgt.";
                    begin
                        LPSAFunctionsMgt.SendEmailProformaInvoice(Rec);
                    end;
                }
                action("PWD AttachAsPDF")
                {
                    ApplicationArea = All;
                    Caption = 'Attach as PDF';
                    Ellipsis = true;
                    Image = PrintAttachment;
                    Promoted = true;
                    PromotedCategory = Category11;
                    ToolTip = 'Create a PDF file and attach it to the document.';

                    trigger OnAction()
                    var
                        SalesHeader: Record "Sales Header";
                        DocPrint: Codeunit "Document-Print";
                    begin
                        SalesHeader := Rec;
                        SalesHeader.SetRecFilter();
                        DocPrint.PrintSalesOrderToDocumentAttachment(SalesHeader, "Sales Order Print Option"::"Pro Forma Invoice".AsInteger());
                    end;
                }
            }
        }
        movefirst("PWD Pro Forma Invoice"; ProformaInvoice)
        modify(ProformaInvoice)
        {
            Promoted = true;
            PromotedCategory = Category11;
            PromotedIsBig = true;
        }
    }
    trigger OnAfterGetRecord()
    var
        RecLComment: Record "Comment Line";
    begin
        RecLComment.RESET();
        RecLComment.SETRANGE("Table Name", RecLComment."Table Name"::Customer);
        RecLComment.SETFILTER("No.", '%1|%2', Rec."Sell-to Customer No.", Rec."Bill-to Customer No.");
        BooGComment := Not RecLComment.IsEmpty;
    end;

    var
        BooGComment: Boolean;

}

