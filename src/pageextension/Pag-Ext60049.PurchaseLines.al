pageextension 60049 "PWD PurchaseLines" extends "Purchase Lines"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.12
    // 
    // P19646_010 : RO : 23/05/2017 : cf. Mail LPSA Modif page 518 du lun. 22/05/2017 15:42
    //               Add Fields Requested Receipt Date
    //                          Promised Receipt Date
    //                          Order Date
    layout
    {
        addafter("Amt. Rcd. Not Invoiced (LCY)")
        {
            field("PWD Requested Receipt Date"; "Requested Receipt Date")
            {
                ApplicationArea = All;
            }
            field("PWD Promised Receipt Date"; "Promised Receipt Date")
            {
                ApplicationArea = All;
            }
            field("PWD Order Date"; "Order Date")
            {
                ApplicationArea = All;
            }
        }
    }
}

