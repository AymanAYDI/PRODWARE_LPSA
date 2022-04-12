page 8073283 "PWD Partner Connector"
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
    // 
    // //>>ProdConnect1.5
    // WMS-FE10.001:GR 01/07/2011   Connector integration
    //                         - Add new action Receiving Message List
    //                         - Add New Fields "Default Value Bool Yes", "Default Value Bool No"
    //                           with visibility management
    //                         - Add import export Parameters
    // +----------------------------------------------------------------------------------------------------------------+

    Caption = 'Partner Connector Card';
    PageType = Card;
    SourceTable = "PWD Partner Connector";

    layout
    {
        area(content)
        {
            group("Général")
            {
                Caption = 'Général';
                field("Code"; Code)
                {
                }
                field(Name; Name)
                {
                }
                field("Communication Mode"; "Communication Mode")
                {

                    trigger OnValidate()
                    begin
                        BooGSeparatorVisible := "Data Format" = "Data Format"::"with separator";
                        BooGReceiveQueueVisible := "Communication Mode" = "Communication Mode"::MSMQ;
                        BooGReplyQueueVisible := "Communication Mode" = "Communication Mode"::MSMQ;
                        BooGObjectIDRunVisible := "Communication Mode" = "Communication Mode"::MSMQ;
                        BooGFunctionsCodeUnitIDVisible := "Communication Mode" = "Communication Mode"::MSMQ;
                    end;
                }
                field("Data Format"; "Data Format")
                {

                    trigger OnValidate()
                    begin
                        BooGSeparatorVisible := "Data Format" = "Data Format"::"with separator";
                    end;
                }
                field(Blocked; Blocked)
                {
                }
                field("Receive Queue"; "Receive Queue")
                {
                    Visible = BooGReceiveQueueVisible;
                }
                field("Reply Queue"; "Reply Queue")
                {
                    Visible = BooGReplyQueueVisible;
                }
                field("Object ID to Run"; "Object ID to Run")
                {
                    Visible = BooGObjectIDRunVisible;
                }
                field("Object Name to Run"; "Object Name to Run")
                {
                    Visible = BooGObjectIDRunVisible;
                }
                field("Functions CodeUnit ID"; "Functions CodeUnit ID")
                {
                    Visible = BooGFunctionsCodeUnitIDVisible;
                }
                field("Functions CodeUnit Name"; "Functions CodeUnit Name")
                {
                    Visible = BooGFunctionsCodeUnitIDVisible;
                }
                field("Default Value Bool Yes"; "Default Value Bool Yes")
                {
                }
                field("Default Value Bool No"; "Default Value Bool No")
                {
                }
                field(Separator; Separator)
                {
                    Visible = BooGSeparatorVisible;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1100294003; Links)
            {
                Visible = false;
            }
            systempart(Control1100294001; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Action1100294002)
            {
                Caption = 'Partner';
                action(Action1100294008)
                {
                    Caption = 'Sending Message List';
                    Promoted = true;
                    RunObject = Page "Sending Message List";
                    RunPageLink = Partner Code=FIELD(Code);
                    ShortCutKey = 'Shift+Ctrl+M';
                }
                action(Action1100294012)
                {
                    Caption = 'Receiving Message List';
                    Promoted = true;
                    RunObject = Page "Receiving Message List";
                                    RunPageLink = Partner Code=FIELD(Code);
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnInit()
    begin
        BooGFunctionsCodeUnitIDVisible := TRUE;
        BooGObjectIDRunVisible := TRUE;
        BooGReplyQueueVisible := TRUE;
        BooGReceiveQueueVisible := TRUE;
        BooGSeparatorVisible := TRUE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord;
    end;

    var
        [InDataSet]
        BooGFunctionsCodeUnitIDVisible: Boolean;
        [InDataSet]
        BooGObjectIDRunVisible: Boolean;
        [InDataSet]
        BooGReplyQueueVisible: Boolean;
        [InDataSet]
        BooGReceiveQueueVisible: Boolean;
        [InDataSet]
        BooGSeparatorVisible: Boolean;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        BooGSeparatorVisible           := "Data Format" = "Data Format"::"with separator";
        BooGReceiveQueueVisible        := "Communication Mode" = "Communication Mode"::MSMQ;
        BooGReplyQueueVisible          := "Communication Mode" = "Communication Mode"::MSMQ;
        BooGObjectIDRunVisible         := "Communication Mode" = "Communication Mode"::MSMQ;
        BooGFunctionsCodeUnitIDVisible := "Communication Mode" = "Communication Mode"::MSMQ;
    end;
}

