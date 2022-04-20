pageextension 60044 "PWD PurchasesPayablesSetup" extends "Purchases & Payables Setup"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 07/09/2017 : DEMANDES DIVERSES
    //                     Add Fields Subcontracting Order Series No
    //                                Subcontracting Legal Text
    layout
    {
        addafter(Archiving)
        {
            group("PWD Sous-Traitance")
            {
                Caption = 'Sous-Traitance';
                field("PWD Subcontracting Order Series No"; "PWD Subcontracting Order Series No")
                {
                    ApplicationArea = All;
                }
                field("PWD Subcontracting Legal Text"; "PWD Subcontracting Legal Text")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}

