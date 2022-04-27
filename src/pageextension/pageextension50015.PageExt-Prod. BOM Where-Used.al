pageextension 50015 pageextension50015 extends "Prod. BOM Where-Used"
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
        addafter("Control 8")
        {
            field("Désignation de recherche"; RecGItem."Search Description")
            {
                Caption = 'Désignation de recherche';
                ApplicationArea = All;
            }
        }
    }

    var
        RecGItem: Record "27";


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    DescriptionIndent := 0;
    DescriptionOnFormat;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    DescriptionIndent := 0;
    DescriptionOnFormat;

    //>>TDL.LPSA.05.10.2015
    IF NOT RecGItem.GET("Item No.") THEN
      RecGItem.INIT;
    //<<TDL.LPSA.05.10.2015
    */
    //end;
}

