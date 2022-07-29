report 50015 "PWD Excel Item Multi-Level"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.07
    // 
    // //>>LAP2.18
    // TDL260619.001 : Prise en compte date début et fin dans sélection ligne de Nomenclature

    Caption = 'Excel Item Multi-Level';
    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Location Code", "Search Description";

            trigger OnAfterGetRecord()
            var
                RecLItemConfig: Record "PWD Item Configurator";
                DecLScrap: Decimal;
            begin
                IntGLineNo += 1;
                IntGColNo := 1;
                DecLScrap := GetScrapFactor("Routing No.");

                EnterCell(IntGLineNo, IntGColNo, "No.", false, false, '@');
                IntGColNo += 1;
                //EnterCell(IntGLineNo,IntGColNo,FORMAT(Item."Order Multiple"),FALSE,FALSE,'0');
                EnterCell(IntGLineNo, IntGColNo, Format(Item."Maximum Order Quantity"), false, false, '0');
                IntGColNo += 1;
                //EnterCell(IntGLineNo,IntGColNo,FORMAT(Item."Order Multiple"*DecLScrap),FALSE,FALSE,'0');
                EnterCell(IntGLineNo, IntGColNo, Format(Item."Maximum Order Quantity" * DecLScrap), false, false, '0');
                IntGColNo += 1;

                GetBOMInfo("Production BOM No.", 2);

                EnterCell(IntGLineNo, IntGColNo, "Search Description", false, false, '@');
                IntGColNo += 1;

                RecLItemConfig.Reset();
                RecLItemConfig.SetCurrentKey("Item Code");
                RecLItemConfig.SetRange("Item Code", "No.");
                if not RecLItemConfig.IsEmpty then begin
                    RecLItemConfig.FindFirst();

                    EnterCell(IntGLineNo, IntGColNo, RecLItemConfig."Piece Type Stone", false, false, '@');
                    IntGColNo += 1;
                    EnterCell(IntGLineNo, IntGColNo, Format(RecLItemConfig.Hole), false, false, '');
                    IntGColNo += 1;
                    EnterCell(IntGLineNo, IntGColNo, Format(RecLItemConfig."External Diameter"), false, false, '');
                    IntGColNo += 1;
                    EnterCell(IntGLineNo, IntGColNo, Format(RecLItemConfig.Thickness), false, false, '');
                    IntGColNo += 1;
                end else begin
                    EnterCell(IntGLineNo, IntGColNo, '', false, false, '@');
                    IntGColNo += 1;
                    EnterCell(IntGLineNo, IntGColNo, '', false, false, '');
                    IntGColNo += 1;
                    EnterCell(IntGLineNo, IntGColNo, '', false, false, '');
                    IntGColNo += 1;
                    EnterCell(IntGLineNo, IntGColNo, '', false, false, '');

                end;
            end;

            trigger OnPostDataItem()
            begin
                ExcelBuf.CreateBook('', 'Feuil1');
                ExcelBuf.WriteSheet(CstG001, CompanyName, UserId);
                ExcelBuf.CloseBook();
                ExcelBuf.OpenExcel();
            end;

            trigger OnPreDataItem()
            begin
                if GetFilter("No.") = '' then
                    SetFilter("No.", RecGInvtSetup."PWD Item Filter Level 1");

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

    trigger OnPreReport()
    begin
        RecGInvtSetup.Get();
        RecGInvtSetup.TestField("PWD Item Filter Level 1");
        RecGInvtSetup.TestField("PWD Item Filter Level 2");
        RecGInvtSetup.TestField("PWD Item Filter Level 3");
        RecGInvtSetup.TestField("PWD Item Filter Level 4");
    end;

    var
        ExcelBuf: Record "Excel Buffer" temporary;
        RecGInvtSetup: Record "Inventory Setup";
        CduGVersionMgt: Codeunit VersionManagement;
        IntGColNo: Integer;
        IntGLineNo: Integer;
        CstG001: Label 'Articles';
        CstG002: Label 'PF';
        CstG003: Label 'Qté max cde';
        CstG004: Label 'Conso';
        CstG005: Label 'GT';
        CstG006: Label 'PP';
        CstG007: Label 'Prep';
        CstG008: Label 'Désignation';
        CstG009: Label 'Type de pièce pierre';
        CstG010: Label 'Trou';
        CstG011: Label 'Diam. extérieur';
        CstG012: Label 'Epaisseur';

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

        EnterCell(IntGLineNo, IntGColNo, CstG002, true, false, '@');
        IntGColNo += 1;
        EnterCell(IntGLineNo, IntGColNo, CstG003, true, false, '@');
        IntGColNo += 1;
        EnterCell(IntGLineNo, IntGColNo, CstG004, true, false, '@');
        IntGColNo += 1;

        EnterCell(IntGLineNo, IntGColNo, CstG005, true, false, '@');
        IntGColNo += 1;
        EnterCell(IntGLineNo, IntGColNo, CstG003, true, false, '@');
        IntGColNo += 1;
        EnterCell(IntGLineNo, IntGColNo, CstG004, true, false, '@');
        IntGColNo += 1;

        EnterCell(IntGLineNo, IntGColNo, CstG006, true, false, '@');
        IntGColNo += 1;
        EnterCell(IntGLineNo, IntGColNo, CstG003, true, false, '@');
        IntGColNo += 1;
        EnterCell(IntGLineNo, IntGColNo, CstG004, true, false, '@');
        IntGColNo += 1;

        EnterCell(IntGLineNo, IntGColNo, CstG007, true, false, '@');
        IntGColNo += 1;
        EnterCell(IntGLineNo, IntGColNo, CstG003, true, false, '@');
        IntGColNo += 1;
        EnterCell(IntGLineNo, IntGColNo, CstG004, true, false, '@');
        IntGColNo += 1;

        EnterCell(IntGLineNo, IntGColNo, CstG008, true, false, '@');
        IntGColNo += 1;
        EnterCell(IntGLineNo, IntGColNo, CstG009, true, false, '@');
        IntGColNo += 1;
        EnterCell(IntGLineNo, IntGColNo, CstG010, true, false, '@');
        IntGColNo += 1;
        EnterCell(IntGLineNo, IntGColNo, CstG011, true, false, '@');
        IntGColNo += 1;
        EnterCell(IntGLineNo, IntGColNo, CstG012, true, false, '@');
        IntGColNo += 1;
    end;


    procedure GetBOMInfo(CodPBOMNo: Code[20]; IntPLevel: Integer)
    var
        RecLItem: Record Item;
        RecLBOMLine: Record "Production BOM Line";
        CodLNextBOM: Code[20];
    begin
        RecLBOMLine.Reset();
        RecLBOMLine.SetRange("Production BOM No.", CodPBOMNo);
        RecLBOMLine.SetRange("Version Code", CduGVersionMgt.GetBOMVersion(CodPBOMNo, Today, true));
        RecLBOMLine.SetRange(Type, RecLBOMLine.Type::Item);
        case IntPLevel of
            2:

                RecLBOMLine.SetFilter("No.", RecGInvtSetup."PWD Item Filter Level 2");
            3:

                RecLBOMLine.SetFilter("No.", RecGInvtSetup."PWD Item Filter Level 3");
            4:

                RecLBOMLine.SetFilter("No.", RecGInvtSetup."PWD Item Filter Level 4");
        end;

        //>>TDL260619.001
        RecLBOMLine.SetFilter("Starting Date", '%1|<=%2', 0D, Today);
        RecLBOMLine.SetFilter("Ending Date", '%1|>=%2', 0D, Today);
        RecLBOMLine.SetFilter("Quantity per", '<>%1', 0);
        //<<TDL260619.001

        if not RecLBOMLine.IsEmpty then begin
            RecLBOMLine.FindFirst();
            RecLItem.Get(RecLBOMLine."No.");

            EnterCell(IntGLineNo, IntGColNo, RecLItem."No.", false, false, '@');
            IntGColNo += 1;
            //  EnterCell(IntGLineNo,IntGColNo,FORMAT(RecLItem."Order Multiple"),FALSE,FALSE,'0');
            EnterCell(IntGLineNo, IntGColNo, Format(RecLItem."Maximum Order Quantity"), false, false, '0');
            IntGColNo += 1;
            //  EnterCell(IntGLineNo,IntGColNo,FORMAT(RecLItem."Order Multiple"*GetScrapFactor(RecLItem."Routing No.")),FALSE,FALSE,'0');
            EnterCell(IntGLineNo, IntGColNo, Format(RecLItem."Maximum Order Quantity" * GetScrapFactor(RecLItem."Routing No.")), false, false, '0');
            IntGColNo += 1;
            CodLNextBOM := RecLItem."Production BOM No.";
        end else begin
            IntGColNo += 3;
            CodLNextBOM := CodPBOMNo;
        end;

        //IF (RecLItem."No." <> '') AND (IntPLevel < 4) THEN BEGIN
        if (IntPLevel < 4) then
            GetBOMInfo(CodLNextBOM, IntPLevel + 1)
        else
            IntGColNo := 13; //il n'y a plus de composant, on force le positionnement à la fin de  la ligne = 13ème colonne
    end;


    procedure GetScrapFactor(CodPRoutingNo: Code[20]): Decimal
    var
        RecLRoutingLine: Record "Routing Line";
        DecLScrap: Decimal;
    begin
        if CodPRoutingNo = '' then
            exit(1);

        DecLScrap := 1;
        RecLRoutingLine.Reset();
        RecLRoutingLine.SetRange("Routing No.", CodPRoutingNo);
        RecLRoutingLine.SetRange("Version Code", CduGVersionMgt.GetRtngVersion(CodPRoutingNo, Today, true));
        RecLRoutingLine.SetFilter("Scrap Factor %", '<>0');
        if RecLRoutingLine.FindSet() then
            repeat
                DecLScrap := DecLScrap * (1 + RecLRoutingLine."Scrap Factor %" / 100);
            until RecLRoutingLine.Next() = 0;
        exit(DecLScrap);
    end;


    procedure GetBOMInfoMulti(CodPBOMNo: Code[20]; IntPLevel: Integer; IntPColNo: Integer; IntPLineNo: Integer)
    var
        RecLItem: Record Item;
        RecLBOMLine: Record "Production BOM Line";
        CodLNextBOM: Code[20];
    begin
        RecLBOMLine.Reset();
        RecLBOMLine.SetRange("Production BOM No.", CodPBOMNo);
        RecLBOMLine.SetRange("Version Code", CduGVersionMgt.GetBOMVersion(CodPBOMNo, Today, true));
        RecLBOMLine.SetRange(Type, RecLBOMLine.Type::Item);
        case IntPLevel of
            2:

                RecLBOMLine.SetFilter("No.", RecGInvtSetup."PWD Item Filter Level 2");
            3:

                RecLBOMLine.SetFilter("No.", RecGInvtSetup."PWD Item Filter Level 3");
            4:

                RecLBOMLine.SetFilter("No.", RecGInvtSetup."PWD Item Filter Level 4");
        end;

        RecLBOMLine.SetFilter("Starting Date", '%1|<=%2', 0D, Today);
        RecLBOMLine.SetFilter("Ending Date", '%1|>=%2', 0D, Today);
        RecLBOMLine.SetFilter("Quantity per", '<>%1', 0);
        if RecLBOMLine.FindSet() then
            repeat
                RecLItem.Get(RecLBOMLine."No.");

                EnterCell(IntPLineNo, IntPColNo, RecLItem."No.", false, false, '@');
                IntPColNo += 1;
                EnterCell(IntPLineNo, IntPColNo, Format(RecLItem."Maximum Order Quantity"), false, false, '0');
                IntPColNo += 1;
                EnterCell(IntPLineNo, IntPColNo, Format(RecLItem."Maximum Order Quantity" * GetScrapFactor(RecLItem."Routing No.")), false, false, '0');
                IntPColNo += 1;
                CodLNextBOM := RecLItem."Production BOM No.";

                if (IntPLevel < 4) then
                    GetBOMInfoMulti(CodLNextBOM, IntPLevel + 1, IntPColNo, IntPLineNo)
                else
                    IntGColNo := 13; //il n'y a plus de composant, on force le positionnement à la fin de  la ligne = 13ème colonne

            until RecLBOMLine.Next() = 0
        else begin
            IntGColNo += 3;
            CodLNextBOM := CodPBOMNo;
        end;
    end;
}

