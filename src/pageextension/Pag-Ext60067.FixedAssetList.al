pageextension 60067 "PWD FixedAssetList" extends "Fixed Asset List"
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
        addafter("Search Description")
        {
            field("PWD Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = All;
            }
        }
    }
}

