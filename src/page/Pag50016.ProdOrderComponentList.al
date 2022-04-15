page 50016 "PWD Prod. Order Component List"
{
    Editable = false;
    PageType = List;
    SourceTable = "Prod. Order Component";
    SourceTableView = SORTING(Status, "Prod. Order No.", "Prod. Order Line No.", "Line No.") WHERE(Status = FILTER("Firm Planned" | Released));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("RecGProdOrderLine.""Item No."""; RecGProdOrderLine."Item No.")
                {
                    Caption = 'Item No.';
                    ApplicationArea = All;
                }
                field("RecGProdOrderLine.Quantity"; RecGProdOrderLine.Quantity)
                {
                    Caption = 'Quantité à produire';
                    ApplicationArea = All;
                }
                field("Prod. Order No."; Rec."Prod. Order No.")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    Caption = 'Component No.';
                    ApplicationArea = All;
                }
                field("Expected Quantity"; Rec."Expected Quantity")
                {
                    ApplicationArea = All;
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        IF NOT RecGProdOrderLine.GET(Rec.Status, Rec."Prod. Order No.", Rec."Prod. Order Line No.") THEN
            RecGProdOrderLine.INIT();
    end;

    var
        RecGProdOrderLine: Record "Prod. Order Line";
}

