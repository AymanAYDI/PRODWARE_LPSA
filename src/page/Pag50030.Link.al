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
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(URL1; Rec.URL1)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the URL1 field.';
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
                caption = 'Nouveau Lien';
                applicationarea = all;
                trigger OnAction()
                var
                    TempBlob: Codeunit "Temp Blob";
                    FileName: Text;
                begin
                    ImportWithFilter(TempBlob, FileName);
                    Rec.URL1 := FileName;
                    Rec.Insert();
                end;
            }
        }
    }
    procedure ImportWithFilter(var TempBlob: Codeunit "Temp Blob"; var FileName: Text)
    var
        FileManagement: Codeunit "File Management";
    begin
        FileName := FileManagement.BLOBImportWithFilter(
            TempBlob, ImportTxt, FileName, StrSubstNo(FileDialogTxt, FilterTxt), FilterTxt);
    end;

    procedure GetRecordId(): RecordId
    begin
        exit(RecordIdV);
    end;

    procedure SetRecordId(RecordIdV2: RecordId)
    begin
        RecordIdV := RecordIdV2;
    end;

    var
        FileDialogTxt: Label 'Attachments (%1)|%1', Comment = '%1=file types, such as *.txt or *.docx';
        FilterTxt: Label '*.jpg;*.jpeg;*.bmp;*.png;*.gif;*.tiff;*.tif;*.pdf;*.docx;*.doc;*.xlsx;*.xls;*.pptx;*.ppt;*.msg;*.xml;*.*', Locked = true;
        ImportTxt: Label 'Attach a document.';
        RecordIdV: RecordId;

}
