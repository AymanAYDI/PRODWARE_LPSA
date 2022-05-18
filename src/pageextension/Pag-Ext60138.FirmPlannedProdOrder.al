pageextension 60138 "PWD FirmPlannedProdOrder" extends "Firm Planned Prod. Order"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //PLAW11.0
    // FE_Merge: TO 23/01/2012:  Merge of pbjects Planner One
    //                          - Add Part "Planner One"
    // 
    // //>>LAP2.06
    // FE_LAPRIERRETTE_GP0003 : APA 16/05/13 Add Etat des manquants
    // 
    // //>>LAP.TDL.NICO
    // 19/11/2014 : Add Item Card and Where-Used Pages in "Action page"
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 24/10/2017 : DEMANDES DIVERSES
    //                   - Add Field Source Material Vendor
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    layout
    {

        addafter("Last Date Modified")
        {
            field("PWD Source Material Vendor"; Rec."PWD Source Material Vendor")
            {
                ApplicationArea = All;
            }
        }
        addafter("Bin Code")
        {
            field("PWD Transmitted Order No."; Rec."PWD Transmitted Order No.")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {


        addafter("Plannin&g")
        {
            action("PWD Action1100267004")
            {
                Caption = 'Item Card';
                RunObject = Page "Item Card";
                RunPageLink = "No." = FIELD("Source No.");
                ApplicationArea = All;
                Image = Item;
            }
            action("PWD Action1100267005")
            {
                Caption = 'Prod. BOM Where-Used';
                Image = ExchProdBOMItem;
                ApplicationArea = All;

                trigger OnAction()
                var
                    RecLItem: Record Item;
                    ProdBOMWhereUsed: Page "Prod. BOM Where-Used";
                begin
                    //>>LPSA.TDL.19112014
                    IF (Rec."Source Type" = Rec."Source Type"::Item) AND RecLItem.GET(Rec."Source No.") THEN BEGIN
                        ProdBOMWhereUsed.SetItem(RecLItem, WORKDATE());
                        ProdBOMWhereUsed.RUNMODAL();
                    END;
                    //<<LPSA.TDL.19112014
                end;
            }
        }
        addlast("&Print")
        {
            action("PWD Etat des manquants")
            {
                Caption = 'Etat des manquants';
                Ellipsis = true;
                Image = "Report";
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    RecLProdOrder: Record "Production Order";
                    RepLListMissing: Report "Prod. Order - List of missing";
                begin
                    CLEAR(RepLListMissing);
                    RecLProdOrder.SETRANGE(Status, Rec.Status);
                    RecLProdOrder.SETRANGE("No.", Rec."No.");
                    RepLListMissing.SETTABLEVIEW(RecLProdOrder);
                    RepLListMissing.RUNMODAL();
                end;
            }
        }
    }
}

