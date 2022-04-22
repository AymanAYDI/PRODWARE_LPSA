pageextension 60008 "PWD ItemCard" extends "Item Card"
{
    layout
    {
        addafter(Description)
        {
            field("PWD Description 2"; "Description 2")
            {
                ApplicationArea = All;

            }
            field("PWD LPSA Description 1"; "PWD LPSA Description 1")
            {
                ApplicationArea = All;

            }
            field("PWD LPSA Description 2"; "PWD LPSA Description 2")
            {
                ApplicationArea = All;

            }
            field("PWD Quartis Description"; "PWD Quartis Description")
            {
                ApplicationArea = All;

            }
        }
        addafter("Last Date Modified")
        {
            field("PWD Customer Plan No."; "PWD Customer Plan No.")
            {
                ApplicationArea = All;

            }
            field("PWD Customer Plan Description"; "PWD Customer Plan Description")
            {
                ApplicationArea = All;

            }
            field("PWD LPSA Plan No."; "PWD LPSA Plan No.")
            {
                ApplicationArea = All;

            }
            field("PWD Barcode"; "PWD Barcode")
            {
                ApplicationArea = All;

            }
        }
        addafter(Inventory)
        {
            field("PWD Principal Inventory"; "PWD Principal Inventory")
            {
                ApplicationArea = All;

            }
            field("PWD Inventory2"; "PWD Inventory 2")
            {
                ApplicationArea = All;

            }
        }
        addafter("Qty. on Purch. Order")
        {
            field("PWD Arch. Purchase Order Qty."; "PWD Arch. Purchase Order Qty.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Qty. on Prod. Order")
        {
            field("PWD Released Qty. on Prod. Order"; "PWD Released Qty. on Prod. Order")
            {
                ApplicationArea = All;
            }
            field("PWD Firm Plan. Qty. on Prod. Order"; "PWD Firm Plan. Qty. on Prod. Order")
            {
                ApplicationArea = All;
            }
        }
        addafter("Qty. on Sales Order")
        {
            field("PWD Arch. Sales Order Qty."; "PWD Arch. Sales Order Qty.")
            {
                ApplicationArea = All;

            }
            field("PWD Forecast Qty."; "PWD Forecast Qty.")
            {
                ApplicationArea = All;

            }
        }
        addlast(InventoryGrp)
        {
            field("PWD Phantom Item"; "PWD Phantom Item")
            {
                ApplicationArea = All;
            }
        }
        addafter("Price/Profit Calculation")
        {
            field("PWD Inventory Value Zero"; "Inventory Value Zero")
            {
                ApplicationArea = All;

            }
        }
        addafter("Sales Blocked")
        {
            field("PWD Last Unit Cost Calc. Date"; "Last Unit Cost Calc. Date")
            {
                ApplicationArea = All;

            }
            field("PWD Rolled-up Material Cost"; "Rolled-up Material Cost")
            {
                ApplicationArea = All;

            }
            field("PWD Rolled-up Capacity Cost"; "Rolled-up Capacity Cost")
            {
                ApplicationArea = All;

            }
        }
        addafter("Lead Time Calculation")
        {
            field("PWD Location Code"; "Location Code")
            {
                ApplicationArea = All;

            }
        }
        addafter("Routing No.")
        {
            Field(ActiveVersionCode; CodGActiveVersionCode)
            {
                caption = 'Routing Active Version';
                editable = false;
                ApplicationArea = All;
                trigger OnLookup(var text: text): Boolean
                var
                    RecLRtngVersion: Record "Routing Version";
                begin
                    //>>LAP2.12
                    RecLRtngVersion.SETRANGE("Routing No.", "Routing No.");
                    RecLRtngVersion.SETRANGE("Version Code", CodGActiveVersionCode);
                    Page.RUNMODAL(Page::"Routing Version", RecLRtngVersion);
                    CodGActiveVersionCode := CduGVersionMgt.GetRtngVersion("Routing No.", WORKDATE(), TRUE);
                    //<<LAP2.12
                END;
            }
        }
        addafter("Production BOM No.")
        {
            field("PWD Manufacturing Code"; "PWD Manufacturing Code")
            {
                ApplicationArea = All;
            }

        }
        addafter("Order Multiple")
        {
            field("PWD Plate Number"; "PWD Plate Number")
            {
                ApplicationArea = All;
            }
            field("PWD Part Number By Plate"; "PWD Part Number By Plate")
            {
                ApplicationArea = All;
            }
        }
        addafter("Expiration Calculation")
        {
            field("PWD Lot Determining"; "PWD Lot Determining")
            {
                ApplicationArea = All;
                Enabled = "Lot DeterminingEnable";
            }

        }
        addafter(Warehouse)
        {
            group("PWD WMS")
            {
                field("PWD WMS_Product Type"; "PWD WMS_Product Type")
                {
                    ApplicationArea = All;
                }
                field("PWD WMS_Permanent item"; "PWD WMS_Permanent item")
                {
                    ApplicationArea = All;
                }
                field("PWD WMS_Freezing sensitive"; "PWD WMS_Freezing sensitive")
                {
                    ApplicationArea = All;
                }
                field("PWD WMS_Heat sensitive"; "PWD WMS_Heat sensitive")
                {
                    ApplicationArea = All;
                }
                field("PWD WMS_Dangerous item"; "PWD WMS_Dangerous item")
                {
                    ApplicationArea = All;
                }
                field("PWD WMS_Fragile item"; "PWD WMS_Fragile item")
                {
                    ApplicationArea = All;
                }
                field("PWD WMS_Mandatory SSCC No"; "PWD WMS_Mandatory SSCC No")
                {
                    ApplicationArea = All;
                }
                field("PWD WMS_Item"; "PWD WMS_Item")
                {
                    ApplicationArea = All;
                }
            }
        }
        modify(Inventory)
        {
            Importance = Standard;
            Visible = false;
        }
    }
    actions
    {
        addfirst(Entries)
        {
            action("PWD StandardCostbyLotSize")
            {
                caption = 'Standard Cost by Lot Size';
                RunObject = Page "PWD Lot Size Std. Cost List";
                RunPageLink = "Item No." = FIELD("No.");
                ApplicationArea = All;
            }
        }
        addbefore("&Units of Measure")
        {
            action("PWD LotSize")
            {
                caption = 'Lot Size';
                RunObject = Page "PWD Lot Size List";
                ApplicationArea = All;
            }
        }
        addbefore(Translations)
        {
            action("PWD Action1100267006")
            {
                caption = 'Possible Items';
                RunObject = Page "PWD Possible Items List";
                RunPageLink = "Item Code" = FIELD("No.");
                Promoted = True;
                Image = SplitChecks;
                PromotedCategory = Process;
                ApplicationArea = All;
            }
            action("PWD PossibleItemsExport")
            {
                caption = 'Possible Items Export';
                Promoted = True;
                Image = Export;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction()
                VAR
                    CduLConnectorOSYSParseData: Codeunit "PWD Connector OSYS Parse Data";
                BEGIN
                    //>>FE_LAPRIERRETTE_GP0004.001
                    CLEAR(CduLConnectorOSYSParseData);
                    CduLConnectorOSYSParseData.FctExportItemsPossibleManual("No.");
                    //<<FE_LAPRIERRETTE_GP0004.001
                END;

            }
            action("PWD PhantomsItems")
            {
                caption = 'Phantoms Items';
                ApplicationArea = All;
                RunObject = Page "PWD Phantom subs. Items List";
                RunPageLink = "Phantom Item No." = FIELD("No.");
                Promoted = True;
                Image = SplitChecks;
                PromotedCategory = Process;
            }
        }
        addafter("Calc. Stan&dard Cost")
        {
            action("PWD RoutingCard")
            {
                caption = 'Routing Card';
                ApplicationArea = All;
                trigger OnAction()
                VAR
                    RecLRouting: Record "Routing Header";
                    PagLRouting: Page Routing;
                    RecLRtngVersion: Record "Routing Version";
                BEGIN
                    //>>LAP2.12
                    IF CodGActiveVersionCode = '' THEN BEGIN
                        //>>LPSA.TDL.19112014
                        IF RecLRouting.GET("Routing No.") THEN BEGIN
                            RecLRouting.SETRANGE("No.", "Routing No.");
                            PagLRouting.SETTABLEVIEW(RecLRouting);
                            PagLRouting.RUNMODAL;
                        END;
                        //<<LPSA.TDL.19112014
                    END ELSE BEGIN
                        RecLRtngVersion.SETRANGE("Routing No.", "Routing No.");
                        RecLRtngVersion.SETRANGE("Version Code", CodGActiveVersionCode);
                        Page.RUNMODAL(Page::"Routing Version", RecLRtngVersion);
                    END;
                    //<<LAP2.12
                END;
            }
            action("PWD BOMCard")
            {
                caption = 'BOM Card';
                ApplicationArea = All;
                trigger OnAction()
                VAR
                    RecLProductionBOM: Record "Production BOM Header";
                    PagLProductionBOM: Page "Production BOM";
                BEGIN
                    //>>LPSA.TDL.19112014
                    IF RecLProductionBOM.GET("Production BOM No.") THEN BEGIN
                        RecLProductionBOM.SETRANGE("No.", "Production BOM No.");
                        PagLProductionBOM.SETTABLEVIEW(RecLProductionBOM);
                        PagLProductionBOM.RUNMODAL();
                    END;
                    //<<LPSA.TDL.19112014
                END;
            }
        }
        addbefore("Requisition Worksheet")
        {
            action("PWD Action1100294016")
            {
                caption = 'Item Configurator';
                ApplicationArea = All;
                Promoted = True;
                PromotedCategory = Process;
                trigger OnAction()
                VAR
                    PgeLItemConfigurator: Page "PWD Item Configurator";
                    RecLItemConfigurator: Record "PWD Item Configurator";
                    CstLT001: Label 'Item %1 not created from configurator.';
                BEGIN
                    //>>FE_LAPIERRETTE_ART01.001
                    RecLItemConfigurator.RESET();
                    RecLItemConfigurator.SETCURRENTKEY("Item Code");
                    RecLItemConfigurator.SETRANGE("Item Code", "No.");
                    IF RecLItemConfigurator.FINDFIRST() THEN BEGIN
                        CLEAR(PgeLItemConfigurator);
                        PgeLItemConfigurator.SETTABLEVIEW(RecLItemConfigurator);
                        PgeLItemConfigurator.EDITABLE(TRUE);
                        PgeLItemConfigurator.FctNotEditable(TRUE);
                        PgeLItemConfigurator.RUNMODAL();
                        //PgeLItemConfigurator.RUN;
                    END ELSE
                        MESSAGE(CstLT001, "No.");
                    //<<FE_LAPIERRETTE_ART01.001
                END;
            }
        }
    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        //>>REGIE
        FctCheckBeforeClose;
        //<<REGIE
    end;

    trigger OnAfterGetRecord()
    begin
        //>>FE_LAPIERRETTE_PROD01.001: TO 13/12/2011
        Fct_EnableLotDeterm();
        //<<FE_LAPIERRETTE_PROD01.001: TO 13/12/2011

        //>>LAP2.12
        CodGActiveVersionCode := CduGVersionMgt.GetRtngVersion("Routing No.", WORKDATE(), TRUE);
        //<<LAP2.12

        //>>TDL260619.001
        //>>TDL131119
        //SETFILTER("Location Filter",'%1',"Location Code");
        SETFILTER("PWD Other Location Filter", '<>%1', "Location Code");
        SETFILTER("PWD Principal Location Filter", '%1', "Location Code");

        CALCFIELDS("PWD Principal Inventory", "PWD Inventory 2");
    end;

    procedure Fct_EnableLotDeterm()
    var
        ItemCategory: Record "Item Category";
    BEGIN
        "Lot DeterminingEnable" := FALSE;

        IF ItemCategory.GET("Item Category Code") THEN
            IF ItemCategory."PWD Transmitted Order No." THEN
                "Lot DeterminingEnable" := TRUE;
    END;

    procedure FctCheckBeforeClose()
    var
        RecLRoutingHeader: Record "Routing Header";
        RecLProductionBOMHeader: Record "Production BOM Header";
        LPSAFunctionsMgt: Codeunit "PWD LPSA Functions Mgt.";
    //CalculateStdCost: Codeunit "Calculate Standard Cost";
    BEGIN
        IF ("Replenishment System" = "Replenishment System"::"Prod. Order") AND
           ("Costing Method" = "Costing Method"::Standard) AND
           ("Lot Size" <> 0) AND
           (RecLRoutingHeader.GET("Routing No.")) AND
           (RecLProductionBOMHeader.GET("Production BOM No.")) AND
           (RecLRoutingHeader.Status = RecLRoutingHeader.Status::Certified) AND
           (RecLProductionBOMHeader.Status = RecLProductionBOMHeader.Status::Certified) AND
           //   ("Standard Cost" = 0) AND
           //   (NOT BooGCalcCost) THEN
           ("Standard Cost" = 0) THEN
            IF CONFIRM(CstG001, TRUE) THEN BEGIN
                CLEAR(LPSAFunctionsMgt);
                //>>TDL290719.001
                //CalculateStdCost.FctCalcItemMonoLevel("No.",FALSE);
                LPSAFunctionsMgt.CalculateCost(Rec);
                //<<TDL290719.001
            END ELSE
                ERROR(CstG002);
    END;


    var
        [InDataSet]
        "Lot DeterminingEnable": Boolean;
        CduGVersionMgt: Codeunit VersionManagement;
        CodGActiveVersionCode: Code[20];
        CstG001: Label 'The Item standard cost is 0, Do you want to calculate it ?';
        CstG002: Label 'The card can not be closed because The Item standard cost is 0 !';
        BooGCalcCost: Boolean;
        CstG003: Label 'The routing, the nomenclature and / or the Lot size have been modified! \ Do you want to recalculate the standard cost of the item?';
        CstG004: Label 'The card can not be closed because The Item standard costmust be recalculate !';

}