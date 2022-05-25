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
                    IF RecGSalesSetup.GET() THEN
                        RecGSalesSetup.TESTFIELD("PWD PDFDirectory");
                    REPORT.SAVEASPDF(Report::"PWD Sales Order Confirmation", RecGSalesSetup."PWD PDFDirectory" + '\' + STRSUBSTNO('CONFIRM No. %1.pdf', Rec."No."), Rec);
                    Rec.RESET();

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
                    SalesHead.SETRANGE("Document Type", Rec."Document Type");
                    SalesHead.SETRANGE("No.", Rec."No.");
                    REPORT.RUN(REPORT::"PWD Proforma invoice", TRUE, FALSE, SalesHead);
                end;
            }
        }

        addbefore("&Order Confirmation")
        {
            group("PWD &Order Confirmation1")
            {
                Caption = 'Pro Forma Invoice';
                Image = Email;
                action("PWD SendEmailConfirmation")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Email Pro Forma Invoice';
                    Ellipsis = true;
                    Image = Email;
                    Promoted = true;
                    PromotedCategory = Category11;
                    PromotedIsBig = true;
                    ToolTip = 'Send a sales order Pro Forma Invoice by email. The attachment is sent as a .pdf.';

                    trigger OnAction()
                    begin
                        // ReportSelection.PrintWithDialogForCust(
                        // ReportUsage::"Pro Forma S. Invoice", Rec, GuiAllowed, Rec.FieldNo("Bill-to Customer No."));
                        DoPrintSalesHeader(Rec, true)
                    end;
                }
                group("PWD Action96")
                {
                    Visible = false;
                    action("PWD Print Pro Forma Invoice")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Pro Forma Invoice';
                        Ellipsis = true;
                        Image = Print;
                        Promoted = true;
                        PromotedCategory = Category11;
                        ToolTip = 'Print a sales order Pro Forma Invoice.';
                        //Visible = NOT IsOfficeHost;

                        trigger OnAction()
                        var
                            DocPrint: Codeunit "Document-Print";
                            Usage: Option "Pro Forma S. Invoice";
                        begin
                            DocPrint.PrintSalesOrder(Rec, Usage::"Pro Forma S. Invoice");
                        end;
                    }
                    action("PWD AttachAsPDF")
                    {
                        ApplicationArea = Basic, Suite;
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
                            DocPrint.PrintSalesOrderToDocumentAttachment(SalesHeader, DocPrint.GetSalesOrderPrintToAttachmentOption(Rec));
                        end;
                    }
                }
            }

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
        RecGSalesSetup: Record "Sales & Receivables Setup";
        BooGComment: Boolean;

    local procedure DoPrintSalesHeader(SalesHeader: Record "Sales Header"; SendAsEmail: Boolean)
    var
        ReportSelections: Record "Report Selections";
        ReportUsage: Enum "Report Selection Usage";
    begin
        ReportUsage := ReportUsage::"Pro Forma S. Invoice";

        SalesHeader.SetRange("Document Type", SalesHeader."Document Type");
        SalesHeader.SetRange("No.", SalesHeader."No.");
        //CalcSalesDisc(SalesHeader);
        if SendAsEmail then
            ReportSelections.SendEmailToCust(
                ReportUsage.AsInteger(), SalesHeader, SalesHeader."No.", SalesHeader.GetDocTypeTxt(), true, SalesHeader.GetBillToNo())
        else
            ReportSelections.PrintForCust(ReportUsage, SalesHeader, SalesHeader.FieldNo("Bill-to Customer No."));
    end;
}

