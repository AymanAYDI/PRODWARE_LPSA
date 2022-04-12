report 99096 "PWD NETOYBUFFER"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/NETOYBUFFER.rdl';

    dataset
    {
        dataitem("PWD Item Jounal Line Buffer"; "PWD Item Jounal Line Buffer")
        {
            DataItemTableView = WHERE(Processed = CONST(false));
            column(Item_Jounal_Line_Buffer__Entry_No__; "Entry No.")
            {
            }
            column(Item_Jounal_Line_Buffer__Prod__Order_No__; "Prod. Order No.")
            {
            }

            trigger OnAfterGetRecord()
            var
                RecLProdOrder: Record "Production Order";
            begin
                if not RecLProdOrder.Get(RecLProdOrder.Status::Released, "Prod. Order No.") then
                    Delete;
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

