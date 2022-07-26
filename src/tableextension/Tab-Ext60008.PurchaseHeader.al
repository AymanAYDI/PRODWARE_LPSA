tableextension 60008 "PWD PurchaseHeader" extends "Purchase Header"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_ACH03.001: NI 22/11/2011:  Montant Minimun de commande
    //                                           - Add field 50000
    //                                           - Add code in trigger Buy-from Vendor No. - OnValidate()
    // 
    // TDL.LPSA.09.02.2015: ONSITE 09/02/2015: Modification
    //                                           - Remove status control on date modifications
    // 
    // TDL.LPSA.20.04.15:APA 20/04/15: - Add Field 50001
    // 
    // //>>TDL.172
    // TDL.LPSA.172:CSC 04/12/15 : Add field "Last Release Amount"
    // 
    // //>>TDL.231
    // TDL.LPSA.231:CSC 14/06/16 : Add field "Intranet Order No."
    // 
    // ------------------------------------------------------------------------------------------------------------------
    fields
    {
        field(50000; "PWD Order Min. Amount"; Decimal)
        {
            Caption = 'Order Min. Amount';
            Description = 'LAP1.00';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50001; "PWD Printed"; Boolean)
        {
            Caption = 'Printed';
            DataClassification = CustomerContent;
        }
        field(50002; "PWD Last Release Amount"; Decimal)
        {
            Caption = 'Last Release Amount';
            Description = 'TDL.172';
            DataClassification = CustomerContent;
        }
        field(50003; "PWD Intranet Order No."; Code[20])
        {
            Caption = 'Intranet Order No.';
            Description = 'TDL.231';
            DataClassification = CustomerContent;
        }
    }
}

