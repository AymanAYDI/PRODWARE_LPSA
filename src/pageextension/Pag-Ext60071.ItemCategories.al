pageextension 60071 "PWD ItemCategories" extends "Item Categories"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_PROD01.001: TO 13/12/2011:  No Commande vente identique OF-LOT
    //                                           - Add field "Transmitted Order No."
    // 
    // 
    // ------------------------------------------------------------------------------------------------------------------
    layout
    {
        addlast(Control1)
        {
            field("PWD Transmitted Order No."; Rec."PWD Transmitted Order No.")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addlast(creation)
        {
            action("PWD Prod. Groups")
            {
                caption = '&Prod. Groups';
                ApplicationArea = All;
                RunObject = Page "PWD Product Groups";
                RunPageLink = "Item Category Code" = FIELD(Code);
                Promoted = true;
                PromotedCategory = Process;
            }
        }
    }
}

