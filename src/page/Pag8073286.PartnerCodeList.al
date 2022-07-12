page 8073286 "PWD Partner Code List"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // 
    // //>>ProdConnect.1.00
    // 
    // FE_ProdConnect.001:GR 22/03/2011  Connector integration
    //                                   - Create Object
    // 
    // //>>ProdConnect1.5
    // WMS-FE10.001:GR 01/07/2011   Connector integration
    //                              - Add new Action to open Card
    // 
    // 
    // +----------------------------------------------------------------------------------------------------------------+

    Caption = 'Partner Connector List';
    CardPageID = "PWD Partner Connector";
    Editable = false;
    PageType = List;
    SourceTable = "PWD Partner Connector";
    UsageCategory = Administration;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Control1120000)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Function)
            {
                Caption = 'Function';
                action("Import Export Connector SetUp")
                {
                    Caption = 'Import Export Connector SetUp';
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedIsBig = true;
                    ApplicationArea = All;
                    Image = ImportExport;

                    trigger OnAction()
                    begin
                        XMLPORT.RUN(XmlPort::"Import Export Connector SetUp", TRUE, FALSE, Rec);
                    end;
                }
            }
        }
    }
}

