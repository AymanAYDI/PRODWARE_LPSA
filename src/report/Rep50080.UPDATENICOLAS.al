report 50080 "PWD UPDATE NICOLAS"
{
    Caption = 'Update routing lines';
    ProcessingOnly = true;
    UseSystemPrinter = false;

    dataset
    {
        dataitem("Prod. Order Routing Line"; "Prod. Order Routing Line")
        {
            DataItemTableView = SORTING(Type, "No.", "Starting Date") WHERE(Status = FILTER(< Finished), "Routing Status" = FILTER(< Finished));

            trigger OnAfterGetRecord()
            var
                RecLMachineCenter: Record "Machine Center";
                RecLWorkCenter: Record "Work Center";
                RecLRoutingLine: Record "Routing Line";
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
                    field(CodGRoutingHeader; CodGRoutingHeader)
                    {
                        Caption = 'Reference Routing No.';
                        ShowCaption = false;
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
                    field(CodGOperationNo; CodGOperationNo)
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
                            RecLRoutingLines.SetRange("Routing No.", CodGRoutingHeader);
                            PagLRoutingLines.SetTableView(RecLRoutingLines);
                            PagLRoutingLines.LookupMode(true);
                            if not (PagLRoutingLines.RunModal = ACTION::LookupOK) then
                                exit(false)
                            else begin
                                Text := PagLRoutingLines.GetSelectionFilter;
                                exit(true);
                            end;
                        end;
                    }
                }
                group(Control1000000002)
                {
                    Caption = 'Options';
                    ShowCaption = false;
                    field("BooG_Setup_Time"; BooG_Setup_Time)
                    {
                        Caption = 'Setup Time';
                        ShowCaption = false;
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if BooG_Setup_Time then
                                BooG_Setup_Time_Unit := true;
                        end;
                    }
                    field("BooG_Setup_Time_Unit"; BooG_Setup_Time_Unit)
                    {
                        Caption = 'Setup Time Unit of Meas. Code';
                        ShowCaption = false;
                        ApplicationArea = All;
                    }
                    field("BooG_Run_Time"; BooG_Run_Time)
                    {
                        Caption = 'Run Time';
                        ShowCaption = false;
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if BooG_Run_Time then
                                BooG_Run_Time_Unit := true;
                        end;
                    }
                    field("BooG_Run_Time_Unit"; BooG_Run_Time_Unit)
                    {
                        Caption = 'Run Time Unit of Meas. Code';
                        ShowCaption = false;
                        ApplicationArea = All;
                    }
                    field("BooG_Wait_Time"; BooG_Wait_Time)
                    {
                        Caption = 'Wait Time';
                        ShowCaption = false;
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if BooG_Wait_Time then
                                BooG_Wait_Time_Unit := true;
                        end;
                    }
                    field("BooG_Wait_Time_Unit"; BooG_Wait_Time_Unit)
                    {
                        Caption = 'Wait Time Unit of Meas. Code';
                        ShowCaption = false;
                        ApplicationArea = All;
                    }
                    field("BooG_Move_Time"; BooG_Move_Time)
                    {
                        Caption = 'Move Time';
                        ShowCaption = false;
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if BooG_Move_Time then
                                BooG_Move_Time_Unit := true;
                        end;
                    }
                    field("BooG_Move_Time_Unit"; BooG_Move_Time_Unit)
                    {
                        Caption = 'Move Time Unit of Meas. Code';
                        ShowCaption = false;
                        ApplicationArea = All;
                    }
                    field("BooG_Concurrent_Capacities"; BooG_Concurrent_Capacities)
                    {
                        Caption = 'Concurrent Capacities';
                        ShowCaption = false;
                        ApplicationArea = All;
                    }
                    field("BooG_Scrap_Factor"; BooG_Scrap_Factor)
                    {
                        Caption = 'Scrap Factor %';
                        ShowCaption = false;
                        ApplicationArea = All;
                    }
                    field("BooG_Update_Cost_FromWC"; BooG_Update_Cost_FromWC)
                    {
                        Caption = 'Update Unit Cost from Work Center';
                        ShowCaption = false;
                        ApplicationArea = All;
                    }
                    field("BooG_Update_Cost_FromMC"; BooG_Update_Cost_FromMC)
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
        TxtG002: Label 'Updated finished.';
        BooG_Setup_Time_Unit: Boolean;
        BooG_Run_Time_Unit: Boolean;
        BooG_Wait_Time_Unit: Boolean;
        BooG_Move_Time_Unit: Boolean;
        BooG_Setup_Time: Boolean;
        BooG_Run_Time: Boolean;
        BooG_Wait_Time: Boolean;
        BooG_Move_Time: Boolean;
        BooG_Concurrent_Capacities: Boolean;
        BooG_Scrap_Factor: Boolean;
        BooG_Update_Cost_FromWC: Boolean;
        BooG_Update_Cost_FromMC: Boolean;
        CodGRoutingHeader: Code[20];
        CodGOperationNo: Code[150];
        TxtG003: Label 'Pensez à calculer vos calendriers avant de lancer une mise à jour. Si l''impact des mises à jour dépasse le calendrier, un message d''erreur bloquant arrêtera le traitement.';
        CstL001: Label 'The reference routing is not ''TT_OPE_PIE'', do you want to continue ?';
}

