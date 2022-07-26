tableextension 60030 "PWD EntrySummary" extends "Entry Summary"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.05
    // FE_LAPIERRETTE_PRO12.001: GR 09/10/2012: Non Conformite
    //                                          - Add Field
    //                                            NC
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    fields
    {
        field(50000; "PWD NC"; Boolean)
        {
            caption = 'NC';
            Description = 'LAP2.05';
            Editable = false;
            DataClassification = CustomerContent;
        }
    }
}

