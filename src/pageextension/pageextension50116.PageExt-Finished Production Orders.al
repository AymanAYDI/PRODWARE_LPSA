pageextension 50116 pageextension50116 extends "Finished Production Orders"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 12/09/2017 : DEMANDES DIVERSES
    //                   - Add Field Source Material Vendor
    layout
    {
        addfirst("Control 1")
        {
            field("Source Material Vendor"; "Source Material Vendor")
            {
                ApplicationArea = All;
            }
        }
        addafter("Control 1102601002")
        {
            field("Consumption Date"; "Consumption Date")
            {
                ApplicationArea = All;
            }
        }
    }
}

