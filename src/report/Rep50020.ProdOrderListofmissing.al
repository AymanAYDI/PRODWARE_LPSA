report 50020 "Prod. Order - List of missing"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.06
    // FE_LAPRIERRETTE_GP0003 : APA 16/05/13 Create
    // 
    // TDL.LPSA.001      Correction pour les prévisions
    //                   Add Code in "Integer - OnAfterGetRecord()"
    // 
    // TDL.LPSA.002  Add Quantité Nécessaire - Date échéance OF - Désignation Dernière écriture capacité
    //               Add Code in "Integer - OnAfterGetRecord()"
    //               Add Code in "Prod. Order Component - OnAfterGetRecord()"
    // +----------------------------------------------------------------------------------------------------------------+
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/ProdOrderListofmissing.rdl';

    Caption = 'Prod. Order - List of missing';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            DataItemTableView = SORTING("PWD Component No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = Status, "No.", "Date Filter";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PageNo())
            {
            }
            column(USERID; UserId)
            {
            }
            column(Shortage_ListCaption; Shortage_ListCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Production_Order__Due_Date_Caption; Production_Order__Due_Date_CaptionLbl)
            {
            }
            column(CompItem__Scheduled_Need__Qty___Caption; CompItem__Scheduled_Need__Qty___CaptionLbl)
            {
            }
            column(CompItem_InventoryCaption; CompItem_InventoryCaptionLbl)
            {
            }
            column(Prod__Order_Component__Remaining_Qty___Base__Caption; Prod__Order_Component__Remaining_Qty___Base__CaptionLbl)
            {
            }
            column(Prod__Order_Component_DescriptionCaption; Prod__Order_Component_DescriptionCaptionLbl)
            {
            }
            column(Prod__Order_Component__Item_No__Caption; Prod__Order_Component__Item_No__CaptionLbl)
            {
            }
            column(LPSA_Description_2Caption; LPSA_Description_2CaptionLbl)
            {
            }
            column(Prod__Order_Component__Quantity_per_Caption; Prod__Order_Component__Quantity_per_CaptionLbl)
            {
            }
            column(Prod__Order_Component__Unit_of_Measure_Code_Caption; Prod__Order_Component__Unit_of_Measure_Code_CaptionLbl)
            {
            }
            column(Prod__Order_Component__Prod__Order_No___Control1100267000Caption; Prod__Order_Component__Prod__Order_No___Control1100267000CaptionLbl)
            {
            }
            column(Prod__Order_Component__PDP_Caption; Prod__Order_Component__PDP_CaptionLbl)
            {
            }
            column(Production_Order__Starting_Date_Caption; Production_Order__Starting_Date_CaptionLbl)
            {
            }
            column(CompItem_QtyOnProdOrderCaption; CompItem_QtyOnProdOrderCaptionLbl)
            {
            }
            column(Comp_NeededQtyCaption; Comp_NeededQtyCaptionLbl)
            {
            }
            column(Production_Order_Status; Status)
            {
            }
            column(Production_Order_No_; "No.")
            {
            }
            dataitem("Prod. Order Line"; "Prod. Order Line")
            {
                DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("No.");
                DataItemTableView = SORTING(Status, "Prod. Order No.", "Line No.");
                PrintOnlyIfDetail = true;
                column(Prod__Order_Line_Status; Status)
                {
                }
                column(Prod__Order_Line_Prod__Order_No_; "Prod. Order No.")
                {
                }
                column(Prod__Order_Line_Line_No_; "Line No.")
                {
                }
                dataitem("Prod. Order Component"; "Prod. Order Component")
                {
                    DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("Prod. Order No."), "Prod. Order Line No." = FIELD("Line No.");
                    DataItemTableView = SORTING(Status, "Prod. Order No.", "Prod. Order Line No.", "Line No.");
                    column(Prod__Order_Component_Status; Status)
                    {
                    }
                    column(Prod__Order_Component_Prod__Order_No_; "Prod. Order No.")
                    {
                    }
                    column(Prod__Order_Component_Prod__Order_Line_No_; "Prod. Order Line No.")
                    {
                    }
                    column(Prod__Order_Component_Line_No_; "Line No.")
                    {
                    }
                    dataitem("Integer"; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(Header_Prod__Order_No__; "Prod. Order Component"."Prod. Order No.")
                        {
                        }
                        column(Header_Prod__Order_Line___MPS_Order_; Format("Prod. Order Line"."MPS Order"))
                        {
                        }
                        column(Header_Production_Order___Source_No__; "Production Order"."Source No.")
                        {
                        }
                        column(Header_Item__LPSA_Description_1_; Item."PWD LPSA Description 1")
                        {
                        }
                        column(Header_Item__LPSA_Description_2_; Item."PWD LPSA Description 2")
                        {
                        }
                        column(Header_Production_Order___Due_Date__; Format("Production Order"."Due Date"))
                        {
                        }
                        column(Header_Item__Scheduled_Need__Qty___; Item."Released Scheduled Need (Qty.)")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(Header_Production_Order__Quantity; "Production Order".Quantity)
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(Header_Item_Inventory; Item.Inventory)
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(BooGShow; BooGShow)
                        {
                        }
                        column(Header_Production_Order___Starting_Date__; Format("Production Order"."Starting Date"))
                        {
                        }
                        column(Header_Item_Qty_on_prod_order; Item."PWD Rele. Qty. on Prod. Order")
                        {
                            //DecimalPlaces = 0 : 5;
                        }
                        column(Comp_CompItem_Inventory; CompItem.Inventory)
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(Comp_CompItem__Scheduled_Need__Qty___; CompItem."Released Scheduled Need (Qty.)")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(Comp_Prod__Order_Component___Item_No__; "Prod. Order Component"."Item No.")
                        {
                        }
                        column(Comp_CompItem__LPSA_Description_1_; CompItem."PWD LPSA Description 1")
                        {
                        }
                        column(Comp_RemainingQty; RemainingQty)
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(Comp_CompItem__LPSA_Description_2_; CompItem."PWD LPSA Description 2")
                        {
                        }
                        column(Comp_Prod__Order_Component___Quantity_per_; "Prod. Order Component"."Quantity per")
                        {
                        }
                        column(Comp_Prod__Order_Component___Unit_of_Measure_Code_; "Prod. Order Component"."Unit of Measure Code")
                        {
                        }
                        column(Comp_Production_Order___Due_Date_; Format("Production Order"."Ending Date"))
                        {
                        }
                        column(Comp_Prod__Order_Line___MPS_Order__; Format("Prod. Order Line"."MPS Order"))
                        {
                        }
                        column(Comp_Prod__Order_No_; "Prod. Order Component"."Prod. Order No.")
                        {
                        }
                        column(Comp_Integer_Number; Number)
                        {
                            //DecimalPlaces = 0 : 5;
                        }
                        column(DetHead_Integer_IntGNbPhantom_; IntGNbPhantom)
                        {
                            //DecimalPlaces = 0 : 5;
                        }
                        column(Comp_Production_Order___Start_Date_; Format("Production Order"."Starting Date"))
                        {
                        }
                        column(Comp_CompItem_QtyOnProdOrder; CompItem."PWD Rele. Qty. on Prod. Order")
                        {
                            //DecimalPlaces = 0 : 5;
                        }
                        column(Comp_NeededQty; DecGQtyNeeded)
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(Phatom_ItemNo; TempItemSubPhantom."Item No.")
                        {
                        }
                        column(Phantom_LotNo; TempItemSubPhantom."Lot No.")
                        {
                        }
                        column(Phantom_Description; TempItemSubPhantom.Description)
                        {
                        }
                        column(Phantom_Priority; TempItemSubPhantom.Priority)
                        {
                        }
                        column(Phantom_Dispo; TempItemSubPhantom."Total Available Quantity")
                        {
                            //DecimalPlaces = 0 : 5;
                        }
                        column(DetHead_Integer_Number_; Number)
                        {
                            //DecimalPlaces = 0 : 5;
                        }
                        column(Detail_NoDoc_1_; NoDoc[1])
                        {
                        }
                        column(Detail_NomTiers_1_; NomTiers[1])
                        {
                        }
                        column(Detail_Date_1_; Format(Date[1], 0, 1))
                        {
                        }
                        column(Detail_Qty_1_; Qty[1])
                        {
                        }
                        column(Detail_NoDoc_2_; NoDoc[2])
                        {
                        }
                        column(Detail_Date_2_; Format(Date[2], 0, 1))
                        {
                        }
                        column(Detail_Qty_2_; Qty[2])
                        {
                        }
                        column(Detail_NoDoc_3_; NoDoc[3])
                        {
                        }
                        column(Detail_NomTiers_3_; NomTiers[3])
                        {
                        }
                        column(Detail_Date_3_; Format(Date[3], 0, 1))
                        {
                        }
                        column(Detail_Qty_3_; Qty[3])
                        {
                        }
                        column(Detail_Integer_Number; Number)
                        {
                            //DecimalPlaces = 0 : 5;
                        }
                        column(Detail_Date_Debut_; Format(DateDebut, 0, 1))
                        {
                        }
                        column(Detail_DueDate_; Format(DueDate, 0, 1))
                        {
                        }
                        column(Detail_TxtGTracking; TxtGTracking)
                        {
                        }
                        column(Detail_Integer_Number_Tracking; IntGNumber)
                        {
                            ///DecimalPlaces = 0 : 5;
                        }
                        column(Total_Qty_1_; Qty[1])
                        {
                        }
                        column(Total_Qty_2_; Qty[2])
                        {
                        }
                        column(Total_Qty_3_; Qty[3])
                        {
                        }
                        column(DetHead_N__achatCaption; DetHead_N__achatCaptionLbl)
                        {
                        }
                        column(DetHead_LPSA_Description_1Caption; DetHead_LPSA_Description_1CaptionLbl)
                        {
                        }
                        column("DetHead_Qté_sur_cde_achatCaption"; DetHead_Qté_sur_cde_achatCaptionLbl)
                        {
                        }
                        column("DetHead_Date_réception_achatCaption"; DetHead_Date_réception_achatCaptionLbl)
                        {
                        }
                        column(DetHead_N__OFCaption; DetHead_N__OFCaptionLbl)
                        {
                        }
                        column(DetHead_Date_Fin_OFCaption; DetHead_Date_Fin_OFCaptionLbl)
                        {
                        }
                        column("DetHead_Qté_sur_OFCaption"; DetHead_Qté_sur_OFCaptionLbl)
                        {
                        }
                        column(DetHead_N__Cde_venteCaption; DetHead_N__Cde_venteCaptionLbl)
                        {
                        }
                        column(DetHead_LPSA_Description_1Caption_; DetHead_LPSA_Description_1Caption_Lbl)
                        {
                        }
                        column("DetHead_Date_livraison_demandéeCaption"; DetHead_Date_livraison_demandéeCaptionLbl)
                        {
                        }
                        column("DetHead_Qté_sur_cde_venteCaption"; DetHead_Qté_sur_cde_venteCaptionLbl)
                        {
                        }
                        column(DetHead_Date_Debut_OFCaption; DetHead_Date_Debut_OFCaptionLbl)
                        {
                        }
                        column(DetHead_Date_Echeance_OFCaption; DetHead_Date_Echeance_OFCaptionLbl)
                        {
                        }
                        column(TotalCaption; TotalCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if CodGProdOrderNo <> "Prod. Order Component"."Prod. Order No." then begin
                                CodGProdOrderNo := "Prod. Order Component"."Prod. Order No.";
                                BooGShow := true;
                            end else
                                BooGShow := false;

                            if Number = 2 then
                                Temp.FindFirst()
                            else
                                Temp.Next();

                            Clear(TxtGTracking);

                            //>>TDL.LPSA.002
                            if RemainingQty - CompItem.Inventory > 0 then
                                DecGQtyNeeded := RemainingQty - CompItem.Inventory
                            else
                                DecGQtyNeeded := 0;

                            if Number = 1 then begin
                                if (CodGComponentNo <> '') and (CodGComponentNo <> "Production Order"."PWD Component No.") then
                                    CurrReport.NewPage();
                                CodGComponentNo := "Production Order"."PWD Component No.";
                            end;
                            //>>TDL.LPSA.002

                            if Number > 1 then begin
                                Clear(NoDoc);
                                Clear(NomTiers);
                                Clear(Date);
                                Clear(Qty);
                                Clear(DateDebut);

                                case Temp."Source Type" of
                                    37:
                                        begin
                                            NoDoc[3] := Temp."Source ID";
                                            if Temp."Source Batch Name" = '' then
                                                NomTiers[3] := ''
                                            else begin
                                                if not RecGCust.Get(Temp."Source Batch Name") then
                                                    RecGCust.Init();
                                                NomTiers[3] := RecGCust.Name;
                                            end;
                                            Date[3] := Temp."Creation Date";
                                            Qty[3] := Temp."Quantity (Base)";
                                            //>>TDL.LPSA.001
                                            //RecGSalesLine.GET(RecGSalesLine."Document Type"::Order,Temp."Source ID",Temp."Source Ref. No.");
                                            if RecGSalesLine.Get(RecGSalesLine."Document Type"::Order, Temp."Source ID", Temp."Source Ref. No.") then begin
                                                TrackingMgt.SetSalesLine(RecGSalesLine);
                                                TxtGTracking := LPSAFunctionsMgt.FindFirsRecord();
                                                IntGNumber := StrLen(TxtGTracking);
                                            end else
                                                TxtGTracking := 'Prévisions';
                                            //<<TDL.LPSA.001
                                        end;
                                    39:
                                        begin
                                            NoDoc[1] := Temp."Source ID";
                                            if not RecGvend.Get(Temp."Source Batch Name") then
                                                RecGvend.Init();
                                            NomTiers[1] := RecGvend.Name;
                                            Date[1] := Temp."Creation Date";
                                            Qty[1] := Temp."Quantity (Base)";
                                        end;
                                    50011:
                                        begin
                                            TempItemSubPhantom.SetRange("Item No.", Temp."Item No.");
                                            TempItemSubPhantom.SetRange("Lot No.", Temp."Lot No.");
                                            TempItemSubPhantom.FindFirst();
                                            TempItemSubPhantom.CalcFields("Description");
                                        end;
                                    else begin
                                            NoDoc[2] := Temp."Source ID";
                                            Date[2] := Temp."Creation Date";
                                            Qty[2] := Temp."Quantity (Base)";
                                            DateDebut := Temp."Warranty Date";
                                            DueDate := Temp."Expiration Date";
                                            RecGCapLedgEntry.SetRange("Order No.", Temp."Source ID");
                                            //>>TDL.LPSA.002
                                            if RecGCapLedgEntry.FindLast() then
                                                NomTiers[3] := RecGCapLedgEntry.Description
                                            else
                                                NomTiers[3] := '';
                                            //<<TDL.LPSA.002
                                        end;
                                end;
                            end;
                        end;

                        trigger OnPreDataItem()
                        begin
                            SetRange(Number, 1, IntGNbDoc + 1);

                            CurrReport.CreateTotals(Qty);

                            //>>TDL.LPSA.002
                            RecGCapLedgEntry.SetCurrentKey("Order No.");
                            //<<TDL.LPSA.002
                        end;
                    }

                    trigger OnAfterGetRecord()
                    var
                        TempProdOrderComp: Record "Prod. Order Component" temporary;
                        TempProdOrderLine: Record "Prod. Order Line" temporary;
                    begin
                        CompItem.Get("Prod. Order Component"."Item No.");
                        CompItem.SetRange("Variant Filter", "Variant Code");
                        CompItem.SetRange("Location Filter", "Location Code");
                        CompItem.SetRange("Date Filter");
                        CompItem.CalcFields("PWD Rele. Qty. on Prod. Order");

                        CompItem.SetRange(
                          "Date Filter", 0D, "Due Date" - 1);

                        CompItem.CalcFields(
                          Inventory, "Reserved Qty. on Inventory",
                          "Scheduled Receipt (Qty.)", "Reserved Qty. on Prod. Order",
                          "Released Scheduled Need (Qty.)", "Res. Qty. on Prod. Order Comp.");
                        CompItem.Inventory :=
                          CompItem.Inventory -
                          CompItem."Reserved Qty. on Inventory";
                        CompItem."Scheduled Receipt (Qty.)" :=
                          CompItem."Scheduled Receipt (Qty.)" -
                          CompItem."Reserved Qty. on Prod. Order";
                        //CompItem."Released Scheduled Need (Qty.)" :=
                        //  CompItem."Released Scheduled Need (Qty.)" -
                        //  CompItem."Res. Qty. on Prod. Order Comp.";

                        CompItem.SetRange(
                          "Date Filter", 0D, "Due Date");
                        CompItem.CalcFields(
                          "Qty. on Sales Order", "Reserved Qty. on Sales Orders",
                          "Qty. on Purch. Order", "Reserved Qty. on Purch. Orders");
                        CompItem."Qty. on Sales Order" :=
                          CompItem."Qty. on Sales Order" -
                          CompItem."Reserved Qty. on Sales Orders";
                        CompItem."Qty. on Purch. Order" :=
                          CompItem."Qty. on Purch. Order" -
                          CompItem."Reserved Qty. on Purch. Orders";

                        TempProdOrderLine.SetCurrentKey(
                          "Item No.", "Variant Code", "Location Code", Status, "Ending Date");

                        TempProdOrderLine.SetRange(Status, TempProdOrderLine.Status::Planned, Status.AsInteger() - 1);
                        TempProdOrderLine.SetRange("Item No.", "Item No.");
                        TempProdOrderLine.SetRange("Variant Code", "Variant Code");
                        TempProdOrderLine.SetRange("Location Code", "Location Code");
                        TempProdOrderLine.SetRange("Due Date", "Due Date");
                        CalcProdOrderLineFields(TempProdOrderLine);
                        CompItem."Scheduled Receipt (Qty.)" :=
                          CompItem."Scheduled Receipt (Qty.)" +
                          TempProdOrderLine."Remaining Qty. (Base)" -
                          TempProdOrderLine."Reserved Qty. (Base)";

                        TempProdOrderLine.SetRange(Status, Status);
                        TempProdOrderLine.SetRange("Prod. Order No.", "Prod. Order No.");
                        CalcProdOrderLineFields(TempProdOrderLine);
                        CompItem."Scheduled Receipt (Qty.)" :=
                          CompItem."Scheduled Receipt (Qty.)" +
                          TempProdOrderLine."Remaining Qty. (Base)" -
                          TempProdOrderLine."Reserved Qty. (Base)";


                        TempProdOrderComp.SetCurrentKey(
                          "Item No.", "Variant Code", "Location Code", Status, "Due Date");

                        TempProdOrderComp.SetRange(Status, TempProdOrderComp.Status::Planned, Status.AsInteger() - 1);
                        TempProdOrderComp.SetRange("Item No.", "Item No.");
                        TempProdOrderComp.SetRange("Variant Code", "Variant Code");
                        TempProdOrderComp.SetRange("Location Code", "Location Code");
                        TempProdOrderComp.SetRange("Due Date", "Due Date");
                        CalcProdOrderCompFields(TempProdOrderComp);
                        //CompItem."Released Scheduled Need (Qty.)" :=
                        //  CompItem."Released Scheduled Need (Qty.)" +
                        //  TempProdOrderComp."Remaining Qty. (Base)" -
                        //  TempProdOrderComp."Reserved Qty. (Base)";

                        TempProdOrderComp.SetRange(Status, Status);
                        TempProdOrderComp.SetFilter("Prod. Order No.", '<%1', "Prod. Order No.");
                        CalcProdOrderCompFields(TempProdOrderComp);
                        //CompItem."Released Scheduled Need (Qty.)" :=
                        //  CompItem."Released Scheduled Need (Qty.)" +
                        //  TempProdOrderComp."Remaining Qty. (Base)" -
                        //  TempProdOrderComp."Reserved Qty. (Base)";

                        TempProdOrderComp.SetRange("Prod. Order No.", "Prod. Order No.");
                        TempProdOrderComp.SetRange("Prod. Order Line No.", 0, "Prod. Order Line No." - 1);
                        CalcProdOrderCompFields(TempProdOrderComp);
                        //CompItem."Released Scheduled Need (Qty.)" :=
                        //  CompItem."Released Scheduled Need (Qty.)" +
                        //  TempProdOrderComp."Remaining Qty. (Base)" -
                        //  TempProdOrderComp."Reserved Qty. (Base)";

                        TempProdOrderComp.SetRange("Prod. Order Line No.", "Prod. Order Line No.");
                        TempProdOrderComp.SetRange("Line No.", 0, "Line No.");
                        CalcProdOrderCompFields(TempProdOrderComp);
                        //CompItem."Released Scheduled Need (Qty.)" :=
                        //  CompItem."Released Scheduled Need (Qty.)" +
                        //  TempProdOrderComp."Remaining Qty. (Base)" -
                        //  TempProdOrderComp."Reserved Qty. (Base)";

                        QtyOnHandAfterProd :=
                          CompItem.Inventory -
                          TempProdOrderComp."Remaining Qty. (Base)" +
                          TempProdOrderComp."Reserved Qty. (Base)";

                        NeededQty :=
                          CompItem."Released Scheduled Need (Qty.)" +
                          CompItem."Qty. on Sales Order" -
                          CompItem."Qty. on Purch. Order" -
                          CompItem."Scheduled Receipt (Qty.)" -
                          CompItem.Inventory;

                        if NeededQty < 0 then
                            NeededQty := 0;


                        RemainingQty :=
                          TempProdOrderComp."Remaining Qty. (Base)";
                        //  TempProdOrderComp."Reserved Qty. (Base)";

                        if CompItem."PWD Phantom Item" then begin
                            ItemSubPhantom.SetRange("Phantom Item No.", CompItem."No.");
                            TempItemSubPhantom.DeleteAll();

                            if ItemSubPhantom.FindFirst() then
                                repeat
                                    RecLItemLedgEntry.SetRange(Open, true);
                                    RecLItemLedgEntry.SetRange("Item No.", ItemSubPhantom."Item No.");
                                    RecLItemLedgEntry.SetFilter("Lot No.", '<>%1', '');
                                    if RecLItemLedgEntry.Find('-') then
                                        repeat
                                            TempItemSubPhantom."Phantom Item No." := ItemSubPhantom."Phantom Item No.";
                                            TempItemSubPhantom."Item No." := ItemSubPhantom."Item No.";
                                            TempItemSubPhantom.Priority := ItemSubPhantom.Priority;
                                            TempItemSubPhantom."Lot No." := RecLItemLedgEntry."Lot No.";
                                            TempItemSubPhantom."Expected Quantity" := "Expected Quantity";

                                            RecLTrackingSpec.Init();
                                            RecLTrackingSpec."Item No." := ItemSubPhantom."Item No.";
                                            RecLTrackingSpec."Location Code" := "Location Code";
                                            RecLTrackingSpec."Lot No." := RecLItemLedgEntry."Lot No.";
                                            TempItemSubPhantom."Total Available Quantity" := LPSAFunctionsMgt.LotSNAvailablePhantom(RecLTrackingSpec);
                                            if TempItemSubPhantom."Total Available Quantity" <> 0 then
                                                if not TempItemSubPhantom.Insert() then
                                                    TempItemSubPhantom.Modify()
                                                else begin
                                                    IntGNbDoc += 1;
                                                    Temp.Init();
                                                    Temp."Entry No." := IntGNbDoc;
                                                    Temp."Source Type" := 50011;
                                                    Temp."Item No." := ItemSubPhantom."Item No.";
                                                    Temp."Lot No." := RecLItemLedgEntry."Lot No.";
                                                    Temp.Insert();
                                                end;
                                        until RecLItemLedgEntry.Next() = 0
                                    else begin
                                        TempItemSubPhantom."Phantom Item No." := ItemSubPhantom."Phantom Item No.";
                                        TempItemSubPhantom."Item No." := ItemSubPhantom."Item No.";
                                        TempItemSubPhantom.Priority := ItemSubPhantom.Priority;
                                        TempItemSubPhantom."Expected Quantity" := "Expected Quantity";

                                        RecLTrackingSpec.Init();
                                        RecLTrackingSpec."Item No." := ItemSubPhantom."Item No.";
                                        RecLTrackingSpec."Location Code" := "Location Code";
                                        TempItemSubPhantom."Total Available Quantity" := LPSAFunctionsMgt.LotSNAvailablePhantom(RecLTrackingSpec);
                                        if TempItemSubPhantom."Total Available Quantity" <> 0 then begin
                                            TempItemSubPhantom.Insert();
                                            IntGNbDoc += 1;
                                            Temp.Init();
                                            Temp."Entry No." := IntGNbDoc;
                                            Temp."Source Type" := 50011;
                                            Temp."Item No." := ItemSubPhantom."Item No.";
                                            Temp.Insert();
                                        end;
                                    end;
                                until ItemSubPhantom.Next() = 0;
                        end;

                        IntGNbPhantom := IntGNbDoc;

                        RecGPurchLine.SetRange("No.", CompItem."No.");
                        if RecGPurchLine.FindFirst() then
                            repeat
                                IntGNbDoc += 1;
                                Temp.Init();
                                Temp."Entry No." := IntGNbDoc;
                                Temp."Source Type" := 39;
                                Temp."Source ID" := RecGPurchLine."Document No.";
                                Temp."Source Batch Name" := RecGPurchLine."Buy-from Vendor No.";
                                Temp."Creation Date" := RecGPurchLine."Expected Receipt Date";
                                Temp."Quantity (Base)" := RecGPurchLine."Outstanding Qty. (Base)";
                                Temp.Insert();
                            until RecGPurchLine.Next() = 0;

                        RecGProdOrderLine.SetFilter("Item No.", '%1', CompItem."No.");
                        RecGProdOrderLine.SetRange("Item No.", CompItem."No.");
                        if RecGProdOrderLine.FindFirst() then
                            repeat
                                if RecGProdOrderLine."Remaining Qty. (Base)" <> 0 then begin
                                    IntGNbDoc += 1;
                                    Temp.Init();
                                    Temp."Entry No." := IntGNbDoc;
                                    Temp."Source Type" := 5406;
                                    Temp."Source ID" := RecGProdOrderLine."Prod. Order No.";
                                    Temp."Creation Date" := RecGProdOrderLine."Ending Date";
                                    Temp."Warranty Date" := RecGProdOrderLine."Starting Date";
                                    Temp."Quantity (Base)" := RecGProdOrderLine."Remaining Qty. (Base)";
                                    //>>TDL.LPSA.002
                                    Temp."Expiration Date" := RecGProdOrderLine."Due Date";
                                    //<<TDL.LPSA.002
                                    Temp.Insert();
                                end;
                            until RecGProdOrderLine.Next() = 0;

                        RecGSalesLine.SetFilter("No.", '%1|%2', "Prod. Order Line"."Item No.", CompItem."No.");
                        RecGSalesLine.SetCurrentKey("Shipment Date");
                        if RecGSalesLine.FindFirst() then
                            repeat
                                IntGNbDoc += 1;
                                Temp.Init();
                                Temp."Entry No." := IntGNbDoc;
                                Temp."Source Type" := 37;
                                Temp."Source ID" := RecGSalesLine."Document No.";
                                Temp."Source Ref. No." := RecGSalesLine."Line No.";
                                Temp."Source Batch Name" := RecGSalesLine."Sell-to Customer No.";
                                Temp."Creation Date" := RecGSalesLine."Planned Delivery Date";
                                Temp."Quantity (Base)" := RecGSalesLine."Outstanding Qty. (Base)";
                                Temp.Insert();
                            until RecGSalesLine.Next() = 0;

                        RecGProdForecastEntry.SetFilter("Item No.", '%1|%2', "Prod. Order Line"."Item No.", CompItem."No.");
                        RecGProdForecastEntry.SetRange("Forecast Date", "Production Order"."Due Date");
                        if RecGProdForecastEntry.FindFirst() then
                            repeat
                                IntGNbDoc += 1;
                                Temp.Init();
                                Temp."Entry No." := IntGNbDoc;
                                Temp."Source Type" := 37;
                                Temp."Source ID" := 'PREVISION';
                                Temp."Source Batch Name" := '';
                                Temp."Creation Date" := RecGProdForecastEntry."Forecast Date";
                                Temp."Quantity (Base)" := RecGProdForecastEntry."Forecast Quantity (Base)";
                                Temp.Insert();
                            until RecGProdForecastEntry.Next() = 0;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetFilter("Due Date", "Production Order".GetFilter("Date Filter"));
                        SetFilter("Remaining Qty. (Base)", '>0');

                        Temp.DeleteAll();
                        IntGNbDoc := 0;

                        RecGPurchLine.SetRange("Document Type", RecGPurchLine."Document Type"::Order);
                        RecGPurchLine.SetRange(Type, RecGPurchLine.Type::Item);
                        RecGPurchLine.SetFilter("Outstanding Quantity", '<>0');

                        RecGSalesLine.SetRange("Document Type", RecGSalesLine."Document Type"::Order);
                        RecGSalesLine.SetRange(Type, RecGSalesLine.Type::Item);
                        RecGSalesLine.SetFilter("Outstanding Quantity", '<>0');

                        RecGProdOrderLine.SetFilter(Status, '%1..%2', RecGProdOrderLine.Status::Planned, RecGProdOrderLine.Status::Released);

                        RecLItemLedgEntry.SetCurrentKey(Open, "Item Tracking", "Item No.", "Variant Code", "Lot No.", "Serial No.");
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                if "Source Type" = "Source Type"::Item then begin
                    if not Item.Get("Source No.") then
                        Item.Init();
                    Item.SetRange("Location Filter", "Location Code");
                    Item.SetRange("Date Filter");
                    Item.CalcFields(Item."PWD Rele. Qty. on Prod. Order");
                    Item.SetRange(
                      "Date Filter", 0D, "Due Date" - 1);

                    Item.CalcFields(
                      Inventory, "Reserved Qty. on Inventory",
                      "Scheduled Receipt (Qty.)", "Reserved Qty. on Prod. Order",
                      "Released Scheduled Need (Qty.)", "Res. Qty. on Prod. Order Comp.");
                    Item.Inventory :=
                      Item.Inventory -
                      Item."Reserved Qty. on Inventory";
                    Item."Scheduled Receipt (Qty.)" :=
                      Item."Scheduled Receipt (Qty.)" -
                      Item."Reserved Qty. on Prod. Order";
                    Item."Released Scheduled Need (Qty.)" :=
                      Item."Released Scheduled Need (Qty.)" -
                      Item."Res. Qty. on Prod. Order Comp.";
                end else
                    Item.Init();

                //>>TDL.LPSA.002
                //IF (CodGComponentNo <>'') AND (CodGComponentNo <> "Component No.") THEN
                //   CurrReport.NEWPAGE;
                //CodGComponentNo := "Component No.";
                //<<TDL.LPSA.002
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
        RecGCapLedgEntry: Record "Capacity Ledger Entry";
        RecGCust: Record Customer;
        CompItem: Record Item;
        Item: Record Item;
        RecLItemLedgEntry: Record "Item Ledger Entry";
        RecGProdOrderLine: Record "Prod. Order Line";
        RecGProdForecastEntry: Record "Production Forecast Entry";
        RecGPurchLine: Record "Purchase Line";
        ItemSubPhantom: Record "PWD Phantom substitution Items";
        TempItemSubPhantom: Record "PWD Phantom substitution Items" temporary;
        RecGSalesLine: Record "Sales Line";
        RecLTrackingSpec: Record "Tracking Specification";
        Temp: Record "Tracking Specification Phantom" temporary;
        RecGvend: Record Vendor;
        TrackingMgt: Codeunit OrderTrackingManagement;
        LPSAFunctionsMgt: codeunit "PWD LPSA Functions Mgt.";
        BooGShow: Boolean;
        CodGComponentNo: Code[20];
        CodGProdOrderNo: Code[20];
        NoDoc: array[3] of Code[20];
        Date: array[3] of Date;
        DateDebut: Date;
        DueDate: Date;
        DecGQtyNeeded: Decimal;
        NeededQty: Decimal;
        Qty: array[3] of Decimal;
        QtyOnHandAfterProd: Decimal;
        RemainingQty: Decimal;
        IntGNbDoc: Integer;
        IntGNbPhantom: Integer;
        IntGNumber: Integer;
        Comp_NeededQtyCaptionLbl: Label 'Needed Quantity';
        CompItem__Scheduled_Need__Qty___CaptionLbl: Label 'Scheduled Need (Qty.)';
        CompItem_InventoryCaptionLbl: Label 'Inventory';
        CompItem_QtyOnProdOrderCaptionLbl: Label 'Qty. on Prod. Order';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        DetHead_Date_Debut_OFCaptionLbl: Label 'Date Début';
        DetHead_Date_Echeance_OFCaptionLbl: Label 'Date Echéance OF';
        DetHead_Date_Fin_OFCaptionLbl: Label 'Date Fin OF';
        "DetHead_Date_livraison_demandéeCaptionLbl": Label 'Date livr. ';
        "DetHead_Date_réception_achatCaptionLbl": Label 'Date récept.';
        DetHead_LPSA_Description_1Caption_Lbl: Label 'LPSA Description 1';
        DetHead_LPSA_Description_1CaptionLbl: Label 'LPSA Description 1';
        DetHead_N__achatCaptionLbl: Label 'N° achat';
        DetHead_N__Cde_venteCaptionLbl: Label 'N° Cde vente';
        DetHead_N__OFCaptionLbl: Label 'N° OF';
        "DetHead_Qté_sur_cde_achatCaptionLbl": Label 'Qté / achat';
        "DetHead_Qté_sur_cde_venteCaptionLbl": Label 'Qté / Vente';
        "DetHead_Qté_sur_OFCaptionLbl": Label 'Qté /OF';
        LPSA_Description_2CaptionLbl: Label 'LPSA Description 2';
        Prod__Order_Component__Item_No__CaptionLbl: Label 'Item No.';
        Prod__Order_Component__PDP_CaptionLbl: Label 'Prod. Order No.';
        Prod__Order_Component__Prod__Order_No___Control1100267000CaptionLbl: Label 'Prod. Order No.';
        Prod__Order_Component__Quantity_per_CaptionLbl: Label 'Quantity per';
        Prod__Order_Component__Remaining_Qty___Base__CaptionLbl: Label 'Quantité à produire';
        Prod__Order_Component__Unit_of_Measure_Code_CaptionLbl: Label 'Unit of Measure Code';
        Prod__Order_Component_DescriptionCaptionLbl: Label 'LPSA Description 1';
        Production_Order__Due_Date_CaptionLbl: Label 'Due Date';
        Production_Order__Starting_Date_CaptionLbl: Label 'Starting Date';
        Shortage_ListCaptionLbl: Label 'Shortage List';
        TotalCaptionLbl: Label 'Total';
        NomTiers: array[3] of Text[50];
        TxtGTracking: Text[250];


    procedure CalcProdOrderLineFields(var ProdOrderLineFields: Record "Prod. Order Line")
    var
        ProdOrderLine: Record "Prod. Order Line";
        RemainingQtyBase: Decimal;
        ReservedQtyBase: Decimal;
    begin
        ProdOrderLine.Copy(ProdOrderLineFields);

        if ProdOrderLine.FindSet() then
            repeat
                ProdOrderLine.CalcFields("Reserved Qty. (Base)");
                RemainingQtyBase += ProdOrderLine."Remaining Qty. (Base)";
                ReservedQtyBase += ProdOrderLine."Reserved Qty. (Base)";
            until ProdOrderLine.Next() = 0;

        ProdOrderLineFields."Remaining Qty. (Base)" := RemainingQtyBase;
        ProdOrderLineFields."Reserved Qty. (Base)" := ReservedQtyBase;
    end;


    procedure CalcProdOrderCompFields(var ProdOrderCompFields: Record "Prod. Order Component")
    var
        ProdOrderComp: Record "Prod. Order Component";
        RemainingQtyBase: Decimal;
        ReservedQtyBase: Decimal;
    begin
        ProdOrderComp.Copy(ProdOrderCompFields);

        if ProdOrderComp.FindSet() then
            repeat
                ProdOrderComp.CalcFields("Reserved Qty. (Base)");
                RemainingQtyBase += ProdOrderComp."Remaining Qty. (Base)";
                ReservedQtyBase += ProdOrderComp."Reserved Qty. (Base)";
            until ProdOrderComp.Next() = 0;

        ProdOrderCompFields."Remaining Qty. (Base)" := RemainingQtyBase;
        ProdOrderCompFields."Reserved Qty. (Base)" := ReservedQtyBase;
    end;
}

