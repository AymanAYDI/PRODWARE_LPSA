report 50100 "PWD Unblock Items"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {

            trigger OnAfterGetRecord()
            var
                RecLItemBlocked: Record "Item to block";
            begin
                if Blocked or "Sale blocked" or "Purchase blocked" then begin
                    RecLItemBlocked.TransferFields(Item);
                    RecLItemBlocked.Insert;
                    Blocked := false;
                    "Sale blocked" := false;
                    "Purchase blocked" := false;
                    Modify;
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

