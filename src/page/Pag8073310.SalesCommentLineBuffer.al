page 8073310 "PWD Sales Comment Line Buffer"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.5
    // WMS-FEMOT.001:GR 29/06/2011  Connector management
    //                                   - Create Object
    // +----------------------------------------------------------------------------------------------------------------+

    Caption = 'Sales Comment Line Buffer';
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Sales Comment Line Buffer";

    layout
    {
        area(content)
        {
            repeater(Control1100294000)
            {
                ShowCaption = false;
                field("Entry No."; "Entry No.")
                {
                }
                field("Connector Values Entry No."; "Connector Values Entry No.")
                {
                }
                field("Partner Code"; "Partner Code")
                {
                }
                field("Message Code"; "Message Code")
                {
                }
                field("Creation Date"; "Creation Date")
                {
                }
                field(Status; Status)
                {
                }
                field(Processed; Processed)
                {
                }
                field("Processed Date"; "Processed Date")
                {
                }
                field("Error Message"; "Error Message")
                {
                }
                field("Action"; Action)
                {
                }
                field("RecordID Created"; "RecordID Created")
                {
                }
                field("Document Type"; "Document Type")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Document Line No."; "Document Line No.")
                {
                }
                field("Date"; Date)
                {
                }
                field("Code"; Code)
                {
                }
                field(Comment; Comment)
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
            systempart(Control1100294002; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Action1100294038)
            {
                Caption = 'Line';
                separator(Action1100294040)
                {
                }
                action(Action1100294041)
                {
                    Caption = 'Purge selected';

                    trigger OnAction()
                    var
                        CduLBufferManagement: Codeunit "Buffer Management";
                        RecLSalesHeaderBuffer: Record "Sales Header Buffer";
                    begin
                        CurrPage.SETSELECTIONFILTER(RecLSalesHeaderBuffer);
                        CduLBufferManagement.FctPurgeSalesHeader(RecLSalesHeaderBuffer);
                    end;
                }
                separator(Action1100294043)
                {
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        FctGetBufferLinked();
    end;

    var
        CduGBufferManagement: Codeunit "Buffer Management";
        RecGPEBSalesCommentLineBuffer: Record "PEB Sales Comment Line Buffer";
        RecGWMSSalesCommentLineBuffer: Record "WMS Sales Comment Line Buffer";


    procedure FctGetBufferLinked()
    begin
        //Insérer les différents tables liées aux imports Natif.
        IF RecGPEBSalesCommentLineBuffer.GET("Entry No.") THEN;
        IF RecGWMSSalesCommentLineBuffer.GET("Entry No.") THEN;
    end;
}

