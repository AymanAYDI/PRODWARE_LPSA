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
            field("PWD Routing No."; Rec."Routing No.")
            {
                ApplicationArea = All;
            }
            field("PWD Version Code"; Rec."Version Code")
            {
                ApplicationArea = All;
            }
            field("PWD Operation No."; Rec."Operation No.")
            {
                ApplicationArea = All;
            }
            field("PWD Type"; Rec."PWD Type")
            {
                ApplicationArea = All;
            }
        }
        addafter(Description)
        {
            field("PWD Criteria"; Rec."PWD Criteria")
            {
                ApplicationArea = All;
            }
        }
    }
}

