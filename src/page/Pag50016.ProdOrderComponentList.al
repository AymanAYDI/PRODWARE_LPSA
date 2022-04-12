page 50016 "PWD Prod. Order Component List"
{
    Editable = false;
    PageType = List;
    SourceTable = "Prod. Order Component";
    SourceTableView = SORTING (Status, Prod. Order No., Prod. Order Line No., Line No.) WHERE (Status = FILTER (Firm Planned|Released));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("RecGProdOrderLine.""Item No."""; RecGProdOrderLine."Item No.")
                {
                    Caption = 'Item No.';
                }
                field("RecGProdOrderLine.Quantity"; RecGProdOrderLine.Quantity)
                {
                    Caption = 'Quantité à produire';
                }
                field("Prod. Order No."; "Prod. Order No.")
                {
                }
                field(Status; Status)
                {
                }
                field("Item No."; "Item No.")
                {
                    Caption = 'Component No.';
                }
                field("Expected Quantity"; "Expected Quantity")
                {
                }
                field("Remaining Quantity"; "Remaining Quantity")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        IF NOT RecGProdOrderLine.GET(Status, "Prod. Order No.", "Prod. Order Line No.") THEN
            RecGProdOrderLine.INIT;
    end;

    var
        RecGProdOrderLine: Record "Prod. Order Line";
}

