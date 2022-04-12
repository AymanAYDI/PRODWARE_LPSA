report 50110 "PWD Check Items"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/CheckItems.rdl';

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = WHERE("Costing Method" = CONST(Standard), "Location Code" = FILTER(<> 'ACI'));
            column(Item__No__; "No.")
            {
            }
            column(Item_Description; Description)
            {
            }

            trigger OnAfterGetRecord()
            var
                RecLRouting: Record "Routing Header";
                RecLBOM: Record "Production BOM Header";
                Boo1: Boolean;
                Boo2: Boolean;
            begin
                //>>NICOLAS
                Boo1 := false;
                Boo2 := false;

                if (((Item."Routing No." <> '') and RecLRouting.Get(Item."Routing No.") and
                  (RecLRouting.Status = RecLRouting.Status::Certified))) then
                    Boo1 := true;

                if Item."Routing No." = '' then
                    Boo1 := true;

                if ((Item."Production BOM No." <> '') and (RecLBOM.Get(Item."Production BOM No.")) and
                  (RecLBOM.Status = RecLBOM.Status::Certified)) then
                    Boo2 := true;

                if Item."Production BOM No." = '' then
                    Boo2 := true;

                if (Boo1 and Boo2) then
                    CurrReport.Skip;


                //<<NICOLAS
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

