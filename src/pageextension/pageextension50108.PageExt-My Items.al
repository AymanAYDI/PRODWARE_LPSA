pageextension 50108 pageextension50108 extends "My Items"
{
    layout
    {
        addafter(Inventory)
        {
            field(Item."Search Description";
                Item."Search Description")
            {
                Caption = 'Désignation rech';
                ApplicationArea = All;
            }
        }
    }
}

