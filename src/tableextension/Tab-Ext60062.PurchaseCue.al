tableextension 60062 "PWD PurchaseCue" extends "Purchase Cue"
{
    fields
    {
        field(50000; "PWD To be approuved"; Integer)
        {
            CalcFormula = Count("Approval Entry" WHERE("Table ID" = CONST(38),
                                                        "Document Type" = CONST(Order),
                                                        Status = FILTER(Open),
                                                        "Approver ID" = FIELD("PWD UserID Filter")));
            Caption = 'To be approuved';
            FieldClass = FlowField;
        }
        field(50001; "PWD UserID Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
    }
}

