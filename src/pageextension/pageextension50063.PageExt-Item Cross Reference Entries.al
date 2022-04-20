pageextension 50063 pageextension50063 extends "Item Cross Reference Entries"
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
        addafter("Control 13")
        {
            field("Customer Name"; "Customer Name")
            {
                ApplicationArea = All;
            }
        }
        addafter("Control 6")
        {
            field("Item No."; "Item No.")
            {
                ApplicationArea = All;
            }
            field("Item Search Description"; "Item Search Description")
            {
                ApplicationArea = All;
            }
            field("Customer Plan No."; "Customer Plan No.")
            {
                ApplicationArea = All;
            }
            field("Customer Plan Description"; "Customer Plan Description")
            {
                ApplicationArea = All;
            }
        }
    }
}

