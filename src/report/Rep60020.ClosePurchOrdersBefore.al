report 60020 "Close Purch. Orders Before..."
{
    Caption = 'Close Purch. Orders Before...';
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


                //Pour les lignes réception, si la quantité restante est <> 0, alors on ajuste
                PurchLine.Reset();
                PurchLine.SetRange("Document Type", "Document Type");
                PurchLine.SetRange("Document No.", "No.");
                PurchLine.SetFilter("Quantity Received", '<>0');
                PurchLine.SetFilter("Outstanding Quantity", '<>0');
                if PurchLine.Find('-') then begin
                    PurchLine.SetRange("Outstanding Quantity");
                    PurchLine.SetRange("Quantity Received");
                    //On rouvre la commande
                    ReleasePurchDoc.PerformManualReopen("Purchase Header");
                    if PurchLine.Find('-') then
                        repeat
                            if (PurchLine."Quantity Received" <> 0) and (PurchLine."Outstanding Quantity" <> 0) then begin
                                WarRcpLine.SetRange("Source Type", 39);
                                WarRcpLine.SetRange(WarRcpLine."Source Subtype", 1);
                                WarRcpLine.SetRange("Source No.", PurchLine."Document No.");
                                WarRcpLine.SetRange("Source Line No.", PurchLine."Line No.");
                                if WarRcpLine.FindFirst() then
                                    WarRcpLine.DeleteAll();
                                ReservEntry.SetRange("Reservation Status", ReservEntry."Reservation Status"::Surplus);
                                ReservEntry.SetRange("Source Type", 39);
                                ReservEntry.SetRange("Source Subtype", 1);
                                ReservEntry.SetRange("Source ID", PurchLine."Document No.");
                                ReservEntry.SetRange("Source Ref. No.", PurchLine."Line No.");
                                if ReservEntry.FindFirst() then
                                    ReservEntry.DeleteAll();
                                // On mémorise le prix
                                DecGUnitPrice := PurchLine."Direct Unit Cost";
                                DecGDiscLine := PurchLine."Line Discount %";
                                // On modifie la quantité
                                PurchLine.Validate(Quantity, PurchLine."Quantity Received");
                                PurchLine.Validate("Direct Unit Cost", DecGUnitPrice);
                                PurchLine.Validate("Line Discount %", DecGDiscLine);
                                // On remet le prix
                                PurchLine.Modify();
                            end;
                        until PurchLine.Next() = 0;
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
        PurchLine: Record "Purchase Line";
        WarRcpLine: Record "Warehouse Receipt Line";
        ReservEntry: Record "Reservation Entry";
        ReleasePurchDoc: Codeunit "Release Purchase Document";
        Window: Dialog;
        DateGDateFilter: Date;
        BooGInvoiced: Boolean;
        DecGUnitPrice: Decimal;
        DecGDiscLine: Decimal;
}

