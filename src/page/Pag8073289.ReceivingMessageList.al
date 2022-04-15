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
    SourceTableView = SORTING("Partner Code", Code, Direction) ORDER(Ascending) WHERE(Direction = FILTER(Import));

    layout
    {
        area(content)
        {
            repeater(Control1100294000)
            {
                ShowCaption = false;
                field("Code"; Code)
                {
                    ApplicationArea = All;
                }
                field(Function; "Function")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Path; Path)
                {
                    ApplicationArea = All;
                }
                field("Archive Path"; "Archive Path")
                {
                    ApplicationArea = All;
                }
                field("Auto-Post Document"; "Auto-Post Document")
                {
                    ApplicationArea = All;
                }
                field("Archive Message"; "Archive Message")
                {
                    ApplicationArea = All;
                }
                field(Blocked; Blocked)
                {
                    ApplicationArea = All;
                }
                field(Control1100267000; "Auto-Post Document")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1100294006; Links)
            {
                Visible = false;
                ApplicationArea = All;
            }
            systempart(Control1100294004; Notes)
            {
                Visible = false;
                ApplicationArea = All;
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
                    RunPageLink = "Partner Code"=  FIELD("Partner Code"),"Message Code"=FIELD(Code),"Table ID"=FIELD("Table ID"),Direction=FIELD(Direction);
                  
                    ApplicationArea = All;
                    ShortCutKey = 'Shift+Ctrl+F';
                }
            }
        }
    }
}

