page 8073320 "PWD Item Journal Line Buffer"
{
    // +----------------------------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                                                |
    // | www.prodware.fr                                                                                                                  |
    // +----------------------------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.5
    // WMS-FE009.001:GR  05/07/2011 Connector management
    //                              - Create Object
    // 
    // //>>ProdConnect1.6
    // OSYS-Int001.001:GR 18/10/2011 Connector integration
    //                               - Use Function FctValidateItemJournaLine on All Process action
    // 
    // //>>LAP2.01
    // FE_LAPIERRETTE_PROD11.001: GR 16/02/2012: Conform Quality Control
    //                                           - Add field
    //                                             Conform Quality Control
    // 
    // //>>LAP2.22
    // P24578_009: RO : 03/12/2019 : cf Demande par mail
    //                   - Add Fields Shortcut Dimension 1 Code
    //                                New Location Code
    //                                Bin Code
    // 
    // +----------------------------------------------------------------------------------------------------------------------------------+

    Caption = 'Item Journal Line Buffer';
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "PWD Item Jounal Line Buffer";

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
                field("Creation Date"; "Creation Date")
                {
                    ApplicationArea = All;
                }
                field("Journal Template Name"; "Journal Template Name")
                {
                    ApplicationArea = All;
                }
                field("Item No."; "Item No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Entry Type"; "Entry Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;
                }
                field("Source Type"; "Source Type")
                {
                    ApplicationArea = All;
                }
                field("Journal Batch Name"; "Journal Batch Name")
                {
                    ApplicationArea = All;
                }
                field("Reason Code"; "Reason Code")
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field("Expiration Date"; "Expiration Date")
                {
                    ApplicationArea = All;
                }
                field("Serial No."; "Serial No.")
                {
                    ApplicationArea = All;
                }
                field("Lot No."; "Lot No.")
                {
                    ApplicationArea = All;
                }
                field("Auto-Post Document"; "Auto-Post Document")
                {
                    ApplicationArea = All;
                }
                field("Operation No."; "Operation No.")
                {
                    ApplicationArea = All;
                }
                field(Type; Type)
                {
                    ApplicationArea = All;
                }
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Setup Time"; "Setup Time")
                {
                    ApplicationArea = All;
                }
                field("Run Time"; "Run Time")
                {
                    ApplicationArea = All;
                }
                field("Output Quantity"; "Output Quantity")
                {
                    ApplicationArea = All;
                }
                field("Scrap Quantity"; "Scrap Quantity")
                {
                    ApplicationArea = All;
                }
                field("Scrap Code"; "Scrap Code")
                {
                    ApplicationArea = All;
                }
                field("Prod. Order No."; "Prod. Order No.")
                {
                    ApplicationArea = All;
                }
                field(Finished; Finished)
                {
                    ApplicationArea = All;
                }
                field("Prod. Order Line No."; "Prod. Order Line No.")
                {
                    ApplicationArea = All;
                }
                field("RecGWMSItemJounalLineBuffer.""WMS Reson Code"""; RecGWMSItemJounalLineBuffer."WMS Reson Code")
                {
                    CaptionClass = CduGBufferManagement.FctGetCaptionClass(DATABASE::"PWD WMS Item Jnl Line Buffer", RecGWMSItemJounalLineBuffer.FIELDNO("WMS Reson Code"));
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        IF RecGWMSItemJounalLineBuffer.MODIFY() THEN;
                    end;
                }
                field("RecGWMSItemJounalLineBuffer.""WMS Company Code"""; RecGWMSItemJounalLineBuffer."WMS Company Code")
                {
                    CaptionClass = CduGBufferManagement.FctGetCaptionClass(DATABASE::"PWD WMS Item Jnl Line Buffer", RecGWMSItemJounalLineBuffer.FIELDNO("WMS Company Code"));
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        IF RecGWMSItemJounalLineBuffer.MODIFY() THEN;
                    end;
                }
                field("Conform quality control"; "Conform quality control")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("New Location Code"; "New Location Code")
                {
                    ApplicationArea = All;
                }
                field("Bin Code"; "Bin Code")
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
            group(Action1100294051)
            {
                Caption = 'Line';
                action(Action1100294052)
                {
                    Caption = 'Process action';
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        CduLBufferManagement: Codeunit "PWD Buffer Management";
                    begin
                        //>>OSYS-Int001.001
                        CLEAR(CduLBufferManagement);
                        //<<OSYS-Int001.001

                        CduLBufferManagement.FctProcessItemJournaLine(Rec);

                        //>>OSYS-Int001.001
                        IF ("Auto-Post Document") AND CduLBufferManagement.FctCanPost() THEN
                            CduLBufferManagement.FctValidateItemJournaLine("Journal Template Name", "Journal Batch Name");
                        //<<OSYS-Int001.001
                    end;
                }
                action(Action1100294062)
                {
                    Caption = 'Process selected actions';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        FctProcessSelected();
                    end;
                }
                action(Action1100294053)
                {
                    Caption = 'Show Error Message';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        FctShowErrorMessage();
                    end;
                }
                separator(Action1100294058)
                {
                }
                action(Action1100294059)
                {
                    Caption = 'Purge selected';
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        CduLBufferManagement: Codeunit "PWD Buffer Management";
                        RecLItemJounalLineBuffer: Record "PWD Item Jounal Line Buffer";
                    begin
                        CurrPage.SETSELECTIONFILTER(RecLItemJounalLineBuffer);
                        CduLBufferManagement.FctPurgeItemJournaLine(RecLItemJounalLineBuffer);
                    end;
                }
                separator(Action1100294060)
                {
                }
                action(Action1100294061)
                {
                    Caption = 'Show Document';
                    Image = View;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        CduLBufferManagement: Codeunit "PWD Buffer Management";
                    begin
                        CduLBufferManagement.FctShowItemJournaLine(Rec);
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
        CduGBufferManagement: Codeunit "PWD Buffer Management";
        RecGWMSItemJounalLineBuffer: Record "PWD WMS Item Jnl Line Buffer";


    procedure FctProcessSelected()
    var
        RecLItemJournalLineBuffer: Record "PWD Item Jounal Line Buffer";
        RecordRef: RecordRef;
    begin
        //>>OSYS-Int001.001
        CLEAR(CduGBufferManagement);
        //<<OSYS-Int001.001

        CurrPage.SETSELECTIONFILTER(RecLItemJournalLineBuffer);
        RecordRef.GETTABLE(RecLItemJournalLineBuffer);
        CduGBufferManagement.FctMultiProcessLine(RecordRef);

        //>>OSYS-Int001.001
        CduGBufferManagement.FctValidateMultiItemJournaLine();
        //<<OSYS-Int001.001
    end;


    procedure FctGetBufferLinked()
    begin
        //Insérer les différents Tables liées au export Natif.
        IF RecGWMSItemJounalLineBuffer.GET("Entry No.") THEN;
    end;


    procedure FctShowErrorMessage()
    var
        RecordRef: RecordRef;
    begin
        RecordRef.GETTABLE(Rec);
        CduGBufferManagement.FctReadBlob(RecordRef);
    end;
}

