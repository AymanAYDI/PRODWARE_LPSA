report 50104 "PWD Stock - In"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Inventory; "PWd Item Ledger Entry Out")
        {
            DataItemTableView = SORTING("Item No.", Open, "Variant Code", Positive, "Location Code", "Posting Date", "Expiration Date", "Lot No.", "Serial No.");
            RequestFilterFields = "Document No.";

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
                RecG83.Validate("Posting Date", 20150731D);
                if "Document No." <> 'RAZ-COUTS' then begin
                    if not Positive then
                        RecG83."Entry Type" := RecG83."Entry Type"::"Negative Adjmt."
                    else
                        RecG83."Entry Type" := RecG83."Entry Type"::"Positive Adjmt.";
                end else
                    "Entry Type" := Inventory."Entry Type";

                RecG83.Validate("Document No.", "Document No.");
                RecG83.Validate("Location Code", "Location Code");
                RecG83.Validate("Bin Code", "Bin Code");
                if "Document No." <> 'RAZ-COUTS' then
                    RecG83.Validate(Quantity, "Remaining Quantity")
                else
                    RecG83.Validate(Quantity, Quantity);

                RecG83.Validate("Source Code", RecGJnlTempl."Source Code");
                //RecG83.VALIDATE("Applies-to Entry","Entry No.");
                RecG83.Modify();
                if "Lot No." <> '' then
                    FctCreateSerialNos(RecG83, Inventory."Lot No.");
            end;

            trigger OnPreDataItem()
            begin
                RecG83.Reset();
                RecG83.SetRange("Journal Template Name", 'ARTICLE');
                RecG83.SetRange("Journal Batch Name", 'COUTS');
                RecG83.DeleteAll();
                /*
                IF RecG83.FINDLAST THEN
                  LineNo := RecG83."Line No." + 10000
                ELSE*/

                LineNo := 10000;

                RecGJnlTempl.Get('ARTICLE');

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

