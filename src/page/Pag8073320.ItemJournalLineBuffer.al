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
    PageType = List;
    UsageCategory = None;
    SourceTable = "PWD Item Jounal Line Buffer";

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
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                }
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = All;
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ApplicationArea = All;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
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
                field("Auto-Post Document"; Rec."Auto-Post Document")
                {
                    ApplicationArea = All;
                }
                field("Operation No."; Rec."Operation No.")
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
                field("Setup Time"; Rec."Setup Time")
                {
                    ApplicationArea = All;
                }
                field("Run Time"; Rec."Run Time")
                {
                    ApplicationArea = All;
                }
                field("Output Quantity"; Rec."Output Quantity")
                {
                    ApplicationArea = All;
                }
                field("Scrap Quantity"; Rec."Scrap Quantity")
                {
                    ApplicationArea = All;
                }
                field("Scrap Code"; Rec."Scrap Code")
                {
                    ApplicationArea = All;
                }
                field("Prod. Order No."; Rec."Prod. Order No.")
                {
                    ApplicationArea = All;
                }
                field(Finished; Rec.Finished)
                {
                    ApplicationArea = All;
                }
                field("Prod. Order Line No."; Rec."Prod. Order Line No.")
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
                field("Conform quality control"; Rec."Conform quality control")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("New Location Code"; Rec."New Location Code")
                {
                    ApplicationArea = All;
                }
                field("Bin Code"; Rec."Bin Code")
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
                    Image = Process;

                    trigger OnAction()
                    var
                        CduLBufferManagement: Codeunit "PWD Buffer Management";
                    begin
                        //>>OSYS-Int001.001
                        CLEAR(CduLBufferManagement);
                        //<<OSYS-Int001.001

                        CduLBufferManagement.FctProcessItemJournaLine(Rec);

                        //>>OSYS-Int001.001
                        IF (Rec."Auto-Post Document") AND CduLBufferManagement.FctCanPost() THEN
                            CduLBufferManagement.FctValidateItemJournaLine(Rec."Journal Template Name", Rec."Journal Batch Name");
                        //<<OSYS-Int001.001
                    end;
                }
                action(Action1100294062)
                {
                    Caption = 'Process selected actions';
                    ApplicationArea = All;
                    Image = Process;

                    trigger OnAction()
                    begin
                        FctProcessSelected();
                    end;
                }
                action(Action1100294053)
                {
                    Caption = 'Show Error Message';
                    ApplicationArea = All;
                    Image = PrevErrorMessage;
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
                    Image = ShowSelected;
                    trigger OnAction()
                    var
                        RecLItemJounalLineBuffer: Record "PWD Item Jounal Line Buffer";
                        CduLBufferManagement: Codeunit "PWD Buffer Management";
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
        RecGWMSItemJounalLineBuffer: Record "PWD WMS Item Jnl Line Buffer";
        CduGBufferManagement: Codeunit "PWD Buffer Management";


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
        IF RecGWMSItemJounalLineBuffer.GET(Rec."Entry No.") THEN;
    end;


    procedure FctShowErrorMessage()
    var
        RecordRef: RecordRef;
    begin
        RecordRef.GETTABLE(Rec);
        CduGBufferManagement.FctReadBlob(RecordRef);
    end;
}

