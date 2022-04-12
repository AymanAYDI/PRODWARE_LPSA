report 99093 "RDD - CReation unite article"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/RDDCReationunitearticle.rdl';

    dataset
    {
        dataitem(Item; Item)
        {

            trigger OnAfterGetRecord()
            var
                RecLunit: Record "Item Unit of Measure";
                RecLunit2: Record "Item Unit of Measure";
            begin
                RecLunit.Reset;
                RecLunit.SetRange("Item No.", "No.");
                if RecLunit.IsEmpty then begin
                    RecLunit2.Init;
                    RecLunit2.Validate("Item No.", "No.");
                    RecLunit2.Validate(Code, 'PCE');
                    RecLunit2.Validate("Qty. per Unit of Measure", 1);
                    RecLunit2.Insert;
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

