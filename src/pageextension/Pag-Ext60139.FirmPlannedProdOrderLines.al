pageextension 60139 "PWD FirmPlannedProdOrderLines" extends "Firm Planned Prod. Order Lines"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //PLAW11.0
    // FE_Merge: TO 23/01/2012:  Merge of pbjects Planner One
    //                          - Add fields:  "Prod. Starting Date-Time"
    //                                         "Prod. Ending Date-Time"
    //                                         "Earliest Start Date"
    //                                         PlannerOneCustom
    //                                         SchedulingPriority
    // //>>LAP2.06
    // FE_LAPRIERRETTE_GP0003 : APA 16/05/13 Add ExistPhantomItem
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    // PLAW1 -----------------------------------------------------------------------------
    // PLAW1-4.0 2014-02-21 PO-4400: enable assistEdit on UserColors for web client
    // PLAW1 -----------------------------------------------------------------------------
    layout
    {
        addafter("Routing Version Code")
        {
            field("PWD ExistPhantomItem"; ExistPhantomItem())
            {
                Caption = 'Phantom Item';
                ApplicationArea = All;
            }
        }
        addafter("ShortcutDimCode[8]")
        {
            field("PWD DatGHeureDeb"; DatGHeureDeb)
            {
                Caption = 'Launch. Prod. Starting Date-Time';
                Editable = false;
                ApplicationArea = All;
            }
            field("PWD Manufacturing Code"; "PWD Manufacturing Code")
            {
                ApplicationArea = All;
            }
            field("PWD Planning Level Code"; "Planning Level Code")
            {
                ApplicationArea = All;
            }
        }
    }

    var
        DatGHeureDeb: DateTime;
}

