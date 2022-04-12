report 99067 "PWD Update POL"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/UpdatePOL.rdl';

    dataset
    {
        dataitem("Prod. Order Line"; "Prod. Order Line")
        {
            DataItemTableView = WHERE(Status = FILTER(<= Released), "Location Code" = FILTER(<> 'ACI'));

            trigger OnAfterGetRecord()
            begin
                if POL.Get(Status, "Prod. Order No.", "Line No.") then begin
                    "Routing No." := POL."Routing No.";
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

    var
        POL: Record "Prod. Order Line BKP";
}

