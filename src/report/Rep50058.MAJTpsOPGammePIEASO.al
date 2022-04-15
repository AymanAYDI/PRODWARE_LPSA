report 50058 "PWD MAJ Tps OP Gamme PIE A/S O"
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

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("No.") WHERE("No." = FILTER('992*' | '802*'));
            dataitem("Routing Header"; "Routing Header")
            {
                DataItemLink = "No." = FIELD("Routing No.");
                DataItemTableView = SORTING("No.");
                dataitem("Routing Line"; "Routing Line")
                {
                    DataItemLink = "Routing No." = FIELD("No.");
                    DataItemTableView = SORTING("Routing No.", "Version Code", "Operation No.") WHERE(Type = FILTER("Machine Center"));

                    trigger OnAfterGetRecord()
                    begin
                        if CodGOperation = "Routing Line"."No." then
                            if BooGDescriptionWithO then begin
                                if BooGSetupTime then begin
                                    "Routing Line"."Setup Time" := DecGSetupTimeO;
                                    "Routing Line".Modify();
                                end;

                                if BooGMoveTime then begin
                                    "Routing Line"."Move Time" := DecGMoveTimeO;
                                    "Routing Line".Modify();
                                end;
                            end else begin
                                if BooGSetupTime then begin
                                    "Routing Line"."Setup Time" := DecGSetupTime;
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

                trigger OnPreDataItem()
                begin
                    "Routing Header".SetFilter("No.", 'PIE*');
                end;
            }

            trigger OnAfterGetRecord()
            begin
                BDialog.Update(1, IntGCounter);
                IntGCounter -= 1;

                BooGDescriptionWithO := (StrPos(Item."PWD LPSA Description 1", 'O') <> 0);
            end;

            trigger OnPostDataItem()
            begin
                BDialog.Close();
            end;

            trigger OnPreDataItem()
            begin
                if BooGSetupTime and
                   (not BooGMoveTime) then
                    if not Confirm(CstG001, false,
                                   CodGOperation, DecGSetupTime, DecGSetupTimeO) then
                        Error(CstG002);

                if (not BooGSetupTime) and
                   BooGMoveTime then
                    if not Confirm(CstG005, false,
                                   CodGOperation, DecGMoveTime, DecGMoveTimeO) then
                        Error(CstG002);

                if BooGSetupTime and
                   BooGMoveTime then
                    if not Confirm(CstG006, false,
                                   CodGOperation, DecGSetupTime, DecGMoveTime, DecGSetupTimeO, DecGMoveTimeO) then
                        Error(CstG002);

                BDialog.Open(CstG004);
                IntGCounter := Item.Count;
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

    trigger OnPreReport()
    begin
        if (CodGOperation = '') then
            Error(CstG003);
    end;

    var
        BDialog: Dialog;
        IntGCounter: Integer;
        CodGOperation: Code[20];
        CstG001: Label 'Dans les gammes PIE (Filtrage N:PIE*), voulez vous forcer pour l''opération %1 le temps de prépa à %2 pour les articles sans "O" et  le temps de prépa à %3 pour les articles avec "O"dans toutes les lignes de gamme ?';
        CstG002: Label 'Traitement annulé !';
        CstG003: Label 'Merci de saisir l''opération à modifier.';
        CstG004: Label 'MAJ Ligne Gammes PIE (Filtrage N°:PIE*),\\Enregistrements restants #1##############';
        BooGSetupTime: Boolean;
        BooGMoveTime: Boolean;
        DecGSetupTime: Decimal;
        DecGMoveTime: Decimal;
        CstG005: Label 'Dans les gammes PIE (Filtrage  N:PIE*), voulez vous forcer pour l''opération %1 le temps de transfert à %2 pour les articles sans "O" et  le temps de transfert à %3 pour les articles avec "O"dans toutes les lignes de gamme ?';
        CstG006: Label 'Dans les gammes PIE (Filtrage  N:PIE*), voulez vous forcer pour l''opération %1 le temps de prépa à %2 et le temps de transfert à %3 pour les articles sans "O" et en plus  le temps de prépa à %4  et le temps de transfert à %5 pour les articles avec "O"dans toutes les lignes de gamme ?';
        DecGSetupTimeO: Decimal;
        DecGMoveTimeO: Decimal;
        BooGDescriptionWithO: Boolean;
}

