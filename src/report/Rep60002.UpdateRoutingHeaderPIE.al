report 60002 "PWD Update Routing Header PIE"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/UpdateRoutingHeaderPIE.rdl';

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("No.") WHERE("Item Category Code" = CONST('PIE'));
            dataitem("Routing Header"; "Routing Header")
            {
                DataItemLink = "No." = FIELD("Routing No.");
                DataItemTableView = SORTING("No.");

                trigger OnAfterGetRecord()
                begin
                    if Status = Status::Certified then begin
                        Validate(Status, Status::"Under Development");
                        Validate(Status, Status::Certified);
                        Modify;
                    end;
                end;
            }
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

