pageextension 60148 "PWD FinishedProdOrderLines" extends "Finished Prod. Order Lines"
{
    // PLAW1 -----------------------------------------------------------------------------
    // PLAW1-4.0 2014-02-21 PO-4400: enable assistEdit on UserColors for web client
    // PLAW1 -----------------------------------------------------------------------------
    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field("PWD Manufacturing Code"; Rec."PWD Manufacturing Code")
            {
                ApplicationArea = All;
            }
        }
    }
}
