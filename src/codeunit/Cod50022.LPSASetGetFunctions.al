codeunit 50022 "PWD LPSA Set/Get Functions."
{
    SingleInstance = true;

    var
        BooGFromImport: Boolean;
        BooGFromConfig: Boolean;
        gFromTheSameLot: Boolean;
        gLotDeterminingLotCode: Code[30];
        gLotDeterminingExpirDate: Date;
        BooGFromOsys: Boolean;
//---TAB39--- 
    procedure SetFctFromImport(SetBooGFromImport: Boolean)
    begin
        BooGFromImport := SetBooGFromImport;
    end;

    procedure GetFctFromImport(): Boolean

    begin

        exit(BooGFromImport);

    end;
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
}
