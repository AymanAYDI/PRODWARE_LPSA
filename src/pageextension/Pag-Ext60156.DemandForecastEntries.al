
pageextension 60156 "PWD DemandForecastEntries" extends "Demand Forecast Entries"
{
    // //>>LAP080615
    // TO 06/06/2015 : Customer Filter
    //                 -Add Field
    // 
    // //>>REGIE
    // RO 22/10/2019 : Add Field Forecast Origin

    //Unsupported feature: Property Insertion (SourceTableView) on ""Production Forecast Entries"(Page 99000922)".

    layout
    {
        addafter("Entry No.")
        {
            field("PWD Customer No."; Rec."PWD Customer No.")
            {
                ApplicationArea = All;
            }
            field("PWD Customer Name"; Rec."PWD Customer Name")
            {
                ApplicationArea = All;
            }
            field("PWD Forecast Origin"; Rec."PWD Forecast Origin")
            {
                ApplicationArea = All;
            }
        }
    }
}

