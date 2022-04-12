report 60024 "Find Purch. Orders Partial Inv"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/FindPurchOrdersPartialInv.rdl';

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Order), "Order Date" = FILTER(.. 20150101D));

            trigger OnAfterGetRecord()
            begin
                PurchLine.SetRange("Document Type", "Document Type");
                PurchLine.SetRange("Document No.", "No.");
                PurchLine.SetRange("Qty. Rcd. Not Invoiced");
                if PurchLine.Count = 1 then
                    CurrReport.Skip;
                PurchLine.SetFilter("Outstanding Quantity", '<>0');
                if not PurchLine.FindFirst then
                    CurrReport.Skip;

                PurchLine.SetRange("Outstanding Quantity");
                PurchLine.SetFilter("Qty. Rcd. Not Invoiced", '<>0');

                if not PurchLine.FindFirst then
                    CurrReport.Skip;

                Message("No.");
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
        PurchLine: Record "Purchase Line";
}

