report 50054 "MAJ OP Gamme PIE Sans 1/2;B"
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

                trigger OnPreDataItem()
                begin
                    "Routing Header".SetFilter("No.", 'PIE*');
                end;
            }

            trigger OnAfterGetRecord()
            begin
                BDialog.Update(1, IntGCounter);
                IntGCounter -= 1;
                if (StrPos(Item."PWD LPSA Description 1", '½') <> 0) or
                   (StrPos(Item."PWD LPSA Description 1", 'B') <> 0) then
                    CurrReport.Skip();
            end;

            trigger OnPostDataItem()
            begin
                BDialog.Close();
            end;

            trigger OnPreDataItem()
            begin
                if not Confirm(CstG001, false, CodGOldOperation, CodGNewOperation, TxtGNewOperationDescription) then
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
            area(content)
            {
                group(Control1000000000)
                {
                    Caption = 'Action';
                    ShowCaption = false;
                    field(CodGOldOperation; CodGOldOperation)
                    {
                        Caption = 'Remplacer';
                        ShowCaption = false;
                        TableRelation = "Machine Center";
                        ApplicationArea = All;
                    }
                    field(CodGNewOperation; CodGNewOperation)
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
                    field(TxtGNewOperationDescription; TxtGNewOperationDescription)
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
        BDialog: Dialog;
        IntGCounter: Integer;
        CodGOldOperation: Code[20];
        CodGNewOperation: Code[20];
        TxtGNewOperationDescription: Text[30];
        CstG001: Label 'Dans les gammes PIE (Filtrage N°:PIE*), uniquement pour les articles n''ayant pas dans leur désignation LPSA1 le caractère ''''½" ou "B'' ou les 2, voulez vous remplacer l''opération %1 par l''opération %2 avec comme désignation %3 ?';
        CstG002: Label 'Traitement annulé !';
        CstG003: Label 'Merci de saisir 2 opérations et si nécessaire la désignation.';
        CstG004: Label 'MAJ Ligne Gammes PIE (Filtrage N:PIE*), uniquement pour les articles n''ayant pas dans leur désignation LPSA1 le caractère ''''½" ou "B'' ou les 2,\\Enregistrements restants #1##############';
}

