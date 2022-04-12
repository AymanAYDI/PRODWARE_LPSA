report 50105 "PWD Reblock Items"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Item to block"; "PWD Item to block")
        {

            trigger OnAfterGetRecord()
            var
                RecLItem: Record Item;
            begin
                if RecLItem.Get("No.") then begin
                    RecLItem.Blocked := "Item to block".Blocked;
                    RecLItem."Sale blocked" := "Item to block"."Sale blocked";
                    RecLItem."Purchase blocked" := "Item to block"."Purchase blocked";
                    RecLItem.Modify;
                end;
            end;

            trigger OnPostDataItem()
            begin
                DeleteAll;
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

