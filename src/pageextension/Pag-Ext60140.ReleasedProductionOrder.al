pageextension 60140 "PWD ReleasedProductionOrder" extends "Released Production Order"
{
    layout
    {
        addafter("Last Date Modified")
        {
            field("PWD Consumption Date"; Rec."PWD Consumption Date")
            {
                ApplicationArea = All;
            }
            field("PWD Source Material Vendor"; Rec."PWD Source Material Vendor")
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
                Image = Item;
            }
            action("PWD Action1100267005")
            {
                caption = 'Prod. BOM Where-Used';
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
        addafter("Re&plan")
        {
            action("PWD Action1100267002")
            {
                Caption = 'Resend to QUARTIS';
                ApplicationArea = All;
                Image = SendTo;
                trigger OnAction()
                begin
                    Rec.ResendProdOrdertoQuartis();
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
                    RecLProductionOrder: Record "Production Order";
                begin
                    //>>LAP2.12
                    RecLProductionOrder := Rec;
                    RecLProductionOrder.SETRECFILTER();
                    REPORT.RUN(Report::"PWD Tracking Card", TRUE, FALSE, RecLProductionOrder);
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
                var
                    DocumentAttach: Record "Document Attachment";
                begin
                    if Rec."Source Type" = Rec."Source Type"::Item then begin
                        DocumentAttach.SetRange("Table Id", 27);
                        DocumentAttach.SetRange("No.", Rec."Source No.");
                        if DocumentAttach.FindSet() then
                            repeat
                                Rec.FctPrintPDF(True, DocumentAttach);
                            until DocumentAttach.Next() = 0;
                    end;
                end;
            }
        }
    }
}
