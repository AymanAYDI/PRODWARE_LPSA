pageextension 50036 "PWD WorkCenterTaskList" extends "Work Center Task List"
{
    layout
    {
        addafter("Unit Cost per")
        {
            field("PWD No."; Rec."No.")
            {
                ApplicationArea = All;
            }
            field("PWD Work Center No."; Rec."Work Center No.")
            {
                ApplicationArea = All;
            }
        }
    }
}

