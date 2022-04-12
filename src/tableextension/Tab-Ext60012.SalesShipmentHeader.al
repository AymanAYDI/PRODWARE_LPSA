tableextension 60012 "PWD SalesShipmentHeader" extends "Sales Shipment Header"
{
    // ----------------------------------------------------------------------------------------------------
    //    Prodware - www.prodware.fr
    // ----------------------------------------------------------------------------------------------------
    // 
    // //>>ProdConnect.1.00
    // FE_ProdConnect.001:GR 22/03/2011  Connector integration
    //                                   - Add field 8073282 "Order No. From Partner"
    // 
    // //>>ProdConnect.1.5
    // WMS-FE05.001:GR 04/07/2001 :  Connector integration
    //                                   - Add Field 8073283 "WMS_Status"
    //                                   - Add Control on OnModify trigger
    // 
    // TDL.LPSA.20.04.15:APA 20/04/15: Add Field Cust Promised Delivery Date
    // ----------------------------------------------------------------------------------------------------
    fields
    {
        field(50003; "PWD Cust Promis Delivery Date"; Date)
        {
            Caption = 'Customer Promised Delivery Date';
            Description = 'TDL.LPSA';
        }
        field(8073282; "PWD Order No. From Partner"; Code[20])
        {
            Caption = 'Order No. From Partner';
        }
        field(8073283; "PWD WMS_Status"; Option)
        {
            Caption = 'WMS_Status';
            Description = 'ProdConnect1.5';
            OptionCaption = ' ,Send,Shipped';
            OptionMembers = " ",Send,Received;
        }
    }
}

