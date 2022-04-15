report 50040 "PWD TPL coché export OSYS"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Prod. Order Line"; "Prod. Order Line")
        {
            RequestFilterFields = Status, "Prod. Order No.";

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

            trigger OnPreDataItem()
            begin
                if Count <> 1 then Error('Ce traitement ne fonctione que sur un OF à la fois');
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

