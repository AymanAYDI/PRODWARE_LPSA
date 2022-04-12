page 50000 "PWD Quartis Comment"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_PROD02.001: NI 28/11/2011:  Commentaire sur feuille production
    //                                           - Create Page
    // 
    // ------------------------------------------------------------------------------------------------------------------

    PageType = List;
    SourceTable = "PWD Quartis Comment";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Code)
                {
                }
                field(Description; Description)
                {
                }
            }
        }
    }

    actions
    {
    }
}

