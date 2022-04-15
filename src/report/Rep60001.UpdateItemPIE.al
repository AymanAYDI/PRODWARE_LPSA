report 60001 "PWD Update Item PIE"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/UpdateItemPIE.rdl';

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("No.") WHERE("Item Category Code" = CONST('PIE'));

            trigger OnAfterGetRecord()
            begin

                Item."Maximum Order Quantity" := Item."Order Multiple";
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

