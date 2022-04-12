report 99089 "PWD update qty transfert"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/updateqtytransfert.rdl';

    dataset
    {
        dataitem("Routing Line"; "Routing Line")
        {

            trigger OnAfterGetRecord()
            begin
                if "Send-Ahead Quantity" <> 0 then begin
                    "Routing Line".Validate("Send-Ahead Quantity", 0);
                    Modify;
                end;
            end;
        }
        dataitem("Prod. Order Routing Line"; "Prod. Order Routing Line")
        {
            DataItemTableView = WHERE(Status = FILTER(<> Finished));

            trigger OnAfterGetRecord()
            begin
                if "Send-Ahead Quantity" <> 0 then begin
                    "Prod. Order Routing Line".Validate("Send-Ahead Quantity", 0);
                    Modify;
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

