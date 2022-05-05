report 8073283 "Prod. Order Line update field"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.6
    // OSYS-Int001.001:GR 18/10/2011   Connector integration
    //                                   - Create Object
    // +----------------------------------------------------------------------------------------------------------------+

    Caption = 'Prod. Order Line update field (Osys)';
    ProcessingOnly = true;
    UsageCategory = none;
    dataset
    {
        dataitem("Prod. Order Line"; "Prod. Order Line")
        {
            DataItemTableView = SORTING(Status, "Prod. Order No.", "Line No.") WHERE(Status = CONST(Released));
            RequestFilterFields = "Prod. Order No.", "Line No.";

            trigger OnAfterGetRecord()
            begin
                "Send to OSYS (Released)" := false;
                Modify();
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }
}

