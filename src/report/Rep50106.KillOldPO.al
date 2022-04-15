report 50106 "PWD Kill Old PO"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            DataItemTableView = SORTING(Status, "No.") WHERE(Status = CONST(Released), "Location Code" = FILTER('ACI*'));
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin
                CODEUNIT.Run(50097, "Production Order");
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

