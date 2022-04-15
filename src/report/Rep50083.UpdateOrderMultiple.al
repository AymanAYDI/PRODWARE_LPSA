report 50083 "PWD Update Order Multiple"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/UpdateOrderMultiple.rdl';

    dataset
    {
        dataitem("New Order By"; "PWD New Order By")
        {

            trigger OnAfterGetRecord()
            var
                RecLItem: Record Item;
            begin
                if "New Order By"."Qty Order By Init" <> 0 then begin
                    RecLItem.Get("New Order By"."Item No.");
                    if RecLItem."Location Code" <> 'ACI' then begin
                        RecLItem.Validate("Order Multiple", "New Order By"."Qty Order By Init");
                        RecLItem.Validate("Maximum Order Quantity", "New Order By"."Qty Order By Init");
                        RecLItem.Validate("Lot Size", "New Order By"."Qty Order By Init");
                        RecLItem.Modify();
                    end;
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

