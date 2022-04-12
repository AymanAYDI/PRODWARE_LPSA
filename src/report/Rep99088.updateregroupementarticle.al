report 99088 "update regroupement article"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/updateregroupementarticle.rdl';

    dataset
    {
        dataitem(Item; Item)
        {
            column(Item__No__; "No.")
            {
            }
            column(Item_Description; Description)
            {
            }
            column(Item__LPSA_Description_1_; "PWD LPSA Description 1")
            {
            }

            trigger OnAfterGetRecord()
            begin

                Validate("Reorder Cycle", DateF);
                Modify;
            end;

            trigger OnPreDataItem()
            begin
                SetFilter("Location Code", '<>ACI');
                SetFilter("Item Category Code", '<>ACI');
                SetFilter("No.", '<>996*');
                SetRange("Replenishment System", "Replenishment System"::"Prod. Order");
                SetRange("Reordering Policy", "Reordering Policy"::"Lot-for-Lot");
                Evaluate(DateF, '1A');
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
        DateF: DateFormula;
}

