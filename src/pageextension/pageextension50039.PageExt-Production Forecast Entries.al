pageextension 50039 pageextension50039 extends "Production Forecast Entries"
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
        addafter("Control 24")
        {
            field("Customer No."; "Customer No.")
            {
                ApplicationArea = All;
            }
            field("Customer Name"; "Customer Name")
            {
                ApplicationArea = All;
            }
            field("Forecast Origin"; "Forecast Origin")
            {
                ApplicationArea = All;
            }
        }
    }
}

