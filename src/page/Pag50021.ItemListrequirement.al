page 50021 "PWD Item List requirement"
{
    // <changelog>
    //   <add id="dach1140"
    //        dev="sryser"
    //        date="2004-04-22"
    //        area="SWS14"
    //        releaseversion="DACH4.00"
    //        request="DACH-START-40">
    //        New menu Function,Copy item
    //   </add>
    // </changelog>
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_ART03.001: NI 23/11/2011:  Notion de N° plan sur article
    //                                           - Display field 50000..50003 on Tab [GENERAL]
    // 
    // FE_LAPIERRETTE_ART02.001: NI 23/11/2011:  Désignation article 120 caracteres
    //                                           - Add field 50004..50005
    // 
    // //>>LAP2.06
    // FE_LAPRIERRETTE_GP0003 : APA 16/05/13 - Add Field "Phantom Item"
    //                                       - Add Action "Phatom Item"
    // 
    // FE_LAPRIERRETTE_GP0004.001 :GR  23/05/13  : Add Action "Possible items"
    //                                             Add Action "Possible Items Export"
    // 
    // 
    // 
    // ------------------------------------------------------------------------------------------------------------------

    Caption = 'Item List';
    CardPageID = "Item Card";
    Editable = false;
    PageType = List;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field("PWD LPSA Description 1"; "PWD LPSA Description 1")
                {
                }
                field("PWD LPSA Description 2"; "PWD LPSA Description 2")
                {
                }
                field("Search Description"; "Search Description")
                {
                }
                field(Inventory; Inventory)
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Safety Stock Quantity"; "Safety Stock Quantity")
                {
                }
                field("Qty. on Purch. Order"; "Qty. on Purch. Order")
                {
                }
                field("Qty. on Sales Order"; "Qty. on Sales Order")
                {
                }
                field("Qty. on Prod. Order"; "Qty. on Prod. Order")
                {
                }
                field("Qty. on Component Lines"; "Qty. on Component Lines")
                {
                }
                field("Released Qty. on Prod. Order"; "Released Qty. on Prod. Order")
                {
                }
                field("Firm Plan. Qty. on Prod. Order"; "Firm Plan. Qty. on Prod. Order")
                {
                }
                field("Forecast Qty."; "Forecast Qty.")
                {
                }
                field("Arch. Sales Order Qty."; "Arch. Sales Order Qty.")
                {
                }
                field("Unit Cost"; "Unit Cost")
                {
                }
                field("Last Direct Cost"; "Last Direct Cost")
                {
                }
            }
        }
        area(factboxes)
        {
            part(Control1901314507; "Item Invoicing FactBox")
            {
                SubPageLink = No.=FIELD(No.);
                    Visible = true;
            }
            part(Control1903326807; "Item Replenishment FactBox")
            {
                SubPageLink = No.=FIELD(No.);
                    Visible = false;
            }
            part(Control1906840407; "Item Planning FactBox")
            {
                SubPageLink = No.=FIELD(No.);
                    Visible = true;
            }
            part(Control1901796907; "Item Warehouse FactBox")
            {
                SubPageLink = No.=FIELD(No.);
                    Visible = false;
            }
            systempart(Control1900383207; Links)
            {
                Visible = true;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Action10)
            {
                Caption = '&Item';
                action(Action81)
                {
                    Caption = 'Stockkeepin&g Units';
                    RunObject = Page "Stockkeeping Unit List";
                    RunPageLink = Item No.=FIELD(No.);
                    RunPageView = SORTING(Item No.);
                }
                group(Action84)
                {
                    Caption = 'E&ntries';
                    action(Action14)
                    {
                        Caption = 'Ledger E&ntries';
                        Image = ItemLedger;
                        Promoted = false;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Item Ledger Entries";
                                        RunPageLink = Item No.=FIELD(No.);
                        RunPageView = SORTING(Item No.);
                        ShortCutKey = 'Ctrl+F7';
                    }
                    action(Action77)
                    {
                        Caption = '&Reservation Entries';
                        Image = ReservationLedger;
                        RunObject = Page "Reservation Entries";
                                        RunPageLink = Reservation Status=CONST(Reservation),Item No.=FIELD(No.);
                        RunPageView = SORTING(Item No.,Variant Code,Location Code,Reservation Status);
                    }
                    action(Action23)
                    {
                        Caption = '&Phys. Inventory Ledger Entries';
                        Image = PhysicalInventoryLedger;
                        RunObject = Page "Phys. Inventory Ledger Entries";
                                        RunPageLink = Item No.=FIELD(No.);
                        RunPageView = SORTING(Item No.);
                    }
                    action(Action5800)
                    {
                        Caption = '&Value Entries';
                        Image = ValueLedger;
                        RunObject = Page "Value Entries";
                                        RunPageLink = Item No.=FIELD(No.);
                        RunPageView = SORTING(Item No.);
                    }
                    action(Action6500)
                    {
                        Caption = 'Item &Tracking Entries';
                        Image = ItemTrackingLedger;

                        trigger OnAction()
                        var
                            ItemTrackingMgt: Codeunit "Item Tracking Management";
                        begin
                            ItemTrackingMgt.CallItemTrackingEntryForm(3,'',"No.",'','','','');
                        end;
                    }
                }
                group(Action85)
                {
                    Caption = 'Statistics';
                    action(Action16)
                    {
                        Caption = 'Statistics';
                        Image = PayrollStatistics;
                        Promoted = true;
                        PromotedCategory = Process;
                        ShortCutKey = 'F7';

                        trigger OnAction()
                        begin
                            ItemStatistics.SetItem(Rec);
                            ItemStatistics.RUNMODAL;
                        end;
                    }
                    action(Action17)
                    {
                        Caption = 'Entry Statistics';
                        RunObject = Page "Item Entry Statistics";
                                        RunPageLink = No.=FIELD(No.),Date Filter=FIELD(Date Filter),Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),Location Filter=FIELD(Location Filter),Drop Shipment Filter=FIELD(Drop Shipment Filter),Variant Filter=FIELD(Variant Filter);
                    }
                    action(Action22)
                    {
                        Caption = 'T&urnover';
                        RunObject = Page "Item Turnover";
                                        RunPageLink = No.=FIELD(No.),Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),Location Filter=FIELD(Location Filter),Drop Shipment Filter=FIELD(Drop Shipment Filter),Variant Filter=FIELD(Variant Filter);
                    }
                }
                action(Action73)
                {
                    Caption = 'Items b&y Location';
                    Image = ItemAvailbyLoc;

                    trigger OnAction()
                    begin
                        ItemsByLocation.SETRECORD(Rec);
                        ItemsByLocation.RUN;
                    end;
                }
                group(Action79)
                {
                    Caption = '&Item Availability by';
                    action(Action21)
                    {
                        Caption = 'Period';
                        RunObject = Page "Item Availability by Periods";
                                        RunPageLink = No.=FIELD(No.),Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),Location Filter=FIELD(Location Filter),Drop Shipment Filter=FIELD(Drop Shipment Filter),Variant Filter=FIELD(Variant Filter);
                    }
                    action(Action80)
                    {
                        Caption = 'Variant';
                        RunObject = Page "Item Availability by Variant";
                                        RunPageLink = No.=FIELD(No.),Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),Location Filter=FIELD(Location Filter),Drop Shipment Filter=FIELD(Drop Shipment Filter),Variant Filter=FIELD(Variant Filter);
                    }
                    action(Action78)
                    {
                        Caption = 'Location';
                        RunObject = Page "Item Availability by Location";
                                        RunPageLink = No.=FIELD(No.),Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),Location Filter=FIELD(Location Filter),Drop Shipment Filter=FIELD(Drop Shipment Filter),Variant Filter=FIELD(Variant Filter);
                    }
                }
                action(Action116)
                {
                    Caption = '&Bin Contents';
                    Image = BinContent;
                    RunObject = Page "Item Bin Contents";
                                    RunPageLink = Item No.=FIELD(No.);
                    RunPageView = SORTING(Item No.);
                }
                action(Action15)
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                                    RunPageLink = Table Name=CONST(Item),No.=FIELD(No.);
                }
                group(Action94)
                {
                    Caption = 'Dimensions';
                    action(Action184)
                    {
                        Caption = 'Dimensions-Single';
                        RunObject = Page "Default Dimensions";
                                        RunPageLink = Table ID=CONST(27),No.=FIELD(No.);
                        ShortCutKey = 'Shift+Ctrl+D';
                    }
                    action(Action93)
                    {
                        Caption = 'Dimensions-&Multiple';

                        trigger OnAction()
                        var
                            Item: Record Item;
                        begin
                            CurrPage.SETSELECTIONFILTER(Item);
                            DefaultDimMultiple.SetMultiItem(Item);
                            DefaultDimMultiple.RUNMODAL;
                        end;
                    }
                }
                action(Action20)
                {
                    Caption = '&Picture';
                    RunObject = Page "Item Picture";
                                    RunPageLink = No.=FIELD(No.),Date Filter=FIELD(Date Filter),Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),Location Filter=FIELD(Location Filter),Drop Shipment Filter=FIELD(Drop Shipment Filter),Variant Filter=FIELD(Variant Filter);
                }
                separator(Action24)
                {
                }
                action(Action25)
                {
                    Caption = '&Units of Measure';
                    RunObject = Page "Item Units of Measure";
                                    RunPageLink = Item No.=FIELD(No.);
                }
                action(Action30)
                {
                    Caption = 'Va&riants';
                    RunObject = Page "Item Variants";
                                    RunPageLink = Item No.=FIELD(No.);
                }
                action(Action82)
                {
                    Caption = 'Cross Re&ferences';
                    RunObject = Page "Item Cross Reference Entries";
                                    RunPageLink = Item No.=FIELD(No.);
                }
                action(Action500)
                {
                    Caption = 'Substituti&ons';
                    RunObject = Page "Item Substitution Entry";
                                    RunPageLink = Type=CONST(Item),No.=FIELD(No.);
                }
                action(Action76)
                {
                    Caption = 'Nonstoc&k Items';
                    RunObject = Page "Nonstock Item List";
                }
                action("<Action1100267006>")
                {
                    Caption = 'Possible Items';
                    Image = SplitChecks;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Possible Items List";
                                    RunPageLink = Item Code=FIELD(No.);
                }
                action("<Action1100267009>")
                {
                    Caption = 'Possible Items Export';
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        CduLConnectorOSYSParseData: Codeunit "Connector OSYS Parse Data";
                    begin
                        //>>FE_LAPRIERRETTE_GP0004.001
                        CLEAR(CduLConnectorOSYSParseData);
                        CduLConnectorOSYSParseData.FctExportItemsPossibleManual("No.");
                        //<<FE_LAPRIERRETTE_GP0004.001
                    end;
                }
                action(Action1100267004)
                {
                    Caption = '"Phantoms" Items';
                    Image = SplitChecks;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Phantom subs. Items List";
                                    RunPageLink = Phantom Item No.=FIELD(No.);
                }
                separator(Action26)
                {
                }
                action(Action27)
                {
                    Caption = 'Translations';
                    RunObject = Page "Item Translations";
                                    RunPageLink = Item No.=FIELD(No.),Variant Code=CONST();
                }
                action(Action28)
                {
                    Caption = 'E&xtended Texts';
                    RunObject = Page "Extended Text List";
                                    RunPageLink = Table Name=CONST(Item),No.=FIELD(No.);
                    RunPageView = SORTING(Table Name,No.,Language Code,All Language Codes,Starting Date,Ending Date);
                }
                separator(Action31)
                {
                }
                group(Action29)
                {
                    Caption = 'Assembly &List';
                    action(Action32)
                    {
                        Caption = 'Bill of Materials';
                        RunObject = Page "Bill of Materials";
                                        RunPageLink = Parent Item No.=FIELD(No.);
                    }
                    action(Action49)
                    {
                        Caption = 'Where-Used List';
                        RunObject = Page "Where-Used List";
                                        RunPageLink = Type=CONST(Item),No.=FIELD(No.);
                        RunPageView = SORTING(Type,No.);
                    }
                    action(Action50)
                    {
                        Caption = 'Calc. Stan&dard Cost';

                        trigger OnAction()
                        begin
                            CalculateStdCost.CalcItem("No.",TRUE);
                        end;
                    }
                }
                group(Action86)
                {
                    Caption = 'Manuf&acturing';
                    action(Action87)
                    {
                        Caption = 'Where-Used';

                        trigger OnAction()
                        begin
                            ProdBOMWhereUsed.SetItem(Rec,WORKDATE);
                            ProdBOMWhereUsed.RUNMODAL;
                        end;
                    }
                    action(Action88)
                    {
                        Caption = 'Calc. Stan&dard Cost';

                        trigger OnAction()
                        begin
                            CalculateStdCost.CalcItem("No.",FALSE);
                        end;
                    }
                }
                separator(Action83)
                {
                    Caption = '';
                }
                action(Action103)
                {
                    Caption = 'Ser&vice Items';
                    RunObject = Page "Service Items";
                                    RunPageLink = Item No.=FIELD(No.);
                    RunPageView = SORTING(Item No.);
                }
                action(Action105)
                {
                    Caption = 'Troubleshooting';
                    RunObject = Page "Troubleshooting Setup";
                                    RunPageLink = Type=CONST(Item),No.=FIELD(No.);
                }
                group(Action107)
                {
                    Caption = 'R&esource';
                    action(Action108)
                    {
                        Caption = 'Resource &Skills';
                        RunObject = Page "Resource Skills";
                                        RunPageLink = Type=CONST(Item),No.=FIELD(No.);
                    }
                    action(Action109)
                    {
                        Caption = 'Skilled R&esources';

                        trigger OnAction()
                        var
                            ResourceSkill: Record "Resource Skill";
                        begin
                            CLEAR(SkilledResourceList);
                            SkilledResourceList.Initialize(ResourceSkill.Type::Item,"No.",Description);
                            SkilledResourceList.RUNMODAL;
                        end;
                    }
                }
                separator(Action120)
                {
                }
                action(Action121)
                {
                    Caption = 'Identifiers';
                    RunObject = Page "Item Identifiers";
                                    RunPageLink = Item No.=FIELD(No.);
                    RunPageView = SORTING(Item No.,Variant Code,Unit of Measure Code);
                }
            }
            group(Action33)
            {
                Caption = 'S&ales';
                action(Action36)
                {
                    Caption = 'Prices';
                    Image = ResourcePrice;
                    RunObject = Page "Sales Prices";
                                    RunPageLink = Item No.=FIELD(No.);
                    RunPageView = SORTING(Item No.);
                }
                action(Action34)
                {
                    Caption = 'Line Discounts';
                    RunObject = Page "Sales Line Discounts";
                                    RunPageLink = Type=CONST(Item),Code=FIELD(No.);
                    RunPageView = SORTING(Type,Code);
                }
                action(Action124)
                {
                    Caption = 'Prepa&yment Percentages';
                    RunObject = Page "Sales Prepayment Percentages";
                                    RunPageLink = Item No.=FIELD(No.);
                }
                action(Action37)
                {
                    Caption = 'Orders';
                    Image = Document;
                    RunObject = Page "Sales Orders";
                                    RunPageLink = Type=CONST(Item),No.=FIELD(No.);
                    RunPageView = SORTING(Document Type,Type,No.);
                }
                action(Action114)
                {
                    Caption = 'Returns Orders';
                    RunObject = Page "Sales Return Orders";
                                    RunPageLink = Type=CONST(Item),No.=FIELD(No.);
                    RunPageView = SORTING(Document Type,Type,No.);
                }
            }
            group(Action38)
            {
                Caption = '&Purchases';
                action(Action118)
                {
                    Caption = 'Ven&dors';
                    RunObject = Page "Item Vendor Catalog";
                                    RunPageLink = Item No.=FIELD(No.);
                    RunPageView = SORTING(Item No.);
                }
                action(Action39)
                {
                    Caption = 'Prices';
                    Image = ResourcePrice;
                    RunObject = Page "Purchase Prices";
                                    RunPageLink = Item No.=FIELD(No.);
                    RunPageView = SORTING(Item No.);
                }
                action(Action42)
                {
                    Caption = 'Line Discounts';
                    RunObject = Page "Purchase Line Discounts";
                                    RunPageLink = Item No.=FIELD(No.);
                    RunPageView = SORTING(Item No.);
                }
                action(Action125)
                {
                    Caption = 'Prepa&yment Percentages';
                    RunObject = Page "Purchase Prepmt. Percentages";
                                    RunPageLink = Item No.=FIELD(No.);
                }
                separator(Action117)
                {
                }
                action(Action40)
                {
                    Caption = 'Orders';
                    Image = Document;
                    RunObject = Page "Purchase Orders";
                                    RunPageLink = Type=CONST(Item),No.=FIELD(No.);
                    RunPageView = SORTING(Document Type,Type,No.);
                }
                action(Action115)
                {
                    Caption = 'Return Orders';
                    Image = ReturnOrder;
                    RunObject = Page "Purchase Return Orders";
                                    RunPageLink = Type=CONST(Item),No.=FIELD(No.);
                    RunPageView = SORTING(Document Type,Type,No.);
                }
            }
        }
        area(processing)
        {
            group(Action110)
            {
                Caption = 'F&unctions';
                action(Action111)
                {
                    Caption = '&Create Stockkeeping Unit';

                    trigger OnAction()
                    var
                        Item: Record Item;
                    begin
                        Item.SETRANGE("No.","No.");
                        REPORT.RUNMODAL(REPORT::"Create Stockkeeping Unit",TRUE,FALSE,Item);
                    end;
                }
                action(Action7380)
                {
                    Caption = 'C&alculate Counting Period';

                    trigger OnAction()
                    var
                        PhysInvtCountMgt: Codeunit "Phys. Invt. Count.-Management";
                    begin
                        PhysInvtCountMgt.UpdateItemPhysInvtCount(Rec);
                    end;
                }
                action(Action1000000)
                {
                    Caption = 'C&opy Item';

                    trigger OnAction()
                    var
                        CopyItem: Report "Item Copy";
                                      ReturnItem: Record Item;
                    begin
                        // dach1140.begin
                        CopyItem.ItemDef(Rec);
                        CopyItem.RUNMODAL;
                        IF CopyItem.ItemReturn(ReturnItem) THEN
                          IF CONFIRM(Text11500,TRUE) THEN
                            Rec := ReturnItem;
                        // dach1140.end
                    end;
                }
            }
            action(Action1901240604)
            {
                Caption = 'Sales Prices';
                Image = SalesPrices;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Sales Prices";
                                RunPageLink = Item No.=FIELD(No.);
                RunPageView = SORTING(Item No.);
            }
            action(Action1900869004)
            {
                Caption = 'Sales Line Discounts';
                Image = SalesLineDisc;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Sales Line Discounts";
                                RunPageLink = Type=CONST(Item),Code=FIELD(No.);
                RunPageView = SORTING(Type,Code);
            }
            action(Action1905370404)
            {
                Caption = 'Requisition Worksheet';
                Image = Worksheet;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Req. Worksheet";
            }
            action(Action1904344904)
            {
                Caption = 'Item Journal';
                Image = Journals;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Item Journal";
            }
            action(Action1906716204)
            {
                Caption = 'Item Reclassification Journal';
                Image = Journals;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Item Reclass. Journal";
            }
            action(Action1902532604)
            {
                Caption = 'Item Tracing';
                Image = ItemTracing;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Item Tracing";
            }
            action(Action1900805004)
            {
                Caption = 'Adjust Item Cost/Price';
                Image = AdjustItemCost;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Report Report794;
            }
            action(Action1907108104)
            {
                Caption = 'Adjust Cost - Item Entries';
                Image = AdjustEntries;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Report Report795;
            }
        }
        area(reporting)
        {
            action(Action1900907306)
            {
                Caption = 'Inventory - List';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Inventory - List";
            }
            action(Action1907629906)
            {
                Caption = 'Item Register - Quantity';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Item Register - Quantity";
            }
            action(Action1904068306)
            {
                Caption = 'Inventory - Transaction Detail';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Inventory - Transaction Detail";
            }
            action(Action1901091106)
            {
                Caption = 'Inventory Availability';
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Inventory Availability";
            }
            action(Action1901254106)
            {
                Caption = 'Status';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report Status;
            }
            action(Action1900649906)
            {
                Caption = 'Inventory Value List';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Inventory Value";
            }
            action(Action1906212206)
            {
                Caption = 'Inventory - Availability Plan';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Inventory - Availability Plan";
            }
            action(Action1905771206)
            {
                Caption = 'Item Sales Lines';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "SR Item Sales Lines";
            }
            action(Action1906265806)
            {
                Caption = 'Item Purchase Lines';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "SR Item Purchase Lines";
            }
            action(Action1907930606)
            {
                Caption = 'Inventory - Top 10 List';
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Inventory - Top 10 List";
            }
            action(Action1901981306)
            {
                Caption = 'Item Statistic Period Comparison';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "SR Item Stat. Period Comp.";
            }
            action(Action1900762706)
            {
                Caption = 'Inventory - Sales Statistics';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Inventory - Sales Statistics";
            }
            action(Action1904034006)
            {
                Caption = 'Inventory - Customer Sales';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Inventory - Customer Sales";
            }
            action(Action1906231806)
            {
                Caption = 'Inventory - Vendor Purchases';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Inventory - Vendor Purchases";
            }
            action(Action1905572506)
            {
                Caption = 'Price List';
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report Report11579;
            }
            action(Action1900128906)
            {
                Caption = 'Inventory Cost and Price List';
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Inventory Cost and Price List";
            }
            action(Action1906101206)
            {
                Caption = 'Inventory - Reorders';
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report Report717;
            }
            action(Action1900210306)
            {
                Caption = 'Inventory - Sales Back Orders';
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Inventory - Sales Back Orders";
            }
            action(Action1900430206)
            {
                Caption = 'Item/Vendor Catalog';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Item/Vendor Catalog";
            }
            action(Action1900730006)
            {
                Caption = 'Inventory - Cost Variance';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Inventory - Cost Variance";
            }
            action(Action1907644006)
            {
                Caption = 'Phys. Inventory List';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Phys. Inventory List";
            }
            action(Action1906316306)
            {
                Caption = 'Inventory Valuation';
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Inventory Valuation";
            }
            action(Action1907253406)
            {
                Caption = 'Nonstock Item Sales';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Nonstock Item Sales";
            }
            action(Action1905753506)
            {
                Caption = 'Item Substitutions';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Item Substitutions";
            }
            action(Action1904299906)
            {
                Caption = 'Invt. Valuation - Cost Spec.';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Invt. Valuation - Cost Spec.";
            }
            action(Action1907928706)
            {
                Caption = 'Inventory Valuation - WIP';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Inventory Valuation - WIP";
            }
            action(Action1902962906)
            {
                Caption = 'Item Register - Value';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Item Register - Value";
            }
            action(Action1900461506)
            {
                Caption = 'Item Charges - Specification';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Item Charges - Specification";
            }
            action(Action1900111206)
            {
                Caption = 'Item Age Composition - Qty.';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Item Age Composition - Qty.";
            }
            action(Action1903496006)
            {
                Caption = 'Item Age Composition - Value';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Item Age Composition - Value";
            }
            action(Action1906747006)
            {
                Caption = 'Item Expiration - Quantity';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Item Expiration - Quantity";
            }
            action(Action1905889606)
            {
                Caption = 'Cost Shares Breakdown';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Cost Shares Breakdown";
            }
            action(Action1901374406)
            {
                Caption = 'Detailed Calculation';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Detailed Calculation";
            }
            action(Action1900812706)
            {
                Caption = 'Rolled-up Cost Shares';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Rolled-up Cost Shares";
            }
            action(Action1901316306)
            {
                Caption = 'Single-Level Cost Shares';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Single-level Cost Shares";
            }
            action(Action1902353206)
            {
                Caption = 'Where Used (Top Level)';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Where-Used (Top Level)";
            }
            action(Action1907778006)
            {
                Caption = 'Quantity Explosion of BOM';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Quantity Explosion of BOM";
            }
            action(Action1907846806)
            {
                Caption = 'Compare List';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Compare List";
            }
        }
    }

    var
        TblshtgHeader: Record "Troubleshooting Header";
        CalculateStdCost: Codeunit "Calculate Standard Cost";
        Text11500: Label 'Do you want to edit the new item?';


    procedure GetSelectionFilter(): Code[80]
    var
        Item: Record Item;
        FirstItem: Code[30];
        LastItem: Code[30];
        SelectionFilter: Code[250];
        ItemCount: Integer;
        More: Boolean;
    begin
        CurrPage.SETSELECTIONFILTER(Item);
        ItemCount := Item.COUNT;
        IF ItemCount > 0 THEN BEGIN
          Item.FIND('-');
          WHILE ItemCount > 0 DO BEGIN
            ItemCount := ItemCount - 1;
            Item.MARKEDONLY(FALSE);
            FirstItem := Item."No.";
            LastItem := FirstItem;
            More := (ItemCount > 0);
            WHILE More DO
              IF Item.NEXT = 0 THEN
                More := FALSE
              ELSE
                IF NOT Item.MARK THEN
                  More := FALSE
                ELSE BEGIN
                  LastItem := Item."No.";
                  ItemCount := ItemCount - 1;
                  IF ItemCount = 0 THEN
                    More := FALSE;
                END;
            IF SelectionFilter <> '' THEN
              SelectionFilter := SelectionFilter + '|';
            IF FirstItem = LastItem THEN
              SelectionFilter := SelectionFilter + FirstItem
            ELSE
              SelectionFilter := SelectionFilter + FirstItem + '..' + LastItem;
            IF ItemCount > 0 THEN BEGIN
              Item.MARKEDONLY(TRUE);
              Item.NEXT;
            END;
          END;
        END;
        EXIT(SelectionFilter);
    end;


    procedure SetSelection(var Item: Record Item)
    begin
        CurrPage.SETSELECTIONFILTER(Item);
    end;
}

