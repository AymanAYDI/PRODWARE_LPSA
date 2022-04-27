pageextension 50028 pageextension50028 extends "Prod. Order Routing Tools"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 12/07/2017 : FICHE SUIVEUSE - PP 1
    //                   - Add Fields Type
    //                                Criteria
    //                                "Routing No."
    //                                "Operation No."
    layout
    {
        addfirst("Control 1")
        {
            field("Routing No."; "Routing No.")
            {
                ApplicationArea = All;
            }
            field("Operation No."; "Operation No.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Control 6")
        {
            field(Type; Type)
            {
                ApplicationArea = All;
            }
            field(Criteria; Criteria)
            {
                ApplicationArea = All;
            }
        }
    }
}

