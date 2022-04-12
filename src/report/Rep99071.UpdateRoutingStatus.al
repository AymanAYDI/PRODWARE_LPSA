report 99071 "PWD Update Routing Status"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/UpdateRoutingStatus.rdl';

    dataset
    {
        dataitem("Prod. Order Routing Line"; "Prod. Order Routing Line")
        {

            trigger OnAfterGetRecord()
            begin
                ItemBuffer.Reset;
                ItemBuffer.SetRange("Prod. Order No.", "Prod. Order No.");
                ItemBuffer.SetRange(Type, "Prod. Order Routing Line".Type);
                ItemBuffer.SetRange("No.", "Prod. Order Routing Line"."No.");
                ItemBuffer.SetRange("Operation No.", "Prod. Order Routing Line"."Operation No.");
                ItemBuffer.SetRange(Finished, true);
                if ItemBuffer.FindFirst then begin
                    "Routing Status" := "Routing Status"::Finished;
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
        ItemBuffer: Record "PWD Item Jounal Line Buffer";
}

