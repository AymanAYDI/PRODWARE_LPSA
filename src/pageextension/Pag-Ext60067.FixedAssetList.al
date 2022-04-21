pageextension 60067 "PWD FixedAssetList" extends "Fixed Asset List"
{
    layout
    {
        addafter(Description)
        {
            field("PWD Description 2"; "Description 2")
            {
                ApplicationArea = All;
            }
        }
        addafter("Search Description")
        {
            field("PWD Global Dimension 1 Code"; "Global Dimension 1 Code")
            {
                ApplicationArea = All;
            }
        }
    }
}

