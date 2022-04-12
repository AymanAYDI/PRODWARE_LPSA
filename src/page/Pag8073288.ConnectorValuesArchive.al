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
    SourceTable = "Connector Values Archive";

    layout
    {
        area(content)
        {
            repeater(Control1120000)
            {
                ShowCaption = false;
                field("Entry No."; "Entry No.")
                {
                }
                field("Partner Code"; "Partner Code")
                {
                }
                field("Communication Mode"; "Communication Mode")
                {
                }
                field("File Name"; "File Name")
                {
                }
                field("Message Code"; "Message Code")
                {
                }
                field(Function; "Function")
                {
                }
                field(Succes; Succes)
                {
                }
                field(Direction; Direction)
                {
                }
                field("File format"; "File format")
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
        area(processing)
        {
            action("<Action1000000000>")
            {
                Caption = 'Show Message';
                Image = ViewPage;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    CduLFileManagement: Codeunit "File Management";
                begin
                    CALCFIELDS(Blob);
                    IF Rec.Blob.HASVALUE THEN BEGIN
                        Blob.CREATEINSTREAM(InsGStream);
                        CduLFileManagement.FctShowBlobAsWindow(InsGStream)
                    END;
                end;
            }
        }
    }

    var
        InsGStream: InStream;
}

