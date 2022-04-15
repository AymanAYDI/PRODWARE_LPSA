report 60000 "PWD Update Scrap %"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/UpdateScrap.rdl';

    dataset
    {
        dataitem("Machine Center"; "Machine Center")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            dataitem("Routing Line"; "Routing Line")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = SORTING("Routing No.", "Version Code", "Operation No.") WHERE(Type = CONST("Machine Center"));

                trigger OnAfterGetRecord()
                begin
                    "Scrap Factor %" := "Machine Center"."Scrap %";
                    "Fixed Scrap Quantity" := "Machine Center"."Fixed Scrap Quantity";
                    Modify();
                end;
            }
            dataitem("Prod. Order Routing Line"; "Prod. Order Routing Line")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = SORTING(Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.") WHERE(Type = CONST("Machine Center"));

                trigger OnAfterGetRecord()
                begin
                    "Scrap Factor %" := "Machine Center"."Scrap %";
                    "Fixed Scrap Quantity" := "Machine Center"."Fixed Scrap Quantity";
                    Modify();
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

