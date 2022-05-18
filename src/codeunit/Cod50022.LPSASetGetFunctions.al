codeunit 50022 "PWD LPSA Set/Get Functions."
{
    SingleInstance = true;

    var
        BooGFromImport: Boolean;
        ToBatchName: Code[10];
        ToTemplateName: Code[10];
        BooGFromWMS: Boolean;
        SourceRecRef: RecordRef;
        CalcReservEntry: Record "Reservation Entry";
        BooGAvoidControl: Boolean;
        ReservEntry: Record "Reservation Entry";

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

}
