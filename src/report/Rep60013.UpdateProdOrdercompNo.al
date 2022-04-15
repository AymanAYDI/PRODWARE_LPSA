report 60013 "PWD Update Prod Order comp No"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/UpdateProdOrdercompNo.rdl';

    dataset
    {
        dataitem("Production Order"; "Production Order")
        {

            trigger OnAfterGetRecord()
            begin
                ProdOrderComp.SetRange(Status, Status);
                ProdOrderComp.SetRange("Prod. Order No.", "No.");
                if ProdOrderComp.FindFirst() then begin
                    "Component No." := ProdOrderComp."Item No.";
                    Modify();
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
        ProdOrderComp: Record "Prod. Order Component";
}

