page 50010 "PWD Lot Size List"
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

    Caption = 'Lot Size List';
    PageType = List;
    SourceTable = "Lot Size";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item Category Code"; "Item Category Code")
                {
                }
                field("Lot Size"; "Lot Size")
                {
                }
                field("Minimum Lot Qty."; "Minimum Lot Qty.")
                {
                }
                field("Maximum Lot Qty."; "Maximum Lot Qty.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

