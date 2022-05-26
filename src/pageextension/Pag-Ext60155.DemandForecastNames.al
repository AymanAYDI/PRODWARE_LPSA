pageextension 60155 "PWD DemandForecastNames" extends "Demand Forecast Names"
{
    layout
    {
        modify(Name)
        {
            trigger OnAssistEdit()
            var
                DemandForecast: Page "PWD Demand Forecast";
            begin
                DemandForecast.SetProductionForecastName(Name);
                DemandForecast.Run();
            end;
        }
    }
    actions
    {
        modify("Edit Demand Forecast")
        {
            Visible = false;
        }
        addafter("Edit Demand Forecast")
        {
            action("PWD Edit Demand Forecast")
            {
                ApplicationArea = Planning;
                Caption = 'Edit Demand Forecast';
                Image = EditForecast;
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'Return';
                trigger OnAction()
                var
                    DemandForecast: Page "PWD Demand Forecast";
                begin
                    DemandForecast.SetProductionForecastName(Name);
                    DemandForecast.Run();
                end;
            }
        }
    }
}