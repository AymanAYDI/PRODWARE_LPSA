pageextension 60000 "PWD ReqWorksheet" extends "Req. Worksheet"
{
    //TODO:
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Planning Flexibility" := Rec."Planning Flexibility"::None;
        //rec.Insert();
    end;
}
