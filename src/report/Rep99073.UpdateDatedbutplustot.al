report 99073 "PWD Update Date début plus tot"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/UpdateDatedébutplustot.rdl';

    dataset
    {
        dataitem("Prod. Order Line"; "Prod. Order Line")
        {
            DataItemTableView = WHERE(Status = FILTER(<= Released));

            trigger OnAfterGetRecord()
            var
                DateL: Date;
            begin
                DateL := CalcDate('-25S', "Ending Date");
                if DateL <> 0D then begin
                    Validate("PWD Earliest Start Date", DateL);
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

