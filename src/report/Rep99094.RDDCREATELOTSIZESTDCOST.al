report 99094 "RDD - CREATE LOT SIZE STD COST"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/RDDCREATELOTSIZESTDCOST.rdl';

    dataset
    {
        dataitem(Item; Item)
        {

            trigger OnAfterGetRecord()
            var
                RecLLotSizeStdCost: Record "PWD Lot Size Standard Cost";
            begin
                if "Item Category Code" <> '' then
                    RecLLotSizeStdCost.FctInsertItemLine("No.", "Item Category Code");
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

