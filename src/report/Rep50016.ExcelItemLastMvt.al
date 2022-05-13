report 50016 "PWD Excel Item Last Mvt"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 07/09/2017 : DEMANDES DIVERSES
    //                              Add C/AL Globals TxtGEntryType, CstG016
    //                              Add C/AL Code in triggers MakeHeader()
    //                                                        Item - OnAfterGetRecord()
    // 
    // //>>HOTLINE(SU)
    // cf TI468326 : LALE.RO : 11/09/2019
    //                              Add C/AL Code in triggers Item - OnAfterGetRecord()

    Caption = 'Excel Item Last Mvt';
    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Location Filter", "Date Filter";

            trigger OnAfterGetRecord()
            var
                RecLItem: Record Item;
                RecLItemLedgEntry: Record "Item Ledger Entry";
                DatLMax: Date;
            begin
                IntGLineNo += 1;
                IntGColNo := 1;

                EnterCell(IntGLineNo, IntGColNo, "No.", false, false, '@');
                IntGColNo += 1;
                EnterCell(IntGLineNo, IntGColNo, "PWD LPSA Description 1", false, false, '@');
                IntGColNo += 1;
                EnterCell(IntGLineNo, IntGColNo, "PWD LPSA Description 2", false, false, '@');
                IntGColNo += 1;

                RecLItem.Get("No.");
                RecLItem.SetRange("Date Filter", 0D, DatGMax);
                RecLItem.CalcFields("Net Change");

                EnterCell(IntGLineNo, IntGColNo, Format(RecLItem."Net Change", 0, 1), false, false, '0');
                IntGColNo += 1;
                EnterCell(IntGLineNo, IntGColNo, Format("PWD Last Entry Date Old ERP"), false, false, '');
                IntGColNo += 1;

                DatLMax := "PWD Last Entry Date Old ERP";
                //>>LAP2.12
                TxtGEntryType := '';
                if DatLMax <> 0D then
                    TxtGEntryType := 'Mvt Old ERP';
                //<<LAP2.12

                RecLItemLedgEntry.Reset();
                //>>HOTLINE
                //RecLItemLedgEntry.SETCURRENTKEY("Item No.","Entry Type","Variant Code","Drop Shipment","Location Code","Posting Date");
                RecLItemLedgEntry.SetCurrentKey("Item No.", "Posting Date", "Entry Type", "Variant Code", "Drop Shipment", "Location Code");

                RecLItemLedgEntry.SetRange("Item No.", "No.");
                RecLItemLedgEntry.SetRange("Posting Date", 0D, DatGMax);
                RecLItemLedgEntry.SetFilter("Entry Type", '%1|%2', RecLItemLedgEntry."Entry Type"::Output,
                                                                  RecLItemLedgEntry."Entry Type"::Purchase);
                if TxtGLocationFilter <> '' then
                    RecLItemLedgEntry.SetFilter("Location Code", TxtGLocationFilter);
                //RecLItemLedgEntry.SETRANGE("Posting Date",0D,DatGMax);
                //>>HOTLINE
                if RecLItemLedgEntry.FindLast() then begin
                    EnterCell(IntGLineNo, IntGColNo, Format(RecLItemLedgEntry."Posting Date"), false, false, '');
                    IntGColNo += 1;
                    if DatLMax < RecLItemLedgEntry."Posting Date" then begin
                        //>>LAP2.12
                        //<<LAP2.12
                        DatLMax := RecLItemLedgEntry."Posting Date";
                        //>>LAP2.12
                        TxtGEntryType := Format(RecLItemLedgEntry."Entry Type");
                    end;
                    //<<LAP2.12
                    EnterCell(IntGLineNo, IntGColNo, Format(RecLItemLedgEntry.Quantity, 0, 1), false, false, '0');
                    IntGColNo += 1;
                end else begin
                    EnterCell(IntGLineNo, IntGColNo, '', false, false, '');
                    IntGColNo += 1;
                    EnterCell(IntGLineNo, IntGColNo, Format(0), false, false, '0');
                    IntGColNo += 1;
                end;

                RecLItemLedgEntry.SetFilter("Entry Type", '%1|%2', RecLItemLedgEntry."Entry Type"::Consumption,
                                                                  RecLItemLedgEntry."Entry Type"::Sale);
                if RecLItemLedgEntry.FindLast() then begin
                    EnterCell(IntGLineNo, IntGColNo, Format(RecLItemLedgEntry."Posting Date"), false, false, '');
                    IntGColNo += 1;
                    if DatLMax < RecLItemLedgEntry."Posting Date" then begin
                        //>>LAP2.12
                        //<<LAP2.12
                        DatLMax := RecLItemLedgEntry."Posting Date";
                        //>>LAP2.12
                        TxtGEntryType := Format(RecLItemLedgEntry."Entry Type");
                    end;
                    //<<LAP2.12
                    EnterCell(IntGLineNo, IntGColNo, Format(RecLItemLedgEntry.Quantity, 0, 1), false, false, '0');
                    IntGColNo += 1;
                end else begin
                    EnterCell(IntGLineNo, IntGColNo, '', false, false, '');
                    IntGColNo += 1;
                    EnterCell(IntGLineNo, IntGColNo, Format(0), false, false, '0');
                    IntGColNo += 1;
                end;
                EnterCell(IntGLineNo, IntGColNo, Format(DatLMax), false, false, '');
                IntGColNo += 1;

                //>>LAP2.12
                EnterCell(IntGLineNo, IntGColNo, TxtGEntryType, false, false, '');
                IntGColNo += 1;
                //<<LAP2.12
            end;

            trigger OnPostDataItem()
            Var
                ServerFileName: Text;
            begin
                ExcelBuf.CreateBook(ServerFileName, CstG012);
                ExcelBuf.WriteSheet(CstG012, CompanyName, UserId);
                ExcelBuf.CloseBook();
            end;

            trigger OnPreDataItem()
            begin
                if GetFilter("Date Filter") = '' then
                    Error(CstG013);
                if GetRangeMax("Date Filter") = 0D then
                    Error(CstG014);

                TxtGDateFilter := GetFilter("Date Filter");
                TxtGLocationFilter := GetFilter("Location Filter");
                DatGMax := GetRangeMax("Date Filter");

                MakeHeader();
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        ExcelBuf: Record "Excel Buffer" temporary;
        DatGMax: Date;
        IntGColNo: Integer;
        IntGLineNo: Integer;
        CstG001: Label 'N° article';
        CstG002: Label 'Désignation';
        CstG003: Label 'Désignation 2';
        CstG004: Label 'Stock à date de demande';
        CstG005: Label 'Date historique';
        CstG006: Label 'Date dern. entrée';
        CstG007: Label 'Qté dern. entrée';
        CstG008: Label 'Date dern. sortie';
        CstG009: Label 'Qté dern. sortie';
        CstG010: Label 'Date dern. mvt';
        CstG011: Label 'Filtre date';
        CstG012: Label 'Export dern. mvt';
        CstG013: Label 'Veuillez renseigner un filtre date';
        CstG014: Label 'Veuillez renseigner une date de fin';
        CstG015: Label 'Filtre magasin';
        CstG016: Label 'Entry type';
        TxtGEntryType: Text[30];
        TxtGDateFilter: Text[100];
        TxtGLocationFilter: Text[100];

    local procedure EnterCell(RowNo: Integer; ColumnNo: Integer; CellValue: Text[250]; Bold: Boolean; UnderLine: Boolean; NumberFormat: Text[30])
    begin
        ExcelBuf.Init();
        ExcelBuf.Validate("Row No.", RowNo);
        ExcelBuf.Validate("Column No.", ColumnNo);
        ExcelBuf."Cell Value as Text" := CellValue;
        ExcelBuf.Formula := '';
        ExcelBuf.Bold := Bold;
        ExcelBuf.Underline := UnderLine;
        ExcelBuf.NumberFormat := NumberFormat;
        ExcelBuf.Insert();
    end;


    procedure MakeHeader()
    begin
        IntGLineNo := 1;
        IntGColNo := 1;

        EnterCell(IntGLineNo, IntGColNo, CstG011, true, false, '@');
        IntGColNo += 1;
        EnterCell(IntGLineNo, IntGColNo, TxtGDateFilter, true, false, '@');
        IntGColNo += 2;
        EnterCell(IntGLineNo, IntGColNo, CstG015, true, false, '@');
        IntGColNo += 1;
        EnterCell(IntGLineNo, IntGColNo, TxtGLocationFilter, true, false, '@');
        IntGColNo += 1;

        IntGLineNo += 2;
        IntGColNo := 1;

        EnterCell(IntGLineNo, IntGColNo, CstG001, true, false, '@');
        IntGColNo += 1;
        EnterCell(IntGLineNo, IntGColNo, CstG002, true, false, '@');
        IntGColNo += 1;
        EnterCell(IntGLineNo, IntGColNo, CstG003, true, false, '@');
        IntGColNo += 1;
        EnterCell(IntGLineNo, IntGColNo, CstG004, true, false, '@');
        IntGColNo += 1;
        EnterCell(IntGLineNo, IntGColNo, CstG005, true, false, '@');
        IntGColNo += 1;
        EnterCell(IntGLineNo, IntGColNo, CstG006, true, false, '@');
        IntGColNo += 1;
        EnterCell(IntGLineNo, IntGColNo, CstG007, true, false, '@');
        IntGColNo += 1;
        EnterCell(IntGLineNo, IntGColNo, CstG008, true, false, '@');
        IntGColNo += 1;
        EnterCell(IntGLineNo, IntGColNo, CstG009, true, false, '@');
        IntGColNo += 1;
        EnterCell(IntGLineNo, IntGColNo, CstG010, true, false, '@');
        IntGColNo += 1;
        //>>LAP2.12
        EnterCell(IntGLineNo, IntGColNo, CstG016, true, false, '@');
        IntGColNo += 1;
        //<<LAP2.12
    end;
}

