report 50103 "PWD Update Cost Method"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {

            trigger OnAfterGetRecord()
            begin
                case Item."Replenishment System" of
                    Item."Replenishment System"::Purchase:
                        Item."Costing Method" := Item."Costing Method"::Average;
                    Item."Replenishment System"::"Prod. Order":
                        Item."Costing Method" := Item."Costing Method"::Standard;
                end;
                Item.Modify;

                ItemCostMgt.UpdateUnitCost(Item, '', '', 0, 0, false, false, true, FieldNo("Costing Method"));
                Item.Modify;
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
        ItemCostMgt: Codeunit ItemCostManagement;
}

