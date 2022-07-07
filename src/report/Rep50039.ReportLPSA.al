report 50039 "PWD ReportLPSA"
{
    ApplicationArea = All;
    Caption = 'ReportLPSA';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem(Item; Item)
        {
            trigger OnAfterGetRecord()
            var
                RecordLink: Record "Record Link";
                DocumentAttach: Record "Document Attachment";
                FileManagement: Codeunit "File Management";
                TempBlob: Codeunit "Temp Blob";
                RecRef: RecordRef;
            begin
                RecRef.GetTable(Item);
                RecordLink.Reset();
                RecordLink.SetRange("Record ID", Item.RecordId);
                if RecordLink.FindSet() then
                    repeat
                        if FileManagement.ServerFileExists(RecordLink.URL1) then begin
                            Clear(DocumentAttach);
                            FileManagement.BLOBImportFromServerFile(TempBlob, RecordLink.URL1);
                            DocumentAttach.SaveAttachment(RecRef, RecordLink.URL1, TempBlob);
                        end;
                    until RecordLink.Next() = 0
            end;
        }
    }
}
