tableextension 60025 "PWD SalesReceivablesSetup" extends "Sales & Receivables Setup"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.00
    // FED-LAPIERRETTE-VTE-02-Documents Vente-V5.001: TUN 26/12/2011:  Documents vente
    //                                                                 - Add field 50000 PDFDirectory
    // 
    // ------------------------------------------------------------------------------------------------------------------
    fields
    {
        field(50000; "PWD PDFDirectory"; Text[250])
        {
            Caption = 'PDF Directory';
            Description = 'LAP2.00';
        }
    }
}

