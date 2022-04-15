codeunit 8073297 "Connector Fields Management"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.5
    // WMS-FEMOT.001:GR 04/07/2001 :  Connector integration
    //                                   - Create Object
    // 
    // +----------------------------------------------------------------------------------------------------------------+


    trigger OnRun()
    begin
        case TxtGFctName of
            'FctReplaceBoolByInt':
                FctReplaceBoolByInt();
            'FctSNSpecTrack':
                FctSNSpecTrack();
            'FctManExp':
                FctManExp();
            'FctUnitType':
                FctUnitType();
            else
        end;
    end;

    var
        TxtGValue: Text[250];
        TxtGFctName: Text[100];
        RecGRecRef: RecordRef;


    procedure FctGiveOldValue(TxtPOldValue: Text[250]; TxtPFctName: Text[100]; RecPRecRef: RecordRef)
    begin
        TxtGValue := TxtPOldValue;
        TxtGFctName := TxtPFctName;
        RecGRecRef := RecPRecRef;
    end;


    procedure FctReturnNewValue(): Text[250]
    begin
        exit(TxtGValue);
    end;


    procedure FctReplaceBoolByInt()
    var
        BooLValue: Boolean;
    begin
        Evaluate(BooLValue, TxtGValue);
        if not BooLValue then
            TxtGValue := '0'
        else
            TxtGValue := '1'
    end;


    procedure FctSNSpecTrack()
    var
        FldRef: FieldRef;
        RecLItemTrackingCode: Record "Item Tracking Code";
        BooLReturn: Boolean;
    begin
        BooLReturn := false;
        FldRef := RecGRecRef.Field(6500);
        if RecLItemTrackingCode.Get(FldRef.Value) then
            if RecLItemTrackingCode."SN Specific Tracking" and RecLItemTrackingCode."Lot Specific Tracking" then
                BooLReturn := true;

        TxtGValue := Format(BooLReturn);
    end;


    procedure FctManExp()
    var
        FldRef: FieldRef;
        RecLItemTrackingCode: Record "Item Tracking Code";
    begin
        FldRef := RecGRecRef.Field(6500);
        if RecLItemTrackingCode.Get(FldRef.Value) then
            TxtGValue := Format(RecLItemTrackingCode."Man. Expir. Date Entry Reqd.");
    end;


    procedure FctUnitType()
    begin
        case TxtGValue of
            '1':
                TxtGValue := '00';
            '2':
                TxtGValue := '01';
            '3':
                TxtGValue := '02';
            '4':
                TxtGValue := '03';
            else
                TxtGValue := '  ';
        end;
    end;
}

