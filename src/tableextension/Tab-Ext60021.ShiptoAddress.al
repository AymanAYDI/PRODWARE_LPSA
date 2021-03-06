tableextension 60021 "PWD ShiptoAddress" extends "Ship-to Address"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.5
    // WMS-FE06.001:GR 01/07/2011   Connector integration
    //                              - Add field "WMS_ShipToNo"
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    //     PLAW1 -----------------------------------------------------------------------------
    // PLAW1-5.0              PO-3447: Customer geolocalisation
    // PLAW1 -----------------------------------------------------------------------------
    fields
    {
        field(8073282; "PWD WMS_ShipToNo"; Code[30])
        {
            Caption = 'WMS_ShipToNo';
            DataClassification = CustomerContent;
        }
    }
}

