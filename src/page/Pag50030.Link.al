page 50030 "PWD Link"
{
    Caption = 'Link ';
    PageType = ListPart;
    SourceTable = "Record Link";


    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(URL1; Rec.URL1)
                {
                    ShowCaption = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the URL1 field.';
                    trigger OnDrillDown()
                    var
                        FileManagement: Codeunit "File Management";
                        FileName: Text;
                        FileDoesNotExistErr: Label 'The file %1 does not exist.', Comment = '%1 File Path';
                        FilterLbl: Label '*.pdf|*.*';
                        DownloadLbl: Label 'Download';
                    begin
                        if Rec."URL1" <> '' then begin
                            if not FileManagement.ServerFileExists(Rec.URL1) then
                                Error(FileDoesNotExistErr, Rec.URL1);
                            FileName := FileManagement.GetFileName(Rec.URL1);
                            FileManagement.DownloadHandler(Rec.URL1, DownloadLbl, '', FilterLbl, FileName);
                        end;
                    end;

                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action("New Link")
            {
                caption = 'Select File';
                applicationarea = all;
                trigger OnAction()
                var
                    FileRec: Record "Name/Value Buffer";
                    RecordLink: Record "Record Link";
                    UserSetup: Record "User Setup";
                    FileMgt: codeunit "File Management";
                begin
                    FileLookupOK(FileRec);
                    if fileRec.Name <> '' then begin
                        RecordLink.Init();
                        RecordLink."Link ID" := 0;
                        RecordLink.URL1 := FileRec.Name;
                        RecordLink.Description := FileMgt.GetFileName(FileRec.Name);
                        RecordLink."Record ID" := RecordIdV;
                        RecordLink.Type := RecordLink.Type::Link;
                        RecordLink.Insert(true);
                    end;
                end;
            }
        }
    }
    trigger OnOPenPage()
    var
    begin
        Rec.SetRange("Record ID", RecordIdV);
        Rec.SetRange(Type, Rec.Type::Link);
    end;

    procedure FileLookupOK(var fileRec: Record "Name/Value Buffer")
    var
        filePag: Page "PWD File List";
    begin
        filePag.lookupMode(true);
        if FilePag.RunModal() = Action::LookUpOK then
            FilePag.getRecord(fileRec);
    end;

    procedure SetFilters(RecordIdV2: RecordId)
    begin
        RecordIdV := RecordIdV2;
    end;

    var
        RecordIdV: RecordId;

}
