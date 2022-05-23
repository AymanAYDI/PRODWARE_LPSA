page 50024 "PWD Capacity ledger entry list"
{
    Editable = false;
    PageType = List;
    ApplicationArea = all;
    UsageCategory = History;
    SourceTable = "Capacity Ledger Entry";
    caption = 'Capacity ledger entry list';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Operation No."; Rec."Operation No.")
                {
                    ApplicationArea = All;
                }
                field("Work Center No."; Rec."Work Center No.")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Setup Time"; Rec."Setup Time")
                {
                    ApplicationArea = All;
                }
                field("Run Time"; Rec."Run Time")
                {
                    ApplicationArea = All;
                }
                field("Invoiced Quantity"; Rec."Invoiced Quantity")
                {
                    ApplicationArea = All;
                }
                field("Output Quantity"; Rec."Output Quantity")
                {
                    ApplicationArea = All;
                }
                field("Prod. Order No."; Rec."Order No.")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Direct Cost"; Rec."Direct Cost")
                {
                    ApplicationArea = All;
                }
                field(Subcontracting; Rec.Subcontracting)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

