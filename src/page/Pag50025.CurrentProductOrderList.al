page 50025 "PWD Current Product Order List"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.13
    //  RO : 07/11/2017 : Nouvelles demandes
    //                   - new Page

    Caption = 'Current Product Order List';
    Editable = false;
    PageType = List;
    SourceTable = "PWD Current Product Order";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("PO No."; Rec."PO No.")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Description LPSA1"; Rec."Description LPSA1")
                {
                    ApplicationArea = All;
                }
                field("Description LPSA2"; Rec."Description LPSA2")
                {
                    ApplicationArea = All;
                }
                field("Last Ended Operation"; Rec."Last Ended Operation")
                {
                    ApplicationArea = All;
                }
                field("Center Description"; Rec."Center Description")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        RecGProductionOrder.SETFILTER(Status, '<>%1', RecGProductionOrder.Status::Finished);
        RecGProductionOrder.SETRANGE("Location Code", 'PIE');
        IntGCounter := RecGProductionOrder.COUNT;
        Bdialog.OPEN(CstG001);
        IF RecGProductionOrder.FINDFIRST THEN
            REPEAT
                Bdialog.UPDATE(1, IntGCounter);
                IntGCounter -= 1;
                RecGProdOrderLine.RESET;
                RecGProdOrderLine.SETRANGE(Status, RecGProductionOrder.Status);
                RecGProdOrderLine.SETRANGE("Prod. Order No.", RecGProductionOrder."No.");
                IF RecGProdOrderLine.FINDFIRST THEN
                    REPEAT
                        RecGProdOrderRoutingLine.RESET;
                        RecGProdOrderRoutingLine.SETRANGE(Status, RecGProdOrderLine.Status);
                        RecGProdOrderRoutingLine.SETRANGE("Prod. Order No.", RecGProdOrderLine."Prod. Order No.");
                        RecGProdOrderRoutingLine.SETRANGE("Routing Reference No.", RecGProdOrderLine."Routing Reference No.");
                        RecGProdOrderRoutingLine.SETRANGE("Routing No.", RecGProdOrderLine."Routing No.");
                        RecGProdOrderRoutingLine.SETRANGE("Routing Status", RecGProdOrderRoutingLine."Routing Status"::Finished);
                        IF RecGProdOrderRoutingLine.FINDLAST THEN BEGIN
                            Status := RecGProductionOrder.Status;
                            "PO No." := RecGProductionOrder."No.";
                            "Item No." := RecGProductionOrder."Source No.";
                            "Last Ended Operation" := RecGProdOrderRoutingLine."No.";
                            "Center Description" := RecGProdOrderRoutingLine.Description;
                            Quantity := RecGProdOrderRoutingLine."Input Quantity";
                            RecGItem.GET(RecGProductionOrder."Source No.");
                            "Description LPSA1" := RecGItem."PWD LPSA Description 1";
                            "Description LPSA2" := RecGItem."PWD LPSA Description 2";
                            INSERT;
                        END;
                    UNTIL RecGProdOrderLine.NEXT = 0;
            UNTIL RecGProductionOrder.NEXT = 0;
        Bdialog.CLOSE
    end;

    var
        RecGProductionOrder: Record "Production Order";
        RecGProdOrderLine: Record "Prod. Order Line";
        RecGProdOrderRoutingLine: Record "Prod. Order Routing Line";
        RecGItem: Record Item;
        TxtGDescriptionLPSA1: Text[120];
        TxtGDescriptionLPSA2: Text[120];
        Bdialog: Dialog;
        IntGCounter: Integer;
        CstG001: Label 'List creation \Compte backwards #1######################';
}

