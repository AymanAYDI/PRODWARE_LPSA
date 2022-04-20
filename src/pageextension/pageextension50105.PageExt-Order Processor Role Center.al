pageextension 50105 pageextension50105 extends "Order Processor Role Center"
{
    actions
    {
        addafter("Action 24")
        {
            separator()
            {
            }
            action("test export xcell")
            {
                Caption = 'test export xcell';
                RunObject = Report 50072;
                ApplicationArea = All;
            }
            action("Export Invoicing data")
            {
                Caption = 'Export Invoicing data';
                RunObject = Report 50000;
                ApplicationArea = All;
            }
        }
    }
}

