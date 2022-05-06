report 50021 "PWD Inventory Valuation - LPSA"
{
    // ------------------------------------------------------------------------------------------------------------------------------------
    // www.prodware.fr
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 
    // //>>MODIF HL
    // TI316306 DO.GEPO 26/02/2016 : reprise code Nav 2013 R2 dans ce report initialement en V6.00 car nombreux bugs
    //                               avec de nombreuses adaptations car état en classic et RTC
    // 
    // TI401536: TO 19/01/18: Replace Column "Production Order"."Source Type" by column "Value Entry"."Location Code"
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/InventoryValuationLPSA.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Inventory Valuation - WIP';

    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            DataItemTableView = WHERE(Status = FILTER(Released ..));
            PrintOnlyIfDetail = true;
            RequestFilterFields = Status, "No.";
            column(COMPANYNAME; CompanyName)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(USERID; UserId)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PageNo())
            {
            }
            column(STRSUBSTNO___1___2___Production_Order__TABLECAPTION_ProdOrderFilter_; StrSubstNo('%1: %2', "Production Order".TableCaption, ProdOrderFilter))
            {
            }
            column(ProdOrderFilter; ProdOrderFilter)
            {
            }
            column(STRSUBSTNO_Text005_StartDateText_; StrSubstNo(Text005, StartDateText))
            {
            }
            column(STRSUBSTNO_Text005_FORMAT_EndDate__; StrSubstNo(Text005, Format(EndDate)))
            {
            }
            column(Value_Entry___Cost_Posted_to_G_L_; DecGInputQty)
            {
                AutoFormatType = 1;
            }
            column(ValueOfWIP___ValueOfMatConsump___ValueOfCap___ValueOfOutput; ValueOfWIP + ValueOfMatConsump + ValueOfCap + ValueOfOutput)
            {
            }
            column(ValueOfOutput; ValueOfOutput)
            {
                AutoFormatType = 1;
            }
            column(ValueOfCap; ValueOfCap)
            {
                AutoFormatType = 1;
            }
            column(ValueOfMatConsump; ValueOfMatConsump)
            {
                AutoFormatType = 1;
            }
            column(ValueOfWIP; ValueOfWIP)
            {
                AutoFormatType = 1;
            }
            column(Production_Order__Production_Order___Source_No__; "Production Order"."Source No.")
            {
            }
            column(Location_Code; "Production Order"."Location Code")
            {
            }
            column(Production_Order__Production_Order__Description; "Production Order".Description)
            {
            }
            column(Production_Order__Production_Order___No__; "Production Order"."No.")
            {
            }
            column(Production_Order__Production_Order__Status; "Production Order".Status)
            {
            }
            column(LastOutput; LastOutput)
            {
            }
            column(AtLastDate; AtLastDate)
            {
            }
            column(LastWIP; LastWIP)
            {
            }
            column(TotalValueOfCostPstdToGL_value; TotalValueOfCostPstdToGL)
            {
            }
            column(TotalValueOfOutput_value; TotalValueOfOutput)
            {
            }
            column(TotalValueOfCap_value; TotalValueOfCap)
            {
            }
            column(TotalValueOfMatConsump_value; TotalValueOfMatConsump)
            {
            }
            column(TotalValueOfWIP_value; TotalValueOfWIP)
            {
            }
            column(TotalLastOutput_value; TotalLastOutput)
            {
            }
            column(TotalAtLastDate_value; TotalAtLastDate)
            {
            }
            column(TotalLastWIP_value; TotalLastWIP)
            {
            }
            column(ValueOfWIP___ValueOfMatConsump___ValueOfCap___ValueOfOutput_Control121; ValueOfWIP + ValueOfMatConsump + ValueOfCap + ValueOfOutput)
            {
            }
            column(ValueOfOutput_Control122; ValueOfOutput)
            {
                AutoFormatType = 1;
            }
            column(ValueOfCap_Control123; ValueOfCap)
            {
                AutoFormatType = 1;
            }
            column(ValueOfWIP_Control124; ValueOfWIP)
            {
                AutoFormatType = 1;
            }
            column(Value_Entry___Cost_Posted_to_G_L__Control126; DecGInputQty)
            {
                AutoFormatType = 1;
            }
            column(ValueOfMatConsump_Control14; ValueOfMatConsump)
            {
                AutoFormatType = 1;
            }
            column(Inventory_Valuation___WIPCaption; Inventory_Valuation___WIPCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(ValueOfCapCaption; ValueOfCapCaptionLbl)
            {
            }
            column(ValueOfOutputCaption; ValueOfOutputCaptionLbl)
            {
            }
            column(Value_Entry___Cost_Posted_to_G_L_Caption; Value_Entry___Cost_Posted_to_G_L_CaptionLbl)
            {
            }
            column(ValueOfMatConsumpCaption; ValueOfMatConsumpCaptionLbl)
            {
            }
            column(Production_Order__Production_Order___No__Caption; Production_Order__Production_Order___No__CaptionLbl)
            {
            }
            column(Production_Order__Production_Order__StatusCaption; Production_Order__Production_Order__StatusCaptionLbl)
            {
            }
            column(Production_Order__Production_Order__DescriptionCaption; Production_Order__Production_Order__DescriptionCaptionLbl)
            {
            }
            column(Location_Code_Caption; Location_Code_CaptionLbl)
            {
            }
            column(Production_Order__Production_Order___Source_No__Caption; Production_Order__Production_Order___Source_No__CaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            dataitem("Value Entry"; "Value Entry")
            {
                DataItemTableView = SORTING("Order No.");

                trigger OnAfterGetRecord()
                begin
                    if IsServiceTier then begin
                        CountRecord := CountRecord + 1;
                        LastOutput := 0;
                        AtLastDate := 0;
                        LastWIP := 0;

                        if (CountRecord = LengthRecord) and IsNotWIP() then begin
                            ValueEntryOnPostDataItem("Value Entry");

                            AtLastDate := NcValueOfWIP + NcValueOfMatConsump + NcValueOfCap + NcValueOfOutput;
                            LastOutput := NcValueOfOutput;
                            LastWIP := NcValueOfWIP;
                            //>>TI316306
                            ValueOfCostPstdToGL := NcValueOfCostPstdToGL;
                            //<<TI316306

                            NcValueOfWIP := 0;
                            NcValueOfOutput := 0;
                            NcValueOfMatConsump := 0;
                            NcValueOfCap := 0;
                            NcValueOfInvOutput1 := 0;
                            NcValueOfExpOutPut1 := 0;
                            NcValueOfExpOutPut2 := 0;
                            NcValueOfRevalCostAct := 0;
                            NcValueOfRevalCostPstd := 0;
                            NcValueOfCostPstdToGL := 0;
                        end;
                    end;

                    if not IsServiceTier then
                        if IsNotWIP() then
                            CurrReport.Skip();

                    if not IsNotWIP() then begin
                        ValueOfWIP := 0;
                        ValueOfMatConsump := 0;
                        ValueOfCap := 0;
                        ValueOfOutput := 0;
                        ValueOfInvOutput1 := 0;
                        ValueOfExpOutput1 := 0;
                        ValueOfExpOutput2 := 0;
                        if EntryFound then
                            ValueOfCostPstdToGL := "Cost Posted to G/L";

                        if "Posting Date" < StartDate then begin
                            if "Item Ledger Entry Type" = "Item Ledger Entry Type"::" " then
                                ValueOfWIP := "Cost Amount (Actual)"
                            else
                                ValueOfWIP := -"Cost Amount (Actual)";
                            if "Item Ledger Entry Type" = "Item Ledger Entry Type"::Output then begin
                                ValueOfExpOutput1 := -"Cost Amount (Expected)";
                                ValueOfInvOutput1 := -"Cost Amount (Actual)";
                                //>>TI316306
                                ValueOfWIP := ValueOfExpOutput1 + ValueOfInvOutput1;
                                //<<TI316306
                            end;

                            //>>TI316306
                            if ("Entry Type" = "Entry Type"::Revaluation) and ("Cost Amount (Actual)" <> 0) then
                                ValueOfWIP := 0;
                            //<<TI316306
                        end else
                            case "Item Ledger Entry Type" of
                                "Item Ledger Entry Type"::Consumption:
                                    if IsProductionCost("Value Entry") then
                                        ValueOfMatConsump := -"Cost Amount (Actual)";
                                "Item Ledger Entry Type"::" ":
                                    ValueOfCap := "Cost Amount (Actual)";
                                "Item Ledger Entry Type"::Output:
                                    begin
                                        ValueOfExpOutput2 := -"Cost Amount (Expected)";
                                        //>>TI316306
                                        //ValueOfOutput := -"Cost Amount (Actual)";
                                        ValueOfOutput := -("Cost Amount (Actual)" + "Cost Amount (Expected)");
                                        //<<TI316306
                                        if "Entry Type" = "Entry Type"::Revaluation then
                                            ValueOfRevalCostAct += -"Cost Amount (Actual)";
                                    end;
                            end;

                        if not ("Item Ledger Entry Type" = "Item Ledger Entry Type"::" ") then begin
                            "Cost Amount (Actual)" := -"Cost Amount (Actual)";
                            if IsProductionCost("Value Entry") then begin
                                ValueOfCostPstdToGL := -("Cost Posted to G/L" + "Expected Cost Posted to G/L");
                                if "Entry Type" = "Entry Type"::Revaluation then
                                    ValueOfRevalCostPstd += ValueOfCostPstdToGL;
                            end else
                                ValueOfCostPstdToGL := 0;
                        end else
                            ValueOfCostPstdToGL := "Cost Posted to G/L" + "Expected Cost Posted to G/L";

                        if IsServiceTier then begin
                            NcValueOfWIP := NcValueOfWIP + ValueOfWIP;
                            NcValueOfOutput := NcValueOfOutput + ValueOfOutput;
                            NcValueOfMatConsump := NcValueOfMatConsump + ValueOfMatConsump;
                            NcValueOfCap := NcValueOfCap + ValueOfCap;
                            NcValueOfInvOutput1 := NcValueOfInvOutput1 + ValueOfInvOutput1;
                            NcValueOfExpOutPut1 := NcValueOfExpOutPut1 + ValueOfExpOutput1;
                            NcValueOfExpOutPut2 := NcValueOfExpOutPut2 + ValueOfExpOutput2;
                            //>>TI316306
                            //NcValueOfRevalCostAct := NcValueOfRevalCostAct + ValueOfRevalCostAct;
                            //NcValueOfRevalCostPstd := NcValueOfRevalCostPstd + ValueOfRevalCostPstd;
                            NcValueOfRevalCostAct := ValueOfRevalCostAct;
                            NcValueOfRevalCostPstd := ValueOfRevalCostPstd;
                            //<<TI316306
                            NcValueOfCostPstdToGL := NcValueOfCostPstdToGL + ValueOfCostPstdToGL;
                            ValueOfCostPstdToGL := 0;

                            if CountRecord = LengthRecord then begin
                                ValueEntryOnPostDataItem("Value Entry");
                                //>>TI316306
                                ValueOfCostPstdToGL := NcValueOfCostPstdToGL;
                                //<<TI316306

                                AtLastDate := NcValueOfWIP + NcValueOfMatConsump + NcValueOfCap + NcValueOfOutput;
                                LastOutput := NcValueOfOutput;
                                LastWIP := NcValueOfWIP;

                                NcValueOfWIP := 0;
                                NcValueOfOutput := 0;
                                NcValueOfMatConsump := 0;
                                NcValueOfCap := 0;
                                NcValueOfInvOutput1 := 0;
                                NcValueOfExpOutPut1 := 0;
                                NcValueOfExpOutPut2 := 0;
                                NcValueOfRevalCostAct := 0;
                                NcValueOfRevalCostPstd := 0;
                                NcValueOfCostPstdToGL := 0;
                            end;
                        end;
                    end;

                    //>>TI316306
                    TotalValueOfCostPstdToGL := TotalValueOfCostPstdToGL + ValueOfCostPstdToGL;
                    TotalValueOfOutput := TotalValueOfOutput + ValueOfOutput;
                    TotalValueOfCap := TotalValueOfCap + ValueOfCap;
                    TotalValueOfMatConsump := TotalValueOfMatConsump + ValueOfMatConsump;
                    TotalValueOfWIP := TotalValueOfWIP + ValueOfWIP;
                    TotalLastOutput := TotalLastOutput + LastOutput;
                    TotalAtLastDate := TotalAtLastDate + AtLastDate;
                    TotalLastWIP := TotalLastWIP + LastWIP;

                    if CountRecord <> LengthRecord then
                        CurrReport.Skip();
                    //<<TI316306
                end;

                trigger OnPostDataItem()
                begin
                    ValueEntryOnPostDataItem("Value Entry");
                end;

                trigger OnPreDataItem()
                begin
                    //>>TI316306
                    TotalValueOfCostPstdToGL := 0;
                    TotalValueOfOutput := 0;
                    TotalValueOfCap := 0;
                    TotalValueOfMatConsump := 0;
                    TotalValueOfWIP := 0;
                    TotalLastOutput := 0;
                    TotalAtLastDate := 0;
                    TotalLastWIP := 0;

                    //SETRANGE("Order Type","Order Type"::Production);
                    //<<TI316306

                    SetRange("Order No.", "Production Order"."No.");
                    if EndDate <> 0D then
                        SetRange("Posting Date", 0D, EndDate);

                    CurrReport.CreateTotals(
                      ValueOfWIP, ValueOfMatConsump, ValueOfCap, ValueOfOutput, "Cost Amount (Actual)", ValueOfCostPstdToGL,
                      ValueOfExpOutput1, ValueOfInvOutput1, ValueOfExpOutput2);

                    ValueOfRevalCostAct := 0;
                    ValueOfRevalCostPstd := 0;
                    LengthRecord := 0;
                    CountRecord := 0;

                    if IsServiceTier then
                        if "Value Entry".Find('-') then
                            repeat
                                LengthRecord := LengthRecord + 1;
                            until "Value Entry".Next() = 0;
                end;
            }

            trigger OnAfterGetRecord()
            var
                ProdOrderRtngLine: Record "Prod. Order Routing Line";
            begin
                //>>TI316306
                if FinishedProdOrderHasNoValueEnt("Production Order") then
                    CurrReport.Skip();
                EntryFound := ValueEntryExist("Production Order", StartDate, EndDate);
                //<<TI316306

                //>>JEPE
                DecGInputQty := 0;
                //ProdOrderRtngLine.SETRANGE(Status,Status);
                ProdOrderRtngLine.SetRange("Prod. Order No.", "Production Order"."No.");
                //ProdOrderRtngLine.SETRANGE("Routing Reference No.","Routing Reference No.");
                //ProdOrderRtngLine.SETRANGE("Routing No.","Routing No.");
                ProdOrderRtngLine.SetRange(ProdOrderRtngLine."Routing Status", ProdOrderRtngLine."Routing Status"::Finished);
                if ProdOrderRtngLine.FindLast() then
                    DecGInputQty := Round(ProdOrderRtngLine."Input Quantity", 1);
                //<<JEPE
            end;

            trigger OnPreDataItem()
            begin
                //CurrReport.CREATETOTALS(
                //  ValueOfWIP,ValueOfMatConsump,ValueOfCap,ValueOfOutput,
                //  "Value Entry"."Cost Amount (Actual)",ValueOfCostPstdToGL);

                CurrReport.CreateTotals(
                  ValueOfWIP, ValueOfMatConsump, ValueOfCap, ValueOfOutput,
                  "Value Entry"."Cost Amount (Actual)", DecGInputQty);
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

    trigger OnPreReport()
    begin
        ProdOrderFilter := "Production Order".GetFilters;
        if (StartDate = 0D) and (EndDate = 0D) then
            EndDate := WorkDate();

        if StartDate in [0D, 00000101D] then
            StartDateText := ''
        else
            StartDateText := Format(StartDate - 1);
    end;

    var
        EntryFound: Boolean;
        EndDate: Date;
        StartDate: Date;
        AtLastDate: Decimal;
        DecGInputQty: Decimal;
        LastOutput: Decimal;
        LastWIP: Decimal;
        NcValueOfCap: Decimal;
        NcValueOfCostPstdToGL: Decimal;
        NcValueOfExpOutPut1: Decimal;
        NcValueOfExpOutPut2: Decimal;
        NcValueOfInvOutput1: Decimal;
        NcValueOfMatConsump: Decimal;
        NcValueOfOutput: Decimal;
        NcValueOfRevalCostAct: Decimal;
        NcValueOfRevalCostPstd: Decimal;
        NcValueOfWIP: Decimal;
        TotalAtLastDate: Decimal;
        TotalLastOutput: Decimal;
        TotalLastWIP: Decimal;
        TotalValueOfCap: Decimal;
        TotalValueOfCostPstdToGL: Decimal;
        TotalValueOfMatConsump: Decimal;
        TotalValueOfOutput: Decimal;
        TotalValueOfWIP: Decimal;
        ValueOfCap: Decimal;
        ValueOfCostPstdToGL: Decimal;
        ValueOfExpOutput1: Decimal;
        ValueOfExpOutput2: Decimal;
        ValueOfInvOutput1: Decimal;
        ValueOfMatConsump: Decimal;
        ValueOfOutput: Decimal;
        ValueOfRevalCostAct: Decimal;
        ValueOfRevalCostPstd: Decimal;
        ValueOfWIP: Decimal;
        CountRecord: Integer;
        LengthRecord: Integer;
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Inventory_Valuation___WIPCaptionLbl: Label 'Inventory Valuation - WIP';
        Location_Code_CaptionLbl: Label 'Location';
        Production_Order__Production_Order___No__CaptionLbl: Label 'No.';
        Production_Order__Production_Order___Source_No__CaptionLbl: Label 'Source No.';
        Production_Order__Production_Order__DescriptionCaptionLbl: Label 'Description';
        Production_Order__Production_Order__StatusCaptionLbl: Label 'Status';
        Text005: Label 'As of %1';
        TotalCaptionLbl: Label 'Total';
        Value_Entry___Cost_Posted_to_G_L_CaptionLbl: Label 'Input Qty';
        ValueOfCapCaptionLbl: Label 'Capacity ';
        ValueOfMatConsumpCaptionLbl: Label 'Consumption ';
        ValueOfOutputCaptionLbl: Label 'Output ';
        StartDateText: Text[10];
        ProdOrderFilter: Text[250];


    procedure ValueEntryOnPostDataItem(ValueEntry: Record "Value Entry")
    begin
        if IsServiceTier then begin
            //>>TI316306
            /*
            IF NcValueOfExpOutPut2 = 0 THEN BEGIN // if prod. order is invoiced
              NcValueOfOutput := NcValueOfOutput - NcValueOfRevalCostAct; // take out revalued differnce
              NcValueOfCostPstdToGL := NcValueOfCostPstdToGL - NcValueOfRevalCostPstd; // take out Cost posted to G/L
            END;

            IF NcValueOfWIP + NcValueOfMatConsump + NcValueOfCap <> -NcValueOfOutput THEN BEGIN
              NcValueOfWIP := NcValueOfWIP - NcValueOfInvOutput1 + NcValueOfExpOutPut1;
              IF NcValueOfExpOutPut2 <> 0 THEN // prod. order is un-invoiced, so Actual Output = 0
                NcValueOfOutput := NcValueOfExpOutPut2;
            END;
            */

            if (NcValueOfExpOutPut2 + NcValueOfExpOutPut1) = 0 then begin // if prod. order is invoiced
                NcValueOfOutput := NcValueOfOutput - NcValueOfRevalCostAct; // take out revalued differnce
                NcValueOfCostPstdToGL := NcValueOfCostPstdToGL - NcValueOfRevalCostPstd; // take out Cost posted to G/L
            end;

            /*IF NcValueOfWIP + NcValueOfMatConsump + NcValueOfCap <> -NcValueOfOutput THEN BEGIN
              NcValueOfWIP := NcValueOfWIP - NcValueOfInvOutput1 + NcValueOfExpOutPut1;
              IF NcValueOfExpOutPut2 <> 0 THEN // prod. order is un-invoiced, so Actual Output = 0
                NcValueOfOutput := NcValueOfExpOutPut2;
            END;*/
            //<<TI316306
        end else
            //>>TI316306
            /*
            IF ValueOfExpOutput2 = 0 THEN BEGIN // if prod. order is invoiced
              ValueOfOutput := ValueOfOutput - ValueOfRevalCostAct; // take out revalued differnce
              ValueOfCostPstdToGL := ValueOfCostPstdToGL - ValueOfRevalCostPstd; // take out Cost posted to G/L
            END;

            IF ValueOfWIP + ValueOfMatConsump + ValueOfCap <> -ValueOfOutput THEN BEGIN
              ValueOfWIP := ValueOfWIP - ValueOfInvOutput1 + ValueOfExpOutput1;
              IF ValueOfExpOutput2 <> 0 THEN // prod. order is un-invoiced, so Actual Output = 0
                ValueOfOutput := ValueOfExpOutput2;
            END;
            */

            if (ValueOfExpOutput2 + ValueOfExpOutput1) = 0 then begin // if prod. order is invoiced
                ValueOfOutput := ValueOfOutput - ValueOfRevalCostAct; // take out revalued differnce
                ValueOfCostPstdToGL := ValueOfCostPstdToGL - ValueOfRevalCostPstd; // take out Cost posted to G/L
            end;
        /*IF ValueOfWIP + ValueOfMatConsump + ValueOfCap <> -ValueOfOutput THEN BEGIN
          ValueOfWIP := ValueOfWIP - ValueOfInvOutput1 + ValueOfExpOutput1;
          IF ValueOfExpOutput2 <> 0 THEN // prod. order is un-invoiced, so Actual Output = 0
            ValueOfOutput := ValueOfExpOutput2;
        END; */
        //<<TI316306

    end;


    procedure IsNotWIP(): Boolean
    begin
        //>>TI316306
        /*
        WITH "Value Entry" DO
          IF "Item Ledger Entry Type" = "Item Ledger Entry Type"::Output THEN
            EXIT(NOT ("Entry Type" IN ["Entry Type"::"Direct Cost",
                                       "Entry Type"::Revaluation]))
          ELSE
            EXIT("Expected Cost");
        */
        if "Value Entry"."Item Ledger Entry Type" = "Value Entry"."Item Ledger Entry Type"::Output then
            exit(not ("Value Entry"."Entry Type" in ["Value Entry"."Entry Type"::"Direct Cost",
                                       "Value Entry"."Entry Type"::Revaluation]));

        exit("Value Entry"."Expected Cost");

        //<<TI316306

    end;


    procedure IsProductionCost(ValueEntry: Record "Value Entry"): Boolean
    var
        ILE: Record "Item Ledger Entry";
    begin
        //>>TI316306
        /*
        WITH ValueEntry DO BEGIN
          IF ("Entry Type" = "Entry Type"::Revaluation) AND ("Item Ledger Entry Type"= "Item Ledger Entry Type"::Consumption) THEN BEGIN
            ILE.GET("Item Ledger Entry No.");
            IF ILE.Positive THEN
              EXIT(FALSE)
          END;
        
        END;
        EXIT(TRUE);
        */
        if (ValueEntry."Entry Type" = ValueEntry."Entry Type"::Revaluation) and (ValueEntry."Item Ledger Entry Type" = ValueEntry."Item Ledger Entry Type"::Consumption) then begin
            ILE.Get(ValueEntry."Item Ledger Entry No.");
            if ILE.Positive then
                exit(false)
        end;

        exit(true);
        //<<TI316306

    end;


    procedure FinishedProdOrderHasNoValueEnt(ProductionOrder: Record "Production Order"): Boolean
    begin
        //>>TI316306
        if ProductionOrder.Status <> ProductionOrder.Status::Finished then
            exit(false);
        exit(not ValueEntryExist(ProductionOrder, StartDate, 99991231D));
        //<<TI316306
    end;


    procedure ValueEntryExist(ProductionOrder: Record "Production Order"; StartDate: Date; EndDate: Date): Boolean
    var
        ValueEntry: Record "Value Entry";
    begin
        //>>TI316306
        //SETRANGE("Order Type","Order Type"::Production);
        ValueEntry.SetRange("Order No.", ProductionOrder."No.");
        ValueEntry.SetRange("Posting Date", StartDate, EndDate);
        exit(not ValueEntry.IsEmpty);
        //<<TI316306
    end;
}

