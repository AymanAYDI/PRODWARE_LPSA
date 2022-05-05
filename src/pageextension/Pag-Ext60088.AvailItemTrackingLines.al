pageextension 60088 "PWD AvailItemTrackingLines" extends "Avail. - Item Tracking Lines"
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
        addafter("Lot No.")
        {
            field("PWD NC"; Rec."PWD NC")
            {
                ApplicationArea = All;
            }
        }
    }
}

