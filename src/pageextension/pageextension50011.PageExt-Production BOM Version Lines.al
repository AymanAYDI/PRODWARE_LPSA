pageextension 50011 pageextension50011 extends "Production BOM Version Lines"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // //>>LAP1.00
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_PROD01.001: TO 13/12/2011:  No Commande vente identique OF-LOT
    //                                           - Add field "Lot Determining"
    // 
    // ------------------------------------------------------------------------------------------------------------------
    layout
    {
        addafter("Control 6")
        {
            field("Lot Determining"; "Lot Determining")
            {
                ApplicationArea = All;
            }
        }
    }

    //Unsupported feature: Deletion (VariableCollection) on "ShowWhereUsed(PROCEDURE 2).ProdBOMWhereUsed(Variable 1003)".

}

