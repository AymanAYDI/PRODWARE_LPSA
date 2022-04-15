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
    SourceTable = "PWD WMS Setup";

    layout
    {
        area(content)
        {
            group(Control1100294000)
            {
                Caption = 'General';
                ShowCaption = false;
                field(WMS; WMS)
                {
                    ApplicationArea = All;
                }
                field("Location Mandatory"; "Location Mandatory")
                {
                    ApplicationArea = All;
                }
                field("WMS Company Code"; "WMS Company Code")
                {
                    ApplicationArea = All;
                }
                field("WMS Delivery"; "WMS Delivery")
                {
                    ApplicationArea = All;
                }
                field("WMS Shipment"; "WMS Shipment")
                {
                    ApplicationArea = All;
                }
                field("Journal Template Name"; "Journal Template Name")
                {
                    ApplicationArea = All;
                }
                field("Journal Batch Name"; "Journal Batch Name")
                {
                    ApplicationArea = All;
                }
                field("Partner Code"; "Partner Code")
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
        RESET();
        IF NOT GET() THEN BEGIN
            INIT();
            INSERT();
        END;

        RecLInventorySetup.GET();
        "Location Mandatory" := RecLInventorySetup."Location Mandatory";
        MODIFY();
    end;
}

