report 50102 "PWD Inv. Phys. to 0"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Item Ledger Entry Out"; "Item Ledger Entry Out")
        {
            DataItemTableView = WHERE("Location Code" = FILTER('ATELER' | 'CREUS' | 'CTRL' | 'DEC_LASER' | 'ENF' | 'GENERAL' | 'GRAND' | 'LAVAGE' | 'MEC_MAINT' | 'METRO' | 'OLIV' | 'PERC_BROCH' | 'PERC_LASER' | 'POLISSAGE' | 'SERV_GENE' | 'TOURN' | 'VERIF'));

            trigger OnPreDataItem()
            begin
                DeleteAll;
            end;
        }
        dataitem("Item Journal Line"; "Item Journal Line")
        {
            DataItemTableView = WHERE("Journal Template Name" = CONST('INV. PHYS'), "Journal Batch Name" = CONST('COUTS'), "Location Code" = FILTER(= 'ATELER' | 'CREUS' | 'CTRL' | 'DEC_LASER' | 'ENF' | 'GENERAL' | 'GRAND' | 'LAVAGE' | 'MEC_MAINT' | 'METRO' | 'OLIV' | 'PERC_BROCH' | 'PERC_LASER' | 'POLISSAGE' | 'SERV_GENE' | 'TOURN' | 'VERIF'));

            trigger OnAfterGetRecord()
            var
                RecL50100: Record "Item Ledger Entry Out";
                recL342: Record "Default Dimension";
                RecLJLD: Record "Journal Line Dimension";
            begin
                RecL50100.Init;
                RecL50100."Entry No." := EntryNO;
                RecL50100.Validate("Item No.", "Item No.");

                RecL50100.Validate("Unit of Measure Code", "Unit of Measure Code");
                RecL50100.Validate("Posting Date", WorkDate);
                if "Item Journal Line"."Qty. (Calculated)" < 0 then
                    RecL50100."Entry Type" := RecL50100."Entry Type"::"Negative Adjmt."
                else
                    RecL50100."Entry Type" := RecL50100."Entry Type"::"Positive Adjmt.";
                RecL50100.Validate("Document No.", "Document No.");
                RecL50100.Validate("Location Code", "Location Code");
                RecL50100.Validate("Bin Code", "Bin Code");
                RecL50100.Validate(Quantity, "Qty. (Calculated)");
                RecL50100.Validate("Lot No.", "Lot No.");
                RecL50100.Insert;
                recL342.SetRange("Table ID", DATABASE::Item);
                recL342.SetRange("No.", "Item No.");
                recL342.SetFilter("Dimension Value Code", '<>%1', '');
                if recL342.FindFirst then
                    repeat
                        if recL342."Dimension Code" = RecL98."Global Dimension 1 Code" then begin
                            RecL50100."Global Dimension 1 Code" := recL342."Dimension Value Code";
                            "Item Journal Line".Validate("Shortcut Dimension 1 Code", recL342."Dimension Value Code");
                            if not RecLJLD.Get(DATABASE::"Item Journal Line", "Journal Template Name", "Journal Batch Name", "Line No.", 0,
                              recL342."Dimension Code") then begin
                                RecLJLD.Init;
                                RecLJLD.Validate("Table ID", DATABASE::"Item Journal Line");
                                RecLJLD.Validate("Journal Template Name", "Item Journal Line"."Journal Template Name");
                                RecLJLD.Validate("Journal Batch Name", "Item Journal Line"."Journal Batch Name");
                                RecLJLD.Validate("Journal Line No.", "Item Journal Line"."Line No.");
                                RecLJLD.Validate("Dimension Code", recL342."Dimension Code");
                                RecLJLD.Validate("Dimension Value Code", recL342."Dimension Value Code");
                                RecLJLD.Insert;
                            end;
                        end;
                        if recL342."Dimension Code" = RecL98."Global Dimension 2 Code" then begin
                            RecL50100."Global Dimension 2 Code" := recL342."Dimension Value Code";
                            "Item Journal Line".Validate("Shortcut Dimension 2 Code", recL342."Dimension Value Code");
                            if not RecLJLD.Get(DATABASE::"Item Journal Line", "Journal Template Name", "Journal Batch Name", "Line No.", 0,
                              recL342."Dimension Code") then begin

                                RecLJLD.Init;
                                RecLJLD.Validate("Table ID", DATABASE::"Item Journal Line");
                                RecLJLD.Validate("Journal Template Name", "Item Journal Line"."Journal Template Name");
                                RecLJLD.Validate("Journal Batch Name", "Item Journal Line"."Journal Batch Name");
                                RecLJLD.Validate("Journal Line No.", "Item Journal Line"."Line No.");
                                RecLJLD.Validate("Dimension Code", recL342."Dimension Code");
                                RecLJLD.Validate("Dimension Value Code", recL342."Dimension Value Code");
                                RecLJLD.Insert;
                            end;
                        end;
                        RecL50100.Modify;
                        "Item Journal Line".Modify;

                    until recL342.Next = 0;

                EntryNO += 1;

                "Item Journal Line".Validate("Qty. (Phys. Inventory)", 0);
                Modify;
            end;

            trigger OnPreDataItem()
            var
                RecL50100: Record "Item Ledger Entry Out";
            begin
                RecL98.Get;


                RecGJnlTempl.Get('INV. PHYS');
                if RecL50100.FindLast then
                    EntryNO := RecL50100."Entry No." + 1;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        EntryNO: Integer;
        RecGJnlTempl: Record "Item Journal Template";
        CduGTracking: Codeunit "Item Tracking Management";
        CodGSerialNo: array[999] of Code[20];
        RecL98: Record "General Ledger Setup";


    procedure FctCreateSerialNos(RecPItemLine: Record "Item Journal Line"; LotNo: Code[20])
    var
        CduLItemTrackingManagment: Codeunit "LPSA Tracking Management";
        CduLReserveItemJLine: Codeunit "Item Jnl. Line-Reserve";
        DecLSecondSourceQtyArray: array[3] of Decimal;
        RecLTrackingSpecification: Record "Tracking Specification";
        RecLItemUOM: Record "Item Unit of Measure";
        DecLQtyToHandleBase: Decimal;
        DecLTemp: Decimal;
        i: Integer;
        LineNo: Integer;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
    begin
        //Simulate Page(6510) initialization
        CduLReserveItemJLine.InitTrackingSpecification(RecPItemLine, RecLTrackingSpecification);
        CduLItemTrackingManagment.SetFormRunMode(9);
        CduLItemTrackingManagment.SetSecondSourceRowID(ItemTrackingMgt.ComposeRowID(DATABASE::"Item Journal Line",
          1, RecPItemLine."Document No.", '', 0, RecPItemLine."Line No."));
        CduLItemTrackingManagment.SetSource(RecLTrackingSpecification, RecPItemLine."Document Date");
        CduLItemTrackingManagment.UpdateUndefinedQty2;
        CodGSerialNo[1] := LotNo;
        CduLItemTrackingManagment.InsertLine(CodGSerialNo, RecPItemLine."Quantity (Base)", RecLTrackingSpecification);
    end;
}

