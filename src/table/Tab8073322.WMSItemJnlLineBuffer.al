table 8073322 "PWD WMS Item Jnl Line Buffer"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.50
    // WMS-FE009.001:GR  05/07/2011   Connector management
    //                                   - Create Object
    // +----------------------------------------------------------------------------------------------------------------+

    Caption = 'WMS Item Journal Line Buffer';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(2; "WMS Company Code"; Text[30])
        {
            Caption = 'WMS Company Code';
            FieldClass = Normal;
            Numeric = true;
            DataClassification = CustomerContent;
        }
        field(20; "WMS Reson Code"; Text[10])
        {
            Caption = 'WMS Reson Code';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

