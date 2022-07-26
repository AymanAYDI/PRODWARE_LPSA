report 50024 "PWD Update Rtg Line Global"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 27/06/2017 : DEMANDES DIVERSES
    //                   - New report

    Caption = 'Update routing lines';
    ProcessingOnly = true;
    UseSystemPrinter = false;
    UsageCategory = None;
    dataset
    {
        dataitem(POL_Sauv; "Prod. Order Line")
        {
            DataItemTableView = SORTING(Status, "Prod. Order No.", "Line No.") WHERE(Status = FILTER(Released));
            dataitem(PORL_Termined; "Prod. Order Routing Line")
            {
                DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("Prod. Order No."), "Routing Reference No." = FIELD("Routing Reference No."), "Routing No." = FIELD("Routing No.");
                DataItemTableView = SORTING(Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.") WHERE(Type = FILTER("Machine Center"), "No." = FILTER('M00000'));

                trigger OnAfterGetRecord()
                begin
                    if PORL_Termined."No." = 'M00000' then begin
                        PORL_Termined."Routing Status" := PORL_Termined."Routing Status"::Finished;
                        PORL_Termined.Modify();
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Bdialog.Update(1, IntGCounter);

                IntGCounter -= 1;

                "PWD Initial Ending Date Time" := "Ending Date-Time";
                Modify(false);
            end;

            trigger OnPostDataItem()
            begin
                if OptGStep = OptGStep::"Step2: Mémorisation Date de fin OF" then begin
                    Bdialog.Close();
                    Message(TxtG004);
                end;
            end;

            trigger OnPreDataItem()
            begin
                if OptGStep <> OptGStep::"Step2: Mémorisation Date de fin OF" then
                    CurrReport.Break();

                Bdialog.Open('Step2: Memorisation Date de fin OF\' +
                             'Statut Gamme = Terminée pour poste de charge M00000 \Enregistrements restants #1########################');
                IntGCounter := POL_Sauv.Count;
            end;
        }
        dataitem(RL_Reference; "Routing Line")
        {
            DataItemTableView = SORTING(Type, "No.");
            dataitem(RL_Others; "Routing Line")
            {
                DataItemLink = Type = FIELD(Type), "No." = FIELD("No.");
                DataItemTableView = SORTING(Type, "No.") WHERE("Version Code" = FILTER(''));

                trigger OnAfterGetRecord()
                begin
                    Bdialog.Update(1, IntGCounter);
                    Bdialog.Update(2, RL_Reference."Operation No.");

                    IntGCounter -= 1;

                    if BooG_Setup_Time
                      or BooG_Run_Time
                      or BooG_Wait_Time
                      or BooG_Move_Time then

                        //  IF NOT (RL_Others."Routing No." = RL_Reference."Routing No.") THEN BEGIN
                        if not ((RL_Others."Routing No." = RL_Reference."Routing No.") and
                               (RL_Others."Operation No." = RL_Reference."Operation No.")) then begin
                            RecGRoutingHeader.Get(RL_Others."Routing No.");
                            if RecGRoutingHeader.Status <> RecGRoutingHeader.Status::Closed then begin
                                Stat := RecGRoutingHeader.Status.AsInteger();

                                if (Stat <> Stat::"Under Development") and (Stat <> Stat::Closed) then begin
                                    RecGRoutingHeader.Validate(Status, RecGRoutingHeader.Status::"Under Development");
                                    RecGRoutingHeader.Modify(true);
                                end;
                                if BooG_Setup_Time then
                                    Validate("Setup Time", RL_Reference."Setup Time");
                                if BooG_Run_Time then
                                    Validate("Run Time", RL_Reference."Run Time");
                                if BooG_Wait_Time then
                                    Validate("Wait Time", RL_Reference."Wait Time");
                                if BooG_Move_Time then
                                    Validate("Move Time", RL_Reference."Move Time");

                                RL_Others.Modify(true);
                                if (Stat <> Stat::"Under Development") and (Stat <> Stat::Closed) then begin
                                    RecGRoutingHeader.Validate(Status, Stat);
                                    RecGRoutingHeader.Modify(true);
                                end;

                            end;
                        end;
                end;

                trigger OnPostDataItem()
                begin
                    if OptGStep = OptGStep::"Step1: MAJ Gamme" then
                        Bdialog.Close();
                end;

                trigger OnPreDataItem()
                begin
                    if OptGStep <> OptGStep::"Step1: MAJ Gamme" then
                        CurrReport.Break();

                    Bdialog.Open('Step1: MAJ Gamme pour opération #2#############\Enregistrements restants #1########################');
                    IntGCounter := RL_Others.Count;
                end;
            }
            dataitem(RL_OthersVersion; "Routing Line")
            {
                DataItemLink = Type = FIELD(Type), "No." = FIELD("No.");
                DataItemTableView = SORTING(Type, "No.") WHERE("Version Code" = FILTER(<> ''));

                trigger OnAfterGetRecord()
                begin
                    Bdialog.Update(1, IntGCounter);
                    Bdialog.Update(2, RL_Reference."Operation No.");

                    IntGCounter -= 1;

                    if BooG_Setup_Time
                      or BooG_Run_Time
                      or BooG_Wait_Time
                      or BooG_Move_Time then

                        //  IF NOT (RL_OthersVersion."Routing No." = RL_Reference."Routing No.") THEN BEGIN
                        if not ((RL_OthersVersion."Routing No." = RL_Reference."Routing No.") and
                               (RL_OthersVersion."Operation No." = RL_Reference."Operation No.")) then begin
                            RecGRoutingVersion.Get(RL_OthersVersion."Routing No.", RL_OthersVersion."Version Code");
                            if RecGRoutingVersion.Status <> RecGRoutingHeader.Status::Closed then begin
                                Stat := RecGRoutingVersion.Status.AsInteger();

                                if (Stat <> Stat::"Under Development") and (Stat <> Stat::Closed) then begin
                                    RecGRoutingVersion.Validate(Status, RecGRoutingVersion.Status::"Under Development");
                                    RecGRoutingVersion.Modify(true);
                                end;
                                if BooG_Setup_Time then
                                    Validate("Setup Time", RL_Reference."Setup Time");
                                if BooG_Run_Time then
                                    Validate("Run Time", RL_Reference."Run Time");
                                if BooG_Wait_Time then
                                    Validate("Wait Time", RL_Reference."Wait Time");
                                if BooG_Move_Time then
                                    Validate("Move Time", RL_Reference."Move Time");

                                RL_OthersVersion.Modify(true);
                                if (Stat <> Stat::"Under Development") and (Stat <> Stat::Closed) then begin
                                    RecGRoutingVersion.Validate(Status, Stat);
                                    RecGRoutingVersion.Modify(true);
                                end;

                            end;
                        end;
                end;

                trigger OnPostDataItem()
                begin
                    if OptGStep = OptGStep::"Step1: MAJ Gamme" then begin
                        Bdialog.Close();
                        Message(TxtG002);
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    if OptGStep <> OptGStep::"Step1: MAJ Gamme" then
                        CurrReport.Break();

                    Bdialog.Open('MAJ version Gamme pour opération #2#############\Enregistrements restants #1########################');
                    IntGCounter := RL_Others.Count;
                end;
            }
            dataitem("Prod. Order Routing Line"; "Prod. Order Routing Line")
            {
                DataItemLink = Type = FIELD(Type), "No." = FIELD("No.");
                DataItemTableView = SORTING(Type, "No.", "Starting Date") WHERE(Status = FILTER(Released), "Routing Status" = FILTER(< Finished));

                trigger OnAfterGetRecord()
                var
                    RecLMachineCenter: Record "Machine Center";
                    RecLProdOrderLine: Record "Prod. Order Line";
                    RecLWorkCenter: Record "Work Center";
                begin
                    Bdialog.Update(1, IntGCounter);
                    Bdialog.Update(2, RL_Reference."Operation No.");

                    IntGCounter -= 1;

                    if BooG_Setup_Time then
                        Validate("Setup Time", RL_Reference."Setup Time");
                    if BooG_Run_Time then
                        Validate("Run Time", RL_Reference."Run Time");
                    if BooG_Wait_Time then
                        Validate("Wait Time", RL_Reference."Wait Time");
                    if BooG_Move_Time then
                        Validate("Move Time", RL_Reference."Move Time");

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

                    if BooG_Setup_Time or BooG_Run_Time or BooG_Wait_Time or BooG_Move_Time or
                       BooG_Update_Cost_FromWC or BooG_Update_Cost_FromMC then begin
                        RecLProdOrderLine.SetCurrentKey(Status, "Prod. Order No.", "Routing No.", "Routing Reference No.");
                        RecLProdOrderLine.SetRange(Status, "Prod. Order Routing Line".Status);
                        RecLProdOrderLine.SetRange("Prod. Order No.", "Prod. Order Routing Line"."Prod. Order No.");
                        RecLProdOrderLine.SetRange("Routing No.", "Prod. Order Routing Line"."Routing No.");
                        RecLProdOrderLine.SetRange("Routing Reference No.", "Prod. Order Routing Line"."Routing Reference No.");
                        if RecLProdOrderLine.Find('-') then
                            repeat
                                RecLProdOrderLine."PWD To Be Updated" := true;
                                RecLProdOrderLine.Modify(false);
                            until RecLProdOrderLine.Next() = 0;
                    end;
                end;

                trigger OnPostDataItem()
                begin
                    if OptGStep = OptGStep::"Step3: MAJ Gamme OF" then begin
                        Bdialog.Close();
                        Commit();
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    if OptGStep <> OptGStep::"Step3: MAJ Gamme OF" then
                        CurrReport.Break();

                    Bdialog.Open('Step3: MAJ Gamme OF pour opération #2#############\Enregistrements restants #1########################');
                    IntGCounter := "Prod. Order Routing Line".Count;
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

                if (OptGStep = OptGStep::"Step1: MAJ Gamme") or
                   (OptGStep = OptGStep::"Step3: MAJ Gamme OF") then
                    if not Confirm(TxtG003) then
                        CurrReport.Quit();

                CodGPrevCode := '';
            end;
        }
        dataitem(POL_rest; "Prod. Order Line")
        {
            DataItemTableView = SORTING(Status, "Prod. Order No.", "Line No.") WHERE(Status = FILTER(Released), "PWD To Be Updated" = FILTER(true));

            trigger OnAfterGetRecord()
            var
                RecLProdOrderLine: Record "Prod. Order Line";
                RecLProdOrder: Record "Production Order";
                RepLReplanProductionOrder: Report "Replan Production Order";
                Direction: Option Forward,Backward;
                CalcMethod: Option "No Levels","One level","All levels";
            begin
                Bdialog.Update(1, IntGCounter);

                IntGCounter -= 1;

                if Format("PWD Initial Ending Date Time") <> '' then begin
                    Validate("Ending Date-Time", "PWD Initial Ending Date Time");
                    Modify(true);
                    "PWD Processed" := true;
                    Modify(false);

                    Commit();
                    RecLProdOrder.SetRange(Status, POL_rest.Status);
                    RecLProdOrder.SetRange("No.", POL_rest."Prod. Order No.");
                    RepLReplanProductionOrder.InitializeRequest(Direction::Backward, CalcMethod::"One level");
                    RepLReplanProductionOrder.SetTableView(RecLProdOrder);
                    RepLReplanProductionOrder.UseRequestPage := false;
                    RepLReplanProductionOrder.RunModal();

                    Commit();
                    RecLProdOrderLine.Get(POL_rest.Status, POL_rest."Prod. Order No.", POL_rest."Line No.");
                    RecLProdOrderLine."PWD To Be Updated" := false;
                    RecLProdOrderLine."Send to OSYS (Released)" := false;
                    RecLProdOrderLine.Modify(false);
                end;
            end;

            trigger OnPostDataItem()
            begin
                if OptGStep = OptGStep::"Step3: MAJ Gamme OF" then begin
                    Bdialog.Close();
                    Message(TxtG005);
                end;
            end;

            trigger OnPreDataItem()
            begin
                if OptGStep <> OptGStep::"Step3: MAJ Gamme OF" then
                    CurrReport.Break();

                Bdialog.Open('Step3: Restauration Date de fin OF et replanification OF\Enregistrements restants #1########################');
                IntGCounter := POL_rest.Count;
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
                        //OptionCaption = 'Operations No.';
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
                    }
                    field("BooG_Run_TimeF"; BooG_Run_Time)
                    {
                        Caption = 'Run Time';
                        ApplicationArea = All;
                    }
                    field("BooG_Wait_TimeF"; BooG_Wait_Time)
                    {
                        Caption = 'Wait Time';
                        ApplicationArea = All;
                    }
                    field("BooG_Move_TimeF"; BooG_Move_Time)
                    {
                        Caption = 'Move Time';
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
                    group("Les OF sont filtrés par défaut avec Statut = Lancé et Groupe de planification <> ACIERS")
                    {
                        Caption = 'Les OF sont filtrés par défaut avec Statut = Lancé et Groupe de planification <> ACIERS';
                        field(OptGStepF; OptGStep)
                        {
                            Caption = 'Etape';
                            ApplicationArea = All;
                        }
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
        RecGRoutingHeader: Record "Routing Header";
        RecGRoutingVersion: Record "Routing Version";
        BooG_Move_Time: Boolean;
        BooG_Run_Time: Boolean;
        BooG_Setup_Time: Boolean;
        BooG_Update_Cost_FromMC: Boolean;
        BooG_Update_Cost_FromWC: Boolean;
        BooG_Wait_Time: Boolean;
        CodGPrevCode: Code[20];
        CodGRoutingHeader: Code[20];
        CodGOperationNo: Code[150];
        Bdialog: Dialog;
        IntGCounter: Integer;
        CstL001: Label 'The reference routing is not ''TT_OPE_PIE'', do you want to continue ?';
        TxtG002: Label 'Updated finished.';
        TxtG003: Label 'Pensez à calculer vos calendriers avant de lancer une mise à jour. Si l''impact des mises à jour dépasse le calendrier, un message d''erreur bloquant arrêtera le traitement.\Voulez-vous continuer ?';
        TxtG004: Label 'Sauvegarde terminée.';
        TxtG005: Label 'Replanification terminée.';
        Stat: Option New,Certified,"Under Development",Closed;
        OptGStep: Option "Step1: MAJ Gamme","Step2: Mémorisation Date de fin OF","Step3: MAJ Gamme OF";
}

