pageextension 50114 pageextension50114 extends "Firm Planned Prod. Orders"
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
        }
        addafter("Control 65")
        {
            field(Delay; Delay)
            {
                ApplicationArea = All;
            }
            field(DatGHeureDeb; DatGHeureDeb)
            {
                Caption = 'Launch. Prod. Starting Date-Time';
                ApplicationArea = All;
            }
            field("Prod. Ending Date-Time"; "Prod. Ending Date-Time")
            {
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
            field("Source Material Vendor"; "Source Material Vendor")
            {
                ApplicationArea = All;
            }
            field("Component No."; "Component No.")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter("Action 32")
        {
            action("Item Card")
            {
                Caption = 'Item Card';
                RunFormLink = No.=                ApplicationArea = All;
FIELD(Source No.);
                RunObject = Page 30;
            }
            action("Prod. BOM Where-Used")
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
    }

    var
        BooGCompAvail: Boolean;
        DeCGCompQty: Decimal;
        DatGHeureDeb: DateTime;


    //Unsupported feature: Code Insertion on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //var
        //RecLRoutingLine: Record "5409";
        //CodLienGamme: Code[20];
        //BooLFound: Boolean;
    //begin
        /*
        //>>LAP.TDL.NICO
        FctSetIndicator;
        //<<LAP.TDL.NICO

        //>>LAP.TDL.NICO 23 06 2015
        DeCGCompQty := ComponentInv;
        //<<LAP.TDL.NICO 23 06 2015


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

