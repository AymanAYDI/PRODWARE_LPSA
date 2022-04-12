tableextension 60050 "PWD InventoryCommentLine" extends "Inventory Comment Line"
{
    fields
    {
        field(50000; "PWD Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            Description = 'TDL.235';
        }
    }
    keys
    {

        //TODO        // key(Key1; "Document Type", "No.", "Document Line No.", "Line No.")
        // {
        //     Clustered = true;
        // }
    }
}

