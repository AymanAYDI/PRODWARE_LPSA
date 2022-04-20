pageextension 50100 pageextension50100 extends "Item Bin Contents"
{
    layout
    {
        addafter("Control 6")
        {
            field(RecGItem."LPSA Description 1";
                RecGItem."LPSA Description 1")
            {
                Caption = 'Désignation LPSA 1';
                Editable = false;
                ApplicationArea = All;
            }
            field(RecGItem."LPSA Description 2";
                RecGItem."LPSA Description 2")
            {
                Caption = 'Désignation LPSA 2';
                Editable = false;
                ApplicationArea = All;
            }
            field(RecGItem."Search Description";
                RecGItem."Search Description")
            {
                Caption = 'Désignation de recherche';
                ApplicationArea = All;
            }
        }
    }

    var
        RecGItem: Record "27";


    //Unsupported feature: Code Insertion on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //begin
    /*
    //>>LAP2.08
    IF NOT RecGItem.GET("Item No.") THEN
      RecGItem.INIT;
    //<<LAP2.08
    */
    //end;
}

