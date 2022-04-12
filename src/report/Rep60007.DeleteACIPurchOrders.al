report 60007 "PWD Delete ACI Purch. Orders"
{
    Caption = 'Delete Purch. Orders Before...';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = SORTING ("Document Type", "No.") WHERE ("Document Type" = CONST (Order), "Location Code" = FILTER ('ACI'));
            RequestFilterFields = "No.", "Buy-from Vendor No.", "Pay-to Vendor No.";
            RequestFilterHeading = 'Purchase Order';

            trigger OnAfterGetRecord()
            var
                ReservePurchLine: Codeunit "Purch. Line-Reserve";
            begin
                Window.Update(1, "No.");

                BooGInvoiced := false;

                AllLinesDeleted := true;
                DocDim.Reset;
                DocDim.SetRange("Document Type", "Document Type");
                DocDim.SetRange("Document No.", "No.");
                ItemChargeAssgntPurch.Reset;
                ItemChargeAssgntPurch.SetRange("Document Type", "Document Type");
                ItemChargeAssgntPurch.SetRange("Document No.", "No.");

                // CAS DES COMMANDES ENTIEREMENT FACTUREES : ARCHIVAGE + SUPPRESSION
                PurchLine.Reset;
                PurchLine.SetRange("Document Type", "Document Type");
                PurchLine.SetRange("Document No.", "No.");
                PurchLine.SetFilter("Quantity Invoiced", '<>0');
                if PurchLine.Find('-') then begin
                    PurchLine.SetRange("Quantity Invoiced");
                    PurchLine.SetFilter("Outstanding Quantity", '<>0');
                    if not PurchLine.Find('-') then begin
                        PurchLine.SetRange("Outstanding Quantity");
                        PurchLine.SetFilter("Qty. Rcd. Not Invoiced", '<>0');
                        if not PurchLine.Find('-') then begin
                            PurchLine.LockTable;
                            if not PurchLine.Find('-') then begin

                                BooGInvoiced := true;
                                PurchLine.SetRange("Qty. Rcd. Not Invoiced");
                                DocDim.SetRange("Table ID", DATABASE::"Purchase Line");

                                ArchiveManagement.ArchPurchDocumentNoConfirm("Purchase Header");

                                if PurchLine.Find('-') then
                                    repeat
                                        PurchLine.CalcFields("Qty. Assigned");
                                        if ((PurchLine."Qty. Assigned" = PurchLine."Quantity Invoiced") and
                                          (PurchLine."Qty. Assigned" <> 0)) or
                                          (PurchLine.Type <> PurchLine.Type::"Charge (Item)")
                                        then begin
                                            DocDim.SetRange("Line No.", PurchLine."Line No.");
                                            DocDim.DeleteAll;
                                            if PurchLine.Type = PurchLine.Type::"Charge (Item)" then begin
                                                ItemChargeAssgntPurch.SetRange("Document Line No.", PurchLine."Line No.");
                                                ItemChargeAssgntPurch.DeleteAll;
                                            end;
                                            if PurchLine.HasLinks then
                                                PurchLine.DeleteLinks;

                                            PurchLine.Delete;
                                        end else
                                            AllLinesDeleted := false;
                                    until PurchLine.Next = 0;

                                if AllLinesDeleted then begin
                                    PurchPost.DeleteHeader(
                                      "Purchase Header", PurchRcptHeader, PurchInvHeader, PurchCrMemoHeader,
                                      ReturnShptHeader, PrepmtPurchInvHeader, PrepmtPurchCrMemoHeader);

                                    ReservePurchLine.DeleteInvoiceSpecFromHeader("Purchase Header");

                                    PurchCommentLine.SetRange("Document Type", "Document Type");
                                    PurchCommentLine.SetRange("No.", "No.");
                                    PurchCommentLine.DeleteAll;

                                    DocDim.SetRange("Table ID", DATABASE::"Purchase Header");
                                    DocDim.SetRange("Line No.", 0);
                                    DocDim.DeleteAll;

                                    WhseRequest.SetRange("Source Type", DATABASE::"Purchase Line");
                                    WhseRequest.SetRange("Source Subtype", "Document Type");
                                    WhseRequest.SetRange("Source No.", "No.");
                                    WhseRequest.DeleteAll(true);

                                    if HasLinks then
                                        DeleteLinks;

                                    Delete;
                                end;
                                Commit;
                            end;
                        end;
                    end;
                end;


                //CAS DES COMMANDES NON RECEPTIONNEES/NON FACTUREES
                if not BooGInvoiced then begin
                    PurchLine.SetRange("Quantity Invoiced");
                    PurchLine.SetFilter(PurchLine."Quantity Received", '<>0');
                    if not PurchLine.Find('-') then begin
                        PurchLine.LockTable;
                        if not PurchLine.Find('-') then begin
                            PurchLine.SetRange("Quantity Received");
                            DocDim.SetRange("Table ID", DATABASE::"Purchase Line");

                            ArchiveManagement.ArchPurchDocumentNoConfirm("Purchase Header");

                            if PurchLine.Find('-') then
                                repeat
                                    //PurchLine.CALCFIELDS("Qty. Assigned");
                                    //IF ((PurchLine."Qty. Assigned" = PurchLine."Quantity Invoiced") AND
                                    //  (PurchLine."Qty. Assigned" <> 0)) OR
                                    //  (PurchLine.Type <> PurchLine.Type::"Charge (Item)")
                                    //THEN BEGIN
                                    //  DocDim.SETRANGE("Line No.",PurchLine."Line No.");
                                    //  DocDim.DELETEALL;
                                    if PurchLine.Type = PurchLine.Type::"Charge (Item)" then begin
                                        ItemChargeAssgntPurch.SetRange("Document Line No.", PurchLine."Line No.");
                                        ItemChargeAssgntPurch.DeleteAll;
                                    end;
                                    if PurchLine.HasLinks then
                                        PurchLine.DeleteLinks;
                                    PurchLine.Delete;
                                    //END ELSE
                                    //  AllLinesDeleted := FALSE;
                                until PurchLine.Next = 0;
                            if AllLinesDeleted then begin
                                PurchPost.DeleteHeader(
                                  "Purchase Header", PurchRcptHeader, PurchInvHeader, PurchCrMemoHeader,
                                  ReturnShptHeader, PrepmtPurchInvHeader, PrepmtPurchCrMemoHeader);
                                ReservePurchLine.DeleteInvoiceSpecFromHeader("Purchase Header");
                                PurchCommentLine.SetRange("Document Type", "Document Type");
                                PurchCommentLine.SetRange("No.", "No.");
                                PurchCommentLine.DeleteAll;

                                DocDim.SetRange("Table ID", DATABASE::"Purchase Header");
                                DocDim.SetRange("Line No.", 0);
                                DocDim.DeleteAll;

                                WhseRequest.SetRange("Source Type", DATABASE::"Purchase Line");
                                WhseRequest.SetRange("Source Subtype", "Document Type");
                                WhseRequest.SetRange("Source No.", "No.");
                                WhseRequest.DeleteAll(true);

                                if HasLinks then
                                    DeleteLinks;

                                Delete;
                            end;
                            Commit;
                        end;
                    end;
                end;
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
        PurchLine: Record "Purchase Line";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        ReturnShptHeader: Record "Return Shipment Header";
        PrepmtPurchInvHeader: Record "Purch. Inv. Header";
        PrepmtPurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        PurchCommentLine: Record "Purch. Comment Line";
        DocDim: Record "Document Dimension";
        ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
        WhseRequest: Record "Warehouse Request";
        PurchPost: Codeunit "Purch.-Post";
        Window: Dialog;
        AllLinesDeleted: Boolean;
        PurchSetup: Record "Purchases & Payables Setup";
        ArchiveManagement: Codeunit ArchiveManagement;
        DateGDateFilter: Date;
        BooGInvoiced: Boolean;
}

