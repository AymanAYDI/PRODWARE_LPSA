pageextension 60008 "PWD ItemCard" extends "Item Card"
{
    layout
    {
        addafter(Description)
        {
            field("PWD Description 2"; Rec."Description 2")
            {
                ApplicationArea = All;

            }
            field("PWD LPSA Description 1"; Rec."PWD LPSA Description 1")
            {
                ApplicationArea = All;

            }
            field("PWD LPSA Description 2"; Rec."PWD LPSA Description 2")
            {
                ApplicationArea = All;

            }
            field("PWD Quartis Description"; Rec."PWD Quartis Description")
            {
                ApplicationArea = All;

            }
        }
        addafter("Last Date Modified")
        {
            field("PWD Customer Plan No."; Rec."PWD Customer Plan No.")
            {
                ApplicationArea = All;

            }
            field("PWD Customer Plan Description"; Rec."PWD Customer Plan Description")
            {
                ApplicationArea = All;

            }
            field("PWD LPSA Plan No."; Rec."PWD LPSA Plan No.")
            {
                ApplicationArea = All;

            }
            field("PWD Barcode"; Rec."PWD Barcode")
            {
                ApplicationArea = All;

            }
        }
        addafter(Inventory)
        {
            field("PWD Principal Inventory"; Rec."PWD Principal Inventory")
            {
                ApplicationArea = All;

            }
            field("PWD Inventory2"; Rec."PWD Inventory 2")
            {
                ApplicationArea = All;

            }
        }
        addafter("Qty. on Purch. Order")
        {
            field("PWD Arch. Purchase Order Qty."; Rec."PWD Arch. Purchase Order Qty.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Qty. on Prod. Order")
        {
            field("PWD Released Qty. on Prod. Order"; Rec."PWD Released Qty. on Prod. Order")
            {
                ApplicationArea = All;
            }
            field("PWD Firm Plan. Qty. on Prod. Order"; Rec."PWD Firm Plan. Qty. on Prod. Order")
            {
                ApplicationArea = All;
            }
        }
        addafter("Qty. on Sales Order")
        {
            field("PWD Arch. Sales Order Qty."; Rec."PWD Arch. Sales Order Qty.")
            {
                ApplicationArea = All;

            }
            field("PWD Forecast Qty."; Rec."PWD Forecast Qty.")
            {
                ApplicationArea = All;

            }
        }
        addlast(InventoryGrp)
        {
            field("PWD Phantom Item"; Rec."PWD Phantom Item")
            {
                ApplicationArea = All;
            }
        }
        addafter("Price/Profit Calculation")
        {
            field("PWD Inventory Value Zero"; Rec."Inventory Value Zero")
            {
                ApplicationArea = All;

            }
        }
        addafter("Sales Blocked")
        {
            field("PWD Last Unit Cost Calc. Date"; Rec."Last Unit Cost Calc. Date")
            {
                ApplicationArea = All;

            }
            field("PWD Rolled-up Material Cost"; Rec."Rolled-up Material Cost")
            {
                ApplicationArea = All;

            }
            field("PWD Rolled-up Capacity Cost"; Rec."Rolled-up Capacity Cost")
            {
                ApplicationArea = All;

            }
        }
        addafter("Lead Time Calculation")
        {
            field("PWD Location Code"; Rec."Location Code")
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
                    RecLRtngVersion.SETRANGE("Routing No.", Rec."Routing No.");
                    RecLRtngVersion.SETRANGE("Version Code", CodGActiveVersionCode);
                    Page.RUNMODAL(Page::"Routing Version", RecLRtngVersion);
                    CodGActiveVersionCode := CduGVersionMgt.GetRtngVersion(Rec."Routing No.", WORKDATE(), TRUE);
                    //<<LAP2.12
                END;
            }
        }
        addafter("Production BOM No.")
        {
            field("PWD Manufacturing Code"; Rec."PWD Manufacturing Code")
            {
                ApplicationArea = All;
            }

        }
        addafter("Order Multiple")
        {
            field("PWD Plate Number"; Rec."PWD Plate Number")
            {
                ApplicationArea = All;
            }
            field("PWD Part Number By Plate"; Rec."PWD Part Number By Plate")
            {
                ApplicationArea = All;
            }
        }
        addafter("Expiration Calculation")
        {
            field("PWD Lot Determining"; Rec."PWD Lot Determining")
            {
                ApplicationArea = All;
                Enabled = "Lot DeterminingEnable";
            }

        }
        addafter(Warehouse)
        {
            group("PWD WMS")
            {
                field("PWD WMS_Product Type"; Rec."PWD WMS_Product Type")
                {
                    ApplicationArea = All;
                }
                field("PWD WMS_Permanent item"; Rec."PWD WMS_Permanent item")
                {
                    ApplicationArea = All;
                }
                field("PWD WMS_Freezing sensitive"; Rec."PWD WMS_Freezing sensitive")
                {
                    ApplicationArea = All;
                }
                field("PWD WMS_Heat sensitive"; Rec."PWD WMS_Heat sensitive")
                {
                    ApplicationArea = All;
                }
                field("PWD WMS_Dangerous item"; Rec."PWD WMS_Dangerous item")
                {
                    ApplicationArea = All;
                }
                field("PWD WMS_Fragile item"; Rec."PWD WMS_Fragile item")
                {
                    ApplicationArea = All;
                }
                field("PWD WMS_Mandatory SSCC No"; Rec."PWD WMS_Mandatory SSCC No")
                {
                    ApplicationArea = All;
                }
                field("PWD WMS_Item"; Rec."PWD WMS_Item")
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
                    CduLConnectorOSYSParseData.FctExportItemsPossibleManual(Rec."No.");
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
                    RecLRtngVersion: Record "Routing Version";
                    PagLRouting: Page Routing;
                BEGIN
                    //>>LAP2.12
                    IF CodGActiveVersionCode = '' THEN BEGIN
                        //>>LPSA.TDL.19112014
                        IF RecLRouting.GET(Rec."Routing No.") THEN BEGIN
                            RecLRouting.SETRANGE("No.", Rec."Routing No.");
                            PagLRouting.SETTABLEVIEW(RecLRouting);
                            PagLRouting.RUNMODAL();
                        END;
                        //<<LPSA.TDL.19112014
                    END ELSE BEGIN
                        RecLRtngVersion.SETRANGE("Routing No.", Rec."Routing No.");
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
                    IF RecLProductionBOM.GET(Rec."Production BOM No.") THEN BEGIN
                        RecLProductionBOM.SETRANGE("No.", Rec."Production BOM No.");
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
                    RecLItemConfigurator: Record "PWD Item Configurator";
                    PgeLItemConfigurator: Page "PWD Item Configurator";
                    CstLT001: Label 'Item %1 not created from configurator.';
                BEGIN
                    //>>FE_LAPIERRETTE_ART01.001
                    RecLItemConfigurator.RESET();
                    RecLItemConfigurator.SETCURRENTKEY("Item Code");
                    RecLItemConfigurator.SETRANGE("Item Code", Rec."No.");
                    IF RecLItemConfigurator.FINDFIRST() THEN BEGIN
                        CLEAR(PgeLItemConfigurator);
                        PgeLItemConfigurator.SETTABLEVIEW(RecLItemConfigurator);
                        PgeLItemConfigurator.EDITABLE(TRUE);
                        PgeLItemConfigurator.FctNotEditable(TRUE);
                        PgeLItemConfigurator.RUNMODAL();
                        //PgeLItemConfigurator.RUN;
                    END ELSE
                        MESSAGE(CstLT001, Rec."No.");
                    //<<FE_LAPIERRETTE_ART01.001
                END;
            }
        }
    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        //>>REGIE
        FctCheckBeforeClose();
        //<<REGIE
    end;

    trigger OnAfterGetRecord()
    begin
        //>>FE_LAPIERRETTE_PROD01.001: TO 13/12/2011
        Fct_EnableLotDeterm();
        //<<FE_LAPIERRETTE_PROD01.001: TO 13/12/2011

        //>>LAP2.12
        CodGActiveVersionCode := CduGVersionMgt.GetRtngVersion(Rec."Routing No.", WORKDATE(), TRUE);
        //<<LAP2.12

        //>>TDL260619.001
        //>>TDL131119
        //SETFILTER("Location Filter",'%1',"Location Code");
        Rec.SETFILTER("PWD Other Location Filter", '<>%1', Rec."Location Code");
        Rec.SETFILTER("PWD Principal Location Filter", '%1', Rec."Location Code");

        Rec.CALCFIELDS("PWD Principal Inventory", "PWD Inventory 2");
    end;

    procedure Fct_EnableLotDeterm()
    var
        ItemCategory: Record "Item Category";
    BEGIN
        "Lot DeterminingEnable" := FALSE;

        IF ItemCategory.GET(Rec."Item Category Code") THEN
            IF ItemCategory."PWD Transmitted Order No." THEN
                "Lot DeterminingEnable" := TRUE;
    END;

    procedure FctCheckBeforeClose()
    var
        RecLProductionBOMHeader: Record "Production BOM Header";
        RecLRoutingHeader: Record "Routing Header";
        LPSAFunctionsMgt: Codeunit "PWD LPSA Functions Mgt.";
    //CalculateStdCost: Codeunit "Calculate Standard Cost";
    BEGIN
        IF (Rec."Replenishment System" = Rec."Replenishment System"::"Prod. Order") AND
           (Rec."Costing Method" = Rec."Costing Method"::Standard) AND
           (Rec."Lot Size" <> 0) AND
           (RecLRoutingHeader.GET(Rec."Routing No.")) AND
           (RecLProductionBOMHeader.GET(Rec."Production BOM No.")) AND
           (RecLRoutingHeader.Status = RecLRoutingHeader.Status::Certified) AND
           (RecLProductionBOMHeader.Status = RecLProductionBOMHeader.Status::Certified) AND
           //   ("Standard Cost" = 0) AND
           //   (NOT BooGCalcCost) THEN
           (Rec."Standard Cost" = 0) THEN
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
        CduGVersionMgt: Codeunit VersionManagement;
        [InDataSet]
        "Lot DeterminingEnable": Boolean;
        CodGActiveVersionCode: Code[20];
        CstG001: Label 'The Item standard cost is 0, Do you want to calculate it ?';
        CstG002: Label 'The card can not be closed because The Item standard cost is 0 !';

}