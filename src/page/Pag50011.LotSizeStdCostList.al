page 50011 "PWD Lot Size Std. Cost List"
{
    // +----------------------------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                                         |
    // | www.prodware.fr                                                                                                                  |
    // +----------------------------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.01
    // FE_LAPIERRETTE_PRO08.001: GR 15/02/2012: Multiple Standard Cost Calculate
    //                                          Creation
    // 
    // +----------------------------------------------------------------------------------------------------------------------------------+

    Caption = 'Lot Size Std. Cost List';
    PageType = List;
    SourceTable = "Lot Size Standard Cost";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; "Item No.")
                {
                }
                field("Item category code"; "Item category code")
                {
                }
                field("Lot Size"; "Lot Size")
                {
                }
                field("Standard Cost"; "Standard Cost")
                {
                }
            }
        }
    }

    actions
    {
    }
}

