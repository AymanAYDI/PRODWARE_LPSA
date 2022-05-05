pageextension 60105 "PWD ItemBinContents" extends "Item Bin Contents"
{
    layout
    {
        addafter("Bin Code")
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
            field("PWD Search Description"; Item."Search Description")
            {
                Caption = 'Désignation de recherche';
                ApplicationArea = All;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        //>>LAP2.08
        IF NOT Item.GET(Rec."Item No.") THEN
            Item.INIT();
        //<<LAP2.08
    end;

    var
        Item: Record Item;
}

