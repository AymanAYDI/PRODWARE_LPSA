report 99099 "PWD Balance of production OLD"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/BalanceofproductionOLD.rdl';
    Caption = 'Balance of production';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Order));
            RequestFilterFields = "No.";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }
            column(USERID; UserId)
            {
            }
            column(Sales_Header___No__; "Sales Header"."No.")
            {
            }
            column(Sales_Header___Sell_to_Customer_No__; "Sales Header"."Sell-to Customer No.")
            {
            }
            column(Sales_Header___Sell_to_Customer_Name_; "Sales Header"."Sell-to Customer Name")
            {
            }
            column(GQtyOF_GQtyPerte; GQtyOF - GQtyPerte)
            {
            }
            column(QtyNeed; QtyNeed)
            {
            }
            column(Grend; Grend)
            {
            }
            column(GProd; GProd)
            {
            }
            column(Prod__Order___ListCaption; Prod__Order___ListCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(N__CommandeCaption; N__CommandeCaptionLbl)
            {
            }
            column(N__ClientCaption; N__ClientCaptionLbl)
            {
            }
            column(Nom_ClientCaption; Nom_ClientCaptionLbl)
            {
            }
            column("Total_GénéralCaption"; Total_GénéralCaptionLbl)
            {
            }
            column("Qté_sur_OFCaption"; Qté_sur_OFCaptionLbl)
            {
            }
            column("Qté_ProduiteCaption"; Qté_ProduiteCaptionLbl)
            {
            }
            column("Coût_Réel_MPCaption"; Coût_Réel_MPCaptionLbl)
            {
            }
            column("Coût_Réel_STRCaption"; Coût_Réel_STRCaptionLbl)
            {
            }
            column("Coût_Réel_MOCaption"; Coût_Réel_MOCaptionLbl)
            {
            }
            column("ProductivitéCaption"; ProductivitéCaptionLbl)
            {
            }
            column(RendementCaption; RendementCaptionLbl)
            {
            }
            column(Sales_Header_Document_Type; "Document Type")
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") WHERE(Type = CONST(Item));
                column(SalesLine_LineNo; "Line No.")
                {
                }
                column(Sales_Line_Document_Type; "Document Type")
                {
                }
                column(Sales_Line_Document_No_; "Document No.")
                {
                }
                column(Sales_Line_No_; "No.")
                {
                }
                dataitem(Item; Item)
                {
                    DataItemLink = "No." = FIELD("No.");
                    DataItemTableView = SORTING("No.");
                    RequestFilterFields = "No.";
                    column(Item__No__; "No.")
                    {
                    }
                    column(N__ArticleCaption; N__ArticleCaptionLbl)
                    {
                    }
                    dataitem("Prod. Order Line"; "Prod. Order Line")
                    {
                        DataItemLink = "Item No." = FIELD("No.");
                        DataItemTableView = SORTING(Status, "Prod. Order No.", "Line No.");
                        RequestFilterFields = "Prod. Order No.";
                        column(ProdOrderLine_LineNo; "Line No.")
                        {
                        }
                        column(ProdOrderNo; "Prod. Order No.")
                        {
                        }
                        column(Prod__Order_Line_Status; Status)
                        {
                        }
                        column(Prod__Order_Line_Item_No_; "Item No.")
                        {
                        }
                        dataitem("Prod. Order Component"; "Prod. Order Component")
                        {
                            DataItemLink = "Prod. Order No." = FIELD("Prod. Order No."), "Prod. Order Line No." = FIELD("Line No.");
                            DataItemTableView = SORTING(Status, "Prod. Order No.", "Prod. Order Line No.", "Line No.");
                            column(Prod__Order_Component__Item_No__; "Item No.")
                            {
                            }
                            column(Prod__Order_Component_Description; Description)
                            {
                            }
                            column(Prod__Order_Component_Status; Status)
                            {
                            }
                            column(QtyNeed_Control1100267006; QtyNeed)
                            {
                            }
                            column(QtyConsommed; QtyConsommed)
                            {
                            }
                            column(Prod__Order_Component__Unit_of_Measure_Code_; "Unit of Measure Code")
                            {
                            }
                            column(GRebutPerte; GRebutPerte)
                            {
                            }
                            column(QtyConsommed_Control1100267047; QtyConsommed)
                            {
                            }
                            column(QtyNeed_Control1100267022; QtyNeed)
                            {
                            }
                            column(GCostPrevu; GCostPrevu)
                            {
                            }
                            column(GCostReal; GCostReal)
                            {
                            }
                            column(GCostReal_Control1100267050; GCostReal)
                            {
                            }
                            column(GEcartCost; GEcartCost)
                            {
                            }
                            column(Prod__Order_Component__Line_No__; "Line No.")
                            {
                            }
                            column(Prod__Order_Component__Line_No__Caption; FieldCaption("Line No."))
                            {
                            }
                            column(Prod__Order_Component__Item_No__Caption; FieldCaption("Item No."))
                            {
                            }
                            column(Prod__Order_Component_DescriptionCaption; FieldCaption(Description))
                            {
                            }
                            column(Prod__Order_Component_StatusCaption; FieldCaption(Status))
                            {
                            }
                            column(Qte_besoin_sur_OFCaption; Qte_besoin_sur_OFCaptionLbl)
                            {
                            }
                            column("Qté_consomméeCaption"; Qté_consomméeCaptionLbl)
                            {
                            }
                            column(Prod__Order_Component__Unit_of_Measure_Code_Caption; FieldCaption("Unit of Measure Code"))
                            {
                            }
                            column(Rebut_PerteCaption; Rebut_PerteCaptionLbl)
                            {
                            }
                            column("Qté_consommation_PrévuCaption"; Qté_consommation_PrévuCaptionLbl)
                            {
                            }
                            column("Qté_consommation_RéaliséCaption"; Qté_consommation_RéaliséCaptionLbl)
                            {
                            }
                            column("Coût_PrévuCaption"; Coût_PrévuCaptionLbl)
                            {
                            }
                            column("Coût_RéelCaption"; Coût_RéelCaptionLbl)
                            {
                            }
                            column("Ecart_CoûtCaption"; Ecart_CoûtCaptionLbl)
                            {
                            }
                            column("Coût_Réel_MPCaption_Control1100267037"; Coût_Réel_MPCaption_Control1100267037Lbl)
                            {
                            }
                            column("Coût_Réel_STRCaption_Control1100267044"; Coût_Réel_STRCaption_Control1100267044Lbl)
                            {
                            }
                            column("Coût_Réel_MOCaption_Control1100267045"; Coût_Réel_MOCaption_Control1100267045Lbl)
                            {
                            }
                            column(Prod__Order_Component_Prod__Order_No_; "Prod. Order No.")
                            {
                            }
                            column(Prod__Order_Component_Prod__Order_Line_No_; "Prod. Order Line No.")
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                QtyConsommed := GetQtyConsommed("Prod. Order No.", "Item No.");
                                QtyNeed := GetQtyNeedOF("Prod. Order No.", "Item No.");
                                if QtyNeed <> 0 then
                                    GRebutPerte := ((QtyConsommed - QtyNeed) / QtyNeed) * 100;
                                GCostPrevu := GetCostPrevu("Prod. Order No.", "Item No.");
                                GCostReal := GetCostReal("Prod. Order No.", "Item No.");
                                if GCostPrevu <> 0 then
                                    GEcartCost := GCostReal / GCostPrevu;
                            end;
                        }
                        dataitem("Prod. Order Routing Line"; "Prod. Order Routing Line")
                        {
                            DataItemLink = "Prod. Order No." = FIELD("Prod. Order No.");
                            DataItemTableView = SORTING(Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.");
                            column(Prod__Order_Routing_Line__Operation_No__; "Operation No.")
                            {
                            }
                            column(Prod__Order_Routing_Line_Type; Type)
                            {
                            }
                            column(Prod__Order_Routing_Line__No__; "No.")
                            {
                            }
                            column(Prod__Order_Routing_Line_Description; Description)
                            {
                            }
                            column(Prod__Order_Routing_Line_Status; Status)
                            {
                            }
                            column(GQtyOF; GQtyOF)
                            {
                            }
                            column(GQtyProduct; GQtyProduct)
                            {
                            }
                            column(RecGCapLedEntry__Unit_of_Measure_Code_; RecGCapLedEntry."Unit of Measure Code")
                            {
                            }
                            column(GQtyPerte; GQtyPerte)
                            {
                            }
                            column(GTimePrevu; GTimePrevu)
                            {
                            }
                            column(GTimeReal; GTimeReal)
                            {
                            }
                            column(GCostReal2; GCostReal2)
                            {
                            }
                            column(GCostPrevu2; GCostPrevu2)
                            {
                            }
                            column(GEcartCost2; GEcartCost2)
                            {
                            }
                            column(GProd_Control1100267061; GProd)
                            {
                            }
                            column(Grend_Control1100267062; Grend)
                            {
                            }
                            column(GQtyOF_GQtyPerte_Control1100267082; GQtyOF - GQtyPerte)
                            {
                            }
                            column(GCostReal_GCostReal2; GCostReal + GCostReal2)
                            {
                            }
                            column(GCostReal_GCostReal2___GQtyOF_GQtyPerte_; (GCostReal + GCostReal2) / (GQtyOF - GQtyPerte))
                            {
                            }
                            column(Prod__Order_Routing_Line__Prod__Order_No__; "Prod. Order No.")
                            {
                            }
                            column(Prod__Order_Routing_Line__Operation_No__Caption; FieldCaption("Operation No."))
                            {
                            }
                            column(Prod__Order_Routing_Line_TypeCaption; FieldCaption(Type))
                            {
                            }
                            column(Prod__Order_Routing_Line__No__Caption; FieldCaption("No."))
                            {
                            }
                            column(Prod__Order_Routing_Line_DescriptionCaption; FieldCaption(Description))
                            {
                            }
                            column(Prod__Order_Routing_Line_StatusCaption; FieldCaption(Status))
                            {
                            }
                            column("Qté_sur_OFCaption_Control1100267023"; Qté_sur_OFCaption_Control1100267023Lbl)
                            {
                            }
                            column("Coût_Réel_MPCaption_Control1100267024"; Coût_Réel_MPCaption_Control1100267024Lbl)
                            {
                            }
                            column("Temps_PrévuCaption"; Temps_PrévuCaptionLbl)
                            {
                            }
                            column("Ecart_CoûtCaption_Control1100267026"; Ecart_CoûtCaption_Control1100267026Lbl)
                            {
                            }
                            column(Rebut_PerteCaption_Control1100267027; Rebut_PerteCaption_Control1100267027Lbl)
                            {
                            }
                            column("UnitéCaption"; UnitéCaptionLbl)
                            {
                            }
                            column("Qté_ProduiteCaption_Control1100267029"; Qté_ProduiteCaption_Control1100267029Lbl)
                            {
                            }
                            column("Temps_réelCaption"; Temps_réelCaptionLbl)
                            {
                            }
                            column("Coût_PrévuCaption_Control1100267031"; Coût_PrévuCaption_Control1100267031Lbl)
                            {
                            }
                            column("Coût_RéelCaption_Control1100267032"; Coût_RéelCaption_Control1100267032Lbl)
                            {
                            }
                            column("Coût_Réel_STRCaption_Control1100267033"; Coût_Réel_STRCaption_Control1100267033Lbl)
                            {
                            }
                            column("Coût_Réel_MOCaption_Control1100267034"; Coût_Réel_MOCaption_Control1100267034Lbl)
                            {
                            }
                            column("ProductivitéCaption_Control1100267035"; ProductivitéCaption_Control1100267035Lbl)
                            {
                            }
                            column(RendementCaption_Control1100267036; RendementCaption_Control1100267036Lbl)
                            {
                            }
                            column(Total_OFCaption; Total_OFCaptionLbl)
                            {
                            }
                            column("Quantité_en_coursCaption"; Quantité_en_coursCaptionLbl)
                            {
                            }
                            column(Prix_unitaireCaption; Prix_unitaireCaptionLbl)
                            {
                            }
                            column(Val_En_coursCaption; Val_En_coursCaptionLbl)
                            {
                            }
                            column(Valeur_unitaireCaption; Valeur_unitaireCaptionLbl)
                            {
                            }
                            column(Prod__Order_Routing_Line_Routing_Reference_No_; "Routing Reference No.")
                            {
                            }
                            column(Prod__Order_Routing_Line_Routing_No_; "Routing No.")
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                GQtyOF := GetQtyOF("Prod. Order No.", Item."No.");
                                GQtyProduct := GetQtyProduct("Operation No.", Item."No.");

                                GQtyPerte := GetQtyPerte("Operation No.", Item."No.");
                                GTimePrevu := GetTimePrevu("Operation No.", Item."No.");
                                GTimeReal := GetTimeReal("Operation No.", Item."No.");
                                GCostPrevu2 := GetCostPrevu2("Operation No.", Item."No.");
                                GCostReal2 := GetCostReal2("Operation No.", Item."No.");
                                GEcartCost2 := GCostReal2 - GCostPrevu2;
                                if GTimeReal <> 0 then
                                    GProd := (1 - (GTimeReal - GTimePrevu) / GTimeReal) * 100;
                                i += 1;
                                GQtyProductT[i] := GQtyProduct;
                                if i = 1 then begin
                                    if (GQtyOF <> 0) then
                                        Grend := (GQtyProduct / GQtyOF) * 100
                                end else
                                    if (GQtyProductT[i - 1] <> 0) then
                                        Grend := GQtyProduct / GQtyProductT[i - 1];

                                RecGCapLedEntry.Reset;
                                RecGCapLedEntry.SetRange("Posting Date", GStartDate, GEndDate);
                                RecGCapLedEntry.SetRange("Operation No.", "Operation No.");
                                RecGCapLedEntry.SetRange("Item No.", Item."No.");
                                RecGCapLedEntry.SetRange("Prod. Order No.", "Prod. Order Line"."Prod. Order No.");
                                if RecGCapLedEntry.FindFirst then;
                            end;

                            trigger OnPreDataItem()
                            begin
                                i := 0;
                                GOpertLenght := "Prod. Order Routing Line".Count;
                                CurrReport.CreateTotals(GQtyPerte)
                            end;
                        }

                        trigger OnPreDataItem()
                        begin
                            CurrReport.CreateTotals(GCostReal, GCostReal2);
                        end;
                    }
                }

                trigger OnPreDataItem()
                begin
                    //ERROR('message %1',COUNT);
                end;
            }

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals(QtyNeed, GQtyOF, GQtyPerte, GProd, Grend);
                //SETRANGE("Posting Date",GStartDate,GEndDate);
            end;
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
                    field(GStartDate; GStartDate)
                    {
                        Caption = 'Date début';
                        ApplicationArea = All;
                    }
                    field(GEndDate; GEndDate)
                    {
                        Caption = 'Date Fin';
                        ApplicationArea = All;
                    }
                    field(GsalesNo; GsalesNo)
                    {
                        Caption = 'N° commande';
                        Lookup = true;
                        LookupPageID = "Sales List";
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

    trigger OnPreReport()
    begin

        //IF (GStartDate = 0D) OR (GEndDate = 0D)   THEN
        // ERROR(GText001);
    end;

    var
        QtyConsommed: Decimal;
        QtyNeed: Decimal;
        GStartDate: Date;
        GEndDate: Date;
        GRebutPerte: Decimal;
        GCostPrevu: Decimal;
        GCostReal: Decimal;
        GEcartCost: Decimal;
        GQtyOF: Decimal;
        GQtyProduct: Decimal;
        RecGCapLedEntry: Record "Capacity Ledger Entry";
        GQtyPerte: Decimal;
        GTimePrevu: Decimal;
        GTimeReal: Decimal;
        GCostPrevu2: Decimal;
        GCostReal2: Decimal;
        GEcartCost2: Decimal;
        GProd: Decimal;
        Grend: Decimal;
        i: Integer;
        GQtyProductT: array[100] of Decimal;
        GOpertLenght: Integer;
        GText001: Label 'la date de début ou la date de fin ne doit pas être vide.';
        GsalesNo: Code[20];
        Prod__Order___ListCaptionLbl: Label 'Bilan production par commande';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        N__CommandeCaptionLbl: Label 'N° Commande';
        N__ClientCaptionLbl: Label 'N° Client';
        Nom_ClientCaptionLbl: Label 'Nom Client';
        "Total_GénéralCaptionLbl": Label 'Total Général';
        "Qté_sur_OFCaptionLbl": Label 'Qté sur OF';
        "Qté_ProduiteCaptionLbl": Label 'Qté Produite';
        "Coût_Réel_MPCaptionLbl": Label 'Coût Réel MP';
        "Coût_Réel_STRCaptionLbl": Label 'Coût Réel STR';
        "Coût_Réel_MOCaptionLbl": Label 'Coût Réel MO';
        "ProductivitéCaptionLbl": Label 'Productivité';
        RendementCaptionLbl: Label 'Rendement';
        N__ArticleCaptionLbl: Label 'N° Article';
        Qte_besoin_sur_OFCaptionLbl: Label 'Qté besoin sur OF';
        "Qté_consomméeCaptionLbl": Label 'Qté consommée';
        Rebut_PerteCaptionLbl: Label 'Rebut/Perte';
        "Qté_consommation_PrévuCaptionLbl": Label 'Qté consommation Prévu';
        "Qté_consommation_RéaliséCaptionLbl": Label 'Qté consommation Réalisé';
        "Coût_PrévuCaptionLbl": Label 'Coût Prévu';
        "Coût_RéelCaptionLbl": Label 'Coût Réel';
        "Ecart_CoûtCaptionLbl": Label 'Ecart Coût';
        "Coût_Réel_MPCaption_Control1100267037Lbl": Label 'Coût Réel MP';
        "Coût_Réel_STRCaption_Control1100267044Lbl": Label 'Coût Réel STR';
        "Coût_Réel_MOCaption_Control1100267045Lbl": Label 'Coût Réel MO';
        "Qté_sur_OFCaption_Control1100267023Lbl": Label 'Qté sur OF';
        "Coût_Réel_MPCaption_Control1100267024Lbl": Label 'Coût Réel MP';
        "Temps_PrévuCaptionLbl": Label 'Temps Prévu';
        "Ecart_CoûtCaption_Control1100267026Lbl": Label 'Ecart Coût';
        Rebut_PerteCaption_Control1100267027Lbl: Label 'Rebut/Perte';
        "UnitéCaptionLbl": Label 'Unité';
        "Qté_ProduiteCaption_Control1100267029Lbl": Label 'Qté Produite';
        "Temps_réelCaptionLbl": Label 'Temps réel';
        "Coût_PrévuCaption_Control1100267031Lbl": Label 'Coût Prévu';
        "Coût_RéelCaption_Control1100267032Lbl": Label 'Coût Réel';
        "Coût_Réel_STRCaption_Control1100267033Lbl": Label 'Coût Réel STR';
        "Coût_Réel_MOCaption_Control1100267034Lbl": Label 'Coût Réel MO';
        "ProductivitéCaption_Control1100267035Lbl": Label 'Productivité';
        RendementCaption_Control1100267036Lbl: Label 'Rendement';
        Total_OFCaptionLbl: Label 'Total OF';
        "Quantité_en_coursCaptionLbl": Label 'Quantité en cours';
        Prix_unitaireCaptionLbl: Label 'Prix unitaire';
        Val_En_coursCaptionLbl: Label 'Val En cours';
        Valeur_unitaireCaptionLbl: Label 'Valeur unitaire';


    procedure GetQtyConsommed(ProdOrderNo: Code[20]; PItemNo: Code[20]): Decimal
    var
        LQtyConsommed: Decimal;
        RecLItemLedEntry: Record "Item Ledger Entry";
    begin
        RecLItemLedEntry.Reset;
        RecLItemLedEntry.SetRange("Posting Date", GStartDate, GEndDate);
        RecLItemLedEntry.SetRange("Prod. Order No.", ProdOrderNo);
        RecLItemLedEntry.SetRange("Item No.", PItemNo);
        if RecLItemLedEntry.FindFirst then
            repeat
                LQtyConsommed += RecLItemLedEntry.Quantity;
            until RecLItemLedEntry.Next = 0;
        exit(LQtyConsommed);
    end;


    procedure GetQtyNeedOF(ProdOrderNo: Code[20]; PItemNo: Code[20]): Decimal
    var
        LQtyNeed: Decimal;
        RecLProdOrderComp: Record "Prod. Order Component";
    begin
        RecLProdOrderComp.Reset;
        RecLProdOrderComp.SetRange("Prod. Order No.", ProdOrderNo);
        RecLProdOrderComp.SetRange("Item No.", PItemNo);
        if RecLProdOrderComp.FindFirst then
            repeat
                LQtyNeed += RecLProdOrderComp.Quantity;
            until RecLProdOrderComp.Next = 0;
        exit(LQtyNeed);
    end;


    procedure GetCostReal(ProdOrderNo: Code[20]; PItemNo: Code[20]): Decimal
    var
        LCostReal: Decimal;
        RecLItemLedEntry: Record "Item Ledger Entry";
    begin
        RecLItemLedEntry.Reset;
        RecLItemLedEntry.SetRange("Posting Date", GStartDate, GEndDate);
        RecLItemLedEntry.SetRange("Prod. Order No.", ProdOrderNo);
        RecLItemLedEntry.SetRange("Item No.", PItemNo);
        if RecLItemLedEntry.FindFirst then
            repeat
                LCostReal += RecLItemLedEntry."Cost Amount (Actual)";
            until RecLItemLedEntry.Next = 0;
        exit(LCostReal);
    end;


    procedure GetCostPrevu(ProdOrderNo: Code[20]; PItemNo: Code[20]): Decimal
    var
        LCostPrevu: Decimal;
        RecLProdOrderComp: Record "Prod. Order Component";
    begin
        RecLProdOrderComp.Reset;
        RecLProdOrderComp.SetRange("Prod. Order No.", ProdOrderNo);
        RecLProdOrderComp.SetRange("Item No.", PItemNo);
        if RecLProdOrderComp.FindFirst then
            repeat
                LCostPrevu += RecLProdOrderComp."Cost Amount";
            until RecLProdOrderComp.Next = 0;
        exit(LCostPrevu);
    end;


    procedure GetQtyOF(ProdOrderNo: Code[20]; PItemNo: Code[20]): Decimal
    var
        LQtyOF: Decimal;
        RecLProdOrderLine: Record "Prod. Order Line";
    begin
        RecLProdOrderLine.Reset;
        RecLProdOrderLine.SetRange("Prod. Order No.", ProdOrderNo);
        RecLProdOrderLine.SetRange("Item No.", PItemNo);
        if RecLProdOrderLine.FindFirst then
            repeat
                LQtyOF += RecLProdOrderLine.Quantity;
            until RecLProdOrderLine.Next = 0;
        exit(LQtyOF);
    end;


    procedure GetQtyProduct(Poperation: Code[20]; PItemNo: Code[20]): Decimal
    var
        LQtyProduct: Decimal;
        RecLCapLedEntry: Record "Capacity Ledger Entry";
    begin
        RecLCapLedEntry.Reset;
        RecLCapLedEntry.SetRange("Posting Date", GStartDate, GEndDate);
        RecLCapLedEntry.SetRange("Operation No.", Poperation);
        RecLCapLedEntry.SetRange("Item No.", PItemNo);
        if RecLCapLedEntry.FindFirst then
            repeat
                LQtyProduct += RecLCapLedEntry."Output Quantity";
            until RecLCapLedEntry.Next = 0;
        exit(LQtyProduct);
    end;


    procedure GetQtyPerte(Poperation: Code[20]; PItemNo: Code[20]): Decimal
    var
        LQtyPerte: Decimal;
        RecLCapLedEntry: Record "Capacity Ledger Entry";
    begin
        RecLCapLedEntry.Reset;
        RecLCapLedEntry.SetRange("Posting Date", GStartDate, GEndDate);
        RecLCapLedEntry.SetRange("Operation No.", Poperation);
        RecLCapLedEntry.SetRange("Item No.", PItemNo);
        if RecLCapLedEntry.FindFirst then
            repeat
                LQtyPerte += RecLCapLedEntry."Scrap Quantity";
            until RecLCapLedEntry.Next = 0;
        exit(LQtyPerte);
    end;


    procedure GetTimePrevu(Poperation: Code[20]; PItemNo: Code[20]): Decimal
    var
        LTimePrevu: Decimal;
        RecLProdRoutingLine: Record "Prod. Order Routing Line";
    begin
        RecLProdRoutingLine.Reset;
        RecLProdRoutingLine.SetRange("Operation No.", Poperation);
        if RecLProdRoutingLine.FindFirst then
            repeat
                LTimePrevu += RecLProdRoutingLine."Expected Capacity Need";
            until RecLProdRoutingLine.Next = 0;
        exit(LTimePrevu);
    end;


    procedure GetTimeReal(Poperation: Code[20]; PItemNo: Code[20]): Decimal
    var
        LTimeReal: Decimal;
        RecLCapLedEntry: Record "Capacity Ledger Entry";
    begin
        RecLCapLedEntry.Reset;
        RecLCapLedEntry.SetRange("Posting Date", GStartDate, GEndDate);
        RecLCapLedEntry.SetRange("Operation No.", Poperation);
        RecLCapLedEntry.SetRange("Item No.", PItemNo);
        if RecLCapLedEntry.FindFirst then
            repeat
                LTimeReal += RecLCapLedEntry."Setup Time" + RecLCapLedEntry."Run Time";
            until RecLCapLedEntry.Next = 0;
        exit(LTimeReal);
    end;


    procedure GetCostPrevu2(Poperation: Code[20]; PItemNo: Code[20]): Decimal
    var
        LCostPrevu2: Decimal;
        RecLProdRoutingLine: Record "Prod. Order Routing Line";
    begin
        RecLProdRoutingLine.Reset;
        RecLProdRoutingLine.SetRange("Operation No.", Poperation);
        if RecLProdRoutingLine.FindFirst then
            repeat
                LCostPrevu2 += RecLProdRoutingLine."Expected Capacity Need";
            until RecLProdRoutingLine.Next = 0;
        exit(LCostPrevu2);
    end;


    procedure GetCostReal2(Poperation: Code[20]; PItemNo: Code[20]): Decimal
    var
        LCostReal2: Decimal;
        RecLCapLedEntry: Record "Capacity Ledger Entry";
    begin
        RecLCapLedEntry.Reset;
        RecLCapLedEntry.SetRange("Posting Date", GStartDate, GEndDate);
        RecLCapLedEntry.SetRange("Operation No.", Poperation);
        RecLCapLedEntry.SetRange("Item No.", PItemNo);
        if RecLCapLedEntry.FindFirst then
            repeat
                LCostReal2 += RecLCapLedEntry."Setup Time" + RecLCapLedEntry."Run Time";
            until RecLCapLedEntry.Next = 0;
        exit(LCostReal2);
    end;
}

