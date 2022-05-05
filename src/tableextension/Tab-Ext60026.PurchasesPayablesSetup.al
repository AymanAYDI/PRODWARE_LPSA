tableextension 60026 "PWD PurchasesPayablesSetup" extends "Purchases & Payables Setup"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 07/09/2017 : DEMANDES DIVERSES
    //                     Add Fields 50000 - Subcontracting Order Series No - Code10
    //                                50001 - Subcontracting Legal Text - Text250
    fields
    {
        field(50000; "PWD Subcontra. Order Series No"; Code[20])
        {
            Caption = 'Subcontracting Order Series No';
            Description = 'LAP2.12';
            TableRelation = "No. Series";
        }
        field(50001; "PWD Subcontracting Legal Text"; Text[250])
        {
            Caption = 'Subcontracting Legal Text';
            Description = 'LAP2.12';
        }
    }
}

