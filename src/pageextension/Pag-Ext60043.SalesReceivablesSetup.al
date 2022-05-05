pageextension 60043 "PWD SalesReceivablesSetup" extends "Sales & Receivables Setup"
{
    // #1..58
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>NDBI
    // P27818_001 LALE.PA: 31/01/2022  : ND Suite TI513220 (remise en place DEV mis de côté)
    //                          - Add Field "Barcode Invoice Nos." in Group Numérotation
    // 
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    layout
    {

        //Unsupported feature: Property Insertion (GroupType) on "Control 1900309501".

        addafter("Apply Inv. Round. Amt. To VAT")
        {
            field("PWD PDFDirectory"; Rec."PWD PDFDirectory")
            {
                ApplicationArea = All;
            }
        }
        //TODO: a vérifier le champ "Barcode Invoice Nos."
        // addafter("Control 67")
        // {
        //     field("PWD Barcode Invoice Nos."; "Barcode Invoice Nos.")
        //     {
        //         ApplicationArea = All;
        //     }
        // }
    }
}

