report 99024 "Traitement suppression D et Ep"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/TraitementsuppressionDetEp.rdl';

    dataset
    {
        dataitem("PWD Item Configurator"; "PWD Item Configurator")
        {

            trigger OnAfterGetRecord()
            begin
                "PWD Item Configurator".D := 0;
                "PWD Item Configurator".Ep := 0;
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

