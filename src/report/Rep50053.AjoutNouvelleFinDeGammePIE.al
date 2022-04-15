report 50053 "Ajout NouvelleFin De Gamme PIE"
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
        dataitem("Routing Header"; "Routing Header")
        {
            DataItemTableView = SORTING("No.");
            dataitem("Routing Line"; "Routing Line")
            {
                DataItemLink = "Routing No." = FIELD("No.");
                DataItemTableView = SORTING("Routing No.", "Version Code", "Operation No.") WHERE(Type = FILTER("Machine Center"));

                trigger OnAfterGetRecord()
                begin
                    if BooGStartDelete then begin
                        "Routing Line".Delete();
                        CurrReport.Skip();
                    end;

                    if ("Routing Line"."No." = CodGStartOperation) then begin
                        RecGRoutingLineToAdd.Reset();
                        RecGRoutingLineToAdd.SetRange("Routing No.", CodGRoutingToAdd);
                        RecGRoutingLineToAdd.FindFirst();
                        if "Routing Line"."Operation No." >= RecGRoutingLineToAdd."Operation No." then
                            Error(CstG005, CodGStartOperation, CodGRoutingToAdd);

                        BooGStartDelete := true;
                        CodGOperationNo := "Routing Line"."Operation No.";
                        CodGRoutingNo := "Routing Line"."Routing No."
                    end;
                end;

                trigger OnPostDataItem()
                var
                    RecLRoutingHeader: Record "Routing Header";
                    CduLCheckRoutingLines: Codeunit "Check Routing Lines";
                begin
                    if BooGStartDelete then begin
                        RecGRoutingLineToAdd.Reset();
                        RecGRoutingLineToAdd.SetRange("Routing No.", CodGRoutingToAdd);
                        if RecGRoutingLineToAdd.FindFirst() then
                            repeat
                                RecGRoutingLineAdded := RecGRoutingLineToAdd;
                                RecGRoutingLineAdded."Routing No." := CodGRoutingNo;
                                if CodGOperationNo <> '' then begin
                                    RecGRoutingLineAdded."Previous Operation No." := CodGOperationNo;
                                    CodGOperationNo := '';
                                end;
                                RecGRoutingLineAdded.Insert();

                            until RecGRoutingLineToAdd.Next() = 0;

                        if ("Routing Header".Status = "Routing Header".Status::Certified) then begin
                            RecLRoutingHeader.Get("Routing Header"."No.");
                            CduLCheckRoutingLines.Calculate(RecLRoutingHeader, '');
                            RecLRoutingHeader.Modify(true);
                        end;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    BooGStartDelete := false;
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

                if not Confirm(CstG001, false,
                                       CodGStartOperation, CodGRoutingToAdd, "Routing Header".GetFilters) then
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
        if (CodGStartOperation = '') or
           (CodGRoutingToAdd = '') then
            Error(CstG003);
    end;

    var
        BDialog: Dialog;
        IntGCounter: Integer;
        CodGStartOperation: Code[20];
        CodGRoutingToAdd: Code[20];
        CstG001: Label 'Dans les gammes PIE (Filtrage %3), voulez vous remplacer toutes les opérations après l''opération %1 par les lignes de la gamme %2 ?';
        CstG002: Label 'Traitement annulé !';
        CstG003: Label 'Merci de saisir l''opérations de départ et la gamme à ajouter.';
        CstG004: Label 'MAJ Ligne Gammes PIE (Filtrage N°:PIE*),\\Enregistrements restants #1##############';
        BooGStartDelete: Boolean;
        CodGOperationNo: Code[20];
        CodGRoutingNo: Code[20];
        CstG005: Label 'Attention le n° opération du poste de charge %1 ne doit pas être plus grand que le n° opération de la première ligne de la gamme à ajouter %2';
        RecGRoutingLineToAdd: Record "Routing Line";
        RecGRoutingLineAdded: Record "Routing Line";
}

