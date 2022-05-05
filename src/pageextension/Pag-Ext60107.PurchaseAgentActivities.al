pageextension 60107 "PWD PurchaseAgentActivities" extends "Purchase Agent Activities"
{
    layout
    {
        addafter(PartiallyInvoiced)
        {
            cuegroup("PWD Purchase Orders - Authorize for Payment")
            {
                Caption = 'Purchase Orders - Authorize for Payment';
                field("PWD To be approuved"; Rec."PWD To be approuved")
                {
                    DrillDownPageID = "Approval Request Entries";
                    ApplicationArea = All;
                }
            }
        }
    }
}

