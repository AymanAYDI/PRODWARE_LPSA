report 50010 "Real Std Comparison Routing"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.00
    // FED-LAPIERRETTE-PRO-07-COMPARAISON-STANDARD-REEL-GAMME-OF-V2.001 TUN 26/12/2011:  Creation Report 50010
    // 
    // ------------------------------------------------------------------------------------------------------------------
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/RealStdComparisonRouting.rdl';

    Caption = 'Real Standard Comparison Routing';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
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
            column(DateFilter; DateFilter)
            {
            }
            column(Item__No__; "No.")
            {
            }
            column(Item_Description; Description)
            {
            }
            column(Prod__Order___ListCaption; Prod__Order___ListCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column("PériodeCaption"; PériodeCaptionLbl)
            {
            }
            column(N__ArticleCaption; N__ArticleCaptionLbl)
            {
            }
            column(Item_DescriptionCaption; FieldCaption(Description))
            {
            }
            dataitem("Prod. Order Line"; "Prod. Order Line")
            {
                DataItemLink = "Item No." = FIELD("No.");
                DataItemTableView = SORTING(Status, "Routing No.", "Routing Version Code") WHERE(Status = CONST(Finished));
                PrintOnlyIfDetail = true;
                column(Prod__Order_Line__Routing_No__; "Routing No.")
                {
                }
                column(NbOf; NbOf)
                {
                }
                column(Prod__Order_Line__Routing_Version_Code_; "Routing Version Code")
                {
                }
                column(Prod__Order_Line__Routing_No__Caption; FieldCaption("Routing No."))
                {
                }
                column(Nb_OFCaption; Nb_OFCaptionLbl)
                {
                }
                column(Prod__Order_Line__Routing_Version_Code_Caption; FieldCaption("Routing Version Code"))
                {
                }
                column(Prod__Order_Routing_Line_TypeCaption; Prod__Order_Routing_Line_TypeCaptionLbl)
                {
                }
                column(Prod__Order_Routing_Line__No__Caption; Prod__Order_Routing_Line__No__CaptionLbl)
                {
                }
                column(Prod__Order_Routing_Line_DescriptionCaption; Prod__Order_Routing_Line_DescriptionCaptionLbl)
                {
                }
                column("Temps_préparation_standardCaption"; Temps_préparation_standardCaptionLbl)
                {
                }
                column(Temps_d_execution__Caption; Temps_d_execution__CaptionLbl)
                {
                }
                column("Temps_de_préparation__Caption"; Temps_de_préparation__CaptionLbl)
                {
                }
                column("Temps_préparation_réelCaption"; Temps_préparation_réelCaptionLbl)
                {
                }
                column("Quantité_rebut_réelCaption"; Quantité_rebut_réelCaptionLbl)
                {
                }
                column("Temps_d_execution_réelCaption"; Temps_d_execution_réelCaptionLbl)
                {
                }
                column(Temps_d_execution_standardCaption; Temps_d_execution_standardCaptionLbl)
                {
                }
                column(Prod__Order_Routing_Line__Operation_No__Caption; Prod__Order_Routing_Line__Operation_No__CaptionLbl)
                {
                }
                column(SetupTimeUnitofMeasCaption; SetupTimeUnitofMeasCaptionLbl)
                {
                }
                column(RunTimeUnitofMeasCaption; RunTimeUnitofMeasCaptionLbl)
                {
                }
                column(ScrapFactorCaption; ScrapFactorCaptionLbl)
                {
                }
                column(Prod__Order_Line_Status; Status)
                {
                }
                column(Prod__Order_Line_Prod__Order_No_; "Prod. Order No.")
                {
                }
                column(Prod__Order_Line_Line_No_; "Line No.")
                {
                }
                column(Prod__Order_Line_Item_No_; "Item No.")
                {
                }
                dataitem(RoutingTemp; "Integer")
                {
                    DataItemTableView = SORTING(Number);
                    column(Prod__Order_Routing_Line__Operation_No__; RecGRoutingTemp."Operation No.")
                    {
                    }
                    column(Prod__Order_Routing_Line_Type; RecGRoutingTemp.Type)
                    {
                    }
                    column(Prod__Order_Routing_Line__No__; RecGRoutingTemp."No.")
                    {
                    }
                    column(Prod__Order_Routing_Line_Description; RecGRoutingTemp.Description)
                    {
                    }
                    column(GTimePrepReal; DecGTimePrepReal)
                    {
                    }
                    column(GTimePrep; DecGTimePrep)
                    {
                    }
                    column(GTimeEx; DecGTimeEx)
                    {
                    }
                    column(GTimeExReal; DecGTimeExReal)
                    {
                    }
                    column(GPerte; DecGPerte)
                    {
                        DecimalPlaces = 0 : 0;
                    }
                    column(Prod__Order_Routing_Line__Setup_Time_; DecGSetupTime)
                    {
                    }
                    column(Prod__Order_Routing_Line__Run_Time_; DecGRunTime)
                    {
                    }
                    column(SetupTimeUnitofMeasCode; RecGRoutingTemp."Setup Time Unit of Meas. Code")
                    {
                    }
                    column(RunTimeUnitofMeasCode; RecGRoutingTemp."Run Time Unit of Meas. Code")
                    {
                    }
                    column(ScrapFactorValue; RecGRoutingTemp."Scrap Factor %")
                    {
                    }
                    column(RoutingTemp_Number; Number)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if Number = 1 then
                            RecGRoutingTemp.FindFirst()
                        else
                            RecGRoutingTemp.Next();

                        // Temps de préparation standard & Temps d'execution standard
                        DecGSetupTime := 0;
                        DecGRunTime := 0;
                        DecGTimeExReal := 0;
                        DecGTimePrepReal := 0;
                        DecGPerte := 0;

                        Clear(RecGManuCycleSetup);
                        if not RecGRoutingTemp."PWD Fixed-step Prod. Rate time" then begin
                            DecGSetupTime := RecGRoutingTemp."Setup Time";
                            DecGRunTime := RecGRoutingTemp."Run Time";
                        end
                        else
                            if RecGManuCycleSetup.Get(RecGRoutingTemp.Type, RecGRoutingTemp."No.", "Prod. Order Line"."Item No.") then begin
                                DecGSetupTime := RecGManuCycleSetup."Setup Time";
                                DecGRunTime := Round((RecGManuCycleSetup."Run Time" / RecGManuCycleSetup."Maximun Quantity by cycle"), 0.001);
                            end;

                        RecGCapLedEntry.Reset();
                        RecGCapLedEntry.SetCurrentKey("Document No.", "Posting Date");
                        RecGCapLedEntry.SetRange("Document No.", "Prod. Order Line"."Prod. Order No.");
                        RecGCapLedEntry.SetFilter("Posting Date", DateFilter);
                        if not RecGCapLedEntry.IsEmpty then
                            // Temps de préparation réel & Temps d'execution réel & Quantité rebut réel %
                            GetTimePrepExReal(RecGRoutingTemp, "Prod. Order Line", DecGTimeExReal, DecGTimePrepReal, DecGPerte);

                        // Temps de preparation %
                        if DecGSetupTime <> 0 then
                            DecGTimePrep := Round(((DecGTimePrepReal - DecGSetupTime) / DecGSetupTime) * 100, 0.001)
                        else
                            DecGTimePrep := 0;

                        // Temps d'execution %
                        if DecGRunTime <> 0 then
                            DecGTimeEx := Round(((DecGTimeExReal - DecGRunTime) / DecGRunTime) * 100, 0.001)
                        else
                            DecGTimeEx := 100;
                    end;

                    trigger OnPreDataItem()
                    begin
                        RecGRoutingTemp.SetRange("Routing No.", '', RecGRoutingTemp."Routing No.");
                        SetRange(Number, 1, RecGRoutingTemp.Count);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    TransferRoutingIntoRoutingTemp("Prod. Order Line", RecGRoutingTemp);
                    NbOf := Count;
                end;

                trigger OnPreDataItem()
                begin
                    SetFilter("Ending Date", DateFilter);
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Option")
                {
                    Caption = 'Option';
                    field(DateFilter; DateFilter)
                    {
                        Caption = 'Filtre Date';
                        ApplicationArea = All;

                        trigger OnValidate()
                        var
                            FilterTokens: Codeunit "Filter Tokens";
                        begin
                            FilterTokens.MakeDateFilter(DateFilter);
                            GLAccBudgetBuf.SetFilter("Date Filter", DateFilter);
                            DateFilter := GLAccBudgetBuf.GetFilter("Date Filter");
                        end;
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
        CodGRoutingNo := 'xyz';
        CodGRoutingVer := 'xyz';
    end;

    var
        RecGCapLedEntry: Record "Capacity Ledger Entry";
        GLAccBudgetBuf: Record "G/L Acc. Budget Buffer";
        RecGManuCycleSetup: Record "PWD Manufacturing cycles Setup";
        RecGRoutingTemp: Record "Routing Line" temporary;
        // BooLExist: Boolean;
        CodGRoutingVer: Code[10];
        CodGRoutingNo: Code[20];
        DecGPerte: Decimal;
        DecGRunTime: Decimal;
        DecGSetupTime: Decimal;
        DecGTimeEx: Decimal;
        DecGTimeExReal: Decimal;
        DecGTimePrep: Decimal;
        DecGTimePrepReal: Decimal;
        NbOf: Integer;
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        N__ArticleCaptionLbl: Label 'N° Article';
        Nb_OFCaptionLbl: Label 'Nb OF';
        "PériodeCaptionLbl": Label 'Période';
        Prod__Order___ListCaptionLbl: Label 'Real Standard Comparison Routing';
        Prod__Order_Routing_Line__No__CaptionLbl: Label 'No.';
        Prod__Order_Routing_Line__Operation_No__CaptionLbl: Label 'Operation No.';
        Prod__Order_Routing_Line_DescriptionCaptionLbl: Label 'Description';
        Prod__Order_Routing_Line_TypeCaptionLbl: Label 'Type';
        "Quantité_rebut_réelCaptionLbl": Label 'Qté rebut réel %';
        RunTimeUnitofMeasCaptionLbl: Label 'Run Time Unit of Meas';
        ScrapFactorCaptionLbl: Label 'Scrap Factor %';
        SetupTimeUnitofMeasCaptionLbl: Label 'Setup Time Unit of Meas';
        Temps_d_execution__CaptionLbl: Label 'Tps d''exe %';
        "Temps_d_execution_réelCaptionLbl": Label 'Tps d''exe réel';
        Temps_d_execution_standardCaptionLbl: Label 'Tps d''exe Std';
        "Temps_de_préparation__CaptionLbl": Label 'Tps Prépa %';
        "Temps_préparation_réelCaptionLbl": Label 'Tps Prépa réel';
        "Temps_préparation_standardCaptionLbl": Label 'Tps Prépa Std';
        DateFilter: Text[30];


    procedure GetTimePrepExReal(RecPRoutingLine: Record "Routing Line"; RecPOrderLine: Record "Prod. Order Line"; var DecPTimeExReal: Decimal; var DecPTimePrepReal: Decimal; var DecPQtyRebut: Decimal)
    var
        RecLCapLedEntry: Record "Capacity Ledger Entry";
        RecLProdOrderLine: Record "Prod. Order Line";
        Nbre: Integer;
    begin
        Clear(DecPTimeExReal);
        Clear(DecPTimePrepReal);
        Clear(DecPQtyRebut);
        RecLCapLedEntry.Reset();
        RecLCapLedEntry.SetFilter("Posting Date", DateFilter);
        RecLCapLedEntry.SetRange("Item No.", RecPOrderLine."Item No.");
        RecLCapLedEntry.SetRange("Operation No.", RecPRoutingLine."Operation No.");
        RecLCapLedEntry.SetRange("Routing No.", RecPRoutingLine."Routing No.");
        Nbre := 0;
        if RecLCapLedEntry.FindSet() then
            repeat
                RecLProdOrderLine.Reset();
                RecLProdOrderLine.SetRange(Status, RecLProdOrderLine.Status::Finished);
                RecLProdOrderLine.SetRange("Routing No.", RecPRoutingLine."Routing No.");
                RecLProdOrderLine.SetRange("Routing Version Code", RecPRoutingLine."Version Code");
                RecLProdOrderLine.SetRange("Prod. Order No.", RecLCapLedEntry."Order No.");
                if not RecLProdOrderLine.IsEmpty then begin
                    Nbre += 1;
                    DecPTimeExReal += RecLCapLedEntry."Run Time" / RecLCapLedEntry."Output Quantity";
                    DecPTimePrepReal += RecLCapLedEntry."Setup Time";
                    DecPQtyRebut += RecLCapLedEntry."Scrap Quantity" / (RecLCapLedEntry."Scrap Quantity" + RecLCapLedEntry."Output Quantity");
                end;
            until RecLCapLedEntry.Next() = 0;
        if Nbre <> 0 then begin
            DecPTimeExReal := Round((DecPTimeExReal / Nbre), 0.001);
            DecPTimePrepReal := Round((DecPTimePrepReal / Nbre), 0.001);
            DecPQtyRebut := Round((DecPQtyRebut / Nbre) * 100, 0.1);
        end;
    end;

    local procedure TransferRoutingIntoRoutingTemp(RecPProdOrderLine: Record "Prod. Order Line"; var RecPRoutingTemp: Record "Routing Line")
    var
        RecLProdOrderRtngLine: Record "Prod. Order Routing Line";
        RecLRtngLine: Record "Routing Line";
        RecLRtngLine2: Record "Routing Line";
    begin
        if RecPProdOrderLine."Routing No." = '' then
            exit;
        RecPRoutingTemp.DeleteAll();
        if (CodGRoutingNo <> RecPProdOrderLine."Routing No.") or (CodGRoutingVer <> RecPProdOrderLine."Routing Version Code") then begin
            RecLRtngLine.Reset();
            RecLRtngLine.SetRange("Routing No.", RecPProdOrderLine."Routing No.");
            RecLRtngLine.SetRange("Version Code", RecPProdOrderLine."Routing Version Code");
            if RecLRtngLine.FindFirst() then
                repeat
                    RecPRoutingTemp.TransferFields(RecLRtngLine);
                    RecPRoutingTemp.Insert();
                until RecLRtngLine.Next() = 0;
            CodGRoutingNo := RecPProdOrderLine."Routing No.";
            CodGRoutingVer := RecPProdOrderLine."Routing Version Code";
        end;

        // BooLExist := false;
        RecLProdOrderRtngLine.Reset();
        RecLProdOrderRtngLine.SetRange(Status, RecPProdOrderLine.Status);
        RecLProdOrderRtngLine.SetRange("Prod. Order No.", RecPProdOrderLine."Prod. Order No.");
        RecLProdOrderRtngLine.SetRange("Routing Reference No.", RecPProdOrderLine."Routing Reference No.");
        RecLProdOrderRtngLine.SetRange("Routing No.", RecPProdOrderLine."Routing No.");
        if RecLProdOrderRtngLine.FindSet() then
            repeat
                if not RecLRtngLine2.Get(RecLProdOrderRtngLine."Routing No.", RecPProdOrderLine."Routing Version Code",
                                            RecLProdOrderRtngLine."Operation No.") then begin
                    RecPRoutingTemp.Init();
                    RecPRoutingTemp."Routing No." := RecLProdOrderRtngLine."Routing No.";
                    RecPRoutingTemp."Version Code" := RecPProdOrderLine."Routing Version Code";
                    RecPRoutingTemp."Operation No." := RecLProdOrderRtngLine."Operation No.";
                    RecPRoutingTemp."Routing No." := RecLProdOrderRtngLine."Routing No.";
                    RecPRoutingTemp."Operation No." := RecLProdOrderRtngLine."Operation No.";
                    RecPRoutingTemp.Type := RecLProdOrderRtngLine.Type;
                    RecPRoutingTemp."No." := RecLProdOrderRtngLine."No.";
                    RecPRoutingTemp."Work Center No." := RecLProdOrderRtngLine."Work Center No.";
                    RecPRoutingTemp."Work Center Group Code" := RecLProdOrderRtngLine."Work Center Group Code";
                    RecPRoutingTemp.Description := RecLProdOrderRtngLine.Description;
                    RecPRoutingTemp."Setup Time" := 0;
                    RecPRoutingTemp."Run Time" := 0;
                    RecPRoutingTemp."Setup Time Unit of Meas. Code" := RecLProdOrderRtngLine."Setup Time Unit of Meas. Code";
                    RecPRoutingTemp."Run Time Unit of Meas. Code" := RecLProdOrderRtngLine."Run Time Unit of Meas. Code";
                    RecPRoutingTemp."PWD Fixed-step Prod. Rate time" := false;
                    RecPRoutingTemp.Insert();
                end;
            until RecLProdOrderRtngLine.Next() = 0;
    end;
}

