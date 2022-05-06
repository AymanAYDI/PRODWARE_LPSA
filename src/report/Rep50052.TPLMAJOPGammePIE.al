report 50052 "PWD TPL MAJ OP Gamme PIE"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>NDBI
    // LALE.PA : 04/05/2021 : P27818_001/P27818_002 DEMANDES DIVERSES suite TI525814
    //                   - New report

    ProcessingOnly = true;
    UsageCategory = none;
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
                    RecLWorkCenter: Record "Work Center";
                begin
                    if ("Routing Line"."No." = CodGOldOperation) then begin
                        "Routing Line"."No." := CodGNewOperation;
                        "Routing Line".Description := TxtGNewOperationDescription;
                        RecLMachineCenter.Get("Routing Line"."No.");
                        RecLWorkCenter.Get(RecLMachineCenter."Work Center No.");
                        "Routing Line"."Work Center No." := RecLWorkCenter."No.";
                        "Routing Line"."Work Center Group Code" := RecLWorkCenter."Work Center Group Code";
                        "Routing Line".Modify();
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

                if not Confirm(CstG001, false, CodGOldOperation, CodGNewOperation, TxtGNewOperationDescription, "Routing Header".GetFilters) then
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
                    field(CodGOldOperationF; CodGOldOperation)
                    {
                        Caption = 'Remplacer';
                        ShowCaption = false;
                        TableRelation = "Machine Center";
                        ApplicationArea = All;
                    }
                    field(CodGNewOperationF; CodGNewOperation)
                    {
                        Caption = 'Par';
                        ShowCaption = false;
                        TableRelation = "Machine Center";
                        ApplicationArea = All;
                        trigger OnValidate()
                        var
                            RecLMachineCenter: Record "Machine Center";
                        begin

                            RecLMachineCenter.GET(CodGNewOperation);
                            TxtGNewOperationDescription := RecLMachineCenter.Name;
                        end;
                    }
                    field(TxtGNewOperationDescriptionF; TxtGNewOperationDescription)
                    {
                        Caption = '';
                        ShowCaption = false;
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
        if (CodGOldOperation = '') or
           (CodGNewOperation = '') or
           (TxtGNewOperationDescription = '') then
            Error(CstG003);
    end;

    var
        CodGNewOperation: Code[20];
        CodGOldOperation: Code[20];
        BDialog: Dialog;
        IntGCounter: Integer;
        CstG001: Label 'Dans les gammes PIE (Filtrage %4), voulez vous remplacer l''opération %1 par l''opération %2 avec comme désignation %3 ?';
        CstG002: Label 'Traitement annulé !';
        CstG003: Label 'Merci de saisir 2 opérations et si nécessaire la désignation.';
        CstG004: Label 'MAJ Ligne Gammes PIE (Filtrage N°:PIE*),\\Enregistrements restants #1##############';
        TxtGNewOperationDescription: Text[30];
}

