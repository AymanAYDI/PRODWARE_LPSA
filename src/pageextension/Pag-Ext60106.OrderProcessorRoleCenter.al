pageextension 60106 "PWD OrderProcessorRoleCenter" extends "Order Processor Role Center"
{
    actions
    {
        addafter("Inventory - Sales &Back Orders")
        {
            action("PWD test export xcell")
            {
                Caption = 'test export xcell';
                RunObject = Report "Liste des Clients (Excel)";
                ApplicationArea = All;
            }
            action("PWD Export Invoicing data")
            {
                Caption = 'Export Invoicing data';
                RunObject = Report "Export Invoicing Data (Excel)";
                ApplicationArea = All;
            }
        }
    }
}

