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
    UsageCategory = none;
    SourceTable = "PWD Partner Connector";

    layout
    {
        area(content)
        {
            group("Général")
            {
                Caption = 'Général';
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Communication Mode"; Rec."Communication Mode")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        BooGSeparatorVisible := Rec."Data Format" = Rec."Data Format"::"with separator";
                        BooGReceiveQueueVisible := Rec."Communication Mode" = Rec."Communication Mode"::MSMQ;
                        BooGReplyQueueVisible := Rec."Communication Mode" = Rec."Communication Mode"::MSMQ;
                        BooGObjectIDRunVisible := Rec."Communication Mode" = Rec."Communication Mode"::MSMQ;
                        BooGFunctionsCodeUnitIDVisible := Rec."Communication Mode" = Rec."Communication Mode"::MSMQ;
                    end;
                }
                field("Data Format"; Rec."Data Format")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        BooGSeparatorVisible := Rec."Data Format" = Rec."Data Format"::"with separator";
                    end;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                }
                field("Receive Queue"; Rec."Receive Queue")
                {
                    Visible = BooGReceiveQueueVisible;
                    ApplicationArea = All;
                }
                field("Reply Queue"; Rec."Reply Queue")
                {
                    Visible = BooGReplyQueueVisible;
                    ApplicationArea = All;
                }
                field("Object ID to Run"; Rec."Object ID to Run")
                {
                    Visible = BooGObjectIDRunVisible;
                    ApplicationArea = All;
                }
                field("Object Name to Run"; Rec."Object Name to Run")
                {
                    Visible = BooGObjectIDRunVisible;
                    ApplicationArea = All;
                }
                field("Functions CodeUnit ID"; Rec."Functions CodeUnit ID")
                {
                    Visible = BooGFunctionsCodeUnitIDVisible;
                    ApplicationArea = All;
                }
                field("Functions CodeUnit Name"; Rec."Functions CodeUnit Name")
                {
                    Visible = BooGFunctionsCodeUnitIDVisible;
                    ApplicationArea = All;
                }
                field("Default Value Bool Yes"; Rec."Default Value Bool Yes")
                {
                    ApplicationArea = All;
                }
                field("Default Value Bool No"; Rec."Default Value Bool No")
                {
                    ApplicationArea = All;
                }
                field(Separator; Rec.Separator)
                {
                    Visible = BooGSeparatorVisible;
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1100294003; Links)
            {
                Visible = false;
                ApplicationArea = All;
            }
            systempart(Control1100294001; Notes)
            {
                Visible = false;
                ApplicationArea = All;
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
                    RunObject = Page "PWD Sending Message List";
                    RunPageLink = "Partner Code" = FIELD(Code);
                    ApplicationArea = All;
                    ShortCutKey = 'Shift+Ctrl+M';
                    Image= SendMail;
                }
                action(Action1100294012)
                {
                    Caption = 'Receiving Message List';
                    Promoted = true;
                    RunObject = Page "PWD Receiving Message List";
                    RunPageLink = "Partner Code" = FIELD(Code);
                    ApplicationArea = All;
                    Image= SendMail;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord();
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
        OnAfterGetCurrRecord();
    end;

    var
        [InDataSet]
        BooGFunctionsCodeUnitIDVisible: Boolean;
        [InDataSet]
        BooGObjectIDRunVisible: Boolean;
        [InDataSet]
        BooGReceiveQueueVisible: Boolean;
        [InDataSet]
        BooGReplyQueueVisible: Boolean;
        [InDataSet]
        BooGSeparatorVisible: Boolean;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        BooGSeparatorVisible := Rec."Data Format" = Rec."Data Format"::"with separator";
        BooGReceiveQueueVisible := Rec."Communication Mode" = Rec."Communication Mode"::MSMQ;
        BooGReplyQueueVisible := Rec."Communication Mode" = Rec."Communication Mode"::MSMQ;
        BooGObjectIDRunVisible := Rec."Communication Mode" = Rec."Communication Mode"::MSMQ;
        BooGFunctionsCodeUnitIDVisible := Rec."Communication Mode" = Rec."Communication Mode"::MSMQ;
    end;
}

