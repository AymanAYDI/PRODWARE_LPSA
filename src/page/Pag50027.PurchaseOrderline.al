page 50027 "PWD Purchase Order line"
{
    Caption = 'Lignes Commandes Achat';
    Editable = false;
    PageType = List;
    SourceTable = "Purchase Line";
    SourceTableView = WHERE("Document Type" = FILTER(Order));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Line No."; Rec."Line No.")
                {
                }
                field(Type; Type)
                {
                }
                field("No."; Rec."No.")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Posting Group"; Rec."Posting Group")
                {
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                }
                field(Description; Description)
                {
                }
                field("Description 2"; Rec."Description 2")
                {
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                }
                field("Qty. to Invoice"; Rec."Qty. to Invoice")
                {
                }
                field("Qty. to Receive"; Rec."Qty. to Receive")
                {
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
                {
                }
                field("VAT %"; Rec."VAT %")
                {
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                }
                field(Amount; Amount)
                {
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                }
                field("Unit Price (LCY)"; Rec."Unit Price (LCY)")
                {
                }
                field("Allow Invoice Disc."; Rec."Allow Invoice Disc.")
                {
                }
                field("Gross Weight"; Rec."Gross Weight")
                {
                }
                field("Net Weight"; Rec."Net Weight")
                {
                }
                field("Units per Parcel"; Rec."Units per Parcel")
                {
                }
                field("Unit Volume"; Rec."Unit Volume")
                {
                }
                field("Appl.-to Item Entry"; Rec."Appl.-to Item Entry")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                }
                field("Job No."; Rec."Job No.")
                {
                }
                field("Indirect Cost %"; Rec."Indirect Cost %")
                {
                }
                field("Outstanding Amount"; Rec."Outstanding Amount")
                {
                }
                field("Qty. Rcd. Not Invoiced"; Rec."Qty. Rcd. Not Invoiced")
                {
                }
                field("Amt. Rcd. Not Invoiced"; Rec."Amt. Rcd. Not Invoiced")
                {
                }
                field("Quantity Received"; Rec."Quantity Received")
                {
                }
                field("Quantity Invoiced"; Rec."Quantity Invoiced")
                {
                }
                field("Receipt No."; Rec."Receipt No.")
                {
                }
                field("Receipt Line No."; Rec."Receipt Line No.")
                {
                }
                field("Profit %"; Rec."Profit %")
                {
                }
                field("Pay-to Vendor No."; Rec."Pay-to Vendor No.")
                {
                }
                field("Inv. Discount Amount"; Rec."Inv. Discount Amount")
                {
                }
                field("Vendor Item No."; Rec."Vendor Item No.")
                {
                }
                field("Sales Order No."; Rec."Sales Order No.")
                {
                }
                field("Sales Order Line No."; Rec."Sales Order Line No.")
                {
                }
                field("Drop Shipment"; Rec."Drop Shipment")
                {
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                }
                field("VAT Calculation Type"; Rec."VAT Calculation Type")
                {
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                }
                field("Transport Method"; Rec."Transport Method")
                {
                }
                field("Attached to Line No."; Rec."Attached to Line No.")
                {
                }
                field("Entry Point"; Rec."Entry Point")
                {
                }
                field("Area"; Area)
                {
                }
                field("Transaction Specification"; Rec."Transaction Specification")
                {
                }
                field("Tax Area Code"; Rec."Tax Area Code")
                {
                }
                field("Tax Liable"; Rec."Tax Liable")
                {
                }
                field("Tax Group Code"; Rec."Tax Group Code")
                {
                }
                field("Use Tax"; Rec."Use Tax")
                {
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                }
                field("Currency Code"; Rec."Currency Code")
                {
                }
                field("Outstanding Amount (LCY)"; Rec."Outstanding Amount (LCY)")
                {
                }
                field("Amt. Rcd. Not Invoiced (LCY)"; Rec."Amt. Rcd. Not Invoiced (LCY)")
                {
                }
                field("Reserved Quantity"; Rec."Reserved Quantity")
                {
                }
                field("Blanket Order No."; Rec."Blanket Order No.")
                {
                }
                field("Blanket Order Line No."; Rec."Blanket Order Line No.")
                {
                }
                field("VAT Base Amount"; Rec."VAT Base Amount")
                {
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                }
                field("System-Created Entry"; Rec."System-Created Entry")
                {
                }
                field("Line Amount"; Rec."Line Amount")
                {
                }
                field("VAT Difference"; Rec."VAT Difference")
                {
                }
                field("Inv. Disc. Amount to Invoice"; Rec."Inv. Disc. Amount to Invoice")
                {
                }
                field("VAT Identifier"; Rec."VAT Identifier")
                {
                }
                field("IC Partner Ref. Type"; Rec."IC Partner Ref. Type")
                {
                }
                field("IC Partner Reference"; Rec."IC Partner Reference")
                {
                }
                field("Prepayment %"; Rec."Prepayment %")
                {
                }
                field("Prepmt. Line Amount"; Rec."Prepmt. Line Amount")
                {
                }
                field("Prepmt. Amt. Inv."; Rec."Prepmt. Amt. Inv.")
                {
                }
                field("Prepmt. Amt. Incl. VAT"; Rec."Prepmt. Amt. Incl. VAT")
                {
                }
                field("Prepayment Amount"; Rec."Prepayment Amount")
                {
                }
                field("Prepmt. VAT Base Amt."; Rec."Prepmt. VAT Base Amt.")
                {
                }
                field("Prepayment VAT %"; Rec."Prepayment VAT %")
                {
                }
                field("Prepmt. VAT Calc. Type"; Rec."Prepmt. VAT Calc. Type")
                {
                }
                field("Prepayment VAT Identifier"; Rec."Prepayment VAT Identifier")
                {
                }
                field("Prepayment Tax Area Code"; Rec."Prepayment Tax Area Code")
                {
                }
                field("Prepayment Tax Liable"; Rec."Prepayment Tax Liable")
                {
                }
                field("Prepayment Tax Group Code"; Rec."Prepayment Tax Group Code")
                {
                }
                field("Prepmt Amt to Deduct"; Rec."Prepmt Amt to Deduct")
                {
                }
                field("Prepmt Amt Deducted"; Rec."Prepmt Amt Deducted")
                {
                }
                field("Prepayment Line"; Rec."Prepayment Line")
                {
                }
                field("Prepmt. Amount Inv. Incl. VAT"; Rec."Prepmt. Amount Inv. Incl. VAT")
                {
                }
                field("Prepmt. Amount Inv. (LCY)"; Rec."Prepmt. Amount Inv. (LCY)")
                {
                }
                field("IC Partner Code"; Rec."IC Partner Code")
                {
                }
                field("Prepayment VAT Difference"; Rec."Prepayment VAT Difference")
                {
                }
                field("Prepmt VAT Diff. to Deduct"; Rec."Prepmt VAT Diff. to Deduct")
                {
                }
                field("Prepmt VAT Diff. Deducted"; Rec."Prepmt VAT Diff. Deducted")
                {
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                }
                field("Job Line Type"; Rec."Job Line Type")
                {
                }
                field("Job Unit Price"; Rec."Job Unit Price")
                {
                }
                field("Job Total Price"; Rec."Job Total Price")
                {
                }
                field("Job Line Amount"; Rec."Job Line Amount")
                {
                }
                field("Job Line Discount Amount"; Rec."Job Line Discount Amount")
                {
                }
                field("Job Line Discount %"; Rec."Job Line Discount %")
                {
                }
                field("Job Unit Price (LCY)"; Rec."Job Unit Price (LCY)")
                {
                }
                field("Job Total Price (LCY)"; Rec."Job Total Price (LCY)")
                {
                }
                field("Job Line Amount (LCY)"; Rec."Job Line Amount (LCY)")
                {
                }
                field("Job Line Disc. Amount (LCY)"; Rec."Job Line Disc. Amount (LCY)")
                {
                }
                field("Job Currency Factor"; Rec."Job Currency Factor")
                {
                }
                field("Job Currency Code"; Rec."Job Currency Code")
                {
                }
                field("Prod. Order No."; Rec."Prod. Order No.")
                {
                }
                field("Variant Code"; Rec."Variant Code")
                {
                }
                field("Bin Code"; Rec."Bin Code")
                {
                }
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
                {
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                }
                field("Quantity (Base)"; Rec."Quantity (Base)")
                {
                }
                field("Outstanding Qty. (Base)"; Rec."Outstanding Qty. (Base)")
                {
                }
                field("Qty. to Invoice (Base)"; Rec."Qty. to Invoice (Base)")
                {
                }
                field("Qty. to Receive (Base)"; Rec."Qty. to Receive (Base)")
                {
                }
                field("Qty. Rcd. Not Invoiced (Base)"; Rec."Qty. Rcd. Not Invoiced (Base)")
                {
                }
                field("Qty. Received (Base)"; Rec."Qty. Received (Base)")
                {
                }
                field("Qty. Invoiced (Base)"; Rec."Qty. Invoiced (Base)")
                {
                }
                field("Reserved Qty. (Base)"; Rec."Reserved Qty. (Base)")
                {
                }
                field("FA Posting Date"; Rec."FA Posting Date")
                {
                }
                field("FA Posting Type"; Rec."FA Posting Type")
                {
                }
                field("Depreciation Book Code"; Rec."Depreciation Book Code")
                {
                }
                field("Salvage Value"; Rec."Salvage Value")
                {
                }
                field("Depr. until FA Posting Date"; Rec."Depr. until FA Posting Date")
                {
                }
                field("Depr. Acquisition Cost"; Rec."Depr. Acquisition Cost")
                {
                }
                field("Maintenance Code"; Rec."Maintenance Code")
                {
                }
                field("Insurance No."; Rec."Insurance No.")
                {
                }
                field("Budgeted FA No."; Rec."Budgeted FA No.")
                {
                }
                field("Duplicate in Depreciation Book"; Rec."Duplicate in Depreciation Book")
                {
                }
                field("Use Duplication List"; Rec."Use Duplication List")
                {
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                }
                field("Cross-Reference No."; Rec."Cross-Reference No.")
                {
                }
                field("Unit of Measure (Cross Ref.)"; Rec."Unit of Measure (Cross Ref.)")
                {
                }
                field("Cross-Reference Type"; Rec."Cross-Reference Type")
                {
                }
                field("Cross-Reference Type No."; Rec."Cross-Reference Type No.")
                {
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                }
                field(Nonstock; Nonstock)
                {
                }
                field("Purchasing Code"; Rec."Purchasing Code")
                {
                }
                //TODO: Field 'Product Group Code' is removed
                // field("Product Group Code"; Rec."Product Group Code")
                // {
                // }
                field("Special Order"; Rec."Special Order")
                {
                }
                field("Special Order Sales No."; Rec."Special Order Sales No.")
                {
                }
                field("Special Order Sales Line No."; Rec."Special Order Sales Line No.")
                {
                }
                field("Whse. Outstanding Qty. (Base)"; Rec."Whse. Outstanding Qty. (Base)")
                {
                }
                field("Completely Received"; Rec."Completely Received")
                {
                }
                field("Requested Receipt Date"; Rec."Requested Receipt Date")
                {
                }
                field("Promised Receipt Date"; Rec."Promised Receipt Date")
                {
                }
                field("Lead Time Calculation"; Rec."Lead Time Calculation")
                {
                }
                field("Inbound Whse. Handling Time"; Rec."Inbound Whse. Handling Time")
                {
                }
                field("Planned Receipt Date"; Rec."Planned Receipt Date")
                {
                }
                field("Order Date"; Rec."Order Date")
                {
                }
                field("Allow Item Charge Assignment"; Rec."Allow Item Charge Assignment")
                {
                }
                field("Qty. to Assign"; Rec."Qty. to Assign")
                {
                }
                field("Qty. Assigned"; Rec."Qty. Assigned")
                {
                }
                field("Return Qty. to Ship"; Rec."Return Qty. to Ship")
                {
                }
                field("Return Qty. to Ship (Base)"; Rec."Return Qty. to Ship (Base)")
                {
                }
                field("Return Qty. Shipped Not Invd."; Rec."Return Qty. Shipped Not Invd.")
                {
                }
                field("Ret. Qty. Shpd Not Invd.(Base)"; Rec."Ret. Qty. Shpd Not Invd.(Base)")
                {
                }
                field("Return Shpd. Not Invd."; Rec."Return Shpd. Not Invd.")
                {
                }
                field("Return Shpd. Not Invd. (LCY)"; Rec."Return Shpd. Not Invd. (LCY)")
                {
                }
                field("Return Qty. Shipped"; Rec."Return Qty. Shipped")
                {
                }
                field("Return Qty. Shipped (Base)"; Rec."Return Qty. Shipped (Base)")
                {
                }
                field("Return Shipment No."; Rec."Return Shipment No.")
                {
                }
                field("Return Shipment Line No."; Rec."Return Shipment Line No.")
                {
                }
                field("Return Reason Code"; Rec."Return Reason Code")
                {
                }
                field("PWD LPSA Description 1"; Rec."PWD LPSA Description 1")
                {
                }
                field("PWD LPSA Description 2"; Rec."PWD LPSA Description 2")
                {
                }
                field("Gen. Account No."; Rec."PWD Gen. Account No.")
                {
                }
                field(Budgeted; Rec."PWD Budgeted")
                {
                }
                field("WMS_Status"; Rec."PWD WMS_Status")
                {
                }
                field("WMS_Status_Header"; Rec."PWD WMS_Status_Header")
                {
                }
                field("WMS_Item"; Rec."PWD WMS_Item")
                {
                }
                field("WMS_Location"; Rec."PWD WMS_Location")
                {
                }
                field("WMS_Qty receipt error (Base)"; Rec."PWD WMS_Qty receipt error (Base)")
                {
                }
                field("WMS_Reason Code Receipt Error"; Rec."PWD WMS_Reason Code Receipt Error")
                {
                }
                field("Routing No."; Rec."Routing No.")
                {
                }
                field("Operation No."; Rec."Operation No.")
                {
                }
                field("Work Center No."; Rec."Work Center No.")
                {
                }
                field(Finished; Finished)
                {
                }
                field("Prod. Order Line No."; Rec."Prod. Order Line No.")
                {
                }
                field("Overhead Rate"; Rec."Overhead Rate")
                {
                }
                field("MPS Order"; Rec."MPS Order")
                {
                }
                field("Planning Flexibility"; Rec."Planning Flexibility")
                {
                }
                field("Safety Lead Time"; Rec."Safety Lead Time")
                {
                }
                field("Routing Reference No."; Rec."Routing Reference No.")
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
                        LrecPurchOrder.RESET();
                        LrecPurchOrder.SETRANGE("Document Type", "Document Type"::Order);
                        LrecPurchOrder.SETRANGE("No.", "Document No.");
                        IF NOT LrecPurchOrder.FINDFIRST() THEN
                            ERROR('La commande achat N° %1 est introuvable .', "Document No.")
                        ELSE BEGIN
                            LpagePurchOrder.SETTABLEVIEW(LrecPurchOrder);
                            LpagePurchOrder.RUN();
                        END;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SETFILTER("Expected Receipt Date", '..%1', TODAY);
        Rec.SETFILTER("Requested Receipt Date", '..%1', TODAY);
        Rec.SETFILTER("Planned Receipt Date", '..%1', TODAY);
    end;
}

