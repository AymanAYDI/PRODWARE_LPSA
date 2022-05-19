codeunit 50022 "PWD LPSA Set/Get Functions."
{
    SingleInstance = true;

    var
        CalcReservEntry: Record "Reservation Entry";
        ReservEntry: Record "Reservation Entry";
        SourceRecRef: RecordRef;
        BooGAvoidControl: Boolean;

        BooGFromConfig: Boolean;
        BooGFromImport: Boolean;
        BooGFromWMS: Boolean;
        gFromTheSameLot: Boolean;
        ToBatchName: Code[10];
        ToTemplateName: Code[10];
        gLotDeterminingLotCode: Code[30];
        gLotDeterminingExpirDate: Date;
        BooGFromOsys: Boolean;
        BooGFromImportSaleLine: Boolean;
        BooGFromLotDeterminingEnable: Boolean;
    //---TAB39--- 
    procedure SetFctFromImport(SetBooGFromImport: Boolean)
    begin
        BooGFromImport := SetBooGFromImport;
    end;

    procedure GetFctFromImport(): Boolean

    begin
        exit(BooGFromImport);
    end;

    //---CDU241---
    PROCEDURE InitJnalName(CodPToTemplateName: Code[10]; CodPToBatchName: Code[10])
    BEGIN
        ToTemplateName := CodPToTemplateName;
        ToBatchName := CodPToBatchName;
    end;

    procedure GetToTemplateName(): Code[10]
    begin
        exit(ToTemplateName);
    end;

    procedure GetToBatchName(): Code[10]
    begin
        exit(ToBatchName);
    end;
    //---CDU99000838---
    procedure SetSourceRecRef(SourceRecRefP: RecordRef)
    begin
        SourceRecRef := SourceRecRefP;
    end;

    procedure SetCalcReservEntry(CalcReservEntryP: Record "Reservation Entry")
    begin
        CalcReservEntry := CalcReservEntryP;
    end;

    procedure GetCalcReservEntry(var CalcReservEntryP: Record "Reservation Entry")
    begin
        CalcReservEntryP := CalcReservEntry;
    end;

    procedure SetProdOrderComp(var ProdOrderComp: Record "Prod. Order Component")
    begin
        SourceRecRef.SetTable(ProdOrderComp);
    end;
    //---CDU5407---
    PROCEDURE SetNoFinishCOntrol(BooPAvoidControl: Boolean);
    BEGIN
        BooGAvoidControl := BooPAvoidControl;
    END;

    PROCEDURE GetNoFinishCOntrol(): Boolean;
    BEGIN
        Exit(BooGAvoidControl);
    END;
    //---CDU99000778---

    procedure SetFromConfiguration()
    BEGIN
        BooGFromConfig := TRUE;
    END;

    procedure GetFromConfiguration(): Boolean

    begin

        exit(BooGFromConfig);

    end;
    //---TAB83--- 
    procedure SetgFromTheSameLot(piSet: Boolean)
    BEGIN
        gFromTheSameLot := piSet;
    END;

    procedure GetFromTheSameLot(): Boolean

    begin

        exit(gFromTheSameLot);

    end;

    procedure SetgLotDeterminingData(piSetLotCode: Code[30]; piSetExpirDate: Date)
    BEGIN
        gLotDeterminingLotCode := piSetLotCode;
        gLotDeterminingExpirDate := piSetExpirDate;
        IF piSetLotCode <> '' THEN
            gFromTheSameLot := TRUE;
    END;

    procedure GetgLotDeterminingData(): Code[30];

    begin

        exit(gLotDeterminingLotCode);

    end;
    //---CDU8073291---
    procedure SetFromOsys()
    BEGIN
        BooGFromOsys := TRUE;
    END;

    procedure GetFromOsys(): Boolean

    begin

        exit(BooGFromOsys);

    end;
    //---TAB37---
    procedure SetFctFromImportSaleLine(BooPFromImport: Boolean)
    begin
        BooGFromImportSaleLine := BooPFromImport;
    end;

    procedure GetFctFromImportSaleLine(): Boolean

    begin

        exit(BooGFromImportSaleLine);

    end;

}
