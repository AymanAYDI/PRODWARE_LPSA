pageextension 60108 "PWD MyItems" extends "My Items"
{
    layout
    {
        addafter(Inventory)
        {
            field("PWD Search Description"; Item."Search Description")
            {
                Caption = 'Désignation rech';
                ApplicationArea = All;
            }
        }
    }
    VAR
        Item: Record Item;
}

