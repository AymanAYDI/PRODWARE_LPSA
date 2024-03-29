report 50076 "Update Rtg Line Global-Step 2"
{
    Caption = 'Update routing lines';
    ProcessingOnly = true;
    UseSystemPrinter = false;
    UsageCategory = None;
    dataset
    {
        dataitem(RL_Reference; "Routing Line")
        {
            DataItemTableView = SORTING(Type, "No.");
            dataitem(RL_Others; "Routing Line")
            {
                DataItemLink = Type = FIELD(Type), "No." = FIELD("No.");
                DataItemTableView = SORTING(Type, "No.");

                trigger OnAfterGetRecord()
                begin
                    if BooG_Setup_Time_Unit
                      or BooG_Wait_Time_Unit
                      or BooG_Run_Time_Unit
                      or BooG_Move_Time_Unit
                      or BooG_Setup_Time
                      or BooG_Run_Time
                      or BooG_Wait_Time
                      or BooG_Move_Time
                      or BooG_Concurrent_Capacities
                      or BooG_Scrap_Factor then
                        if not (RL_Others."Routing No." = RL_Reference."Routing No.") then begin
                            RecGRoutingHeader.Get(RL_Others."Routing No.");
                            if RecGRoutingHeader.Status <> RecGRoutingHeader.Status::Closed then begin
                                Stat := RecGRoutingHeader.Status.AsInteger();

                                if (Stat <> Stat::"Under Development") and (Stat <> Stat::Closed) then begin
                                    RecGRoutingHeader.Validate(Status, RecGRoutingHeader.Status::"Under Development");
                                    RecGRoutingHeader.Modify(true);
                                end;
                                if BooG_Setup_Time_Unit then
                                    Validate("Setup Time Unit of Meas. Code", RL_Reference."Setup Time Unit of Meas. Code");
                                if BooG_Run_Time_Unit then
                                    Validate("Run Time Unit of Meas. Code", RL_Reference."Run Time Unit of Meas. Code");
                                if BooG_Wait_Time_Unit then
                                    Validate("Wait Time Unit of Meas. Code", RL_Reference."Wait Time Unit of Meas. Code");
                                if BooG_Move_Time_Unit then
                                    Validate("Move Time Unit of Meas. Code", RL_Reference."Move Time Unit of Meas. Code");
                                if BooG_Setup_Time then
                                    Validate("Setup Time", RL_Reference."Setup Time");
                                if BooG_Run_Time then
                                    Validate("Run Time", RL_Reference."Run Time");
                                if BooG_Wait_Time then
                                    Validate("Wait Time", RL_Reference."Wait Time");
                                if BooG_Move_Time then
                                    Validate("Move Time", RL_Reference."Move Time");
                                if BooG_Concurrent_Capacities then
                                    Validate("Concurrent Capacities", RL_Reference."Concurrent Capacities");
                                if BooG_Scrap_Factor then
                                    Validate(RL_Others."Scrap Factor %", RL_Reference."Scrap Factor %");

                                RL_Others.Modify(true);

                                if (Stat <> Stat::"Under Development") and (Stat <> Stat::Closed) then begin
                                    RecGRoutingHeader.Validate(Status, Stat);
                                    RecGRoutingHeader.Modify(true);
                                end;

                            end;
                        end;
                end;
            }
            dataitem("Prod. Order Routing Line"; "Prod. Order Routing Line")
            {
                DataItemLink = Type = FIELD(Type), "No." = FIELD("No.");
                DataItemTableView = SORTING(Type, "No.", "Starting Date") WHERE(Status = FILTER(< Finished), "Routing Status" = FILTER(< Finished));

                trigger OnAfterGetRecord()
                var
                    RecLMachineCenter: Record "Machine Center";
                    RecLWorkCenter: Record "Work Center";
                begin
                    if BooG_Scrap_Factor then
                        Validate("Scrap Factor %", RL_Reference."Scrap Factor %");
                    if BooG_Concurrent_Capacities then
                        Validate("Concurrent Capacities", RL_Reference."Concurrent Capacities");
                    if BooG_Setup_Time then
                        Validate("Setup Time", RL_Reference."Setup Time");
                    if BooG_Run_Time then
                        Validate("Run Time", RL_Reference."Run Time");
                    if BooG_Wait_Time then
                        Validate("Wait Time", RL_Reference."Wait Time");
                    if BooG_Move_Time then
                        Validate("Move Time", RL_Reference."Move Time");
                    if BooG_Setup_Time_Unit then
                        Validate("Setup Time Unit of Meas. Code", RL_Reference."Setup Time Unit of Meas. Code");
                    if BooG_Run_Time_Unit then
                        Validate("Run Time Unit of Meas. Code", RL_Reference."Run Time Unit of Meas. Code");
                    if BooG_Wait_Time_Unit then
                        Validate("Wait Time Unit of Meas. Code", RL_Reference."Wait Time Unit of Meas. Code");
                    if BooG_Move_Time_Unit then
                        Validate("Move Time Unit of Meas. Code", RL_Reference."Move Time Unit of Meas. Code");

                    if "Prod. Order Routing Line".Type = "Prod. Order Routing Line".Type::"Work Center" then begin
                        if BooG_Update_Cost_FromWC then begin
                            RecLWorkCenter.Get("Prod. Order Routing Line"."No.");
                            "Prod. Order Routing Line".Validate("Unit Cost per", RecLWorkCenter."Unit Cost");
                        end;
                    end else
                        if BooG_Update_Cost_FromMC then begin
                            RecLMachineCenter.Get("Prod. Order Routing Line"."No.");
                            "Prod. Order Routing Line".Validate("Unit Cost per", RecLMachineCenter."Unit Cost");
                        end;
                    Modify(false);
                end;

                trigger OnPreDataItem()
                begin
                    if BooGExcludeGammeOF then
                        CurrReport.Break();
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if CodGPrevCode = "No." then
                    CurrReport.Skip();
                CodGPrevCode := "No.";
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Routing No.", CodGRoutingHeader);
                SetFilter("Operation No.", CodGOperationNo);

                CodGPrevCode := '';
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
                    field(CodGRoutingHeaderF; CodGRoutingHeader)
                    {
                        Caption = 'Reference Routing No.';
                        TableRelation = "Routing Header"."No.";
                        ApplicationArea = All;

                        trigger OnValidate()
                        var
                            RecLRouting: Record "Routing Header";
                        begin
                            if CodGRoutingHeader <> 'TT_OPE_PIE' then
                                if Confirm(CstL001) then
                                    RecLRouting.Get(CodGRoutingHeader)
                                else
                                    CodGRoutingHeader := 'TT_OPE_PIE';
                        end;
                    }
                    field(CodGOperationNoF; CodGOperationNo)
                    {
                        Caption = 'Operation No.';
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            RecLRoutingLines: Record "Routing Line";
                            PagLRoutingLines: Page "PWD Routing Lines choice";
                        begin
                            RecLRoutingLines.SetRange("Routing No.", CodGRoutingHeader);
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
                    field("BooG_Setup_TimeF"; BooG_Setup_Time)
                    {
                        Caption = 'Setup Time';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if BooG_Setup_Time then
                                BooG_Setup_Time_Unit := true;
                        end;
                    }
                    field("BooG_Setup_Time_UnitF"; BooG_Setup_Time_Unit)
                    {
                        Caption = 'Setup Time Unit of Meas. Code';
                        ApplicationArea = All;
                    }
                    field("BooG_Run_TimeF"; BooG_Run_Time)
                    {
                        Caption = 'Run Time';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if BooG_Run_Time then
                                BooG_Run_Time_Unit := true;
                        end;
                    }
                    field("BooG_Run_Time_UnitF"; BooG_Run_Time_Unit)
                    {
                        Caption = 'Run Time Unit of Meas. Code';
                        ApplicationArea = All;
                    }
                    field("BooG_Wait_TimeF"; BooG_Wait_Time)
                    {
                        Caption = 'Wait Time';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if BooG_Wait_Time then
                                BooG_Wait_Time_Unit := true;
                        end;
                    }
                    field("BooG_Wait_Time_UnitF"; BooG_Wait_Time_Unit)
                    {
                        Caption = 'Wait Time Unit of Meas. Code';
                        ApplicationArea = All;
                    }
                    field("BooG_Move_TimeF"; BooG_Move_Time)
                    {
                        Caption = 'Move Time';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if BooG_Move_Time then
                                BooG_Move_Time_Unit := true;
                        end;
                    }
                    field("BooG_Move_Time_UnitF"; BooG_Move_Time_Unit)
                    {
                        Caption = 'Move Time Unit of Meas. Code';
                        ApplicationArea = All;
                    }
                    field("BooG_Concurrent_CapacitiesF"; BooG_Concurrent_Capacities)
                    {
                        Caption = 'Concurrent Capacities';
                        ApplicationArea = All;
                    }
                    field("BooG_Scrap_FactorF"; BooG_Scrap_Factor)
                    {
                        Caption = 'Scrap Factor %';
                        ApplicationArea = All;
                    }
                    field("BooG_Update_Cost_FromWCF"; BooG_Update_Cost_FromWC)
                    {
                        Caption = 'Update Unit Cost from Work Center';
                        ApplicationArea = All;
                    }
                    field("BooG_Update_Cost_FromMCF"; BooG_Update_Cost_FromMC)
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
            CodGRoutingHeader := 'TT_OPE_PIE';
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
        RecGRoutingHeader: Record "Routing Header";
        BooG_Concurrent_Capacities: Boolean;
        BooG_Move_Time: Boolean;
        BooG_Move_Time_Unit: Boolean;
        BooG_Run_Time: Boolean;
        BooG_Run_Time_Unit: Boolean;
        BooG_Scrap_Factor: Boolean;
        BooG_Setup_Time: Boolean;
        BooG_Setup_Time_Unit: Boolean;
        BooG_Update_Cost_FromMC: Boolean;
        BooG_Update_Cost_FromWC: Boolean;
        BooG_Wait_Time: Boolean;
        BooG_Wait_Time_Unit: Boolean;
        BooGExcludeGammeOF: Boolean;
        CodGPrevCode: Code[20];
        CodGRoutingHeader: Code[20];
        CodGOperationNo: Code[150];
        CstL001: Label 'The reference routing is not ''TT_OPE_PIE'', do you want to continue ?';
        TxtG002: Label 'Updated finished.';
        TxtG003: Label 'Pensez à calculer vos calendriers avant de lancer une mise à jour. Si l''impact des mises à jour dépasse le calendrier, un message d''erreur bloquant arrêtera le traitement.';
        Stat: Option New,Certified,"Under Development",Closed;
}

