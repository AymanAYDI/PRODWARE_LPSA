pageextension 60104 "PWD BinContents" extends "Bin Contents"
{
    layout
    {
        addafter("Item No.")
        {
            field("PWD LPSA Description 1"; Item."PWD LPSA Description 1")
            {
                Caption = 'Désignation LPSA 1';
                Editable = false;
                ApplicationArea = All;
            }
            field("PWD LPSA Description 2"; Item."PWD LPSA Description 2")
            {
                Caption = 'Désignation LPSA 2';
                Editable = false;
                ApplicationArea = All;
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        //>>LAP2.08
        IF NOT Item.GET("Item No.") THEN
            Item.INIT();
        //<<LAP2.08
    end;

    var
        Item: Record Item;
}

