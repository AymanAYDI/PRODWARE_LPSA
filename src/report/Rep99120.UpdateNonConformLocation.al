report 99120 "Update Non Conform. Location"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Company; Company)
        {

            trigger OnAfterGetRecord()
            begin
                RecGManufSetup.Reset;
                RecGManufSetup.Get;
                RecGManufSetup."PWD Non conformity Prod. Location" := '';
                RecGManufSetup.Modify(false);
                RecGManufSetup.ChangeCompany(Company.Name);
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
        RecGManufSetup: Record "Manufacturing Setup";
}

