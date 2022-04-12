report 60012 "PWD Update Des Quartis <>992*"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/UpdateDesQuartis992.rdl';

    dataset
    {
        dataitem("PWD Item Configurator"; "PWD Item Configurator")
        {
            DataItemTableView = SORTING("Item Code") WHERE("Item Code" = FILTER('802*' & '902*'), "Location Code" = CONST('PIE'));
            RequestFilterFields = "Item Code";

            trigger OnAfterGetRecord()
            begin

                CdUGItemConfigurator.FctConfigDescSemiFinish("PWD Item Configurator");
                Modify;

                RecGItem.Get("Item Code");
                RecGItem."PWD Quartis Description" := "PWD Quartis Description";
                RecGItem.Modify;
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
        RecGItem: Record Item;
        CdUGItemConfigurator: Codeunit "PWD Item Configurator";
}

