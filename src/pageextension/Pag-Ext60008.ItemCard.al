pageextension 60008 "PWD ItemCard" extends "Item Card"
{
        trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Costing Method" := Rec."Costing Method"::Average;
    end;
}
