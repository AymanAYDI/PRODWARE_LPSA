pageextension 60039 "PWD ResCapacityEntries" extends "Res. Capacity Entries"
{
    Editable = true;
    //TODO:     InsertAllowed=No; DeleteAllowed=No;
    layout
    {
        modify(Date)
        {
            Editable = false;
        }
        modify("Resource No.")
        {
            Editable = false;
        }
        modify("Resource Group No.")
        {
            Editable = false;
        }
        modify(Capacity)
        {
            Editable = false;
        }
        modify("Entry No.")
        {
            Editable = false;
        }
    }


}
