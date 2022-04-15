tableextension 60024 "PWD VATAmountLine" extends "VAT Amount Line"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FED-LAPIERRETTE-VTE-02-Documents Vente-V5: TUN 22/12/2011: Documents vente
    //                                                             - Add function VATAmountText2
    // 
    // ------------------------------------------------------------------------------------------------------------------
    procedure VATAmountText2(): Text[50]

    var
        CstG001: Label '%1% VAT for %2';
    begin
        //>>FED-LAPIERRETTE-VTE-02-Documents Vente-V5
        if Find('-') then
            if Next() = 0 then
                exit(StrSubstNo(CstG001, "VAT %", "VAT Base"));
        exit('');
        //<<FED-LAPIERRETTE-VTE-02-Documents Vente-V5
    end;


}

