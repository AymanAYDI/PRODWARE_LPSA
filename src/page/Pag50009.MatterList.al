page 50009 "PWD Matter List"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_ART01.001: TO 07/12/2011:  Configurateur article
    //                                           - Create Page
    // 
    // ------------------------------------------------------------------------------------------------------------------

    PageType = List;
    SourceTable = Matter;

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

