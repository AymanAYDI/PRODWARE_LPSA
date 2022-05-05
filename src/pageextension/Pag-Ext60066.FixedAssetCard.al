pageextension 60066 "PWD FixedAssetCard" extends "Fixed Asset Card"
{
    layout
    {
        addafter(Description)
        {
            field("PWD Description 2"; Rec."Description 2")
            {
                ApplicationArea = All;
            }
        }
    }
}

