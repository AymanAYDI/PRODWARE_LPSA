page 8073289 "PWD Receiving Message List"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // //>>ProdConnect1.5
    // WMS-FE10.001:GR 01/07/2011   Connector integration
    //                         - Create Object
    // 
    // //>>ProdConnect1.6
    // OSYS-Int001.001:GR 25/10/2011   Connector integration
    //                                 - Add field : "Auto-Post Document"
    // +----------------------------------------------------------------------------------------------------------------+

    Caption = 'Receiving Message List';
    PageType = List;
    PopulateAllFields = false;
    SourceTable = "PWD Connector Messages";
    SourceTableView = SORTING(Partner Code, Code, Direction) ORDER(Ascending) WHERE(Direction = FILTER(Import));

    layout
    {
        area(content)
        {
            repeater(Control1100294000)
            {
                ShowCaption = false;
                field("Code"; Code)
                {
                }
                field(Function; "Function")
                {
                }
                field(Description; Description)
                {
                }
                field(Path; Path)
                {
                }
                field("Archive Path"; "Archive Path")
                {
                }
                field("Auto-Post Document"; "Auto-Post Document")
                {
                }
                field("Archive Message"; "Archive Message")
                {
                }
                field(Blocked; Blocked)
                {
                }
                field(Control1100267000; "Auto-Post Document")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1100294006; Links)
            {
                Visible = false;
            }
            systempart(Control1100294004; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Action1100294012)
            {
                Caption = 'Message';
                action(Action1100294014)
                {
                    Caption = 'Paramètres champs';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "PWD Fields Export Setup";
                    RunPageLink = Partner Code=FIELD(Partner Code),Message Code=FIELD(Code),Table ID=FIELD(Table ID),Direction=FIELD(Direction);
                    ShortCutKey = 'Shift+Ctrl+F';
                }
            }
        }
    }
}

