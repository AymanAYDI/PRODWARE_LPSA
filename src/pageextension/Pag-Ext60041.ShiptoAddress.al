pageextension 60041 "PWD ShiptoAddress" extends "Ship-to Address"
{
    // PLAW1 -----------------------------------------------------------------------------
    // PLAW1-5.0   2014-11-07 PO-3447: Location (Latitude/Longitude)
    // PLAW1 -----------------------------------------------------------------------------
    layout
    {
        addafter(Name)
        {
            field("PWD Name 2"; Rec."Name 2")
            {
                ApplicationArea = All;
            }
        }
    }
}

