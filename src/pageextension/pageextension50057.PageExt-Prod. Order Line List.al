pageextension 50057 pageextension50057 extends "Prod. Order Line List"
{

    //Unsupported feature: Property Insertion (SourceTableView) on ""Prod. Order Line List"(Page 5406)".

    layout
    {
        addafter("Control 40")
        {
            field("Manufacturing Code"; "Manufacturing Code")
            {
                ApplicationArea = All;
            }
        }
    }
}

