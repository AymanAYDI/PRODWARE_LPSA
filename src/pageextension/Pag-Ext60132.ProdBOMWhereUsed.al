pageextension 60132 "PWD ProdBOMWhereUsed" extends "Prod. BOM Where-Used"
{
    // #1..7
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    //  TDL.LPSA.05.10.15:NBO 05/10/15: Change "Search Description" to get the where-used item search description
    layout
    {
        addafter(Description)
        {
            field("Désignation de recherche"; RecGItem."Search Description")
            {
                Caption = 'Désignation de recherche';
                ApplicationArea = All;
            }
        }
    }

    var
        RecGItem: Record Item;


}

