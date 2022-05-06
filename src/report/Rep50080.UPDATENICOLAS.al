report 50080 "PWD UPDATE NICOLAS"
{
    Caption = 'Update routing lines';
    ProcessingOnly = true;
    UseSystemPrinter = false;
    UsageCategory = none;
    dataset
    {
        dataitem("Prod. Order Routing Line"; "Prod. Order Routing Line")
        {
            DataItemTableView = SORTING(Type, "No.", "Starting Date") WHERE(Status = FILTER(< Finished), "Routing Status" = FILTER(< Finished));

            trigger OnAfterGetRecord()
            var
                RecLMachineCenter: Record "Machine Center";
                RecLRoutingLine: Record "Routing Line";
                RecLWorkCenter: Record "Work Center";
            begin
                RecLRoutingLine.SetRange("Routing No.", 'TT_OPE_PIE');
                RecLRoutingLine.SetRange(Type, Type);
                RecLRoutingLine.SetRange("No.", "No.");
                if RecLRoutingLine.FindFirst() then begin
                    if ("Move Time" <> RecLRoutingLine."Move Time") then
                        //    VALIDATE("Move Time",RecLRoutingLine."Move Time");
                        "Move Time" := RecLRoutingLine."Move Time";
                    if ("Setup Time" <> RecLRoutingLine."Setup Time") then
                        //    VALIDATE("Setup Time",RecLRoutingLine."Setup Time");
                        "Setup Time" := RecLRoutingLine."Setup Time";
                    if ("Run Time" <> RecLRoutingLine."Run Time") then
                        //    VALIDATE("Run Time",RecLRoutingLine."Run Time");
                        "Run Time" := RecLRoutingLine."Run Time";
                    if ("Wait Time" <> RecLRoutingLine."Wait Time") then
                        //    VALIDATE("Wait Time",RecLRoutingLine."Wait Time");
                        "Wait Time" := RecLRoutingLine."Wait Time";
                    Validate("Scrap Factor %", RecLRoutingLine."Scrap Factor %");

                    if "Prod. Order Routing Line".Type = "Prod. Order Routing Line".Type::"Work Center" then begin
                        RecLWorkCenter.Get("Prod. Order Routing Line"."No.");
                        if "Unit Cost per" <> RecLWorkCenter."Unit Cost" then
                            "Unit Cost per" := RecLWorkCenter."Unit Cost";
                    end;
                    if "Prod. Order Routing Line".Type = "Prod. Order Routing Line".Type::"Machine Center" then begin
                        RecLMachineCenter.Get("Prod. Order Routing Line"."No.");
                        if "Unit Cost per" <> RecLMachineCenter."Unit Cost" then
                            "Unit Cost per" := RecLMachineCenter."Unit Cost";
                    end;
                    //  "Prod. Order Routing Line".Processed := TRUE;
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
                        ShowCaption = false;
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
                        ShowCaption = false;
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
                    ShowCaption = false;
                    field("BooG_Setup_Time"; Setup_Time)
                    {
                        Caption = 'Setup Time';
                        ShowCaption = false;
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
                        ShowCaption = false;
                        ApplicationArea = All;
                    }
                    field("BooG_Run_Time"; Run_Time)
                    {
                        Caption = 'Run Time';
                        ShowCaption = false;
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if Run_Time then
                                Run_Time_Unit := true;
                        end;
                    }
                    field("BooG_Run_Time_Unit"; Run_Time_Unit)
                    {
                        Caption = 'Run Time Unit of Meas. Code';
                        ShowCaption = false;
                        ApplicationArea = All;
                    }
                    field("BooG_Wait_Time"; Wait_Time)
                    {
                        Caption = 'Wait Time';
                        ShowCaption = false;
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if Wait_Time then
                                Wait_Time_Unit := true;
                        end;
                    }
                    field("BooG_Wait_Time_Unit"; Wait_Time_Unit)
                    {
                        Caption = 'Wait Time Unit of Meas. Code';
                        ShowCaption = false;
                        ApplicationArea = All;
                    }
                    field("BooG_Move_Time"; Move_Time)
                    {
                        Caption = 'Move Time';
                        ShowCaption = false;
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if Move_Time then
                                Move_Time_Unit := true;
                        end;
                    }
                    field("BooG_Move_Time_Unit"; Move_Time_Unit)
                    {
                        Caption = 'Move Time Unit of Meas. Code';
                        ShowCaption = false;
                        ApplicationArea = All;
                    }
                    field("BooG_Concurrent_Capacities"; Concurrent_Capacities)
                    {
                        Caption = 'Concurrent Capacities';
                        ShowCaption = false;
                        ApplicationArea = All;
                    }
                    field("BooG_Scrap_Factor"; Scrap_Factor)
                    {
                        Caption = 'Scrap Factor %';
                        ShowCaption = false;
                        ApplicationArea = All;
                    }
                    field("BooG_Update_Cost_FromWC"; Update_Cost_FromWC)
                    {
                        Caption = 'Update Unit Cost from Work Center';
                        ShowCaption = false;
                        ApplicationArea = All;
                    }
                    field("BooG_Update_Cost_FromMC"; Update_Cost_FromMC)
                    {
                        Caption = 'Update Unit Cost from Machine Center';
                        ShowCaption = false;
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

