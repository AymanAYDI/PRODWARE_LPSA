page 50031 "PWD File List"
{
    Caption = 'File List';
    PageType = List;
    SourceTable = "Name/Value Buffer";
    SourceTableTemporary = True;
    UsageCategory = None;
    Editable = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Name; Rec."Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        NameValueBuffer: Record "Name/Value Buffer" temporary;
        InventorySetup: Record "Inventory Setup";
        FileManagement: Codeunit "File Management";
        Data: Text;
        Parameters: List of [Text];
        Select: Integer;
    begin
        InventorySetup.Get();
        InventorySetup.TestField("PWD Path Link");
        Data := InventorySetup."PWD Path Link";
        if Data.Contains('|') then begin
            Parameters := Data.Split('|');
            Data := ConvertStr(InventorySetup."PWD Path Link", '|', ',');
            Select := Dialog.StrMenu(Data);
            if Select = 0 then
                exit;
            FileManagement.GetServerDirectoryFilesListInclSubDirs(NameValueBuffer, Parameters.Get(Select));
        end
        else
            FileManagement.GetServerDirectoryFilesListInclSubDirs(NameValueBuffer, Data);
        if NameValueBuffer.FindSet() then
            repeat
                Rec := NameValueBuffer;
                Rec.Insert();
            until NameValueBuffer.Next() = 0;
    end;
}
