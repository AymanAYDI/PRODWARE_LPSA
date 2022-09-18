pageextension 60141 "PWD ReleasedProdOrderLines" extends "Released Prod. Order Lines"
{
    // //>>LPSA.TDL
    // 10/04/2014 : Add Field starting/ending date
    // PLAW1 -----------------------------------------------------------------------------
    // PLAW1-4.0 2014-02-21 PO-4400: enable assistEdit on UserColors for web client
    // PLAW1 -----------------------------------------------------------------------------
    layout
    {
        addafter("ShortcutDimCode[8]")
        {
            field("PWD DatGHeureDeb"; DatGHeureDeb)
            {
                Caption = 'Launch. Prod. Starting Date-Time';
                ApplicationArea = All;
            }
            field("Send to OSYS (Released)"; Rec."PWD Send to OSYS (Released)")
            {
                ApplicationArea = All;
            }
            field("PWD Manufacturing Code"; Rec."PWD Manufacturing Code")
            {
                ApplicationArea = All;
            }
            field("PWD Inventory Posting Group"; Rec."Inventory Posting Group")
            {
                ApplicationArea = All;
            }
        }
    }

    var
        DatGHeureDeb: DateTime;

}

