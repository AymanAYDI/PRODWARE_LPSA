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
    SourceTable = "PWD Lot Size Standard Cost";
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Item category code"; Rec."Item category code")
                {
                    ApplicationArea = All;
                }
                field("Lot Size"; Rec."Lot Size")
                {
                    ApplicationArea = All;
                }
                field("Standard Cost"; Rec."Standard Cost")
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

