tableextension 60029 "PWD ReservationEntry" extends "Reservation Entry"
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
        field(50003; "PWD NC"; Boolean)
        {
            Description = 'LAP2.05';
            Editable = false;
        }
    }
    keys
    {
        key(Key50000; "Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name", "Source Prod. Order Line", "Reservation Status")
        {
            SumIndexFields = Quantity;
        }
    }
}

