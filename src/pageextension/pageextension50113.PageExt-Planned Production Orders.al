pageextension 50113 pageextension50113 extends "Planned Production Orders"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 24/10/2017 : DEMANDES DIVERSES
    //                   - Add Field Source Material Vendor
    layout
    {
        addafter("Control 1102601002")
        {
            field("Source Material Vendor"; "Source Material Vendor")
            {
                ApplicationArea = All;
            }
        }
    }
}

