report 99070 "PWD Update Gammes OF  PIERRES"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            DataItemTableView = SORTING(Status, "No.") WHERE(Status = FILTER(<= Released), "Location Code" = FILTER(<> 'ACI'));

            trigger OnAfterGetRecord()
            var
                Item: Record Item;
                ProdOrderLine: Record "Prod. Order Line";
                ProdOrderRtngLine: Record "Prod. Order Routing Line";
                ProdOrderComp: Record "Prod. Order Component";
                Family: Record Family;
                ProdOrderStatusMgt: Codeunit "Prod. Order Status Management";
                RoutingNo: Code[20];
                RH: Record "Routing Header";
                RoutingLine: Record "Routing Line";
                RecLRL: Record "Routing Line";
            begin
                if "Production Order".Status = "Production Order".Status::Finished then
                    CurrReport.Skip;

                if Direction = Direction::Backward then
                    TestField("Due Date");

                ProdOrderLine.SetRange(Status, Status);
                ProdOrderLine.SetRange("Prod. Order No.", "No.");
                if ProdOrderLine.FindFirst then
                    if not (ProdOrderLine.PlanningGroup in ['PIERRES', 'PREPARAGES', 'LEVEES_ELI']) then
                        CurrReport.Skip;


                RecLRoutingH.Init;
                RecLRoutingH."No." := "Production Order"."No.";
                RecLRoutingH.Description := "Production Order"."No.";
                RecLRoutingH.Status := RecLRoutingH.Status::"Under Development";
                RecLRoutingH.Type := RecLRoutingH.Type::Parallel;
                RecLRoutingH.PlanningGroup := ProdOrderLine.PlanningGroup;
                RecLRoutingH.Insert;

                ProdOrderRtngLine.SetRange(Status, Status);
                ProdOrderRtngLine.SetRange("Prod. Order No.", "No.");
                ProdOrderRtngLine.SetRange("Routing Reference No.", ProdOrderLine."Routing Reference No.");
                ProdOrderRtngLine.SetRange("Routing No.", ProdOrderLine."Routing No.");
                if ProdOrderRtngLine.FindFirst then
                    repeat
                        RoutingLine.Init;
                        RoutingLine."Routing No." := "No.";
                        RoutingLine."Operation No." := ProdOrderRtngLine."Operation No.";
                        RoutingLine."Next Operation No." := ProdOrderRtngLine."Next Operation No.";
                        RoutingLine."Previous Operation No." := ProdOrderRtngLine."Previous Operation No.";
                        RoutingLine.Type := ProdOrderRtngLine.Type;
                        if (RoutingLine.Type = ProdOrderRtngLine.Type::"Machine Center") and
                          ((RoutingLine."No." = 'M00000') or (RoutingLine."No." = 'M99999')) then
                            case ProdOrderLine.PlanningGroup of
                                'LEVEES_ELI':
                                    begin
                                        if RoutingLine."No." = 'M00000' then
                                            RoutingLine.Validate("No.", 'ML00000')
                                        else
                                            RoutingLine.Validate("No.", 'ML99999');
                                    end;
                                'PIERRES':
                                    begin
                                        if RoutingLine."No." = 'M00000' then
                                            RoutingLine.Validate("No.", 'M00000')
                                        else
                                            RoutingLine.Validate("No.", 'M99999');
                                    end;
                                'PREPARAGES':
                                    begin
                                        if RoutingLine."No." = 'M00000' then
                                            RoutingLine.Validate("No.", 'MR00000')
                                        else
                                            RoutingLine.Validate("No.", 'MR99999');
                                    end;
                            end
                        else
                            RoutingLine."No." := ProdOrderRtngLine."No.";
                        RoutingLine."Work Center No." := ProdOrderRtngLine."Work Center No.";
                        RoutingLine."Work Center Group Code" := ProdOrderRtngLine."Work Center Group Code";
                        RoutingLine.Description := ProdOrderRtngLine.Description;
                        RoutingLine."Setup Time" := ProdOrderRtngLine."Setup Time";
                        RoutingLine."Run Time" := ProdOrderRtngLine."Run Time";
                        RoutingLine."Wait Time" := ProdOrderRtngLine."Wait Time";
                        RoutingLine."Move Time" := ProdOrderRtngLine."Move Time";
                        RoutingLine."Fixed Scrap Quantity" := ProdOrderRtngLine."Fixed Scrap Quantity";
                        RoutingLine."Lot Size" := ProdOrderRtngLine."Lot Size";
                        RoutingLine."Scrap Factor %" := ProdOrderRtngLine."Scrap Factor %";
                        RoutingLine."Setup Time Unit of Meas. Code" := ProdOrderRtngLine."Setup Time Unit of Meas. Code";
                        RoutingLine."Run Time Unit of Meas. Code" := ProdOrderRtngLine."Run Time Unit of Meas. Code";
                        RoutingLine."Wait Time Unit of Meas. Code" := ProdOrderRtngLine."Wait Time Unit of Meas. Code";
                        RoutingLine."Move Time Unit of Meas. Code" := ProdOrderRtngLine."Move Time Unit of Meas. Code";
                        RoutingLine."Minimum Process Time" := ProdOrderRtngLine."Minimum Process Time";
                        RoutingLine."Maximum Process Time" := ProdOrderRtngLine."Maximum Process Time";
                        RoutingLine."Concurrent Capacities" := ProdOrderRtngLine."Concurrent Capacities";
                        RoutingLine."Send-Ahead Quantity" := ProdOrderRtngLine."Send-Ahead Quantity";
                        RoutingLine."Routing Link Code" := ProdOrderRtngLine."Routing Link Code";
                        RoutingLine."Standard Task Code" := ProdOrderRtngLine."Standard Task Code";
                        RoutingLine."Unit Cost per" := ProdOrderRtngLine."Unit Cost per";
                        RoutingLine.Recalculate := ProdOrderRtngLine.Recalculate;
                        RoutingLine."Sequence No. (Forward)" := ProdOrderRtngLine."Sequence No. (Forward)";
                        RoutingLine."Sequence No. (Backward)" := ProdOrderRtngLine."Sequence No. (Backward)";
                        RoutingLine."Fixed Scrap Qty. (Accum.)" := ProdOrderRtngLine."Fixed Scrap Qty. (Accum.)";
                        RoutingLine."Scrap Factor % (Accumulated)" := ProdOrderRtngLine."Scrap Factor % (Accumulated)";
                        RoutingLine."Next Operation Link Type" := ProdOrderRtngLine."Next Operation Link Type";
                        RecLRL.SetRange(RecLRL."Routing No.", 'PIE_TT_OPE_PIERRE');
                        RecLRL.SetRange(Type, RecLRL.Type::"Machine Center");
                        RecLRL.SetRange("No.", "No.");
                        if RecLRL.FindFirst then begin
                            RoutingLine.Validate("Setup Time", RecLRL."Setup Time");
                            RoutingLine.Validate("Run Time", RecLRL."Run Time");
                            RoutingLine.Validate("Wait Time", RecLRL."Wait Time");
                            RoutingLine.Validate("Move Time", RecLRL."Move Time");
                            RoutingLine.Validate("Setup Time Unit of Meas. Code", RecLRL."Setup Time Unit of Meas. Code");
                            RoutingLine.Validate("Run Time Unit of Meas. Code", RecLRL."Run Time Unit of Meas. Code");
                            RoutingLine.Validate("Wait Time Unit of Meas. Code", RecLRL."Wait Time Unit of Meas. Code");
                            RoutingLine.Validate("Move Time Unit of Meas. Code", RecLRL."Move Time Unit of Meas. Code");
                        end;
                        RoutingLine.Insert(true);
                    until ProdOrderRtngLine.Next = 0;

                RecLRoutingH.Validate(Status, RecLRoutingH.Status::Certified);
                RecLRoutingH.Modify(true);

                RecLRoutingH.Validate(Status, RecLRoutingH.Status::"Under Development");
                RecLRoutingH.Validate(Type, RecLRoutingH.Type::Serial);
                RecLRoutingH.Modify(true);

                RoutingLine.Reset;
                RoutingLine.SetRange("Routing No.", RecLRoutingH."No.");
                RoutingLine.SetRange("Version Code", RecLRoutingH."Version Nos.");
                RoutingLine.SetRange(Type, RoutingLine.Type::"Work Center");
                RoutingLine.SetFilter("No.", '*P');
                RoutingLine.DeleteAll(true);

                RecLRoutingH.Validate(Status, RH.Status::Certified);
                RecLRoutingH.Modify(true);


                RoutingNo := RecLRoutingH."No.";
                if RoutingNo <> "Routing No." then begin
                    "Routing No." := RoutingNo;
                    Modify(true);
                    ProdOrderLine.Reset;
                    ProdOrderLine.SetRange(Status, Status);
                    ProdOrderLine.SetRange("Prod. Order No.", "No.");
                    if ProdOrderLine.FindFirst then
                        repeat
                            ProdOrderLine.Validate("Routing No.", RoutingNo);
                            ProdOrderLine.Validate("Routing Type", RecLRoutingH.Type);
                            ProdOrderLine.Modify;
                        until ProdOrderLine.Next = 0;
                end;


                ProdOrderLine.LockTable;

                CheckReservationExist;

                if CalcLines then
                    CreateProdOrderLines.Copy("Production Order", Direction, '')
                else begin
                    ProdOrderLine.SetRange(Status, Status);
                    ProdOrderLine.SetRange("Prod. Order No.", "No.");
                    if CalcRoutings or CalcComponents then begin
                        if ProdOrderLine.Find('-') then
                            repeat
                                if CalcRoutings then begin
                                    ProdOrderRtngLine.Reset;
                                    ProdOrderRtngLine.SetRange(Status, Status);
                                    ProdOrderRtngLine.SetRange("Prod. Order No.", "No.");
                                    ProdOrderRtngLine.SetRange("Routing Reference No.", ProdOrderLine."Routing Reference No.");
                                    ProdOrderRtngLine.SetRange("Routing No.", ProdOrderLine."Routing No.");
                                    ProdOrderRtngLine.DeleteAll(true);
                                end;
                            until ProdOrderLine.Next = 0;
                        if ProdOrderLine.Find('-') then
                            repeat
                                ProdOrderLine."Due Date" := "Due Date";
                                CalcProdOrder.Calculate(ProdOrderLine, Direction, CalcRoutings, CalcComponents, false);
                            until ProdOrderLine.Next = 0;
                    end;
                end;
                if (Direction = Direction::Backward) and
                   ("Source Type" = "Source Type"::Family)
                then begin
                    SetUpdateEndDate;
                    Validate("Due Date", "Due Date");
                end;

                if Status = Status::Released then begin
                    ProdOrderStatusMgt.FlushProdOrder("Production Order", "Production Order".Status, WorkDate);
                    WhseProdRelease.Release("Production Order");
                    if CreateInbRqst then
                        WhseOutputProdRelease.Release("Production Order");
                end;

                RecLRoutingH.Validate(Status, RecLRoutingH.Status::"Under Development");
                RecLRoutingH.Modify(true);
                RecLRoutingH.Delete(true);
            end;

            trigger OnPreDataItem()
            begin
                //CurrReport.BREAK;
                CalcLines := false;
                CalcRoutings := true;
                CalcComponents := false;
                Direction := Direction::Backward;
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

    var
        RecLItem: Record Item;
        RecLItem2: Record Item;
        CalcProdOrder: Codeunit "Calculate Prod. Order";
        CreateProdOrderLines: Codeunit "Create Prod. Order Lines";
        WhseProdRelease: Codeunit "Whse.-Production Release";
        WhseOutputProdRelease: Codeunit "Whse.-Output Prod. Release";
        Window: Dialog;
        Direction: Option Forward,Backward;
        CalcLines: Boolean;
        CalcRoutings: Boolean;
        CalcComponents: Boolean;
        CreateInbRqst: Boolean;
        RecLRoutingH: Record "Routing Header";


    procedure CheckReservationExist()
    var
        ProdOrderLine2: Record "Prod. Order Line";
        ProdOrderComp2: Record "Prod. Order Component";
        ReservEntry: Record "Reservation Entry";
    begin
        // Not allowed to refresh if reservations exist
        if (not CalcLines) or (not CalcComponents) then
            exit;
        ReservEntry.SetCurrentKey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name");
        ReservEntry.SetRange("Source Batch Name", '');
        ReservEntry.SetRange("Reservation Status", ReservEntry."Reservation Status"::Reservation);

        ProdOrderLine2.SetRange(Status, "Production Order".Status);
        ProdOrderLine2.SetRange("Prod. Order No.", "Production Order"."No.");
        if ProdOrderLine2.Find('-') then
            repeat
                if CalcLines then begin
                    ProdOrderLine2.CalcFields("Reserved Qty. (Base)");
                    if ProdOrderLine2."Reserved Qty. (Base)" <> 0 then begin
                        ReservEntry.SetRange("Source ID", ProdOrderLine2."Prod. Order No.");
                        ReservEntry.SetRange("Source Ref. No.", 0);
                        ReservEntry.SetRange("Source Type", DATABASE::"Prod. Order Line");
                        ReservEntry.SetRange("Source Subtype", ProdOrderLine2.Status);
                        ReservEntry.SetRange("Source Prod. Order Line", ProdOrderLine2."Line No.");
                        if ReservEntry.Find('-') then begin
                            ReservEntry.Get(ReservEntry."Entry No.", not ReservEntry.Positive);
                            if not ((ReservEntry."Source Type" = DATABASE::"Prod. Order Component") and
                                    (ReservEntry."Source ID" = ProdOrderLine2."Prod. Order No.") and
                                    (ReservEntry."Source Subtype" = ProdOrderLine2.Status))
                            then
                                ProdOrderLine2.TestField("Reserved Qty. (Base)", 0);
                        end;
                    end;
                end;

                if CalcLines or CalcComponents then begin
                    ProdOrderComp2.SetRange(Status, ProdOrderLine2.Status);
                    ProdOrderComp2.SetRange("Prod. Order No.", ProdOrderLine2."Prod. Order No.");
                    ProdOrderComp2.SetRange("Prod. Order Line No.", ProdOrderLine2."Line No.");
                    if ProdOrderComp2.Find('-') then
                        repeat
                            ProdOrderComp2.CalcFields("Reserved Qty. (Base)");
                            if ProdOrderComp2."Reserved Qty. (Base)" <> 0 then begin
                                ReservEntry.SetRange("Source ID", ProdOrderComp2."Prod. Order No.");
                                ReservEntry.SetRange("Source Ref. No.", ProdOrderComp2."Line No.");
                                ReservEntry.SetRange("Source Type", DATABASE::"Prod. Order Component");
                                ReservEntry.SetRange("Source Subtype", ProdOrderComp2.Status);
                                ReservEntry.SetRange("Source Prod. Order Line", ProdOrderComp2."Prod. Order Line No.");
                                if ReservEntry.Find('-') then begin
                                    ReservEntry.Get(ReservEntry."Entry No.", not ReservEntry.Positive);
                                    if not ((ReservEntry."Source Type" = DATABASE::"Prod. Order Line") and
                                            (ReservEntry."Source ID" = ProdOrderComp2."Prod. Order No.") and
                                            (ReservEntry."Source Subtype" = ProdOrderComp2.Status))
                                    then
                                        ProdOrderComp2.TestField("Reserved Qty. (Base)", 0);
                                end;
                            end;
                        until ProdOrderComp2.Next = 0;
                end;
            until ProdOrderLine2.Next = 0;
    end;
}

