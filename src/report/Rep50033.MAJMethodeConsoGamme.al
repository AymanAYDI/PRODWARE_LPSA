report 50033 "PWD MAJ Methode Conso Gamme"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Routing Line"; "Routing Line")
        {

            trigger OnAfterGetRecord()
            begin
                BDialog.Update(1, IntGCounter);
                IntGCounter -= 1;
                case Type of
                    Type::"Work Center":
                        begin
                            WorkCenter.Get("No.");
                            "PWD Flushing Method" := WorkCenter."Flushing Method";
                            Modify();
                        end;
                    Type::"Machine Center":
                        begin
                            MachineCenter.Get("No.");
                            "PWD Flushing Method" := MachineCenter."Flushing Method";
                            Modify();
                        end;
                end;
            end;

            trigger OnPostDataItem()
            begin
                BDialog.Close();
                Message('Traitement terminé');
            end;

            trigger OnPreDataItem()
            begin
                BDialog.Open('MAJ Méthode de consommation sur Ligne gamme article\\Enregistrements restants #1##############');
                IntGCounter := Count;
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
        MachineCenter: Record "Machine Center";
        WorkCenter: Record "Work Center";
        BDialog: Dialog;
        IntGCounter: Integer;
}

