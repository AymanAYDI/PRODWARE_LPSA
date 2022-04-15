report 50064 "Modif OP après OP Gamme PIE"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>NDBI
    // LALE.PA : 01/06/2021 : P27818_003 Création TPL suite mail de Max Tholomier le 21/05/2021
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
                var
                    RecLMachineCenter: Record "Machine Center";
                    RecLRoutingLine: Record "Routing Line";
                    RecLWorkCenter: Record "Work Center";
                begin
                    if (CodGOperationToCheck = CodGStartOperation) and ("Routing Line"."No." = CodGOldOperation) then begin
                        "Routing Line"."No." := CodGNewOperation;
                        "Routing Line".Description := TxtGNewOperationDescription;
                        RecLMachineCenter.Get("Routing Line"."No.");
                        RecLWorkCenter.Get(RecLMachineCenter."Work Center No.");
                        "Routing Line"."Work Center No." := RecLWorkCenter."No.";
                        "Routing Line"."Work Center Group Code" := RecLWorkCenter."Work Center Group Code";
                        "Routing Line".Modify();
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

                if not Confirm(CstG001, false, CodGOldOperation, CodGNewOperation, TxtGNewOperationDescription, CodGStartOperation,
                                             "Routing Header".GetFilters) then
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
        if (CodGOldOperation = '') or
           (CodGNewOperation = '') or
           (CodGStartOperation = '') then
            Error(CstG003);
    end;

    var
        BDialog: Dialog;
        IntGCounter: Integer;
        CodGStartOperation: Code[20];
        CstG001: Label 'Dans les gammes PIE (Filtrage %5), voulez vous remplacer l''opération %1 par l''opération %2 avec comme désignation %3 si elle suit l''opération %4 ?';
        CstG002: Label 'Traitement annulé !';
        CstG003: Label 'Merci de saisir les opérations.';
        CstG004: Label 'MAJ Ligne Gammes PIE (Filtrage N°:PIE*),\\Enregistrements restants #1##############';
        CodGOperationToCheck: Code[20];
        CodGOldOperation: Code[20];
        CodGNewOperation: Code[20];
        TxtGNewOperationDescription: Text[30];
}

