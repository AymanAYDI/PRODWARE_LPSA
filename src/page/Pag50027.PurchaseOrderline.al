page 50027 "PWD Purchase Order line"
{
    Caption = 'Lignes Commandes Achat';
    Editable = false;
    PageType = List;
    SourceTable = "Purchase Line";
    SourceTableView = WHERE(Document Type=FILTER(Order));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; "Document Type")
                {
                }
                field("Buy-from Vendor No."; "Buy-from Vendor No.")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Line No."; "Line No.")
                {
                }
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Posting Group"; "Posting Group")
                {
                }
                field("Expected Receipt Date"; "Expected Receipt Date")
                {
                }
                field(Description; Description)
                {
                }
                field("Description 2"; "Description 2")
                {
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Outstanding Quantity"; "Outstanding Quantity")
                {
                }
                field("Qty. to Invoice"; "Qty. to Invoice")
                {
                }
                field("Qty. to Receive"; "Qty. to Receive")
                {
                }
                field("Direct Unit Cost"; "Direct Unit Cost")
                {
                }
                field("Unit Cost (LCY)";"Unit Cost (LCY)")
                {
                }
                field("VAT %";"VAT %")
                {
                }
                field("Line Discount %";"Line Discount %")
                {
                }
                field("Line Discount Amount"; "Line Discount Amount")
                {
                }
                field(Amount; Amount)
                {
                }
                field("Amount Including VAT"; "Amount Including VAT")
                {
                }
                field("Unit Price (LCY)";"Unit Price (LCY)")
                {
                }
                field("Allow Invoice Disc."; "Allow Invoice Disc.")
                {
                }
                field("Gross Weight"; "Gross Weight")
                {
                }
                field("Net Weight"; "Net Weight")
                {
                }
                field("Units per Parcel"; "Units per Parcel")
                {
                }
                field("Unit Volume"; "Unit Volume")
                {
                }
                field("Appl.-to Item Entry"; "Appl.-to Item Entry")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
                field("Job No."; "Job No.")
                {
                }
                field("Indirect Cost %";"Indirect Cost %")
                {
                }
                field("Outstanding Amount"; "Outstanding Amount")
                {
                }
                field("Qty. Rcd. Not Invoiced"; "Qty. Rcd. Not Invoiced")
                {
                }
                field("Amt. Rcd. Not Invoiced"; "Amt. Rcd. Not Invoiced")
                {
                }
                field("Quantity Received"; "Quantity Received")
                {
                }
                field("Quantity Invoiced"; "Quantity Invoiced")
                {
                }
                field("Receipt No."; "Receipt No.")
                {
                }
                field("Receipt Line No."; "Receipt Line No.")
                {
                }
                field("Profit %";"Profit %")
                {
                }
                field("Pay-to Vendor No."; "Pay-to Vendor No.")
                {
                }
                field("Inv. Discount Amount"; "Inv. Discount Amount")
                {
                }
                field("Vendor Item No."; "Vendor Item No.")
                {
                }
                field("Sales Order No."; "Sales Order No.")
                {
                }
                field("Sales Order Line No."; "Sales Order Line No.")
                {
                }
                field("Drop Shipment"; "Drop Shipment")
                {
                }
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                }
                field("VAT Calculation Type"; "VAT Calculation Type")
                {
                }
                field("Transaction Type"; "Transaction Type")
                {
                }
                field("Transport Method"; "Transport Method")
                {
                }
                field("Attached to Line No."; "Attached to Line No.")
                {
                }
                field("Entry Point"; "Entry Point")
                {
                }
                field("Area"; Area)
                {
                }
                field("Transaction Specification"; "Transaction Specification")
                {
                }
                field("Tax Area Code"; "Tax Area Code")
                {
                }
                field("Tax Liable"; "Tax Liable")
                {
                }
                field("Tax Group Code"; "Tax Group Code")
                {
                }
                field("Use Tax"; "Use Tax")
                {
                }
                field("VAT Bus. Posting Group"; "VAT Bus. Posting Group")
                {
                }
                field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
                {
                }
                field("Currency Code"; "Currency Code")
                {
                }
                field("Outstanding Amount (LCY)";"Outstanding Amount (LCY)")
                {
                }
                field("Amt. Rcd. Not Invoiced (LCY)";"Amt. Rcd. Not Invoiced (LCY)")
                {
                }
                field("Reserved Quantity"; "Reserved Quantity")
                {
                }
                field("Blanket Order No."; "Blanket Order No.")
                {
                }
                field("Blanket Order Line No."; "Blanket Order Line No.")
                {
                }
                field("VAT Base Amount"; "VAT Base Amount")
                {
                }
                field("Unit Cost"; "Unit Cost")
                {
                }
                field("System-Created Entry"; "System-Created Entry")
                {
                }
                field("Line Amount"; "Line Amount")
                {
                }
                field("VAT Difference"; "VAT Difference")
                {
                }
                field("Inv. Disc. Amount to Invoice"; "Inv. Disc. Amount to Invoice")
                {
                }
                field("VAT Identifier"; "VAT Identifier")
                {
                }
                field("IC Partner Ref. Type"; "IC Partner Ref. Type")
                {
                }
                field("IC Partner Reference"; "IC Partner Reference")
                {
                }
                field("Prepayment %";"Prepayment %")
                {
                }
                field("Prepmt. Line Amount"; "Prepmt. Line Amount")
                {
                }
                field("Prepmt. Amt. Inv."; "Prepmt. Amt. Inv.")
                {
                }
                field("Prepmt. Amt. Incl. VAT"; "Prepmt. Amt. Incl. VAT")
                {
                }
                field("Prepayment Amount"; "Prepayment Amount")
                {
                }
                field("Prepmt. VAT Base Amt."; "Prepmt. VAT Base Amt.")
                {
                }
                field("Prepayment VAT %";"Prepayment VAT %")
                {
                }
                field("Prepmt. VAT Calc. Type"; "Prepmt. VAT Calc. Type")
                {
                }
                field("Prepayment VAT Identifier"; "Prepayment VAT Identifier")
                {
                }
                field("Prepayment Tax Area Code"; "Prepayment Tax Area Code")
                {
                }
                field("Prepayment Tax Liable"; "Prepayment Tax Liable")
                {
                }
                field("Prepayment Tax Group Code"; "Prepayment Tax Group Code")
                {
                }
                field("Prepmt Amt to Deduct"; "Prepmt Amt to Deduct")
                {
                }
                field("Prepmt Amt Deducted"; "Prepmt Amt Deducted")
                {
                }
                field("Prepayment Line"; "Prepayment Line")
                {
                }
                field("Prepmt. Amount Inv. Incl. VAT"; "Prepmt. Amount Inv. Incl. VAT")
                {
                }
                field("Prepmt. Amount Inv. (LCY)";"Prepmt. Amount Inv. (LCY)")
                {
                }
                field("IC Partner Code"; "IC Partner Code")
                {
                }
                field("Prepayment VAT Difference"; "Prepayment VAT Difference")
                {
                }
                field("Prepmt VAT Diff. to Deduct"; "Prepmt VAT Diff. to Deduct")
                {
                }
                field("Prepmt VAT Diff. Deducted"; "Prepmt VAT Diff. Deducted")
                {
                }
                field("Job Task No."; "Job Task No.")
                {
                }
                field("Job Line Type"; "Job Line Type")
                {
                }
                field("Job Unit Price"; "Job Unit Price")
                {
                }
                field("Job Total Price"; "Job Total Price")
                {
                }
                field("Job Line Amount"; "Job Line Amount")
                {
                }
                field("Job Line Discount Amount"; "Job Line Discount Amount")
                {
                }
                field("Job Line Discount %";"Job Line Discount %")
                {
                }
                field("Job Unit Price (LCY)";"Job Unit Price (LCY)")
                {
                }
                field("Job Total Price (LCY)";"Job Total Price (LCY)")
                {
                }
                field("Job Line Amount (LCY)";"Job Line Amount (LCY)")
                {
                }
                field("Job Line Disc. Amount (LCY)";"Job Line Disc. Amount (LCY)")
                {
                }
                field("Job Currency Factor"; "Job Currency Factor")
                {
                }
                field("Job Currency Code"; "Job Currency Code")
                {
                }
                field("Prod. Order No."; "Prod. Order No.")
                {
                }
                field("Variant Code"; "Variant Code")
                {
                }
                field("Bin Code"; "Bin Code")
                {
                }
                field("Qty. per Unit of Measure"; "Qty. per Unit of Measure")
                {
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                }
                field("Quantity (Base)";"Quantity (Base)")
                {
                }
                field("Outstanding Qty. (Base)";"Outstanding Qty. (Base)")
                {
                }
                field("Qty. to Invoice (Base)";"Qty. to Invoice (Base)")
                {
                }
                field("Qty. to Receive (Base)";"Qty. to Receive (Base)")
                {
                }
                field("Qty. Rcd. Not Invoiced (Base)";"Qty. Rcd. Not Invoiced (Base)")
                {
                }
                field("Qty. Received (Base)";"Qty. Received (Base)")
                {
                }
                field("Qty. Invoiced (Base)";"Qty. Invoiced (Base)")
                {
                }
                field("Reserved Qty. (Base)";"Reserved Qty. (Base)")
                {
                }
                field("FA Posting Date"; "FA Posting Date")
                {
                }
                field("FA Posting Type"; "FA Posting Type")
                {
                }
                field("Depreciation Book Code"; "Depreciation Book Code")
                {
                }
                field("Salvage Value"; "Salvage Value")
                {
                }
                field("Depr. until FA Posting Date"; "Depr. until FA Posting Date")
                {
                }
                field("Depr. Acquisition Cost"; "Depr. Acquisition Cost")
                {
                }
                field("Maintenance Code"; "Maintenance Code")
                {
                }
                field("Insurance No."; "Insurance No.")
                {
                }
                field("Budgeted FA No."; "Budgeted FA No.")
                {
                }
                field("Duplicate in Depreciation Book"; "Duplicate in Depreciation Book")
                {
                }
                field("Use Duplication List"; "Use Duplication List")
                {
                }
                field("Responsibility Center"; "Responsibility Center")
                {
                }
                field("Cross-Reference No."; "Cross-Reference No.")
                {
                }
                field("Unit of Measure (Cross Ref.)";"Unit of Measure (Cross Ref.)")
                {
                }
                field("Cross-Reference Type"; "Cross-Reference Type")
                {
                }
                field("Cross-Reference Type No."; "Cross-Reference Type No.")
                {
                }
                field("Item Category Code"; "Item Category Code")
                {
                }
                field(Nonstock; Nonstock)
                {
                }
                field("Purchasing Code"; "Purchasing Code")
                {
                }
                field("Product Group Code"; "Product Group Code")
                {
                }
                field("Special Order"; "Special Order")
                {
                }
                field("Special Order Sales No."; "Special Order Sales No.")
                {
                }
                field("Special Order Sales Line No."; "Special Order Sales Line No.")
                {
                }
                field("Whse. Outstanding Qty. (Base)";"Whse. Outstanding Qty. (Base)")
                {
                }
                field("Completely Received"; "Completely Received")
                {
                }
                field("Requested Receipt Date"; "Requested Receipt Date")
                {
                }
                field("Promised Receipt Date"; "Promised Receipt Date")
                {
                }
                field("Lead Time Calculation"; "Lead Time Calculation")
                {
                }
                field("Inbound Whse. Handling Time"; "Inbound Whse. Handling Time")
                {
                }
                field("Planned Receipt Date"; "Planned Receipt Date")
                {
                }
                field("Order Date"; "Order Date")
                {
                }
                field("Allow Item Charge Assignment"; "Allow Item Charge Assignment")
                {
                }
                field("Qty. to Assign"; "Qty. to Assign")
                {
                }
                field("Qty. Assigned"; "Qty. Assigned")
                {
                }
                field("Return Qty. to Ship"; "Return Qty. to Ship")
                {
                }
                field("Return Qty. to Ship (Base)";"Return Qty. to Ship (Base)")
                {
                }
                field("Return Qty. Shipped Not Invd."; "Return Qty. Shipped Not Invd.")
                {
                }
                field("Ret. Qty. Shpd Not Invd.(Base)";"Ret. Qty. Shpd Not Invd.(Base)")
                {
                }
                field("Return Shpd. Not Invd."; "Return Shpd. Not Invd.")
                {
                }
                field("Return Shpd. Not Invd. (LCY)";"Return Shpd. Not Invd. (LCY)")
                {
                }
                field("Return Qty. Shipped"; "Return Qty. Shipped")
                {
                }
                field("Return Qty. Shipped (Base)";"Return Qty. Shipped (Base)")
                {
                }
                field("Return Shipment No."; "Return Shipment No.")
                {
                }
                field("Return Shipment Line No."; "Return Shipment Line No.")
                {
                }
                field("Return Reason Code"; "Return Reason Code")
                {
                }
                field("PWD LPSA Description 1"; "PWD LPSA Description 1")
                {
                }
                field("PWD LPSA Description 2"; "PWD LPSA Description 2")
                {
                }
                field("Gen. Account No."; "Gen. Account No.")
                {
                }
                field(Budgeted; Budgeted)
                {
                }
                field("WMS_Status"; WMS_Status)
                {
                }
                field("WMS_Status_Header"; WMS_Status_Header)
                {
                }
                field("WMS_Item"; WMS_Item)
                {
                }
                field("WMS_Location"; WMS_Location)
                {
                }
                field("WMS_Qty receipt error (Base)";"WMS_Qty receipt error (Base)")
                {
                }
                field("WMS_Reason Code Receipt Error"; "WMS_Reason Code Receipt Error")
                {
                }
                field("Routing No."; "Routing No.")
                {
                }
                field("Operation No."; "Operation No.")
                {
                }
                field("Work Center No."; "Work Center No.")
                {
                }
                field(Finished; Finished)
                {
                }
                field("Prod. Order Line No."; "Prod. Order Line No.")
                {
                }
                field("Overhead Rate"; "Overhead Rate")
                {
                }
                field("MPS Order"; "MPS Order")
                {
                }
                field("Planning Flexibility"; "Planning Flexibility")
                {
                }
                field("Safety Lead Time"; "Safety Lead Time")
                {
                }
                field("Routing Reference No."; "Routing Reference No.")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action59>")
            {
                Caption = 'O&rder';
                action("<Action62>")
                {
                    Caption = 'Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    var
                        LpagePurchOrder: Page "Purchase Order";
                                             LrecPurchOrder: Record "Purchase Header";
                    begin
                        LrecPurchOrder.RESET;
                        LrecPurchOrder.SETRANGE("Document Type","Document Type"::Order);
                        LrecPurchOrder.SETRANGE("No.","Document No.");
                        IF NOT LrecPurchOrder.FINDFIRST THEN
                          ERROR('La commande achat N° %1 est introuvable .',"Document No.")
                        ELSE BEGIN
                          LpagePurchOrder.SETTABLEVIEW(LrecPurchOrder);
                        LpagePurchOrder.RUN;
                        END;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SETFILTER("Expected Receipt Date",'..%1',TODAY);
        Rec.SETFILTER("Requested Receipt Date",'..%1',TODAY);
        Rec.SETFILTER("Planned Receipt Date",'..%1',TODAY);
    end;
}

