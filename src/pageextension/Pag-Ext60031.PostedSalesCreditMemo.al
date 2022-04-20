pageextension 60031 "PWD PostedSalesCreditMemo" extends "Posted Sales Credit Memo"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_VTE01.001: TO 07/12/2011:  Export Role
    //                                           - Displayd field 50002 "Rolex Bienne" on Tab [GENERAL]
    // 
    // 
    // 
    // ------------------------------------------------------------------------------------------------------------------
    layout
    {
        addafter("No. Printed")
        {
            field("PWD Rolex Bienne"; "PWD Rolex Bienne")
            {
                ApplicationArea = All;
            }
        }
        modify("Bill-to Contact")
        {
            Editable = true;
        }
    }
}

