tableextension 60014 "PWD SalesInvoiceHeader" extends "Sales Invoice Header"
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
    // //>>LAP1.00
    // FE_LAPIERRETTE_VTE01.001: TO 07/12/2011:  Export Role
    //                                           - Add field 50002 "Rolex Bienne"
    // 
    // TDL.LPSA.20.04.15:APA 20/04/15: Add Field Cust Promised Delivery Date
    // ----------------------------------------------------------------------------------------------------
    fields
    {
        field(50002; "PWD Rolex Bienne"; Boolean)
        {
            Caption = 'Rolex Bienne';
            Description = 'LAP1.00';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50003; "PWD Cust Promised Deliv. Date"; Date)
        {
            Caption = 'Customer Promised Delivery Date';
            Description = 'TDL.LPSA';
            DataClassification = CustomerContent;
        }
        field(8073282; "PWD Order No. From Partner"; Code[20])
        {
            Caption = 'Order No. From Partner';
            DataClassification = CustomerContent;
        }
        field(8073283; "PWD WMS_Status"; Enum "PWD WMS_Status")
        {
            Caption = 'WMS_Status';
            Description = 'ProdConnect1.5';
            DataClassification = CustomerContent;
        }
    }
}

