pageextension 50083 pageextension50083 extends "Avail. - Item Tracking Lines"
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
        addafter("Control 32")
        {
            field(NC; NC)
            {
                ApplicationArea = All;
            }
        }
    }
}

