report 50101 "PWD Stock - Out"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Item No." = FIELD("No.");
                DataItemTableView = SORTING("Item No.", Open, "Variant Code", Positive, "Location Code", "Posting Date", "Expiration Date", "Lot No.", "Serial No.") WHERE(Open = CONST(true), "Location Code" = FILTER(<> 'ATELER' & <> 'CREUS' & <> 'CTRL' & <> 'DEC_LASER' & <> 'ENF' & <> 'GENERAL' & <> 'GRAND' & <> 'LAVAGE' & <> 'MEC_MAINT' & <> 'METRO' & <> 'OLIV' & <> 'PERC_BROCH' & <> 'PERC_LASER' & <> 'POLISSAGE' & <> 'SERV_GENE' & <> 'TOURN' & <> 'VERIF'));

                trigger OnAfterGetRecord()
                var
                    RecLILEOut: Record "Item Ledger Entry Out";
                    WhseEntry: Record "Warehouse Entry";
                    RecLLocation: Record Location;
                begin
                    if not RecLILEOut.Get("Entry No.") then begin
                        RecLILEOut.TransferFields("Item Ledger Entry");
                        RecLILEOut.Insert;
                    end;
                end;
            }
            dataitem(Inventory; "Item Ledger Entry")
            {
                DataItemLink = "Item No." = FIELD("No.");
                DataItemTableView = SORTING("Item No.", Open, "Variant Code", Positive, "Location Code", "Posting Date", "Expiration Date", "Lot No.", "Serial No.") WHERE(Open = CONST(true), "Location Code" = FILTER(<> 'ATELER' & <> 'CREUS' & <> 'CTRL' & <> 'DEC_LASER' & <> 'ENF' & <> 'GENERAL' & <> 'GRAND' & <> 'LAVAGE' & <> 'MEC_MAINT' & <> 'METRO' & <> 'OLIV' & <> 'PERC_BROCH' & <> 'PERC_LASER' & <> 'POLISSAGE' & <> 'SERV_GENE' & <> 'TOURN' & <> 'VERIF'));

                trigger OnAfterGetRecord()
                begin
                    RecG83.Init();
                    RecG83."Journal Template Name" := 'ARTICLE';
                    RecG83."Journal Batch Name" := 'COUTS';
                    RecG83."Line No." := LineNo;
                    RecG83.Insert();
                    LineNo += 10000;

                    RecG83.Validate("Item No.", "Item No.");
                    RecG83.Validate("Unit of Measure Code", "Unit of Measure Code");
                    RecG83.Validate("Posting Date", WorkDate());
                    if Positive then
                        RecG83."Entry Type" := RecG83."Entry Type"::"Negative Adjmt."
                    else
                        RecG83."Entry Type" := RecG83."Entry Type"::"Positive Adjmt.";
                    RecG83.Validate("Document No.", "Document No.");
                    RecG83.Validate("Location Code", "Location Code");
                    RecG83.Validate(Quantity, "Remaining Quantity");
                    RecG83.Validate("Source Code", RecGJnlTempl."Source Code");
                    //IF Positive THEN
                    //  RecG83.VALIDATE("Applies-to Entry","Entry No.");
                    RecG83.Modify();
                    if "Lot No." <> '' then
                        FctCreateSerialNos(RecG83, Inventory."Lot No.");
                end;
            }
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

    trigger OnPreReport()
    var
        RecLILEOut: Record "Item Ledger Entry Out";
    begin
        RecLILEOut.DeleteAll;

        RecG83.Reset();
        RecG83.SetRange("Journal Template Name", 'ARTICLE');
        RecG83.SetRange("Journal Batch Name", 'DEFAUT');
        RecG83.DeleteAll();
        /*
        IF RecG83.FINDLAST THEN
          LineNo := RecG83."Line No." + 10000
        ELSE*/

        LineNo := 10000;

        RecGJnlTempl.Get('ARTICLE');

    end;

    var
        LineNo: Integer;
        RecG83: Record "Item Journal Line";
        RecGJnlTempl: Record "Item Journal Template";
        CodGSerialNo: array[999] of Code[20];


    procedure FctCreateSerialNos(RecPItemLine: Record "Item Journal Line"; LotNo: Code[20])
    var
        CduLItemTrackingManagment: Codeunit "LPSA Tracking Management";
        CduLReserveItemJLine: Codeunit "Item Jnl. Line-Reserve";
        RecLTrackingSpecification: Record "Tracking Specification";
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

