report 50041 "TPL coché export OSYS Terminé"
{
    ProcessingOnly = true;
UsageCategory = none;
    dataset
    {
        dataitem("Prod. Order Line"; "Prod. Order Line")
        {
            DataItemTableView = WHERE(Status = FILTER(Finished));
            RequestFilterFields = "Prod. Order No.";

            trigger OnAfterGetRecord()
            begin
                if "Prod. Order Line"."Send to OSYS (Released)" = false then begin
                    "Prod. Order Line"."Send to OSYS (Released)" := true;
                    "Prod. Order Line".Modify();
                end;

                if "Prod. Order Line"."Send to OSYS (Finished)" = false then begin
                    "Prod. Order Line"."Send to OSYS (Finished)" := true;
                    "Prod. Order Line".Modify();
                end;
            end;

            trigger OnPostDataItem()
            begin
                Message('terminée');
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
}

