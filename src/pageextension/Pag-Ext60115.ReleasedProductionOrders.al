pageextension 60115 "PWD ReleasedProductionOrders" extends "Released Production Orders"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP.TDL.NICO
    // 07/04/2014 : Add fields 50004, 50005
    // 07/04/2014 : Add function ResendProdOrdertoQuartis  in MEnuItem Function
    // 09/10/2014 : Add "PWD Indicator" and Delay. Add function FctSetIndicator
    // 19/11/2014 : Add Item Card and Where-Used Pages in "Action page"
    // 19/02/2015 : Add "Consumption Date"
    // 23/06/2015 : Add "DeCGCompQty"
    // 
    // //>>LAP090615
    // TO 09/06/15:Add fields
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 12/09/2017 : DEMANDES DIVERSES
    //                   - Add Field Source Material Vendor
    // 
    // ------------------------------------------------------------------------------------------------------------------
    layout
    {
        addafter(Description)
        {
            field("PWD Indicator"; "PWD Indicator")
            {
                ApplicationArea = All;
            }
            field("PWD BooGCompAvail"; BooGCompAvail)
            {
                Caption = 'Component availability (boolean)';
                ApplicationArea = All;
            }
            field("PWD DeCGCompQty"; DeCGCompQty)
            {
                Caption = 'Components Inv. Qty.';
                ApplicationArea = All;
            }
            field("PWD Source Material Vendor"; "PWD Source Material Vendor")
            {
                ApplicationArea = All;
            }
        }
        addbefore("Due Date")
        {
            field("PWD DatGHeureDeb"; DatGHeureDeb)
            {
                Caption = 'Prod. Starting Date-Time';
                ApplicationArea = All;
            }
            field("PWD Prod. Ending Date-Time"; "PWD Prod. Ending Date-Time")
            {
                ApplicationArea = All;
            }
            field("PWD Delay"; "PWD Delay")
            {
                ApplicationArea = All;
            }
            field("PWD BooGStarted"; BooGStarted)
            {
                Caption = 'Prod. order Started';
                ApplicationArea = All;
            }
        }
        addafter("Bin Code")
        {
            field("PWD Order Multiple"; "PWD Order Multiple")
            {
                ApplicationArea = All;
            }
            field("PWD Component Quantity"; "PWD Component Quantity")
            {
                ApplicationArea = All;
            }
            field("PWD Consumption Date"; "PWD Consumption Date")
            {
                ApplicationArea = All;
            }
            field("PWD DateGCapacityPostingDate"; DateGCapacityPostingDate)
            {
                Caption = 'Capacity Ledg. Entry Posting date';
                ApplicationArea = All;
            }
            field("PWD TxtGCapacityDescription"; TxtGCapacityDescription)
            {
                Caption = 'Capacity Ledg. Entry Description';
                ApplicationArea = All;
            }
            field("PWD DecGImputQty"; DecGImputQty)
            {
                Caption = 'Routing line Imput Qty';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter(Statistics)
        {
            action("PWD Action1100267004")
            {
                Caption = 'Item Card';
                RunPageLink = "No." = FIELD("Source No.");
                RunObject = Page "Item Card";
                ApplicationArea = All;
            }
            action("PWD Action1100267005")
            {
                Caption = 'Prod. BOM Where-Used';
                ApplicationArea = All;
                trigger OnAction()
                var
                    Item: Record Item;
                    ProdBOMWhereUsed: Page "Prod. BOM Where-Used";
                begin
                    IF ("Source Type" = "Source Type"::Item) AND Item.GET("Source No.") THEN BEGIN
                        ProdBOMWhereUsed.SetItem(Item, WORKDATE());
                        ProdBOMWhereUsed.RUNMODAL();
                    END;
                end;
            }
        }
        addafter("Create Inventor&y Put-away/Pick/Movement")
        {
            action("PWD Resend to QUARTIS")
            {
                Caption = 'Resend to QUARTIS';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    ResendProdOrdertoQuartis();
                end;
            }
            group("<Action12>")
            {
                Caption = 'E&ntries';
                action("PWD Action13")
                {
                    Caption = 'Item Ledger E&ntries';
                    Image = ItemLedger;
                    RunPageLink = "Order No." = FIELD("No.");
                    RunPageView = SORTING("Order No.");
                    RunObject = Page "Item Ledger Entries";
                    ShortCutKey = 'Ctrl+F7';
                    ApplicationArea = All;
                }
                action("PWD Action27")
                {
                    Caption = 'Capacity Ledger Entries';
                    RunPageLink = "Order No." = FIELD("No.");
                    RunPageView = SORTING("Order No.");
                    RunObject = Page "Capacity Ledger Entries";
                    ApplicationArea = All;
                }
                action("PWD Action28")
                {
                    Caption = 'Value Entries';
                    Image = ValueLedger;
                    RunPageLink = "Order No." = FIELD("No.");
                    RunPageView = SORTING("Order No.");
                    RunObject = Page "Value Entries";
                    ApplicationArea = All;
                }
                action("PWD Action33")
                {
                    Caption = '&Warehouse Entries';
                    Image = BinLedger;
                    RunPageLink = "Source Type" = FILTER(83 | 5407),
                                  "Source Subtype" = FILTER(3 | 4 | 5),
                                  "Source No." = FIELD("No.");
                    RunPageView = SORTING("Source Type", "Source Subtype", "Source No.");
                    RunObject = Page "Warehouse Entries";
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        CapcityLedger: Record "Capacity Ledger Entry";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        RoutingLine: Record "Prod. Order Routing Line";
        CodLienGamme: Code[20];
        BooLFound: Boolean;
    begin
        //>>LAP.TDL.NICO
        BooGStarted := isStarted();
        FctSetIndicator();
        //<<LAP.TDL.NICO

        //>>LAP.TDL.NICO 23 06 2015
        DeCGCompQty := ComponentInv();
        //<<LAP.TDL.NICO 23 06 2015

        //>>LAP090615
        CLEAR(DateGCapacityPostingDate);
        CLEAR(TxtGCapacityDescription);
        CLEAR(DecGImputQty);

        CapcityLedger.RESET();
        CapcityLedger.SETRANGE("Order No.", "No.");
        IF CapcityLedger.FINDLAST() THEN BEGIN
            DateGCapacityPostingDate := CapcityLedger."Posting Date";
            TxtGCapacityDescription := CapcityLedger.Description;

            ProdOrderLine.RESET();
            ProdOrderLine.SETRANGE(Status, Status);
            ProdOrderLine.SETRANGE("Prod. Order No.", "No.");
            IF ProdOrderLine.FINDFIRST() THEN BEGIN
                ProdOrderRoutingLine.RESET();
                ProdOrderRoutingLine.SETRANGE(Status, Status);
                ProdOrderRoutingLine.SETRANGE("Prod. Order No.", "No.");
                //First Line
                ProdOrderRoutingLine.SETRANGE("Routing Reference No.", ProdOrderLine."Line No.");
                ProdOrderRoutingLine.SETRANGE("Routing No.", "Routing No.");
                ProdOrderRoutingLine.SETRANGE("Operation No.", CapcityLedger."Operation No.");
                IF ProdOrderRoutingLine.FINDSET() THEN
                    DecGImputQty := ProdOrderRoutingLine."Input Quantity";
            END;
        END;
        //<<LAP090615

        CLEAR(DatGHeureDeb);
        CLEAR(BooLFound);
        CLEAR(CodLienGamme);
        RoutingLine.RESET();
        RoutingLine.SETRANGE(Status, Status);
        RoutingLine.SETRANGE("Prod. Order No.", "No.");
        IF RoutingLine.FINDSET() THEN
            REPEAT
                IF CodLienGamme <> '' THEN BEGIN
                    DatGHeureDeb := RoutingLine."Starting Date-Time";
                    BooLFound := FALSE;
                END;
                CodLienGamme := RoutingLine."Routing Link Code";
            UNTIL (RoutingLine.NEXT() = 0) OR BooLFound;

    end;


    procedure isStarted() Started: Boolean
    var
        Capcity: Record "Capacity Ledger Entry";
        BooLStarted: Boolean;
        PORL: Record "Prod. Order Routing Line";
    begin
        BooLStarted := FALSE;
        Capcity.SETRANGE("Order No.", "No.");
        Capcity.SETRANGE(Type, Capcity.Type::"Machine Center");
        IF Capcity.FINDFIRST() THEN
            REPEAT
                IF PORL.GET(
                  Status,
                  Capcity."Order No.",
                  Capcity."Order Line No.",
                  Capcity."Routing No.",
                  Capcity."Operation No.") AND (PORL."Routing Link Code" <> '') THEN
                    BooLStarted := TRUE;
            UNTIL (Capcity.NEXT() = 0) OR BooLStarted;

        EXIT(BooLStarted);
    end;

    procedure FctSetIndicator()
    var
        InfoCompany: Record "Company Information";
    begin
        InfoCompany.GET();
        InfoCompany.CALCFIELDS("PWD Picture_Negative", "PWD Picture_Positive");
        IF CheckComponentAvailabilty() THEN BEGIN
            "PWD Indicator" := InfoCompany."PWD Picture_Negative";
            BooGCompAvail := FALSE;
        END ELSE BEGIN
            "PWD Indicator" := InfoCompany."PWD Picture_Positive";
            BooGCompAvail := TRUE;
        END;
    end;

    var
        BooGStarted: Boolean;
        BooGCompAvail: Boolean;
        DateGCapacityPostingDate: Date;
        TxtGCapacityDescription: Text[50];
        DecGImputQty: Decimal;
        DeCGCompQty: Decimal;
        DatGHeureDeb: DateTime;
}

