report 60010 "PWD Update Printed Purch Order"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/UpdatePrintedPurchOrder.rdl';

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Order), Status = CONST(Released));

            trigger OnAfterGetRecord()
            begin
                Printed := true;
                Modify;
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

