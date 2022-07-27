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
                ItemLink: Record "PWD Item Link";
            begin
                RecordLink.Reset();
                RecordLink.SetRange("Record ID", Item.RecordId);
                if RecordLink.FindSet() then
                    repeat
                        ItemLink.Init();
                        ItemLink."No." := 0;
                        ItemLink.URL := RecordLink.URL1;
                        ItemLink.Description := RecordLink.Description;
                        ItemLink."Item No." := Item."No.";
                        ItemLink."User Id" := RecordLink."User ID";
                        ItemLink."Creation Date" := RecordLink.Created;
                        ItemLink.Insert();
                    until RecordLink.Next() = 0
            end;
        }
    }
}
