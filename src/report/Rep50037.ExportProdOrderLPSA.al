report 50037 "PWD Export Prod Order LPSA"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.14
    //  RO : 11/04/2018 : Nouvelles demande Export Prod Order remis à plat
    //                    - new Report

    ProcessingOnly = true;
    UseRequestPage = false;
    UsageCategory = None;
    Caption = 'Export Prod Order LPSA';
    dataset
    {
        dataitem("Prod. Order Line"; "Prod. Order Line")
        {
            DataItemTableView = SORTING(Status, "Send to OSYS (Released)") WHERE(Status = FILTER(Released), "Send to OSYS (Released)" = FILTER(false), "PWD Is Possible Item" = FILTER(false));
            dataitem("Reservation Entry"; "Reservation Entry")
            {
                DataItemLink = "Source ID" = FIELD("Prod. Order No."), "Source Prod. Order Line" = FIELD("Line No.");
                DataItemTableView = SORTING("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name", "Source Prod. Order Line", "Reservation Status", "Shipment Date", "Expected Receipt Date");

                trigger OnAfterGetRecord()
                begin
                    BooGLotDetermined := false;
                    if ("Reservation Entry"."Source Ref. No." <> 0) then begin
                        RecGProdOrderComponent.Get("Reservation Entry"."Source Subtype",
                                                   "Reservation Entry"."Source ID",
                                                   "Reservation Entry"."Source Prod. Order Line",
                                                   "Reservation Entry"."Source Ref. No.");
                        if not RecGProdOrderComponent."PWD Lot Determining" then CurrReport.Skip();
                        BooGLotDetermined := true;
                    end;

                    IntGOperation += 1;

                    //Colonne A
                    OutStreamGlobal.WriteText('T_TrackingSpecification');
                    OutStreamGlobal.WriteText(';');

                    //Colonne B
                    OutStreamGlobal.WriteText("Prod. Order Line"."Prod. Order No." + RecGOSYSSetup."Separator Character" +
                                              Format("Prod. Order Line"."Line No."));
                    OutStreamGlobal.WriteText(';');

                    //Colonne C
                    if "Prod. Order Line"."Variant Code" <> '' then
                        OutStreamGlobal.WriteText("Prod. Order Line"."Item No." + RecGOSYSSetup."Separator Character" + "Prod. Order Line"."Variant Code")
                    else
                        OutStreamGlobal.WriteText("Prod. Order Line"."Item No.");
                    OutStreamGlobal.WriteText(';');

                    //Colonne D
                    if RecGItem.Get("Prod. Order Line"."Item No.") then
                        OutStreamGlobal.WriteText(CduGConvertAsciiToAnsi.AsciiToAnsi(RecGItem."PWD Quartis Description"))
                    else
                        OutStreamGlobal.WriteText(CduGConvertAsciiToAnsi.AsciiToAnsi("Prod. Order Line".Description));
                    OutStreamGlobal.WriteText(';');

                    //Colonne E
                    IntGTempField := "Prod. Order Line".Status.AsInteger();
                    OutStreamGlobal.WriteText(Format(IntGTempField));
                    OutStreamGlobal.WriteText(';');

                    //Colonne F
                    OutStreamGlobal.WriteText(Format("Prod. Order Line".Quantity, 0, 2));
                    OutStreamGlobal.WriteText(';');

                    //Colonne G
                    OutStreamGlobal.WriteText("Prod. Order Line"."Unit of Measure Code");
                    OutStreamGlobal.WriteText(';');

                    //Colonne H
                    OutStreamGlobal.WriteText(Format("Prod. Order Line"."Due Date"));
                    OutStreamGlobal.WriteText(';');

                    //Colonne I
                    OutStreamGlobal.WriteText("Prod. Order Line"."Production BOM No.");
                    OutStreamGlobal.WriteText(';');

                    //Colonne J
                    OutStreamGlobal.WriteText("Prod. Order Line"."Production BOM Version Code");
                    OutStreamGlobal.WriteText(';');

                    //Colonne K
                    TxtGRoutingNo := Format("Prod. Order Line"."Routing No.");
                    OutStreamGlobal.WriteText(CduGConvertAsciiToAnsi.AsciiToAnsi(TxtGRoutingNo));
                    OutStreamGlobal.WriteText(';');

                    //Colonne L
                    TxtGSearchDescription := Format(RecGProductionOrder."Search Description");
                    if RecGProductionOrder.Get("Prod. Order Line".Status, "Prod. Order Line"."Prod. Order No.") then
                        OutStreamGlobal.WriteText(CduGConvertAsciiToAnsi.AsciiToAnsi(TxtGSearchDescription))
                    else
                        OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne M
                    OutStreamGlobal.WriteText("Prod. Order Line"."Routing Version Code");
                    OutStreamGlobal.WriteText(';');

                    //Colonne N
                    OutStreamGlobal.WriteText("Prod. Order Line"."PWD Manufacturing Code");
                    OutStreamGlobal.WriteText(';');

                    //Colonne O
                    OutStreamGlobal.WriteText("Reservation Entry"."Serial No.");
                    OutStreamGlobal.WriteText(';');

                    //Colonne P
                    OutStreamGlobal.WriteText("Reservation Entry"."Lot No.");
                    OutStreamGlobal.WriteText(';');

                    //Colonne Q
                    if ("Reservation Entry"."Lot No." = '') and ("Reservation Entry"."Serial No." = '') then
                        OutStreamGlobal.WriteText('0')
                    else
                        if BooGLotDetermined then
                            OutStreamGlobal.WriteText(Format(-"Reservation Entry"."Quantity (Base)", 0, 2))
                        else
                            OutStreamGlobal.WriteText(Format("Reservation Entry"."Quantity (Base)", 0, 2));
                    OutStreamGlobal.WriteText(';');

                    //Colonne R
                    OutStreamGlobal.WriteText(Format(IntGOperation));
                    OutStreamGlobal.WriteText(';');

                    //Colonne S
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne T
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne U
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne V
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne W
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne X
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne Y
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne Z
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne AA
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne AB
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne AC
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne AD
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne AE
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne AF
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne AG
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne AH
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne AI
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne AJ
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne AK
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne AL
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne AM
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    OutStreamGlobal.WriteText();
                end;
            }
            dataitem("Prod. Order Routing Line"; "Prod. Order Routing Line")
            {
                DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("Prod. Order No."), "Routing Reference No." = FIELD("Routing Reference No."), "Routing No." = FIELD("Routing No.");
                DataItemTableView = WHERE("Flushing Method" = FILTER(Manual));

                trigger OnAfterGetRecord()
                begin
                    //Colonne A
                    OutStreamGlobal.WriteText('T_ProdOrderRoutingLine');
                    OutStreamGlobal.WriteText(';');

                    //Colonne B
                    OutStreamGlobal.WriteText("Prod. Order Line"."Prod. Order No." + RecGOSYSSetup."Separator Character" +
                                              Format("Prod. Order Line"."Line No."));
                    OutStreamGlobal.WriteText(';');

                    //Colonne C
                    if "Prod. Order Line"."Variant Code" <> '' then
                        OutStreamGlobal.WriteText("Prod. Order Line"."Item No." + RecGOSYSSetup."Separator Character" + "Prod. Order Line"."Variant Code")
                    else
                        OutStreamGlobal.WriteText("Prod. Order Line"."Item No.");
                    OutStreamGlobal.WriteText(';');

                    //Colonne D
                    if RecGItem.Get("Prod. Order Line"."Item No.") then
                        OutStreamGlobal.WriteText(CduGConvertAsciiToAnsi.AsciiToAnsi(RecGItem."PWD Quartis Description"))
                    else
                        OutStreamGlobal.WriteText(CduGConvertAsciiToAnsi.AsciiToAnsi("Prod. Order Line".Description));
                    OutStreamGlobal.WriteText(';');

                    //Colonne E
                    IntGTempField := "Prod. Order Line".Status.AsInteger();
                    OutStreamGlobal.WriteText(Format(IntGTempField));
                    OutStreamGlobal.WriteText(';');

                    //Colonne F
                    OutStreamGlobal.WriteText(Format("Prod. Order Line".Quantity, 0, 2));
                    OutStreamGlobal.WriteText(';');

                    //Colonne G
                    OutStreamGlobal.WriteText("Prod. Order Line"."Unit of Measure Code");
                    OutStreamGlobal.WriteText(';');

                    //Colonne H
                    OutStreamGlobal.WriteText(Format("Prod. Order Line"."Due Date"));
                    OutStreamGlobal.WriteText(';');

                    //Colonne I
                    OutStreamGlobal.WriteText("Prod. Order Line"."Production BOM No.");
                    OutStreamGlobal.WriteText(';');

                    //Colonne J
                    OutStreamGlobal.WriteText("Prod. Order Line"."Production BOM Version Code");
                    OutStreamGlobal.WriteText(';');

                    //Colonne K
                    TxtGRoutingNo := Format("Prod. Order Line"."Routing No.");
                    OutStreamGlobal.WriteText(CduGConvertAsciiToAnsi.AsciiToAnsi(TxtGRoutingNo));
                    OutStreamGlobal.WriteText(';');

                    //Colonne L
                    TxtGSearchDescription := Format(RecGProductionOrder."Search Description");
                    if RecGProductionOrder.Get("Prod. Order Line".Status, "Prod. Order Line"."Prod. Order No.") then
                        OutStreamGlobal.WriteText(CduGConvertAsciiToAnsi.AsciiToAnsi(TxtGSearchDescription))
                    else
                        OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne M
                    OutStreamGlobal.WriteText("Prod. Order Line"."Routing Version Code");
                    OutStreamGlobal.WriteText(';');

                    //Colonne N
                    OutStreamGlobal.WriteText("Prod. Order Line"."PWD Manufacturing Code");
                    OutStreamGlobal.WriteText(';');

                    //Colonne O
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne P
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne Q
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne R
                    OutStreamGlobal.WriteText("Prod. Order Routing Line"."Operation No.");
                    OutStreamGlobal.WriteText(';');

                    //Colonne S
                    OutStreamGlobal.WriteText(CduGConvertAsciiToAnsi.AsciiToAnsi("Prod. Order Routing Line".Description));
                    OutStreamGlobal.WriteText(';');

                    //Colonne T
                    IntGTempField := "Prod. Order Routing Line".Type.AsInteger();
                    OutStreamGlobal.WriteText(Format(IntGTempField));
                    OutStreamGlobal.WriteText(';');

                    //Colonne U
                    OutStreamGlobal.WriteText(Format("Prod. Order Routing Line"."Next Operation No."));
                    OutStreamGlobal.WriteText(';');

                    //Colonne V
                    if "Prod. Order Routing Line".Type = "Prod. Order Routing Line".Type::"Machine Center" then
                        OutStreamGlobal.WriteText("Prod. Order Routing Line"."No.")
                    else
                        OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne W
                    OutStreamGlobal.WriteText(Format("Prod. Order Routing Line"."Starting Date-Time"));
                    OutStreamGlobal.WriteText(';');

                    //Colonne X
                    OutStreamGlobal.WriteText(Format("Prod. Order Routing Line"."Ending Date-Time"));
                    OutStreamGlobal.WriteText(';');

                    //Colonne Y
                    OutStreamGlobal.WriteText(Format("Prod. Order Routing Line"."Setup Time", 0, 2));
                    OutStreamGlobal.WriteText(';');

                    //Colonne Z
                    OutStreamGlobal.WriteText(Format("Prod. Order Routing Line"."Run Time", 0, 2));
                    OutStreamGlobal.WriteText(';');

                    //Colonne AA
                    IntGTempField := "Prod. Order Routing Line"."Routing Status";
                    OutStreamGlobal.WriteText(Format(IntGTempField));
                    OutStreamGlobal.WriteText(';');

                    //Colonne AB
                    OutStreamGlobal.WriteText("Prod. Order Routing Line"."Prod. Order No." +
                                              Format("Prod. Order Routing Line"."Routing Reference No.") +
                                              "Prod. Order Routing Line"."Operation No.");
                    OutStreamGlobal.WriteText(';');

                    //Colonne AC
                    RecGProdOrderRtngCommLine.Reset();
                    RecGProdOrderRtngCommLine.SetRange("Prod. Order No.", "Prod. Order Routing Line"."Prod. Order No.");
                    RecGProdOrderRtngCommLine.SetRange("Routing Reference No.", "Prod. Order Routing Line"."Routing Reference No.");
                    RecGProdOrderRtngCommLine.SetRange("Routing No.", "Prod. Order Routing Line"."Routing No.");
                    RecGProdOrderRtngCommLine.SetRange("Operation No.", "Prod. Order Routing Line"."Operation No.");
                    if RecGProdOrderRtngCommLine.IsEmpty then
                        OutStreamGlobal.WriteText('')
                    else
                        OutStreamGlobal.WriteText('ATTENTION CONSIGNES A SUIVRE SUR LA FICHE SUIVEUSE');
                    OutStreamGlobal.WriteText(';');

                    //Colonne AD
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne AE
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne AF
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne AG
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne AH
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne AI
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne AJ
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne AK
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne AL
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne AM
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    OutStreamGlobal.WriteText();
                end;
            }
            dataitem("Prod. Order Component"; "Prod. Order Component")
            {
                DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("Prod. Order No."), "Prod. Order Line No." = FIELD("Line No.");
                DataItemTableView = WHERE("PWD Lot Determining" = FILTER(false));
                dataitem(ReservationEntryComponent; "Reservation Entry")
                {
                    DataItemLink = "Source ID" = FIELD("Prod. Order No."), "Source Prod. Order Line" = FIELD("Prod. Order Line No."), "Source Ref. No." = FIELD("Line No.");
                    DataItemTableView = SORTING("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name", "Source Prod. Order Line", "Reservation Status", "Shipment Date", "Expected Receipt Date");

                    trigger OnAfterGetRecord()
                    begin
                        IntGOperation += 1;

                        //Colonne A
                        OutStreamGlobal.WriteText('T_TrackingSpecificationComponent');
                        OutStreamGlobal.WriteText(';');

                        //Colonne B
                        OutStreamGlobal.WriteText("Prod. Order Line"."Prod. Order No." + RecGOSYSSetup."Separator Character" +
                                                  Format("Prod. Order Line"."Line No."));
                        OutStreamGlobal.WriteText(';');

                        //Colonne C
                        if "Prod. Order Line"."Variant Code" <> '' then
                            OutStreamGlobal.WriteText("Prod. Order Line"."Item No." + RecGOSYSSetup."Separator Character" + "Prod. Order Line"."Variant Code")
                        else
                            OutStreamGlobal.WriteText("Prod. Order Line"."Item No.");
                        OutStreamGlobal.WriteText(';');

                        //Colonne D
                        if RecGItem.Get("Prod. Order Line"."Item No.") then
                            OutStreamGlobal.WriteText(CduGConvertAsciiToAnsi.AsciiToAnsi(RecGItem."PWD Quartis Description"))
                        else
                            OutStreamGlobal.WriteText(CduGConvertAsciiToAnsi.AsciiToAnsi("Prod. Order Line".Description));
                        OutStreamGlobal.WriteText(';');

                        //Colonne E
                        IntGTempField := "Prod. Order Line".Status.AsInteger();
                        OutStreamGlobal.WriteText(Format(IntGTempField));
                        OutStreamGlobal.WriteText(';');

                        //Colonne F
                        OutStreamGlobal.WriteText(Format("Prod. Order Line".Quantity, 0, 2));
                        OutStreamGlobal.WriteText(';');

                        //Colonne G
                        OutStreamGlobal.WriteText("Prod. Order Line"."Unit of Measure Code");
                        OutStreamGlobal.WriteText(';');

                        //Colonne H
                        OutStreamGlobal.WriteText(Format("Prod. Order Line"."Due Date"));
                        OutStreamGlobal.WriteText(';');

                        //Colonne I
                        OutStreamGlobal.WriteText("Prod. Order Line"."Production BOM No.");
                        OutStreamGlobal.WriteText(';');

                        //Colonne J
                        OutStreamGlobal.WriteText("Prod. Order Line"."Production BOM Version Code");
                        OutStreamGlobal.WriteText(';');

                        //Colonne K
                        TxtGRoutingNo := Format("Prod. Order Line"."Routing No.");
                        OutStreamGlobal.WriteText(CduGConvertAsciiToAnsi.AsciiToAnsi(TxtGRoutingNo));
                        OutStreamGlobal.WriteText(';');

                        //Colonne L
                        TxtGSearchDescription := Format(RecGProductionOrder."Search Description");
                        if RecGProductionOrder.Get("Prod. Order Line".Status, "Prod. Order Line"."Prod. Order No.") then
                            OutStreamGlobal.WriteText(CduGConvertAsciiToAnsi.AsciiToAnsi(TxtGSearchDescription))
                        else
                            OutStreamGlobal.WriteText('');
                        OutStreamGlobal.WriteText(';');

                        //Colonne M
                        OutStreamGlobal.WriteText("Prod. Order Line"."Routing Version Code");
                        OutStreamGlobal.WriteText(';');

                        //Colonne N
                        OutStreamGlobal.WriteText("Prod. Order Line"."PWD Manufacturing Code");
                        OutStreamGlobal.WriteText(';');

                        //Colonne O
                        OutStreamGlobal.WriteText('');
                        OutStreamGlobal.WriteText(';');

                        //Colonne P
                        OutStreamGlobal.WriteText('');
                        OutStreamGlobal.WriteText(';');

                        //Colonne Q
                        OutStreamGlobal.WriteText('');
                        OutStreamGlobal.WriteText(';');

                        //Colonne R
                        OutStreamGlobal.WriteText(Format(IntGOperation));
                        OutStreamGlobal.WriteText(';');

                        //Colonne S
                        OutStreamGlobal.WriteText('');
                        OutStreamGlobal.WriteText(';');

                        //Colonne T
                        OutStreamGlobal.WriteText('');
                        OutStreamGlobal.WriteText(';');

                        //Colonne U
                        OutStreamGlobal.WriteText('');
                        OutStreamGlobal.WriteText(';');

                        //Colonne V
                        OutStreamGlobal.WriteText('');
                        OutStreamGlobal.WriteText(';');

                        //Colonne W
                        OutStreamGlobal.WriteText('');
                        OutStreamGlobal.WriteText(';');

                        //Colonne X
                        OutStreamGlobal.WriteText('');
                        OutStreamGlobal.WriteText(';');

                        //Colonne Y
                        OutStreamGlobal.WriteText('');
                        OutStreamGlobal.WriteText(';');

                        //Colonne Z
                        OutStreamGlobal.WriteText('');
                        OutStreamGlobal.WriteText(';');

                        //Colonne AA
                        OutStreamGlobal.WriteText('');
                        OutStreamGlobal.WriteText(';');

                        //Colonne AB
                        OutStreamGlobal.WriteText('');
                        OutStreamGlobal.WriteText(';');

                        //Colonne AC
                        OutStreamGlobal.WriteText('');
                        OutStreamGlobal.WriteText(';');

                        //Colonne AD
                        OutStreamGlobal.WriteText("Prod. Order Component"."Item No.");
                        OutStreamGlobal.WriteText(';');

                        //Colonne AE
                        OutStreamGlobal.WriteText(Format("Prod. Order Component"."Quantity per", 0, 2));
                        OutStreamGlobal.WriteText(';');

                        //Colonne AF
                        OutStreamGlobal.WriteText(Format("Prod. Order Component"."Expected Quantity", 0, 2));
                        OutStreamGlobal.WriteText(';');

                        //Colonne AG
                        RecGProdOrderRoutingLine.Reset();
                        RecGProdOrderRoutingLine.SetRange("Prod. Order No.", "Prod. Order Component"."Prod. Order No.");
                        RecGProdOrderRoutingLine.SetRange("Routing Link Code", "Prod. Order Component"."Routing Link Code");
                        if RecGProdOrderRoutingLine.FindFirst() then
                            OutStreamGlobal.WriteText(Format(RecGProdOrderRoutingLine."Operation No."))
                        else
                            OutStreamGlobal.WriteText('');
                        OutStreamGlobal.WriteText(';');

                        //Colonne AH
                        OutStreamGlobal.WriteText('');
                        OutStreamGlobal.WriteText(';');

                        //Colonne AI
                        OutStreamGlobal.WriteText('');
                        OutStreamGlobal.WriteText(';');

                        //Colonne AJ
                        OutStreamGlobal.WriteText('');
                        OutStreamGlobal.WriteText(';');

                        //Colonne AK
                        OutStreamGlobal.WriteText(ReservationEntryComponent."Serial No.");
                        OutStreamGlobal.WriteText(';');

                        //Colonne AL
                        OutStreamGlobal.WriteText(ReservationEntryComponent."Lot No.");
                        OutStreamGlobal.WriteText(';');

                        //Colonne AM
                        if (ReservationEntryComponent."Lot No." = '') and (ReservationEntryComponent."Serial No." = '') then
                            OutStreamGlobal.WriteText('0')
                        else
                            OutStreamGlobal.WriteText(Format(-ReservationEntryComponent."Quantity (Base)", 0, 2));
                        OutStreamGlobal.WriteText(';');

                        OutStreamGlobal.WriteText();
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    IntGOperation += 1;

                    //Colonne A
                    OutStreamGlobal.WriteText('T_ProdOrderComponent');
                    OutStreamGlobal.WriteText(';');

                    //Colonne B
                    OutStreamGlobal.WriteText("Prod. Order Line"."Prod. Order No." + RecGOSYSSetup."Separator Character" +
                                              Format("Prod. Order Line"."Line No."));
                    OutStreamGlobal.WriteText(';');

                    //Colonne C
                    if "Prod. Order Line"."Variant Code" <> '' then
                        OutStreamGlobal.WriteText("Prod. Order Line"."Item No." + RecGOSYSSetup."Separator Character" + "Prod. Order Line"."Variant Code")
                    else
                        OutStreamGlobal.WriteText("Prod. Order Line"."Item No.");
                    OutStreamGlobal.WriteText(';');

                    //Colonne D
                    if RecGItem.Get("Prod. Order Line"."Item No.") then
                        OutStreamGlobal.WriteText(CduGConvertAsciiToAnsi.AsciiToAnsi(RecGItem."PWD Quartis Description"))
                    else
                        OutStreamGlobal.WriteText(CduGConvertAsciiToAnsi.AsciiToAnsi("Prod. Order Line".Description));
                    OutStreamGlobal.WriteText(';');

                    //Colonne E
                    IntGTempField := "Prod. Order Line".Status.AsInteger();
                    OutStreamGlobal.WriteText(Format(IntGTempField));
                    OutStreamGlobal.WriteText(';');

                    //Colonne F
                    OutStreamGlobal.WriteText(Format("Prod. Order Line".Quantity, 0, 2));
                    OutStreamGlobal.WriteText(';');

                    //Colonne G
                    OutStreamGlobal.WriteText("Prod. Order Line"."Unit of Measure Code");
                    OutStreamGlobal.WriteText(';');

                    //Colonne H
                    OutStreamGlobal.WriteText(Format("Prod. Order Line"."Due Date"));
                    OutStreamGlobal.WriteText(';');

                    //Colonne I
                    OutStreamGlobal.WriteText("Prod. Order Line"."Production BOM No.");
                    OutStreamGlobal.WriteText(';');

                    //Colonne J
                    OutStreamGlobal.WriteText("Prod. Order Line"."Production BOM Version Code");
                    OutStreamGlobal.WriteText(';');

                    //Colonne K
                    TxtGRoutingNo := Format("Prod. Order Line"."Routing No.");
                    OutStreamGlobal.WriteText(CduGConvertAsciiToAnsi.AsciiToAnsi(TxtGRoutingNo));
                    OutStreamGlobal.WriteText(';');

                    //Colonne L
                    TxtGSearchDescription := Format(RecGProductionOrder."Search Description");
                    if RecGProductionOrder.Get("Prod. Order Line".Status, "Prod. Order Line"."Prod. Order No.") then
                        OutStreamGlobal.WriteText(CduGConvertAsciiToAnsi.AsciiToAnsi(TxtGSearchDescription))
                    else
                        OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne M
                    OutStreamGlobal.WriteText("Prod. Order Line"."Routing Version Code");
                    OutStreamGlobal.WriteText(';');

                    //Colonne N
                    OutStreamGlobal.WriteText("Prod. Order Line"."PWD Manufacturing Code");
                    OutStreamGlobal.WriteText(';');

                    //Colonne O
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne P
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne Q
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne R
                    OutStreamGlobal.WriteText(Format(IntGOperation));
                    OutStreamGlobal.WriteText(';');

                    //Colonne S
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne T
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne U
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne V
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne W
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne X
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne Y
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne Z
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne AA
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne AB
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne AC
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne AD
                    OutStreamGlobal.WriteText("Prod. Order Component"."Item No.");
                    OutStreamGlobal.WriteText(';');

                    //Colonne AE
                    OutStreamGlobal.WriteText(Format("Prod. Order Component"."Quantity per", 0, 2));
                    OutStreamGlobal.WriteText(';');

                    //Colonne AF
                    OutStreamGlobal.WriteText(Format("Prod. Order Component"."Expected Quantity", 0, 2));
                    OutStreamGlobal.WriteText(';');

                    //Colonne AG
                    RecGProdOrderRoutingLine.Reset();
                    RecGProdOrderRoutingLine.SetRange("Prod. Order No.", "Prod. Order Component"."Prod. Order No.");
                    RecGProdOrderRoutingLine.SetRange("Routing Link Code", "Prod. Order Component"."Routing Link Code");
                    if RecGProdOrderRoutingLine.FindFirst() then
                        OutStreamGlobal.WriteText(Format(RecGProdOrderRoutingLine."Operation No."))
                    else
                        OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne AH
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne AI
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne AJ
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne AK
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne AL
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    //Colonne AM
                    OutStreamGlobal.WriteText('');
                    OutStreamGlobal.WriteText(';');

                    OutStreamGlobal.WriteText();
                end;
            }

            trigger OnAfterGetRecord()
            var
                RecLProdOrderLine: Record "Prod. Order Line";
            begin
                IntGOperation := 1;

                //Colonne A
                OutStreamGlobal.WriteText('T_ProdOrderLine');
                OutStreamGlobal.WriteText(';');

                //Colonne B
                OutStreamGlobal.WriteText("Prod. Order Line"."Prod. Order No." + RecGOSYSSetup."Separator Character" +
                                          Format("Prod. Order Line"."Line No."));
                OutStreamGlobal.WriteText(';');

                //Colonne C
                if "Prod. Order Line"."Variant Code" <> '' then
                    OutStreamGlobal.WriteText("Prod. Order Line"."Item No." + RecGOSYSSetup."Separator Character" + "Prod. Order Line"."Variant Code")
                else
                    OutStreamGlobal.WriteText("Prod. Order Line"."Item No.");
                OutStreamGlobal.WriteText(';');

                //Colonne D
                if RecGItem.Get("Prod. Order Line"."Item No.") then
                    OutStreamGlobal.WriteText(CduGConvertAsciiToAnsi.AsciiToAnsi(RecGItem."PWD Quartis Description"))
                else
                    OutStreamGlobal.WriteText(CduGConvertAsciiToAnsi.AsciiToAnsi("Prod. Order Line".Description));
                OutStreamGlobal.WriteText(';');

                //Colonne E
                IntGTempField := "Prod. Order Line".Status.AsInteger();
                OutStreamGlobal.WriteText(Format(IntGTempField));
                OutStreamGlobal.WriteText(';');

                //Colonne F
                OutStreamGlobal.WriteText(Format("Prod. Order Line".Quantity, 0, 2));
                OutStreamGlobal.WriteText(';');

                //Colonne G
                OutStreamGlobal.WriteText("Prod. Order Line"."Unit of Measure Code");
                OutStreamGlobal.WriteText(';');

                //Colonne H
                OutStreamGlobal.WriteText(Format("Prod. Order Line"."Due Date"));
                OutStreamGlobal.WriteText(';');

                //Colonne I
                OutStreamGlobal.WriteText("Prod. Order Line"."Production BOM No.");
                OutStreamGlobal.WriteText(';');

                //Colonne J
                OutStreamGlobal.WriteText("Prod. Order Line"."Production BOM Version Code");
                OutStreamGlobal.WriteText(';');

                //Colonne K
                TxtGRoutingNo := Format("Prod. Order Line"."Routing No.");
                OutStreamGlobal.WriteText(CduGConvertAsciiToAnsi.AsciiToAnsi(TxtGRoutingNo));
                OutStreamGlobal.WriteText(';');

                //Colonne L
                TxtGSearchDescription := Format(RecGProductionOrder."Search Description");
                if RecGProductionOrder.Get("Prod. Order Line".Status, "Prod. Order Line"."Prod. Order No.") then
                    OutStreamGlobal.WriteText(CduGConvertAsciiToAnsi.AsciiToAnsi(TxtGSearchDescription))
                else
                    OutStreamGlobal.WriteText('');
                OutStreamGlobal.WriteText(';');

                //Colonne M
                OutStreamGlobal.WriteText("Prod. Order Line"."Routing Version Code");
                OutStreamGlobal.WriteText(';');

                //Colonne N
                OutStreamGlobal.WriteText("Prod. Order Line"."PWD Manufacturing Code");
                OutStreamGlobal.WriteText(';');

                //Colonne O
                OutStreamGlobal.WriteText('');
                OutStreamGlobal.WriteText(';');

                //Colonne P
                OutStreamGlobal.WriteText('');
                OutStreamGlobal.WriteText(';');

                //Colonne Q
                OutStreamGlobal.WriteText('');
                OutStreamGlobal.WriteText(';');

                //Colonne R
                OutStreamGlobal.WriteText(Format(IntGOperation));
                OutStreamGlobal.WriteText(';');

                //Colonne S
                OutStreamGlobal.WriteText('');
                OutStreamGlobal.WriteText(';');

                //Colonne T
                OutStreamGlobal.WriteText('');
                OutStreamGlobal.WriteText(';');

                //Colonne U
                OutStreamGlobal.WriteText('');
                OutStreamGlobal.WriteText(';');

                //Colonne V
                OutStreamGlobal.WriteText('');
                OutStreamGlobal.WriteText(';');

                //Colonne W
                OutStreamGlobal.WriteText('');
                OutStreamGlobal.WriteText(';');

                //Colonne X
                OutStreamGlobal.WriteText('');
                OutStreamGlobal.WriteText(';');

                //Colonne Y
                OutStreamGlobal.WriteText('');
                OutStreamGlobal.WriteText(';');

                //Colonne Z
                OutStreamGlobal.WriteText('');
                OutStreamGlobal.WriteText(';');

                //Colonne AA
                OutStreamGlobal.WriteText('');
                OutStreamGlobal.WriteText(';');

                //Colonne AB
                OutStreamGlobal.WriteText('');
                OutStreamGlobal.WriteText(';');

                //Colonne AC
                OutStreamGlobal.WriteText('');
                OutStreamGlobal.WriteText(';');

                //Colonne AD
                OutStreamGlobal.WriteText('');
                OutStreamGlobal.WriteText(';');

                //Colonne AE
                OutStreamGlobal.WriteText('');
                OutStreamGlobal.WriteText(';');

                //Colonne AF
                OutStreamGlobal.WriteText('');
                OutStreamGlobal.WriteText(';');

                //Colonne AG
                OutStreamGlobal.WriteText('');
                OutStreamGlobal.WriteText(';');

                //Colonne AH
                OutStreamGlobal.WriteText('');
                OutStreamGlobal.WriteText(';');

                //Colonne AI
                OutStreamGlobal.WriteText('');
                OutStreamGlobal.WriteText(';');

                //Colonne AJ
                OutStreamGlobal.WriteText('');
                OutStreamGlobal.WriteText(';');

                //Colonne AK
                OutStreamGlobal.WriteText('');
                OutStreamGlobal.WriteText(';');

                //Colonne AL
                OutStreamGlobal.WriteText('');
                OutStreamGlobal.WriteText(';');

                //Colonne AM
                OutStreamGlobal.WriteText('');
                OutStreamGlobal.WriteText(';');

                OutStreamGlobal.WriteText();

                RecLProdOrderLine.Get("Prod. Order Line".Status, "Prod. Order Line"."Prod. Order No.", "Prod. Order Line"."Line No.");
                RecLProdOrderLine."Send to OSYS (Released)" := true;
                RecLProdOrderLine.Modify();
            end;

            trigger OnPreDataItem()
            begin
                RecGOSYSSetup.Get();
                RecGTempBlob.CreateOutStream(OutStreamGlobal);
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
        RecGItem: Record Item;
        RecGProdOrderComponent: Record "Prod. Order Component";
        RecGProdOrderRoutingLine: Record "Prod. Order Routing Line";
        RecGProdOrderRtngCommLine: Record "Prod. Order Rtng Comment Line";
        RecGProductionOrder: Record "Production Order";
        RecGOSYSSetup: Record "PWD OSYS Setup";
        CduGConvertAsciiToAnsi: Codeunit "PWD Convert Ascii To Ansi";
        RecGTempBlob: Codeunit "Temp Blob";
        BooGLotDetermined: Boolean;
        IntGOperation: Integer;
        IntGTempField: Integer;
        OutStreamGlobal: OutStream;
        TxtGRoutingNo: Text[30];
        TxtGSearchDescription: Text[50];

    procedure FctInitRep(): Boolean
    var
        RecLProdOrderLine: Record "Prod. Order Line";
    begin
        RecLProdOrderLine.SetCurrentKey(Status, "Send to OSYS (Released)");
        RecLProdOrderLine.SetRange(Status, RecLProdOrderLine.Status::Released);
        RecLProdOrderLine.SetRange("PWD Is Possible Item", false);
        if not RecGOSYSSetup.PlannerOne then
            RecLProdOrderLine.SetRange("Send to OSYS (Released)", false);

        exit(not RecLProdOrderLine.IsEmpty);
    end;

    procedure FctGetBlob(var TempBlob: Codeunit "Temp Blob")
    begin
        TempBlob := RecGTempBlob;
    end;
}

