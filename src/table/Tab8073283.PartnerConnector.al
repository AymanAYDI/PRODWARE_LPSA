table 8073283 "PWD Partner Connector"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect.1.00
    // FE_ProdConnect.001:GR 22/03/2011  Connector integration
    //                                   - Create Object
    // 
    // //>>ProdConnect.1.5
    // WMS-FE10.001:GR 01/07/2011   Connector integration
    //                              - Add Fields "Default Value Bool Yes" and "Default Value Bool No"
    // 
    // 
    // +----------------------------------------------------------------------------------------------------------------+

    Caption = 'Partner Connector List';
    DrillDownPageID = "PWD Partner Code List";
    LookupPageID = "PWD Partner Code List";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(3; Blocked; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
        }
        field(4; "Receive Queue"; Text[100])
        {
            Caption = 'Receive Queue';
            DataClassification = CustomerContent;
        }
        field(5; "Reply Queue"; Text[100])
        {
            Caption = 'Reply Queue';
            DataClassification = CustomerContent;
        }
        field(6; "Data Format"; Option)
        {
            Caption = 'Data Format';
            OptionCaption = 'Xml,with separator,File Position';
            OptionMembers = Xml,"with separator","File Position";
            DataClassification = CustomerContent;
        }
        field(7; Separator; Text[1])
        {
            Caption = 'Separator';
            DataClassification = CustomerContent;
        }
        field(8; "Object ID to Run"; Integer)
        {
            Caption = 'Object ID to Run';
            TableRelation = AllObjWithCaption."Object ID";
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                RecLObject: Record "Object";
                FrmLObjects: Page Objects;
            begin
                IF RecLObject.GET(RecLObject.Type::Codeunit, '', "Object ID to Run") THEN;
                RecLObject.FILTERGROUP(2);
                RecLObject.SETRANGE(Type, RecLObject.Type::Codeunit);
                RecLObject.FILTERGROUP(0);
                FrmLObjects.SETRECORD(RecLObject);
                FrmLObjects.SETTABLEVIEW(RecLObject);
                FrmLObjects.LOOKUPMODE := TRUE;
                IF FrmLObjects.RUNMODAL() = ACTION::LookupOK THEN BEGIN
                    FrmLObjects.GETRECORD(RecLObject);
                    VALIDATE("Object ID to Run", RecLObject.ID);
                END;
            end;

            trigger OnValidate()
            var
                RecLObject: Record "Object";
            begin
                IF "Object ID to Run" <> 0 THEN
                    RecLObject.GET(RecLObject.Type::Codeunit, '', "Object ID to Run");
                CALCFIELDS("Object Name to Run");
            end;
        }
        field(9; "Object Name to Run"; Text[250])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object ID" = FIELD("Object ID to Run"), "Object Type" = CONST(Codeunit)));
            Caption = 'Object Name to Run';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Communication Mode"; Option)
        {
            Caption = 'Communication Mode';
            OptionCaption = ' ,MSMQ,File,Web Service';
            OptionMembers = " ",MSMQ,File,"Web Service";
            DataClassification = CustomerContent;
        }
        field(11; "Functions CodeUnit ID"; Integer)
        {
            Caption = 'Functions CodeUnit ID';
            TableRelation = AllObjWithCaption."Object ID";
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                RecLObject: Record "Object";
                FrmLObjects: Page Objects;
            begin
                IF RecLObject.GET(RecLObject.Type::Codeunit, '', "Functions CodeUnit ID") THEN;
                RecLObject.FILTERGROUP(2);
                RecLObject.SETRANGE(Type, RecLObject.Type::Codeunit);
                RecLObject.FILTERGROUP(0);
                FrmLObjects.SETRECORD(RecLObject);
                FrmLObjects.SETTABLEVIEW(RecLObject);
                FrmLObjects.LOOKUPMODE := TRUE;
                IF FrmLObjects.RUNMODAL() = ACTION::LookupOK THEN BEGIN
                    FrmLObjects.GETRECORD(RecLObject);
                    VALIDATE("Functions CodeUnit ID", RecLObject.ID);
                END;
            end;

            trigger OnValidate()
            var
                RecLObject: Record "Object";
            begin
                IF "Object ID to Run" <> 0 THEN
                    RecLObject.GET(RecLObject.Type::Codeunit, '', "Functions CodeUnit ID");
                CALCFIELDS("Functions CodeUnit Name");
            end;
        }
        field(12; "Functions CodeUnit Name"; Text[250])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object ID" = FIELD("Functions CodeUnit ID"), "Object Type" = CONST(Codeunit)));
            Caption = 'Functions CodeUnit Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; "Default Value Bool Yes"; Text[10])
        {
            Caption = 'Default Value for Boolean: Yes';
            DataClassification = CustomerContent;
        }
        field(14; "Default Value Bool No"; Text[10])
        {
            Caption = 'Default Value for Boolean: No';
            DataClassification = CustomerContent;
        }
        field(30; "FTP Active"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(31; "FTP HostName/IP"; Text[80])
        {
            DataClassification = CustomerContent;
        }
        field(32; "FTP Port No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(33; "FTP Login"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(34; "FTP Password"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(35; "FTP Binary Mode"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(36; "FTP Passive Mode"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        RecLSendingMessage: Record "PWD Connector Messages";
    begin
        RecLSendingMessage.RESET();
        RecLSendingMessage.SETRANGE("Partner Code", Code);
        RecLSendingMessage.DELETEALL(TRUE);
    end;
}

