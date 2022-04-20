tableextension 60070 "PWD ProductionForecastEntry" extends "Production Forecast Entry"
{
    // //>>LAP080615
    // TO 06/06/2015 : Customer Filter
    //                 -Add Field 50000
    // 
    // //>>LAP181016
    // RO 18/10/2016 : Modif C/AL Code in trigger OnInsert()
    // 
    // //>>REGIE
    // RO 22/10/2019 : Add Field 50002 - Forecast Origin - Option

    fields
    {
        field(50000; "PWD Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            Description = 'LAP080615';
            TableRelation = Customer;
        }
        field(50001; "PWD Customer Name"; Text[100])
        {
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("PWD Customer No.")));
            Caption = 'Customer Name';
            Description = 'LAP080615';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002; "PWD Forecast Origin"; Option)
        {
            Caption = 'Forecast Origin';
            Description = 'REGIE';
            OptionCaption = ' ,Customer Order,Customer Forecast,LPSA Forecast,Simulation';
            OptionMembers = " ","Customer Order","Customer Forecast","LPSA Forecast",Simulation;
        }
    }
    keys
    {
        // key(Key4; "Production Forecast Name", "Item No.", "Component Forecast", "Forecast Date", "Location Code", "PWD Customer No.")
        // {
        //     SumIndexFields = "Forecast Quantity (Base)";
        // }
    }
}
