report 60021 "Invoice Purch. Orders Before.."
{
    Caption = 'Invoice Purch. Orders Before...';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Order));
            RequestFilterFields = "No.", "Buy-from Vendor No.", "Pay-to Vendor No.";
            RequestFilterHeading = 'Purchase Order';

            trigger OnAfterGetRecord()
            var
                ReservePurchLine: Codeunit "Purch. Line-Reserve";
            begin
                Window.Update(1, "No.");

                BooGInvoiced := false;


                //S'il existe des lignes non facture, on maj la qté à factruer et on facture
                PurchLine.Reset;
                PurchLine.SetRange("Document Type", "Document Type");
                PurchLine.SetRange("Document No.", "No.");
                PurchLine.SetFilter("Qty. Rcd. Not Invoiced", '<>0');
                if PurchLine.Find('-') then begin
                    BooGInvoiced := true;
                    repeat
                        PurchLine.Validate("Qty. to Invoice", PurchLine."Qty. Rcd. Not Invoiced");
                        PurchLine.Modify;
                    until PurchLine.Next = 0;
                end;

                if BooGInvoiced then begin
                    ArchiveManagement.ArchPurchDocumentNoConfirm("Purchase Header");
                    "Purchase Header"."Vendor Invoice No." := 'Sold. ' + "No.";
                    "Purchase Header".Modify;
                    Commit;
                    CounterTotal += 1;
                    if CalcInvDisc then
                        CalculateInvoiceDiscount;
                    "Purchase Header".Invoice := true;
                    Clear(PurchPost);
                    PurchPost.SetPostingDate(ReplacePostingDate, ReplaceDocumentDate, PostingDateReq);
                    if PurchPost.Run("Purchase Header") then begin
                        CounterOK := CounterOK + 1;
                    end;
                end;
            end;

            trigger OnPostDataItem()
            begin
                Message(Text002, CounterOK, CounterTotal);
            end;

            trigger OnPreDataItem()
            begin
                if DateGDateFilter = 0D then
                    Error('Vous devez choisir une date');
                SetFilter("Order Date", '<%1', DateGDateFilter);
                Window.Open(Text000);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(DateGDateFilter; DateGDateFilter)
                    {
                        Caption = 'Commandes avant le';
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Text000: Label 'Processing purch. orders #1##########';
        PurchSetup: Record "Purchases & Payables Setup";
        PurchLine: Record "Purchase Line";
        PurchCalcDisc: Codeunit "Purch.-Calc.Discount";
        PurchPost: Codeunit "Purch.-Post";
        ArchiveManagement: Codeunit ArchiveManagement;
        Window: Dialog;
        DateGDateFilter: Date;
        BooGInvoiced: Boolean;
        DecGUnitPrice: Decimal;
        DecGDiscLine: Decimal;
        ReplacePostingDate: Boolean;
        ReplaceDocumentDate: Boolean;
        PostingDateReq: Date;
        CounterTotal: Integer;
        CounterOK: Integer;
        CalcInvDisc: Boolean;
        Text001: Label 'Posting orders  #1########## @2@@@@@@@@@@@@@';
        Text002: Label '%1 orders out of a total of %2 have now been posted.';
        Text003: Label 'The exchange rate associated with the new posting date on the purchase header will not apply to the purchase lines.';


    procedure CalculateInvoiceDiscount()
    begin
        PurchLine.Reset;
        PurchLine.SetRange("Document Type", "Purchase Header"."Document Type");
        PurchLine.SetRange("Document No.", "Purchase Header"."No.");
        if PurchLine.Find('-') then
            if PurchCalcDisc.Run(PurchLine) then begin
                "Purchase Header".Get("Purchase Header"."Document Type", "Purchase Header"."No.");
                Commit;
            end;
    end;
}

