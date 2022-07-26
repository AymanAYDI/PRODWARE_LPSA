table 8073327 "PWD WMS Receipt Line Buffer"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.5
    // WMS-FE007_15.001:GR 05/07/2011 Receipt
    //                                - Create Object
    // +----------------------------------------------------------------------------------------------------------------+

    Caption = 'WMS Receipt Line Buffer';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(20; "Qty on receipt error (Base)"; Text[15])
        {
            Caption = 'Quantity on Receipt Error (Base)';
            DataClassification = CustomerContent;
        }
        field(21; "Reason Code Receipt Error"; Text[30])
        {
            Caption = 'Reason Code Receipt Error';
            DataClassification = CustomerContent;
        }
        field(22; "Posting Date"; Text[10])
        {
            Caption = 'Posting Date';
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

