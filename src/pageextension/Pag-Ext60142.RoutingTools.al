pageextension 60142 "PWD RoutingTools" extends "Routing Tools"
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
        addbefore("No.")
        {
            field("PWD Routing No."; "Routing No.")
            {
                ApplicationArea = All;
            }
            field("PWD Version Code"; "Version Code")
            {
                ApplicationArea = All;
            }
            field("PWD Operation No."; "Operation No.")
            {
                ApplicationArea = All;
            }
            field("PWD Type"; "PWD Type")
            {
                ApplicationArea = All;
            }
        }
        addafter(Description)
        {
            field("PWD Criteria"; "PWD Criteria")
            {
                ApplicationArea = All;
            }
        }
    }
}

