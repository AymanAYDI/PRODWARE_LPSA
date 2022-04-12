codeunit 50003 "PWD Trading Unit Mgt.PW"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // FE_PROD01.001:GR 14/02/2012:  Order No, OF and LOT
    //                               - create
    // 
    // ------------------------------------------------------------------------------------------------------------------


    trigger OnRun()
    begin
    end;

    var
        gMaxLenLotNo: Integer;
        gMaxLenTradingUnitNo: Integer;
        gctxErr0001: Label 'Lot No. must be max. %1 chars, Trading Unit No. must be max. %2 chars.';
        gctxErr0002: Label 'Lot No. %1 exceeds the maximum length.';
        gctxErr0003: Label 'Trading Unit No. %1 exceeds the maximum length.';
        gctxErr0004: Label 'Lot-/Trading Unit No. %1 exceeds the maximum length.';
        gctxErr0005: Label 'Lot No. has to be entered.';
        gctxErr0006: Label 'Item %1 is handled in Trading Units. Trading Unit Number must be entered.';
        gctxErr0007: Label 'Item %1 is not handled in Trading Units. Trading Unit Number must not be entered.';


    procedure CheckLotNo(piLotNo: Code[20])
    begin
        InitVars;

        if StrLen(piLotNo) > gMaxLenLotNo then
            Error(gctxErr0002, piLotNo);
    end;


    procedure CheckTradingUnitNo(piTradingUnitNo: Code[20])
    begin
        InitVars;

        if StrLen(piTradingUnitNo) > gMaxLenTradingUnitNo then
            Error(gctxErr0003, piTradingUnitNo);
    end;


    procedure CheckLotTradingUnitNo(piLotTradingUnitNo: Code[40])
    begin
        InitVars;

        if StrLen(piLotTradingUnitNo) > (gMaxLenLotNo + gMaxLenTradingUnitNo) then
            Error(gctxErr0004, piLotTradingUnitNo);
    end;


    procedure GetLotTradingUnitNo(piLotNo: Code[20]; piTradingUnitNo: Code[20]): Code[40]
    begin
        InitVars;
        if piTradingUnitNo <> '' then
            if piLotNo = '' then
                Error(gctxErr0005);
        exit(PadStr(piLotNo, gMaxLenLotNo) + PadStr(piTradingUnitNo, gMaxLenTradingUnitNo));
    end;


    procedure GetLotNo(piLotNo: Code[40]): Code[20]
    begin
        InitVars;
        exit(DelChr(CopyStr(piLotNo, 1, gMaxLenLotNo), '><', ' '));
    end;


    procedure GetTradingUnitNo(piLotNo: Code[40]): Code[20]
    begin
        InitVars;
        exit(DelChr(CopyStr(piLotNo, gMaxLenLotNo + 1, gMaxLenTradingUnitNo), '><', ' '));
    end;


    procedure InitVars()
    begin
        gMaxLenLotNo := 20;
        gMaxLenTradingUnitNo := 10;
    end;


    procedure SplitLotTradingUnitNo(piLotTradingUnitNo: Code[30]; var poLotNo: Code[20]; var poTradingUnitNo: Code[20])
    begin
        InitVars;
        if StrLen(piLotTradingUnitNo) > (gMaxLenLotNo + gMaxLenTradingUnitNo) then
            Error(gctxErr0001, gMaxLenLotNo, gMaxLenTradingUnitNo);
        poLotNo := DelChr(CopyStr(piLotTradingUnitNo, 1, gMaxLenLotNo), '><', ' ');
        poTradingUnitNo := DelChr(CopyStr(piLotTradingUnitNo, gMaxLenLotNo + 1, gMaxLenTradingUnitNo), '><', ' ');
    end;


    procedure CheckTradingUnitHandling(piItemNo: Code[20]; piLotNumber: Code[20]; piTradingUnitNumber: Code[20])
    var
        Item: Record Item;
    begin
        if piLotNumber <> '' then
            if Item.Get(piItemNo) then;
        /*
          IF Item."Handled in Trading Units" AND (piTradingUnitNumber = '') THEN
            ERROR(gctxErr0006, Item."No.")
          ELSE IF NOT Item."Handled in Trading Units" AND (piTradingUnitNumber <> '') THEN
            ERROR(gctxErr0007, Item."No.");
         */

    end;


    procedure Item_OnValidateItemTrkgCode(var pioItem: Record Item)
    var
        ItemTrackingCode: Record "Item Tracking Code";
    begin
        if not ItemTrackingCode.Get(pioItem."Item Tracking Code") then
            Clear(ItemTrackingCode);
        if not ItemTrackingCode."Lot Specific Tracking" then;
        //IF pioItem."Handled in Trading Units" THEN
        /* BEGIN
          pioItem.TestNoOpenEntriesExist(pioItem.FIELDCAPTION("Item Tracking Code"));
          pioItem."Handled in Trading Units" := FALSE;
          pioItem."Trading Unit Nos." := '';
        END;
          */

    end;


    procedure Item_OnValidateHandledInTU(var pioItem: Record Item)
    var
        ItemTrackingCode: Record "Item Tracking Code";
    begin
        /*IF pioItem."Handled in Trading Units" THEN BEGIN
          pioItem.TESTFIELD("Item Tracking Code");
          ItemTrackingCode.GET(pioItem."Item Tracking Code");
          ItemTrackingCode.TESTFIELD("Lot Specific Tracking");*/
        //END ELSE
        // pioItem."Trading Unit Nos." := '';

    end;
}

