page 8073284 "PWD Sending Message List"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.00
    // FE_ProdConnect.001:GR 22/03/2011  Connector integration
    //                                   - Create Object
    // 
    // //>>ProdConnect1.5
    // WMS-FE10.001:GR 01/07/2011   Connector integration
    //                              - Add Fields : Direction
    //                                             "Export Date"
    //                                             "Field ID"
    //                                             "Field Name"
    //                                             "Master Table"
    //                                             "Export Option"
    //                             - Change Form SourceTableView
    //                             - Change Formlink in Action Fields Setup
    //                             - Add Field "Fill Character"
    // 
    // +----------------------------------------------------------------------------------------------------------------+

    Caption = 'Sending Message List';
    PageType = List;
    PopulateAllFields = false;
    UsageCategory = none;
    SourceTable = "PWD Connector Messages";
    SourceTableView = SORTING("Partner Code", Code, Direction) ORDER(Ascending) WHERE(Direction = FILTER(Export));

    layout
    {
        area(content)
        {
            repeater(Control1100294000)
            {
                ShowCaption = false;
                field("Code"; Code)
                {
                    ApplicationArea = All;
                }
                field("Table ID"; "Table ID")
                {
                    ApplicationArea = All;
                }
                field("Table Name"; "Table Name")
                {
                    ApplicationArea = All;
                }
                field("Xml Tag"; "Xml Tag")
                {
                    Visible = BooGXmlTagVisible;
                    ApplicationArea = All;
                }
                field(Function; "Function")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Path; Path)
                {
                    ApplicationArea = All;
                }
                field("Fill Character"; "Fill Character")
                {
                    Visible = BooGFillCharVisible;
                    ApplicationArea = All;
                }
                field("Field ID"; "Field ID")
                {
                    Visible = BooGVisible;
                    ApplicationArea = All;
                }
                field("Field Name"; "Field Name")
                {
                    Visible = BooGVisible;
                    ApplicationArea = All;
                }
                field("Export Option"; "Export Option")
                {
                    Visible = BooGVisible;
                    ApplicationArea = All;
                }
                field("Master Table"; "Master Table")
                {
                    ApplicationArea = All;
                }
                field("Archive Message"; "Archive Message")
                {
                    ApplicationArea = All;
                }
                field(Blocked; Blocked)
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
            systempart(Control1100294004; Notes)
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
            group(Action1100294012)
            {
                Caption = 'Message';
                action(Action1100294014)
                {
                    Caption = 'Fields Setup';
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "PWD Fields Export Setup";
                    RunPageLink = "Partner Code" = FIELD("Partner Code"), "Message Code" = FIELD(Code), "Table ID" = FIELD("Table ID"), Direction = FIELD(Direction);
                    ShortCutKey = 'Shift+Ctrl+F';
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnInit()
    begin
        BooGXmlTagVisible := TRUE;
    end;

    trigger OnOpenPage()
    begin
        FctShowColumns();
    end;

    var
        [InDataSet]
        BooGFillCharVisible: Boolean;
        [InDataSet]
        BooGVisible: Boolean;
        [InDataSet]
        BooGXmlTagVisible: Boolean;


    procedure FctShowColumns()
    var
        RecLPartner: Record "PWD Partner Connector";
    begin
        //>>WMS-FE10.001
        BooGFillCharVisible := FALSE;
        BooGXmlTagVisible := TRUE;
        IF RecLPartner.GET("Partner Code") THEN
            CASE RecLPartner."Data Format" OF
                RecLPartner."Data Format"::Xml:
                    BooGXmlTagVisible := TRUE;
                RecLPartner."Data Format"::"File Position":
                    BEGIN
                        BooGXmlTagVisible := FALSE;
                        BooGFillCharVisible := TRUE;
                    END;
                RecLPartner."Data Format"::"with separator":
                    BooGXmlTagVisible := FALSE;
            END;
        IF FINDFIRST() THEN;
        BooGVisible := (Direction = Direction::Export) AND (RecLPartner."Communication Mode" = RecLPartner."Communication Mode"::File);
        //<<WMS-FE10.001
    end;
}

