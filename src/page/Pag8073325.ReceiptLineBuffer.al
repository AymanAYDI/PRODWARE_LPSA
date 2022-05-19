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
    PageType = List;
    UsageCategory = None;
    SourceTable = "PWD Receipt Line Buffer";

    layout
    {
        area(content)
        {
            repeater(Control1100294000)
            {
                ShowCaption = false;
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Connector Values Entry No."; Rec."Connector Values Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Partner Code"; Rec."Partner Code")
                {
                    ApplicationArea = All;
                }
                field("Message Code"; Rec."Message Code")
                {
                    ApplicationArea = All;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(Processed; Rec.Processed)
                {
                    ApplicationArea = All;
                }
                field("Processed Date"; Rec."Processed Date")
                {
                    ApplicationArea = All;
                }
                field("Error Message"; Rec."Error Message")
                {
                    ApplicationArea = All;
                }
                field("Action"; Rec.Action)
                {
                    ApplicationArea = All;
                }
                field("RecordID Created"; Rec."RecordID Created")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Document Line No."; Rec."Document Line No.")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field("Initial Quantity (Base)"; Rec."Initial Quantity (Base)")
                {
                    ApplicationArea = All;
                }
                field("Receipt Quantity (Base)"; Rec."Receipt Quantity (Base)")
                {
                    ApplicationArea = All;
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = All;
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                }
                field("RecGWMSReceiptLineBuffer.""Qty on receipt error (Base)"""; RecGWMSReceiptLineBuffer."Qty on receipt error (Base)")
                {
                    CaptionClass = CduGBufferManagement.FctGetCaptionClass(DATABASE::"PWD WMS Receipt Line Buffer", RecGWMSReceiptLineBuffer.FIELDNO("Qty on receipt error (Base)"));
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        IF RecGWMSReceiptLineBuffer.MODIFY() THEN;
                    end;
                }
                field("RecGWMSReceiptLineBuffer.""Reason Code Receipt Error"""; RecGWMSReceiptLineBuffer."Reason Code Receipt Error")
                {
                    CaptionClass = CduGBufferManagement.FctGetCaptionClass(DATABASE::"PWD WMS Receipt Line Buffer", RecGWMSReceiptLineBuffer.FIELDNO("Reason Code Receipt Error"));
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        IF RecGWMSReceiptLineBuffer.MODIFY() THEN;
                    end;
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
            systempart(Control1100294002; Notes)
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
            group(Action1100294044)
            {
                Caption = 'Line';
                action(Action1100294045)
                {
                    Caption = 'Process action';
                    ApplicationArea = All;
                    Image = Process;
                    trigger OnAction()
                    var
                        CduLBufferManagement: Codeunit "PWD Buffer Management";
                    begin
                        CduLBufferManagement.FctProcessReceiptLine(Rec);
                    end;
                }
                action(Action1100294058)
                {
                    Caption = 'Process selected actions';
                    ApplicationArea = All;
                    Image = Process;
                    trigger OnAction()
                    begin
                        FctProcessSelected();
                    end;
                }
                action(Action1100294059)
                {
                    Caption = 'Show Error Message';
                    ApplicationArea = All;
                    Image = PrevErrorMessage;
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
                    ApplicationArea = All;
                    Image = ShowSelected;
                    trigger OnAction()
                    var
                        RecLReceiptLineBuffer: Record "PWD Receipt Line Buffer";
                        CduLBufferManagement: Codeunit "PWD Buffer Management";
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
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        CduLBufferManagement: Codeunit "PWD Buffer Management";
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
        RecGPEBReceiptLineBuffer: Record "PWD PEB Receipt Line Buffer";
        RecGWMSReceiptLineBuffer: Record "PWD WMS Receipt Line Buffer";
        CduGBufferManagement: Codeunit "PWD Buffer Management";


    procedure FctGetBufferLinked()
    begin
        //Insérer les différents Tables liées au export Natif.
        IF RecGPEBReceiptLineBuffer.GET(Rec."Entry No.") THEN;
        IF RecGWMSReceiptLineBuffer.GET(Rec."Entry No.") THEN;
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

