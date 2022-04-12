page 8073305 "PWD Sales Line Buffer"
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

    Caption = 'Sales Line Buffer';
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Sales Line Buffer";

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
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {
                }
                field("Unit Price"; "Unit Price")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Line Amount"; "Line Amount")
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
    }

    trigger OnAfterGetRecord()
    begin
        FctGetBufferLinked();
    end;

    var
        CduGBufferManagement: Codeunit "Buffer Management";
        RecGPEBSalesLineBuffer: Record "PEB Sales Line Buffer";
        RecGWMSSalesLineBuffer: Record "WMS Sales Line Buffer";


    procedure FctGetBufferLinked()
    begin
        //Insérer les différents Tables liées au export Natif.
        IF RecGPEBSalesLineBuffer.GET("Entry No.") THEN;
        IF RecGWMSSalesLineBuffer.GET("Entry No.") THEN;
    end;
}

