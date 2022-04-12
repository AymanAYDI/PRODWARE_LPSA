report 99999 "PWD Delete blank item"
{
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem("Integer"; "Integer")
        {

            trigger OnAfterGetRecord()
            begin
                if RecGItem.Get('') then
                    RecGItem.Delete(false);
            end;

            trigger OnPreDataItem()
            begin
                Integer.SetRange(Number, 1);
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
}

