codeunit 50008 "PWD Calculate Standard Cost"
{

    trigger OnRun()
    begin
    end;

    var
        Text000: Label 'Too many levels. Must be below %1.';
        MfgSetup: Record "Manufacturing Setup";
        GLSetup: Record "General Ledger Setup";
        TempItem: Record Item temporary;
        TempWorkCenter: Record "Work Center" temporary;
        TempMachineCenter: Record "Machine Center" temporary;
        TempPriceListLine: Record "Price List Line" temporary;
        ProdBOMVersionErrBuf: Record "Production BOM Version" temporary;
        RtngVersionErrBuf: Record "Routing Version" temporary;
        CostCalcMgt: Codeunit "Cost Calculation Management";
        VersionMgt: Codeunit VersionManagement;
        UOMMgt: Codeunit "Unit of Measure Management";
        Window: Dialog;
        MaxLevel: Integer;
        NextPriceListLineNo: Integer;
        CalculationDate: Date;
        CalcMultiLevel: Boolean;
        UseAssemblyList: Boolean;
        LogErrors: Boolean;
        Text001: Label '&Top level,&All levels';
        ShowDialog: Boolean;
        StdCostWkshName: Text[50];
        Text002: Label '@1@@@@@@@@@@@@@';
        CalcMfgPrompt: Label 'One or more subassemblies on the assembly list for item %1 use replenishment system Prod. Order. Do you want to calculate standard cost for those subassemblies?';
        TargetText: Label 'Standard Cost,Unit Price';
        RecursionInstruction: Label 'Calculate the %3 of item %1 %2 by rolling up the assembly list components. Select All levels to include and update the %3 of any subassemblies.';
        NonAssemblyItemError: Label 'Item %1 %2 does not use replenishment system Assembly. The %3 will not be calculated.';
        NoAssemblyListError: Label 'Item %1 %2 has no assembly list. The %3 will not be calculated.';
        NonAssemblyComponentWithList: Label 'One or more subassemblies on the assembly list for this item does not use replenishment system Assembly. The %1 for these subassemblies will not be calculated. Are you sure that you want to continue?';
        ColIdx: Option ,StdCost,ExpCost,ActCost,Dev,"Var";
        RowIdx: Option ,MatCost,ResCost,ResOvhd,AsmOvhd,Total;

    procedure SetProperties(NewCalculationDate: Date; NewCalcMultiLevel: Boolean; NewUseAssemblyList: Boolean; NewLogErrors: Boolean; NewStdCostWkshName: Text[50]; NewShowDialog: Boolean)
    begin
        TempItem.DeleteAll();
        ProdBOMVersionErrBuf.DeleteAll();
        RtngVersionErrBuf.DeleteAll();
        ClearAll();

        CalculationDate := NewCalculationDate;
        CalcMultiLevel := NewCalcMultiLevel;
        UseAssemblyList := NewUseAssemblyList;
        LogErrors := NewLogErrors;
        StdCostWkshName := NewStdCostWkshName;
        ShowDialog := NewShowDialog;

        MaxLevel := 50;
        MfgSetup.Get();
        GLSetup.Get();
    end;

    procedure TestPreconditions(var Item: Record Item; var NewProdBOMVersionErrBuf: Record "Production BOM Version"; var NewRtngVersionErrBuf: Record "Routing Version")
    var
        TempItem2: Record Item temporary;
    begin
        CalcItems(Item, TempItem2);

        ProdBOMVersionErrBuf.Reset();
        if ProdBOMVersionErrBuf.Find('-') then
            repeat
                NewProdBOMVersionErrBuf := ProdBOMVersionErrBuf;
                NewProdBOMVersionErrBuf.Insert();
            until ProdBOMVersionErrBuf.Next() = 0;

        RtngVersionErrBuf.Reset();
        if RtngVersionErrBuf.Find('-') then
            repeat
                NewRtngVersionErrBuf := RtngVersionErrBuf;
                NewRtngVersionErrBuf.Insert();
            until RtngVersionErrBuf.Next() = 0;
    end;

    local procedure AnalyzeAssemblyList(var Item: Record Item; var Depth: Integer; var NonAssemblyItemWithList: Boolean; var ContainsProdBOM: Boolean)
    var
        BOMComponent: Record "BOM Component";
        SubItem: Record Item;
        BaseDepth: Integer;
        MaxDepth: Integer;
    begin
        if Item.IsMfgItem and ((Item."Production BOM No." <> '') or (Item."Routing No." <> '')) then begin
            ContainsProdBOM := true;
            if Item."Production BOM No." <> '' then
                AnalyzeProdBOM(Item."Production BOM No.", Depth, NonAssemblyItemWithList, ContainsProdBOM)
            else
                Depth += 1;
            exit
        end;
        BOMComponent.SetRange("Parent Item No.", Item."No.");
        if BOMComponent.FindSet then begin
            if not Item.IsAssemblyItem then begin
                NonAssemblyItemWithList := true;
                exit
            end;
            Depth += 1;
            BaseDepth := Depth;
            repeat
                if BOMComponent.Type = BOMComponent.Type::Item then begin
                    SubItem.Get(BOMComponent."No.");
                    MaxDepth := BaseDepth;
                    AnalyzeAssemblyList(SubItem, MaxDepth, NonAssemblyItemWithList, ContainsProdBOM);
                    if MaxDepth > Depth then
                        Depth := MaxDepth
                end
            until BOMComponent.Next() = 0
        end;
    end;

    local procedure AnalyzeProdBOM(ProductionBOMNo: Code[20]; var Depth: Integer; var NonAssemblyItemWithList: Boolean; var ContainsProdBOM: Boolean)
    var
        ProdBOMLine: Record "Production BOM Line";
        SubItem: Record Item;
        PBOMVersionCode: Code[20];
        BaseDepth: Integer;
        MaxDepth: Integer;
    begin
        SetProdBOMFilters(ProdBOMLine, PBOMVersionCode, ProductionBOMNo);
        if ProdBOMLine.FindSet then begin
            Depth += 1;
            BaseDepth := Depth;
            repeat
                case ProdBOMLine.Type of
                    ProdBOMLine.Type::Item:
                        begin
                            SubItem.Get(ProdBOMLine."No.");
                            MaxDepth := BaseDepth;
                            AnalyzeAssemblyList(SubItem, MaxDepth, NonAssemblyItemWithList, ContainsProdBOM);
                            if MaxDepth > Depth then
                                Depth := MaxDepth
                        end;
                    ProdBOMLine.Type::"Production BOM":
                        begin
                            MaxDepth := BaseDepth;
                            AnalyzeProdBOM(ProdBOMLine."No.", MaxDepth, NonAssemblyItemWithList, ContainsProdBOM);
                            MaxDepth -= 1;
                            if MaxDepth > Depth then
                                Depth := MaxDepth
                        end;
                end;
            until ProdBOMLine.Next() = 0
        end
    end;

    local procedure PrepareAssemblyCalculation(var Item: Record Item; var Depth: Integer; Target: Option "Standard Cost","Unit Price"; var ContainsProdBOM: Boolean) Instruction: Text[1024]
    var
        CalculationTarget: Text[80];
        SubNonAssemblyItemWithList: Boolean;
    begin
        CalculationTarget := SelectStr(Target, TargetText);
        if not Item.IsAssemblyItem then
            Error(NonAssemblyItemError, Item."No.", Item.Description, CalculationTarget);
        AnalyzeAssemblyList(Item, Depth, SubNonAssemblyItemWithList, ContainsProdBOM);
        if Depth = 0 then
            Error(NoAssemblyListError, Item."No.", Item.Description, CalculationTarget);
        Instruction := StrSubstNo(RecursionInstruction, Item."No.", Item.Description, CalculationTarget);
        if SubNonAssemblyItemWithList then
            Instruction += StrSubstNo(NonAssemblyComponentWithList, CalculationTarget)
    end;

    procedure CalcItem(ItemNo: Code[20]; NewUseAssemblyList: Boolean)
    var
        Item: Record Item;
        ItemCostMgt: Codeunit ItemCostManagement;
        Instruction: Text[1024];
        NewCalcMultiLevel: Boolean;
        Depth: Integer;
        AssemblyContainsProdBOM: Boolean;
        CalcMfgItems: Boolean;
        IsHandled: Boolean;
        ShowStrMenu: Boolean;
    begin
        Item.Get(ItemNo);
        IsHandled := false;
        if IsHandled then
            exit;

        if NewUseAssemblyList then
            Instruction := PrepareAssemblyCalculation(Item, Depth, 1, AssemblyContainsProdBOM) // 1=StandardCost
        else
            if not Item.IsMfgItem then
                exit;

        ShowStrMenu := not NewUseAssemblyList or (Depth > 1);
        if ShowStrMenu then
            case StrMenu(Text001, 1, Instruction) of
                0:
                    exit;
                1:
                    NewCalcMultiLevel := false;
                2:
                    NewCalcMultiLevel := true;
            end;

        SetProperties(WorkDate, NewCalcMultiLevel, NewUseAssemblyList, false, '', false);

        if NewUseAssemblyList then begin
            if NewCalcMultiLevel and AssemblyContainsProdBOM then
                CalcMfgItems := Confirm(CalcMfgPrompt, false, Item."No.");
            CalcAssemblyItem(ItemNo, Item, 0, CalcMfgItems)
        end else
            CalcMfgItem(ItemNo, Item, 0);

        if TempItem.Find('-') then
            repeat
                ItemCostMgt.UpdateStdCostShares(TempItem);
            until TempItem.Next() = 0;
    end;

    procedure CalcItems(var Item: Record Item; var NewTempItem: Record Item)
    var
        Item2: Record Item;
        Item3: Record Item;
        RecLRouting: Record "Routing Header";
        RecLBOM: Record "Production BOM Header";
        NoOfRecords: Integer;
        LineCount: Integer;
    begin
        NewTempItem.DeleteAll();

        Item2.Copy(Item);
        NoOfRecords := Item.Count();
        if ShowDialog then
            Window.Open(Text002);

        if Item2.Find('-') then
            repeat
                //>>NICOLAS
                IF ((Item2."Routing No." <> '') AND RecLRouting.GET(Item2."Routing No.") AND
                  (RecLRouting.Status = RecLRouting.Status::Certified))
                AND
                ((Item2."Production BOM No." <> '') AND (RecLBOM.GET(Item2."Production BOM No.")) AND
                  (RecLBOM.Status = RecLBOM.Status::Certified)) THEN BEGIN
                    //<<NICOLAS
                    LineCount := LineCount + 1;
                    if ShowDialog then
                        Window.Update(1, Round(LineCount / NoOfRecords * 10000, 1));
                    if UseAssemblyList then
                        CalcAssemblyItem(Item2."No.", Item3, 0, true)
                    else
                        CalcMfgItem(Item2."No.", Item3, 0);
                    //>>NICOLAS
                END;
            //<<NICOLAS
            until Item2.Next() = 0;

        TempItem.Reset();
        if TempItem.Find('-') then
            repeat
                NewTempItem := TempItem;
                NewTempItem.Insert();
            until TempItem.Next() = 0;

        if ShowDialog then
            Window.Close;
    end;

    local procedure CalcAssemblyItem(ItemNo: Code[20]; var Item: Record Item; Level: Integer; CalcMfgItems: Boolean)
    var
        BOMComp: Record "BOM Component";
        CompItem: Record Item;
        Res: Record Resource;
        LotSize: Decimal;
        ComponentQuantity: Decimal;
    begin
        if Level > MaxLevel then
            Error(Text000, MaxLevel);

        if GetItem(ItemNo, Item) then
            exit;

        if not Item.IsAssemblyItem then
            exit;

        if not CalcMultiLevel and (Level <> 0) then
            exit;

        BOMComp.SetRange("Parent Item No.", ItemNo);
        BOMComp.SetFilter(Type, '<>%1', BOMComp.Type::" ");
        if BOMComp.FindSet then begin
            Item."Rolled-up Material Cost" := 0;
            Item."Rolled-up Capacity Cost" := 0;
            Item."Rolled-up Cap. Overhead Cost" := 0;
            Item."Rolled-up Mfg. Ovhd Cost" := 0;
            Item."Rolled-up Subcontracted Cost" := 0;
            Item."Single-Level Material Cost" := 0;
            Item."Single-Level Capacity Cost" := 0;
            Item."Single-Level Cap. Ovhd Cost" := 0;
            Item."Single-Level Subcontrd. Cost" := 0;
            repeat
                case BOMComp.Type of
                    BOMComp.Type::Item:
                        begin
                            GetItem(BOMComp."No.", CompItem);
                            ComponentQuantity :=
                              BOMComp."Quantity per" *
                              UOMMgt.GetQtyPerUnitOfMeasure(CompItem, BOMComp."Unit of Measure Code");
                            if CompItem.IsInventoriableType() then
                                if CompItem.IsAssemblyItem or CompItem.IsMfgItem then begin
                                    if CompItem.IsAssemblyItem then
                                        CalcAssemblyItem(BOMComp."No.", CompItem, Level + 1, CalcMfgItems)
                                    else
                                        if CalcMfgItems then
                                            CalcMfgItem(BOMComp."No.", CompItem, Level + 1);
                                    Item."Rolled-up Material Cost" += ComponentQuantity * CompItem."Rolled-up Material Cost";
                                    Item."Rolled-up Capacity Cost" += ComponentQuantity * CompItem."Rolled-up Capacity Cost";
                                    Item."Rolled-up Cap. Overhead Cost" += ComponentQuantity * CompItem."Rolled-up Cap. Overhead Cost";
                                    Item."Rolled-up Mfg. Ovhd Cost" += ComponentQuantity * CompItem."Rolled-up Mfg. Ovhd Cost";
                                    Item."Rolled-up Subcontracted Cost" += ComponentQuantity * CompItem."Rolled-up Subcontracted Cost";
                                    Item."Single-Level Material Cost" += ComponentQuantity * CompItem."Standard Cost"
                                end else begin
                                    Item."Rolled-up Material Cost" += ComponentQuantity * CompItem."Unit Cost";
                                    Item."Single-Level Material Cost" += ComponentQuantity * CompItem."Unit Cost"
                                end;
                        end;
                    BOMComp.Type::Resource:
                        begin
                            LotSize := 1;
                            if BOMComp."Resource Usage Type" = BOMComp."Resource Usage Type"::Fixed then
                                if Item."Lot Size" <> 0 then
                                    LotSize := Item."Lot Size";

                            GetResCost(BOMComp."No.", TempPriceListLine);
                            Res.Get(BOMComp."No.");
                            ComponentQuantity :=
                              BOMComp."Quantity per" *
                              UOMMgt.GetResQtyPerUnitOfMeasure(Res, BOMComp."Unit of Measure Code") /
                              LotSize;
                            Item."Single-Level Capacity Cost" += ComponentQuantity * TempPriceListLine."Direct Unit Cost";
                            Item."Single-Level Cap. Ovhd Cost" += ComponentQuantity * (TempPriceListLine."Unit Cost" - TempPriceListLine."Direct Unit Cost");
                        end;
                end;
            until BOMComp.Next() = 0;

            Item."Single-Level Mfg. Ovhd Cost" :=
              Round(
                (Item."Single-Level Material Cost" +
                 Item."Single-Level Capacity Cost" +
                 Item."Single-Level Cap. Ovhd Cost") * Item."Indirect Cost %" / 100 +
                Item."Overhead Rate",
                GLSetup."Unit-Amount Rounding Precision");
            Item."Rolled-up Material Cost" :=
              Round(
                Item."Rolled-up Material Cost",
                GLSetup."Unit-Amount Rounding Precision");
            Item."Rolled-up Capacity Cost" :=
              Round(
                Item."Rolled-up Capacity Cost" + Item."Single-Level Capacity Cost",
                GLSetup."Unit-Amount Rounding Precision");
            Item."Rolled-up Cap. Overhead Cost" :=
              Round(
                Item."Rolled-up Cap. Overhead Cost" + Item."Single-Level Cap. Ovhd Cost",
                GLSetup."Unit-Amount Rounding Precision");
            Item."Rolled-up Mfg. Ovhd Cost" :=
              Round(
                Item."Rolled-up Mfg. Ovhd Cost" + Item."Single-Level Mfg. Ovhd Cost",
                GLSetup."Unit-Amount Rounding Precision");
            Item."Rolled-up Subcontracted Cost" :=
              Round(
                Item."Rolled-up Subcontracted Cost",
                GLSetup."Unit-Amount Rounding Precision");

            Item."Standard Cost" :=
              Round(
                Item."Single-Level Material Cost" +
                Item."Single-Level Capacity Cost" +
                Item."Single-Level Cap. Ovhd Cost" +
                Item."Single-Level Mfg. Ovhd Cost" +
                Item."Single-Level Subcontrd. Cost",
                GLSetup."Unit-Amount Rounding Precision");
            Item."Single-Level Capacity Cost" :=
              Round(
                Item."Single-Level Capacity Cost",
                GLSetup."Unit-Amount Rounding Precision");
            Item."Single-Level Cap. Ovhd Cost" :=
              Round(
                Item."Single-Level Cap. Ovhd Cost",
                GLSetup."Unit-Amount Rounding Precision");

            Item."Last Unit Cost Calc. Date" := CalculationDate;

            TempItem := Item;
            TempItem.Insert
        end
    end;

    procedure CalcAssemblyItemPrice(ItemNo: Code[20])
    var
        Item: Record Item;
        Instruction: Text[1024];
        Depth: Integer;
        NewCalcMultiLevel: Boolean;
        AssemblyContainsProdBOM: Boolean;
    begin
        Item.Get(ItemNo);
        Instruction := PrepareAssemblyCalculation(Item, Depth, 2, AssemblyContainsProdBOM); // 2=UnitPrice
        if Depth > 1 then
            case StrMenu(Text001, 1, Instruction) of
                0:
                    exit;
                1:
                    NewCalcMultiLevel := false;
                2:
                    NewCalcMultiLevel := true;
            end;

        SetProperties(WorkDate, NewCalcMultiLevel, true, false, '', false);

        Item.Get(ItemNo);
        DoCalcAssemblyItemPrice(Item, 0);
    end;

    local procedure DoCalcAssemblyItemPrice(var Item: Record Item; Level: Integer)
    var
        BOMComp: Record "BOM Component";
        CompItem: Record Item;
        CompResource: Record Resource;
        UnitPrice: Decimal;
    begin
        if Level > MaxLevel then
            Error(Text000, MaxLevel);

        if not CalcMultiLevel and (Level <> 0) then
            exit;

        if not Item.IsAssemblyItem then
            exit;

        BOMComp.SetRange("Parent Item No.", Item."No.");
        if BOMComp.Find('-') then begin
            repeat
                case BOMComp.Type of
                    BOMComp.Type::Item:
                        if CompItem.Get(BOMComp."No.") then begin
                            DoCalcAssemblyItemPrice(CompItem, Level + 1);
                            UnitPrice +=
                              BOMComp."Quantity per" *
                              UOMMgt.GetQtyPerUnitOfMeasure(CompItem, BOMComp."Unit of Measure Code") *
                              CompItem."Unit Price";
                        end;
                    BOMComp.Type::Resource:
                        if CompResource.Get(BOMComp."No.") then
                            UnitPrice +=
                              BOMComp."Quantity per" *
                              UOMMgt.GetResQtyPerUnitOfMeasure(CompResource, BOMComp."Unit of Measure Code") *
                              CompResource."Unit Price";
                end
            until BOMComp.Next() = 0;
            UnitPrice := Round(UnitPrice, GLSetup."Unit-Amount Rounding Precision");
            Item.Validate("Unit Price", UnitPrice);
            Item.Modify(true)
        end;
    end;

    local procedure CalcMfgItem(ItemNo: Code[20]; var Item: Record Item; Level: Integer)
    var
        RecLLotSizeStdCost: Record "PWD Lot Size Standard Cost";
        RecLItemTemp: Record Item TEMPORARY;
        LotSize: Decimal;
        MfgItemQtyBase: Decimal;
        SLMat: Decimal;
        SLCap: Decimal;
        SLSub: Decimal;
        SLCapOvhd: Decimal;
        SLMfgOvhd: Decimal;
        RUMat: Decimal;
        RUCap: Decimal;
        RUSub: Decimal;
        RUCapOvhd: Decimal;
        RUMfgOvhd: Decimal;
    begin
        if Level > MaxLevel then
            Error(Text000, MaxLevel);

        if GetItem(ItemNo, Item) then
            exit;

        if not CalcMultiLevel and (Level <> 0) then
            exit;
        //>>FE_LAPIERRETTE_PRO08.001
        WITH Item DO BEGIN
            RecLLotSizeStdCost.RESET;
            RecLLotSizeStdCost.SETRANGE("Item No.", Item."No.");
            RecLLotSizeStdCost.SETRANGE("Item category code", Item."Item Category Code");
            IF RecLLotSizeStdCost.FINDFIRST THEN
                REPEAT
                    RecLItemTemp.RESET;
                    RecLItemTemp.DELETEALL;
                    RecLItemTemp.COPY(Item);

                    LotSize := RecLLotSizeStdCost."Lot Size";
                    IF IsMfgItem THEN BEGIN

                        MfgItemQtyBase := CostCalcMgt.CalcQtyAdjdForBOMScrap(LotSize, "Scrap %");

                        //>>FE_LAPIERRETTE_PROD04.001
                        //STD CalcRtngCost("Routing No.",MfgItemQtyBase,SLCap,SLSub,SLCapOvhd);
                        CalcRtngCost2("Routing No.", MfgItemQtyBase, SLCap, SLSub, SLCapOvhd, ItemNo);
                        //<<FE_LAPIERRETTE_PROD04.001

                        CalcProdBOMCost(
                          RecLItemTemp, "Production BOM No.", "Routing No.",
                          MfgItemQtyBase, TRUE, Level, SLMat, RUMat, RUCap, RUSub, RUCapOvhd, RUMfgOvhd);
                        SLMfgOvhd :=
                          CostCalcMgt.CalcOvhdCost(
                            SLMat + SLCap + SLSub + SLCapOvhd,
                            "Indirect Cost %", "Overhead Rate", LotSize);
                        "Last Unit Cost Calc. Date" := CalculationDate;
                    END
                    ELSE BEGIN
                        SLMat := "Unit Cost";
                        RUMat := "Unit Cost";
                    END;

                    "Single-Level Material Cost" := CalcCostPerUnit(SLMat, LotSize);
                    "Single-Level Capacity Cost" := CalcCostPerUnit(SLCap, LotSize);
                    "Single-Level Subcontrd. Cost" := CalcCostPerUnit(SLSub, LotSize);
                    "Single-Level Cap. Ovhd Cost" := CalcCostPerUnit(SLCapOvhd, LotSize);
                    "Single-Level Mfg. Ovhd Cost" := CalcCostPerUnit(SLMfgOvhd, LotSize);

                    "Rolled-up Material Cost" := CalcCostPerUnit(RUMat, LotSize);
                    "Rolled-up Capacity Cost" := CalcCostPerUnit(RUCap + SLCap, LotSize);
                    "Rolled-up Subcontracted Cost" := CalcCostPerUnit(RUSub + SLSub, LotSize);
                    "Rolled-up Cap. Overhead Cost" := CalcCostPerUnit(RUCapOvhd + SLCapOvhd, LotSize);
                    "Rolled-up Mfg. Ovhd Cost" := CalcCostPerUnit(RUMfgOvhd + SLMfgOvhd, LotSize);

                    RecLLotSizeStdCost."Standard Cost" := "Single-Level Material Cost" +
                                                          "Single-Level Capacity Cost" +
                                                          "Single-Level Subcontrd. Cost" +
                                                          "Single-Level Cap. Ovhd Cost" +
                                                          "Single-Level Mfg. Ovhd Cost";
                    RecLLotSizeStdCost.MODIFY(FALSE);

                    SLMat := 0;
                    RUMat := 0;
                    SLCap := 0;
                    SLSub := 0;
                    SLCapOvhd := 0;
                    SLMfgOvhd := 0;
                    RUCap := 0;
                    RUSub := 0;
                    RUCapOvhd := 0;
                    RUMfgOvhd := 0;
                    "Single-Level Material Cost" := 0;
                    "Single-Level Capacity Cost" := 0;
                    "Single-Level Subcontrd. Cost" := 0;
                    "Single-Level Cap. Ovhd Cost" := 0;
                    "Single-Level Mfg. Ovhd Cost" := 0;
                    "Rolled-up Material Cost" := 0;
                    "Rolled-up Capacity Cost" := 0;
                    "Rolled-up Subcontracted Cost" := 0;
                    "Rolled-up Cap. Overhead Cost" := 0;
                    "Rolled-up Mfg. Ovhd Cost" := 0;


                UNTIL RecLLotSizeStdCost.NEXT = 0;

        END;
        //<<FE_LAPIERRETTE_PRO08.001

        with Item do begin
            LotSize := 1;

            if IsMfgItem then begin
                if "Lot Size" <> 0 then
                    LotSize := "Lot Size";
                MfgItemQtyBase := CostCalcMgt.CalcQtyAdjdForBOMScrap(LotSize, "Scrap %");
                //>>FE_LAPIERRETTE_PROD04.001
                //CalcRtngCost("Routing No.", MfgItemQtyBase, SLCap, SLSub, SLCapOvhd, Item);
                CalcRtngCost2("Routing No.", MfgItemQtyBase, SLCap, SLSub, SLCapOvhd, ItemNo);
                //<<FE_LAPIERRETTE_PROD04.001
                CalcProdBOMCost(
                  Item, "Production BOM No.", "Routing No.",
                  MfgItemQtyBase, true, Level, SLMat, RUMat, RUCap, RUSub, RUCapOvhd, RUMfgOvhd);
                SLMfgOvhd :=
                  CostCalcMgt.CalcOvhdCost(
                    SLMat + SLCap + SLSub + SLCapOvhd,
                    "Indirect Cost %", "Overhead Rate", LotSize);
                "Last Unit Cost Calc. Date" := CalculationDate;
            end else
                if IsAssemblyItem then begin
                    CalcAssemblyItem(ItemNo, Item, Level, true);
                    exit
                end else begin
                    SLMat := "Unit Cost";
                    RUMat := "Unit Cost";
                end;

            "Single-Level Material Cost" := CalcCostPerUnit(SLMat, LotSize);
            "Single-Level Capacity Cost" := CalcCostPerUnit(SLCap, LotSize);
            "Single-Level Subcontrd. Cost" := CalcCostPerUnit(SLSub, LotSize);
            "Single-Level Cap. Ovhd Cost" := CalcCostPerUnit(SLCapOvhd, LotSize);
            "Single-Level Mfg. Ovhd Cost" := CalcCostPerUnit(SLMfgOvhd, LotSize);
            "Rolled-up Material Cost" := CalcCostPerUnit(RUMat, LotSize);
            "Rolled-up Capacity Cost" := CalcCostPerUnit(RUCap + SLCap, LotSize);
            "Rolled-up Subcontracted Cost" := CalcCostPerUnit(RUSub + SLSub, LotSize);
            "Rolled-up Cap. Overhead Cost" := CalcCostPerUnit(RUCapOvhd + SLCapOvhd, LotSize);
            "Rolled-up Mfg. Ovhd Cost" := CalcCostPerUnit(RUMfgOvhd + SLMfgOvhd, LotSize);
            "Standard Cost" :=
              "Single-Level Material Cost" +
              "Single-Level Capacity Cost" +
              "Single-Level Subcontrd. Cost" +
              "Single-Level Cap. Ovhd Cost" +
              "Single-Level Mfg. Ovhd Cost";
        end;

        TempItem := Item;
        TempItem.Insert();
    end;

    local procedure SetProdBOMFilters(var ProdBOMLine: Record "Production BOM Line"; var PBOMVersionCode: Code[20]; ProdBOMNo: Code[20])
    var
        ProdBOMHeader: Record "Production BOM Header";
    begin
        PBOMVersionCode :=
          VersionMgt.GetBOMVersion(ProdBOMNo, CalculationDate, true);
        if PBOMVersionCode = '' then begin
            ProdBOMHeader.Get(ProdBOMNo);
            TestBOMVersionIsCertified(PBOMVersionCode, ProdBOMHeader);
        end;

        with ProdBOMLine do begin
            SetRange("Production BOM No.", ProdBOMNo);
            SetRange("Version Code", PBOMVersionCode);
            SetFilter("Starting Date", '%1|..%2', 0D, CalculationDate);
            SetFilter("Ending Date", '%1|%2..', 0D, CalculationDate);
            SetFilter("No.", '<>%1', '')
        end;
    end;

    local procedure CalcProdBOMCost(MfgItem: Record Item; ProdBOMNo: Code[20]; RtngNo: Code[20]; MfgItemQtyBase: Decimal; IsTypeItem: Boolean; Level: Integer; var SLMat: Decimal; var RUMat: Decimal; var RUCap: Decimal; var RUSub: Decimal; var RUCapOvhd: Decimal; var RUMfgOvhd: Decimal)
    var
        CompItem: Record Item;
        ProdBOMLine: Record "Production BOM Line";
        CompItemQtyBase: Decimal;
        UOMFactor: Decimal;
        PBOMVersionCode: Code[20];
    begin
        if ProdBOMNo = '' then
            exit;

        SetProdBOMFilters(ProdBOMLine, PBOMVersionCode, ProdBOMNo);

        if IsTypeItem then
            UOMFactor := UOMMgt.GetQtyPerUnitOfMeasure(MfgItem, VersionMgt.GetBOMUnitOfMeasure(ProdBOMNo, PBOMVersionCode))
        else
            UOMFactor := 1;

        with ProdBOMLine do begin
            //>>TDL290719.001
            SETFILTER("Quantity per", '<>%1', 0);
            //<<TDL290719.001
            if Find('-') then
                repeat
                    CompItemQtyBase :=
                      CostCalcMgt.CalcCompItemQtyBase(ProdBOMLine, CalculationDate, MfgItemQtyBase, RtngNo, IsTypeItem) / UOMFactor;
                    case Type of
                        Type::Item:
                            begin
                                GetItem("No.", CompItem);
                                if CompItem.IsInventoriableType() then
                                    if CompItem.IsMfgItem() or CompItem.IsAssemblyItem() then begin
                                        CalcMfgItem("No.", CompItem, Level + 1);
                                        IncrCost(SLMat, CompItem."Standard Cost", CompItemQtyBase);
                                        IncrCost(RUMat, CompItem."Rolled-up Material Cost", CompItemQtyBase);
                                        IncrCost(RUCap, CompItem."Rolled-up Capacity Cost", CompItemQtyBase);
                                        IncrCost(RUSub, CompItem."Rolled-up Subcontracted Cost", CompItemQtyBase);
                                        IncrCost(RUCapOvhd, CompItem."Rolled-up Cap. Overhead Cost", CompItemQtyBase);
                                        IncrCost(RUMfgOvhd, CompItem."Rolled-up Mfg. Ovhd Cost", CompItemQtyBase);
                                    end else begin
                                        IncrCost(SLMat, CompItem."Unit Cost", CompItemQtyBase);
                                        IncrCost(RUMat, CompItem."Unit Cost", CompItemQtyBase);
                                    end;
                            end;
                        Type::"Production BOM":
                            CalcProdBOMCost(
                              MfgItem, "No.", RtngNo, CompItemQtyBase, false, Level, SLMat, RUMat, RUCap, RUSub, RUCapOvhd, RUMfgOvhd);
                    end;
                until Next() = 0;
        end;
    end;

    local procedure CalcRtngCost(RtngHeaderNo: Code[20]; MfgItemQtyBase: Decimal; var SLCap: Decimal; var SLSub: Decimal; var SLCapOvhd: Decimal; var ParentItem: Record Item)
    var
        RtngLine: Record "Routing Line";
        RtngHeader: Record "Routing Header";
    begin
        if RtngLine.CertifiedRoutingVersionExists(RtngHeaderNo, CalculationDate) then begin
            if RtngLine."Version Code" = '' then begin
                RtngHeader.Get(RtngHeaderNo);
                TestRtngVersionIsCertified(RtngLine."Version Code", RtngHeader);
            end;

            repeat
                CalcRtngLineCost(RtngLine, MfgItemQtyBase, SLCap, SLSub, SLCapOvhd);
            until RtngLine.Next() = 0;
        end;
    end;

    local procedure CalcRtngCostPerUnit(Type: Enum "Capacity Type Routing"; No: Code[20]; var DirUnitCost: Decimal; var IndirCostPct: Decimal; var OvhdRate: Decimal; var UnitCost: Decimal; var UnitCostCalculation: Option Time,Unit)
    var
        WorkCenter: Record "Work Center";
        MachineCenter: Record "Machine Center";
        IsHandled: Boolean;
    begin
        case Type of
            Type::"Work Center":
                GetWorkCenter(No, WorkCenter);
            Type::"Machine Center":
                GetMachineCenter(No, MachineCenter);
        end;

        IsHandled := false;
        if IsHandled then
            exit;

        CostCalcMgt.RoutingCostPerUnit(
            Type, DirUnitCost, IndirCostPct, OvhdRate, UnitCost, UnitCostCalculation, WorkCenter, MachineCenter);
    end;

    local procedure CalcCostPerUnit(CostPerLot: Decimal; LotSize: Decimal): Decimal
    begin
        exit(Round(CostPerLot / LotSize, GLSetup."Unit-Amount Rounding Precision"));
    end;

    local procedure TestBOMVersionIsCertified(BOMVersionCode: Code[20]; ProdBOMHeader: Record "Production BOM Header")
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit;

        if BOMVersionCode = '' then begin
            if ProdBOMHeader.Status <> ProdBOMHeader.Status::Certified then
                if LogErrors then
                    InsertInErrBuf(ProdBOMHeader."No.", '', false)
                else
                    ProdBOMHeader.TestField(Status, ProdBOMHeader.Status::Certified);
        end;
    end;

    local procedure InsertInErrBuf(No: Code[20]; Version: Code[10]; IsRtng: Boolean)
    begin
        if not LogErrors then
            exit;

        if IsRtng then begin
            RtngVersionErrBuf."Routing No." := No;
            RtngVersionErrBuf."Version Code" := Version;
            if RtngVersionErrBuf.Insert() then;
        end else begin
            ProdBOMVersionErrBuf."Production BOM No." := No;
            ProdBOMVersionErrBuf."Version Code" := Version;
            if ProdBOMVersionErrBuf.Insert() then;
        end;
    end;

    local procedure GetItem(ItemNo: Code[20]; var Item: Record Item) IsInBuffer: Boolean
    var
        StdCostWksh: Record "Standard Cost Worksheet";
    begin
        if TempItem.Get(ItemNo) then begin
            Item := TempItem;
            IsInBuffer := true;
        end else begin
            Item.Get(ItemNo);
            if (StdCostWkshName <> '') and
               not (Item.IsMfgItem or Item.IsAssemblyItem)
            then
                if StdCostWksh.Get(StdCostWkshName, StdCostWksh.Type::Item, ItemNo) then begin
                    Item."Unit Cost" := StdCostWksh."New Standard Cost";
                    Item."Standard Cost" := StdCostWksh."New Standard Cost";
                    Item."Indirect Cost %" := StdCostWksh."New Indirect Cost %";
                    Item."Overhead Rate" := StdCostWksh."New Overhead Rate";
                end;
            IsInBuffer := false;
        end;
    end;

    local procedure GetWorkCenter(No: Code[20]; var WorkCenter: Record "Work Center")
    var
        StdCostWksh: Record "Standard Cost Worksheet";
    begin
        if TempWorkCenter.Get(No) then
            WorkCenter := TempWorkCenter
        else begin
            WorkCenter.Get(No);
            if StdCostWkshName <> '' then
                if StdCostWksh.Get(StdCostWkshName, StdCostWksh.Type::"Work Center", No) then begin
                    WorkCenter."Unit Cost" := StdCostWksh."New Standard Cost";
                    WorkCenter."Indirect Cost %" := StdCostWksh."New Indirect Cost %";
                    WorkCenter."Overhead Rate" := StdCostWksh."New Overhead Rate";
                    WorkCenter."Direct Unit Cost" :=
                      CostCalcMgt.CalcDirUnitCost(
                        StdCostWksh."New Standard Cost", StdCostWksh."New Overhead Rate", StdCostWksh."New Indirect Cost %");
                end;

            TempWorkCenter := WorkCenter;
            TempWorkCenter.Insert();
        end;
    end;

    local procedure GetMachineCenter(No: Code[20]; var MachineCenter: Record "Machine Center")
    var
        StdCostWksh: Record "Standard Cost Worksheet";
    begin
        if TempMachineCenter.Get(No) then
            MachineCenter := TempMachineCenter
        else begin
            MachineCenter.Get(No);
            if StdCostWkshName <> '' then
                if StdCostWksh.Get(StdCostWkshName, StdCostWksh.Type::"Machine Center", No) then begin
                    MachineCenter."Unit Cost" := StdCostWksh."New Standard Cost";
                    MachineCenter."Indirect Cost %" := StdCostWksh."New Indirect Cost %";
                    MachineCenter."Overhead Rate" := StdCostWksh."New Overhead Rate";
                    MachineCenter."Direct Unit Cost" :=
                      CostCalcMgt.CalcDirUnitCost(
                        StdCostWksh."New Standard Cost", StdCostWksh."New Overhead Rate", StdCostWksh."New Indirect Cost %");
                end;
            TempMachineCenter := MachineCenter;
            TempMachineCenter.Insert();
        end;
    end;

    local procedure GetResCost(ResourceNo: Code[20]; var PriceListLine: Record "Price List Line")
    var
        StdCostWksh: Record "Standard Cost Worksheet";
    begin
        TempPriceListLine.SetRange("Asset Type", TempPriceListLine."Asset Type"::Resource);
        TempPriceListLine.SetRange("Asset No.", ResourceNo);
        if TempPriceListLine.FindFirst() then
            PriceListLine := TempPriceListLine
        else begin
            PriceListLine.Init();
            PriceListLine."Price Type" := PriceListLine."Price Type"::Purchase;
            PriceListLine."Asset Type" := PriceListLine."Asset Type"::Resource;
            PriceListLine."Asset No." := ResourceNo;
            PriceListLine."Work Type Code" := '';

            FindResourceCost(PriceListLine);

            if StdCostWkshName <> '' then
                if StdCostWksh.Get(StdCostWkshName, StdCostWksh.Type::Resource, ResourceNo) then begin
                    PriceListLine."Unit Cost" := StdCostWksh."New Standard Cost";
                    PriceListLine."Direct Unit Cost" :=
                        CostCalcMgt.CalcDirUnitCost(
                            StdCostWksh."New Standard Cost",
                            StdCostWksh."New Overhead Rate",
                            StdCostWksh."New Indirect Cost %");
                end;

            TempPriceListLine := PriceListLine;
            NextPriceListLineNo += 1;
            TempPriceListLine."Line No." := NextPriceListLineNo;
            TempPriceListLine.Insert();
        end;
    end;

    local procedure FindResourceCost(var PriceListLine: Record "Price List Line")
    var
        PriceCalculationMgt: Codeunit "Price Calculation Mgt.";
        PriceListLinePrice: Codeunit "Price List Line - Price";
        LineWithPrice: Interface "Line With Price";
        PriceCalculation: Interface "Price Calculation";
        Line: Variant;
        PriceType: Enum "Price Type";
    begin
        LineWithPrice := PriceListLinePrice;
        LineWithPrice.SetLine(PriceType::Purchase, PriceListLine);
        PriceCalculationMgt.GetHandler(LineWithPrice, PriceCalculation);
        PriceCalculation.ApplyPrice(0);
        PriceCalculation.GetLine(Line);
        PriceListLine := Line;
    end;

    local procedure IncrCost(var Cost: Decimal; UnitCost: Decimal; Qty: Decimal)
    begin
        Cost := Cost + (Qty * UnitCost);
    end;

    procedure CalculateAssemblyCostExp(AssemblyHeader: Record "Assembly Header"; var ExpCost: array[5] of Decimal)
    begin
        GLSetup.Get();

        ExpCost[RowIdx::AsmOvhd] :=
          Round(
            CalcOverHeadAmt(
              AssemblyHeader.CalcTotalCost(ExpCost),
              AssemblyHeader."Indirect Cost %",
              AssemblyHeader."Overhead Rate" * AssemblyHeader.Quantity),
            GLSetup."Unit-Amount Rounding Precision");
    end;

    local procedure CalculateAssemblyCostStd(ItemNo: Code[20]; QtyBase: Decimal; var StdCost: array[5] of Decimal)
    var
        Item: Record Item;
        StdTotalCost: Decimal;
    begin
        GLSetup.Get();

        Item.Get(ItemNo);
        StdCost[RowIdx::MatCost] :=
          Round(
            Item."Single-Level Material Cost" * QtyBase,
            GLSetup."Unit-Amount Rounding Precision");
        StdCost[RowIdx::ResCost] :=
          Round(
            Item."Single-Level Capacity Cost" * QtyBase,
            GLSetup."Unit-Amount Rounding Precision");
        StdCost[RowIdx::ResOvhd] :=
          Round(
            Item."Single-Level Cap. Ovhd Cost" * QtyBase,
            GLSetup."Unit-Amount Rounding Precision");
        StdTotalCost := StdCost[RowIdx::MatCost] + StdCost[RowIdx::ResCost] + StdCost[RowIdx::ResOvhd];
        StdCost[RowIdx::AsmOvhd] :=
          Round(
            CalcOverHeadAmt(
              StdTotalCost,
              Item."Indirect Cost %",
              Item."Overhead Rate" * QtyBase),
            GLSetup."Unit-Amount Rounding Precision");
    end;

    procedure CalcOverHeadAmt(CostAmt: Decimal; IndirectCostPct: Decimal; OverheadRateAmt: Decimal): Decimal
    begin
        exit(CostAmt * IndirectCostPct / 100 + OverheadRateAmt);
    end;

    local procedure CalculatePostedAssemblyCostExp(PostedAssemblyHeader: Record "Posted Assembly Header"; var ExpCost: array[5] of Decimal)
    begin
        GLSetup.Get();

        ExpCost[RowIdx::AsmOvhd] :=
          Round(
            CalcOverHeadAmt(
              PostedAssemblyHeader.CalcTotalCost(ExpCost),
              PostedAssemblyHeader."Indirect Cost %",
              PostedAssemblyHeader."Overhead Rate" * PostedAssemblyHeader.Quantity),
            GLSetup."Unit-Amount Rounding Precision");
    end;

    local procedure CalcTotalAndVar(var Value: array[5, 5] of Decimal)
    begin
        CalcTotal(Value);
        CalcVariance(Value);
    end;

    local procedure CalcTotal(var Value: array[5, 5] of Decimal)
    var
        RowId: Integer;
        ColId: Integer;
    begin
        for ColId := 1 to 3 do begin
            Value[ColId, 5] := 0;
            for RowId := 1 to 4 do
                Value[ColId, 5] += Value[ColId, RowId];
        end;
    end;

    local procedure CalcVariance(var Value: array[5, 5] of Decimal)
    var
        i: Integer;
    begin
        for i := 1 to 5 do begin
            Value[ColIdx::Dev, i] := CalcIndicatorPct(Value[ColIdx::StdCost, i], Value[ColIdx::ActCost, i]);
            Value[ColIdx::"Var", i] := Value[ColIdx::ActCost, i] - Value[ColIdx::StdCost, i];
        end;
    end;

    local procedure CalcIndicatorPct(Value: Decimal; "Sum": Decimal): Decimal
    begin
        if Value = 0 then
            exit(0);

        exit(Round((Sum - Value) / Value * 100, 1));
    end;

    procedure CalcAsmOrderStatistics(AssemblyHeader: Record "Assembly Header"; var Value: array[5, 5] of Decimal)
    begin
        CalculateAssemblyCostStd(
          AssemblyHeader."Item No.",
          AssemblyHeader."Quantity (Base)",
          Value[ColIdx::StdCost]);
        CalculateAssemblyCostExp(AssemblyHeader, Value[ColIdx::ExpCost]);
        AssemblyHeader.CalcActualCosts(Value[ColIdx::ActCost]);
        CalcTotalAndVar(Value);
    end;

    procedure CalcPostedAsmOrderStatistics(PostedAssemblyHeader: Record "Posted Assembly Header"; var Value: array[5, 5] of Decimal)
    begin
        CalculateAssemblyCostStd(
          PostedAssemblyHeader."Item No.",
          PostedAssemblyHeader."Quantity (Base)",
          Value[ColIdx::StdCost]);
        CalculatePostedAssemblyCostExp(PostedAssemblyHeader, Value[ColIdx::ExpCost]);
        PostedAssemblyHeader.CalcActualCosts(Value[ColIdx::ActCost]);
        CalcTotalAndVar(Value);
    end;

    procedure CalcRtngLineCost(RoutingLine: Record "Routing Line"; MfgItemQtyBase: Decimal; var SLCap: Decimal; var SLSub: Decimal; var SLCapOvhd: Decimal)
    var
        WorkCenter: Record "Work Center";
        CostCalculationMgt: Codeunit "Cost Calculation Management";
        UnitCost: Decimal;
        DirUnitCost: Decimal;
        IndirCostPct: Decimal;
        OvhdRate: Decimal;
        CostTime: Decimal;
        UnitCostCalculation: Option;
    begin
        with RoutingLine do begin
            if (Type = Type::"Work Center") and ("No." <> '') then
                WorkCenter.Get("No.");

            UnitCost := "Unit Cost per";
            CalcRtngCostPerUnit(Type, "No.", DirUnitCost, IndirCostPct, OvhdRate, UnitCost, UnitCostCalculation);
            CostTime :=
              CostCalculationMgt.CalcCostTime(
                MfgItemQtyBase,
                "Setup Time", "Setup Time Unit of Meas. Code",
                "Run Time", "Run Time Unit of Meas. Code", "Lot Size",
                "Scrap Factor % (Accumulated)", "Fixed Scrap Qty. (Accum.)",
                "Work Center No.", UnitCostCalculation, MfgSetup."Cost Incl. Setup",
                "Concurrent Capacities");

            if (Type = Type::"Work Center") and (WorkCenter."Subcontractor No." <> '') then
                IncrCost(SLSub, DirUnitCost, CostTime)
            else
                IncrCost(SLCap, DirUnitCost, CostTime);
            IncrCost(SLCapOvhd, CostCalcMgt.CalcOvhdCost(DirUnitCost, IndirCostPct, OvhdRate, 1), CostTime);
        end;
    end;

    local procedure TestRtngVersionIsCertified(RtngVersionCode: Code[20]; RtngHeader: Record "Routing Header")
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit;

        if RtngVersionCode = '' then
            if RtngHeader.Status <> RtngHeader.Status::Certified then
                if LogErrors then
                    InsertInErrBuf(RtngHeader."No.", '', true)
                else
                    RtngHeader.TestField(Status, RtngHeader.Status::Certified);
    end;

    LOCAL PROCEDURE CalcRtngCost2(RtngHeaderNo: Code[20]; MfgItemQtyBase: Decimal; VAR SLCap: Decimal; VAR SLSub: Decimal; VAR SLCapOvhd: Decimal; CodPItemNo: Code[20])
    VAR
        WorkCenter: Record "Work Center";
        RtngHeader: Record "Routing Header";
        RtngVersion: Record "Routing Version";
        RtngLine: Record "Routing Line";
        CostCalcMgt: Codeunit "Cost Calculation Management";
        CheckRouting: Codeunit "Check Routing Lines";
        CduLCalculateProdOrder: Codeunit "Calculate Prod. Order";
        LPSAFunctionsMgt: codeunit "PWD LPSA Functions Mgt.";
        RtngVersionCode: Code[10];
        UnitCost: Decimal;
        DirUnitCost: Decimal;
        IndirCostPct: Decimal;
        OvhdRate: Decimal;
        CostTime: Decimal;
        UnitCostCalculation: Option;
        DecLRunTime: Decimal;
        DecLSetupTime: Decimal;
        CodLSetupTimeUnit: Code[10];
        CodLRunTimeUnit: Code[10];
    BEGIN
        if RtngLine.CertifiedRoutingVersionExists(RtngHeaderNo, CalculationDate) then
            if RtngLine."Version Code" = '' then begin
                RtngHeader.Get(RtngHeaderNo);
                TestRtngVersionIsCertified(RtngLine."Version Code", RtngHeader);
            end;
        WITH RtngLine DO
            REPEAT
                IF (Type = Type::"Work Center") AND ("No." <> '') THEN
                    WorkCenter.GET("No.")
                ELSE
                    CLEAR(WorkCenter);
                UnitCost := "Unit Cost per";
                CalcRtngCostPerUnit(Type, "No.", DirUnitCost, IndirCostPct, OvhdRate, UnitCost, UnitCostCalculation);

                //>>FE_LAPIERRETTE_PROD04.001
                IF RtngLine."PWD Fixed-step Prod. Rate time" THEN BEGIN
                    LPSAFunctionsMgt.FctGetTimeForCost(RtngLine.Type, RtngLine."No.", CodPItemNo, MfgItemQtyBase, DecLSetupTime, DecLRunTime, CodLSetupTimeUnit, CodLRunTimeUnit);
                    CostTime :=
                      CostCalcMgt.CalcCostTime(
                        MfgItemQtyBase,
                        DecLSetupTime, CodLSetupTimeUnit,
                        DecLRunTime, CodLRunTimeUnit, "Lot Size",
                        "Scrap Factor % (Accumulated)", "Fixed Scrap Qty. (Accum.)",
                        "Work Center No.", UnitCostCalculation, MfgSetup."Cost Incl. Setup",
                        "Concurrent Capacities");

                END ELSE
                    //<<FE_LAPIERRETTE_PROD04.001

                    CostTime :=
                CostCalcMgt.CalcCostTime(
                  MfgItemQtyBase,
                  "Setup Time", "Setup Time Unit of Meas. Code",
                  "Run Time", "Run Time Unit of Meas. Code", "Lot Size",
                  "Scrap Factor % (Accumulated)", "Fixed Scrap Qty. (Accum.)",
                  "Work Center No.", UnitCostCalculation, MfgSetup."Cost Incl. Setup",
                  "Concurrent Capacities");

                IF (Type = Type::"Work Center") AND
                   (WorkCenter."Subcontractor No." <> '')
                THEN
                    IncrCost(SLSub, DirUnitCost, CostTime)
                ELSE
                    IncrCost(SLCap, DirUnitCost, CostTime);
                IncrCost(SLCapOvhd, CostCalcMgt.CalcOvhdCost(DirUnitCost, IndirCostPct, OvhdRate, 1), CostTime);
            UNTIL NEXT() = 0;
    end;

    PROCEDURE CalcMiddleLotSize(CodPitemNo: Code[20]; DecPLotSizeItem: Decimal): Decimal
    VAR
        RecLProdOrdLine: Record "Prod. Order Line";
        DatLBegin: Date;
        DatLEnd: Date;
        IntLCount: Integer;
        DecLSum: Decimal;
        DecLMiddle: Decimal;
        DecLLotSizeItem: Decimal;
    BEGIN
        //===Calc Middle for Lot Size========================================
        EVALUATE(DatLBegin, '01/01/' + FORMAT(DATE2DWY(WORKDATE, 3)));
        EVALUATE(DatLEnd, '31/12/' + FORMAT(DATE2DWY(WORKDATE, 3)));
        IntLCount := 0;
        DecLSum := 0;
        DecLMiddle := 1;
        DecLLotSizeItem := DecPLotSizeItem;
        RecLProdOrdLine.RESET;
        RecLProdOrdLine.SETRANGE("Item No.", CodPitemNo);
        RecLProdOrdLine.SETRANGE(Status, 4);
        RecLProdOrdLine.SETRANGE("Ending Date", DatLBegin, DatLEnd);
        IF RecLProdOrdLine.FINDFIRST THEN
            REPEAT
                IntLCount += 1;
                DecLSum += RecLProdOrdLine.Quantity;
            UNTIL RecLProdOrdLine.NEXT = 0;

        IF IntLCount <> 0 THEN
            DecLMiddle := ROUND(DecLSum / IntLCount, 0.01, '>')
        ELSE
            IF DecLLotSizeItem > DecLMiddle THEN
                DecLMiddle := DecLLotSizeItem;

        EXIT(DecLMiddle);
    END;

    PROCEDURE FctCalcItemMonoLevel(ItemNo: Code[20]; NewUseAssemblyList: Boolean);
    VAR
        Item: Record Item;
        ItemCostMgt: Codeunit ItemCostManagement;
        NewCalcMultiLevel: Boolean;
        CalcMfgItems: Boolean;
    BEGIN
        NewCalcMultiLevel := FALSE;

        SetProperties(WORKDATE, NewCalcMultiLevel, NewUseAssemblyList, FALSE, '', FALSE);

        IF NewUseAssemblyList THEN
            CalcAssemblyItem(ItemNo, Item, 0, CalcMfgItems)
        ELSE
            CalcMfgItem(ItemNo, Item, 0);

        IF TempItem.FIND('-') THEN
            REPEAT
                ItemCostMgt.UpdateStdCostShares(TempItem);
            UNTIL TempItem.NEXT = 0;
    END;

    PROCEDURE CalculateCost(RecPItem: Record Item)
    VAR
        RecLRoutingHeader: Record "Routing Header";
        RecLProductionBOMHeader: Record "Production BOM Header";
        RecLBOMLine: Record "Production BOM Line";
        RecLItem: Record Item;
        TxtL50000: label 'Item Cost can''t be calculated. The component %1 is not valued.';
    BEGIN
        //>>TDL290719.001
        //>>TDL100220.001
        //IF (RecPItem."Replenishment System" = RecPItem."Replenishment System"::Purchase) AND (RecPItem."Unit Cost" = 0) THEN
        //    ERROR(TxtL50000,RecPItem."No.");
        IF RecPItem."Replenishment System" = RecPItem."Replenishment System"::Purchase THEN BEGIN
            IF ((RecPItem."Costing Method" = RecPItem."Costing Method"::Standard) AND (RecPItem."Standard Cost" = 0))
               OR
               ((RecPItem."Costing Method" = RecPItem."Costing Method"::Average) AND (RecPItem."Unit Cost" = 0))
            THEN
                //>>NDBI
                IF RecPItem."Inventory Posting Group" <> 'NON_VALO' THEN
                    //    ERROR(TxtL50000,RecPItem."No.");
                    ERROR(TxtL50000, RecPItem."No.");
            //<<NDBI
        END ELSE
            //<<TDL100220.001

            IF (RecPItem."Costing Method" = RecPItem."Costing Method"::Standard) AND (RecPItem."Standard Cost" = 0) THEN
                IF RecPItem."Replenishment System" = RecPItem."Replenishment System"::"Prod. Order" THEN BEGIN
                    RecLRoutingHeader.GET(RecPItem."Routing No.");
                    IF RecLRoutingHeader.Status <> RecLRoutingHeader.Status::Certified THEN
                        RecLRoutingHeader.FIELDERROR(Status);

                    RecLProductionBOMHeader.GET(RecPItem."Production BOM No.");
                    IF RecLProductionBOMHeader.Status <> RecLProductionBOMHeader.Status::Certified THEN
                        RecLProductionBOMHeader.FIELDERROR(Status);

                    // on descend la nomenclature
                    RecLBOMLine.RESET;
                    RecLBOMLine.SETRANGE("Production BOM No.", RecPItem."Production BOM No.");
                    RecLBOMLine.SETRANGE("Version Code", VersionMgt.GetBOMVersion(RecPItem."Production BOM No.", TODAY, TRUE));
                    RecLBOMLine.SETRANGE(Type, RecLBOMLine.Type::Item);
                    RecLBOMLine.SETFILTER("Starting Date", '%1|<=%2', 0D, TODAY);
                    RecLBOMLine.SETFILTER("Ending Date", '%1|>=%2', 0D, TODAY);
                    RecLBOMLine.SETFILTER("Quantity per", '<>%1', 0);
                    IF RecLBOMLine.FINDSET THEN BEGIN
                        REPEAT
                            RecLItem.GET(RecLBOMLine."No.");
                            CalculateCost(RecLItem);
                        UNTIL RecLBOMLine.NEXT = 0;
                        // Calculate Cost
                        FctCalcItemMonoLevel(RecPItem."No.", FALSE)
                    END;
                END ELSE
                //>>NDBI
                BEGIN
                    IF RecPItem."Inventory Posting Group" <> 'NON_VALO' THEN
                        //    ERROR(TxtL50000,RecPItem."No.");
                        ERROR(TxtL50000, RecPItem."No.");
                END;
        //<<NDBI
        //<<TDL290719.001
    END;

}

