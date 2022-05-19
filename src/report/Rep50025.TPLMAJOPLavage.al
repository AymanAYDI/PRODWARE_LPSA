report 50025 "PWD TPL MAJ OP Lavage"
{
    ProcessingOnly = true;
    UsageCategory = None;
    dataset
    {
        dataitem("Routing Header"; "Routing Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            dataitem("Routing Line"; "Routing Line")
            {
                DataItemLink = "Routing No." = FIELD("No.");
                DataItemTableView = SORTING("Routing No.", "Version Code", "Operation No.") WHERE(Type = FILTER("Machine Center"));

                trigger OnAfterGetRecord()
                var
                    RecLMachineCenter: Record "Machine Center";
                begin
                    if ("Routing Line"."No." = 'OP37201') or ("Routing Line"."No." = 'OP37501') then begin
                        BooGChangeLavage := true;
                        CurrReport.Skip();
                    end;

                    if ("Routing Line"."No." = 'OP11810') and BooGChangeLavage then begin
                        "Routing Line"."No." := 'OP11811';
                        RecLMachineCenter.Get('OP11811');
                        "Routing Line".Description := RecLMachineCenter.Name;
                        "Routing Line".Modify();
                    end;

                    BooGChangeLavage := false;
                end;

                trigger OnPreDataItem()
                begin
                    BooGChangeLavage := false;
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
                BDialog.Open('MAJ Ligne Gamme\\Enregistrements restants #1##############');
                IntGCounter := "Routing Header".Count;
            end;
        }
        dataitem("Prod. Order Line"; "Prod. Order Line")
        {
            DataItemTableView = SORTING(Status, "Prod. Order No.", "Line No.") WHERE(Status = FILTER(Released));
            RequestFilterFields = "Prod. Order No.";
            dataitem("Prod. Order Routing Line"; "Prod. Order Routing Line")
            {
                DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("Prod. Order No."), "Routing Reference No." = FIELD("Routing Reference No."), "Routing No." = FIELD("Routing No.");
                DataItemTableView = SORTING(Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.") WHERE("Routing Status" = FILTER(<> Finished), Type = FILTER("Machine Center"));

                trigger OnAfterGetRecord()
                var
                    RecLMachineCenter: Record "Machine Center";
                    RecLProdOrderLine: Record "Prod. Order Line";
                begin
                    if ("Prod. Order Routing Line"."No." = 'OP37201') or ("Prod. Order Routing Line"."No." = 'OP37501') then begin
                        BooGChangeLavage := true;
                        CurrReport.Skip();
                    end;

                    if ("Prod. Order Routing Line"."No." = 'OP11810') and BooGChangeLavage then begin
                        "Prod. Order Routing Line"."No." := 'OP11811';
                        RecLMachineCenter.Get('OP11811');
                        "Prod. Order Routing Line".Description := RecLMachineCenter.Name;
                        "Prod. Order Routing Line".Modify();

                        RecLProdOrderLine.Get("Prod. Order Line".Status, "Prod. Order Line"."Prod. Order No.", "Prod. Order Line"."Line No.");
                        RecLProdOrderLine."Send to OSYS (Released)" := false;
                        RecLProdOrderLine.Modify(false);
                    end;

                    BooGChangeLavage := false;
                end;

                trigger OnPreDataItem()
                begin
                    BooGChangeLavage := false;
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
                Message('traitement terminé');
            end;

            trigger OnPreDataItem()
            begin
                BDialog.Open('MAJ Ligne Gamme OF\\Enregistrements restants #1##############');
                IntGCounter := "Prod. Order Line".Count;
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

    var
        BooGChangeLavage: Boolean;
        BDialog: Dialog;
        IntGCounter: Integer;
}

