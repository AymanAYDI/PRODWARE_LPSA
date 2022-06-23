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
                if "PWD Lot Determining" then
                    IsLotItem(true);
                //  TESTFIELD("From the same Lot", TRUE);
            end;
        }
        field(50008; "PWD Phantom Item"; Boolean)
        {
            Caption = 'Phantom Item';
        }
        field(50009; "PWD Released Scheduled Need (Qty.)"; Decimal)
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
        field(50010; "PWD Rele. Qty. on Prod. Order"; Decimal)
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
        field(50012; "PWD Sales Invoiced Qty."; Integer)
        {
            CalcFormula = Count("Sales Invoice Line" WHERE(Type = CONST(Item),
                                                            "No." = FIELD("No.")));
            Caption = 'Qté facturée';
            Editable = false;
            Enabled = false;
            FieldClass = FlowField;
        }
        field(50013; "PWD Firm Plan. Qty. Prod. Ord."; Decimal)
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
            CalcFormula = Exist("Item Reference" WHERE("Item No." = FIELD("No."),
                                                              "Reference Type" = CONST(Customer),
                                                              "Reference Type No." = FIELD("PWD Customer Filter")));
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
        field(50021; "PWD Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "PWD Product Group".Code WHERE("Item Category Code" = FIELD("Item Category Code"));
            trigger OnValidate()
            var
                CduGClosingMgt: Codeunit "PWD Closing Management";
            begin
                //>>P24578_008.001
                CduGClosingMgt.UpdtItemDimValue(DATABASE::"PWD Product Group", "No.", "PWD Product Group Code");
                //<<P24578_008.001  
            end;
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
        field(500046; "PWD Prod. Forecast Qty. (Base)"; Decimal)
        {
            CalcFormula = Sum("Production Forecast Entry"."Forecast Quantity (Base)" WHERE("Item No." = FIELD("No."),
                                                                                            "Production Forecast Name" = FIELD("Production Forecast Name"),
                                                                                            "Forecast Date" = FIELD("Date Filter"),
                                                                                            "Location Code" = FIELD("Location Filter"),
                                                                                            "Component Forecast" = FIELD("Component Forecast"),
                                                                                            "Variant Code" = FIELD("Variant Filter"),
                                                                                            "PWD Customer No." = FIELD("PWD Customer Filter")));
            Caption = 'Prod. Forecast Quantity (Base)';
            DecimalPlaces = 0 : 5;
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
        Modify("Shelf No.")
        {
            TableRelation = Bin.Code;
        }
    }
    keys
    {


    }

    procedure IsLotItem(piForceError: Boolean): Boolean
    var
        ItemTrackingCode3: Record "Item Tracking Code";
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
        if not ItemLedgEntry.IsEmpty then
            exit(false);

        PurchOrderLine.SetCurrentKey("Document Type", Type, "No.");
        PurchOrderLine.SetFilter(
          "Document Type", '%1|%2',
          PurchOrderLine."Document Type"::Order,
          PurchOrderLine."Document Type"::"Return Order");
        PurchOrderLine.SetRange(Type, PurchOrderLine.Type::Item);
        PurchOrderLine.SetRange("No.", "No.");
        if not PurchOrderLine.IsEmpty then
            exit(false);

        exit(true);
    end;


    var

        PurchOrderLine: Record "Purchase Line";
}

