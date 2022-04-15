report 99076 "PWD Update Prod. Line From BKP"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Prod. Order Line"; "Prod. Order Line")
        {
            DataItemTableView = SORTING(Status, "Prod. Order No.", "Line No.") WHERE(Status = FILTER(< Finished));
            RequestFilterFields = "Prod. Order No.";

            trigger OnAfterGetRecord()
            var
                RecL50098: Record "Prod. Order Line BKP";
                ProdOrder: Record "Production Order";
            begin
                if RecL50098.Get(Status, "Prod. Order No.", "Line No.") and ProdOrder.Get(Status, "Prod. Order No.") then begin
                    Validate("Ending Date-Time", RecL50098."Ending Date-Time");
                    Modify(true);
                end;
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

