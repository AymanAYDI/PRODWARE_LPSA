tableextension 60032 "PWD SalesHeaderArchive" extends "Sales Header Archive"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
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
    // FE_LAPIERRETTE_VTE06.001: NI 23/11/2011:  Statut Commande vente
    //                                           - Add field 50000..50001
    // 
    // TDL.LPSA.05.10.15:NBO 05/10/15: Add Field 50005
    // ------------------------------------------------------------------------------------------------------------------
    fields
    {
        field(50000; "PWD Confirmed"; Boolean)
        {
            Caption = 'Confirmed';
            Description = 'LAP1.00';
            Editable = false;
        }
        field(50001; "PWD Planned"; Boolean)
        {
            Caption = 'Planned';
            Description = 'LAP1.00';
            Editable = false;
        }
        field(50005; "PWD Validity Quote Date"; Date)
        {
            Caption = 'Validity Quote Date';
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

