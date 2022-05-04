pageextension 60114 "PWD FirmPlannedProdOrders" extends "Firm Planned Prod. Orders"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP.TDL.NICO
    // 09/10/2014 : Add Indicator and Delay. Add function FctSetIndicator
    // 19/11/2014 : Add Item Card and Where-Used Pages in "Action page"
    // 23/06/2015 : Add "DeCGCompQty"
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 24/10/2017 : DEMANDES DIVERSES
    //                   - Add Field Source Material Vendor
    // 
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
        }
        addafter("Search Description")
        {
            field("PWD Delay"; "PWD Delay")
            {
                ApplicationArea = All;
            }
            field("PWD DatGHeureDeb"; DatGHeureDeb)
            {
                Caption = 'Launch. Prod. Starting Date-Time';
                ApplicationArea = All;
            }
            //TODO:The name 'PWD Prod. Ending Date-Time' does not exist in the current context
            // field("PWD Prod. Ending Date-Time"; "PWD Prod. Ending Date-Time")
            // {
            //     ApplicationArea = All;
            // }
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
            field("PWD Source Material Vendor"; "PWD Source Material Vendor")
            {
                ApplicationArea = All;
            }
            field("PWD Component No."; "PWD Component No.")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter(Statistics)
        {
            action("PWD Item Card")
            {
                Caption = 'Item Card';
                RunPageLink = "No." = FIELD("Source No.");
                RunObject = Page "Item Card";
                ApplicationArea = All;
            }
            action("PWD Prod. BOM Where-Used")
            {
                Caption = 'Prod. BOM Where-Used';
                ApplicationArea = All;
                trigger OnAction()
                var
                    RecLItem: Record Item;
                    ProdBOMWhereUsed: Page "Prod. BOM Where-Used";
                begin
                    //>>LPSA.TDL.19112014
                    IF ("Source Type" = "Source Type"::Item) AND RecLItem.GET("Source No.") THEN BEGIN
                        ProdBOMWhereUsed.SetItem(RecLItem, WORKDATE());
                        ProdBOMWhereUsed.RUNMODAL();
                    END;
                    //<<LPSA.TDL.19112014
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        RecLRoutingLine: Record "Prod. Order Routing Line";
        BooLFound: Boolean;
        CodLienGamme: Code[20];
    begin
        FctSetIndicator();
        DeCGCompQty := ComponentInv();
        CLEAR(DatGHeureDeb);
        CLEAR(BooLFound);
        CLEAR(CodLienGamme);
        RecLRoutingLine.RESET();
        RecLRoutingLine.SETRANGE(Status, Status);
        RecLRoutingLine.SETRANGE("Prod. Order No.", "No.");
        IF RecLRoutingLine.FINDSET() THEN
            REPEAT
                IF CodLienGamme <> '' THEN BEGIN
                    DatGHeureDeb := RecLRoutingLine."Starting Date-Time";
                    BooLFound := FALSE;
                END;
                CodLienGamme := RecLRoutingLine."Routing Link Code";
            UNTIL (RecLRoutingLine.NEXT() = 0) OR BooLFound;

    end;

    procedure FctSetIndicator()
    var
        RecLInfoCompany: Record "Company Information";
    begin
        RecLInfoCompany.GET();
        RecLInfoCompany.CALCFIELDS("PWD Picture_Negative", "PWD Picture_Positive");
        IF CheckComponentAvailabilty() THEN BEGIN
            "PWD Indicator" := RecLInfoCompany."PWD Picture_Negative";
            BooGCompAvail := FALSE;
        END ELSE BEGIN
            "PWD Indicator" := RecLInfoCompany."PWD Picture_Positive";
            BooGCompAvail := TRUE;
        END;
    end;

    var
        BooGCompAvail: Boolean;
        DatGHeureDeb: DateTime;
        DeCGCompQty: Decimal;
}

