pageextension 50097 pageextension50097 extends "Warehouse Entries"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.05
    // FE_LAPIERRETTE_PRO12.001: GR 09/10/2012: Non Conformite
    //                                          - Add Field
    //                                            NC
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    layout
    {
        addafter("Control 58")
        {
            field(NC; NC)
            {
                ApplicationArea = All;
            }
        }
    }
}

