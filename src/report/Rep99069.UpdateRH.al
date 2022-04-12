report 99069 "PWD Update RH"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/UpdateRH.rdl';

    dataset
    {
        dataitem("Routing Header"; "Routing Header")
        {

            trigger OnAfterGetRecord()
            begin
                RH.Get("No.");
                "Routing Header".Validate(Status, RH.Status);
                "Routing Header".Modify(true);
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
        RH: Record "Routing Header BKP";
}

