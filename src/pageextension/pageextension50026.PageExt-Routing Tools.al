pageextension 50026 pageextension50026 extends "Routing Tools"
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
    //                                "Version Code"
    //                                "Operation No."
    //                   - Change Page Caption
    Caption = 'Routing Tools';
    layout
    {
        addfirst("Control 1")
        {
            field("Routing No."; "Routing No.")
            {
                ApplicationArea = All;
            }
            field("Version Code"; "Version Code")
            {
                ApplicationArea = All;
            }
            field("Operation No."; "Operation No.")
            {
                ApplicationArea = All;
            }
            field(Type; Type)
            {
                ApplicationArea = All;
            }
        }
        addafter("Control 6")
        {
            field(Criteria; Criteria)
            {
                ApplicationArea = All;
            }
        }
    }
}

