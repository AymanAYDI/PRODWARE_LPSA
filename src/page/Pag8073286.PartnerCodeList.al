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

    layout
    {
        area(content)
        {
            repeater(Control1120000)
            {
                ShowCaption = false;
                field("Code"; Code)
                {
                }
                field(Name; Name)
                {
                }
                field(Blocked; Blocked)
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1100294001; Links)
            {
                Visible = false;
            }
            systempart(Control1100294000; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Action1100294004)
            {
                Caption = 'fiche';
                RunObject = Page "PWD Partner Connector";
                RunPageLink = Code = FIELD(Code);
            }
            group("<Action1100294014>")
            {
                Caption = 'Function';
                action("<Action1100294015>")
                {
                    Caption = 'Import Export Connector SetUp';
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        XMLPORT.RUN(8073282, TRUE, FALSE, Rec);
                    end;
                }
            }
        }
    }
}

