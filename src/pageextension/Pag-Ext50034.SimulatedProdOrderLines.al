pageextension 50034 "PWD SimulatedProdOrderLines" extends "Simulated Prod. Order Lines"
{
    // PLAW1 -----------------------------------------------------------------------------
    // PLAW1-4.0 2014-02-21 PO-4400: enable assistEdit on UserColors for web client
    // PLAW1 -----------------------------------------------------------------------------
    layout
    {
        addafter("ShortcutDimCode[8]")
        {
            field("PWD Manufacturing Code"; Rec."PWD Manufacturing Code")
            {
                ApplicationArea = All;
            }
        }
    }

    var
        vUserColors: Text[50];
        ApplicationManagement: Codeunit "1";

}

