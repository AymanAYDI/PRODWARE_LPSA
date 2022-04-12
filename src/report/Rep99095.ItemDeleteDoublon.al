report 99095 "PWD Item : Delete Doublon"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/ItemDeleteDoublon.rdl';

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "Last Date Modified";

            trigger OnAfterGetRecord()
            begin
                RecItem2.SetFilter("No.", '<>%1', "No.");
                RecItem2.SetRange("PWD LPSA Description 1", "PWD LPSA Description 1");
                RecItem2.SetRange("PWD LPSA Description 1", "PWD LPSA Description 1");
                RecItem2.SetRange("Last Date Modified", "Last Date Modified");
                if RecItem2.FindFirst then begin
                    repeat
                        RecGProdBOMLine.SetRange("No.", RecItem2."No.");
                        RecGProdBOMLine.ModifyAll("No.", "No.");
                    until RecItem2.Next = 0;
                    RecItem2.DeleteAll(true);
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

    var
        RecItem2: Record Item;
        RecGProdBOMLine: Record "Production BOM Line";
}

