report 50026 "Update Rtg Line Global IRON"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 27/06/2017 : cf. FED-Modification des gammes Aciers-22052107-V1
    //                   - New report

    Caption = 'Update routing lines IRON';
    ProcessingOnly = true;
    UseSystemPrinter = false;

    dataset
    {
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
                    Bdialog.Close();
                end;

                trigger OnPreDataItem()
                begin

                    Bdialog.Open('MAJ Gamme pour opération #2#############\Enregistrements restants #1########################');
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
                    Bdialog.Close();
                    Message(TxtG002);
                end;

                trigger OnPreDataItem()
                begin
                    Bdialog.Open('MAJ version Gamme pour opération #2#############\Enregistrements restants #1########################');
                    IntGCounter := RL_Others.Count;
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
                if not Confirm(TxtG003) then
                    CurrReport.Break();

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
                            if CodGRoutingHeader <> 'ACIER_TTES_OPE' then
                                if Confirm(CstL001) then
                                    RecLRouting.Get(CodGRoutingHeader)
                                else
                                    CodGRoutingHeader := 'ACIER_TTES_OPE';
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
                    field("BooG_Setup_Time"; BooG_Setup_Time)
                    {
                        Caption = 'Setup Time';
                        ShowCaption = false;
                        ApplicationArea = All;
                    }
                    field("BooG_Run_Time"; BooG_Run_Time)
                    {
                        Caption = 'Run Time';
                        ShowCaption = false;
                        ApplicationArea = All;
                    }
                    field("BooG_Wait_Time"; BooG_Wait_Time)
                    {
                        Caption = 'Wait Time';
                        ShowCaption = false;
                        ApplicationArea = All;
                    }
                    field("BooG_Move_Time"; BooG_Move_Time)
                    {
                        Caption = 'Move Time';
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
            CodGRoutingHeader := 'ACIER_TTES_OPE';
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
        BooG_Wait_Time: Boolean;
        CodGPrevCode: Code[20];
        CodGRoutingHeader: Code[20];
        CodGOperationNo: Code[150];
        Bdialog: Dialog;
        IntGCounter: Integer;
        CstL001: Label 'The reference routing is not ''TT_OPE_PIE'', do you want to continue ?';
        TxtG002: Label 'Updated finished.';
        TxtG003: Label 'Pensez à calculer vos calendriers avant de lancer une mise à jour. Si l''impact des mises à jour dépasse le calendrier, un message d''erreur bloquant arrêtera le traitement.\Voulez-vous continuer ?';
        Stat: Option New,Certified,"Under Development",Closed;
}

