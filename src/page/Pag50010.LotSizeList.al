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
    SourceTable = "PWD Lot Size";
    UsageCategory = none;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                }
                field("Lot Size"; Rec."Lot Size")
                {
                    ApplicationArea = All;
                }
                field("Minimum Lot Qty."; Rec."Minimum Lot Qty.")
                {
                    ApplicationArea = All;
                }
                field("Maximum Lot Qty."; Rec."Maximum Lot Qty.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

