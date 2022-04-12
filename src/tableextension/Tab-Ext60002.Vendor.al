tableextension 60002 "PWD Vendor" extends Vendor
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_ACH03.001: NI 22/11/2011:  Montant Minimun de commande
    //                                           - Add field 50000
    //                                           - Add code in trigger Order Min. Amount - OnValidate()
    // ------------------------------------------------------------------------------------------------------------------

    fields
    {
        field(50000; "PWD Order Min. Amount"; Decimal)
        {
            Caption = 'Order Min. Amount';
            Description = 'LAP1.00';

            trigger OnValidate()
            var
                RecLPurchaseHeader: Record "Purchase Header";
                CstL0001: Label 'There are Purchase order for Vendor %1, do you want to update %2 in these pruchases ?';
                RecLPurchaseLine: Record "Purchase Line";
            begin
                //>>FE_LAPIERRETTE_ACH03.001
                RecLPurchaseHeader.RESET;
                RecLPurchaseHeader.SETRANGE("Document Type", RecLPurchaseHeader."Document Type"::Order);
                RecLPurchaseHeader.SETRANGE("Buy-from Vendor No.", "No.");
                IF NOT RecLPurchaseHeader.ISEMPTY THEN BEGIN
                    IF CONFIRM(STRSUBSTNO(CstL0001, "No.", "PWD Order Min. Amount")) THEN
                        RecLPurchaseHeader.MODIFYALL(RecLPurchaseHeader."PWD Order Min. Amount", "PWD Order Min. Amount");
                END;
                //<<FE_LAPIERRETTE_ACH03.001
            end;
        }
    }
}

