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
        field(50001; "Starting Date-Time (P1)"; DateTime)
        {
            Caption = 'Starting Date-Time (P1)';

            trigger OnValidate()
            begin
                "Starting Date" := DT2DATE("Starting Date-Time");
                "Starting Time" := DT2TIME("Starting Date-Time");
                VALIDATE("Starting Time");
            end;
        }
        field(50002; "Ending Date-Time (P1)"; DateTime)
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

    procedure SetProdOrderLineDates()
    begin
        //PLAW11.0
        //PLAW12.0 : change to more reliable condition for first and last operation
        IF ("Previous Operation No." = '') OR ("Next Operation No." = '') THEN BEGIN
            ProdOrderLine.SETCURRENTKEY(Status, "Prod. Order No.", "Routing No.", "Routing Reference No.");
            ProdOrderLine.SETRANGE(Status, Status);
            ProdOrderLine.SETRANGE("Prod. Order No.", "Prod. Order No.");
            ProdOrderLine.SETRANGE("Routing No.", "Routing No.");
            ProdOrderLine.SETRANGE("Routing Reference No.", "Routing Reference No.");
            IF ProdOrderLine.FIND('-') THEN
                REPEAT
                    // PLAW14.0.6
                    ProdOrderLine.BlockDynamicTracking(TRUE);

                    // PLAW12.0 : code moved in validate trigger
                    // Set Prod. Starting Date-Time
                    IF "Previous Operation No." = '' THEN
                        ProdOrderLine.VALIDATE("Prod. Starting Date-Time", "Starting Date-Time");

                    // Set Prod. Ending Date-Time
                    IF "Next Operation No." = '' THEN
                        ProdOrderLine.VALIDATE("Prod. Ending Date-Time", "Ending Date-Time");
                    //PLAW12.0 END

                    ProdOrderLine.MODIFY(TRUE);
                UNTIL ProdOrderLine.NEXT = 0;
        END;
        //PLAW11.0 END
    end;

    procedure RecalculateComponents()
    var
        ProdOrderComp: Record "Prod. Order Component";
    begin
        //PLAW11.0
        // Copy of "Calculate Prod. Order".CalculateComponents() restricted to the current routing link code
        IF "Routing Link Code" <> '' THEN BEGIN
            ProdOrderComp.SETRANGE(Status, Status);
            ProdOrderComp.SETRANGE("Prod. Order No.", "Prod. Order No.");
            ProdOrderComp.SETRANGE("Prod. Order Line No.", "Routing Reference No.");
            ProdOrderComp.SETRANGE("Routing Link Code", "Routing Link Code");
            IF ProdOrderComp.FIND('-') THEN
                REPEAT
                    RecalculateComponent(ProdOrderComp);
                UNTIL ProdOrderComp.NEXT = 0;
        END;

        // update components whith no routing link code
        // PLAW12.0 : use "Previous Operation No." = '' instead of "Sequence Number (Forward)" = 1
        IF "Previous Operation No." = '' THEN BEGIN
            ProdOrderComp.SETRANGE(Status, Status);
            ProdOrderComp.SETRANGE("Prod. Order No.", "Prod. Order No.");
            ProdOrderComp.SETRANGE("Prod. Order Line No.", "Routing Reference No.");
            ProdOrderComp.SETRANGE("Routing Link Code", '');
            IF ProdOrderComp.FIND('-') THEN
                REPEAT
                    RecalculateComponent(ProdOrderComp);
                UNTIL ProdOrderComp.NEXT = 0;
        END;
        //PLAW11.0 END
    end;

    procedure RecalculateComponent(ProdOrderComp: Record "Prod. Order Component")
    begin
        //PLAW11.0
        ProdOrderComp.BlockDynamicTracking(TRUE);
        ProdOrderComp."Due Date" := "Starting Date";
        ProdOrderComp."Due Time" := "Starting Time";
        IF FORMAT(ProdOrderComp."Production Lead Time") <> '' THEN BEGIN
            ProdOrderComp."Due Date" :=
              ProdOrderComp."Due Date" - (CALCDATE(ProdOrderComp."Production Lead Time", WORKDATE) - WORKDATE);
            ProdOrderComp."Due Time" := 0T;
        END;
        ProdOrderComp.VALIDATE("Due Date");
        ProdOrderComp.MODIFY;
        ProdOrderComp.AutoReserve;
        //PLAW11.0 END
    end;

    procedure CheckAlternate()
    var
        TEXT001: Label 'Alternate resource %1 %2 was replaced by resource %3 %4.';
    begin
        // PLAW1 2.1 END
        // PLAW12.2 Check LICENSE
        IF ApplicationManagement.CheckPlannerOneLicence THEN
            IF ((Type <> xRec.Type) OR ("No." <> xRec."No."))
              AND ProdOrderRtngLineAlt.GET(Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.",
                                       Type, "No.") THEN BEGIN
                ProdOrderRtngLineAlt.RENAME(Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.",
                                        xRec.Type, xRec."No.");
                ProdOrderRtngLineAlt.TRANSFERFIELDS(xRec);
                ProdOrderRtngLineAlt.MODIFY;
                MESSAGE(TEXT001, Type, "No.", xRec.Type, xRec."No.");
            END;
        // PLAW1 2.1 END
    end;

    procedure CalculateRoutingLine()
    var
        CalcProdOrderRtngLine: Codeunit "Calculate Routing Line";
    begin
        // PLAW1 2.1.1
        IF DateChangedByPlannerOne THEN BEGIN
            CalcProdOrderRtngLine.CalculateRoutingLineP1(Rec);
        END;
        // PLAW1 2.1.1 END
    end;

    var
        DateChangedByPlannerOne: Boolean;
        ApplicationManagement: Codeunit ApplicationManagement;
}

