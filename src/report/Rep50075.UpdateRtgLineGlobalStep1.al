report 50075 "Update Rtg Line Global-Step 1"
{
    Caption = 'Update routing';
    ProcessingOnly = true;
    UseSystemPrinter = false;
    ApplicationArea = all;
    UsageCategory = Tasks;
    dataset
    {
        dataitem(POL_Sauv; "Prod. Order Line")
        {
            DataItemTableView = SORTING(Status, "Prod. Order No.", "Line No.") WHERE(Status = FILTER(< Finished));

            trigger OnAfterGetRecord()
            begin
                //"Initial Ending Date Time" = DateTime THEN BEGIN
                //IF "Initial Ending Date Time" = 0DT THEN BEGIN
                "PWD Initial Ending Date Time" := "Ending Date-Time";
                Modify(false);
                //END;
            end;

            trigger OnPostDataItem()
            begin
                Message(TxtG004);
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
                    ShowCaption = false;
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

    var
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
        CodGRoutingHeader: Code[20];
        CodGOperationNo: Code[150];
        CstL001: Label 'The reference routing is not ''TT_OPE_PIE'', do you want to continue ?';
        TxtG004: Label 'Sauvegarde terminée.';
}

