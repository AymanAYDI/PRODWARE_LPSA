pageextension 60117 "PWD PurchaseOrderArchives" extends "Purchase Order Archives"
{
    layout
    {
        addfirst(Control1)
        {
            field("PWD No."; "No.")
            {
                ApplicationArea = All;
            }
        }
    }
}

