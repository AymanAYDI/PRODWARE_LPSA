tableextension 60057 "PWD WarehouseEntry" extends "Warehouse Entry"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
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
            Description = 'LAP2.05';
            Editable = false;
            caption = 'NC';
        }
    }
}

