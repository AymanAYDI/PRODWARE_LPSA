pageextension 60144 "PWD ProdOrderRoutingTools" extends "Prod. Order Routing Tools"
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
        addbefore("No.")
        {
            field("PWD Routing No."; Rec."Routing No.")
            {
                ApplicationArea = All;
            }
            field("PWD Operation No."; Rec."Operation No.")
            {
                ApplicationArea = All;
            }
        }
        addafter(Description)
        {
            field("PWD Type"; Rec."PWD Type")
            {
                ApplicationArea = All;
            }
            field("PWD Criteria"; Rec."PWD Criteria")
            {
                ApplicationArea = All;
            }
        }
    }
}

