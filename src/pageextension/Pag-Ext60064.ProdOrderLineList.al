pageextension 60064 "PWD ProdOrderLineList" extends "Prod. Order Line List"
{
    //TODO: SourceTableView
    //SourceTableView=SORTING("Prod. Order No.","Line No.",Status) ORDER(Ascending);

    layout
    {
        addafter("Cost Amount")
        {
            field("PWD Manufacturing Code"; Rec."PWD Manufacturing Code")
            {
                ApplicationArea = All;
            }
        }
    }
}

