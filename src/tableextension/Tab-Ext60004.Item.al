tableextension 60004 "PWD Item" extends Item
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.5
    // WMS-FE10.001:GR  01/07/2011   Connector integration
    //                              - Add fields:  "WMS_Product Type"
    //                                             "WMS_Permanent item"
    //                                             "WMS_Freezing sensitive"
    //                                             "WMS_Heat sensitive"
    //                                             "WMS_Dangerous item"
    //                                             "WMS_Mandatory SSCC No"
    //                                             "WMS_Fragile item"
    //                                             "WMS_Item"
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_ART03.001: NI 23/11/2011:  Notion de N° plan sur article
    //                                           - Add field 50000..50003
    //                                           - Change Group Fields DropDown
    //                                             Old value : No.,Description,Base Unit of Measure,Bill of Materials,Unit Price
    //                                             New value :
    //          No.,Description,Base Unit of Measure,Bill of Materials,Unit Price,Customer Plan No.,Customer Plan Description,LPSA Plan No.
    // 
    // FE_LAPIERRETTE_ART02.001: NI 23/11/2011:  Désignation article 120 caracteres
    //                                           - Add field 50004..50005
    // 
    // FE_LAPIERRETTE_INT01.001: NI 28/11/2011:  Designation Article Quartis
    //                                           - Add field 50006
    // 
    // FE_LAPIERRETTE_ART01.001: TO 07/12/2011:  Configurateur article
    //                                           - Add C/AL in Trigger OnDelete()
    // 
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_PROD01.001: TO 13/12/2011:  No Commande vente identique OF-LOT
    //                                           - Add field 50007
    // 
    // //PLAW11.0
    // FE_Merge: TO 23/01/2012:  Merge of pbjects Planner One
    //                                           - Add field 8076501
    // 
    // //>>LAP2.05
    // FE_LAPIERRETTE_NDT01.001: LY 17/04/2013:  Modify field 50000
    //                                           Text20 -> Text40
    // 
    // //>>LAP2.06
    // FE_LAPRIERRETTE_GP0003 : APA 16/05/2013 : Add Field 50008
    //                                           Add TableRelation = Location on Field 12
    // 
    // //>>LPSA.TDL
    // 10/04/2014 : Add Field 50011 : Forecast Qty
    // 19/01/2015 : Add field 50012, 50013
    // 
    // //>>LAP080615
    // TO 06/06/2015 : Customer Filter
    //                 -Add field 50015
    //                 -Modify calcfield "Prod. Forecast Quantity (Base)"
    // 
    // 12.08.2015  : Update Costing Method
    //                 - Add C\AL Replenishment System - OnValidate()
    //                 - Create function TestNoEntriesExist_Cost
    // ------------------------------------------------------------------------------------------------------------------
    //     PLAW1 -----------------------------------------------------------------------------
    // PLAW1-4.0   06/02/2014 PO-3706 remove copy of PlannerOne color on production order lines
    // PLAW1-4.0   06/02/2014 PO-3706 cascade delete of parameter values
    // PLAW1 -----------------------------------------------------------------------------
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 12/06/2017 : DEMANDES DIVERSES
    //                 - Add Field 50030 - Component Initial Qty - Decimal
    // 
    // //>>REGIE
    // P24578_005 : LALE.RO : 18/10/2018 Demande par Mail
    //                 - Add Fields 50040 - Plate Number - Integer
    //                              50041 - Part Number By Plate - Integer
    // 
    // //>>LAP2.18
    // TDL260619.001 : Distinguer stock magasin principal
    // 
    // //>>LAP2.19
    // P24578_008.001 : LY 12/08/2019 : Export contrôle de gestion
    // 
    // //>>LAP2.18
    // TDL131119.001 : Distinguer stock magasin principal et stock magasin secondaire
    //                 Add Field 50044 to 50045

    fields
    {
        field(50000; "PWD Customer Plan No."; Text[40])
        {
            Caption = 'Customer Plan No.';
            Description = 'LAP2.05';
        }
        field(50001; "PWD Customer Plan Description"; Text[50])
        {
            Caption = 'Customer Plan Description';
            Description = 'LAP1.00';
        }
        field(50002; "PWD LPSA Plan No."; Text[20])
        {
            Caption = 'LPSA Plan No.';
            Description = 'LAP1.00';
        }
        field(50003; "PWD Barcode"; Text[20])
        {
            Caption = 'Barcode';
            Description = 'LAP1.00';
        }
        field(50004; "PWD LPSA Description 1"; Text[120])
        {
            Caption = 'LPSA Description 1';
            Description = 'LAP1.00';
        }
        field(50005; "PWD LPSA Description 2"; Text[120])
        {
            Caption = 'LPSA Description 2';
            Description = 'LAP1.00';
        }
        field(50006; "PWD Quartis Description"; Text[40])
        {
            Caption = 'Quartis Description';
            Description = 'LAP1.00';
        }
        field(50007; "PWD Lot Determining"; Boolean)
        {
            Caption = 'Lot Determining';
            Description = 'LAP1.00';

            trigger OnValidate()
            begin
                if "PWD Lot Determining" then begin
                    IsLotItem(true);
                    //  TESTFIELD("From the same Lot", TRUE);
                end;
            end;
        }
        field(50008; "PWD Phantom Item"; Boolean)
        {
            Caption = 'Phantom Item';
        }
        field(50009; "Released Scheduled Need (Qty.)"; Decimal)
        {
            CalcFormula = Sum("Prod. Order Component"."Remaining Qty. (Base)" WHERE(Status = FILTER(Released),
                                                                                     "Item No." = FIELD("No."),
                                                                                     "Variant Code" = FIELD("Variant Filter"),
                                                                                     "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                                     "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                                     "Location Code" = FIELD("Location Filter"),
                                                                                     "Due Date" = FIELD("Date Filter")));
            Caption = 'Released Scheduled Need (Qty.)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50010; "PWD Released Qty. on Prod. Order"; Decimal)
        {
            CalcFormula = Sum("Prod. Order Line"."Remaining Qty. (Base)" WHERE(Status = FILTER(Released),
                                                                                "Item No." = FIELD("No."),
                                                                                "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                                "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                                "Location Code" = FIELD("Location Filter"),
                                                                                "Variant Code" = FIELD("Variant Filter"),
                                                                                "Due Date" = FIELD("Date Filter")));
            Caption = 'Released Qty. on Prod. Order';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50011; "PWD Forecast Qty."; Decimal)
        {
            CalcFormula = Sum("Production Forecast Entry"."Forecast Quantity (Base)" WHERE("Item No." = FIELD("No."),
                                                                                            "Forecast Date" = FIELD("Date Filter"),
                                                                                            "Location Code" = FIELD("Location Filter")));
            Caption = 'Forecast Qty.';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50012; "PWD Sales Invoiced Qty."; Decimal)
        {
            CalcFormula = Count("Sales Invoice Line" WHERE(Type = CONST(Item),
                                                            "No." = FIELD("No.")));
            Caption = 'Qté facturée';
            DecimalPlaces = 0 : 5;
            Editable = false;
            Enabled = false;
            FieldClass = FlowField;
        }
        field(50013; "PWD Firm Plan. Qty. on Prod. Order"; Decimal)
        {
            CalcFormula = Sum("Prod. Order Line"."Remaining Qty. (Base)" WHERE(Status = FILTER("Firm Planned"),
                                                                                "Item No." = FIELD("No."),
                                                                                "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                                "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                                "Location Code" = FIELD("Location Filter"),
                                                                                "Variant Code" = FIELD("Variant Filter"),
                                                                                "Due Date" = FIELD("Date Filter")));
            Caption = 'Released Qty. on Prod. Order';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50014; "PWD Arch. Sales Order Qty."; Decimal)
        {
            CalcFormula = Sum("Sales Line Archive"."Quantity Invoiced" WHERE("Document Type" = CONST(Order),
                                                                              Type = CONST(Item),
                                                                              "No." = FIELD("No."),
                                                                              "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                              "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                              "Location Code" = FIELD("Location Filter"),
                                                                              "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                              "Variant Code" = FIELD("Variant Filter"),
                                                                              "Shipment Date" = FIELD("Date Filter")));
            Caption = 'Qté sur commande vente archivée';
            DecimalPlaces = 0 : 5;
            Description = 'su';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50015; "PWD Customer Filter"; Code[20])
        {
            Caption = 'Customer Filter';
            Description = 'LAP080615';
            FieldClass = FlowFilter;
            TableRelation = Customer;
        }
        field(50016; "PWD ToForecast"; Boolean)
        {
            CalcFormula = Exist("Item Cross Reference" WHERE("Item No." = FIELD("No."),
                                                              "Cross-Reference Type" = CONST(Customer),
                                                              "Cross-Reference Type No." = FIELD("Customer Filter")));
            Caption = 'To Forecast';
            Description = 'LAP080615';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50017; "PWD Last Entry Date Old ERP"; Date)
        {
            Caption = 'Last Entry Date Old ERP';
            Description = 'LAP2.09';
        }
        field(50018; "PWD Manufacturing Code"; Code[10])
        {
            Caption = 'Code production';
            Description = 'LAP2.10';
        }
        field(50019; "PWD Arch. Purchase Order Qty."; Decimal)
        {
            CalcFormula = Sum("Purchase Line Archive"."Quantity Invoiced" WHERE("Document Type" = CONST(Order),
                                                                                 Type = CONST(Item),
                                                                                 "No." = FIELD("No."),
                                                                                 "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                                 "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                                 "Location Code" = FIELD("Location Filter"),
                                                                                 "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                                 "Variant Code" = FIELD("Variant Filter"),
                                                                                 "Expected Receipt Date" = FIELD("Date Filter")));
            Caption = 'Qty. on Purch. Order Archive';
            DecimalPlaces = 0 : 5;
            Description = 'LAP2.11';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50020; "PWD Configurator Exists"; Boolean)
        {
            CalcFormula = Exist("PWD Item Configurator" WHERE("Item Code" = FIELD("No.")));
            Caption = 'Configurateur';
            Description = 'LAP2.12';
            FieldClass = FlowField;
        }
        field(50030; "PWD Component Initial Qty"; Decimal)
        {
            Caption = 'Qté composant initiale';
            Editable = false;
        }
        field(50040; "PWD Plate Number"; Integer)
        {
            Caption = 'Plate Number';
            Description = 'REGIE';
        }
        field(50041; "PWD Part Number By Plate"; Integer)
        {
            Caption = 'Part Number By Plate';
            Description = 'REGIE';
        }
        field(50042; "PWD Other Location Filter"; Code[10])
        {
            Caption = 'Location Filter';
            Description = 'LAP2.18';
            FieldClass = FlowFilter;
            TableRelation = Location;
        }
        field(50043; "PWD Inventory 2"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
                                                                  "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                  "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                  "Location Code" = FIELD("PWD Other Location Filter"),
                                                                  "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                  "Variant Code" = FIELD("Variant Filter"),
                                                                  "Lot No." = FIELD("Lot No. Filter"),
                                                                  "Serial No." = FIELD("Serial No. Filter")));
            Caption = 'Inventory';
            DecimalPlaces = 0 : 5;
            Description = 'LAP2.18';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50044; "PWD Principal Location Filter"; Code[10])
        {
            Caption = 'Principal Location Filter';
            Description = 'LAP2.18';
            FieldClass = FlowFilter;
            TableRelation = Location;
        }
        field(50045; "PWD Principal Inventory"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
                                                                  "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                  "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                  "Location Code" = FIELD("PWD Principal Location Filter"),
                                                                  "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                  "Variant Code" = FIELD("Variant Filter"),
                                                                  "Lot No." = FIELD("Lot No. Filter"),
                                                                  "Serial No." = FIELD("Serial No. Filter")));
            Caption = 'Principal Inventory';
            DecimalPlaces = 0 : 5;
            Description = 'LAP2.18';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8073282; "PWD WMS_Product Type"; Code[2])
        {
            Caption = 'WMS_Product Type';
            Description = 'ProdConnect1.5';
        }
        field(8073283; "PWD WMS_Permanent item"; Boolean)
        {
            Caption = 'WMS_Permanent item';
            Description = 'ProdConnect1.5';
        }
        field(8073284; "PWD WMS_Freezing sensitive"; Boolean)
        {
            Caption = 'WMS_Freezing sensitive';
            Description = 'ProdConnect1.5';
        }
        field(8073285; "PWD WMS_Heat sensitive"; Boolean)
        {
            Caption = 'WMS_Heat sensitive';
            Description = 'ProdConnect1.5';
        }
        field(8073286; "PWD WMS_Dangerous item"; Boolean)
        {
            Caption = 'WMS_Dangerous item';
            Description = 'ProdConnect1.5';
        }
        field(8073287; "PWD WMS_Fragile item"; Boolean)
        {
            Caption = 'WMS_Fragile item';
            Description = 'ProdConnect1.5';
        }
        field(8073288; "PWD WMS_Mandatory SSCC No"; Boolean)
        {
            Caption = 'WMS_Mandatory SSCC No';
            Description = 'ProdConnect1.5';
        }
        field(8073289; "PWD WMS_Item"; Boolean)
        {
            Caption = 'WMS_Item';
            Description = 'ProdConnect1.5';
        }
        field(8076501; "PWD Order Start Date Calc."; DateFormula)
        {
            Caption = 'Order Start Date Calculation';
            Description = 'Should be a negative duration. Used by PlannerOne to calculate the production order earliest start date, starting from its due date.';
        }
        field(8076502; "PWD PlannerOneColor"; Text[30])
        {
            Caption = 'PlannerOne Color';
            Description = 'Color displayed in PlannerOne';
        }
        field(8076503; "PWD ParamValuesForAllVariants"; Boolean)
        {
            Caption = 'Use Parameter Values For All Variants';
            Description = 'Apply item parameter values to all variants';
            InitValue = true;
        }
    }
    keys
    {

        //Unsupported feature: Property Insertion (KeyGroups) on ""Production BOM No."(Key)".


        //Unsupported feature: Property Insertion (KeyGroups) on ""Routing No."(Key)".


        //Unsupported feature: Property Insertion (KeyGroups) on "Description(Key)".


        //Unsupported feature: Property Insertion (KeyGroups) on ""Base Unit of Measure"(Key)".


        //Unsupported feature: Deletion (KeyCollection) on "Type(Key)".

    }


    //Unsupported feature: Code Insertion (VariableCollection) on "OnDelete".

    //trigger (Variable: BinContent)()
    //Parameters and return type have not been exported.
    //begin
    /*
    */
    //end;


    //Unsupported feature: Code Modification on "OnDelete".

    //trigger OnDelete()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    ApprovalsMgmt.OnCancelItemApprovalRequest(Rec);

    CheckJournalsAndWorksheets(0);
    CheckDocuments(0);

    MoveEntries.MoveItemEntries(Rec);

    ServiceItem.Reset;
    ServiceItem.SetRange("Item No.","No.");
    #10..12
        ServiceItem.Modify(true);
      until ServiceItem.Next = 0;

    DeleteRelatedData;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    BOMComp.Reset;
    BOMComp.SetCurrentKey(Type,"No.");
    BOMComp.SetRange(Type,BOMComp.Type::Item);
    BOMComp.SetRange("No.","No.");
    if BOMComp.Find('-') then
      Error(Text023,TableCaption,"No.",BOMComp.TableCaption);

    ItemJnlLine.SetRange("Item No.","No.");
    if ItemJnlLine.Find('-') then
      Error(Text023,TableCaption,"No.",ItemJnlLine.TableCaption);

    RequisitionLine.SetCurrentKey(Type,"No.");
    RequisitionLine.SetRange(Type,RequisitionLine.Type::Item);
    RequisitionLine.SetRange("No.","No.");
    if not RequisitionLine.IsEmpty then
      Error(Text023,TableCaption,"No.",RequisitionLine.TableCaption);

    PurchOrderLine.SetCurrentKey(Type,"No.");
    PurchOrderLine.SetRange(Type,PurchOrderLine.Type::Item);
    PurchOrderLine.SetRange("No.","No.");
    if PurchOrderLine.Find('-') then
      Error(Text000,TableCaption,"No.",PurchOrderLine."Document Type");

    SalesOrderLine.SetCurrentKey(Type,"No.");
    SalesOrderLine.SetRange(Type,SalesOrderLine.Type::Item);
    SalesOrderLine.SetRange("No.","No.");
    if SalesOrderLine.Find('-') then
      Error(Text001,TableCaption,"No.",SalesOrderLine."Document Type");

    if ProdOrderExist then
      Error(Text002,TableCaption,"No.");

    ProdOrderComp.SetCurrentKey(Status,"Item No.");
    ProdOrderComp.SetFilter(Status,'..%1',ProdOrderComp.Status::Released);
    ProdOrderComp.SetRange("Item No.","No.");
    if ProdOrderComp.Find('-') then
      Error(Text014,TableCaption,"No.");

    TransLine.SetCurrentKey("Item No.");
    TransLine.SetRange("Item No.","No.");
    if TransLine.Find('-') then
      Error(Text016,TableCaption,"No.");

    ServInvLine.Reset;
    ServInvLine.SetCurrentKey(Type,"No.");
    ServInvLine.SetRange(Type,ServInvLine.Type::Item);
    ServInvLine.SetRange("No.","No.");
    if ServInvLine.Find('-') then
      Error(Text017,TableCaption,"No.",ServInvLine."Document Type");

    ProdBOMLine.Reset;
    ProdBOMLine.SetCurrentKey(Type,"No.");
    ProdBOMLine.SetRange(Type,ProdBOMLine.Type::Item);
    ProdBOMLine.SetRange("No.","No.");
    if ProdBOMLine.Find('-') then
      repeat
        if ProdBOMHeader.Get(ProdBOMLine."Production BOM No.") and
           (ProdBOMHeader.Status = ProdBOMHeader.Status::Certified)
        then
          Error(Text004,TableCaption,"No.");
      until ProdBOMLine.Next = 0;

    ServiceContractLine.Reset;
    ServiceContractLine.SetRange("Item No.","No.");
    if ServiceContractLine.Find('-') then
      Error(Text023,TableCaption,"No.",ServiceContractLine.TableCaption);
    #7..15
    MoveEntries.MoveItemEntries(Rec);

    ItemBudgetEntry.SetCurrentKey("Analysis Area","Budget Name","Item No.");
    ItemBudgetEntry.SetRange("Item No.","No.");
    ItemBudgetEntry.DeleteAll(true);

    ItemSub.Reset;
    ItemSub.SetRange(Type,ItemSub.Type::Item);
    ItemSub.SetRange("No.","No.");
    ItemSub.DeleteAll;

    ItemSub.Reset;
    ItemSub.SetRange("Substitute Type",ItemSub."Substitute Type"::Item);
    ItemSub.SetRange("Substitute No.","No.");
    ItemSub.DeleteAll;

    SKU.Reset;
    SKU.SetCurrentKey("Item No.");
    SKU.SetRange("Item No.","No.");
    SKU.DeleteAll;

    NonstockItemMgt.NonstockItemDel(Rec);
    CommentLine.SetRange("Table Name",CommentLine."Table Name"::Item);
    CommentLine.SetRange("No.","No.");
    CommentLine.DeleteAll;

    ItemVend.SetCurrentKey("Item No.");
    ItemVend.SetRange("Item No.","No.");
    ItemVend.DeleteAll;

    SalesPrice.SetRange("Item No.","No.");
    SalesPrice.DeleteAll;

    SalesLineDisc.SetRange(Type,SalesLineDisc.Type::Item);
    SalesLineDisc.SetRange(Code,"No.");
    SalesLineDisc.DeleteAll;

    SalesPrepmtPct.SetRange("Item No.","No.");
    SalesPrepmtPct.DeleteAll;

    PurchPrice.SetRange("Item No.","No.");
    PurchPrice.DeleteAll;

    PurchLineDisc.SetRange("Item No.","No.");
    PurchLineDisc.DeleteAll;

    PurchPrepmtPct.SetRange("Item No.","No.");
    PurchPrepmtPct.DeleteAll;

    ItemTranslation.SetRange("Item No.","No.");
    ItemTranslation.DeleteAll;

    ItemUnitOfMeasure.SetRange("Item No.","No.");
    ItemUnitOfMeasure.DeleteAll;

    ItemVariant.SetRange("Item No.","No.");
    ItemVariant.DeleteAll;

    ExtTextHeader.SetRange("Table Name",ExtTextHeader."Table Name"::Item);
    ExtTextHeader.SetRange("No.","No.");
    ExtTextHeader.DeleteAll(true);

    ItemAnalysisViewEntry.SetRange("Item No.","No.");
    ItemAnalysisViewEntry.DeleteAll;

    ItemAnalysisBudgViewEntry.SetRange("Item No.","No.");
    ItemAnalysisBudgViewEntry.DeleteAll;

    PlanningAssignment.SetRange("Item No.","No.");
    PlanningAssignment.DeleteAll;

    BOMComp.Reset;
    BOMComp.SetRange("Parent Item No.","No.");
    BOMComp.DeleteAll;

    TroubleshSetup.Reset;
    TroubleshSetup.SetRange(Type,TroubleshSetup.Type::Item);
    TroubleshSetup.SetRange("No.","No.");
    TroubleshSetup.DeleteAll;

    ResSkillMgt.DeleteItemResSkills("No.");
    DimMgt.DeleteDefaultDim(DATABASE::Item,"No.");

    ItemIdent.Reset;
    ItemIdent.SetCurrentKey("Item No.");
    ItemIdent.SetRange("Item No.","No.");
    ItemIdent.DeleteAll;

    ServiceItemComponent.Reset;
    ServiceItemComponent.SetRange(Type,ServiceItemComponent.Type::Item);
    ServiceItemComponent.SetRange("No.","No.");
    ServiceItemComponent.ModifyAll("No.",'');

    BinContent.SetCurrentKey("Item No.");
    BinContent.SetRange("Item No.","No.");
    BinContent.DeleteAll;

    //>>FE_LAPIERRETTE_ART01.001
    RecGItemConfigurator.Reset;
    RecGItemConfigurator.SetCurrentKey("Item Code");
    RecGItemConfigurator.SetRange("Item Code","No.");
    RecGItemConfigurator.DeleteAll;
    //<<FE_LAPIERRETTE_ART01.001

    MobSalesMgt.ItemOnDelete(Rec);

    // PLAW1
    if not ApplicationManagement.CheckPlannerOneLicence then exit;
    PlannerOneParameters.SetRange("Item No.","No.");
    PlannerOneParameters.SetRange(VariantCode,'');
    PlannerOneParameters.DeleteAll;
    // PLAW1 END
    */
    //end;


    //Unsupported feature: Code Modification on "OnInsert".

    //trigger OnInsert()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    if "No." = '' then begin
      GetInvtSetup;
      InvtSetup.TestField("Item Nos.");
      NoSeriesMgt.InitSeries(InvtSetup."Item Nos.",xRec."No. Series",0D,"No.","No. Series");
      "Costing Method" := InvtSetup."Default Costing Method";
    end;

    DimMgt.UpdateDefaultDim(
      DATABASE::Item,"No.",
      "Global Dimension 1 Code","Global Dimension 2 Code");

    UpdateReferencedIds;
    SetLastDateTimeModified;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..4
    #6..10
    */
    //end;


    //Unsupported feature: Code Modification on "OnModify".

    //trigger OnModify()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    UpdateReferencedIds;
    SetLastDateTimeModified;
    PlanningAssignment.ItemChange(Rec,xRec);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    "Last Date Modified" := Today;

    PlanningAssignment.ItemChange(Rec,xRec);
    //PLAW11.0
    ProdOrderLine.ItemChange(Rec,xRec);
    //PLAW11.0 END
    */
    //end;


    //Unsupported feature: Code Modification on "OnRename".

    //trigger OnRename()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SalesLine.RenameNo(SalesLine.Type::Item,xRec."No.","No.");
    PurchaseLine.RenameNo(PurchaseLine.Type::Item,xRec."No.","No.");
    TransferLine.RenameNo(xRec."No.","No.");
    DimMgt.RenameDefaultDim(DATABASE::Item,xRec."No.","No.");

    ApprovalsMgmt.OnRenameRecordInApprovalRequest(xRec.RecordId,RecordId);
    ItemAttributeValueMapping.RenameItemAttributeValueMapping(xRec."No.","No.");
    SetLastDateTimeModified;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    "Last Date Modified" := Today;
    */
    //end;

    //Unsupported feature: ReturnValue Insertion (ReturnValue: <Blank>) (ReturnValueCollection) on "CalcPurchReturn(PROCEDURE 12)".


    //Unsupported feature: Variable Insertion (Variable: PurchLine) (VariableCollection) on "CalcPurchReturn(PROCEDURE 12)".


    //Unsupported feature: Property Deletion (Local) on "DeleteRelatedData(PROCEDURE 12)".


    //Unsupported feature: Property Modification (Name) on "DeleteRelatedData(PROCEDURE 12)".



    //Unsupported feature: Code Modification on "DeleteRelatedData(PROCEDURE 12)".

    //procedure DeleteRelatedData();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    ItemBudgetEntry.SetCurrentKey("Analysis Area","Budget Name","Item No.");
    ItemBudgetEntry.SetRange("Item No.","No.");
    ItemBudgetEntry.DeleteAll(true);

    ItemSub.Reset;
    ItemSub.SetRange(Type,ItemSub.Type::Item);
    ItemSub.SetRange("No.","No.");
    ItemSub.DeleteAll;

    ItemSub.Reset;
    ItemSub.SetRange("Substitute Type",ItemSub."Substitute Type"::Item);
    ItemSub.SetRange("Substitute No.","No.");
    ItemSub.DeleteAll;

    SKU.Reset;
    SKU.SetCurrentKey("Item No.");
    SKU.SetRange("Item No.","No.");
    SKU.DeleteAll;

    CatalogItemMgt.NonstockItemDel(Rec);
    CommentLine.SetRange("Table Name",CommentLine."Table Name"::Item);
    CommentLine.SetRange("No.","No.");
    CommentLine.DeleteAll;

    ItemVend.SetCurrentKey("Item No.");
    ItemVend.SetRange("Item No.","No.");
    ItemVend.DeleteAll;

    SalesPrice.SetRange("Item No.","No.");
    SalesPrice.DeleteAll;

    SalesLineDisc.SetRange(Type,SalesLineDisc.Type::Item);
    SalesLineDisc.SetRange(Code,"No.");
    SalesLineDisc.DeleteAll;

    SalesPrepmtPct.SetRange("Item No.","No.");
    SalesPrepmtPct.DeleteAll;

    PurchPrice.SetRange("Item No.","No.");
    PurchPrice.DeleteAll;

    PurchLineDisc.SetRange("Item No.","No.");
    PurchLineDisc.DeleteAll;

    PurchPrepmtPct.SetRange("Item No.","No.");
    PurchPrepmtPct.DeleteAll;

    ItemTranslation.SetRange("Item No.","No.");
    ItemTranslation.DeleteAll;

    ItemUnitOfMeasure.SetRange("Item No.","No.");
    ItemUnitOfMeasure.DeleteAll;

    ItemVariant.SetRange("Item No.","No.");
    ItemVariant.DeleteAll;

    ExtTextHeader.SetRange("Table Name",ExtTextHeader."Table Name"::Item);
    ExtTextHeader.SetRange("No.","No.");
    ExtTextHeader.DeleteAll(true);

    ItemAnalysisViewEntry.SetRange("Item No.","No.");
    ItemAnalysisViewEntry.DeleteAll;

    ItemAnalysisBudgViewEntry.SetRange("Item No.","No.");
    ItemAnalysisBudgViewEntry.DeleteAll;

    PlanningAssignment.SetRange("Item No.","No.");
    PlanningAssignment.DeleteAll;

    BOMComp.Reset;
    BOMComp.SetRange("Parent Item No.","No.");
    BOMComp.DeleteAll;

    TroubleshSetup.Reset;
    TroubleshSetup.SetRange(Type,TroubleshSetup.Type::Item);
    TroubleshSetup.SetRange("No.","No.");
    TroubleshSetup.DeleteAll;

    ResSkillMgt.DeleteItemResSkills("No.");
    DimMgt.DeleteDefaultDim(DATABASE::Item,"No.");

    ItemIdent.Reset;
    ItemIdent.SetCurrentKey("Item No.");
    ItemIdent.SetRange("Item No.","No.");
    ItemIdent.DeleteAll;

    ServiceItemComponent.Reset;
    ServiceItemComponent.SetRange(Type,ServiceItemComponent.Type::Item);
    ServiceItemComponent.SetRange("No.","No.");
    ServiceItemComponent.ModifyAll("No.",'');

    BinContent.SetCurrentKey("Item No.");
    BinContent.SetRange("Item No.","No.");
    BinContent.DeleteAll;

    ItemCrossReference.SetRange("Item No.","No.");
    ItemCrossReference.DeleteAll;

    MyItem.SetRange("Item No.","No.");
    MyItem.DeleteAll;

    if not SocialListeningSearchTopic.IsEmpty then begin
      SocialListeningSearchTopic.FindSearchTopic(SocialListeningSearchTopic."Source Type"::Item,"No.");
      SocialListeningSearchTopic.DeleteAll;
    end;

    ItemAttributeValueMapping.Reset;
    ItemAttributeValueMapping.SetRange("Table ID",DATABASE::Item);
    ItemAttributeValueMapping.SetRange("No.","No.");
    ItemAttributeValueMapping.DeleteAll;

    OnAfterDeleteRelatedData(Rec);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    PurchLine.SetCurrentKey("Document Type",Type,"No.","Variant Code","Drop Shipment","Location Code","Expected Receipt Date");
    PurchLine.SetRange("Document Type",PurchLine."Document Type"::"Return Order");
    PurchLine.SetRange(Type,PurchLine.Type::Item);
    PurchLine.SetRange("No.","No.");
    PurchLine.SetFilter("Location Code",GetFilter("Location Filter"));
    PurchLine.SetFilter("Drop Shipment",GetFilter("Drop Shipment Filter"));
    PurchLine.SetFilter("Variant Code",GetFilter("Variant Filter"));
    PurchLine.SetRange("Expected Receipt Date",GetRangeMin("Date Filter"),GetRangeMax("Date Filter"));
    PurchLine.CalcSums("Outstanding Qty. (Base)");
    exit(PurchLine."Outstanding Qty. (Base)");
    */
    //end;

    //Unsupported feature: Property Modification (Attributes) on "AssistEdit(PROCEDURE 2)".


    //Unsupported feature: Property Modification (Attributes) on "FindItemVend(PROCEDURE 5)".



    //Unsupported feature: Code Modification on "FindItemVend(PROCEDURE 5)".

    //procedure FindItemVend();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    TestField("No.");
    ItemVend.Reset;
    ItemVend.SetRange("Item No.","No.");
    #4..9
      GetPlanningParameters.AtSKU(SKU,"No.",ItemVend."Variant Code",LocationCode);
      if ItemVend."Vendor No." = '' then
        ItemVend."Vendor No." := SKU."Vendor No.";
      if ItemVend."Vendor Item No." = '' then
        ItemVend."Vendor Item No." := SKU."Vendor Item No.";
      ItemVend."Lead Time Calculation" := SKU."Lead Time Calculation";
    end;
    if Format(ItemVend."Lead Time Calculation") = '' then begin
      GetPlanningParameters.AtSKU(SKU,"No.",ItemVend."Variant Code",LocationCode);
      ItemVend."Lead Time Calculation" := SKU."Lead Time Calculation";
      if Format(ItemVend."Lead Time Calculation") = '' then
        if Vend.Get(ItemVend."Vendor No.") then
          ItemVend."Lead Time Calculation" := Vend."Lead Time Calculation";
    end;
    ItemVend.Reset;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..12
      if (ItemVend."Vendor Item No." = '') and (ItemVend."Vendor No." = SKU."Vendor No.") then
    #14..16
    if Format(ItemVend."Lead Time Calculation") = '' then
      if Vend.Get(ItemVend."Vendor No.") then
        ItemVend."Lead Time Calculation" := Vend."Lead Time Calculation";
    ItemVend.Reset;
    */
    //end;

    //Unsupported feature: Property Modification (Attributes) on "ValidateShortcutDimCode(PROCEDURE 8)".



    //Unsupported feature: Code Modification on "ValidateShortcutDimCode(PROCEDURE 8)".

    //procedure ValidateShortcutDimCode();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
    if not IsTemporary then begin
      DimMgt.SaveDefaultDim(DATABASE::Item,"No.",FieldNumber,ShortcutDimCode);
      Modify;
    end;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
    DimMgt.SaveDefaultDim(DATABASE::Item,"No.",FieldNumber,ShortcutDimCode);
    Modify;
    */
    //end;

    //Unsupported feature: Property Modification (Attributes) on "TestNoEntriesExist(PROCEDURE 1006)".



    //Unsupported feature: Code Modification on "TestNoEntriesExist(PROCEDURE 1006)".

    //procedure TestNoEntriesExist();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    if "No." = '' then
      exit;

    IsHandled := false;
    OnBeforeTestNoItemLedgEntiesExist(Rec,CurrentFieldName,IsHandled);
    if not IsHandled then begin
      ItemLedgEntry.SetCurrentKey("Item No.");
      ItemLedgEntry.SetRange("Item No.","No.");
      if not ItemLedgEntry.IsEmpty then
        Error(Text007,CurrentFieldName);
    end;

    IsHandled := false;
    OnBeforeTestNoPurchLinesExist(Rec,CurrentFieldName,IsHandled);
    if not IsHandled then begin
      PurchaseLine.SetCurrentKey("Document Type",Type,"No.");
      PurchaseLine.SetFilter(
        "Document Type",'%1|%2',
        PurchaseLine."Document Type"::Order,
        PurchaseLine."Document Type"::"Return Order");
      PurchaseLine.SetRange(Type,PurchaseLine.Type::Item);
      PurchaseLine.SetRange("No.","No.");
      if PurchaseLine.FindFirst then
        Error(Text008,CurrentFieldName,PurchaseLine."Document Type");
    end;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    ItemLedgEntry.SetCurrentKey("Item No.");
    ItemLedgEntry.SetRange("Item No.","No.");
    if ItemLedgEntry.Find('-') then
      Error(
        Text007,
        CurrentFieldName);

    PurchOrderLine.SetCurrentKey("Document Type",Type,"No.");
    PurchOrderLine.SetFilter(
      "Document Type",'%1|%2',
      PurchOrderLine."Document Type"::Order,
      PurchOrderLine."Document Type"::"Return Order");
    PurchOrderLine.SetRange(Type,PurchOrderLine.Type::Item);
    PurchOrderLine.SetRange("No.","No.");
    if PurchOrderLine.Find('-') then
      Error(
        Text008,
        CurrentFieldName,
        PurchOrderLine."Document Type");
    */
    //end;

    //Unsupported feature: Property Modification (Attributes) on "TestNoOpenEntriesExist(PROCEDURE 4)".



    //Unsupported feature: Code Modification on "TestNoOpenEntriesExist(PROCEDURE 4)".

    //procedure TestNoOpenEntriesExist();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    ItemLedgEntry.SetCurrentKey("Item No.",Open);
    ItemLedgEntry.SetRange("Item No.","No.");
    ItemLedgEntry.SetRange(Open,true);
    if not ItemLedgEntry.IsEmpty then
      Error(
        Text019,
        CurrentFieldName);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..3
    if ItemLedgEntry.Find('-') then
    #5..7
    */
    //end;

    //Unsupported feature: Property Modification (Attributes) on "ItemSKUGet(PROCEDURE 11)".


    //Unsupported feature: Property Deletion (Local) on "GetInvtSetup(PROCEDURE 14)".


    //Unsupported feature: Property Modification (Attributes) on "IsMfgItem(PROCEDURE 1)".


    //Unsupported feature: Property Deletion (Local) on "ProdOrderExist(PROCEDURE 7)".


    //Unsupported feature: Property Modification (Attributes) on "CheckSerialNoQty(PROCEDURE 15)".


    //Unsupported feature: Property Deletion (Local) on "CheckForProductionOutput(PROCEDURE 17)".


    //Unsupported feature: Property Deletion (Length) on "GetItemNo(PROCEDURE 10).ReturnValue".


    //Unsupported feature: Property Modification (Data type) on "GetItemNo(PROCEDURE 10).ReturnValue".


    //Unsupported feature: Variable Insertion (Variable: SalesLine) (VariableCollection) on "CalcSalesReturn(PROCEDURE 10)".


    //Unsupported feature: Property Modification (Attributes) on "GetItemNo(PROCEDURE 10)".


    //Unsupported feature: Property Modification (Name) on "GetItemNo(PROCEDURE 10)".



    //Unsupported feature: Code Modification on "GetItemNo(PROCEDURE 10)".

    //procedure GetItemNo();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    TryGetItemNo(ItemNo,ItemText,true);
    exit(CopyStr(ItemNo,1,MaxStrLen("No.")));
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    SalesLine.SetCurrentKey("Document Type",Type,"No.","Variant Code","Drop Shipment","Location Code","Shipment Date");
    SalesLine.SetRange("Document Type",SalesLine."Document Type"::"Return Order");
    SalesLine.SetRange(Type,SalesLine.Type::Item);
    SalesLine.SetRange("No.","No.");
    SalesLine.SetFilter("Location Code",GetFilter("Location Filter"));
    SalesLine.SetFilter("Drop Shipment",GetFilter("Drop Shipment Filter"));
    SalesLine.SetFilter("Variant Code",GetFilter("Variant Filter"));
    SalesLine.SetRange("Shipment Date",GetRangeMin("Date Filter"),GetRangeMax("Date Filter"));
    SalesLine.CalcSums("Outstanding Qty. (Base)");
    exit(SalesLine."Outstanding Qty. (Base)");
    */
    //end;

    //Unsupported feature: Property Modification (Data type) on "TryGetItemNo(PROCEDURE 9).ReturnValue".


    //Unsupported feature: Property Insertion (Name) on "TryGetItemNo(PROCEDURE 9).ReturnValue".


    //Unsupported feature: Variable Insertion (Variable: ReqLine) (VariableCollection) on "PlanningTransferShptQty(PROCEDURE 9)".


    //Unsupported feature: Property Modification (Attributes) on "TryGetItemNo(PROCEDURE 9)".


    //Unsupported feature: Property Modification (Name) on "TryGetItemNo(PROCEDURE 9)".



    //Unsupported feature: Code Modification on "TryGetItemNo(PROCEDURE 9)".

    //procedure TryGetItemNo();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    InvtSetup.Get;
    exit(TryGetItemNoOpenCard(ReturnValue,ItemText,DefaultCreate,true,not InvtSetup."Skip Prompt to Create Item"));
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    ReqLine.SetCurrentKey(Type,"No.","Variant Code","Transfer-from Code","Transfer Shipment Date");
    ReqLine.SetRange("Replenishment System",ReqLine."Replenishment System"::Transfer);
    ReqLine.SetRange(Type,ReqLine.Type::Item);
    ReqLine.SetRange("No.","No.");
    CopyFilter("Variant Filter",ReqLine."Variant Code");
    CopyFilter("Location Filter",ReqLine."Transfer-from Code");
    CopyFilter("Date Filter",ReqLine."Transfer Shipment Date");
    if ReqLine.IsEmpty then
      exit;

    if ReqLine.FindSet then
      repeat
        Sum += ReqLine."Quantity (Base)";
      until ReqLine.Next = 0;
    */
    //end;

    //Unsupported feature: Property Deletion (Length) on "CreateNewItem(PROCEDURE 3).ReturnValue".


    //Unsupported feature: Property Modification (Data type) on "CreateNewItem(PROCEDURE 3).ReturnValue".


    //Unsupported feature: Property Insertion (Name) on "CreateNewItem(PROCEDURE 3).ReturnValue".


    //Unsupported feature: Variable Insertion (Variable: ReqLine) (VariableCollection) on "PlanningReleaseQty(PROCEDURE 3)".


    //Unsupported feature: Property Deletion (Local) on "CreateNewItem(PROCEDURE 3)".


    //Unsupported feature: Property Modification (Name) on "CreateNewItem(PROCEDURE 3)".



    //Unsupported feature: Code Modification on "CreateNewItem(PROCEDURE 3)".

    //procedure CreateNewItem();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    if not ItemTemplate.NewItemFromTemplate(Item) then
      Error(SelectItemErr);

    Item.Description := ItemName;
    Item.Modify(true);
    Commit;
    if not ShowItemCard then
      exit(Item."No.");
    Item.SetRange("No.",Item."No.");
    ItemCard.SetTableView(Item);
    if not (ItemCard.RunModal = ACTION::OK) then
      Error(SelectItemErr);

    exit(Item."No.");
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    ReqLine.SetCurrentKey(Type,"No.","Variant Code","Location Code");
    ReqLine.SetRange(Type,ReqLine.Type::Item);
    ReqLine.SetRange("No.","No.");
    CopyFilter("Variant Filter",ReqLine."Variant Code");
    CopyFilter("Location Filter",ReqLine."Location Code");
    CopyFilter("Date Filter",ReqLine."Starting Date");
    CopyFilter("Global Dimension 1 Filter",ReqLine."Shortcut Dimension 1 Code");
    CopyFilter("Global Dimension 2 Filter",ReqLine."Shortcut Dimension 2 Code");
    if ReqLine.IsEmpty then
      exit;

    if ReqLine.FindSet then
      repeat
        Sum += ReqLine."Quantity (Base)";
      until ReqLine.Next = 0;
    */
    //end;

    //Unsupported feature: ReturnValue Insertion (ReturnValue: <Blank>) (ReturnValueCollection) on "CalcResvQtyOnPurchReturn(PROCEDURE 16)".


    //Unsupported feature: Variable Insertion (Variable: ReservationEntry) (VariableCollection) on "CalcResvQtyOnPurchReturn(PROCEDURE 16)".


    //Unsupported feature: Property Deletion (Local) on "SetLastDateTimeModified(PROCEDURE 16)".


    //Unsupported feature: Property Modification (Name) on "SetLastDateTimeModified(PROCEDURE 16)".



    //Unsupported feature: Code Modification on "SetLastDateTimeModified(PROCEDURE 16)".

    //procedure SetLastDateTimeModified();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    "Last DateTime Modified" := CurrentDateTime;
    "Last Date Modified" := DT2Date("Last DateTime Modified");
    "Last Time Modified" := DT2Time("Last DateTime Modified");
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    ReservationEntry.SetCurrentKey(
      "Item No.","Source Type","Source Subtype","Reservation Status",
      "Location Code","Variant Code","Shipment Date","Expected Receipt Date");
    ReservationEntry.SetRange("Item No.","No.");
    ReservationEntry.SetRange("Source Type",DATABASE::"Purchase Line");
    ReservationEntry.SetRange("Source Subtype",5); // return order
    ReservationEntry.SetRange("Reservation Status",ReservationEntry."Reservation Status"::Reservation);
    ReservationEntry.SetFilter("Location Code",GetFilter("Location Filter"));
    ReservationEntry.SetFilter("Variant Code",GetFilter("Variant Filter"));
    ReservationEntry.SetRange("Shipment Date",GetRangeMin("Date Filter"),GetRangeMax("Date Filter"));
    ReservationEntry.CalcSums("Quantity (Base)");
    exit(-ReservationEntry."Quantity (Base)");
    */
    //end;

    //Unsupported feature: ReturnValue Insertion (ReturnValue: <Blank>) (ReturnValueCollection) on "CalcResvQtyOnSalesReturn(PROCEDURE 13)".


    //Unsupported feature: Variable Insertion (Variable: ReservationEntry) (VariableCollection) on "CalcResvQtyOnSalesReturn(PROCEDURE 13)".


    //Unsupported feature: Property Deletion (Local) on "UpdateTaxGroupCode(PROCEDURE 13)".


    //Unsupported feature: Property Modification (Name) on "UpdateTaxGroupCode(PROCEDURE 13)".



    //Unsupported feature: Code Modification on "UpdateTaxGroupCode(PROCEDURE 13)".

    //procedure UpdateTaxGroupCode();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    if not IsNullGuid("Tax Group Id") then begin
      TaxGroup.SetRange(Id,"Tax Group Id");
      TaxGroup.FindFirst;
    end;

    Validate("Tax Group Code",TaxGroup.Code);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    ReservationEntry.SetCurrentKey(
      "Item No.","Source Type","Source Subtype","Reservation Status",
      "Location Code","Variant Code","Shipment Date","Expected Receipt Date");
    ReservationEntry.SetRange("Item No.","No.");
    ReservationEntry.SetRange("Source Type",DATABASE::"Sales Line");
    ReservationEntry.SetRange("Source Subtype",5); // return order
    ReservationEntry.SetRange("Reservation Status",ReservationEntry."Reservation Status"::Reservation);
    ReservationEntry.SetFilter("Location Code",GetFilter("Location Filter"));
    ReservationEntry.SetFilter("Variant Code",GetFilter("Variant Filter"));
    ReservationEntry.SetRange("Expected Receipt Date",GetRangeMin("Date Filter"),GetRangeMax("Date Filter"));
    ReservationEntry.CalcSums("Quantity (Base)");
    exit(ReservationEntry."Quantity (Base)");
    */
    //end;

    procedure "---FE_LAPIERRETTE_PROD01.001--"()
    begin
    end;

    procedure IsLotItem(piForceError: Boolean): Boolean
    var
        ItemTrackingCode3: Record "Item Tracking Code";
        RecLItemCategory: Record "Item Category";
    begin
        if "Item Tracking Code" = '' then
            if piForceError then
                TestField("Item Tracking Code")
            else
                exit(false);

        if not ItemTrackingCode3.Get("Item Tracking Code") then
            if piForceError then
                ItemTrackingCode3.Get("Item Tracking Code")
            else
                exit(false);

        if not ItemTrackingCode3."Lot Specific Tracking" then
            if piForceError then
                ItemTrackingCode3.TestField("Lot Specific Tracking", true)
            else
                exit(false);

        exit(true);

        /*
        IF RecLItemCategory.GET("Item Category Code") THEN
        BEGIN
          IF NOT(RecLItemCategory."Transmitted Order No.") THEN
            ERROR(Text92006);
        END
        ELSE
          ERROR(Text92006);
        */

    end;

    procedure TestNoEntriesExist_Cost() OK: Boolean
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        ItemLedgEntry.SetCurrentKey("Item No.");
        ItemLedgEntry.SetRange("Item No.", "No.");
        if ItemLedgEntry.Find('-') then
            exit(false);

        PurchOrderLine.SetCurrentKey("Document Type", Type, "No.");
        PurchOrderLine.SetFilter(
          "Document Type", '%1|%2',
          PurchOrderLine."Document Type"::Order,
          PurchOrderLine."Document Type"::"Return Order");
        PurchOrderLine.SetRange(Type, PurchOrderLine.Type::Item);
        PurchOrderLine.SetRange("No.", "No.");
        if PurchOrderLine.Find('-') then
            exit(false);

        exit(true);
    end;

    //Unsupported feature: Property Modification (Fields) on "DropDown(FieldGroup 1)".


    //Unsupported feature: Deletion (FieldGroupCollection) on "Brick(FieldGroup 2)".


    //Unsupported feature: Deletion (VariableCollection) on "DeleteRelatedData(PROCEDURE 12).BinContent(Variable 1002)".


    //Unsupported feature: Deletion (VariableCollection) on "DeleteRelatedData(PROCEDURE 12).ItemCrossReference(Variable 1001)".


    //Unsupported feature: Deletion (VariableCollection) on "DeleteRelatedData(PROCEDURE 12).SocialListeningSearchTopic(Variable 1000)".


    //Unsupported feature: Deletion (VariableCollection) on "DeleteRelatedData(PROCEDURE 12).MyItem(Variable 1003)".


    //Unsupported feature: Deletion (VariableCollection) on "DeleteRelatedData(PROCEDURE 12).ItemAttributeValueMapping(Variable 1004)".


    //Unsupported feature: Deletion (VariableCollection) on "TestNoEntriesExist(PROCEDURE 1006).PurchaseLine(Variable 1002)".


    //Unsupported feature: Deletion (VariableCollection) on "TestNoEntriesExist(PROCEDURE 1006).IsHandled(Variable 1003)".


    //Unsupported feature: Deletion (ParameterCollection) on "GetItemNo(PROCEDURE 10).ItemText(Parameter 1000)".


    //Unsupported feature: Deletion (VariableCollection) on "GetItemNo(PROCEDURE 10).ItemNo(Variable 1001)".


    //Unsupported feature: Deletion (ParameterCollection) on "TryGetItemNo(PROCEDURE 9).ReturnValue(Parameter 1007)".


    //Unsupported feature: Deletion (ParameterCollection) on "TryGetItemNo(PROCEDURE 9).ItemText(Parameter 1000)".


    //Unsupported feature: Deletion (ParameterCollection) on "TryGetItemNo(PROCEDURE 9).DefaultCreate(Parameter 1006)".


    //Unsupported feature: Deletion (ParameterCollection) on "CreateNewItem(PROCEDURE 3).ItemName(Parameter 1000)".


    //Unsupported feature: Deletion (ParameterCollection) on "CreateNewItem(PROCEDURE 3).ShowItemCard(Parameter 1001)".


    //Unsupported feature: Deletion (VariableCollection) on "CreateNewItem(PROCEDURE 3).Item(Variable 1005)".


    //Unsupported feature: Deletion (VariableCollection) on "CreateNewItem(PROCEDURE 3).ItemTemplate(Variable 1006)".


    //Unsupported feature: Deletion (VariableCollection) on "CreateNewItem(PROCEDURE 3).ItemCard(Variable 1002)".


    //Unsupported feature: Deletion (VariableCollection) on "UpdateTaxGroupCode(PROCEDURE 13).TaxGroup(Variable 1001)".


    //Variable type has not been exported.

    var
        Text001: Label 'You cannot delete %1 %2 because there is at least one outstanding Sales %3 that includes this item.';

    var
        PurchOrderLine: Record "Purchase Line";
        SalesOrderLine: Record "Sales Line";

    var
        ItemCategory: Record "Item Category";

    var
        NonstockItemMgt: Codeunit "Nonstock Item Management";

    var
        MobSalesMgt: Codeunit "Mobile Sales Management";

    var
        ProductGrp: Record "Product Group";

    var
        ApplicationManagement: Codeunit ApplicationManagement;
        Text92000: Label 'You can''t change this field if %1 or %2 are zero.';
        Text92001: Label 'You can''t change this field because there are not invoiced sales orders or return orders for this item.';
        Text92002: Label 'You can''t change this field because there are not invoiced purchase orders or return orders for this item.';
        Text92003: Label 'You can''t change this field because there are one or more outstanding transfer orders for this item.';
        Text92004: Label 'You cannot change this field because there are open reservations for this item.';
        Text92005: Label 'Future item movements won''t create any item ledger entries. Statistics for this item are not possible anymore.';
        ReservEntry: Record "Reservation Entry";
        ItemStock: Record Item;
        "-FE_LAPIERRETTE_ART01.001-": Integer;
        RecGItemConfigurator: Record "PWD Item Configurator";
        Text92006: Label 'Item Category Code must be "Transmitted to Order" to activate this feature.';
        "- LAP2.19 -": Integer;
        CduGClosingMgt: Codeunit "PWD Closing Management";
}

