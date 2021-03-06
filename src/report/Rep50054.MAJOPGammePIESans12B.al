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
    UsageCategory = None;
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
                if (StrPos(Item."PWD LPSA Description 1", '??') <> 0) or
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
                    field(CodGOldOperationF; CodGOldOperation)
                    {
                        Caption = 'Remplacer';
                        TableRelation = "Machine Center";
                        ApplicationArea = All;
                    }
                    field(CodGNewOperationF; CodGNewOperation)
                    {
                        Caption = 'Par';
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
        CstG001: Label 'Dans les gammes PIE (Filtrage N??:PIE*), uniquement pour les articles n''ayant pas dans leur d??signation LPSA1 le caract??re ''''??" ou "B'' ou les 2, voulez vous remplacer l''op??ration %1 par l''op??ration %2 avec comme d??signation %3 ?';
        CstG002: Label 'Traitement annul?? !';
        CstG003: Label 'Merci de saisir 2 op??rations et si n??cessaire la d??signation.';
        CstG004: Label 'MAJ Ligne Gammes PIE (Filtrage N:PIE*), uniquement pour les articles n''ayant pas dans leur d??signation LPSA1 le caract??re ''''??" ou "B'' ou les 2,\\Enregistrements restants #1##############';
        TxtGNewOperationDescription: Text[30];
}

