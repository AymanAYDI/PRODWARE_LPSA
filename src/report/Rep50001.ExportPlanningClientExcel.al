report 50001 "Export Planning Client Excel"
{
    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;


    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.", "Search Name", Priority;
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Bill-to Customer No." = FIELD("No."), "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                DataItemTableView = SORTING("Document Type", "Bill-to Customer No.", "Currency Code") WHERE("Document Type" = CONST(Order), "Outstanding Quantity" = FILTER(<> 0), Type = CONST(Item));
                RequestFilterFields = "Shipment Date", "Item Category Code", "No.";

                trigger OnAfterGetRecord()
                begin
                    NewOrder := "Document No." <> SalesHeader."No.";

                    if NewOrder then
                        SalesHeader.Get("Document Type", "Document No.");

                    // if "Shipment Date" <= WorkDate() then
                    //     BackOrderQty := "Outstanding Quantity"
                    // else
                    //     BackOrderQty := 0;

                    RowNo += 1;

                    if not Item.Get("No.") then
                        Item.Init();

                    Item.CalcFields(Inventory);

                    EnterCell(RowNo, 1, "Document No.", false, false, false, '@');
                    EnterCell(RowNo, 2, "Bill-to Customer No.", false, false, false, '@');
                    EnterCell(RowNo, 3, Customer.Name, false, false, false, '@');
                    EnterCell(RowNo, 4, SalesHeader."External Document No.", false, false, false, '@');
                    EnterCell(RowNo, 5, "No.", false, false, false, '@');
                    EnterCell(RowNo, 6, "Item Reference No.", false, false, false, '@');
                    EnterCell(RowNo, 7, "PWD LPSA Description 1" + "PWD LPSA Description 2", false, false, false, '@');
                    EnterCell(RowNo, 8, Format("Shipment Date"), false, false, false, '@');
                    EnterCell(RowNo, 9, Format(Quantity), false, false, false, '');
                    EnterCell(RowNo, 10, Format("Outstanding Quantity"), false, false, false, '');
                    EnterCell(RowNo, 11, Format(Item.Inventory), false, false, false, '');
                end;
            }

            trigger OnPreDataItem()
            begin
                Window.Open(
                  Text000 +
                  '@1@@@@@@@@@@@@@@@@@@@@@\');
                Window.Update(1, 0);
                // TotalRecNo := Customer.CountApprox;
                // RecNo := 0;

                TempExcelBuffer.DeleteAll();
                Clear(TempExcelBuffer);

                if Option = Option::"Update Workbook" then begin
                    ReadExcelSheet();
                    MaxRowNo := 0;
                    if TempExcelBuffer.FindFirst() then
                        repeat
                            if TempExcelBuffer."Row No." > MaxRowNo then
                                MaxRowNo := TempExcelBuffer."Row No.";
                        until TempExcelBuffer.Next() = 0;
                end;

                TempExcelBuffer.DeleteAll();
                Clear(TempExcelBuffer);


                //Title
                MakeExcelInfo();
            end;
        }
        dataitem("Production Forecast Entry"; "Production Forecast Entry")
        {
            RequestFilterFields = "Production Forecast Name", "Item No.", "Forecast Date";

            trigger OnAfterGetRecord()
            begin
                RowNo += 1;

                if not Item.Get("Item No.") then
                    Item.Init();

                Item.CalcFields(Inventory);

                if not ProductionForecastName.Get("Production Forecast Name") then
                    ProductionForecastName.Init();

                EnterCell(RowNo, 1, '', false, false, false, '@');
                EnterCell(RowNo, 2, "Production Forecast Name", false, false, false, '@');
                EnterCell(RowNo, 3, ProductionForecastName.Description, false, false, false, '@');
                EnterCell(RowNo, 4, '', false, false, false, '@');
                EnterCell(RowNo, 5, "Item No.", false, false, false, '@');
                EnterCell(RowNo, 6, '', false, false, false, '@');
                EnterCell(RowNo, 7, Item."PWD LPSA Description 1" + Item."PWD LPSA Description 2", false, false, false, '@');
                EnterCell(RowNo, 8, Format("Forecast Date"), false, false, false, '@');
                EnterCell(RowNo, 9, Format("Forecast Quantity"), false, false, false, '');
                EnterCell(RowNo, 10, Format("Forecast Quantity"), false, false, false, '');
                EnterCell(RowNo, 11, Format(Item.Inventory), false, false, false, '');
            end;
        }
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            begin

                if Option = Option::"Update Workbook" then begin
                    if UploadedFileName = '' then
                        UploadFile()
                    else
                        GFileName := UploadedFileName;
                    TempExcelBuffer.UpdateBookExcel(GFileName, SheetName, false);
                    TempExcelBuffer.WriteSheet('', CompanyName, UserId);
                    TempExcelBuffer.CloseBook();
                end else begin
                    TempExcelBuffer.CreateBook(GFileName, Text002E);
                    TempExcelBuffer.WriteSheet(Text003E, CompanyName, UserId);
                    TempExcelBuffer.CloseBook();
                end;
                Commit();
                TempExcelBuffer.OpenExcel();
                Error('');
            end;

            trigger OnPreDataItem()
            begin

                if RowNo < MaxRowNo then
                    for i := 1 to (MaxRowNo - RowNo) do begin
                        EnterCell(RowNo + i, 1, '', false, false, false, '@');
                        EnterCell(RowNo + i, 2, '', false, false, false, '@');
                        EnterCell(RowNo + i, 3, '', false, false, false, '@');
                        EnterCell(RowNo + i, 4, '', false, false, false, '@');
                        EnterCell(RowNo + i, 5, '', false, false, false, '@');
                        EnterCell(RowNo + i, 6, '', false, false, false, '@');
                        EnterCell(RowNo + i, 7, '', false, false, false, '@');
                        EnterCell(RowNo + i, 8, '', false, false, false, '@');
                        EnterCell(RowNo + i, 9, '', false, false, false, '');
                        EnterCell(RowNo + i, 10, '', false, false, false, '');
                        EnterCell(RowNo + i, 11, '', false, false, false, '');
                    end;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Control1900000002)
                {
                    Caption = 'Options';
                    ShowCaption = false;
                    field(OptionF; Option)
                    {
                        Caption = 'Option';
                        OptionCaption = 'Create Workbook,Update Workbook';
                        ShowCaption = false;
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            UpdateRequestForm();
                        end;
                    }
                    field(FileName; GFileName)
                    {
                        Caption = 'Workbook File Name';
                        Enabled = FileNameEnable;
                        ApplicationArea = All;

                        trigger OnAssistEdit()
                        begin
                            UploadFile();
                            if UploadedFileName <> '' then
                                GFileName := Text003;
                        end;

                        trigger OnValidate()
                        begin
                            FileNameOnAfterValidate();
                        end;
                    }
                    field(SheetNameF; SheetName)
                    {
                        Caption = 'Worksheet Name';
                        Enabled = SheetNameEnable;
                        ApplicationArea = All;

                        trigger OnAssistEdit()
                        var
                            ExcelBuf: Record "Excel Buffer";
                        begin
                            SheetName := ExcelBuf.SelectSheetsName(UploadedFileName);
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            SheetNameEnable := true;
            FileNameEnable := true;
        end;

        trigger OnOpenPage()
        begin
            UpdateRequestForm();
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        SalesLineFiter := "Sales Line".GetFilters;
        ForecastEntryFiter := "Production Forecast Entry".GetFilters;
    end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        Item: Record Item;
        ProductionForecastName: Record "Production Forecast Name";
        SalesHeader: Record "Sales Header";
        [InDataSet]
        FileNameEnable: Boolean;
        NewOrder: Boolean;
        [InDataSet]
        SheetNameEnable: Boolean;
        // BackOrderQty: Decimal;
        Window: Dialog;
        i: Integer;
        MaxRowNo: Integer;
        // RecNo: Integer;
        RowNo: Integer;
        // TotalRecNo: Integer;
        Text000: Label 'Analyzing Data...\\';
        Text002: Label 'Update Workbook';
        Text002E: Label 'Data';
        Text003: Label 'The file was successfully uploaded to server';
        Text003E: Label 'Export Planning Client Excel';
        Option: Option "Create Workbook","Update Workbook";
        GFileName: Text[250];
        SheetName: Text[250];
        ForecastEntryFiter: Text[1024];
        SalesLineFiter: Text[1024];
        UploadedFileName: Text[1024];


    procedure UpdateRequestForm()
    begin
        PageUpdateRequestForm();
        exit;
    end;


    procedure MakeExcelInfo()
    var
        Text004E: Label 'Company Name';
        Text005E: Label 'Report No.';
        Text006E: Label 'Report Name';
        Text007E: Label 'User ID';
        Text008E: Label 'Date';
        Text009E: Label 'Customer Filters';
        Text010E: Label 'Sales Order Lines Filters';
        Text011E: Label 'Production Forecast Entry Filter ';
    Begin
        TempExcelBuffer.AddColumn(Format(Text004E), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CompanyName, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(Format(Text006E), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(Text003E), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(Format(Text005E), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(REPORT::"Export Planning Client Excel", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(Format(Text007E), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(UserId, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(Format(Text008E), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Today, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(Format(Text009E), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Customer.GetFilters, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(Format(Text010E), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesLineFiter, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(Format(Text011E), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ForecastEntryFiter, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.ClearNewRow();

        RowNo := 10;

        EnterCell(RowNo, 1, "Sales Line".FieldCaption("Document No."), true, false, true, '@');
        EnterCell(RowNo, 2, "Sales Line".FieldCaption("Bill-to Customer No."), true, false, true, '@');
        EnterCell(RowNo, 3, Customer.FieldCaption(Name), true, false, true, '@');
        EnterCell(RowNo, 4, SalesHeader.FieldCaption("External Document No."), true, false, true, '@');
        EnterCell(RowNo, 5, "Sales Line".FieldCaption("No."), true, false, true, '@');
        EnterCell(RowNo, 6, "Sales Line".FieldCaption("Item Reference No."), true, false, true, '@');
        EnterCell(RowNo, 7, "Sales Line".FieldCaption(Description), true, false, true, '@');
        EnterCell(RowNo, 8, "Sales Line".FieldCaption("Shipment Date"), true, false, true, '@');
        EnterCell(RowNo, 9, "Sales Line".FieldCaption(Quantity), true, false, true, '');
        EnterCell(RowNo, 10, "Sales Line".FieldCaption("Outstanding Quantity"), true, false, true, '');
        EnterCell(RowNo, 11, Item.FieldCaption(Inventory), true, false, true, '@');
    end;

    // local procedure EnterFilterInCell(RowNo: Integer; "Filter": Text[250]; FieldName: Text[100])
    // begin
    //     if Filter <> '' then begin
    //         EnterCell(RowNo, 1, FieldName, false, false, false, '@');
    //         EnterCell(RowNo, 2, Filter, false, false, false, '@');
    //     end;
    // end;

    local procedure EnterCell(RowNo: Integer; ColumnNo: Integer; CellValue: Text[250]; Bold: Boolean; Italic: Boolean; UnderLine: Boolean; NumFormat: Text[30])
    begin
        TempExcelBuffer.Init();
        TempExcelBuffer.Validate("Row No.", RowNo);
        TempExcelBuffer.Validate("Column No.", ColumnNo);
        TempExcelBuffer."Cell Value as Text" := CellValue;
        TempExcelBuffer.Formula := '';
        TempExcelBuffer.Bold := Bold;
        TempExcelBuffer.Italic := Italic;
        TempExcelBuffer.Underline := UnderLine;
        TempExcelBuffer.NumberFormat := NumFormat;
        TempExcelBuffer.Insert();
    end;


    procedure UploadFile()
    var
        FileMgt: Codeunit "File Management";
    begin
        UploadedFileName := FileMgt.UploadFileWithFilter(Text002, GFileName, 'Excel', '');
        GFileName := UploadedFileName;
    end;

    local procedure FileNameOnAfterValidate()
    begin
        UploadFile();
        if UploadedFileName <> '' then
            GFileName := Text003;
    end;

    local procedure PageUpdateRequestForm()
    begin
        if Option = Option::"Update Workbook" then begin
            FileNameEnable := true;
            SheetNameEnable := true;
        end else begin
            GFileName := '';
            UploadedFileName := '';
            SheetName := '';
            FileNameEnable := false;
            SheetNameEnable := false;
        end;
    end;

    local procedure ReadExcelSheet()
    begin
        if UploadedFileName = '' then
            UploadFile()
        else
            GFileName := UploadedFileName;

        TempExcelBuffer.OpenBook(GFileName, SheetName);
        TempExcelBuffer.ReadSheet();
    end;
}

