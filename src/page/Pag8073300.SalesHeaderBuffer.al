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
    SourceTable = "PWD Sales Header Buffer";

    layout
    {
        area(content)
        {
            repeater(Control1100294000)
            {
                ShowCaption = false;
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Connector Values Entry No."; "Connector Values Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Partner Code"; "Partner Code")
                {
                    ApplicationArea = All;
                }
                field("Message Code"; "Message Code")
                {
                    ApplicationArea = All;
                }
                field("Creation Date"; "Creation Date")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field(Processed; Processed)
                {
                    ApplicationArea = All;
                }
                field("Processed Date"; "Processed Date")
                {
                    ApplicationArea = All;
                }
                field("Error Message"; "Error Message")
                {
                    ApplicationArea = All;
                }
                field("Action"; Action)
                {
                    ApplicationArea = All;
                }
                field("RecordID Created"; "RecordID Created")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; "Posting Date")
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
            group(Action1100294035)
            {
                Caption = 'Line';
                action(Action1100294036)
                {
                    Caption = 'Process action';
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        CduLBufferManagement: Codeunit "PWD Buffer Management";
                    begin
                        CduLBufferManagement.FctProcessSalesOrder(Rec);
                    end;
                }
                action(Action1100294044)
                {
                    Caption = 'Process selected actions';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        FctProcessSelected();
                    end;
                }
                action(Action1100294045)
                {
                    Caption = 'Show Error Message';
                    ApplicationArea = All;

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
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        RecLSalesHeaderBuffer: Record "PWD Sales Header Buffer";
                        CduLBufferManagement: Codeunit "PWD Buffer Management";
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
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        CduLBufferManagement: Codeunit "PWD Buffer Management";
                    begin
                        CduLBufferManagement.FctShowSalesOrder(Rec);
                    end;
                }
                action(Action1100294034)
                {
                    Caption = 'Show Sales Line Buffer';
                    RunObject = Page "PWD Sales Line Buffer";
                    RunPageLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("Document No.");
                    RunPageView = SORTING("Document Type", "Document No.");
                    ApplicationArea = All;
                }
                action(Action1100294039)
                {
                    Caption = 'Show Sales Comment Line Buffer';
                    RunObject = Page "PWD Sales Comment Line Buffer";
                    RunPageLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("Document No.");
                    RunPageView = SORTING("Document Type", "Document No.", "Document Line No.");
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        FctGetBufferLinked();
    end;

    var
        RecGPEBSalesHeaderBuffer: Record "PWD PEB Sales Header Buffer";
        RecGWMSSalesHeaderBuffer: Record "PWD WMS Sales Header Buffer";
        CduGBufferManagement: Codeunit "PWD Buffer Management";


    procedure FctGetBufferLinked()
    begin
        //Insérer les différents Tables liées au export Natif.
        IF RecGPEBSalesHeaderBuffer.GET("Entry No.") THEN;
        IF RecGWMSSalesHeaderBuffer.GET("Entry No.") THEN;
    end;


    procedure FctProcessSelected()
    var
        RecLSalesHeaderBuffer: Record "PWD Sales Header Buffer";
        RecordRef: RecordRef;
    begin
        CurrPage.SETSELECTIONFILTER(RecLSalesHeaderBuffer);
        RecordRef.OPEN(DATABASE::"PWD Sales Header Buffer", FALSE, COMPANYNAME);
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

