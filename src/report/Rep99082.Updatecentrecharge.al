report 99082 "PWD Update centre charge"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/Updatecentrecharge.rdl';

    dataset
    {
        dataitem("Work Center"; "Work Center")
        {
            DataItemTableView = WHERE("No." = FILTER(<> '*P'));

            trigger OnAfterGetRecord()
            begin
                case CopyStr(Name, 1, 3) of
                    'PIE':
                        begin
                            "Work Center".ResourceBehavior := "Work Center".ResourceBehavior::FiniteCapacity;
                            "Work Center".PlanningGroup := 'PIERRES';
                            "Work Center"."PWD ColorScheme" := 'DEFAULT';
                            Modify;
                        end;
                    'PRE':
                        begin
                            "Work Center".ResourceBehavior := "Work Center".ResourceBehavior::FiniteCapacity;
                            "Work Center".PlanningGroup := 'PREPARAGES';
                            "Work Center".ColorScheme := 'DEFAULT';
                            Modify;
                        end;
                    'ACI':
                        begin
                            "Work Center".ResourceBehavior := "Work Center".ResourceBehavior::FiniteCapacity;
                            "Work Center".PlanningGroup := 'ACIERS';
                            "Work Center".ColorScheme := 'DEFAULT';
                            Modify;
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

