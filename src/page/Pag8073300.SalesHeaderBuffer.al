page 8073300 "PWD Sales Header Buffer"
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

    Caption = 'Sales Header Buffer';
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Sales Header Buffer";

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
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                }
                field("External Document No."; "External Document No.")
                {
                }
                field("Posting Date"; "Posting Date")
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
            group(Action1100294035)
            {
                Caption = 'Line';
                action(Action1100294036)
                {
                    Caption = 'Process action';

                    trigger OnAction()
                    var
                        CduLBufferManagement: Codeunit "Buffer Management";
                    begin
                        CduLBufferManagement.FctProcessSalesOrder(Rec);
                    end;
                }
                action(Action1100294044)
                {
                    Caption = 'Process selected actions';

                    trigger OnAction()
                    begin
                        FctProcessSelected();
                    end;
                }
                action(Action1100294045)
                {
                    Caption = 'Show Error Message';

                    trigger OnAction()
                    begin
                        FctShowErrorMessage();
                    end;
                }
                separator(Action1100294038)
                {
                }
                action(Action1100294043)
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
                separator(Action1100294042)
                {
                }
                action(Action1100294037)
                {
                    Caption = 'Show Document';
                    Image = View;

                    trigger OnAction()
                    var
                        CduLBufferManagement: Codeunit "Buffer Management";
                    begin
                        CduLBufferManagement.FctShowSalesOrder(Rec);
                    end;
                }
                action(Action1100294034)
                {
                    Caption = 'Show Sales Line Buffer';
                    RunObject = Page "Sales Line Buffer";
                    RunPageLink = Document Type=FIELD(Document Type),Document No.=FIELD(Document No.);
                    RunPageView = SORTING(Document Type,Document No.);
                }
                action(Action1100294039)
                {
                    Caption = 'Show Sales Comment Line Buffer';
                    RunObject = Page "Sales Comment Line Buffer";
                                    RunPageLink = Document Type=FIELD(Document Type),Document No.=FIELD(Document No.);
                    RunPageView = SORTING(Document Type,Document No.,Document Line No.);
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        FctGetBufferLinked();
    end;

    var
        RecGPEBSalesHeaderBuffer: Record "PEB Sales Header Buffer";
        RecGWMSSalesHeaderBuffer: Record "WMS Sales Header Buffer";
        CduGBufferManagement: Codeunit "Buffer Management";


    procedure FctGetBufferLinked()
    begin
        //Insérer les différents Tables liées au export Natif.
        IF RecGPEBSalesHeaderBuffer.GET("Entry No.") THEN;
        IF RecGWMSSalesHeaderBuffer.GET("Entry No.") THEN;
    end;


    procedure FctProcessSelected()
    var
        RecLSalesHeaderBuffer: Record "Sales Header Buffer";
        RecordRef: RecordRef;
    begin
        CurrPage.SETSELECTIONFILTER(RecLSalesHeaderBuffer);
        RecordRef.OPEN(DATABASE::"Sales Header Buffer", FALSE, COMPANYNAME);
        RecordRef.SETTABLE(RecLSalesHeaderBuffer);
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

