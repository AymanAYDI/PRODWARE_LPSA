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

            begin
                RecordLink.Reset();
                RecordLink.SetRange("Record ID", Item.RecordId);
                RecordLink.SetFilter(URL1, 'X*');
                if RecordLink.FindSet() then
                    repeat
                        ItemLink.Init();
                        ItemLink."No." := 0;
                        if CopyStr(RecordLink.URL1, 1, 7) = 'X:\Plan' then
                            ItemLink.URL := '\\lp-dc02\Data\Plan' + CopyStr(RecordLink.URL1, 8, StrLen(RecordLink.URL1))
                        else
                            if CopyStr(RecordLink.URL1, 1, 15) = 'X:\PDF Tech NAV' then
                                ItemLink.URL := '\\lp-dc02\Data\PDF Tech NAV' + CopyStr(RecordLink.URL1, 16, StrLen(RecordLink.URL1))
                            else
                                ItemLink.URL := '\\lp-dc02\' + CopyStr(RecordLink.URL1, 3, StrLen(RecordLink.URL1));
                        //ConvertStr(RecordLink.URL1, 'X:', '\\lp-dc02');
                        //ItemLink.URL := RecordLink.URL1;
                        ItemLink.Description := RecordLink.Description;
                        ItemLink."Item No." := Item."No.";
                        ItemLink."User Id" := RecordLink."User ID";
                        ItemLink."Creation Date" := RecordLink.Created;
                        ItemLink.Insert();
                    until RecordLink.Next() = 0
            end;

            trigger OnPreDataItem()
            begin
                ItemLink.DeleteAll();
            end;
        }
    }
    var
        ItemLink: Record "PWD Item Link";

}
