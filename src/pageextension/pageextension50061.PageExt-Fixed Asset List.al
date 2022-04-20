pageextension 50061 pageextension50061 extends "Fixed Asset List"
{
    layout
    {
        addafter("Control 4")
        {
            field("Description 2"; "Description 2")
            {
                ApplicationArea = All;
            }
        }
        addafter("Control 8")
        {
            field("Global Dimension 1 Code"; "Global Dimension 1 Code")
            {
                ApplicationArea = All;
            }
        }
    }
}

