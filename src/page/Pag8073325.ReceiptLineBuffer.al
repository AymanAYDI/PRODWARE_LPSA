page 8073325 "PWD Receipt Line Buffer"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.5
    // WMS-FE007_15.001:GR 05/07/2011 Receipt
    //                                   - Create Object
    // +----------------------------------------------------------------------------------------------------------------+

    Caption = 'Receipt Line Buffer';
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "PWD Receipt Line Buffer";

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
                field("Location Code"; "Location Code")
                {
                }
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {
                }
                field("Variant Code"; "Variant Code")
                {
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                }
                field("Initial Quantity (Base)"; "Initial Quantity (Base)")
                {
                }
                field("Receipt Quantity (Base)"; "Receipt Quantity (Base)")
                {
                }
                field("Expiration Date"; "Expiration Date")
                {
                }
                field("Serial No."; "Serial No.")
                {
                }
                field("Lot No."; "Lot No.")
                {
                }
                field("RecGWMSReceiptLineBuffer.""Qty on receipt error (Base)"""; RecGWMSReceiptLineBuffer."Qty on receipt error (Base)")
                {
                    CaptionClass = CduGBufferManagement.FctGetCaptionClass(DATABASE::"WMS Receipt Line Buffer", RecGWMSReceiptLineBuffer.FIELDNO("Qty on receipt error (Base)"));

                    trigger OnValidate()
                    begin
                        IF RecGWMSReceiptLineBuffer.MODIFY THEN;
                    end;
                }
                field("RecGWMSReceiptLineBuffer.""Reason Code Receipt Error"""; RecGWMSReceiptLineBuffer."Reason Code Receipt Error")
                {
                    CaptionClass = CduGBufferManagement.FctGetCaptionClass(DATABASE::"WMS Receipt Line Buffer", RecGWMSReceiptLineBuffer.FIELDNO("Reason Code Receipt Error"));

                    trigger OnValidate()
                    begin
                        IF RecGWMSReceiptLineBuffer.MODIFY THEN;
                    end;
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
            group(Action1100294044)
            {
                Caption = 'Line';
                action(Action1100294045)
                {
                    Caption = 'Process action';

                    trigger OnAction()
                    var
                        CduLBufferManagement: Codeunit "Buffer Management";
                    begin
                        CduLBufferManagement.FctProcessReceiptLine(Rec);
                    end;
                }
                action(Action1100294058)
                {
                    Caption = 'Process selected actions';

                    trigger OnAction()
                    begin
                        FctProcessSelected();
                    end;
                }
                action(Action1100294059)
                {
                    Caption = 'Show Error Message';

                    trigger OnAction()
                    begin
                        FctShowErrorMessage();
                    end;
                }
                separator(Action1100294046)
                {
                }
                action(Action1100294050)
                {
                    Caption = 'Purge selected';

                    trigger OnAction()
                    var
                        CduLBufferManagement: Codeunit "Buffer Management";
                        RecLReceiptLineBuffer: Record "PWD Receipt Line Buffer";
                    begin
                        CurrPage.SETSELECTIONFILTER(RecLReceiptLineBuffer);
                        CduLBufferManagement.FctPurgeReceiptLine(RecLReceiptLineBuffer);
                    end;
                }
                separator(Action1100294051)
                {
                }
                action(Action1100294047)
                {
                    Caption = 'Show Document';
                    Image = View;

                    trigger OnAction()
                    var
                        CduLBufferManagement: Codeunit "Buffer Management";
                    begin
                        CduLBufferManagement.FctShowReceiptLine(Rec);
                    end;
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
        RecGPEBReceiptLineBuffer: Record "PEB Receipt Line Buffer";
        RecGWMSReceiptLineBuffer: Record "WMS Receipt Line Buffer";


    procedure FctGetBufferLinked()
    begin
        //Insérer les différents Tables liées au export Natif.
        IF RecGPEBReceiptLineBuffer.GET("Entry No.") THEN;
        IF RecGWMSReceiptLineBuffer.GET("Entry No.") THEN;
    end;


    procedure FctProcessSelected()
    var
        RecLReceiptLineBuffer: Record "PWD Receipt Line Buffer";
        RecordRef: RecordRef;
    begin
        CurrPage.SETSELECTIONFILTER(RecLReceiptLineBuffer);
        RecordRef.OPEN(DATABASE::"PWD Receipt Line Buffer", FALSE, COMPANYNAME);
        RecordRef.SETTABLE(RecLReceiptLineBuffer);
        CduGBufferManagement.FctMultiProcessLine(RecordRef);
    end;


    procedure FctShowErrorMessage()
    var
        RecordRef: RecordRef;
    begin
        RecordRef.GETTABLE(Rec);
        CduGBufferManagement.FctReadBlob(RecordRef);
    end;
}

