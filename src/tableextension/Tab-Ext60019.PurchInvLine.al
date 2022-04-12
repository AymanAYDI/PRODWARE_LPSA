tableextension 60019 "PWD PurchInvLine" extends "Purch. Inv. Line"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.5
    // WMS-FE04.001:GR  01/07/2011   Connector integration
    //                              - Add fields:  "WMS_Status"
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // //>>LAP1.00
    // FE_LAPIERRETTE_ART02.001: NI 23/11/2011:  Désignation article 120 caracteres
    //                                           - Add field 50004..50005
    // ------------------------------------------------------------------------------------------------------------------
    fields
    {
        field(50004; "PWD LPSA Description 1"; Text[120])
        {
            Caption = 'LPSA Description 1';
            Description = 'LAP1.00';
        }
        field(50005; "PWD LPSA Description 2"; Text[120])
        {
            Caption = 'LPSA Description 2';
            Description = 'LAP1.00';
        }
        field(8073282; "PWD WMS_Status"; Option)
        {
            Caption = 'WMS_Status';
            Description = 'ProdConnect1.5';
            OptionCaption = ' ,Send,Received';
            OptionMembers = " ",Send,Received;
        }
    }
}

