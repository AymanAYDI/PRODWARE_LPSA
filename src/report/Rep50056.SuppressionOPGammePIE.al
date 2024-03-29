report 50056 "PWD Suppression OP Gamme PIE"
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
    Caption = 'Suppression OP Gamme PIE';
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
                var
                    RecLRoutingLine: Record "Routing Line";
                begin
                    if (CodGOperationToCheck = CodGStartOperation) and ("Routing Line"."No." = CodGOperationToDel) then begin
                        RecLRoutingLine.Get("Routing Line"."Routing No.",
                                            "Routing Line"."Version Code",
                                            "Routing Line"."Operation No.");
                        RecLRoutingLine.Delete();
                    end;

                    CodGOperationToCheck := "Routing Line"."No.";
                end;

                trigger OnPreDataItem()
                begin
                    CodGOperationToCheck := '';
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

                if not Confirm(CstG001, false, CodGOperationToDel, CodGStartOperation, "Routing Header".GetFilters) then
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
                    Caption = 'Option';
                    field(CodGOperationToDelF; CodGOperationToDel)
                    {
                        Caption = 'Opération à supprimer';
                        TableRelation = "Machine Center";
                        ApplicationArea = All;
                    }
                    field(CodGStartOperationF; CodGStartOperation)
                    {
                        Caption = 'Quand elle suit l''opération';
                        TableRelation = "Machine Center";
                        ApplicationArea = All;
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
        if (CodGOperationToDel = '') or
           (CodGStartOperation = '') then
            Error(CstG003);
    end;

    var
        CodGOperationToCheck: Code[20];
        CodGOperationToDel: Code[20];
        CodGStartOperation: Code[20];
        BDialog: Dialog;
        IntGCounter: Integer;
        CstG001: Label 'Dans les gammes PIE (Filtrage %3), voulez vous supprimer l''opération %1 si elle suit l''opération %2 ?';
        CstG002: Label 'Traitement annulé !';
        CstG003: Label 'Merci de saisir 2 opérations.';
        CstG004: Label 'MAJ Ligne Gammes PIE (Filtrage N°:PIE*),\\Enregistrements restants #1##############';
}

