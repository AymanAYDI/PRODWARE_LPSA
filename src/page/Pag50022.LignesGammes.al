page 50022 "PWD Lignes Gammes"
{
    Editable = false;
    PageType = List;
    SourceTable = "Routing Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Routing No."; Rec."Routing No.")
                {
                    ApplicationArea = All;
                }
                field("Operation No."; Rec."Operation No.")
                {
                    ApplicationArea = All;
                }
                field("Next Operation No."; Rec."Next Operation No.")
                {
                    ApplicationArea = All;
                }
                field("Previous Operation No."; Rec."Previous Operation No.")
                {
                    ApplicationArea = All;
                }
                field(Type; Type)
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Work Center No."; Rec."Work Center No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
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
                field("Wait Time"; Rec."Wait Time")
                {
                    ApplicationArea = All;
                }
                field("Move Time"; Rec."Move Time")
                {
                    ApplicationArea = All;
                }
                field("Lot Size"; Rec."Lot Size")
                {
                    ApplicationArea = All;
                }
                field("Routing Link Code"; Rec."Routing Link Code")
                {
                    ApplicationArea = All;
                }
                field("Unit Cost per"; Rec."Unit Cost per")
                {
                    ApplicationArea = All;
                }
                field("Scrap Factor %"; Rec."Scrap Factor %")
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

