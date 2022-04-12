report 60005 "Update Routing Header PIE 2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/UpdateRoutingHeaderPIE2.rdl';

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("No.");

            trigger OnAfterGetRecord()
            begin
                if CopyStr("No.", 1, 4) = '9911' then begin
                    Item."Routing No." := 'PIE_P_LASER';
                    Modify;
                end;

                if CopyStr("No.", 1, 4) = '9912' then begin
                    Item."Routing No." := 'PIE_P_BROCHE';
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

