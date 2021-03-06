page 50028 "PWD Product Groups"
{
    Caption = 'Product Groups';
    DataCaptionFields = "Item Category Code";
    PageType = List;
    SourceTable = "PWD Product Group";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Item Category Code"; Rec."Item Category Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field("Warehouse Class Code"; Rec."Warehouse Class Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links)
            {
                Visible = false;
                ApplicationArea = All;
            }
            systempart(Notes; Notes)
            {
                Visible = false;
                ApplicationArea = All;
            }
        }
    }
    procedure GetSelectionFilter() SelectionFilter: Code[80]
    var
        ProductGroup: Record "PWD Product Group";
    begin
        //>>P24578_008.001
        CurrPage.SETSELECTIONFILTER(ProductGroup);
        ProductGroup.SETCURRENTKEY("Item Category Code", Code);
        IF ProductGroup.COUNT > 0 THEN BEGIN
            ProductGroup.FindFirst();
            SelectionFilter := ProductGroup.Code;
        END;
        EXIT(SelectionFilter);
        //<<P24578_008.001
    end;

}

