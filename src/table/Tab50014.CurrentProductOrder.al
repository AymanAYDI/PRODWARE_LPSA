table 50014 "PWD Current Product Order"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.13
    //  RO : 07/11/2017 : Nouvelles demandes
    //                   - new Table

    Caption = 'Current Product Order';
    DataClassification = CustomerContent;

    fields
    {
        field(1; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Simulated,Planned,Firm Planned,Released,Finished';
            OptionMembers = Simulated,Planned,"Firm Planned",Released,Finished;
            DataClassification = CustomerContent;
        }
        field(2; "PO No."; Code[20])
        {
            Caption = 'PO No.';
            DataClassification = CustomerContent;
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
        }
        field(4; "Last Ended Operation"; Code[20])
        {
            Caption = 'Center No. last ended operation';
            DataClassification = CustomerContent;
        }
        field(5; "Center Description"; Text[50])
        {
            Caption = 'Center Description';
            DataClassification = CustomerContent;
        }
        field(6; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
        }
        field(7; "Description LPSA1"; Text[120])
        {
            Caption = 'Description LPSA1';
            DataClassification = CustomerContent;
        }
        field(8; "Description LPSA2"; Text[120])
        {
            Caption = 'Description LPSA2';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; Status, "PO No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

