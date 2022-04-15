page 8073288 "PWD Connector Values Archive"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect.1.00
    // 
    // FE_ProdConnect.001:GR 22/03/2011  Connector integration
    //                                   - Create Object
    // +----------------------------------------------------------------------------------------------------------------+

    Caption = 'Values From Connector Archive';
    Editable = false;
    PageType = List;
    SourceTable = "PWD Connector Values Archive";

    layout
    {
        area(content)
        {
            repeater(Control1120000)
            {
                ShowCaption = false;
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Partner Code"; "Partner Code")
                {
                    ApplicationArea = All;
                }
                field("Communication Mode"; "Communication Mode")
                {
                    ApplicationArea = All;
                }
                field("File Name"; "File Name")
                {
                    ApplicationArea = All;
                }
                field("Message Code"; "Message Code")
                {
                    ApplicationArea = All;
                }
                field(Function; "Function")
                {
                    ApplicationArea = All;
                }
                field(Succes; Succes)
                {
                    ApplicationArea = All;
                }
                field(Direction; Direction)
                {
                    ApplicationArea = All;
                }
                field("File format"; "File format")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1100294001; Links)
            {
                Visible = false;
                ApplicationArea = All;
            }
            systempart(Control1100294000; Notes)
            {
                Visible = false;
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1000000000>")
            {
                Caption = 'Show Message';
                Image = ViewPage;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                    CduLFileManagement: Codeunit "File Management";
                begin
                    CALCFIELDS(Blob);
                    IF Rec.Blob.HASVALUE THEN BEGIN
                        Blob.CREATEINSTREAM(InsGStream);
                        //TODO: le Codeunit "File Management" ne contient pas la definition de la procedure 'FctShowBlobAsWindow'
                        //CduLFileManagement.FctShowBlobAsWindow(InsGStream)
                    END;
                end;
            }
        }
    }

    var
        InsGStream: InStream;
}

