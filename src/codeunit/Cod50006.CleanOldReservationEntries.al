codeunit 50006 "Clean Old Reservation Entries"
{
    Permissions = TableData "Reservation Entry" = rimd;
    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        RecGItemJournalTemplate.SetRange(Type, RecGItemJournalTemplate.Type::"Prod.Order");
        RecGItemJournalTemplate.SetRange(Recurring, false);
        if RecGItemJournalTemplate.FindFirst() then
            repeat
                RecGProductionName.SetRange("Journal Template Name", RecGItemJournalTemplate.Name);
                if RecGProductionName.FindFirst() then
                    repeat
                        RecGItemJnlLine.SetRange("Journal Template Name", RecGProductionName."Journal Template Name");
                        RecGItemJnlLine.SetRange("Journal Batch Name", RecGProductionName.Name);
                        if RecGItemJnlLine.IsEmpty then begin
                            RecGResEntry.SetRange("Source Type", DATABASE::"Item Journal Line");
                            RecGResEntry.SetRange("Source ID", RecGProductionName."Journal Template Name");
                            RecGResEntry.SetRange("Source Batch Name", RecGProductionName.Name);
                            if RecGResEntry.FindFirst() then
                                repeat
                                    RecGResEntryBis.SetRange("Entry No.", RecGResEntry."Entry No.");
                                    if not RecGResEntryBis.IsEmpty then
                                        repeat
                                            RecGResEntryBis.Delete();
                                        until RecGResEntryBis.Next() = 0;
                                until RecGResEntry.Next() = 0;
                        end;
                    until RecGProductionName.Next() = 0;
            until RecGItemJournalTemplate.Next() = 0;


        RecGResEntry.Reset();
        if RecGResEntry.FindFirst() then
            repeat
                if RecGResEntry."Reservation Status" = RecGResEntry."Reservation Status"::Tracking then begin
                    RecGResEntryBis.Reset();
                    RecGResEntryBis.SetRange("Entry No.", RecGResEntry."Entry No.");
                    if RecGResEntryBis.Count <> 2 then
                        RecGResEntryBis.DeleteAll();
                end;
                case RecGResEntry."Source Type" of
                    DATABASE::"Prod. Order Line":
                        begin
                            RecGProdOrderLine.SetFilter(Status, '<>%1', RecGProdOrderLine.Status::Finished);
                            RecGProdOrderLine.SetRange("Prod. Order No.", RecGResEntry."Source ID");
                            RecGProdOrderLine.SetRange("Line No.", RecGResEntry."Source Prod. Order Line");
                            if not RecGProdOrderLine.FindFirst() then begin
                                RecGResEntryBis.Reset();
                                RecGResEntryBis.SetRange("Entry No.", RecGResEntry."Entry No.");
                                RecGResEntryBis.DeleteAll();
                            end;
                        end;
                    DATABASE::"Prod. Order Component":
                        begin
                            //Status,Prod. Order No.,Prod. Order Line No.,Line No.
                            RecGProdOrderComp.SetFilter(Status, '<>%1', RecGProdOrderLine.Status::Finished);
                            RecGProdOrderComp.SetRange("Prod. Order No.", RecGResEntry."Source ID");
                            RecGProdOrderComp.SetRange("Prod. Order Line No.", RecGResEntry."Source Prod. Order Line");
                            RecGProdOrderComp.SetRange("Line No.", RecGResEntry."Source Ref. No.");
                            if not RecGProdOrderComp.FindFirst() then begin
                                RecGResEntryBis.Reset();
                                RecGResEntryBis.SetRange("Entry No.", RecGResEntry."Entry No.");
                                RecGResEntryBis.DeleteAll();
                            end;
                        end;
                end;
            until RecGResEntry.Next() = 0;
    end;

    var
        RecGItemJournalTemplate: Record "Item Journal Template";
        RecGProductionName: Record "Item Journal Batch";
        RecGItemJnlLine: Record "Item Journal Line";
        RecGResEntry: Record "Reservation Entry";
        RecGResEntryBis: Record "Reservation Entry";
        RecGProdOrderComp: Record "Prod. Order Component";
        RecGProdOrderLine: Record "Prod. Order Line";
}

