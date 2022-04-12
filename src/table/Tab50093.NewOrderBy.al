table 50093 "PWD New Order By"
{

    fields
    {
        field(10; "Item No."; Code[20])
        {
            TableRelation = Item;
        }
        field(20; "Quantity Comp. Init"; Decimal)
        {
        }
        field(30; "Quantity Comp. New"; Decimal)
        {
        }
        field(31; "Qty Order By Init"; Decimal)
        {
        }
        field(32; "Qty Order By New"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Item No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

