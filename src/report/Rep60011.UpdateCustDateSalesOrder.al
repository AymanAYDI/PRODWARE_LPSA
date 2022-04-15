report 60011 "Update Cust Date Sales Order"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/UpdateCustDateSalesOrder.rdl';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Order), Status = CONST(Released));
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") WHERE(Type = CONST(Item));

                trigger OnAfterGetRecord()
                begin
                    "Cust Promised Delivery Date" := "Planned Delivery Date";
                    Modify();
                end;
            }

            trigger OnAfterGetRecord()
            begin
                "Cust Promised Delivery Date" := "Shipment Date";
                Modify();
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

