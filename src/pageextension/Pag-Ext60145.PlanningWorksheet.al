pageextension 60145 "PWD PlanningWorksheet" extends "Planning Worksheet"
{
    //TODO: SourceTableView
    //SourceTableView=SORTING("Worksheet Template Name","Journal Batch Name","Starting Date","No.","Location Code");
    layout
    {
        addafter("Location Code")
        {
            field("PWD Vendor Item No."; Rec."Vendor Item No.")
            {
                ApplicationArea = All;

            }
        }
        addafter(Quantity)
        {
            field("PWD Order Multiple"; Rec."PWD Order Multiple")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter("Ro&uting")
        {
            action("PWD Action1100267003")
            {
                caption = 'Item Card';
                RunObject = Page "Item Card";
                RunPageLink = "No." = FIELD("No.");
                ApplicationArea = All;
                Image = Item;
            }
            action("PWD ProdBOMWhereUsed")
            {
                caption = 'Prod. BOM Where-Used';
                Image = ExchProdBOMItem;
                ApplicationArea = All;
                trigger OnAction()
                var
                    RecLItem: Record Item;
                    ProdBOMWhereUsed: Page "Prod. BOM Where-Used";
                begin
                    //>>LPSA.TDL.20102014
                    IF (Rec.Type = Rec.Type::Item) AND RecLItem.GET(Rec."No.") THEN BEGIN
                        ProdBOMWhereUsed.SetItem(RecLItem, WORKDATE());
                        ProdBOMWhereUsed.RUNMODAL();
                    END;
                    //<<LPSA.TDL.20102014

                end;
            }
            action("PWD Forecast")
            {
                caption = 'Forecast';
                Promoted = true;
                PromotedIsBig = true;
                Image = History;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction()
                var
                    RecLProductionForecastEntry: Record "Production Forecast Entry";
                    FrmLProductionForecastEntries: Page "Demand Forecast Entries";
                begin
                    //>>REGIE
                    IF Rec.Type = Rec.Type::Item THEN BEGIN
                        RecLProductionForecastEntry.SETRANGE("Item No.", Rec."No.");
                        RecLProductionForecastEntry.SETRANGE("Forecast Date", Rec."Starting Date", Rec."Ending Date");
                        FrmLProductionForecastEntries.SETTABLEVIEW(RecLProductionForecastEntry);
                        FrmLProductionForecastEntries.RUNMODAL();
                    END;
                    //<<REGIE
                end;
            }
        }
        addafter(OrderTracking)
        {
            action("PWD Action1100267001")
            {
                Caption = 'Tout Cocher';
                ApplicationArea = All;
                Image = Action;
                trigger OnAction()
                begin
                    // >> FE_LAPRIERRETTE_GP0003 : APA 16/05/13
                    Rec.MODIFYALL("Accept Action Message", TRUE);
                    // << FE_LAPRIERRETTE_GP0003 : APA 16/05/13  
                end;
            }
            action("PWD ToutDecocher")
            {
                Caption = 'Tout Decocher';
                ApplicationArea = All;
                Image = Action;
                trigger OnAction()
                begin
                    // >> FE_LAPRIERRETTE_GP0003 : APA 16/05/13
                    Rec.MODIFYALL("Accept Action Message", FALSE);
                    // << FE_LAPRIERRETTE_GP0003 : APA 16/05/13

                end;
            }
        }
    }
}
