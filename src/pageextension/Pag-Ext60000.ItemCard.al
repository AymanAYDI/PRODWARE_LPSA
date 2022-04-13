pageextension 60000 "PWD ItemCard" extends "Item Card"
{
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Costing Method" := Rec."Costing Method"::Average;
    end;
}
