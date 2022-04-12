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
                field("Creation Date"; "Creation Date")
                {
                }
                field("Journal Template Name"; "Journal Template Name")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Entry Type"; "Entry Type")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Source Type"; "Source Type")
                {
                }
                field("Journal Batch Name"; "Journal Batch Name")
                {
                }
                field("Reason Code"; "Reason Code")
                {
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
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
                field("Auto-Post Document"; "Auto-Post Document")
                {
                }
                field("Operation No."; "Operation No.")
                {
                }
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {
                }
                field("Setup Time"; "Setup Time")
                {
                }
                field("Run Time"; "Run Time")
                {
                }
                field("Output Quantity"; "Output Quantity")
                {
                }
                field("Scrap Quantity"; "Scrap Quantity")
                {
                }
                field("Scrap Code"; "Scrap Code")
                {
                }
                field("Prod. Order No."; "Prod. Order No.")
                {
                }
                field(Finished; Finished)
                {
                }
                field("Prod. Order Line No."; "Prod. Order Line No.")
                {
                }
                field("RecGWMSItemJounalLineBuffer.""WMS Reson Code"""; RecGWMSItemJounalLineBuffer."WMS Reson Code")
                {
                    CaptionClass = CduGBufferManagement.FctGetCaptionClass(DATABASE::"PWD WMS Item Jnl Line Buffer", RecGWMSItemJounalLineBuffer.FIELDNO("WMS Reson Code"));

                    trigger OnValidate()
                    begin
                        IF RecGWMSItemJounalLineBuffer.MODIFY THEN;
                    end;
                }
                field("RecGWMSItemJounalLineBuffer.""WMS Company Code"""; RecGWMSItemJounalLineBuffer."WMS Company Code")
                {
                    CaptionClass = CduGBufferManagement.FctGetCaptionClass(DATABASE::"PWD WMS Item Jnl Line Buffer", RecGWMSItemJounalLineBuffer.FIELDNO("WMS Company Code"));

                    trigger OnValidate()
                    begin
                        IF RecGWMSItemJounalLineBuffer.MODIFY THEN;
                    end;
                }
                field("Conform quality control"; "Conform quality control")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("New Location Code"; "New Location Code")
                {
                }
                field("Bin Code"; "Bin Code")
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
            group(Action1100294051)
            {
                Caption = 'Line';
                action(Action1100294052)
                {
                    Caption = 'Process action';

                    trigger OnAction()
                    var
                        CduLBufferManagement: Codeunit "Buffer Management";
                    begin
                        //>>OSYS-Int001.001
                        CLEAR(CduLBufferManagement);
                        //<<OSYS-Int001.001

                        CduLBufferManagement.FctProcessItemJournaLine(Rec);

                        //>>OSYS-Int001.001
                        IF ("Auto-Post Document") AND CduLBufferManagement.FctCanPost THEN
                            CduLBufferManagement.FctValidateItemJournaLine("Journal Template Name", "Journal Batch Name");
                        //<<OSYS-Int001.001
                    end;
                }
                action(Action1100294062)
                {
                    Caption = 'Process selected actions';

                    trigger OnAction()
                    begin
                        FctProcessSelected();
                    end;
                }
                action(Action1100294053)
                {
                    Caption = 'Show Error Message';

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

                    trigger OnAction()
                    var
                        CduLBufferManagement: Codeunit "Buffer Management";
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

                    trigger OnAction()
                    var
                        CduLBufferManagement: Codeunit "Buffer Management";
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
        CduGBufferManagement: Codeunit "Buffer Management";
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

