pageextension 60069 "PWD ItemCrossReferenceEntries" extends "Item Cross Reference Entries"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LPSA.TDL
    // LPSA.TDL.09/02/2015 : Add Field 50000, 50001
    // 
    // //>>LAP2.16
    // P24578_004 : RO : 27/03/2018 : DEMANDES DIVERSES
    //                   - Add Field Item Search Description
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    layout
    {
        addafter("Cross-Reference Type No.")
        {
            field("PWD Customer Name"; Rec."PWD Customer Name")
            {
                ApplicationArea = All;
            }
        }
        addafter("Discontinue Bar Code")
        {
            field("PWD Item No."; Rec."Item No.")
            {
                ApplicationArea = All;
            }
            field("PWD Item Search Description"; Rec."PWD Item Search Description")
            {
                ApplicationArea = All;
            }
            field("PWD Customer Plan No."; Rec."PWD Customer Plan No.")
            {
                ApplicationArea = All;
            }
            field("PWD Customer Plan Description"; Rec."PWD Customer Plan Description")
            {
                ApplicationArea = All;
            }
        }
    }
}

