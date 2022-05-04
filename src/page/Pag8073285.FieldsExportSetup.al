page 8073285 "PWD Fields Export Setup"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // //>>ProdConnect.1.00
    // FE_ProdConnect.001:GR 22/03/2011  Connector integration
    //                                   - Create Object
    // 
    // //>>ProdConnect1.5
    // WMS-FE10.001:GR 01/07/2011   Connector integration
    //                              - Add new fields : Type
    //                                                 Format
    //                                                 Precision
    //                                                "Fill up"
    //                                                "Fill Character"
    //                                                "Rounding Direction"
    //                                                "Fct For Replace"
    //                                                "Field Type"
    //                                                "Constant Value"
    //                                                Add "Check Position" button
    // 
    // +----------------------------------------------------------------------------------------------------------------+

    AutoSplitKey = true;
    Caption = 'Fields Export Setup';
    DelayedInsert = true;
    PageType = List;
    UsageCategory = none;
    PopulateAllFields = true;
    SourceTable = "PWD Fields Export Setup";

    layout
    {
        area(content)
        {
            repeater(Control1100294000)
            {
                ShowCaption = false;
                field("Field ID"; "Field ID")
                {
                    ApplicationArea = All;
                }
                field("Field Name"; "Field Name")
                {
                    ApplicationArea = All;
                }
                field(Type; Type)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Field Type"; "Field Type")
                {
                    ApplicationArea = All;
                }
                field("Constant Value"; "Constant Value")
                {
                    ApplicationArea = All;
                }
                field("Xml Tag"; "Xml Tag")
                {
                    Visible = BooGXmlTagVisible;
                    ApplicationArea = All;
                }
                field("File Position"; "File Position")
                {
                    Visible = BooGFilePositionVisible;
                    ApplicationArea = All;
                }
                field("File Length"; "File Length")
                {
                    Visible = BooGFileLengthVisible;
                    ApplicationArea = All;
                }
                field(FormatStr; FormatStr)
                {
                    ApplicationArea = All;
                }
                field(Precision; Precision)
                {
                    ApplicationArea = All;
                }
                field("Rounding Direction"; "Rounding Direction")
                {
                    ApplicationArea = All;
                }
                field("Fill up"; "Fill up")
                {
                    Visible = BooGFillupVisible;
                    ApplicationArea = All;
                }
                field("Fill Character"; "Fill Character")
                {
                    Visible = BooGFillCharacterVisible;
                    ApplicationArea = All;
                }
                field("Fct For Replace"; "Fct For Replace")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1100294002; Links)
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
            action(Action1000000000)
            {
                Caption = 'Insert All';
                Image = Trace;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    FctInsertAllFields();
                end;
            }
            action("<Action1000000000>")
            {
                Caption = 'Check All Position';
                Image = Trace;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    FctVerifyPosition(Rec);
                end;
            }
        }
    }

    trigger OnInit()
    begin
        BooGFileLengthVisible := TRUE;
        BooGFilePositionVisible := TRUE;
        BooGXmlTagVisible := TRUE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetUpNewLine(xRec);
    end;

    trigger OnOpenPage()
    begin
        FctShowColumns();
    end;

    var
        [InDataSet]
        BooGFileLengthVisible: Boolean;
        [InDataSet]
        BooGFilePositionVisible: Boolean;
        [InDataSet]
        BooGFillCharacterVisible: Boolean;
        [InDataSet]
        BooGFillupVisible: Boolean;
        [InDataSet]
        BooGXmlTagVisible: Boolean;


    procedure FctShowColumns()
    var
        RecLPartner: Record "PWD Partner Connector";
    begin
        //>>WMS-FE10.001
        BooGXmlTagVisible := FALSE;
        BooGFilePositionVisible := FALSE;
        BooGFillupVisible := FALSE;
        BooGFileLengthVisible := FALSE;
        BooGFillCharacterVisible := FALSE;

        IF RecLPartner.GET("Partner Code") THEN
            CASE RecLPartner."Data Format" OF
                RecLPartner."Data Format"::Xml:
                    BooGXmlTagVisible := TRUE;
                RecLPartner."Data Format"::"File Position":
                    BEGIN
                        BooGFilePositionVisible := TRUE;
                        BooGFileLengthVisible := TRUE;
                        BooGFillupVisible := TRUE;
                        BooGFillCharacterVisible := TRUE;
                    END;
            END;
        //<<WMS-FE10.001
    end;
}

