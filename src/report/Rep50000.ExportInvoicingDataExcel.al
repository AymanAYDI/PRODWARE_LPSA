report 50000 "Export Invoicing Data (Excel)"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_VTE01.001: TO 07/12/2011:  Export Role
    //                                           - Creation of Report
    // 
    // ------------------------------------------------------------------------------------------------------------------

    Caption = 'Export Invoicing Data (Excel)';
    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(CrMemoHeaderNR; "Sales Cr.Memo Header")
        {
            DataItemTableView = SORTING("No.") WHERE("PWD Rolex Bienne" = CONST(false));
            dataitem(CrMemoLineNR; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.") WHERE(Type = FILTER(<> " "));

                trigger OnAfterGetRecord()
                begin
                    ExcelBuf.NewRow();
                    ExcelBuf.AddColumn(Format(CrMemoLineNR."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>'), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(Format(CrMemoLineNR."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>'), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('DG', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(CrMemoLineNR."Document No.", FALSE, '', FALSE, FALSE, FALSE, '@', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(CodGCurrency, FALSE, '', FALSE, FALSE, FALSE, '@', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(TxtGBarCode, FALSE, '', FALSE, FALSE, FALSE, '@', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('1900', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(CstG40, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    if CrMemoLineNR.Type = CrMemoLineNR.Type::"G/L Account" then
                        ExcelBuf.AddColumn(CrMemoLineNR."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text)
                    else
                        ExcelBuf.AddColumn(Fct_CalcAccountNoLine(CrMemoLineNR."Gen. Bus. Posting Group", CrMemoLineNR."Gen. Prod. Posting Group", '40'), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

                    ExcelBuf.AddColumn(Format(CrMemoLineNR.Amount, 15, 2), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(CrMemoLineNR."VAT Bus. Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

                    ExcelBuf.AddColumn(CopyStr(CrMemoLineNR."PWD LPSA Description 1", 1, 50), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(CrMemoLineNR."Shortcut Dimension 2 Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('X', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    //ExcelBuf.AddColumn(Fct_CalcShortcutDim3(CrMemoLineNR."Document No.", CrMemoLineNR."Line No.", '40'), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(Fct_CalcShortcutDim3(CrMemoLineNR."Dimension Set ID"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('1900', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(Fct_CalcAccountNo(CrMemoLineNR."Bill-to Customer No."), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('72', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

                    CodGShipNoLine := Fct_CalcShipNoLine(CrMemoLineNR."Appl.-from Item Entry");
                    if CodGShipNoLine = '' then
                        CodGShipNoLine := CodGShipNo
                    else
                        CodGShipNo := CodGShipNoLine;
                    ExcelBuf.AddColumn(CodGShipNoLine, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                end;

                trigger OnPostDataItem()
                begin
                    //?????????????    Sheet.Range('A1:Z65535').Columns.AutoFit;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                ExcelBuf.NewRow();
                ExcelBuf.AddColumn(Format(CrMemoHeaderNR."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>'), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Format(CrMemoHeaderNR."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>'), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('DG', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(CrMemoHeaderNR."No.", FALSE, '', FALSE, FALSE, FALSE, '@', ExcelBuf."Cell Type"::Text);
                if CrMemoHeaderNR."Currency Code" = '' then
                    CodGCurrency := RecGGenLedgerSetup."LCY Code"
                else
                    CodGCurrency := CrMemoHeaderNR."Currency Code";
                ExcelBuf.AddColumn(CodGCurrency, FALSE, '', FALSE, FALSE, FALSE, '@', ExcelBuf."Cell Type"::Text);
                TxtGBarCode := Fct_CalcBarCode(CrMemoHeaderNR."External Document No.");
                ExcelBuf.AddColumn(TxtGBarCode, FALSE, '', FALSE, FALSE, FALSE, '@', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('1900', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(CstG11, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Fct_CalcAccountNo(CrMemoHeaderNR."Bill-to Customer No."), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                CrMemoHeaderNR.CalcFields("Amount Including VAT", Amount);
                ExcelBuf.AddColumn(Format(CrMemoHeaderNR."Amount Including VAT", 15, 2), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                DecGTvaAmount := CrMemoHeaderNR."Amount Including VAT" - CrMemoHeaderNR.Amount;
                ExcelBuf.AddColumn(Format(DecGTvaAmount, 15, 2), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(CrMemoHeaderNR."VAT Bus. Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Fct_CalcText(CrMemoHeaderNR."No.", '11'), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                CodGShipNo := Fct_CalcShipNoHead(CrMemoHeaderNR."No.", '11');
                ExcelBuf.AddColumn(CodGShipNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
            end;

            trigger OnPostDataItem()
            begin
                //????????????    Sheet.Range('A1:Z65535').Columns.AutoFit;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("No.");
                CrMemoHeaderNR.SetRange("Posting Date", DatGStarting, DatGEnding);
            end;
        }
        dataitem(InvoiceHeaderNR; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.") WHERE("PWD Rolex Bienne" = CONST(false));
            dataitem(InvoiceLineNR; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.") WHERE(Type = FILTER(<> " "));

                trigger OnAfterGetRecord()
                begin
                    ExcelBuf.NewRow();
                    ExcelBuf.AddColumn(Format(InvoiceLineNR."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>'), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(Format(InvoiceLineNR."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>'), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('DR', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(InvoiceLineNR."Document No.", FALSE, '', FALSE, FALSE, FALSE, '@', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(CodGCurrency, FALSE, '', FALSE, FALSE, FALSE, '@', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(TxtGBarCode, FALSE, '', FALSE, FALSE, FALSE, '@', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('1900', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(CstG50, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    if InvoiceLineNR.Type = InvoiceLineNR.Type::"G/L Account" then
                        ExcelBuf.AddColumn(InvoiceLineNR."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text)
                    else
                        ExcelBuf.AddColumn(Fct_CalcAccountNoLine(InvoiceLineNR."Gen. Bus. Posting Group", InvoiceLineNR."Gen. Prod. Posting Group", '50'), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

                    ExcelBuf.AddColumn(Format(InvoiceLineNR.Amount, 15, 2), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(InvoiceLineNR."VAT Bus. Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

                    ExcelBuf.AddColumn(CopyStr(InvoiceLineNR."PWD LPSA Description 1", 1, 50), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

                    ExcelBuf.AddColumn(InvoiceLineNR."Shortcut Dimension 2 Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

                    ExcelBuf.AddColumn('X', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    //ExcelBuf.AddColumn(Fct_CalcShortcutDim3(InvoiceLineNR."Document No.", InvoiceLineNR."Line No.", '50'), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(Fct_CalcShortcutDim3(InvoiceLineNR."Dimension Set ID"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('1900', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(Fct_CalcAccountNo(InvoiceLineNR."Bill-to Customer No."), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('72', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    CodGShipNoLine := InvoiceLineNR."Shipment No.";
                    if CodGShipNoLine = '' then
                        CodGShipNoLine := Fct_CalcShipNoLine(InvoiceLineNR."Appl.-from Item Entry");
                    if CodGShipNoLine = '' then
                        CodGShipNoLine := CodGShipNo
                    else
                        CodGShipNo := CodGShipNoLine;

                    ExcelBuf.AddColumn(CodGShipNoLine, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                ExcelBuf.NewRow();
                ExcelBuf.AddColumn(Format(InvoiceHeaderNR."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>'), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Format(InvoiceHeaderNR."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>'), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('DR', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(InvoiceHeaderNR."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                if InvoiceHeaderNR."Currency Code" = '' then
                    CodGCurrency := RecGGenLedgerSetup."LCY Code"
                else
                    CodGCurrency := InvoiceHeaderNR."Currency Code";
                ExcelBuf.AddColumn(CodGCurrency, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                TxtGBarCode := Fct_CalcBarCode(InvoiceHeaderNR."External Document No.");
                ExcelBuf.AddColumn(TxtGBarCode, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('1900', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(CstG01, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Fct_CalcAccountNo(InvoiceHeaderNR."Bill-to Customer No."), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                InvoiceHeaderNR.CalcFields("Amount Including VAT", Amount);
                ExcelBuf.AddColumn(Format(InvoiceHeaderNR."Amount Including VAT", 15, 2), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                DecGTvaAmount := InvoiceHeaderNR."Amount Including VAT" - InvoiceHeaderNR.Amount;
                ExcelBuf.AddColumn(Format(DecGTvaAmount, 15, 2), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(InvoiceHeaderNR."VAT Bus. Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Fct_CalcText(InvoiceHeaderNR."No.", '01'), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                CodGShipNo := Fct_CalcShipNoHead(InvoiceHeaderNR."No.", '01');
                ExcelBuf.AddColumn(CodGShipNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
            end;

            trigger OnPreDataItem()
            begin
                InvoiceHeaderNR.SetRange("Posting Date", DatGStarting, DatGEnding);
            end;
        }
        dataitem(CrMemoHeaderRol; "Sales Cr.Memo Header")
        {
            DataItemTableView = SORTING("No.") WHERE("PWD Rolex Bienne" = CONST(true));
            dataitem(CrMemoLineRol1; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.") WHERE(Type = FILTER(<> " "));

                trigger OnAfterGetRecord()
                begin
                    ExcelBuf.NewRow();
                    ExcelBuf.AddColumn(Format(CrMemoLineRol1."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>'), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(Format(CrMemoLineRol1."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>'), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('DG', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(CrMemoLineRol1."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(CodGCurrency, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(TxtGBarCode, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('1900', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(CstG11, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(TxtGOurAccountNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(Format(CrMemoLineRol1.Amount, 15, 2), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(0, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(CrMemoLineRol1."VAT Bus. Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(CopyStr(CrMemoLineRol1."PWD LPSA Description 1", 1, 50), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(CodGShipNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                end;
            }
            dataitem(CrMemoLineRol2; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.") WHERE(Type = FILTER(<> " "));

                trigger OnAfterGetRecord()
                begin
                    ExcelBuf.NewRow();
                    ExcelBuf.AddColumn(Format(CrMemoLineRol2."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>'), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(Format(CrMemoLineRol2."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>'), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('DG', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(CrMemoLineRol2."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(CodGCurrency, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(TxtGBarCode, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('1900', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(CstG40, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    if CrMemoLineRol2.Type = CrMemoLineRol2.Type::"G/L Account" then
                        ExcelBuf.AddColumn(CrMemoLineRol2."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text)
                    else
                        ExcelBuf.AddColumn(Fct_CalcAccountNoLine(CrMemoLineRol2."Gen. Bus. Posting Group", CrMemoLineRol2."Gen. Prod. Posting Group", '40'), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(Format(CrMemoLineRol2.Amount, 15, 2), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(0, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(CrMemoLineRol2."VAT Bus. Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(CopyStr(CrMemoLineRol2."PWD LPSA Description 1", 1, 50), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(CrMemoLineRol2."Shortcut Dimension 2 Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('X', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    // ExcelBuf.AddColumn(Fct_CalcShortcutDim3(CrMemoLineRol2."Document No.", CrMemoLineRol2."Line No.", '40'), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(Fct_CalcShortcutDim3(CrMemoLineRol2."Dimension Set ID"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('1900', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(Fct_CalcAccountNo(CrMemoLineRol2."Bill-to Customer No."), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('72', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    CodGShipNoLine := Fct_CalcShipNoLine(CrMemoLineRol2."Appl.-from Item Entry");
                    if CodGShipNoLine = '' then
                        CodGShipNoLine := CodGShipNo
                    else
                        CodGShipNo := CodGShipNoLine;
                    ExcelBuf.AddColumn(CodGShipNoLine, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if CrMemoHeaderRol."Currency Code" = '' then
                    CodGCurrency := RecGGenLedgerSetup."LCY Code"
                else
                    CodGCurrency := CrMemoHeaderRol."Currency Code";

                TxtGBarCode := Fct_CalcBarCode(CrMemoHeaderRol."External Document No.");

                TxtGOurAccountNo := Fct_CalcAccountNo(CrMemoHeaderRol."Bill-to Customer No.");

                CodGShipNo := Fct_CalcShipNoHead(CrMemoHeaderRol."No.", '11');
                if CodGShipNo = '' then
                    Message(CstGtxt004, CrMemoHeaderRol."No.");
            end;

            trigger OnPreDataItem()
            begin
                CrMemoHeaderRol.SetRange("Posting Date", DatGStarting, DatGEnding);
            end;
        }
        dataitem(InvoiceHeaderRol; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.") WHERE("PWD Rolex Bienne" = CONST(true));
            dataitem(InvoiceLineRol1; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.") WHERE(Type = FILTER(<> " "));

                trigger OnAfterGetRecord()
                begin
                    ExcelBuf.NewRow();
                    ExcelBuf.AddColumn(Format(InvoiceLineRol1."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>'), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(Format(InvoiceLineRol1."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>'), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('DR', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(InvoiceLineRol1."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(CodGCurrency, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(TxtGBarCode, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('1900', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(CstG01, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(TxtGOurAccountNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(Format(InvoiceLineRol1.Amount, 15, 2), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(0, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(InvoiceLineRol1."VAT Bus. Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(CopyStr("PWD LPSA Description 1", 1, 50), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(CodGShipNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                end;
            }
            dataitem(InvoiceLineRol2; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.") WHERE(Type = FILTER(<> " "));

                trigger OnAfterGetRecord()
                begin
                    ExcelBuf.NewRow();
                    ExcelBuf.AddColumn(Format(InvoiceLineRol2."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>'), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(Format(InvoiceLineRol2."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>'), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('DR', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(InvoiceLineRol2."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(CodGCurrency, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(TxtGBarCode, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('1900', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    //ExcelBuf.AddColumn('50', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(CstG50, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    if InvoiceLineRol2.Type = InvoiceLineRol2.Type::"G/L Account" then
                        ExcelBuf.AddColumn(InvoiceLineRol2."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text)
                    else
                        ExcelBuf.AddColumn(Fct_CalcAccountNoLine(InvoiceLineRol2."Gen. Bus. Posting Group", InvoiceLineRol2."Gen. Prod. Posting Group", '50'), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(Format(InvoiceLineRol2.Amount, 15, 2), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(0, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(InvoiceLineRol2."VAT Bus. Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(CopyStr(InvoiceLineRol2."PWD LPSA Description 1", 1, 50), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(InvoiceLineRol2."Shortcut Dimension 2 Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('X', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    // ExcelBuf.AddColumn(Fct_CalcShortcutDim3(InvoiceLineRol2."Document No.", InvoiceLineRol2."Line No.", '50'), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(Fct_CalcShortcutDim3(InvoiceLineRol2."Dimension Set ID"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('1900', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(Fct_CalcAccountNo(InvoiceLineRol2."Bill-to Customer No."), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('72', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    CodGShipNoLine := InvoiceLineRol2."Shipment No.";
                    if CodGShipNoLine = '' then
                        CodGShipNoLine := Fct_CalcShipNoLine(InvoiceLineRol2."Appl.-from Item Entry");
                    if CodGShipNoLine = '' then
                        CodGShipNoLine := CodGShipNo
                    else
                        CodGShipNo := CodGShipNoLine;
                    ExcelBuf.AddColumn(CodGShipNoLine, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if InvoiceHeaderRol."Currency Code" = '' then
                    CodGCurrency := RecGGenLedgerSetup."LCY Code"
                else
                    CodGCurrency := InvoiceHeaderRol."Currency Code";

                TxtGBarCode := Fct_CalcBarCode(InvoiceHeaderRol."External Document No.");

                TxtGOurAccountNo := Fct_CalcAccountNo(InvoiceHeaderRol."Bill-to Customer No.");

                CodGShipNo := Fct_CalcShipNoHead(InvoiceHeaderRol."No.", '01');
                if CodGShipNo = '' then
                    Message(CstGtxt005, InvoiceHeaderRol."No.");
            end;

            trigger OnPreDataItem()
            begin
                InvoiceHeaderRol.SetRange("Posting Date", DatGStarting, DatGEnding);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(options)
                {
                    Caption = 'options';
                    field(DatStartingF; DatGStarting)
                    {
                        Caption = 'Starting Date';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if DatGStarting = 0D then
                                Error(CstGtxt001);

                            DatGEnding := CalcDate('<CM>', DatGStarting);
                        end;
                    }
                    field(DatEndingF; DatGEnding)
                    {
                        Caption = 'EndingDate';
                        ApplicationArea = All;
                    }
                    field(TxtFilenameF; TxtGFilename)
                    {
                        Caption = 'File Name';
                        Visible = false;
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        ExcelBuf.CreateBookAndOpenExcel('', 'Clients non Rolex', '', COMPANYNAME, USERID);
        Message('Export Excel Terminé');
    end;

    trigger OnPreReport()
    var
        // ThreeTierMngt: Codeunit "File Management";
        // ServerFile: File;
        TempFileName: Text[1024];
    begin
        if DatGStarting = 0D then
            Error(CstGtxt001);
        if DatGEnding = 0D then
            Error(CstGtxt002);
        //IF TxtGFileName = '' THEN
        //  ERROR(CstGTxt003);

        //IF NOT EVALUATE(DatGformat, DatGStarting) THEN
        //  ERROR(CstGtxt001);

        RecGGenLedgerSetup.Get();

        //TODO: The name 'Create' does not exist in the current context
        //Create(Excel, true, true);
        MakeExcelDataHeader();

        // ServerFile.CreateTempFile();
        // TempFileName := ServerFile.Name + '.txt';
        // ServerFile.Close();
        // ServerFile.Create(TempFileName);
        // ServerFile.TextMode := true;
        // ServerFile.Close();


        // TempFileName := ThreeTierMngt.DownloadTempFile(TempFileName);
        // Excel.Workbooks.OpenText(TempFileName);
        // Excel.Visible(true);
        // Sheet := Excel.ActiveSheet;
        // Sheet.Name := 'Clients non Rolex';
        //end;


        //CREATE(Excel);
        //Excel.Visible(TRUE);
        //Book:=Excel.Workbooks.Add;
    end;

    var
        RecGGenLedgerSetup: Record "General Ledger Setup";
        ExcelBuf: record "Excel Buffer" temporary;
        CodGCurrency: Code[10];
        CodGShipNo: Code[20];
        DatGEnding: Date;
        DatGStarting: Date;
        Excel: DotNet "EXCEL ApplicationClass";
        Book: DotNet "EXCEL Workbook";
        Sheet: DotNet "EXCEL Worksheet";
        Compteur: Integer;
        LastFieldNo: Integer;
        CstGtxt001: Label 'The Starting Date  %1 must be filled,';
        CstGtxt002: Label 'The Ending date must be filled,';
        CstGtxt004: Label 'BL not found for lines of CR Memo No. %1. It is necessary to check manually.';
        CstGtxt005: Label 'BL not found for lines of Invoice  No. %1. It is necessary to check manually.';
        TxtGBarCode: Text[15];
        TxtGOurAccountNo: Text[20];
        TxtGFilename: Text[250];
        CodGShipNoLine: Code[20];
        CstG01: Label '01';
        CstG11: Label '11';
        CstG40: Label '40';
        CstG50: Label '50';
        DecGTvaAmount: Decimal;


    procedure Fct_CalcAccountNo(CodPSellToCustNo: Code[20]) TxtLOurAccountNo: Text[20]
    var
        RecLCustomer: Record Customer;
    begin
        TxtLOurAccountNo := '';
        if RecLCustomer.Get(CodPSellToCustNo) then
            TxtLOurAccountNo := RecLCustomer."Our Account No.";

        exit(TxtLOurAccountNo);
    end;


    procedure Fct_CalcText(CodPDocNo: Code[20]; TxtPLineType: Text[2]) TxtLDesc: Text[50]
    var
        RecLSalesCrMemoLine: Record "Sales Cr.Memo Line";
        RecLSalesInvoiceLine: Record "Sales Invoice Line";
        DecLAmount: Decimal;
    begin
        TxtLDesc := '';
        DecLAmount := 0;

        case TxtPLineType of
            '01':
                begin
                    RecLSalesInvoiceLine.Reset();
                    RecLSalesInvoiceLine.SetRange("Document No.", CodPDocNo);

                    if RecLSalesInvoiceLine.FindSet() then
                        repeat
                            if RecLSalesInvoiceLine.Amount > DecLAmount then begin
                                DecLAmount := RecLSalesInvoiceLine.Amount;
                                //TxtLDesc := RecLSalesInvoiceLine.Description;
                                TxtLDesc := CopyStr(RecLSalesInvoiceLine."PWD LPSA Description 1", 1, 50);

                            end;
                        until RecLSalesInvoiceLine.Next() = 0;

                end;

            '11':
                begin
                    RecLSalesCrMemoLine.Reset();
                    RecLSalesCrMemoLine.SetRange("Document No.", CodPDocNo);

                    if RecLSalesCrMemoLine.FindSet() then
                        repeat
                            if RecLSalesCrMemoLine.Amount > DecLAmount then begin
                                DecLAmount := RecLSalesCrMemoLine.Amount;
                                //TxtLDesc := RecLSalesCrMemoLine.Description;
                                TxtLDesc := CopyStr(RecLSalesCrMemoLine."PWD LPSA Description 1", 1, 50);

                            end;
                        until RecLSalesCrMemoLine.Next() = 0;
                end;
        end;

        exit(TxtLDesc);
    end;


    procedure Fct_CalcBarCode(CodPExternalDocno: Code[20]): Text[15]
    var
        TxtLBarCode: Text[15];
    begin
        TxtLBarCode := '';

        //>>Export Rolex
        /*IntLLength := 14 - STRLEN(CodPExternalDocno);
        IF IntLLength > 0 THEN
          TxtLBarCode := COPYSTR(CodPExternalDocno,1,IntLLength)
        ELSE
          TxtLBarCode := COPYSTR(CodPExternalDocno,1,14);
        */
        TxtLBarCode := CopyStr(CodPExternalDocno, 1, 14);
        TxtLBarCode := '''' + TxtLBarCode;
        //<<Export Rolex
        exit(TxtLBarCode);

    end;


    procedure Fct_CalcAccountNoLine(CodPGenBusPostingGroup: Code[10]; CodPGenProdPostingGroup: Code[10]; TxtPLineType: Text[2]) TxtLAccountNo: Text[20]
    var
        RecLGenPostingSetup: Record "General Posting Setup";
    begin
        TxtLAccountNo := '';
        if RecLGenPostingSetup.Get(CodPGenBusPostingGroup, CodPGenProdPostingGroup) then
            if TxtPLineType = '40' then
                TxtLAccountNo := RecLGenPostingSetup."Sales Credit Memo Account"
            else
                TxtLAccountNo := RecLGenPostingSetup."Sales Account";
        exit(TxtLAccountNo);
    end;


    // procedure Fct_CalcShortcutDim3(CodPDocNo: Code[20]; IntPLineNo: Integer; TxtPLineType: Text[2]): Code[20]
    // var

    //     DimSetEntry: Record "Dimension Set Entry";
    //     CodLDimValueCode: Code[20];
    //     IntLTableNo: Integer;
    // begin
    //     CodLDimValueCode := '';

    //     if TxtPLineType = '40' then
    //         IntLTableNo := DATABASE::"Sales Cr.Memo Line"
    //     else
    //         IntLTableNo := DATABASE::"Sales Invoice Line";

    //     if DimSetEntry.Get(IntLTableNo, CodPDocNo, IntPLineNo, RecGGenLedgerSetup."Shortcut Dimension 3 Code") then
    //         CodLDimValueCode := DimSetEntry."Dimension Value Code";

    //     exit(CodLDimValueCode);
    // end;
    procedure Fct_CalcShortcutDim3(DimSetID: Integer): Code[20]
    var

        DimSetEntry: Record "Dimension Set Entry";
        CodLDimValueCode: Code[20];
        IntLTableNo: Integer;
    begin
        CodLDimValueCode := '';
        if DimSetEntry.Get(DimSetID, RecGGenLedgerSetup."Shortcut Dimension 3 Code") then
            CodLDimValueCode := DimSetEntry."Dimension Value Code";

        exit(CodLDimValueCode);
    end;



    procedure Fct_CalcShipNoHead(CodPDocNo: Code[20]; TxtPLineType: Text[2]) CodLShipNo: Code[20]
    var
        RecLItemLedgerEntry: Record "Item Ledger Entry";
        RecLSalesCrMemoLine: Record "Sales Cr.Memo Line";
        RecLSalesInvoiceLine: Record "Sales Invoice Line";
        BooLFound: Boolean;
    begin
        CodLShipNo := '';
        BooLFound := false;


        case TxtPLineType of
            '01':
                begin
                    RecLSalesInvoiceLine.Reset();
                    RecLSalesInvoiceLine.SetRange("Document No.", CodPDocNo);

                    if RecLSalesInvoiceLine.FindSet() then
                        repeat
                            if RecLSalesInvoiceLine."Shipment No." = '' then begin
                                if RecLItemLedgerEntry.Get(RecLSalesInvoiceLine."Appl.-from Item Entry") then
                                    if RecLItemLedgerEntry."Document Type" = RecLItemLedgerEntry."Document Type"::"Sales Shipment" then begin
                                        CodLShipNo := RecLItemLedgerEntry."Document No.";
                                        BooLFound := true;
                                    end;
                            end else begin
                                CodLShipNo := RecLSalesInvoiceLine."Shipment No.";
                                BooLFound := true;
                            end;

                        until ((RecLSalesInvoiceLine.Next() = 0) or (BooLFound = true));

                end;

            '11':
                begin
                    RecLSalesCrMemoLine.Reset();
                    RecLSalesCrMemoLine.SetRange("Document No.", CodPDocNo);

                    if RecLSalesCrMemoLine.FindSet() then
                        repeat
                            if RecLItemLedgerEntry.Get(RecLSalesCrMemoLine."Appl.-from Item Entry") then
                                if RecLItemLedgerEntry."Document Type" = RecLItemLedgerEntry."Document Type"::"Sales Shipment" then begin
                                    CodLShipNo := RecLItemLedgerEntry."Document No.";
                                    BooLFound := true;
                                end;
                        until ((RecLSalesCrMemoLine.Next() = 0) or (BooLFound = true));
                end;
        end;


        exit(CodLShipNo);
    end;

    procedure Fct_CalcShipNoLine(IntPEntryNo: Integer) CodLShipNo: Code[20]
    var
        RecLItemLedgerEntry: Record "Item Ledger Entry";
    begin
        CodLShipNo := '';

        if RecLItemLedgerEntry.Get(IntPEntryNo) then
            if RecLItemLedgerEntry."Document Type" = RecLItemLedgerEntry."Document Type"::"Sales Shipment" then
                CodLShipNo := RecLItemLedgerEntry."Document No.";

        exit(CodLShipNo);
    end;

    Procedure MakeExcelDataHeader()
    begin
        ExcelBuf.NewRow();
        ExcelBuf.AddColumn('DatePieceChar', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('DateComptaChar', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('TypePiece', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Reference ', FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Devise', FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('CodeBarre', FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Societe', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('CleDeCompta', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('ClientCompte', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Montant', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('ValTVA', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('CodeTVA', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Text', FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('CentreProfit', FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('ObjetResultat', FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Article', FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Societe2', FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Client', FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Activité', FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('BLlie', FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
    end;

}