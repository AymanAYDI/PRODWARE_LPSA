xmlport 8073323 "PWD Export Prod Order OSYS"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.06
    // OSYS-Int001.001:GR 18/10/2011   Connector integration
    //                                   - Create Object
    // 
    // 
    // 
    // //>>ProdConnect1.07.02.02
    // OSYS-Int001.002:GR 07/02/2012   Connector integration
    //                                 - Add new Tag : F_OperationDescription
    //                                 - Add C\AL in tags triggers , FctProdOrderLine , FctInitXML();
    //                                 - Fix bug in : T_TrackingSpecification - Export::OnPreXMLItem()
    //                                 - C\AL in    : FctProdOrderRoutingLine
    // 
    // 
    // //>>ProdConnect2.00
    // OSYS-Int001.003:GR 31/07/2012   Connector integration
    //                                 - C\AL in    : FctCanExportRoutingLine
    //                                                F_CodeTool - Export::OnBeforePassVariable()
    //                                                F_CodeComment - Export::OnBeforePassVariable()
    //                                                F_CodePersonnel - Export::OnBeforePassVariable()
    // 
    // 
    // //>>LAP2.02
    // Specifique.LPSA.001:GR  Gestion de la traçabilité chez la pirette
    // 
    // //>>LAP2.06
    // FE_LAPRIERRETTE_GP0004.001 :GR  23/05/13  - C\AL in   FctProdOrderLine
    // 
    // //>>TDL.LPSA.28.03.2014.NIBO : Export Quartis Description
    // 
    // //>>TDL.LPSA.22.01.2015.RALA : Export Quartis Search Description
    // +----------------------------------------------------------------------------------------------------------------+

    Caption = 'Export Prod Order OSYS';

    schema
    {
        textelement(OSYS)
        {
            MinOccurs = Zero;
            tableelement("Prod. Order Line"; "Prod. Order Line")
            {
                MinOccurs = Zero;
                XmlName = 'T_ProdOrderLine';
                UseTemporary = true;
                textelement(F_Prod_Order_No)
                {

                    trigger OnBeforePassVariable()
                    begin
                        F_Prod_Order_No := "Prod. Order Line"."Prod. Order No." + RecGOSYSSetup."Separator Character" +
                                            Format("Prod. Order Line"."Line No.");
                    end;
                }
                textelement(F_Item_No)
                {

                    trigger OnBeforePassVariable()
                    begin
                        if "Prod. Order Line"."Variant Code" <> '' then
                            F_Item_No := "Prod. Order Line"."Item No." + RecGOSYSSetup."Separator Character" + "Prod. Order Line"."Variant Code"
                        else
                            F_Item_No := "Prod. Order Line"."Item No.";
                    end;
                }
                textelement(F_Description)
                {

                    trigger OnBeforePassVariable()
                    var
                        RecLItem: Record Item;
                    begin
                        //>>TDL.LPSA.28.03.2014.NIBO
                        //F_Description := "Prod. Order Line".Description;
                        if RecLItem.Get("Prod. Order Line"."Item No.") then
                            F_Description := RecLItem."PWD Quartis Description"
                        else
                            F_Description := "Prod. Order Line".Description;
                        //<<TDL.LPSA.28.03.2014.NIBO
                    end;
                }
                textelement(F_Status)
                {

                    trigger OnBeforePassVariable()
                    begin
                        IntGTempField := "Prod. Order Line".Status.AsInteger();
                        F_Status := Format(IntGTempField);
                    end;
                }
                textelement(F_Quantity)
                {

                    trigger OnBeforePassVariable()
                    begin
                        F_Quantity := Format("Prod. Order Line".Quantity, 0, 2);
                    end;
                }
                textelement(F_UnitofMeasure)
                {

                    trigger OnBeforePassVariable()
                    begin
                        F_UnitofMeasure := "Prod. Order Line"."Unit of Measure Code";
                    end;
                }
                textelement(F_DueDate)
                {

                    trigger OnBeforePassVariable()
                    begin
                        F_DueDate := Format("Prod. Order Line"."Due Date");
                    end;
                }
                textelement(F_ProductionBOMNo)
                {

                    trigger OnBeforePassVariable()
                    begin
                        F_ProductionBOMNo := "Prod. Order Line"."Production BOM No.";
                    end;
                }
                textelement(F_ProductionBOMVersionCode)
                {

                    trigger OnBeforePassVariable()
                    begin
                        F_ProductionBOMVersionCode := "Prod. Order Line"."Production BOM Version Code";
                    end;
                }
                textelement(F_RoutingNo)
                {

                    trigger OnBeforePassVariable()
                    begin
                        F_RoutingNo := "Prod. Order Line"."Routing No.";
                    end;
                }
                textelement(F_ResearchDesignation)
                {

                    trigger OnBeforePassVariable()
                    var
                        RecLProductionOrder: Record "Production Order";
                    begin
                        //>>TDL.LPSA.22.01.2015.RALA
                        if RecLProductionOrder.Get("Prod. Order Line".Status, "Prod. Order Line"."Prod. Order No.") then
                            F_ResearchDesignation := RecLProductionOrder."Search Description"
                        else
                            F_ResearchDesignation := '';
                        //<<TDL.LPSA.22.01.2015.RALA
                    end;
                }
                textelement(F_RoutingVersionCode)
                {

                    trigger OnBeforePassVariable()
                    begin
                        F_RoutingVersionCode := "Prod. Order Line"."Routing Version Code";
                    end;
                }
                textelement(F_ManufacturingCode)
                {

                    trigger OnBeforePassVariable()
                    begin
                        F_ManufacturingCode := "Prod. Order Line"."PWD Manufacturing Code";
                    end;
                }
                tableelement("Tracking Specification"; "Tracking Specification")
                {
                    XmlName = 'T_TrackingSpecification';
                    UseTemporary = true;
                    textelement(F_SerialNo)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            F_SerialNo := "Tracking Specification"."Serial No.";
                        end;
                    }
                    textelement(F_LotNo)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            F_LotNo := "Tracking Specification"."Lot No.";
                        end;
                    }
                    textelement(F_QuantityProdOrderLine)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            F_QuantityProdOrderLine := Format("Tracking Specification"."Quantity (Base)", 0, 2);
                        end;
                    }

                    trigger OnPreXmlItem()
                    begin
                        //>>OSYS-Int001.002:GR 07/02/2012
                        //OLD : FctGetTrackingSpecification("Prod. Order Line", "Tracking Specification");
                        FctProdOrderTrackingSpec("Prod. Order Line", "Tracking Specification");
                        //<<OSYS-Int001.002:GR 07/02/2012
                    end;
                }
                tableelement("Record Link"; "Record Link")
                {
                    MinOccurs = Zero;
                    XmlName = 'T_RecordLink';
                    UseTemporary = true;
                    textelement(F_URL)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            //TODO: Field 'URL2','URL3' et 'URL4' are removed.
                            // F_URL := "Record Link".URL1 + "Record Link".URL2 + "Record Link".URL3 + "Record Link".URL4;
                        end;
                    }
                    textelement(F_DescriptionLink)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            F_DescriptionLink := "Record Link".Description;
                        end;
                    }
                    textelement(F_User)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            F_User := "Record Link"."User ID";
                        end;
                    }

                    trigger OnPreXmlItem()
                    begin
                        FctRecordLink("Prod. Order Line", "Record Link");
                    end;
                }
                tableelement("Prod. Order Routing Line"; "Prod. Order Routing Line")
                {
                    MinOccurs = Zero;
                    XmlName = 'T_ProdOrderRoutingLine';
                    UseTemporary = true;
                    textelement(F_Operation)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            F_Operation := "Prod. Order Routing Line"."Operation No.";
                        end;
                    }
                    textelement(F_OperationDescription)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            //>>OSYS-Int001.002
                            F_OperationDescription := "Prod. Order Routing Line".Description;
                            //<<OSYS-Int001.002
                        end;
                    }
                    textelement(F_Type)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            //>>OSYS-Int001.002
                            /*OLD:
                            IntGTempField := "Prod. Order Routing Line".Type;
                            F_Type := FORMAT(IntGTempField);
                            */
                            //TODO: 'Record "Prod. Order Routing Line"' does not contain a field 'Planned Ress. No.' and 'Planned Ress. Type'
                            // if ("Prod. Order Routing Line"."Planned Ress. No." <> '') and RecGOSYSSetup.PlannerOne and FctPlannerOnePermission() then begin
                            //     IntGTempField := "Prod. Order Routing Line"."Planned Ress. Type";
                            //     F_Type := Format(IntGTempField);
                            // end
                            // else begin
                            //     IntGTempField := "Prod. Order Routing Line".Type;
                            //     F_Type := Format(IntGTempField);
                            // end;
                            // //>>OSYS-Int001.002

                        end;
                    }
                    textelement(F_NextOperationNo)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            F_NextOperationNo := Format("Prod. Order Routing Line"."Next Operation No.");
                        end;
                    }
                    textelement(F_No)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            //>>OSYS-Int001.002
                            /*OLD:
                            IF "Prod. Order Routing Line".Type  = "Prod. Order Routing Line".Type::"Machine Center" THEN
                              F_No := "Prod. Order Routing Line"."No."
                            ELSE
                              F_No := '';
                            */
                            //TODO: 'Record "Prod. Order Routing Line"' does not contain a field 'Planned Ress. No.', 'Planned Ress. Type' 
                            //     if ("Prod. Order Routing Line"."Planned Ress. No." <> '') and RecGOSYSSetup.PlannerOne and FctPlannerOnePermission() then begin
                            //         if "Prod. Order Routing Line"."Planned Ress. Type" = "Prod. Order Routing Line"."Planned Ress. Type"::"Machine Center" then
                            //             F_No := "Prod. Order Routing Line"."Planned Ress. No."
                            //         else
                            //             F_No := '';
                            //     end
                            //     else
                            //         if "Prod. Order Routing Line".Type = "Prod. Order Routing Line".Type::"Machine Center" then
                            //             F_No := "Prod. Order Routing Line"."No."
                            //         else
                            //             F_No := '';
                            //     //>>OSYS-Int001.002
                        end;
                    }
                    textelement(F_StartingDateTime)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            F_StartingDateTime := Format("Prod. Order Routing Line"."Starting Date-Time");
                        end;
                    }
                    textelement(F_EndingDateTime)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            F_EndingDateTime := Format("Prod. Order Routing Line"."Ending Date-Time");
                        end;
                    }
                    textelement(F_SetupTime)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            F_SetupTime := Format("Prod. Order Routing Line"."Setup Time", 0, 2);
                        end;
                    }
                    textelement(F_RunTime)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            F_RunTime := Format("Prod. Order Routing Line"."Run Time", 0, 2);
                        end;
                    }
                    textelement(F_RoutingStatus)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            IntGTempField := "Prod. Order Routing Line"."Routing Status";
                            F_RoutingStatus := Format(IntGTempField);
                        end;
                    }
                    tableelement(recordlinkrouting; "Record Link")
                    {
                        MinOccurs = Zero;
                        XmlName = 'T_RecordLinkRouting';
                        UseTemporary = true;
                        textelement(F_URLRouting)
                        {

                            trigger OnBeforePassVariable()
                            begin
                                //TODO: Field 'URL2','URL3' et 'URL4' are removed.
                                //F_URLRouting := RecordLinkRouting.URL1 + RecordLinkRouting.URL2 + RecordLinkRouting.URL3 + RecordLinkRouting.URL4;
                            end;
                        }
                        textelement(F_DescriptionLinkRouting)
                        {

                            trigger OnBeforePassVariable()
                            begin
                                F_DescriptionLinkRouting := RecordLinkRouting.Description;
                            end;
                        }
                        textelement(F_UserRouting)
                        {

                            trigger OnBeforePassVariable()
                            begin
                                F_UserRouting := RecordLinkRouting."User ID";
                            end;
                        }

                        trigger OnPreXmlItem()
                        begin
                            FctRecordLinkRouting("Prod. Order Routing Line", RecordLinkRouting);
                        end;
                    }
                    tableelement("Prod. Order Routing Tool"; "Prod. Order Routing Tool")
                    {
                        MinOccurs = Zero;
                        XmlName = 'T_ProdOrderRoutingTool';
                        UseTemporary = true;
                        textelement(F_CodeTool)
                        {

                            trigger OnBeforePassVariable()
                            begin
                                //>>OSYS-Int001.003
                                //OLD: F_CodeTool := "Prod. Order Routing Tool"."No.";
                                F_CodeTool := Format("Prod. Order Routing Tool"."Line No.");
                                //<<OSYS-Int001.003
                            end;
                        }
                        textelement(F_DescriptionTool)
                        {

                            trigger OnBeforePassVariable()
                            begin
                                F_DescriptionTool := "Prod. Order Routing Tool".Description;
                            end;
                        }

                        trigger OnPreXmlItem()
                        begin
                            FctProdOrderRoutingTool("Prod. Order Routing Line", "Prod. Order Routing Tool");
                        end;
                    }
                    tableelement("Prod. Order Rtng Comment Line"; "Prod. Order Rtng Comment Line")
                    {
                        MinOccurs = Zero;
                        XmlName = 'T_ProdOrderRtngCommentLine';
                        UseTemporary = true;
                        textelement(F_CodeComment)
                        {

                            trigger OnBeforePassVariable()
                            begin
                                //>>OSYS-Int001.003
                                //OLD:F_CodeComment := "Prod. Order Rtng Comment Line".Code;
                                F_CodeComment := Format("Prod. Order Rtng Comment Line"."Line No.");
                                //<<OSYS-Int001.003
                            end;
                        }
                        textelement(F_DescriptionComment)
                        {

                            trigger OnBeforePassVariable()
                            begin
                                F_DescriptionComment := "Prod. Order Rtng Comment Line".Comment;
                            end;
                        }

                        trigger OnPreXmlItem()
                        begin
                            FctProdOrderRtngCommentLine("Prod. Order Routing Line", "Prod. Order Rtng Comment Line");
                        end;
                    }
                    tableelement("Prod. Order Routing Personnel"; "Prod. Order Routing Personnel")
                    {
                        MinOccurs = Zero;
                        XmlName = 'T_ProdOrderRtngPersonnel';
                        UseTemporary = true;
                        textelement(F_CodePersonnel)
                        {

                            trigger OnBeforePassVariable()
                            begin
                                //>>OSYS-Int001.003
                                //OLD : F_CodePersonnel := "Prod. Order Routing Personnel"."No.";
                                F_CodePersonnel := Format("Prod. Order Routing Personnel"."Line No.");
                                //<<OSYS-Int001.003
                            end;
                        }
                        textelement(F_DescriptionPersonnel)
                        {

                            trigger OnBeforePassVariable()
                            begin
                                F_DescriptionPersonnel := "Prod. Order Routing Personnel".Description;
                            end;
                        }

                        trigger OnPreXmlItem()
                        begin
                            FctProdOrderRtngPersonnel("Prod. Order Routing Line", "Prod. Order Routing Personnel");
                        end;
                    }

                    trigger OnPreXmlItem()
                    begin
                        FctProdOrderRoutingLine("Prod. Order Line", "Prod. Order Routing Line");
                    end;
                }
                tableelement("Prod. Order Component"; "Prod. Order Component")
                {
                    MinOccurs = Zero;
                    XmlName = 'T_ProdOrderComponent';
                    UseTemporary = true;
                    textelement(F_Item_NoComponent)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            F_Item_NoComponent := "Prod. Order Component"."Item No.";
                        end;
                    }
                    textelement(F_QuantityPer)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            F_QuantityPer := Format("Prod. Order Component"."Quantity per", 0, 2);
                        end;
                    }
                    textelement(F_ExpectedQuantity)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            F_ExpectedQuantity := Format("Prod. Order Component"."Expected Quantity", 0, 2);
                        end;
                    }
                    textelement(F_OperationNo)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            "Prod. Order Routing Line".Reset();
                            "Prod. Order Routing Line".SetRange("Prod. Order No.", "Prod. Order Component"."Prod. Order No.");
                            "Prod. Order Routing Line".SetRange("Routing Link Code", "Prod. Order Component"."Routing Link Code");
                            if "Prod. Order Routing Line".FindFirst() then
                                F_OperationNo := Format("Prod. Order Routing Line"."Operation No.")
                            else
                                F_OperationNo := '';
                            "Prod. Order Routing Line".Reset();
                        end;
                    }
                    textelement(F_Postion1)
                    {
                    }
                    textelement(F_Postion2)
                    {
                    }
                    textelement(F_Postion3)
                    {
                    }
                    tableelement(trackingspecificationcomponent; "Tracking Specification")
                    {
                        XmlName = 'T_TrackingSpecificationComponent';
                        UseTemporary = true;
                        textelement(F_Serial)
                        {

                            trigger OnBeforePassVariable()
                            begin
                                F_Serial := TrackingSpecificationComponent."Serial No.";
                            end;
                        }
                        textelement(F_Lot)
                        {

                            trigger OnBeforePassVariable()
                            begin
                                F_Lot := TrackingSpecificationComponent."Lot No.";
                            end;
                        }
                        textelement(F_QuantityCompo)
                        {

                            trigger OnBeforePassVariable()
                            begin
                                F_QuantityCompo := Format(TrackingSpecificationComponent."Quantity (Base)", 0, 2);
                            end;
                        }

                        trigger OnPreXmlItem()
                        begin
                            FctProdOrderTrackingSpecCompo("Prod. Order Component", TrackingSpecificationComponent);
                        end;
                    }

                    trigger OnPreXmlItem()
                    begin
                        FctProdOrderComponent("Prod. Order Line", "Prod. Order Component");
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    RecLProdOrderLine: Record "Prod. Order Line";
                begin
                    RecLProdOrderLine.Get("Prod. Order Line".Status, "Prod. Order Line"."Prod. Order No.", "Prod. Order Line"."Line No.");
                    if RecLProdOrderLine.Status = RecLProdOrderLine.Status::Released then
                        RecLProdOrderLine."Send to OSYS (Released)" := true
                    else
                        RecLProdOrderLine."Send to OSYS (Finished)" := true;
                    RecLProdOrderLine.Modify();
                end;

                trigger OnPreXmlItem()
                begin
                    FctProdOrderLine("Prod. Order Line");
                end;
            }
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

    trigger OnPreXmlPort()
    begin
        RecGOSYSSetup.Get();

        FctInitXML();
    end;

    var
        RecGOSYSSetup: Record "PWD OSYS Setup";
        CduGConnectorBufferMgtExport: Codeunit "Connector Buffer Mgt Export";
        CodGConnectorPartner: Code[20];
        IntGIndent: Integer;
        IntGProdOrderStatus: Integer;
        IntGTempField: Integer;
        IntGTranckingSpecifCompoTempNo: Integer;
        IntGTranckingSpecificationNo: Integer;


    procedure FctDefinePartner(var RecPConnectorMes: Record "PWD Connector Messages")
    begin
        CodGConnectorPartner := RecPConnectorMes."Partner Code";
    end;


    procedure FctCheckValues(var RecPProdOrderLine: Record "Prod. Order Line"; BooPInsertValue: Boolean): Boolean
    var
        RecLProdOrderComponent: Record "Prod. Order Component";
        RecLProdOrderComponent2: Record "Prod. Order Component";
        RecLProdOrderRoutingLine: Record "Prod. Order Routing Line";
        RecLProdOrderRtngPersonnel: Record "Prod. Order Routing Personnel";
        RecLProdOrderRoutingTool: Record "Prod. Order Routing Tool";
        RecLProdOrderRtngCommentLine: Record "Prod. Order Rtng Comment Line";
        RecLRecordLink: Record "Record Link";
        RecLRecordLinkRouting: Record "Record Link";
        RecLTrackingSpecifCompoTemp: Record "Tracking Specification" temporary;
        RecLTrackingSpecificationTemp: Record "Tracking Specification" temporary;
        CodLConnectorOSYSParseData: Codeunit "PWD Connector OSYS Parse Data";
        RecordRef: RecordRef;
        RecordRefTemp: RecordRef;
        FieldRef: FieldRef;
        BooLError: Boolean;
        CodLNextOp: Code[1024];
    begin
        BooLError := false;

        RecordRef.GetTable(RecPProdOrderLine);

        if CduGConnectorBufferMgtExport.FctCheckFields(RecordRef) then
            BooLError := true;

        if BooPInsertValue then begin
            RecordRefTemp.GetTable("Prod. Order Line");
            RecordRefTemp.Init();
            CduGConnectorBufferMgtExport.FctTransferFields(RecordRef, RecordRefTemp);
            RecordRefTemp.Insert();
        end;

        //>>DEBUT Parcours de la tracabilité
        FctGetTrackingSpecification(RecPProdOrderLine, RecLTrackingSpecificationTemp);

        //>>Specifique.LPSA.001
        if RecLTrackingSpecificationTemp.IsEmpty then begin
            FctProdOrderComponent(RecPProdOrderLine, RecLProdOrderComponent2);
            RecLProdOrderComponent2.SetRange("Flushing Method");
            RecLProdOrderComponent2.SetRange("PWD Lot Determining", true);
            if not RecLProdOrderComponent2.IsEmpty then begin
                RecLProdOrderComponent2.FindFirst();
                FctProdOrderTrackingSpecCompo(RecLProdOrderComponent2, RecLTrackingSpecificationTemp);
                FctGetTrackingSpecifComponent(RecLProdOrderComponent2, RecLTrackingSpecificationTemp);
            end;
        end;
        //<<Specifique.LPSA.001

        if not RecLTrackingSpecificationTemp.IsEmpty then begin
            RecLTrackingSpecificationTemp.FindSet();
            repeat
                RecordRef.GetTable(RecLTrackingSpecificationTemp);

                if CduGConnectorBufferMgtExport.FctCheckFields(RecordRef) then
                    BooLError := true;

                if BooPInsertValue then begin
                    IntGTranckingSpecificationNo += 1;
                    RecordRefTemp.GetTable("Tracking Specification");
                    RecordRefTemp.Init();
                    CduGConnectorBufferMgtExport.FctTransferFields(RecordRef, RecordRefTemp);

                    FieldRef := RecordRefTemp.Field(1);
                    FieldRef.Value := IntGTranckingSpecificationNo;
                    RecordRefTemp.Insert();
                end;
            until RecLTrackingSpecificationTemp.Next() = 0;
        end;
        //<<FIN Parcours de la tracabilité

        //>>DEBUT Parcours des liens associés
        FctRecordLink(RecPProdOrderLine, RecLRecordLink);
        if not RecLRecordLink.IsEmpty then begin
            RecLRecordLink.FindSet();
            repeat
                RecordRef.GetTable(RecLRecordLink);

                if CduGConnectorBufferMgtExport.FctCheckFields(RecordRef) then
                    BooLError := true;

                if BooPInsertValue then begin
                    RecordRefTemp.GetTable("Record Link");
                    RecordRefTemp.Init();
                    CduGConnectorBufferMgtExport.FctTransferFields(RecordRef, RecordRefTemp);
                    if RecordRefTemp.Insert() then;
                end;
            until RecLRecordLink.Next() = 0;
        end;
        //<<FIN Parcours des liens associés

        //>>DEBUT Parcours des gammes
        FctProdOrderRoutingLine(RecPProdOrderLine, RecLProdOrderRoutingLine);
        if not RecLProdOrderRoutingLine.IsEmpty then begin
            RecLProdOrderRoutingLine.FindSet();
            repeat
                CodLNextOp := '';
                if FctCanExportRoutingLine(RecLProdOrderRoutingLine, CodLNextOp) then begin
                    CodLConnectorOSYSParseData.FctConvertUnit(RecLProdOrderRoutingLine);

                    RecordRef.GetTable(RecLProdOrderRoutingLine);

                    if CduGConnectorBufferMgtExport.FctCheckFields(RecordRef) then
                        BooLError := true;

                    if BooPInsertValue then begin
                        RecordRefTemp.GetTable("Prod. Order Routing Line");
                        RecordRefTemp.Init();
                        CduGConnectorBufferMgtExport.FctTransferFields(RecordRef, RecordRefTemp);
                        FieldRef := RecordRefTemp.Field(5);
                        FieldRef.Value(CopyStr(CodLNextOp, 1, 30));
                        RecordRefTemp.Insert();
                    end;

                    //>>DEBUT Parcours des liens associés
                    FctRecordLinkRouting(RecLProdOrderRoutingLine, RecLRecordLinkRouting);
                    if not RecLRecordLinkRouting.IsEmpty then begin
                        RecLRecordLinkRouting.FindSet();
                        repeat
                            RecordRef.GetTable(RecLRecordLinkRouting);

                            if CduGConnectorBufferMgtExport.FctCheckFields(RecordRef) then
                                BooLError := true;

                            if BooPInsertValue then begin
                                RecordRefTemp.GetTable(RecordLinkRouting);
                                RecordRefTemp.Init();

                                CduGConnectorBufferMgtExport.FctTransferFields(RecordRef, RecordRefTemp);
                                RecordRefTemp.Insert();
                            end;
                        until RecLRecordLinkRouting.Next() = 0;
                    end;
                    //<<FIN Parcours des liens associés

                    //>>DEBUT Parcours des lignes de commentaires d'une gamme
                    FctProdOrderRtngCommentLine(RecLProdOrderRoutingLine, RecLProdOrderRtngCommentLine);
                    if not RecLProdOrderRtngCommentLine.IsEmpty then begin
                        RecLProdOrderRtngCommentLine.FindSet();
                        repeat
                            RecordRef.GetTable(RecLProdOrderRtngCommentLine);

                            if CduGConnectorBufferMgtExport.FctCheckFields(RecordRef) then
                                BooLError := true;

                            if BooPInsertValue then begin
                                RecordRefTemp.GetTable("Prod. Order Rtng Comment Line");
                                RecordRefTemp.Init();
                                CduGConnectorBufferMgtExport.FctTransferFields(RecordRef, RecordRefTemp);
                                RecordRefTemp.Insert();
                            end;
                        until RecLProdOrderRtngCommentLine.Next() = 0;
                    end;
                    //<<FIN Parcours des lignes de commentaires d'une gamme

                    //>>DEBUT Parcours des outillages d'une gamme
                    FctProdOrderRoutingTool(RecLProdOrderRoutingLine, RecLProdOrderRoutingTool);
                    if not RecLProdOrderRoutingTool.IsEmpty then begin
                        RecLProdOrderRoutingTool.FindSet();
                        repeat
                            RecordRef.GetTable(RecLProdOrderRoutingTool);

                            if CduGConnectorBufferMgtExport.FctCheckFields(RecordRef) then
                                BooLError := true;

                            if BooPInsertValue then begin
                                RecordRefTemp.GetTable("Prod. Order Routing Tool");
                                RecordRefTemp.Init();
                                CduGConnectorBufferMgtExport.FctTransferFields(RecordRef, RecordRefTemp);
                                RecordRefTemp.Insert();
                            end;
                        until RecLProdOrderRoutingTool.Next() = 0;
                    end;
                    //<<FIN Parcours des outillages d'une gamme

                    //>>DEBUT Parcours des qualifications d'une gamme
                    FctProdOrderRtngPersonnel(RecLProdOrderRoutingLine, RecLProdOrderRtngPersonnel);
                    if not RecLProdOrderRtngPersonnel.IsEmpty then begin
                        RecLProdOrderRtngPersonnel.FindSet();
                        repeat
                            RecordRef.GetTable(RecLProdOrderRtngPersonnel);

                            if CduGConnectorBufferMgtExport.FctCheckFields(RecordRef) then
                                BooLError := true;

                            if BooPInsertValue then begin
                                RecordRefTemp.GetTable("Prod. Order Routing Personnel");
                                RecordRefTemp.Init();
                                CduGConnectorBufferMgtExport.FctTransferFields(RecordRef, RecordRefTemp);
                                RecordRefTemp.Insert();
                            end;
                        until RecLProdOrderRtngPersonnel.Next() = 0;
                    end;
                    //<<FIN Parcours des qualifications d'une gamme
                end;
            until RecLProdOrderRoutingLine.Next() = 0;
        end;
        //<<FIN Parcours des gammes

        //>>DEBUT Parcours des composants
        FctProdOrderComponent(RecPProdOrderLine, RecLProdOrderComponent);
        if not RecLProdOrderComponent.IsEmpty then begin
            RecLProdOrderComponent.FindSet();
            repeat
                RecordRef.GetTable(RecLProdOrderComponent);

                if CduGConnectorBufferMgtExport.FctCheckFields(RecordRef) then
                    BooLError := true;

                if BooPInsertValue then begin
                    RecordRefTemp.GetTable("Prod. Order Component");
                    RecordRefTemp.Init();
                    CduGConnectorBufferMgtExport.FctTransferFields(RecordRef, RecordRefTemp);
                    RecordRefTemp.Insert();
                end;

                //>>DEBUT Parcours de la tracabilité
                RecLTrackingSpecifCompoTemp.Reset();
                RecLTrackingSpecifCompoTemp.DeleteAll();
                FctGetTrackingSpecifComponent(RecLProdOrderComponent, RecLTrackingSpecifCompoTemp);
                if not RecLTrackingSpecifCompoTemp.IsEmpty then begin
                    RecLTrackingSpecifCompoTemp.FindSet();
                    repeat
                        RecordRef.GetTable(RecLTrackingSpecifCompoTemp);

                        if CduGConnectorBufferMgtExport.FctCheckFields(RecordRef) then
                            BooLError := true;

                        if BooPInsertValue then begin
                            IntGTranckingSpecifCompoTempNo += 1;
                            RecordRefTemp.GetTable(TrackingSpecificationComponent);
                            RecordRefTemp.Init();
                            CduGConnectorBufferMgtExport.FctTransferFields(RecordRef, RecordRefTemp);

                            FieldRef := RecordRefTemp.Field(1);
                            FieldRef.Value := IntGTranckingSpecifCompoTempNo;
                            RecordRefTemp.Insert();
                        end;
                    until RecLTrackingSpecifCompoTemp.Next() = 0;
                end;
            //<<FIN Parcours de la tracabilité
            until RecLProdOrderComponent.Next() = 0;
        end;
        //<<FIN Parcours des composants

        exit(BooLError);
    end;


    procedure FctInitXML(): Boolean
    var
        RecLProdOrderLine: Record "Prod. Order Line";
    begin
        //>>OSYS-Int001.002
        RecGOSYSSetup.Get();
        //<<OSYS-Int001.002

        "Prod. Order Line".DeleteAll();
        "Prod. Order Routing Line".DeleteAll();
        "Prod. Order Rtng Comment Line".DeleteAll();
        "Prod. Order Routing Tool".DeleteAll();
        "Prod. Order Routing Personnel".DeleteAll();
        "Prod. Order Component".DeleteAll();
        TrackingSpecificationComponent.DeleteAll();
        "Tracking Specification".DeleteAll();
        "Record Link".DeleteAll();
        RecordLinkRouting.DeleteAll();

        CduGConnectorBufferMgtExport.FctInitValidateField(CodGConnectorPartner, 0);

        FctProdOrderLine(RecLProdOrderLine);
        //>>DEBUT Parcours des OF
        if not RecLProdOrderLine.IsEmpty then begin
            RecLProdOrderLine.FindSet();
            repeat
                if not FctCheckValues(RecLProdOrderLine, false) then
                    FctCheckValues(RecLProdOrderLine, true);
            until RecLProdOrderLine.Next() = 0;
        end;

        exit(not "Prod. Order Line".IsEmpty);
        //<<FIN Parcours des OF
    end;


    procedure FctProdOrderLine(var RecPProdOrderLine: Record "Prod. Order Line")
    begin
        //Filtre Ligne Projet
        case IntGProdOrderStatus of
            RecPProdOrderLine.Status::Released.AsInteger():
                begin
                    RecPProdOrderLine.SetCurrentKey(Status, "Send to OSYS (Released)");
                    RecPProdOrderLine.SetRange(Status, RecPProdOrderLine.Status::Released);

                    //>>FE_LAPRIERRETTE_GP0004.001
                    RecPProdOrderLine.SetRange("PWD Is Possible Item", false);
                    //<<FE_LAPRIERRETTE_GP0004.001

                    //>>OSYS-Int001.002
                    if not RecGOSYSSetup.PlannerOne then
                        //<<OSYS-Int001.002
                        RecPProdOrderLine.SetRange("Send to OSYS (Released)", false);
                end;
            RecPProdOrderLine.Status::Finished.AsInteger():
                begin
                    RecPProdOrderLine.SetCurrentKey(Status, "Send to OSYS (Finished)");
                    RecPProdOrderLine.SetRange(Status, RecPProdOrderLine.Status::Finished);
                    RecPProdOrderLine.SetRange("Send to OSYS (Finished)", false);

                    //>>FE_LAPRIERRETTE_GP0004.001
                    RecPProdOrderLine.SetRange("PWD Is Possible Item", false);
                    //<<FE_LAPRIERRETTE_GP0004.001

                end;
        end;
    end;


    procedure FctProdOrderRoutingLine(RecPProdOrderLine: Record "Prod. Order Line"; var RecPProdOrderRoutingLine: Record "Prod. Order Routing Line")
    begin
        //Filtre Gamme
        RecPProdOrderRoutingLine.SetRange(Status, RecPProdOrderLine.Status);
        RecPProdOrderRoutingLine.SetRange("Prod. Order No.", RecPProdOrderLine."Prod. Order No.");
        RecPProdOrderRoutingLine.SetRange("Routing Reference No.", RecPProdOrderLine."Routing Reference No.");
        RecPProdOrderRoutingLine.SetRange("Routing No.", RecPProdOrderLine."Routing No.");

        //>>OSYS-Int001.002
        RecPProdOrderRoutingLine.SetRange("Flushing Method", RecPProdOrderRoutingLine."Flushing Method"::Manual);
        //<<OSYS-Int001.002
    end;


    procedure FctProdOrderRtngCommentLine(RecPProdOrderRoutingLine: Record "Prod. Order Routing Line"; var RecPProdOrderRtngCommentLine: Record "Prod. Order Rtng Comment Line")
    begin
        //Filtre Gamme Commentaire
        RecPProdOrderRtngCommentLine.SetRange("Prod. Order No.", RecPProdOrderRoutingLine."Prod. Order No.");
        RecPProdOrderRtngCommentLine.SetRange("Routing Reference No.", RecPProdOrderRoutingLine."Routing Reference No.");
        RecPProdOrderRtngCommentLine.SetRange("Routing No.", RecPProdOrderRoutingLine."Routing No.");
        RecPProdOrderRtngCommentLine.SetRange("Operation No.", RecPProdOrderRoutingLine."Operation No.");
    end;


    procedure FctProdOrderRoutingTool(RecPProdOrderRoutingLine: Record "Prod. Order Routing Line"; var RecPProdOrderRoutingTool: Record "Prod. Order Routing Tool")
    begin
        //Filtre Gamme Outillage
        RecPProdOrderRoutingTool.SetRange("Prod. Order No.", RecPProdOrderRoutingLine."Prod. Order No.");
        RecPProdOrderRoutingTool.SetRange("Routing Reference No.", RecPProdOrderRoutingLine."Routing Reference No.");
        RecPProdOrderRoutingTool.SetRange("Routing No.", RecPProdOrderRoutingLine."Routing No.");
        RecPProdOrderRoutingTool.SetRange("Operation No.", RecPProdOrderRoutingLine."Operation No.");
    end;


    procedure FctProdOrderRtngPersonnel(RecPProdOrderRoutingLine: Record "Prod. Order Routing Line"; var RecPProdOrderRtngPersonnel: Record "Prod. Order Routing Personnel")
    begin
        //Filtre Gamme Qualification
        RecPProdOrderRtngPersonnel.SetRange("Prod. Order No.", RecPProdOrderRoutingLine."Prod. Order No.");
        RecPProdOrderRtngPersonnel.SetRange("Routing Reference No.", RecPProdOrderRoutingLine."Routing Reference No.");
        RecPProdOrderRtngPersonnel.SetRange("Routing No.", RecPProdOrderRoutingLine."Routing No.");
        RecPProdOrderRtngPersonnel.SetRange("Operation No.", RecPProdOrderRoutingLine."Operation No.");
    end;


    procedure FctProdOrderComponent(RecPProdOrderLine: Record "Prod. Order Line"; var RecPProdOrderComponent: Record "Prod. Order Component")
    begin
        //Filtre Composant
        RecPProdOrderComponent.SetRange(Status, RecPProdOrderLine.Status);
        RecPProdOrderComponent.SetRange("Prod. Order No.", RecPProdOrderLine."Prod. Order No.");
        RecPProdOrderComponent.SetRange("Prod. Order Line No.", RecPProdOrderLine."Line No.");
        //>>TO BE COMMENTED
        //RecPProdOrderComponent.SETRANGE("Flushing Method", RecPProdOrderComponent."Flushing Method"::Manual);
        RecPProdOrderComponent.SetRange("PWD Lot Determining", false);
        //<<TO BE COMMENTED
    end;


    procedure FctProdOrderTrackingSpec(RecPProdOrderLine: Record "Prod. Order Line"; var RecPTrackingSpecification: Record "Tracking Specification")
    begin
        //Filtre Traçabilité
        RecPTrackingSpecification.SetRange("Source ID", RecPProdOrderLine."Prod. Order No.");
        RecPTrackingSpecification.SetRange("Source Prod. Order Line", RecPProdOrderLine."Line No.");
    end;


    procedure FctProdOrderTrackingSpecCompo(RecPProdOrderComponent: Record "Prod. Order Component"; var RecPTrackingSpecification: Record "Tracking Specification")
    begin
        //Filtre Traçabilité
        RecPTrackingSpecification.SetRange("Source ID", RecPProdOrderComponent."Prod. Order No.");
        RecPTrackingSpecification.SetRange("Source Prod. Order Line", RecPProdOrderComponent."Prod. Order Line No.");
        RecPTrackingSpecification.SetRange("Source Ref. No.", RecPProdOrderComponent."Line No.");
    end;


    procedure FctRecordLink(RecPProdOrderLine: Record "Prod. Order Line"; var RecPRecordLink: Record "Record Link")
    var
        RecLProductionOrder: Record "Production Order";
        RecordRef: RecordRef;
    begin
        //Filtre Record Link
        RecLProductionOrder.Get(RecPProdOrderLine.Status, RecPProdOrderLine."Prod. Order No.");
        RecordRef.GetTable(RecLProductionOrder);
        RecPRecordLink.SetRange("Record ID", RecordRef.RecordId);
    end;


    procedure FctRecordLinkRouting(RecPProdOrderRoutingLine: Record "Prod. Order Routing Line"; var RecPRecordLink: Record "Record Link")
    var
        RecLProdOrderRoutingLine: Record "Prod. Order Routing Line";
        RecordRef: RecordRef;
    begin
        //Filtre Routing Record Link
        RecLProdOrderRoutingLine.Get(RecPProdOrderRoutingLine.Status, RecPProdOrderRoutingLine."Prod. Order No.",
                                RecPProdOrderRoutingLine."Routing Reference No.", RecPProdOrderRoutingLine."Routing No.",
                                RecPProdOrderRoutingLine."Operation No.");
        RecordRef.GetTable(RecLProdOrderRoutingLine);
        RecPRecordLink.SetRange("Record ID", RecordRef.RecordId);
    end;


    procedure FctGetTrackingSpecification(RecPProdOrderLine: Record "Prod. Order Line"; var RecPTrackingSpecificationTemp: Record "Tracking Specification" temporary)
    var
        RecLItem: Record Item;
        RecLTrackingSpecificationTemp: Record "Tracking Specification" temporary;
        CduLBufferTrackingManagement: Codeunit "Buffer Tracking Management 2";
    begin
        if (RecLItem.Get(RecPProdOrderLine."Item No.") and (RecLItem."Item Tracking Code" <> '')) then begin
            RecPTrackingSpecificationTemp.Reset();
            RecPTrackingSpecificationTemp.DeleteAll();

            if RecPProdOrderLine.Status = RecPProdOrderLine.Status::Finished then begin
                IntGIndent += 1;

                CduLBufferTrackingManagement.GetPostedItemTrackingProdOrder(RecPTrackingSpecificationTemp, IntGIndent,
                    DATABASE::"Prod. Order Line", RecPProdOrderLine."Prod. Order No.", RecPProdOrderLine."Line No.", 0)
            end else begin
                Clear(CduLBufferTrackingManagement);
                CduLBufferTrackingManagement.FctInitTrackingSpecification(RecPProdOrderLine, RecLTrackingSpecificationTemp);
                CduLBufferTrackingManagement.SetSource(RecLTrackingSpecificationTemp, RecPProdOrderLine."Due Date");
                CduLBufferTrackingManagement.GetTrackingSpecification(RecPTrackingSpecificationTemp);
            end;
        end;
    end;


    procedure FctGetTrackingSpecifComponent(RecPProdOrderComponent: Record "Prod. Order Component"; var RecPTrackingSpecificationTemp: Record "Tracking Specification" temporary)
    var
        RecLItem: Record Item;
        RecLTrackingSpecification: Record "Tracking Specification";
        CduLBufferTrackingManagement: Codeunit "Buffer Tracking Management 2";
    begin
        if (RecLItem.Get(RecPProdOrderComponent."Item No.") and (RecLItem."Item Tracking Code" <> '')) then
            if RecPProdOrderComponent.Status = RecPProdOrderComponent.Status::Finished then begin
                IntGIndent += 1;

                CduLBufferTrackingManagement.GetPostedItemTrackingProdOrder(RecPTrackingSpecificationTemp, IntGIndent,
                    DATABASE::"Prod. Order Component", RecPProdOrderComponent."Prod. Order No.",
                    RecPProdOrderComponent."Prod. Order Line No.", RecPProdOrderComponent."Line No.")
            end else begin
                Clear(CduLBufferTrackingManagement);
                CduLBufferTrackingManagement.FctInitTrackingSpecifComponent(RecPProdOrderComponent, RecLTrackingSpecification);
                CduLBufferTrackingManagement.SetSource(RecLTrackingSpecification, RecPProdOrderComponent."Due Date");
                CduLBufferTrackingManagement.GetTrackingSpecification(RecPTrackingSpecificationTemp);
            end;
    end;


    procedure FctDefineProdOrderStatus(IntPProdOrderStatus: Integer)
    begin
        IntGProdOrderStatus := IntPProdOrderStatus;
    end;


    procedure FctCanExportRoutingLine(RecPProdOrderRoutingLine: Record "Prod. Order Routing Line"; var CodPNextOp: Code[1024]): Boolean
    var
        RecLMachineCenter: Record "Machine Center";
        RecLProdOrderRoutingLine2: Record "Prod. Order Routing Line";
    begin
        if (RecPProdOrderRoutingLine.Type = RecPProdOrderRoutingLine.Type::"Work Center") then
            exit(false);

        //Est-ce que ma gamme est une gamme parallèle ?
        RecLProdOrderRoutingLine2.SetRange(Status, RecPProdOrderRoutingLine.Status);
        RecLProdOrderRoutingLine2.SetRange("Prod. Order No.", RecPProdOrderRoutingLine."Prod. Order No.");
        RecLProdOrderRoutingLine2.SetRange("Routing Reference No.", RecPProdOrderRoutingLine."Routing Reference No.");
        RecLProdOrderRoutingLine2.SetRange("Previous Operation No.", RecPProdOrderRoutingLine."Previous Operation No.");

        //>>OSYS-Int001.003
        RecLProdOrderRoutingLine2.SetRange(Type, RecPProdOrderRoutingLine.Type::"Machine Center");
        //Ne prendre en compte que les opérations avec une méthode de consommation manuelle
        RecLProdOrderRoutingLine2.SetRange("Flushing Method", RecLProdOrderRoutingLine2."Flushing Method"::Manual);
        //<<OSYS-Int001.003

        if (RecLProdOrderRoutingLine2.Count < 2) then begin     //Ma gamme n'est pas une gamme parallèle
            CodPNextOp := '';
            exit(true);
        end
        else begin
            RecLProdOrderRoutingLine2.FindSet();
            repeat
                if CodPNextOp = '' then
                    CodPNextOp := RecLProdOrderRoutingLine2."Operation No."
                else
                    CodPNextOp := CodPNextOp + '|' + RecLProdOrderRoutingLine2."Operation No.";
            until RecLProdOrderRoutingLine2.Next() = 0;
            //RecPProdOrderRoutingLine.MODIFY;
        end;


        //Ma gamme est  une gamme parallèle
        RecLMachineCenter.Get(RecPProdOrderRoutingLine."No.");

        //Est ce que mon poste de charge est une machine ?
        if (RecLMachineCenter."PWD Type" = RecLMachineCenter."PWD Type"::Machine) then
            exit(true);

        //Mon poste de charge est une main d'oeuvre  =>  la ligne de gamme n'est pas exporté
        exit(false);
    end;

    procedure FctPlannerOnePermission(): Boolean
    var
    //TODO: Table 'PlannerOneIntegrationRecord' is missing
    //RecLPlannerOne: Record PlannerOneIntegrationRecord;
    begin
        //exit(RecLPlannerOne.ReadPermission);
    end;
}

