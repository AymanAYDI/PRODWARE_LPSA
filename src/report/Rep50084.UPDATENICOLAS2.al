report 50084 "PWD UPDATE NICOLAS2"
{
    Caption = 'Update routing lines';
    ProcessingOnly = true;
    UseSystemPrinter = false;
    UsageCategory = None;
    dataset
    {
        dataitem("Prod. Order Routing Line"; "Prod. Order Routing Line")
        {
            DataItemTableView = SORTING(Type, "No.", "Starting Date") WHERE(Status = FILTER(< Finished), "Routing Status" = FILTER(< Finished));

            trigger OnAfterGetRecord()
            var
                RecLRoutingLine: Record "Routing Line";
            begin
                RecLRoutingLine.SetRange("Routing No.", 'TT_OPE_PIE');
                RecLRoutingLine.SetRange(Type, Type);
                RecLRoutingLine.SetRange("No.", "No.");
                if RecLRoutingLine.FindFirst() then begin
                    if ("Move Time" <> RecLRoutingLine."Move Time") then
                        //    VALIDATE("Move Time",RecLRoutingLine."Move Time");
                        "Move Time" := RecLRoutingLine."Move Time";
                    Modify(false);
                    //  COMMIT;
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Control1000000000)
                {
                    Caption = 'Reference';
                    ShowCaption = false;
                    field(RoutingHeaderF; RoutingHeader)
                    {
                        Caption = 'Reference Routing No.';
                        TableRelation = "Routing Header"."No.";
                        ApplicationArea = All;

                        trigger OnValidate()
                        var
                            RecLRouting: Record "Routing Header";
                        begin
                            if RoutingHeader <> 'TT_OPE_PIE' then
                                if Confirm(CstL001) then
                                    RecLRouting.Get(RoutingHeader)
                                else
                                    RoutingHeader := 'TT_OPE_PIE';
                        end;
                    }
                    field(OperationNoF; OperationNo)
                    {
                        Caption = 'Operation No.';
                        //OptionCaption = 'Operations No.';
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            RecLRoutingLines: Record "Routing Line";
                            PagLRoutingLines: Page "PWD Routing Lines choice";
                        begin
                            RecLRoutingLines.SetRange("Routing No.", RoutingHeader);
                            PagLRoutingLines.SetTableView(RecLRoutingLines);
                            PagLRoutingLines.LookupMode(true);
                            if not (PagLRoutingLines.RunModal() = ACTION::LookupOK) then
                                exit(false)
                            else begin
                                Text := PagLRoutingLines.GetSelectionFilter();
                                exit(true);
                            end;
                        end;
                    }
                }
                group(Control1000000002)
                {
                    Caption = 'Options';
                    field("Setup_TimeF"; Setup_Time)
                    {
                        Caption = 'Setup Time';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if Setup_Time then
                                Setup_Time_Unit := true;
                        end;
                    }
                    field("Setup_Time_UnitF"; Setup_Time_Unit)
                    {
                        Caption = 'Setup Time Unit of Meas. Code';
                        ApplicationArea = All;
                    }
                    field("Run_TimeF"; Run_Time)
                    {
                        Caption = 'Run Time';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if Run_Time then
                                Run_Time_Unit := true;
                        end;
                    }
                    field("Run_Time_UnitF"; Run_Time_Unit)
                    {
                        Caption = 'Run Time Unit of Meas. Code';
                        ApplicationArea = All;
                    }
                    field("Wait_TimeF"; Wait_Time)
                    {
                        Caption = 'Wait Time';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if Wait_Time then
                                Wait_Time_Unit := true;
                        end;
                    }
                    field("Wait_Time_UnitF"; Wait_Time_Unit)
                    {
                        Caption = 'Wait Time Unit of Meas. Code';
                        ApplicationArea = All;
                    }
                    field("Move_TimeF"; Move_Time)
                    {
                        Caption = 'Move Time';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if Move_Time then
                                Move_Time_Unit := true;
                        end;
                    }
                    field("Move_Time_UnitF"; Move_Time_Unit)
                    {
                        Caption = 'Move Time Unit of Meas. Code';
                        ApplicationArea = All;
                    }
                    field("Concurrent_CapacitiesF"; Concurrent_Capacities)
                    {
                        Caption = 'Concurrent Capacities';
                        ApplicationArea = All;
                    }
                    field("Scrap_FactorF"; Scrap_Factor)
                    {
                        Caption = 'Scrap Factor %';
                        ApplicationArea = All;
                    }
                    field("Update_Cost_FromWCF"; Update_Cost_FromWC)
                    {
                        Caption = 'Update Unit Cost from Work Center';
                        ApplicationArea = All;
                    }
                    field("Update_Cost_FromMCF"; Update_Cost_FromMC)
                    {
                        Caption = 'Update Unit Cost from Machine Center';
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            RoutingHeader := 'TT_OPE_PIE';
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        Message(TxtG003);
    end;

    trigger OnPostReport()
    begin
        Message(TxtG002);
    end;

    var
        Concurrent_Capacities: Boolean;
        Move_Time: Boolean;
        Move_Time_Unit: Boolean;
        Run_Time: Boolean;
        Run_Time_Unit: Boolean;
        Scrap_Factor: Boolean;
        Setup_Time: Boolean;
        Setup_Time_Unit: Boolean;
        Update_Cost_FromMC: Boolean;
        Update_Cost_FromWC: Boolean;
        Wait_Time: Boolean;
        Wait_Time_Unit: Boolean;
        RoutingHeader: Code[20];
        OperationNo: Code[150];
        CstL001: Label 'The reference routing is not ''TT_OPE_PIE'', do you want to continue ?';
        TxtG002: Label 'Updated finished.';
        TxtG003: Label 'Pensez à calculer vos calendriers avant de lancer une mise à jour. Si l''impact des mises à jour dépasse le calendrier, un message d''erreur bloquant arrêtera le traitement.';
}

