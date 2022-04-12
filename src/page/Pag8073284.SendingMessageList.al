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
                }
                field("Table ID"; "Table ID")
                {
                }
                field("Table Name"; "Table Name")
                {
                }
                field("Xml Tag"; "Xml Tag")
                {
                    Visible = BooGXmlTagVisible;
                }
                field(Function; "Function")
                {
                }
                field(Description; Description)
                {
                }
                field(Path; Path)
                {
                }
                field("Fill Character"; "Fill Character")
                {
                    Visible = BooGFillCharVisible;
                }
                field("Field ID"; "Field ID")
                {
                    Visible = BooGVisible;
                }
                field("Field Name"; "Field Name")
                {
                    Visible = BooGVisible;
                }
                field("Export Option"; "Export Option")
                {
                    Visible = BooGVisible;
                }
                field("Master Table"; "Master Table")
                {
                }
                field("Archive Message"; "Archive Message")
                {
                }
                field(Blocked; Blocked)
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
            systempart(Control1100294004; Notes)
            {
                Visible = false;
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
        FctShowColumns;
    end;

    var
        [InDataSet]
        BooGXmlTagVisible: Boolean;
        [InDataSet]
        BooGFillCharVisible: Boolean;
        [InDataSet]
        BooGVisible: Boolean;


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
        IF FINDFIRST THEN;
        BooGVisible := (Direction = Direction::Export) AND (RecLPartner."Communication Mode" = RecLPartner."Communication Mode"::File);
        //<<WMS-FE10.001
    end;
}

