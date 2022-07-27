page 50030 "PWD Link"
{
    Caption = 'Document Link';
    PageType = ListPart;
    SourceTable = "PWD Item Link";
    InsertAllowed = false;
    ModifyAllowed = false;
    UsageCategory = None;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(URL; Rec.URL)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the URL field.';
                    trigger OnDrillDown()
                    var
                        FileManagement: Codeunit "File Management";
                        FileName: Text;
                        FileDoesNotExistErr: Label 'The file %1 does not exist.', Comment = '%1 File Path';
                        FilterLbl: Label '*.pdf|*.*';
                        DownloadLbl: Label 'Download';
                    begin
                        if Rec."URL" <> '' then begin
                            if not FileManagement.ServerFileExists(Rec.URL) then
                                Error(FileDoesNotExistErr, Rec.URL);
                            FileName := FileManagement.GetFileName(Rec.URL);
                            FileManagement.DownloadHandler(Rec.URL, DownloadLbl, '', FilterLbl, FileName);
                        end;
                    end;

                }
                Field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                Field(CreationDate; Rec."Creation Date")
                {
                    ApplicationArea = All;
                }
                Field(UserId; Rec."User Id")
                {
                    ApplicationArea = All;
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
                Caption = 'Import File';
                Applicationarea = all;
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                var
                    FileRec: Record "Name/Value Buffer";
                    ItemLink: Record "PWD Item Link";
                    FileMgt: codeunit "File Management";
                begin
                    FileLookupOK(FileRec);
                    if fileRec.Name <> '' then begin
                        ItemLink.Init();
                        ItemLink."No." := 0;
                        ItemLink.URL := FileRec.Name;
                        ItemLink.Description := FileMgt.GetFileName(FileRec.Name);
                        ItemLink."Item No." := ItemIdV;
                        ItemLink.Insert(true);
                    end;
                end;
            }
        }
    }
    procedure FileLookupOK(var fileRec: Record "Name/Value Buffer")
    var
        filePag: Page "PWD File List";
    begin
        filePag.lookupMode(true);
        if FilePag.RunModal() = Action::LookUpOK then
            FilePag.getRecord(fileRec);
    end;

    procedure SetFilters(_ItemIdV: Code[20])
    begin
        ItemIdV := _ItemIdV;
    end;

    var
        ItemIdV: Code[20];

}
