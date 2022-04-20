pageextension 50115 pageextension50115 extends "Released Production Orders"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP.TDL.NICO
    // 07/04/2014 : Add fields 50004, 50005
    // 07/04/2014 : Add function ResendProdOrdertoQuartis  in MEnuItem Function
    // 09/10/2014 : Add Indicator and Delay. Add function FctSetIndicator
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
        addafter("Control 4")
        {
            field(Indicator; Indicator)
            {
                ApplicationArea = All;
            }
            field(BooGCompAvail; BooGCompAvail)
            {
                Caption = 'Component availability (boolean)';
                ApplicationArea = All;
            }
            field(DeCGCompQty; DeCGCompQty)
            {
                Caption = 'Components Inv. Qty.';
                ApplicationArea = All;
            }
            field("Source Material Vendor"; "Source Material Vendor")
            {
                ApplicationArea = All;
            }
        }
        addafter("Control 20")
        {
            field(DatGHeureDeb; DatGHeureDeb)
            {
                Caption = 'Prod. Starting Date-Time';
                ApplicationArea = All;
            }
            field("Prod. Ending Date-Time"; "Prod. Ending Date-Time")
            {
                ApplicationArea = All;
            }
            field(Delay; Delay)
            {
                ApplicationArea = All;
            }
            field(BooGStarted; BooGStarted)
            {
                Caption = 'Prod. order Started';
                ApplicationArea = All;
            }
        }
        addafter("Control 1102601002")
        {
            field("Order Multiple"; "Order Multiple")
            {
                ApplicationArea = All;
            }
            field("Component Quantity"; "Component Quantity")
            {
                ApplicationArea = All;
            }
            field("Consumption Date"; "Consumption Date")
            {
                ApplicationArea = All;
            }
            field(DateGCapacityPostingDate; DateGCapacityPostingDate)
            {
                Caption = 'Capacity Ledg. Entry Posting date';
                ApplicationArea = All;
            }
            field(TxtGCapacityDescription; TxtGCapacityDescription)
            {
                Caption = 'Capacity Ledg. Entry Description';
                ApplicationArea = All;
            }
            field(DecGImputQty; DecGImputQty)
            {
                Caption = 'Routing line Imput Qty';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter("Action 32")
        {
            action("<Action1100267004>")
            {
                Caption = 'Item Card';
                RunFormLink = No.=                ApplicationArea = All;
FIELD(Source No.);
                RunObject = Page 30;
            }
            action("<Action1100267005>")
            {
                Caption = 'Prod. BOM Where-Used';

                trigger OnAction()
                var
                    RecLItem: Record "27";
                    ProdBOMWhereUsed: Form "99000811";
                begin
                    //>>LPSA.TDL.19112014
                    IF ("Source Type"="Source Type"::Item) AND RecLItem.GET("Source No.") THEN BEGIN
                      ProdBOMWhereUsed.SetItem(RecLItem,WORKDATE);
                      ProdBOMWhereUsed.RUNMODAL;
                    END;
                    //<<LPSA.TDL.19112014
                end;
            }
        }
        addafter("Action 153")
        {
            action("Resend to QUARTIS")
            {
                Caption = 'Resend to QUARTIS';

                trigger OnAction()
                begin
                    ResendProdOrdertoQuartis;
                end;
            }
            group("<Action12>")
            {
                Caption = 'E&ntries';
                action("<Action13>")
                {
                    Caption = 'Item Ledger E&ntries';
                    Image = ItemLedger;
                    RunFormLink = Prod. Order No.=FIELD(No.);
                    RunFormView = SORTING(Prod. Order No.);
                    RunObject = Page 38;
                                    ShortCutKey = 'Ctrl+F7';
                }
                action("<Action27>")
                {
                    Caption = 'Capacity Ledger Entries';
                    RunFormLink = Prod. Order No.=FIELD(No.);
                    RunFormView = SORTING(Prod. Order No.);
                    RunObject = Page 5832;
                }
                action("<Action28>")
                {
                    Caption = 'Value Entries';
                    Image = ValueLedger;
                    RunFormLink = Prod. Order No.=FIELD(No.);
                    RunFormView = SORTING(Prod. Order No.);
                    RunObject = Page 5802;
                }
                action("<Action33>")
                {
                    Caption = '&Warehouse Entries';
                    Image = BinLedger;
                    RunFormLink = Source Type=FILTER(83|5407),
                                  Source Subtype=FILTER(3|4|5),
                                  Source No.=FIELD(No.);
                    RunFormView = SORTING(Source Type,Source Subtype,Source No.);
                    RunObject = Page 7318;
                }
            }
        }
    }

    var
        BooGStarted: Boolean;
        BooGCompAvail: Boolean;
        DateGCapacityPostingDate: Date;
        TxtGCapacityDescription: Text[50];
        DecGImputQty: Decimal;
        DeCGCompQty: Decimal;
        DatGHeureDeb: DateTime;


    //Unsupported feature: Code Insertion on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //var
        //RecLCapcityLedger: Record "5832";
        //RecLProdOrderLine: Record "5406";
        //RecLProdOrderRoutingLine: Record "5409";
        //RecLRoutingLine: Record "5409";
        //CodLienGamme: Code[20];
        //BooLFound: Boolean;
    //begin
        /*
        //>>LAP.TDL.NICO
        BooGStarted := isStarted;
        FctSetIndicator;
        //<<LAP.TDL.NICO

        //>>LAP.TDL.NICO 23 06 2015
        DeCGCompQty := ComponentInv;
        //<<LAP.TDL.NICO 23 06 2015

        //>>LAP090615
        CLEAR(DateGCapacityPostingDate);
        CLEAR(TxtGCapacityDescription);
        CLEAR(DecGImputQty);

        RecLCapcityLedger.RESET;
        RecLCapcityLedger.SETRANGE("Prod. Order No.","No.");
        IF RecLCapcityLedger.FINDLAST THEN BEGIN
          DateGCapacityPostingDate:=RecLCapcityLedger."Posting Date";
          TxtGCapacityDescription:=RecLCapcityLedger.Description;

          RecLProdOrderLine.RESET;
          RecLProdOrderLine.SETRANGE(Status,Status);
          RecLProdOrderLine.SETRANGE("Prod. Order No.","No.");
          IF RecLProdOrderLine.FINDFIRST THEN BEGIN
            RecLProdOrderRoutingLine.RESET;
            RecLProdOrderRoutingLine.SETRANGE(Status,Status);
            RecLProdOrderRoutingLine.SETRANGE("Prod. Order No.","No.");
            //First Line
            RecLProdOrderRoutingLine.SETRANGE("Routing Reference No.",RecLProdOrderLine."Line No.");
            RecLProdOrderRoutingLine.SETRANGE("Routing No.","Routing No.");
            RecLProdOrderRoutingLine.SETRANGE("Operation No.",RecLCapcityLedger."Operation No.");
            IF RecLProdOrderRoutingLine.FINDSET THEN
              DecGImputQty:=RecLProdOrderRoutingLine."Input Quantity";
          END;
        END;
        //<<LAP090615

        CLEAR(DatGHeureDeb);
        CLEAR(BooLFound);
        CLEAR(CodLienGamme);
        RecLRoutingLine.RESET;
        RecLRoutingLine.SETRANGE(Status,Status);
        RecLRoutingLine.SETRANGE("Prod. Order No.","No.");
        IF RecLRoutingLine.FINDSET THEN
          REPEAT
            IF CodLienGamme <> '' THEN BEGIN
              DatGHeureDeb := RecLRoutingLine."Starting Date-Time";
              BooLFound := FALSE;
            END;
            CodLienGamme := RecLRoutingLine."Routing Link Code";
          UNTIL (RecLRoutingLine.NEXT = 0) OR BooLFound;
        */
    //end;

    procedure "--- TDL.LPSA ---"()
    begin
    end;

    procedure isStarted() Started: Boolean
    var
        ReclCapcity: Record "5832";
        BooLStarted: Boolean;
        RecLPORL: Record "5409";
    begin
        BooLStarted := FALSE;
        ReclCapcity.SETRANGE("Prod. Order No.","No.");
        ReclCapcity.SETRANGE(Type,ReclCapcity.Type::"Machine Center");
        IF ReclCapcity.FINDFIRST THEN
          REPEAT
            IF RecLPORL.GET(
              Status,
              ReclCapcity."Prod. Order No.",
              ReclCapcity."Prod. Order Line No.",
              ReclCapcity."Routing No.",
              ReclCapcity."Operation No.") AND (RecLPORL."Routing Link Code" <> '') THEN
              BooLStarted := TRUE;
          UNTIL (ReclCapcity.NEXT =0) OR BooLStarted;

        EXIT(BooLStarted);
    end;

    procedure FctSetIndicator()
    var
        RecLInfoCompany: Record "79";
    begin
        RecLInfoCompany.GET;
        RecLInfoCompany.CALCFIELDS(Picture_Negative,Picture_Positive);
        IF CheckComponentAvailabilty THEN BEGIN
          Indicator := RecLInfoCompany.Picture_Negative;
          BooGCompAvail := FALSE;
        END ELSE BEGIN
          Indicator := RecLInfoCompany.Picture_Positive;
          BooGCompAvail := TRUE;
        END;
    end;
}

