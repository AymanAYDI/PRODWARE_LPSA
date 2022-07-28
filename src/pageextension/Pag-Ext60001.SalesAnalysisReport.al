pageextension 60001 "PWD SalesAnalysisReport" extends "Sales Analysis Report"
{
    layout
    {
        addlast(Filters)
        {
            field("PWD DateFilter"; DateFilter)
            {
                ApplicationArea = All;
                Caption = 'Date Filter';
                trigger OnValidate()
                begin
                    ValidateDateFilter(DateFilter);
                    if DateFilter <> '' then
                        Rec.SetFilter("Date Filter", DateFilter);
                end;
            }

        }
    }
    var
        AnalysisLine: Record "Analysis Line";
        DateFilter: Text[30];

    local procedure ValidateDateFilter(NewDateFilter: Text[30])
    var
        FilterTokens: Codeunit "Filter Tokens";
    begin
        FilterTokens.MakeDateFilter(NewDateFilter);
        AnalysisLine.SetFilter("Date Filter", NewDateFilter);
        DateFilter := CopyStr(AnalysisLine.GetFilter("Date Filter"), 1, MaxStrLen(DateFilter));
    end;
}