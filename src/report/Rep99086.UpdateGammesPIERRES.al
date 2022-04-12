report 99086 "PWD Update Gammes PIERRES"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(RH2; "Routing Header")
        {
            DataItemTableView = SORTING ("No.") WHERE (PlanningGroup = CONST ('PIERRES'));

            trigger OnAfterGetRecord()
            var
                RecLRoutingLine: Record "Routing Line";
                RecLWorkCenter: Record "Work Center";
                RecLMachCenter: Record "Machine Center";
                RecLRL: Record "Routing Line";
                RoutingLine2: Record "Routing Line";
            begin
                Stat := RH2.Status;

                Validate(Status, RH2.Status::"Under Development");
                Validate(Type, Type::Serial);
                Modify(true);
                RecLRoutingLine.Reset;
                RecLRoutingLine.SetRange("Routing No.", RH2."No.");
                RecLRoutingLine.SetRange("Version Code", RH2."Version Nos.");
                RecLRoutingLine.SetRange(Type, RecLRoutingLine.Type::"Machine Center");
                RecLRoutingLine.SetFilter("No.", 'M99999|M00000');

                if RecLRoutingLine.FindFirst then
                    repeat
                        case RH2.PlanningGroup of
                            'LEVEES_ELI':
                                begin
                                    if RecLRoutingLine."No." = 'M00000' then
                                        RecLRoutingLine.Validate("No.", 'M00000')
                                    else
                                        RecLRoutingLine.Validate("No.", 'M99999');
                                    RecLRoutingLine.Modify(true);
                                end;

                            'PIERRES':
                                begin
                                    if RecLRoutingLine."No." = 'M00000' then
                                        RecLRoutingLine.Validate("No.", 'M00000')
                                    else
                                        RecLRoutingLine.Validate("No.", 'M99999');
                                    RecLRoutingLine.Modify(true);
                                end;
                            'ACIERS':
                                begin
                                    if RecLRoutingLine."No." = 'M00000' then
                                        RecLRoutingLine.Validate("No.", 'M00000')
                                    else
                                        RecLRoutingLine.Validate("No.", 'M99999');
                                    RecLRoutingLine.Modify(true);

                                end;
                            'PREPARAGES':
                                begin
                                    if RecLRoutingLine."No." = 'M00000' then
                                        RecLRoutingLine.Validate("No.", 'M00000')
                                    else
                                        RecLRoutingLine.Validate("No.", 'M99999');
                                    RecLRoutingLine.Modify(true);
                                end;
                        end;
                    until RecLRoutingLine.Next = 0;

                RecLRoutingLine.SetRange(Type);
                RecLRoutingLine.SetRange("No.");
                if RecLRoutingLine.FindFirst then
                    repeat
                        RecLRL.SetRange(RecLRL."Routing No.", 'PIE_TT_OPE_PIERRE');
                        RecLRL.SetRange(Type, RecLRL.Type::"Machine Center");
                        RecLRL.SetRange("No.", "No.");
                        if RecLRL.FindFirst then begin
                            RecLRoutingLine.Validate("Setup Time", RecLRL."Setup Time");
                            RecLRoutingLine.Validate("Run Time", RecLRL."Run Time");
                            RecLRoutingLine.Validate("Wait Time", RecLRL."Wait Time");
                            RecLRoutingLine.Validate("Move Time", RecLRL."Move Time");
                            RecLRoutingLine.Validate("Setup Time Unit of Meas. Code", RecLRL."Setup Time Unit of Meas. Code");
                            RecLRoutingLine.Validate("Run Time Unit of Meas. Code", RecLRL."Run Time Unit of Meas. Code");
                            RecLRoutingLine.Validate("Wait Time Unit of Meas. Code", RecLRL."Wait Time Unit of Meas. Code");
                            RecLRoutingLine.Validate("Move Time Unit of Meas. Code", RecLRL."Move Time Unit of Meas. Code");
                            RecLRoutingLine.Modify;
                        end;
                    until RecLRoutingLine.Next = 0;

                RecLRoutingLine.SetRange(Type, RecLRoutingLine.Type::"Machine Center");
                RecLRoutingLine.SetRange("No.", 'OP11710');
                if RecLRoutingLine.FindFirst then begin
                    RoutingLine2.Reset;
                    RoutingLine2.SetRange("Routing No.", RecLRoutingLine."Routing No.");
                    RoutingLine2.SetRange("Version Code", RecLRoutingLine."Version Code");
                    RoutingLine2.SetRange(Type, RoutingLine2.Type::"Machine Center");
                    RoutingLine2.SetRange("No.", 'OP11720');
                    RoutingLine2.DeleteAll(true);
                end;


                Validate(Status, Stat);
                Modify(true);
            end;

            trigger OnPreDataItem()
            var
                RecLRoutingLine: Record "Routing Line";
            begin
                //CurrReport.BREAK;
            end;
        }
        dataitem(RH; "Routing Header")
        {
            DataItemTableView = SORTING ("No.") WHERE (PlanningGroup = CONST ('PIERRES'));

            trigger OnAfterGetRecord()
            var
                RecLRoutingLine: Record "Routing Line";
            begin
                Stat := RH2.Status;
                Validate(Status, RH.Status::"Under Development");
                Validate(Type, Type::Serial);
                Modify(true);

                RecLRoutingLine.Reset;
                RecLRoutingLine.SetRange("Routing No.", RH."No.");
                RecLRoutingLine.SetRange("Version Code", RH."Version Nos.");
                RecLRoutingLine.SetRange(Type, RecLRoutingLine.Type::"Work Center");
                RecLRoutingLine.SetFilter(RecLRoutingLine."No.", '*P');
                RecLRoutingLine.DeleteAll(true);

                Validate(Status, Stat);
                Modify(true);
            end;

            trigger OnPreDataItem()
            begin
                //                 CurrReport.BREAK;
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
        Stat: Option New,Certified,"Under Development",Closed;
}

