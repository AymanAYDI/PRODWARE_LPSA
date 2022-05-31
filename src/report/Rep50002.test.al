report 50002 "PWD test"
{
    ProcessingOnly = true;
    UseRequestPage = false;
    UsageCategory = None;
    Caption = 'Test';

    dataset
    {
        dataitem("Tracking Specification"; "Tracking Specification")
        {
            DataItemTableView = SORTING("Lot No.", "Serial No.") ORDER(Ascending) WHERE("Lot No." = CONST('CFST-13-1899'));

            trigger OnAfterGetRecord()
            begin
                "Tracking Specification"."Quantity (Base)" := 9960;
                "Tracking Specification"."Quantity Handled (Base)" := 9960;
                "Tracking Specification"."Qty. to Invoice (Base)" := 9960;
                "Tracking Specification"."Qty. to Invoice" := 9960;
                "Tracking Specification".Modify();
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

