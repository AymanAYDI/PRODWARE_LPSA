pageextension 60014 "PWD SalesCreditMemo" extends "Sales Credit Memo"
{
    layout
    {
        addafter("External Document No.")
        {
            field("PWD Your Reference"; "Your Reference")
            {
                ApplicationArea = All;
            }
        }
    }
}

