reportextension 50066 "PWD CopyProductionForecast" extends "Copy Production Forecast"
{
    requestpage
    {
        layout
        {
            addlast("Copy to")
            {

                field(CustomerNo; ToProdForecastEntry."PWD Customer No.")
                {
                    ApplicationArea = Planning;
                    Caption = 'Customer No';
                    ToolTip = 'Specifies a Customer No for the demand forecast to which you are copying entries.';
                }
            }
        }
        var
            ToProdForecastEntry: Record "Production Forecast Entry";
    }
}