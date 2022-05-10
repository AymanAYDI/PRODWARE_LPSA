codeunit 50022 "PWD LPSA Set/Get Functions."
{
    SingleInstance = true;

    var
        BooGFromImport: Boolean;

    procedure SetFctFromImport(SetBooGFromImport: Boolean)
    begin
        BooGFromImport := SetBooGFromImport;
    end;

    procedure GetFctFromImport(): Boolean

    begin

        exit(BooGFromImport);

    end;
}
