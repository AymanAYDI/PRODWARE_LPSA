report 50068 "PWD Routing Sheet"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/RoutingSheet.rdl';
    AdditionalSearchTerms = 'operations sheet,process structure sheet';
    ApplicationArea = Manufacturing;
    Caption = 'Routing Sheet';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(No_Item; "No.")
            {
            }
            column(PrintComment; PrintComment)
            {
            }
            column(PrintTool; PrintTool)
            {
            }
            column(PrintPersonnel; PrintPersonnel)
            {
            }
            column(PrintQualityMeasures; PrintQualityMeasures)
            {
            }
            dataitem(Counter1; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(Counter2; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    PrintOnlyIfDetail = true;
                    column(CompanyName; COMPANYPROPERTY.DisplayName())
                    {
                    }
                    column(TodayFormatted; Format(Today))
                    {
                    }
                    column(CopyNo1; CopyNo - 1)
                    {
                    }
                    column(CopyText; CopyText)
                    {
                    }
                    column(No01_Item; Item."No.")
                    {
                    }
                    column(Desc_Item; Item.Description)
                    {
                    }
                    column(ProductionQuantity; ProductionQuantity)
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(RtngNo_Item; Item."Routing No.")
                    {
                    }
                    column(ActiveVersionCode; ActiveVersionCode)
                    {
                    }
                    column(ActiveVersionText; ActiveVersionText)
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
                    {
                    }
                    column(RoutingSheetCaption; RoutingSheetCaptionLbl)
                    {
                    }
                    column(ProductionQuantityCaption; ProductionQuantityCaptionLbl)
                    {
                    }
                    column(ItemRtngNoCaption; ItemRtngNoCaptionLbl)
                    {
                    }
                    dataitem("Routing Header"; "Routing Header")
                    {
                        DataItemTableView = SORTING("No.");
                        PrintOnlyIfDetail = true;
                        dataitem("Routing Line"; "Routing Line")
                        {
                            DataItemLink = "Routing No." = FIELD("No.");
                            DataItemTableView = SORTING("Routing No.", "Version Code", "Operation No.");
                            column(OperationNo_RtngLine; "Operation No.")
                            {
                                IncludeCaption = true;
                            }
                            column(Type_RtngLine; Type)
                            {
                                IncludeCaption = true;
                            }
                            column(No_RtngLine; "No.")
                            {
                                IncludeCaption = true;
                            }
                            column(SendAheadQty_RtngLine; "Send-Ahead Quantity")
                            {
                                IncludeCaption = true;
                            }
                            column(SetupTime_RtngLine; "Setup Time")
                            {
                                IncludeCaption = true;
                            }
                            column(RunTime_RtngLine; "Run Time")
                            {
                                IncludeCaption = true;
                            }
                            column(MoveTime_RtngLine; "Move Time")
                            {
                                IncludeCaption = true;
                            }
                            column(TotalTime; TotalTime)
                            {
                                DecimalPlaces = 0 : 5;
                            }
                            column(RunTimeUOMCode_RtngLine; "Run Time Unit of Meas. Code")
                            {
                            }
                            column(ScrapFactor_RtngLine; "Scrap Factor %")
                            {
                                IncludeCaption = true;
                            }
                            column(WaitTime_RtngLine; "Wait Time")
                            {
                                IncludeCaption = true;
                            }
                            column(TotalTimeCaption; TotalTimeCaptionLbl)
                            {
                            }
                            column(RtngLnRunTimeUOMCodeCptn; RtngLnRunTimeUOMCodeCptnLbl)
                            {
                            }
                            dataitem("Routing Comment Line"; "Routing Comment Line")
                            {
                                DataItemLink = "Routing No." = FIELD("Routing No."), "Version Code" = FIELD("Version Code"), "Operation No." = FIELD("Operation No.");
                                DataItemTableView = SORTING("Routing No.", "Version Code", "Operation No.", "Line No.");
                                column(LineComment_RtngComment; Comment)
                                {
                                }

                                trigger OnPreDataItem()
                                begin
                                    SetRange("Routing No.", Item."Routing No.");

                                    if not PrintComment then
                                        CurrReport.Break();
                                end;
                            }
                            dataitem("Routing Tool"; "Routing Tool")
                            {
                                DataItemLink = "Routing No." = FIELD("Routing No."), "Version Code" = FIELD("Version Code"), "Operation No." = FIELD("Operation No.");
                                DataItemTableView = SORTING("Routing No.", "Version Code", "Operation No.", "Line No.");
                                column(Desc_RtngTool; Description)
                                {
                                }
                                column(No_RtngTool; "No.")
                                {
                                }

                                trigger OnPreDataItem()
                                begin
                                    if not PrintTool then
                                        CurrReport.Break();
                                end;
                            }
                            dataitem("Routing Personnel"; "Routing Personnel")
                            {
                                DataItemLink = "Routing No." = FIELD("Routing No."), "Version Code" = FIELD("Version Code"), "Operation No." = FIELD("Operation No.");
                                DataItemTableView = SORTING("Routing No.", "Version Code", "Operation No.", "Line No.");
                                column(Desc_RtngPersonnel; Description)
                                {
                                }
                                column(No_RtngPersonnel; "No.")
                                {
                                }

                                trigger OnPreDataItem()
                                begin
                                    if not PrintPersonnel then
                                        CurrReport.Break();
                                end;
                            }
                            dataitem("Routing Quality Measure"; "Routing Quality Measure")
                            {
                                DataItemLink = "Routing No." = FIELD("Routing No."), "Version Code" = FIELD("Version Code"), "Operation No." = FIELD("Operation No.");
                                DataItemTableView = SORTING("Routing No.", "Version Code", "Operation No.", "Line No.");
                                column(Desc_RtngQualityMeasure; Description)
                                {
                                }
                                column(QMCode_RtngQltyMeasure; "Qlty Measure Code")
                                {
                                }

                                trigger OnPreDataItem()
                                begin
                                    if not PrintQualityMeasures then
                                        CurrReport.Break();
                                end;
                            }

                            trigger OnAfterGetRecord()
                            var
                                CduLCalculateProdOrder: Codeunit 99000773;
                                PWDLPSAFunctionsMgt: codeunit "PWD LPSA Functions Mgt.";
                                CodLRunTimeUnit: Code[10];
                                CodLSetupTimeUnit: Code[10];
                                DecLRunTime: Decimal;
                                DecLSetupTime: Decimal;
                                RunTimeFactor: Decimal;
                            begin
                                //>>FE_LAPIERRETTE_PROD04.001
                                IF "Routing Line"."PWD Fixed-step Prod. Rate time" THEN BEGIN
                                    PWDLPSAFunctionsMgt.FctGetTime("Routing Line".Type, "Routing Line"."No.", Item."No.",
                                                                      ProductionQuantity,
                                                                      DecLSetupTime, DecLRunTime, CodLSetupTimeUnit, CodLRunTimeUnit);

                                    RunTimeFactor := CalendarMgt.TimeFactor(CodLRunTimeUnit);
                                    TotalTime :=
                                      ROUND(
                                        DecLSetupTime * CalendarMgt.TimeFactor(CodLSetupTimeUnit) / RunTimeFactor +
                                        "Wait Time" * CalendarMgt.TimeFactor("Wait Time Unit of Meas. Code") / RunTimeFactor +
                                        "Move Time" * CalendarMgt.TimeFactor("Move Time Unit of Meas. Code") / RunTimeFactor +
                                        ProductionQuantity * DecLRunTime, 0.00001);

                                END ELSE BEGIN
                                    //<<FE_LAPIERRETTE_PROD04.001
                                    RunTimeFactor := CalendarMgt.TimeFactor("Run Time Unit of Meas. Code");
                                    TotalTime :=
                                      Round(
                                        "Setup Time" * CalendarMgt.TimeFactor("Setup Time Unit of Meas. Code") / RunTimeFactor +
                                        "Wait Time" * CalendarMgt.TimeFactor("Wait Time Unit of Meas. Code") / RunTimeFactor +
                                        "Move Time" * CalendarMgt.TimeFactor("Move Time Unit of Meas. Code") / RunTimeFactor +
                                        ProductionQuantity * "Run Time", UOMMgt.TimeRndPrecision());
                                end;
                            end;

                            trigger OnPreDataItem()
                            begin
                                if ActiveVersionCode <> '' then
                                    SetFilter("Version Code", ActiveVersionCode)
                                else
                                    SetFilter("Version Code", '%1', '');
                            end;
                        }

                        trigger OnPreDataItem()
                        begin
                            SetRange("No.", Item."Routing No.");
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    if CopyNo = LoopNo then
                        CurrReport.Break();

                    CopyNo := CopyNo + 1;

                    if CopyNo = 1 then
                        Clear(CopyText)
                    else begin
                        CopyText := Text000;
                        OutputNo += 1;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    if NumberOfCopies = 0 then
                        LoopNo := 1
                    else
                        LoopNo := 1 + NumberOfCopies;
                    CopyNo := 0;
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if "Routing No." = '' then
                    CurrReport.Skip();

                ActiveVersionCode :=
                  VersionMgt.GetRtngVersion("Routing No.", WorkDate(), true);

                if ActiveVersionCode <> '' then
                    ActiveVersionText := Text001
                else
                    ActiveVersionText := '';
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ProductionQuantity; ProductionQuantity)
                    {
                        ApplicationArea = Manufacturing;
                        Caption = 'Production Quantity';
                        DecimalPlaces = 0 : 5;
                        MinValue = 0;
                        ToolTip = 'Specifies the quantity of items to manufacture for which you want the program to calculate the total time of the routing.';
                    }
                    field(PrintComment; PrintComment)
                    {
                        ApplicationArea = Manufacturing;
                        Caption = 'Comment';
                        ToolTip = 'Specifies whether to include comments that provide additional information about the operation. For example, comments might mention special conditions for completing the operation.';
                    }
                    field(PrintTool; PrintTool)
                    {
                        ApplicationArea = Manufacturing;
                        Caption = 'Tools';
                        ToolTip = 'Specifies whether to include the tools that are required to complete the operation.';
                    }
                    field(PrintPersonnel; PrintPersonnel)
                    {
                        ApplicationArea = Manufacturing;
                        Caption = 'Personnel';
                        ToolTip = 'Specifies whether to include the people to involve in the operation. For example, this is useful if the operation requires special knowledge or training.';
                    }
                    field(PrintQualityMeasures; PrintQualityMeasures)
                    {
                        ApplicationArea = Manufacturing;
                        Caption = 'Quality Measures';
                        ToolTip = 'Specifies whether to include quality measures for the operation. For example, this is useful for quality control purposes.';
                    }
                    field(NumberOfCopies; NumberOfCopies)
                    {
                        ApplicationArea = Manufacturing;
                        Caption = 'No. of Copies';
                        MinValue = 0;
                        ToolTip = 'Specifies how many copies of the document to print.';
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

    trigger OnInitReport()
    begin
        ProductionQuantity := 1;
    end;

    var
        CalendarMgt: Codeunit "Shop Calendar Management";
        UOMMgt: Codeunit "Unit of Measure Management";
        VersionMgt: Codeunit VersionManagement;
        PrintComment: Boolean;
        PrintPersonnel: Boolean;
        PrintQualityMeasures: Boolean;
        PrintTool: Boolean;
        ActiveVersionCode: Code[20];
        ProductionQuantity: Decimal;
        TotalTime: Decimal;
        CopyNo: Integer;
        LoopNo: Integer;
        NumberOfCopies: Integer;
        OutputNo: Integer;
        CurrReportPageNoCaptionLbl: Label 'Page';
        ItemRtngNoCaptionLbl: Label 'Routing No.';
        ProductionQuantityCaptionLbl: Label 'Production Quantity';
        RoutingSheetCaptionLbl: Label 'Routing Sheet';
        RtngLnRunTimeUOMCodeCptnLbl: Label 'Time Unit';
        Text000: Label 'Copy number:';
        Text001: Label 'Active Version';
        TotalTimeCaptionLbl: Label 'Total Time';
        ActiveVersionText: Text[30];
        CopyText: Text[30];
}

