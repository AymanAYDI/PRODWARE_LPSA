report 50057 "PWD MAJ Tps OP Gamme PIE"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>NDBI
    // LALE.PA : 15/03/2021 : P27818_001/P27818_002 DEMANDES DIVERSES suite TI525814
    //                   - New report

    ProcessingOnly = true;
    UsageCategory = None;
    dataset
    {
        dataitem("Routing Header"; "Routing Header")
        {
            DataItemTableView = SORTING("No.");
            dataitem("Routing Line"; "Routing Line")
            {
                DataItemLink = "Routing No." = FIELD("No.");
                DataItemTableView = SORTING("Routing No.", "Version Code", "Operation No.") WHERE(Type = FILTER("Machine Center"));

                trigger OnAfterGetRecord()
                begin
                    if CodGOperation = "Routing Line"."No." then begin
                        if BooGSetupTime then begin
                            "Routing Line"."Setup Time" := DecGSetupTime;
                            "Routing Line".Modify();
                        end;

                        if BooGRunTime then begin
                            "Routing Line"."Run Time" := DecGRunTime;
                            "Routing Line".Modify();
                        end;

                        if BooGMoveTime then begin
                            "Routing Line"."Move Time" := DecGMoveTime;
                            "Routing Line".Modify();
                        end;
                    end;
                end;

                trigger OnPostDataItem()
                var
                    RecLRoutingHeader: Record "Routing Header";
                    CduLCheckRoutingLines: Codeunit "Check Routing Lines";
                begin
                    if ("Routing Header".Status = "Routing Header".Status::Certified) then begin
                        RecLRoutingHeader.Get("Routing Header"."No.");
                        CduLCheckRoutingLines.Calculate(RecLRoutingHeader, '');
                        RecLRoutingHeader.Modify(true);
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                BDialog.Update(1, IntGCounter);
                IntGCounter -= 1;
            end;

            trigger OnPostDataItem()
            begin
                BDialog.Close();
            end;

            trigger OnPreDataItem()
            begin
                "Routing Header".SetFilter("No.", 'PIE*');

                if BooGSetupTime and
                   (not BooGRunTime) and
                   (not BooGMoveTime) then
                    if not Confirm(CstG001, false,
                                   "Routing Header".GetFilters, CodGOperation, DecGSetupTime) then
                        Error(CstG002);

                if (not BooGSetupTime) and
                   BooGRunTime and
                   (not BooGMoveTime) then
                    if not Confirm(CstG005, false,
                                   "Routing Header".GetFilters, CodGOperation, DecGRunTime) then
                        Error(CstG002);

                if (not BooGSetupTime) and
                   (not BooGRunTime) and
                   BooGMoveTime then
                    if not Confirm(CstG006, false,
                                   "Routing Header".GetFilters, CodGOperation, DecGMoveTime) then
                        Error(CstG002);

                if BooGSetupTime and
                   BooGRunTime and
                   (not BooGMoveTime) then
                    if not Confirm(CstG007, false,
                                   "Routing Header".GetFilters, CodGOperation, DecGSetupTime, DecGRunTime) then
                        Error(CstG002);

                if BooGSetupTime and
                   (not BooGRunTime) and
                   BooGMoveTime then
                    if not Confirm(CstG008, false,
                                   "Routing Header".GetFilters, CodGOperation, DecGSetupTime, DecGMoveTime) then
                        Error(CstG002);

                if (not BooGSetupTime) and
                   BooGRunTime and
                   BooGMoveTime then
                    if not Confirm(CstG009, false,
                                   "Routing Header".GetFilters, CodGOperation, DecGRunTime, DecGMoveTime) then
                        Error(CstG002);

                if BooGSetupTime and
                   BooGRunTime and
                   BooGMoveTime then
                    if not Confirm(CstG010, false,
                                   "Routing Header".GetFilters, CodGOperation, DecGSetupTime, DecGRunTime, DecGMoveTime) then
                        Error(CstG002);

                BDialog.Open(CstG004);
                IntGCounter := "Routing Header".Count;
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
                    Caption = 'Action';
                    ShowCaption = false;
                    field(CodGOperationF; CodGOperation)
                    {
                        Caption = 'Pour l''opération';
                        ShowCaption = false;
                        TableRelation = "Machine Center";
                        ApplicationArea = All;
                    }
                    field(CstG011F; CstG011)
                    {
                        ApplicationArea = All;
                        ShowCaption = false;
                        Editable = false;
                    }
                }
                group(Control1000000001)
                {
                    field(BooGSetupTimeF; BooGSetupTime)
                    {
                        Caption = 'prépa';
                        ShowCaption = false;
                        ApplicationArea = All;
                    }
                    field(DecGSetupTimeF; DecGSetupTime)
                    {
                        Caption = '';
                        ShowCaption = false;
                        ApplicationArea = All;
                        Editable = BooGSetupTime;
                    }
                }
                group(Control1000000002)
                {
                    field(BooGRunTimeF; BooGRunTime)
                    {
                        Caption = 'exe';
                        ShowCaption = false;
                        ApplicationArea = All;
                    }
                    field(DecGRunTimeF; DecGRunTime)
                    {
                        Caption = '';
                        ShowCaption = false;
                        ApplicationArea = All;
                        Editable = BooGRunTime;
                    }
                }
                group(Control1000000003)
                {
                    field(BooGMoveTimeF; BooGMoveTime)
                    {
                        Caption = 'Transfert';
                        ShowCaption = false;
                        ApplicationArea = All;
                    }
                    field(DecGMoveTimeF; DecGMoveTime)
                    {
                        Caption = '';
                        ShowCaption = false;
                        ApplicationArea = All;
                        Editable = BooGMoveTime;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if (CodGOperation = '') then
            Error(CstG003);
    end;

    var
        BooGMoveTime: Boolean;
        BooGRunTime: Boolean;
        BooGSetupTime: Boolean;
        CodGOperation: Code[20];
        DecGMoveTime: Decimal;
        DecGRunTime: Decimal;
        DecGSetupTime: Decimal;
        BDialog: Dialog;
        IntGCounter: Integer;
        CstG001: Label 'Dans les gammes PIE (Filtrage %1), voulez vous forcer pour l''opération %2 le temps de prépa à %3 dans toutes les lignes de gamme ?';
        CstG002: Label 'Traitement annulé !';
        CstG003: Label 'Merci de saisir l''opération à modifier.';
        CstG004: Label 'MAJ Ligne Gammes PIE (Filtrage N°:PIE*),\\Enregistrements restants #1##############';
        CstG005: Label 'Dans les gammes PIE (Filtrage %1), voulez vous forcer pour l''opération %2 le temps d''exe à %3 dans toutes les lignes de gamme ?';
        CstG006: Label 'Dans les gammes PIE (Filtrage %1), voulez vous forcer pour l''opération %2 le temps de transfert à %3 dans toutes les lignes de gamme ?';
        CstG007: Label 'Dans les gammes PIE (Filtrage %1), voulez vous forcer pour l''opération %2 le temps de prépa à %3 et le temps d''exe à %4 dans toutes les lignes de gamme ?';
        CstG008: Label 'Dans les gammes PIE (Filtrage %1), voulez vous forcer pour l''opération %2 le temps de prépa à %3 et le temps de transfert à %4 dans toutes les lignes de gamme ?';
        CstG009: Label 'Dans les gammes PIE (Filtrage %1), voulez vous forcer pour l''opération %2 le temps d''exe à %3 et le temps de transfert à %4 dans toutes les lignes de gamme ?';
        CstG010: Label 'Dans les gammes PIE (Filtrage %1), voulez vous forcer pour l''opération %2 le temps de prépa à %3, le temps d''exe à %4 et le temps de transfert à %5 dans toutes les lignes de gamme ?';
        CstG011: Label 'Cocher et préciser la nouvelle valeur pour les temps';
}

