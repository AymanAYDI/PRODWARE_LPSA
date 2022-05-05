page 8073290 "PWD WMS Setup"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // //>>ProdConnect1.05
    // WMS-FE10.001:GR 29/06/2011   Connector integration
    //                              - Create Object
    // 
    // //>>ProdConnect1.6
    // OSYS-Int001.001:GR 18/10/2011   Connector integration
    //                                 - Add Field :  Partner Code
    // 
    // +----------------------------------------------------------------------------------------------------------------+

    Caption = 'WMS Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    UsageCategory = none;
    SourceTable = "PWD WMS Setup";

    layout
    {
        area(content)
        {
            group(Control1100294000)
            {
                Caption = 'General';
                ShowCaption = false;
                field(WMS; Rec.WMS)
                {
                    ApplicationArea = All;
                }
                field("Location Mandatory"; Rec."Location Mandatory")
                {
                    ApplicationArea = All;
                }
                field("WMS Company Code"; Rec."WMS Company Code")
                {
                    ApplicationArea = All;
                }
                field("WMS Delivery"; Rec."WMS Delivery")
                {
                    ApplicationArea = All;
                }
                field("WMS Shipment"; Rec."WMS Shipment")
                {
                    ApplicationArea = All;
                }
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                    ApplicationArea = All;
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ApplicationArea = All;
                }
                field("Partner Code"; Rec."Partner Code")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1100294004; Links)
            {
                Visible = false;
                ApplicationArea = All;
            }
            systempart(Control1100294003; Notes)
            {
                Visible = false;
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
        RecLInventorySetup: Record "Inventory Setup";
    begin
        Rec.RESET();
        IF NOT Rec.GET() THEN BEGIN
            Rec.INIT();
            Rec.INSERT();
        END;

        RecLInventorySetup.GET();
        Rec."Location Mandatory" := RecLInventorySetup."Location Mandatory";
        Rec.MODIFY();
    end;
}

