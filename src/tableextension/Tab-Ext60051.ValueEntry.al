tableextension 60051 "PWD ValueEntry" extends "Value Entry"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>NDBI
    // P27818_006 : LALE.PA : 05/07/2021 : Cf. demande mail client du 21/06/2021
    //                   - Add Key Item No.,Posting Date,Item Ledger Entry Type,Source Type,Source No.
    keys  //TODO: il faut ajouter la propriete SumIndexFields=Invoiced Quantity; pour le key principale (Key1)
    {

        key(Key50000; "Item No.", "Posting Date", "Item Ledger Entry Type", "Source Type", "Source No.")
        {
            SumIndexFields = "Invoiced Quantity", "Sales Amount (Actual)";
        }
    }
}

