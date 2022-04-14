page 8073287 "PWD Values form Connector"
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

    Caption = 'Values From Connector';
    DelayedInsert = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "PWD Connector Values";

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
                field("File Name"; "File Name")
                {
                    ApplicationArea = All;
                }
                field(Function; "Function")
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
                field(Separator; Separator)
                {
                    ApplicationArea = All;
                }
                field("Blob"; Blob)
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
            action(Action1000000000)
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
                        CduLFileManagement.FctShowBlobAsWindow(InsGStream)
                    END;
                end;
            }
        }
    }

    var
        InsGStream: InStream;
}

