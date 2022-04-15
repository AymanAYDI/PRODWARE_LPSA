report 50111 "PWD update linkes"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/updatelinkes.rdl';

    dataset
    {
        dataitem("Record Link"; "Record Link")
        {

            trigger OnAfterGetRecord()
            begin
                if "Record Link".Company = 'LPSA-BKP-31-07-2015' then begin
                    "Record Link".Company := 'LPSA';
                    Modify();
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

