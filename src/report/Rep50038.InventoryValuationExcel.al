report 50038 "PWD Inventory Valuation Excel"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.17
    // P24578_004 : RO : 05/04/2018 : DEMANDES DIVERSES
    //                           - New report copy from R1001

    Caption = 'Inventory Valuation Excel';
    ProcessingOnly = true;
    UsageCategory = none;
    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("Inventory Posting Group");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Inventory Posting Group", "Statistics Group", "Location Code";
            dataitem("Value Entry"; "Value Entry")
            {
                DataItemTableView = SORTING("Item No.", "Posting Date", "Item Ledger Entry Type");

                trigger OnAfterGetRecord()
                begin
                    QtyOnHand := 0;
                    RcdIncreases := 0;
                    ShipDecreases := 0;
                    ValueOfQtyOnHand := 0;
                    ValueOfInvoicedQty := 0;
                    InvoicedQty := 0;

                    ValueOfRcdIncreases := 0;
                    ValueOfInvIncreases := 0;
                    InvIncreases := 0;

                    CostOfShipDecreases := 0;
                    CostOfInvDecreases := 0;
                    InvDecreases := 0;

                    IsPositive := GetSign();
                    if "Item Ledger Entry Quantity" <> 0 then
                        if "Posting Date" < StartDate then
                            QtyOnHand := "Item Ledger Entry Quantity"
                        else
                            if IsPositive then
                                RcdIncreases := "Item Ledger Entry Quantity"
                            else
                                ShipDecreases := -"Item Ledger Entry Quantity";

                    if "Posting Date" < StartDate then
                        SetAmount(ValueOfQtyOnHand, ValueOfInvoicedQty, InvoicedQty, 1)
                    else
                        if IsPositive then
                            SetAmount(ValueOfRcdIncreases, ValueOfInvIncreases, InvIncreases, 1)
                        else
                            SetAmount(CostOfShipDecreases, CostOfInvDecreases, InvDecreases, -1);

                    ValueOfQtyOnHand := ValueOfQtyOnHand + ValueOfInvoicedQty;
                    ValueOfRcdIncreases := ValueOfRcdIncreases + ValueOfInvIncreases;
                    CostOfShipDecreases := CostOfShipDecreases + CostOfInvDecreases;

                    ExpCostPostedToGL := "Expected Cost Posted to G/L";
                    InvCostPostedToGL := "Cost Posted to G/L";
                    CostPostedToGL := ExpCostPostedToGL + InvCostPostedToGL;

                    //>>LAP2.12
                    if BooGExportExcel then begin
                        IntGCounterEntry -= 1;
                        if IntGCounterEntry mod 10 = 0 then
                            Bdialog.Update(3, IntGCounterEntry);
                        DecGTotInvoicedQty += InvoicedQty;
                        DecGTotValueOfInvoicedQty += ValueOfInvoicedQty;
                        DecGTotInvIncreases += InvIncreases;
                        DecGTotValueOfInvIncreases += ValueOfInvIncreases;
                        DecGTotInvDecreases += InvDecreases;
                        DecGTotCostOfInvDecreases += CostOfInvDecreases;
                        DecGTotInvoicedQtyValueEntry += "Value Entry"."Invoiced Quantity";
                        DecGTotCostAmountActValueEntry += "Value Entry"."Cost Amount (Actual)";
                        DecGTotQtyOnHand += QtyOnHand;
                        DecGTotValueOfQtyOnHand += QtyOnHand;
                        DecGTotRcdIncreases += RcdIncreases;
                        DecGTotValueOfRcdIncreases += ValueOfRcdIncreases;
                        DecGTotShipDecreases += ShipDecreases;
                        DecGTotCostOfShipDecreases += CostOfShipDecreases;
                        DecGTotItemLedgEntryQtyValueEn += "Value Entry"."Item Ledger Entry Quantity";
                    end;
                    //<<LAP2.12
                end;

                trigger OnPostDataItem()
                begin
                    //>>LAP2.12
                    if BooGExportExcel and ("Value Entry".Count <> 0) then
                        if ShowExpected and InvAndShipDiffers() then begin
                            IntGLineNo += 1;
                            IntGColNo := 1;

                            EnterCell(IntGLineNo, IntGColNo, Item."No.", false, false, '@');
                            IntGColNo += 1;
                            EnterCell(IntGLineNo, IntGColNo, Item.Description, false, false, '@');
                            IntGColNo += 1;
                            //>>LAP2.17
                            //     EnterCell(IntGLineNo,IntGColNo,FORMAT(Item."Bill of Materials"),FALSE,FALSE,'@');
                            EnterCell(IntGLineNo, IntGColNo, Format("Value Entry"."Location Code"), false, false, '@');
                            //<<LAP2.17
                            IntGColNo += 1;
                            EnterCell(IntGLineNo, IntGColNo, Item."Base Unit of Measure", false, false, '@');
                            IntGColNo += 1;
                            EnterCell(IntGLineNo, IntGColNo, Format(DecGTotQtyOnHand), false, false, '');
                            IntGColNo += 1;
                            EnterCell(IntGLineNo, IntGColNo, Format(DecGTotValueOfQtyOnHand), false, false, '');
                            IntGColNo += 1;
                            EnterCell(IntGLineNo, IntGColNo, Format(DecGTotRcdIncreases), false, false, '');
                            IntGColNo += 1;
                            EnterCell(IntGLineNo, IntGColNo, Format(DecGTotValueOfRcdIncreases), false, false, '');
                            IntGColNo += 1;
                            EnterCell(IntGLineNo, IntGColNo, Format(DecGTotShipDecreases), false, false, '');
                            IntGColNo += 1;
                            EnterCell(IntGLineNo, IntGColNo, Format(DecGTotCostOfShipDecreases), false, false, '');
                            IntGColNo += 1;
                            EnterCell(IntGLineNo, IntGColNo, Format(DecGTotItemLedgEntryQtyValueEn), false, false, '');
                            IntGColNo += 1;
                            EnterCell(IntGLineNo, IntGColNo, Format(DecGTotValueOfQtyOnHand +
                                                                  DecGTotValueOfRcdIncreases - DecGTotCostOfShipDecreases), false, false, '');
                            IntGColNo += 1;

                        end else begin
                            IntGLineNo += 1;
                            IntGColNo := 1;

                            EnterCell(IntGLineNo, IntGColNo, Item."No.", false, false, '@');
                            IntGColNo += 1;
                            EnterCell(IntGLineNo, IntGColNo, Item.Description, false, false, '@');
                            IntGColNo += 1;
                            //>>LAP2.17
                            //     EnterCell(IntGLineNo,IntGColNo,FORMAT(Item."Bill of Materials"),FALSE,FALSE,'@');
                            EnterCell(IntGLineNo, IntGColNo, Format("Value Entry"."Location Code"), false, false, '@');
                            //<<LAP2.17
                            IntGColNo += 1;
                            EnterCell(IntGLineNo, IntGColNo, Item."Base Unit of Measure", false, false, '@');
                            IntGColNo += 1;
                            EnterCell(IntGLineNo, IntGColNo, Format(DecGTotInvoicedQty), false, false, '');
                            IntGColNo += 1;
                            EnterCell(IntGLineNo, IntGColNo, Format(DecGTotValueOfInvoicedQty), false, false, '');
                            IntGColNo += 1;
                            EnterCell(IntGLineNo, IntGColNo, Format(DecGTotInvIncreases), false, false, '');
                            IntGColNo += 1;
                            EnterCell(IntGLineNo, IntGColNo, Format(DecGTotValueOfInvIncreases), false, false, '');
                            IntGColNo += 1;
                            EnterCell(IntGLineNo, IntGColNo, Format(DecGTotInvDecreases), false, false, '');
                            IntGColNo += 1;
                            EnterCell(IntGLineNo, IntGColNo, Format(DecGTotCostOfInvDecreases), false, false, '');
                            IntGColNo += 1;
                            EnterCell(IntGLineNo, IntGColNo, Format(DecGTotInvoicedQtyValueEntry), false, false, '');
                            IntGColNo += 1;
                            EnterCell(IntGLineNo, IntGColNo, Format(DecGTotCostAmountActValueEntry), false, false, '');
                            IntGColNo += 1;

                        end;
                    //<<LAP2.12
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Item No.", Item."No.");
                    SetFilter("Variant Code", Item.GetFilter("Variant Filter"));
                    SetFilter("Location Code", Item.GetFilter("Location Filter"));
                    SetFilter("Global Dimension 1 Code", Item.GetFilter("Global Dimension 1 Filter"));
                    SetFilter("Global Dimension 2 Code", Item.GetFilter("Global Dimension 2 Filter"));
                    if EndDate <> 0D then
                        SetRange("Posting Date", 0D, EndDate);

                    CurrReport.CreateTotals(QtyOnHand, RcdIncreases, ShipDecreases, "Item Ledger Entry Quantity", InvoicedQty, InvIncreases,
                      InvDecreases, "Value Entry"."Invoiced Quantity");
                    CurrReport.CreateTotals(
                      ValueOfQtyOnHand, ValueOfRcdIncreases, CostOfShipDecreases, CostPostedToGL, ExpCostPostedToGL,
                      ValueOfInvoicedQty, ValueOfInvIncreases, CostOfInvDecreases, "Value Entry"."Cost Amount (Actual)",
                      InvCostPostedToGL);

                    //>>LAP2.12
                    if BooGExportExcel then begin
                        IntGCounterEntry := "Value Entry".Count;
                        DecGTotInvoicedQty := 0;
                        DecGTotValueOfInvoicedQty := 0;
                        DecGTotInvIncreases := 0;
                        DecGTotValueOfInvIncreases := 0;
                        DecGTotInvDecreases := 0;
                        DecGTotCostOfInvDecreases := 0;
                        DecGTotInvoicedQtyValueEntry := 0;
                        DecGTotCostAmountActValueEntry := 0;
                        DecGTotQtyOnHand := 0;
                        DecGTotValueOfQtyOnHand := 0;
                        DecGTotRcdIncreases := 0;
                        DecGTotValueOfRcdIncreases := 0;
                        DecGTotShipDecreases := 0;
                        DecGTotCostOfShipDecreases := 0;
                        DecGTotItemLedgEntryQtyValueEn := 0;
                    end;
                    //<<LAP2.12
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CalcFields("Assembly BOM");
                // InvandShipDiffer := false;
                //>>LAP2.12
                if BooGExportExcel then begin
                    IntGCounter -= 1;
                    Bdialog.Update(1, IntGCounter);
                    Bdialog.Update(2, Item."No.");

                end;
                //<<LAP2.12
            end;

            trigger OnPostDataItem()
            begin
                //>>LAP2.12
                if BooGExportExcel then begin
                    Bdialog.Close();
                    //TODO: There is no argument given that corresponds to the required formal parameter 'FileName' of 'CreateBook(Text, Text)'
                    // ExcelBuf.CreateBook;
                    ExcelBuf.WriteSheet(CstG006, CompanyName, UserId);
                    ExcelBuf.OpenExcel();
                    Error('');
                end;
                //<<LAP2.12
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals(QtyOnHand, RcdIncreases, ShipDecreases, "Value Entry"."Item Ledger Entry Quantity");
                CurrReport.CreateTotals(InvoicedQty, InvIncreases, InvDecreases);
                CurrReport.CreateTotals(
                  ValueOfQtyOnHand, ValueOfRcdIncreases, CostOfShipDecreases, CostPostedToGL, ExpCostPostedToGL);
                CurrReport.CreateTotals(
                  ValueOfInvoicedQty, ValueOfInvIncreases, CostOfInvDecreases,
                  "Value Entry"."Cost Amount (Actual)", InvCostPostedToGL);

                //>>LAP2.12
                if BooGExportExcel then begin
                    IntGCounter := Item.Count;
                    Bdialog.Open(CstG007);
                end;
                //<<LAP2.12
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
                    field(StartDateF; StartDate)
                    {
                        Caption = 'Starting Date';
                        ShowCaption = false;
                        ApplicationArea = All;
                    }
                    field(EndDateF; EndDate)
                    {
                        Caption = 'Ending Date';
                        ShowCaption = false;
                        ApplicationArea = All;
                    }
                    field(ShowExpectedF; ShowExpected)
                    {
                        Caption = 'Include Expected Cost';
                        ShowCaption = false;
                        ApplicationArea = All;
                    }
                    field(BooGExportExcelF; BooGExportExcel)
                    {
                        Caption = 'Excel (CSV) Export';
                        Editable = false;
                        ShowCaption = false;
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if (StartDate = 0D) and (EndDate = 0D) then
                EndDate := WorkDate();
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        BooGExportExcel := true;
    end;

    trigger OnPreReport()
    begin
        if (StartDate = 0D) and (EndDate = 0D) then
            EndDate := WorkDate();

        if StartDate in [0D, 00000101D] then
            StartDateText := ''
        else
            StartDateText := Format(StartDate - 1);

        ItemFilter := Item.GetFilters;

        //>>LAP2.12
        if BooGExportExcel then
            MakeHeader();
        //<<LAP2.12
    end;

    var
        ExcelBuf: Record "Excel Buffer" temporary;
        BooGExportExcel: Boolean;
        // InvandShipDiffer: Boolean;
        IsPositive: Boolean;
        ShowExpected: Boolean;
        EndDate: Date;
        StartDate: Date;
        CostOfInvDecreases: Decimal;
        CostOfShipDecreases: Decimal;
        CostPostedToGL: Decimal;
        DecGTotCostAmountActValueEntry: Decimal;
        DecGTotCostOfInvDecreases: Decimal;
        DecGTotCostOfShipDecreases: Decimal;
        DecGTotInvDecreases: Decimal;
        DecGTotInvIncreases: Decimal;
        DecGTotInvoicedQty: Decimal;
        DecGTotInvoicedQtyValueEntry: Decimal;
        DecGTotItemLedgEntryQtyValueEn: Decimal;
        DecGTotQtyOnHand: Decimal;
        DecGTotRcdIncreases: Decimal;
        DecGTotShipDecreases: Decimal;
        DecGTotValueOfInvIncreases: Decimal;
        DecGTotValueOfInvoicedQty: Decimal;
        DecGTotValueOfQtyOnHand: Decimal;
        DecGTotValueOfRcdIncreases: Decimal;
        ExpCostPostedToGL: Decimal;
        InvCostPostedToGL: Decimal;
        InvDecreases: Decimal;
        InvIncreases: Decimal;
        InvoicedQty: Decimal;
        QtyOnHand: Decimal;
        RcdIncreases: Decimal;
        ShipDecreases: Decimal;
        ValueOfInvIncreases: Decimal;
        ValueOfInvoicedQty: Decimal;
        ValueOfQtyOnHand: Decimal;
        ValueOfRcdIncreases: Decimal;
        Bdialog: Dialog;
        IntGColNo: Integer;
        IntGCounter: Integer;
        IntGCounterEntry: Integer;
        IntGLineNo: Integer;
        CstG001: Label 'Input (LCY)';
        CstG002: Label 'Output (LCY)';
        CstG003: Label 'Quantity';
        CstG004: Label 'Value';
        CstG006: Label 'Inventory Valuationn for lines inclusive planned costs';
        CstG007: Label 'Evaluation du stock format CSV\Article restants       #1##########\Article N°             #2##########\Ecritures restantes    #3##########\';
        Text005: Label 'As of %1';
        StartDateText: Text[10];
        ItemFilter: Text[250];


    procedure InvAndShipDiffers(): Boolean
    begin
        exit(
          (QtyOnHand + RcdIncreases - ShipDecreases) <>
          (InvoicedQty + InvIncreases - InvDecreases));
    end;


    procedure GetSign(): Boolean
    begin
        case "Value Entry"."Item Ledger Entry Type" of
            "Value Entry"."Item Ledger Entry Type"::Purchase,
  "Value Entry"."Item Ledger Entry Type"::"Positive Adjmt.",
  "Value Entry"."Item Ledger Entry Type"::Output:
                exit(true);
            "Value Entry"."Item Ledger Entry Type"::Transfer:

                if "Value Entry"."Valued Quantity" < 0 then
                    exit(false)
                else
                    exit(GetOutboundItemEntry("Value Entry"."Item Ledger Entry No."));
            else
                exit(false)
        end;
    end;


    procedure SetAmount(var CostAmtExp: Decimal; var CostAmtActual: Decimal; var InvQty: Decimal; Sign: Integer)
    begin
        CostAmtExp := "Value Entry"."Cost Amount (Expected)" * Sign;
        CostAmtActual := "Value Entry"."Cost Amount (Actual)" * Sign;
        InvQty := "Value Entry"."Invoiced Quantity" * Sign;
    end;

    local procedure GetOutboundItemEntry(ItemLedgerEntryNo: Integer): Boolean
    var
        ItemApplnEntry: Record "Item Application Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        ItemApplnEntry.SetCurrentKey("Item Ledger Entry No.");
        ItemApplnEntry.SetRange("Item Ledger Entry No.", ItemLedgerEntryNo);
        if ItemApplnEntry.IsEmpty then
            exit(true);

        ItemLedgEntry.SetRange("Item No.", Item."No.");
        ItemLedgEntry.SetFilter("Variant Code", Item.GetFilter("Variant Filter"));
        ItemLedgEntry.SetFilter("Location Code", Item.GetFilter("Location Filter"));
        ItemLedgEntry.SetFilter("Global Dimension 1 Code", Item.GetFilter("Global Dimension 1 Filter"));
        ItemLedgEntry.SetFilter("Global Dimension 2 Code", Item.GetFilter("Global Dimension 2 Filter"));
        ItemLedgEntry."Entry No." := ItemApplnEntry."Outbound Item Entry No.";
        exit(ItemLedgEntry.IsEmpty);
    end;


    procedure SetStartDate(DateValue: Date)
    begin
        StartDate := DateValue;
    end;


    procedure SetEndDate(DateValue: Date)
    begin
        EndDate := DateValue;
    end;


    procedure "----- LAP2.12 -----"()
    begin
    end;

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

        IntGColNo += 4;
        EnterCell(IntGLineNo, IntGColNo, StrSubstNo(Text005, StartDateText), true, false, '@');
        IntGColNo += 2;
        EnterCell(IntGLineNo, IntGColNo, CstG001, true, false, '@');
        IntGColNo += 2;
        EnterCell(IntGLineNo, IntGColNo, CstG002, true, false, '@');
        IntGColNo += 2;
        EnterCell(IntGLineNo, IntGColNo, StrSubstNo(Text005, Format(EndDate)), true, false, '@');

        IntGLineNo += 2;
        IntGColNo := 1;

        EnterCell(IntGLineNo, IntGColNo, "Value Entry".FieldCaption("Item No."), true, false, '@');
        IntGColNo += 1;
        EnterCell(IntGLineNo, IntGColNo, "Value Entry".FieldCaption(Description), true, false, '@');
        IntGColNo += 1;
        //>>LAP2.17
        //EnterCell(IntGLineNo,IntGColNo,Item.FIELDCAPTION("Bill of Materials"),TRUE,FALSE,'@');
        EnterCell(IntGLineNo, IntGColNo, "Value Entry".FieldCaption("Location Code"), true, false, '@');
        //<<LAP2.17
        IntGColNo += 1;
        EnterCell(IntGLineNo, IntGColNo, Item.FieldCaption("Base Unit of Measure"), true, false, '@');
        IntGColNo += 1;
        EnterCell(IntGLineNo, IntGColNo, CstG003, true, false, '@');
        IntGColNo += 1;
        EnterCell(IntGLineNo, IntGColNo, CstG004, true, false, '@');
        IntGColNo += 1;
        EnterCell(IntGLineNo, IntGColNo, CstG003, true, false, '@');
        IntGColNo += 1;
        EnterCell(IntGLineNo, IntGColNo, CstG004, true, false, '@');
        IntGColNo += 1;
        EnterCell(IntGLineNo, IntGColNo, CstG003, true, false, '@');
        IntGColNo += 1;
        EnterCell(IntGLineNo, IntGColNo, CstG004, true, false, '@');
        IntGColNo += 1;
        EnterCell(IntGLineNo, IntGColNo, CstG003, true, false, '@');
        IntGColNo += 1;
        EnterCell(IntGLineNo, IntGColNo, CstG004, true, false, '@');
        IntGColNo += 1;
    end;
}

