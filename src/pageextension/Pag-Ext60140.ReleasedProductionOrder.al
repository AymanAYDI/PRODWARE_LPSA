pageextension 60140 "PWD ReleasedProductionOrder" extends "Released Production Order"
{
    layout
    {
        addafter("Last Date Modified")
        {
            field("PWD Consumption Date"; "PWD Consumption Date")
            {
                ApplicationArea = All;
            }
            field("PWD Source Material Vendor"; "PWD Source Material Vendor")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter(Planning)
        {
            action("PWD Action1100267004")
            {
                caption = 'Item Card';
                RunObject = Page "Item Card";
                RunPageLink = "No." = FIELD("Source No.");
                ApplicationArea = All;
            }
            action("PWD Action1100267005")
            {
                caption = 'Prod. BOM Where-Used';
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
        addafter("Re&plan")
        {
            action("PWD Action1100267002")
            {
                Caption = 'Resend to QUARTIS';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    ResendProdOrdertoQuartis();
                end;
            }
        }
        addafter("&Print")
        {
            action("PWD PrintTrackingCard")
            {
                Ellipsis = true;
                caption = 'Tracking Card';
                Promoted = True;
                PromotedIsBig = True;
                Image = Report;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction()
                var
                    RecLProductionOrder: Record 5405;
                begin
                    //>>LAP2.12
                    RecLProductionOrder := Rec;
                    RecLProductionOrder.SETRECFILTER();
                    REPORT.RUN(50022, TRUE, FALSE, RecLProductionOrder);
                    //<<LAP2.12
                end;

            }
            action("PWD PrintPDF")
            {
                caption = 'Imprimer PDF des Plans';
                Promoted = true;
                PromotedIsBig = true;
                Image = Report;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    //>>REGIE
                    FctPrintPDF();
                    //<<REGIE
                end;
            }
        }
    }
}
