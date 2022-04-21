pageextension 60070 "PWD CrossReferenceList" extends "Cross Reference List"
{
    layout
    {
        addafter(Description)
        {
            field("PWD Customer Plan Description"; "PWD Customer Plan Description")
            {
                ApplicationArea = All;
            }
            field("PWD Customer Plan No."; "PWD Customer Plan No.")
            {
                ApplicationArea = All;
            }
        }
    }
}

