tableextension 60039 "PWD ProdOrderRoutingLine" extends "Prod. Order Routing Line"
{
    // PLAW1 -----------------------------------------------------------------------------
    // PLAW1-2.1   2013-06-25 PO-3699: calculate prod. order capacity needs (table 5410)
    // PLAW1-2.1.1 2013-07-05 PO-3699: refactor prod. order capacity needs calculation (table 5410)
    // PLAW1-4.0   2014-02-06 PO-3706: add SetupAggregationRule and ActualSetupTime
    // PLAW1-4.0.6 2014-02-02 PO-4982: block dynamic tracking on Production order line 
    // PLAW1 -----------------------------------------------------------------------------
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.20
    // P24578_007 : RO 03/09/2019 : for TPL R50045
    //              Add key Routing No.
    // 
    // ------------------------------------------------------------------------------------------------------------------
    fields
    {
        field(50000; "PWD Processed"; Boolean)
        {
        }
        field(50001; "PWD Start. Date-Time (P1)"; DateTime)
        {
            Caption = 'Starting Date-Time (P1)';

            trigger OnValidate()
            begin
                "Starting Date" := DT2DATE("Starting Date-Time");
                "Starting Time" := DT2TIME("Starting Date-Time");
                VALIDATE("Starting Time");
            end;
        }
        field(50002; "PWD End. Date-Time (P1)"; DateTime)
        {
            Caption = 'Ending Date-Time (P1)';

            trigger OnValidate()
            begin
                "Ending Date" := DT2DATE("Ending Date-Time");
                "Ending Time" := DT2TIME("Ending Date-Time");
                VALIDATE("Ending Time");
            end;
        }
    }
    keys
    {
        key(Key50000; Status, Type, "No.", "Starting Date") { SumIndexFields = "Expected Capacity Need"; }
        key(Key50001; "Routing No.") { }

    }
}

