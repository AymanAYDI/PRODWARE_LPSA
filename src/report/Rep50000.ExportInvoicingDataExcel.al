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

    dataset
    {
        dataitem(CrMemoHeaderNR; "Sales Cr.Memo Header")
        {
            DataItemTableView = SORTING("No.") WHERE("Rolex Bienne" = CONST(false));
            dataitem(CrMemoLineNR; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.") WHERE(Type = FILTER(<> " "));

                trigger OnAfterGetRecord()
                begin

                    Compteur := Compteur + 1;

                    Sheet.Range('A' + Format(Compteur)).Value := Format(CrMemoLineNR."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>');
                    Sheet.Range('B' + Format(Compteur)).Value := Format(CrMemoLineNR."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>');
                    Sheet.Range('C' + Format(Compteur)).Value := 'DG';
                    Sheet.Range('D' + Format(Compteur)).Value := CrMemoLineNR."Document No.";

                    Sheet.Range('E' + Format(Compteur)).Value := CodGCurrency;

                    Sheet.Range('F' + Format(Compteur)).Value := TxtGBarCode;

                    Sheet.Range('G' + Format(Compteur)).Value := '1900';
                    //Sheet.Range('H'+FORMAT(Compteur)).Value:= '40';
                    Sheet.Range('H' + Format(Compteur)).Value := CstG40;

                    if CrMemoLineNR.Type = CrMemoLineNR.Type::"G/L Account" then
                        Sheet.Range('I' + Format(Compteur)).Value := CrMemoLineNR."No."
                    else
                        Sheet.Range('I' + Format(Compteur)).Value := Fct_CalcAccountNoLine(CrMemoLineNR."Gen. Bus. Posting Group",
                                                                                       CrMemoLineNR."Gen. Prod. Posting Group", '40');

                    Sheet.Range('J' + Format(Compteur)).Value := Format(CrMemoLineNR.Amount, 15, 2);

                    //DecGTvaAmount := CrMemoHeaderNR."Amount Including VAT" - CrMemoHeaderNR.Amount;
                    Sheet.Range('K' + Format(Compteur)).Value := '';
                    Sheet.Range('L' + Format(Compteur)).Value := CrMemoLineNR."VAT Bus. Posting Group";

                    //Sheet.Range('M'+FORMAT(Compteur)).Value:= CrMemoLineNR.Description;
                    Sheet.Range('M' + Format(Compteur)).Value := CopyStr(CrMemoLineNR."PWD LPSA Description 1", 1, 50);

                    Sheet.Range('N' + Format(Compteur)).Value := CrMemoLineNR."Shortcut Dimension 2 Code";
                    Sheet.Range('O' + Format(Compteur)).Value := 'X';
                    Sheet.Range('P' + Format(Compteur)).Value := Fct_CalcShortcutDim3(CrMemoLineNR."Document No.", CrMemoLineNR."Line No.", '40');
                    Sheet.Range('Q' + Format(Compteur)).Value := '1900';
                    Sheet.Range('R' + Format(Compteur)).Value := Fct_CalcAccountNo(CrMemoLineNR."Bill-to Customer No.");
                    Sheet.Range('S' + Format(Compteur)).Value := '72';

                    CodGShipNoLine := Fct_CalcShipNoLine(CrMemoLineNR."Appl.-from Item Entry");
                    if CodGShipNoLine = '' then
                        CodGShipNoLine := CodGShipNo
                    else
                        CodGShipNo := CodGShipNoLine;
                    Sheet.Range('T' + Format(Compteur)).Value := CodGShipNoLine;
                end;

                trigger OnPostDataItem()
                begin
                    //?????????????    Sheet.Range('A1:Z65535').Columns.AutoFit;
                end;
            }

            trigger OnAfterGetRecord()
            begin

                Compteur := Compteur + 1;

                Sheet.Range('A' + Format(Compteur)).Value := Format(CrMemoHeaderNR."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>');
                Sheet.Range('B' + Format(Compteur)).Value := Format(CrMemoHeaderNR."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>');
                Sheet.Range('C' + Format(Compteur)).Value := 'DG';
                Sheet.Range('D' + Format(Compteur)).Value := CrMemoHeaderNR."No.";

                if CrMemoHeaderNR."Currency Code" = '' then
                    CodGCurrency := RecGGenLedgerSetup."LCY Code"
                else
                    CodGCurrency := CrMemoHeaderNR."Currency Code";

                Sheet.Range('E' + Format(Compteur)).Value := CodGCurrency;

                TxtGBarCode := Fct_CalcBarCode(CrMemoHeaderNR."External Document No.");
                Sheet.Range('F' + Format(Compteur)).Value := TxtGBarCode;

                Sheet.Range('G' + Format(Compteur)).Value := '1900';
                //Sheet.Range('H'+FORMAT(Compteur)).Value:= '11';
                Sheet.Range('H' + Format(Compteur)).Value := CstG11;

                Sheet.Range('I' + Format(Compteur)).Value := Fct_CalcAccountNo(CrMemoHeaderNR."Bill-to Customer No.");

                CrMemoHeaderNR.CalcFields("Amount Including VAT", Amount);
                Sheet.Range('J' + Format(Compteur)).Value := Format(CrMemoHeaderNR."Amount Including VAT", 15, 2);

                DecGTvaAmount := CrMemoHeaderNR."Amount Including VAT" - CrMemoHeaderNR.Amount;
                Sheet.Range('K' + Format(Compteur)).Value := Format(DecGTvaAmount, 15, 2);
                Sheet.Range('L' + Format(Compteur)).Value := CrMemoHeaderNR."VAT Bus. Posting Group";

                Sheet.Range('M' + Format(Compteur)).Value := Fct_CalcText(CrMemoHeaderNR."No.", '11');
                Sheet.Range('N' + Format(Compteur)).Value := '';
                Sheet.Range('O' + Format(Compteur)).Value := '';
                Sheet.Range('P' + Format(Compteur)).Value := '';
                Sheet.Range('Q' + Format(Compteur)).Value := '';
                Sheet.Range('R' + Format(Compteur)).Value := '';
                Sheet.Range('S' + Format(Compteur)).Value := '';

                CodGShipNo := Fct_CalcShipNoHead(CrMemoHeaderNR."No.", '11');
                Sheet.Range('T' + Format(Compteur)).Value := CodGShipNo;
            end;

            trigger OnPostDataItem()
            begin
                //????????????    Sheet.Range('A1:Z65535').Columns.AutoFit;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("No.");

                //Sheet:=Excel.Sheets.Add;
                //Sheet.Name:='Clients non Rolex';
                Sheet.Range('A1').Value := 'DatePieceChar';
                Sheet.Range('B1').Value := 'DateComptaChar';
                Sheet.Range('C1').Value := 'TypePiece';
                Sheet.Range('D1').Value := 'Reference';
                Sheet.Range('E1').Value := 'Devise';
                Sheet.Range('F1').Value := 'CodeBarre';
                Sheet.Range('G1').Value := 'Societe';
                Sheet.Range('H1').Value := 'CleDeCompta';
                Sheet.Range('I1').Value := 'ClientCompte';
                Sheet.Range('J1').Value := 'Montant';
                Sheet.Range('K1').Value := 'ValTVA';
                Sheet.Range('L1').Value := 'CodeTVA';
                Sheet.Range('M1').Value := 'Text';
                Sheet.Range('N1').Value := 'CentreProfit';
                Sheet.Range('O1').Value := 'ObjetResultat';
                Sheet.Range('P1').Value := 'Article';
                Sheet.Range('Q1').Value := 'Societe2';
                Sheet.Range('R1').Value := 'Client';
                Sheet.Range('S1').Value := 'Activité';
                Sheet.Range('T1').Value := 'BLlie';

                Sheet.Range('A1:T1').Font.Bold := true;
                Sheet.Range('A1:T1').Font.ColorIndex := '2';
                Sheet.Range('A1:T1').Interior.ColorIndex := '55';

                Compteur := 1;

                CrMemoHeaderNR.SetRange("Posting Date", DatGStarting, DatGEnding);
            end;
        }
        dataitem(InvoiceHeaderNR; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.") WHERE("Rolex Bienne" = CONST(false));
            dataitem(InvoiceLineNR; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.") WHERE(Type = FILTER(<> " "));

                trigger OnAfterGetRecord()
                begin
                    Compteur := Compteur + 1;

                    Sheet.Range('A' + Format(Compteur)).Value := Format(InvoiceLineNR."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>');
                    Sheet.Range('B' + Format(Compteur)).Value := Format(InvoiceLineNR."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>');
                    Sheet.Range('C' + Format(Compteur)).Value := 'DR';
                    Sheet.Range('D' + Format(Compteur)).Value := InvoiceLineNR."Document No.";

                    Sheet.Range('E' + Format(Compteur)).Value := CodGCurrency;

                    Sheet.Range('F' + Format(Compteur)).Value := TxtGBarCode;

                    Sheet.Range('G' + Format(Compteur)).Value := '1900';
                    //Sheet.Range('H'+FORMAT(Compteur)).Value:= '50';
                    Sheet.Range('H' + Format(Compteur)).Value := CstG50;

                    if InvoiceLineNR.Type = InvoiceLineNR.Type::"G/L Account" then
                        Sheet.Range('I' + Format(Compteur)).Value := InvoiceLineNR."No."
                    else
                        Sheet.Range('I' + Format(Compteur)).Value := Fct_CalcAccountNoLine(InvoiceLineNR."Gen. Bus. Posting Group",
                                                                                       InvoiceLineNR."Gen. Prod. Posting Group", '50');

                    Sheet.Range('J' + Format(Compteur)).Value := Format(InvoiceLineNR.Amount, 15, 2);

                    //DecGTvaAmount := CrMemoHeaderNR."Amount Including VAT" - CrMemoHeaderNR.Amount;
                    Sheet.Range('K' + Format(Compteur)).Value := '';
                    Sheet.Range('L' + Format(Compteur)).Value := InvoiceLineNR."VAT Bus. Posting Group";

                    //Sheet.Range('M'+FORMAT(Compteur)).Value:= InvoiceLineNR.Description;
                    Sheet.Range('M' + Format(Compteur)).Value := CopyStr(InvoiceLineNR."PWD LPSA Description 1", 1, 50);

                    Sheet.Range('N' + Format(Compteur)).Value := InvoiceLineNR."Shortcut Dimension 2 Code";
                    Sheet.Range('O' + Format(Compteur)).Value := 'X';
                    Sheet.Range('P' + Format(Compteur)).Value := Fct_CalcShortcutDim3(InvoiceLineNR."Document No.", InvoiceLineNR."Line No.", '50');
                    Sheet.Range('Q' + Format(Compteur)).Value := '1900';
                    Sheet.Range('R' + Format(Compteur)).Value := Fct_CalcAccountNo(InvoiceLineNR."Bill-to Customer No.");
                    Sheet.Range('S' + Format(Compteur)).Value := '72';

                    CodGShipNoLine := InvoiceLineNR."Shipment No.";
                    if CodGShipNoLine = '' then
                        CodGShipNoLine := Fct_CalcShipNoLine(InvoiceLineNR."Appl.-from Item Entry");
                    if CodGShipNoLine = '' then
                        CodGShipNoLine := CodGShipNo
                    else
                        CodGShipNo := CodGShipNoLine;
                    Sheet.Range('T' + Format(Compteur)).Value := CodGShipNoLine;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Compteur := Compteur + 1;

                Sheet.Range('A' + Format(Compteur)).Value := Format(InvoiceHeaderNR."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>');
                Sheet.Range('B' + Format(Compteur)).Value := Format(InvoiceHeaderNR."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>');
                Sheet.Range('C' + Format(Compteur)).Value := 'DR';
                Sheet.Range('D' + Format(Compteur)).Value := InvoiceHeaderNR."No.";

                if InvoiceHeaderNR."Currency Code" = '' then
                    CodGCurrency := RecGGenLedgerSetup."LCY Code"
                else
                    CodGCurrency := InvoiceHeaderNR."Currency Code";

                Sheet.Range('E' + Format(Compteur)).Value := CodGCurrency;

                TxtGBarCode := Fct_CalcBarCode(InvoiceHeaderNR."External Document No.");
                Sheet.Range('F' + Format(Compteur)).Value := TxtGBarCode;

                Sheet.Range('G' + Format(Compteur)).Value := '1900';
                //Sheet.Range('H'+FORMAT(Compteur)).Value:= '01;
                Sheet.Range('H' + Format(Compteur)).Value := CstG01;

                //Sheet.Range('H'+FORMAT(Compteur)).Text:= True;

                //Sheet.Range('A1:T1').Text := TRUE;


                Sheet.Range('I' + Format(Compteur)).Value := Fct_CalcAccountNo(InvoiceHeaderNR."Bill-to Customer No.");

                InvoiceHeaderNR.CalcFields("Amount Including VAT", Amount);
                Sheet.Range('J' + Format(Compteur)).Value := Format(InvoiceHeaderNR."Amount Including VAT", 15, 2);

                DecGTvaAmount := InvoiceHeaderNR."Amount Including VAT" - InvoiceHeaderNR.Amount;
                Sheet.Range('K' + Format(Compteur)).Value := Format(DecGTvaAmount, 15, 2);
                Sheet.Range('L' + Format(Compteur)).Value := InvoiceHeaderNR."VAT Bus. Posting Group";

                Sheet.Range('M' + Format(Compteur)).Value := Fct_CalcText(InvoiceHeaderNR."No.", '01');
                Sheet.Range('N' + Format(Compteur)).Value := '';
                Sheet.Range('O' + Format(Compteur)).Value := '';
                Sheet.Range('P' + Format(Compteur)).Value := '';
                Sheet.Range('Q' + Format(Compteur)).Value := '';
                Sheet.Range('R' + Format(Compteur)).Value := '';
                Sheet.Range('S' + Format(Compteur)).Value := '';

                CodGShipNo := Fct_CalcShipNoHead(InvoiceHeaderNR."No.", '01');
                Sheet.Range('T' + Format(Compteur)).Value := CodGShipNo;
            end;

            trigger OnPreDataItem()
            begin
                InvoiceHeaderNR.SetRange("Posting Date", DatGStarting, DatGEnding);
            end;
        }
        dataitem(CrMemoHeaderRol; "Sales Cr.Memo Header")
        {
            DataItemTableView = SORTING("No.") WHERE("Rolex Bienne" = CONST(true));
            dataitem(CrMemoLineRol1; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.") WHERE(Type = FILTER(<> " "));

                trigger OnAfterGetRecord()
                begin

                    Compteur := Compteur + 1;

                    Sheet.Range('A' + Format(Compteur)).Value := Format(CrMemoLineRol1."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>');
                    Sheet.Range('B' + Format(Compteur)).Value := Format(CrMemoLineRol1."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>');
                    Sheet.Range('C' + Format(Compteur)).Value := 'DG';
                    Sheet.Range('D' + Format(Compteur)).Value := CrMemoLineRol1."Document No.";

                    Sheet.Range('E' + Format(Compteur)).Value := CodGCurrency;

                    Sheet.Range('F' + Format(Compteur)).Value := TxtGBarCode;

                    Sheet.Range('G' + Format(Compteur)).Value := '1900';
                    //Sheet.Range('H'+FORMAT(Compteur)).Value:= '11';
                    Sheet.Range('H' + Format(Compteur)).Value := CstG11;

                    Sheet.Range('I' + Format(Compteur)).Value := TxtGOurAccountNo;

                    Sheet.Range('J' + Format(Compteur)).Value := Format(CrMemoLineRol1.Amount, 15, 2);

                    Sheet.Range('K' + Format(Compteur)).Value := 0;
                    Sheet.Range('L' + Format(Compteur)).Value := CrMemoLineRol1."VAT Bus. Posting Group";

                    //Sheet.Range('M'+FORMAT(Compteur)).Value:= CrMemoLineRol1.Description;
                    Sheet.Range('M' + Format(Compteur)).Value := CopyStr(CrMemoLineRol1."PWD LPSA Description 1", 1, 50);

                    Sheet.Range('N' + Format(Compteur)).Value := '';
                    Sheet.Range('O' + Format(Compteur)).Value := '';
                    Sheet.Range('P' + Format(Compteur)).Value := '';
                    Sheet.Range('Q' + Format(Compteur)).Value := '';
                    Sheet.Range('R' + Format(Compteur)).Value := '';
                    Sheet.Range('S' + Format(Compteur)).Value := '';

                    Sheet.Range('T' + Format(Compteur)).Value := CodGShipNo;
                end;
            }
            dataitem(CrMemoLineRol2; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.") WHERE(Type = FILTER(<> " "));

                trigger OnAfterGetRecord()
                begin

                    Compteur := Compteur + 1;

                    Sheet.Range('A' + Format(Compteur)).Value := Format(CrMemoLineRol2."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>');
                    Sheet.Range('B' + Format(Compteur)).Value := Format(CrMemoLineRol2."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>');
                    Sheet.Range('C' + Format(Compteur)).Value := 'DG';
                    Sheet.Range('D' + Format(Compteur)).Value := CrMemoLineRol2."Document No.";

                    Sheet.Range('E' + Format(Compteur)).Value := CodGCurrency;

                    Sheet.Range('F' + Format(Compteur)).Value := TxtGBarCode;

                    Sheet.Range('G' + Format(Compteur)).Value := '1900';
                    //Sheet.Range('H'+FORMAT(Compteur)).Value:= '40';
                    Sheet.Range('H' + Format(Compteur)).Value := CstG40;

                    if CrMemoLineRol2.Type = CrMemoLineRol2.Type::"G/L Account" then
                        Sheet.Range('I' + Format(Compteur)).Value := CrMemoLineRol2."No."
                    else
                        Sheet.Range('I' + Format(Compteur)).Value := Fct_CalcAccountNoLine(CrMemoLineRol2."Gen. Bus. Posting Group",
                                                                                       CrMemoLineRol2."Gen. Prod. Posting Group", '40');

                    Sheet.Range('J' + Format(Compteur)).Value := Format(CrMemoLineRol2.Amount, 15, 2);

                    Sheet.Range('K' + Format(Compteur)).Value := 0;
                    Sheet.Range('L' + Format(Compteur)).Value := CrMemoLineRol2."VAT Bus. Posting Group";

                    //Sheet.Range('M'+FORMAT(Compteur)).Value:= CrMemoLineRol2.Description;
                    Sheet.Range('M' + Format(Compteur)).Value := CopyStr(CrMemoLineRol2."PWD LPSA Description 1", 1, 50);

                    Sheet.Range('N' + Format(Compteur)).Value := CrMemoLineRol2."Shortcut Dimension 2 Code";
                    Sheet.Range('O' + Format(Compteur)).Value := 'X';
                    Sheet.Range('P' + Format(Compteur)).Value := Fct_CalcShortcutDim3(CrMemoLineRol2."Document No.", CrMemoLineRol2."Line No.", '40');
                    Sheet.Range('Q' + Format(Compteur)).Value := '1900';
                    Sheet.Range('R' + Format(Compteur)).Value := Fct_CalcAccountNo(CrMemoLineRol2."Bill-to Customer No.");
                    Sheet.Range('S' + Format(Compteur)).Value := '72';

                    CodGShipNoLine := Fct_CalcShipNoLine(CrMemoLineRol2."Appl.-from Item Entry");
                    if CodGShipNoLine = '' then
                        CodGShipNoLine := CodGShipNo
                    else
                        CodGShipNo := CodGShipNoLine;
                    Sheet.Range('T' + Format(Compteur)).Value := CodGShipNoLine;
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
            DataItemTableView = SORTING("No.") WHERE("Rolex Bienne" = CONST(true));
            dataitem(InvoiceLineRol1; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.") WHERE(Type = FILTER(<> " "));

                trigger OnAfterGetRecord()
                begin
                    Compteur := Compteur + 1;

                    Sheet.Range('A' + Format(Compteur)).Value := Format(InvoiceLineRol1."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>');
                    Sheet.Range('B' + Format(Compteur)).Value := Format(InvoiceLineRol1."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>');
                    Sheet.Range('C' + Format(Compteur)).Value := 'DR';
                    Sheet.Range('D' + Format(Compteur)).Value := InvoiceLineRol1."Document No.";

                    Sheet.Range('E' + Format(Compteur)).Value := CodGCurrency;

                    Sheet.Range('F' + Format(Compteur)).Value := TxtGBarCode;

                    Sheet.Range('G' + Format(Compteur)).Value := '1900';
                    //Sheet.Range('H'+FORMAT(Compteur)).Value:= '01';
                    Sheet.Range('H' + Format(Compteur)).Value := CstG01;

                    Sheet.Range('I' + Format(Compteur)).Value := TxtGOurAccountNo;

                    Sheet.Range('J' + Format(Compteur)).Value := Format(InvoiceLineRol1.Amount, 15, 2);

                    Sheet.Range('K' + Format(Compteur)).Value := 0;
                    Sheet.Range('L' + Format(Compteur)).Value := InvoiceLineRol1."VAT Bus. Posting Group";

                    //Sheet.Range('M'+FORMAT(Compteur)).Value:= InvoiceLineRol1.Description;
                    Sheet.Range('M' + Format(Compteur)).Value := CopyStr("PWD LPSA Description 1", 1, 50);

                    Sheet.Range('N' + Format(Compteur)).Value := '';
                    Sheet.Range('O' + Format(Compteur)).Value := '';
                    Sheet.Range('P' + Format(Compteur)).Value := '';
                    Sheet.Range('Q' + Format(Compteur)).Value := '';
                    Sheet.Range('R' + Format(Compteur)).Value := '';
                    Sheet.Range('S' + Format(Compteur)).Value := '';

                    Sheet.Range('T' + Format(Compteur)).Value := CodGShipNo;
                end;
            }
            dataitem(InvoiceLineRol2; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.") WHERE(Type = FILTER(<> " "));

                trigger OnAfterGetRecord()
                begin
                    Compteur := Compteur + 1;

                    Sheet.Range('A' + Format(Compteur)).Value := Format(InvoiceLineRol2."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>');
                    Sheet.Range('B' + Format(Compteur)).Value := Format(InvoiceLineRol2."Posting Date", 0, '<Day,2>.<Month,2>.<Year4>');
                    Sheet.Range('C' + Format(Compteur)).Value := 'DR';
                    Sheet.Range('D' + Format(Compteur)).Value := InvoiceLineRol2."Document No.";

                    Sheet.Range('E' + Format(Compteur)).Value := CodGCurrency;

                    Sheet.Range('F' + Format(Compteur)).Value := TxtGBarCode;

                    Sheet.Range('G' + Format(Compteur)).Value := '1900';
                    Sheet.Range('H' + Format(Compteur)).Value := '50';
                    Sheet.Range('H' + Format(Compteur)).Value := CstG50;

                    if InvoiceLineRol2.Type = InvoiceLineRol2.Type::"G/L Account" then
                        Sheet.Range('I' + Format(Compteur)).Value := InvoiceLineRol2."No."
                    else
                        Sheet.Range('I' + Format(Compteur)).Value := Fct_CalcAccountNoLine(InvoiceLineRol2."Gen. Bus. Posting Group",
                                                                                       InvoiceLineRol2."Gen. Prod. Posting Group", '50');

                    Sheet.Range('J' + Format(Compteur)).Value := Format(InvoiceLineRol2.Amount, 15, 2);

                    Sheet.Range('K' + Format(Compteur)).Value := 0;
                    Sheet.Range('L' + Format(Compteur)).Value := InvoiceLineRol2."VAT Bus. Posting Group";

                    //Sheet.Range('M'+FORMAT(Compteur)).Value:= InvoiceLineRol2.Description;
                    Sheet.Range('M' + Format(Compteur)).Value := CopyStr(InvoiceLineRol2."PWD LPSA Description 1", 1, 50);

                    Sheet.Range('N' + Format(Compteur)).Value := InvoiceLineRol2."Shortcut Dimension 2 Code";
                    Sheet.Range('O' + Format(Compteur)).Value := 'X';
                    Sheet.Range('P' + Format(Compteur)).Value := Fct_CalcShortcutDim3(InvoiceLineRol2."Document No.", InvoiceLineRol2."Line No.", '50');
                    Sheet.Range('Q' + Format(Compteur)).Value := '1900';
                    Sheet.Range('R' + Format(Compteur)).Value := Fct_CalcAccountNo(InvoiceLineRol2."Bill-to Customer No.");
                    Sheet.Range('S' + Format(Compteur)).Value := '72';

                    CodGShipNoLine := InvoiceLineRol2."Shipment No.";
                    if CodGShipNoLine = '' then
                        CodGShipNoLine := Fct_CalcShipNoLine(InvoiceLineRol2."Appl.-from Item Entry");
                    if CodGShipNoLine = '' then
                        CodGShipNoLine := CodGShipNo
                    else
                        CodGShipNo := CodGShipNoLine;
                    Sheet.Range('T' + Format(Compteur)).Value := CodGShipNoLine;
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
                    field(DatGStarting; DatGStarting)
                    {
                        Caption = 'Starting Date';
                        ShowCaption = false;

                        trigger OnValidate()
                        begin
                            if DatGStarting = 0D then
                                Error(CstGtxt001);

                            DatGEnding := CalcDate('<CM>', DatGStarting);
                        end;
                    }
                    field(DatGEnding; DatGEnding)
                    {
                        Caption = 'EndingDate';
                        ShowCaption = false;
                    }
                    field(TxtGFilename; TxtGFilename)
                    {
                        Caption = 'File Name';
                        OptionCaption = 'File Name';
                        ShowCaption = false;
                        Visible = false;
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
        Message('Export Excel Terminé');
    end;

    trigger OnPreReport()
    var
        ThreeTierMngt: Codeunit "3-Tier Automation Mgt.";
        ServerFileName: Text[1024];
        ServerFile: File;
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


        RecGGenLedgerSetup.Get;


        Create(Excel, true, true);


        if not IsServiceTier then begin
            Excel.Visible(true);
            Book := Excel.Workbooks.Add;
            Sheet := Excel.Sheets.Add;
            Sheet.Name := 'Clients non Rolex';
        end else begin
            ServerFile.CreateTempFile;
            TempFileName := ServerFile.Name + '.txt';
            ServerFile.Close;
            ServerFile.Create(TempFileName);
            ServerFile.TextMode := true;
            ServerFile.Close;

            TempFileName := ThreeTierMngt.DownloadTempFile(TempFileName);

            Excel.Workbooks.OpenText(TempFileName);
            Excel.Visible(true);
            Sheet := Excel.ActiveSheet;
            Sheet.Name := 'Clients non Rolex';
        end;


        //CREATE(Excel);
        //Excel.Visible(TRUE);
        //Book:=Excel.Workbooks.Add;
    end;

    var
        RecGGenLedgerSetup: Record "General Ledger Setup";
        CodGCurrency: Code[10];
        DecGTvaAmount: Decimal;
        TxtGBarCode: Text[15];
        CodGShipNo: Code[20];
        CodGShipNoLine: Code[20];
        LastFieldNo: Integer;
        TxtGOurAccountNo: Text[20];
        Excel: Automation;
        Book: Automation;
        Range: Automation;
        Sheet: Automation;
        Compteur: Integer;
        "No.": Code[20];
        Name: Text[30];
        Address: Text[30];
        "Address 2": Text[30];
        "Post Code": Text[30];
        City: Text[30];
        "Country Code": Text[30];
        "Phone No.": Text[30];
        "Fax No.": Text[30];
        DatGStarting: Date;
        DatGEnding: Date;
        TxtGFilename: Text[250];
        CstGtxt001: Label 'The Starting Date  %1 must be filled,';
        CstGtxt002: Label 'The Ending date must be filled,';
        CstGtxt003: Label 'The field %1 must be filled,';
        CstGtxt004: Label 'BL not found for lines of CR Memo No. %1. It is necessary to check manually.';
        DatGFormat: Date;
        xlApp: Automation;
        xlWorkBook: Automation;
        xlWorkSheet: Automation;
        xlRange: Automation;
        CstGtxt005: Label 'BL not found for lines of Invoice  No. %1. It is necessary to check manually.';
        TxtGFormat: Text[2];
        CstG01: Label '''01';
        CstG11: Label '''11';
        CstG40: Label '''40';
        CstG50: Label '''50';


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
                    RecLSalesInvoiceLine.Reset;
                    RecLSalesInvoiceLine.SetRange("Document No.", CodPDocNo);

                    if RecLSalesInvoiceLine.FindSet then
                        repeat
                            if RecLSalesInvoiceLine.Amount > DecLAmount then begin
                                DecLAmount := RecLSalesInvoiceLine.Amount;
                                //TxtLDesc := RecLSalesInvoiceLine.Description;
                                TxtLDesc := CopyStr(RecLSalesInvoiceLine."PWD LPSA Description 1", 1, 50);

                            end;
                        until RecLSalesInvoiceLine.Next = 0;

                end;

            '11':
                begin
                    RecLSalesCrMemoLine.Reset;
                    RecLSalesCrMemoLine.SetRange("Document No.", CodPDocNo);

                    if RecLSalesCrMemoLine.FindSet then
                        repeat
                            if RecLSalesCrMemoLine.Amount > DecLAmount then begin
                                DecLAmount := RecLSalesCrMemoLine.Amount;
                                //TxtLDesc := RecLSalesCrMemoLine.Description;
                                TxtLDesc := CopyStr(RecLSalesCrMemoLine."PWD LPSA Description 1", 1, 50);

                            end;
                        until RecLSalesCrMemoLine.Next = 0;
                end;
        end;

        exit(TxtLDesc);
    end;


    procedure Fct_CalcBarCode(CodPExternalDocno: Code[20]): Text[15]
    var
        TxtLBarCode: Text[15];
        IntLLength: Integer;
        CstLZero: Label '00000000000000';
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


    procedure Fct_CalcShortcutDim3(CodPDocNo: Code[20]; IntPLineNo: Integer; TxtPLineType: Text[2]): Code[20]
    var
        RecLPostedDocDim: Record "Posted Document Dimension";
        CodLDimValueCode: Code[20];
        IntLTableNo: Integer;
    begin
        CodLDimValueCode := '';

        if TxtPLineType = '40' then
            IntLTableNo := DATABASE::"Sales Cr.Memo Line"
        else
            IntLTableNo := DATABASE::"Sales Invoice Line";

        if RecLPostedDocDim.Get(IntLTableNo, CodPDocNo, IntPLineNo, RecGGenLedgerSetup."Shortcut Dimension 3 Code") then
            CodLDimValueCode := RecLPostedDocDim."Dimension Value Code";

        exit(CodLDimValueCode);
    end;


    procedure Fct_CalcShipNoHead(CodPDocNo: Code[20]; TxtPLineType: Text[2]) CodLShipNo: Code[20]
    var
        RecLSalesCrMemoLine: Record "Sales Cr.Memo Line";
        RecLSalesInvoiceLine: Record "Sales Invoice Line";
        RecLItemLedgerEntry: Record "Item Ledger Entry";
        BooLFound: Boolean;
    begin
        CodLShipNo := '';
        BooLFound := false;


        case TxtPLineType of
            '01':
                begin
                    RecLSalesInvoiceLine.Reset;
                    RecLSalesInvoiceLine.SetRange("Document No.", CodPDocNo);

                    if RecLSalesInvoiceLine.FindSet then
                        repeat
                            if RecLSalesInvoiceLine."Shipment No." = '' then begin
                                if RecLItemLedgerEntry.Get(RecLSalesInvoiceLine."Appl.-from Item Entry") then begin
                                    if RecLItemLedgerEntry."Document Type" = RecLItemLedgerEntry."Document Type"::"Sales Shipment" then begin
                                        CodLShipNo := RecLItemLedgerEntry."Document No.";
                                        BooLFound := true;
                                    end;
                                end;
                            end else begin
                                CodLShipNo := RecLSalesInvoiceLine."Shipment No.";
                                BooLFound := true;
                            end;

                        until ((RecLSalesInvoiceLine.Next = 0) or (BooLFound = true));

                end;

            '11':
                begin
                    RecLSalesCrMemoLine.Reset;
                    RecLSalesCrMemoLine.SetRange("Document No.", CodPDocNo);

                    if RecLSalesCrMemoLine.FindSet then
                        repeat
                            if RecLItemLedgerEntry.Get(RecLSalesCrMemoLine."Appl.-from Item Entry") then begin
                                if RecLItemLedgerEntry."Document Type" = RecLItemLedgerEntry."Document Type"::"Sales Shipment" then begin
                                    CodLShipNo := RecLItemLedgerEntry."Document No.";
                                    BooLFound := true;
                                end;
                            end;
                        until ((RecLSalesCrMemoLine.Next = 0) or (BooLFound = true));
                end;
        end;


        exit(CodLShipNo);
    end;


    procedure Fct_CalcShipNoLine(IntPEntryNo: Integer) CodLShipNo: Code[20]
    var
        RecLSalesCrMemoLine: Record "Sales Cr.Memo Line";
        RecLItemLedgerEntry: Record "Item Ledger Entry";
        BooLFound: Boolean;
    begin
        CodLShipNo := '';

        if RecLItemLedgerEntry.Get(IntPEntryNo) then begin
            if RecLItemLedgerEntry."Document Type" = RecLItemLedgerEntry."Document Type"::"Sales Shipment" then begin
                CodLShipNo := RecLItemLedgerEntry."Document No.";
            end;
        end;

        exit(CodLShipNo);
    end;
}

