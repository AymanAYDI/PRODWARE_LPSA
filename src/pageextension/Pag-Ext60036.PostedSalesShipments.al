pageextension 60036 "PWD PostedSalesShipments" extends "Posted Sales Shipments"
{
    layout
    {
        addafter("Shipping Agent Code")
        {
            field("PWD Order No."; Rec."Order No.")
            {
                ApplicationArea = All;
            }
            field("PWD External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
            }
        }
    }
}

