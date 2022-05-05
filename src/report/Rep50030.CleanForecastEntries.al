report 50030 "PWD Clean Forecast Entries"
{
    Caption = 'Clean Forecast Entry';
    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = Tasks;
    dataset
    {
        dataitem("Production Forecast Entry"; "Production Forecast Entry")
        {

            trigger OnAfterGetRecord()
            var
                R99000851: Record "Production Forecast Name";
            begin
                if R99000851.Get("Production Forecast Entry"."Production Forecast Name") then
                    CurrReport.Skip()
                else
                    Delete();
            end;

            trigger OnPostDataItem()
            var
                "99000851": Record "Production Forecast Name";
            begin
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
}

