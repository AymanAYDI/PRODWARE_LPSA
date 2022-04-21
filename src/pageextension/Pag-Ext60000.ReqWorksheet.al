pageextension 60000 "PWD ReqWorksheet" extends "Req. Worksheet"
{
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Planning Flexibility" := ' ';
    end;
}
