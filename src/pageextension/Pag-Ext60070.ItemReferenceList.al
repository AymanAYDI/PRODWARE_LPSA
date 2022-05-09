pageextension 60070 "PWD ItemReferenceList" extends "Item Reference List"
{
    layout
    {
        addafter(Description)
        {
            field("PWD Customer Plan Description"; Rec."PWD Customer Plan Description")
            {
                ApplicationArea = All;
            }
            field("PWD Customer Plan No."; Rec."PWD Customer Plan No.")
            {
                ApplicationArea = All;
            }
        }
    }
}

