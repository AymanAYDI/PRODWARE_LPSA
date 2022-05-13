reportextension 50002 "PWD CopyProductionForecast" extends "Copy Production Forecast"
{
    requestpage
    {
        layout
        {
            addlast("Copy to")
            {

                field(CustomerNo; ToProdForecastEntry."PWD Customer No.")
                {
                    ApplicationArea = All;
                    Caption = 'Customer No';
                }
            }
        }
        var
            ToProdForecastEntry: Record "Production Forecast Entry";
    }
}