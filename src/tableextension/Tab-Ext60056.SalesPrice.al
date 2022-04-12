tableextension 60056 "PWD SalesPrice" extends "Sales Price"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_VTE03.001: NI 23/11/2011:  Prix de vente forfaitaire
    //                                           - Add field 50000
    // 
    // 
    // TDL.LPSA.09.02.2015: ONSITE 09/02/2015: Modification
    //                                           - Add Item Search Description
    // 
    // ------------------------------------------------------------------------------------------------------------------
    fields
    {
        field(50000; "PWD Fixed Price"; Boolean)
        {
            Caption = 'Fixed Price';
            Description = 'LAP1.00';
        }
        field(50001; "PWD Search Description"; Code[100])
        {
            CalcFormula = Lookup(Item."Search Description" WHERE("No." = FIELD("Item No.")));
            Caption = 'Search Description';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}

