tableextension 60037 "PWD ProdOrderLine" extends "Prod. Order Line"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                 |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // 
    // //PLAW11.0
    // FE_Merge: TO 23/01/2012:  Merge of pbjects Planner One
    //                                           - Add field 8076500..8076505
    //                                           - Add C/AL on triggers
    //                                              Item No. - OnValidate
    //                                              Starting Time - OnValidate
    //                                              Ending Time - OnValidate
    // 
    // //>>LAP2.06
    // FE_LAPRIERRETTE_GP0003 : APA 16/05/2013 : Add Function ExistPhantomItem
    // 
    // 
    // FE_LAPRIERRETTE_GP0004.001 :GR  23/05/13  - C\AL in   FctCreateDeleteProdOrderLine
    //                                           - add field "Is Possible Item"
    // 
    // //>>LAP.TDL.07/04/2014 :
    //                                           - Add function ResendProdOrdertoQuartis
    //                                           - Add Code in Prod. Starting Date-Time - OnValidate()
    //                                           - Add Code in Prod. Ending Date-Time - OnValidate()
    // 
    // //>>LAP.TDL.09/10/2014 :
    // 09/10/2014 : Add indicator (to know the component status) and Delay (between P1 ending date and NAV Ending Date)
    //               - Add fields 50001 (Delay)
    //               - Add function CheckComponentAvailabilty
    // 
    // ------------------------------------------------------------------------------------------------------------------
    // PLAW1 -----------------------------------------------------------------------------
    // PLAW1-4.0   06/02/2014 PO-3706 remove copy of item color
    // PLAW1-5.0   06/05/2015 PO-5140 Earliest Start date from start date
    // PLAW1 -----------------------------------------------------------------------------
    // 
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 11/05/2017 : DEMANDES DIVERSES
    //                   - Add Field 50010 - To Be Updated - Boolean
    fields
    {
        field(50000; "PWD Is Possible Item"; Boolean)
        {
            Caption = 'Is Possible Item';
            Description = 'LAP2.06';
            DataClassification = CustomerContent;
        }
        field(50001; "PWD Delay"; Integer)
        {
            Caption = 'Delay';
            DataClassification = CustomerContent;
        }
        field(50002; "PWD Initial Ending Date Time"; DateTime)
        {
            Caption = 'Date/Heure fin initiale';
            DataClassification = CustomerContent;
        }
        field(50003; "PWD Processed"; Boolean)
        {
            caption = 'Processed';
            DataClassification = CustomerContent;
        }
        field(50004; "PWD Manufacturing Code"; Code[10])
        {
            Caption = 'Code production';
            Description = 'LAP2.10';
            DataClassification = CustomerContent;
        }
        field(50010; "PWD To Be Updated"; Boolean)
        {
            Caption = 'To Be Updated';
            Description = 'LAP2.12';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(8073282; "PWD Send to OSYS (Released)"; Boolean)
        {
            Caption = 'Send to OSYS (Released)';
            DataClassification = CustomerContent;
        }
        field(8073283; "PWD Send to OSYS (Finished)"; Boolean)
        {
            Caption = 'Send to OSYS (Terminer)';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(Key50002; Status, "Routing No.", "Routing Version Code")
        {
        }
    }
    PROCEDURE FctCreateDeleteProdOrderLine()
    VAR
        RecLDeleteProdOrderLine: Record "PWD Deleted Prod. Order Line";
    BEGIN
        FctIsRecreateOrderLine();
        RecLDeleteProdOrderLine.INIT();
        RecLDeleteProdOrderLine.TRANSFERFIELDS(Rec);
        RecLDeleteProdOrderLine.INSERT();
    END;

    PROCEDURE FctIsRecreateOrderLine()
    VAR
        RecLDeleteProdOrderLine: Record "PWD Deleted Prod. Order Line";
    BEGIN
        IF RecLDeleteProdOrderLine.GET(Status, "Prod. Order No.", "Line No.") THEN
            RecLDeleteProdOrderLine.DELETE(TRUE);
    END;

    PROCEDURE ExistPhantomItem(): Text[1];
    VAR
        RecLItem: Record Item;
        RecLProdOrderComponent: Record "Prod. Order Component";
        BooLPhantomFind: Boolean;
    BEGIN
        BooLPhantomFind := FALSE;
        RecLProdOrderComponent.SETRANGE(Status, Status);
        RecLProdOrderComponent.SETRANGE("Prod. Order No.", "Prod. Order No.");
        RecLProdOrderComponent.SETRANGE("Prod. Order Line No.", "Line No.");
        IF RecLProdOrderComponent.FIND('-') THEN
            REPEAT
                RecLItem.GET(RecLProdOrderComponent."Item No.");
                BooLPhantomFind := RecLItem."PWD Phantom Item";
            UNTIL (RecLProdOrderComponent.NEXT() = 0) OR BooLPhantomFind;

        IF BooLPhantomFind THEN
            EXIT('F')
        ELSE
            EXIT('');
    END;

    PROCEDURE ResendProdOrdertoQuartis();
    BEGIN
        IF (Status = Status::Released) AND ("PWD Send to OSYS (Released)") THEN BEGIN
            "PWD Send to OSYS (Released)" := FALSE;
            MODIFY();
        END;
    END;

    PROCEDURE CheckComponentAvailabilty() IsNotAvailable: Boolean;
    VAR
        RecLProdOrderCompo: Record "Prod. Order Component";
        BooLIsNotAvailable: Boolean;
    BEGIN
        BooLIsNotAvailable := FALSE;
        RecLProdOrderCompo.RESET();
        RecLProdOrderCompo.SETRANGE(Status, Status);
        RecLProdOrderCompo.SETRANGE("Prod. Order No.", "Prod. Order No.");
        RecLProdOrderCompo.SETRANGE("Prod. Order Line No.", "Line No.");
        RecLProdOrderCompo.SETFILTER("Remaining Quantity", '<>%1', 0);
        IF RecLProdOrderCompo.FINDFIRST() THEN
            REPEAT
                BooLIsNotAvailable := RecLProdOrderCompo.CheckComponentAvailabilty();
            UNTIL (BooLIsNotAvailable) OR (RecLProdOrderCompo.NEXT() = 0);
        EXIT(BooLIsNotAvailable);
    END;

}

