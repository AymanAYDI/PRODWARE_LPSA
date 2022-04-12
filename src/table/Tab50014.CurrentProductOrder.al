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

    fields
    {
        field(1; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Simulated,Planned,Firm Planned,Released,Finished';
            OptionMembers = Simulated,Planned,"Firm Planned",Released,Finished;
        }
        field(2; "PO No."; Code[20])
        {
            Caption = 'PO No.';
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(4; "Last Ended Operation"; Code[20])
        {
            Caption = 'Center No. last ended operation';
        }
        field(5; "Center Description"; Text[50])
        {
            Caption = 'Center Description';
        }
        field(6; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(7; "Description LPSA1"; Text[120])
        {
            Caption = 'Description LPSA1';
        }
        field(8; "Description LPSA2"; Text[120])
        {
            Caption = 'Description LPSA2';
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

