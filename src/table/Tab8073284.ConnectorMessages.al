table 8073284 "PWD Connector Messages"
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
    //                               - Add Fields : Direction
    //                                              "Export Date"
    //                                              "Field ID"
    //                                              "Field Name"
    //                                              "Field ID"
    //                                              "Master Table"
    //                                              "Export Option"
    //                                              "Auto-Post Document"
    // 
    //                               - Add field Direction to primary key
    //                               - Change name of field 4
    // 
    // //>>ProdConnect1.5.1
    // FTP.001:GR 20/11/2011 :  Connector integration
    //                          - Add Fields  :
    //                            "FTP Remote Path"
    //                            "FTP Filter File"
    // 
    // FE_ProdConnect.002:GR 20/11/2011  Connector integration
    //                                   - Add field: "File Name value", "File Name with Date", "File Name with Time",
    //                                     "File Name with Society Code"
    // 
    // //>>ProdConnect1.07
    // WMS-EBL1-003.001:GR 13/12/2011  Connector management
    //                              -  Add field "File extension"
    // 
    // 
    // //>>LAP2.06
    // FE_LAPRIERRETTE_GP0004.001 :GR  23/05/13 add Field :   Export DateTime
    // 
    // 
    // +----------------------------------------------------------------------------------------------------------------+

    Caption = 'Connector Messages';
    LookupPageID = "PWD Sending Message List";

    fields
    {
        field(1; "Partner Code"; Code[20])
        {
            Caption = 'Partner Code';
            TableRelation = "PWD Partner Connector".Code;
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(4; Path; Text[250])
        {
            Caption = 'Path';

            trigger OnLookup()
            var
                i: Integer;
                InboxDetails: Text[250];
                InboxDetails2: Text[250];
                CstLTxt001: Label 'File Location for files';
                FileName: Text;
            begin
                if Path = '' then
                    FileName := StrSubstNo('%1.xml', Code)
                else
                    FileName := Path + StrSubstNo('\%1.xml', Code);
            end;
        }
        field(5; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(6; "Archive Message"; Boolean)
        {
            InitValue = true;
        }
        field(7; Function; Code[30])
        {
            Caption = 'Function';
        }
        field(8; "Table ID"; Integer)
        {
            Caption = 'Table ID';

            trigger OnLookup()
            var
                RecLObject: Record "Object";
                FrmLObjects: Page Objects;
            begin
                IF RecLObject.GET(RecLObject.Type::Table, '', "Table ID") THEN;
                RecLObject.FILTERGROUP(2);
                RecLObject.SETRANGE(Type, RecLObject.Type::Table);
                RecLObject.FILTERGROUP(0);
                FrmLObjects.SETRECORD(RecLObject);
                FrmLObjects.SETTABLEVIEW(RecLObject);
                FrmLObjects.LOOKUPMODE := TRUE;
                IF FrmLObjects.RUNMODAL() = ACTION::LookupOK THEN BEGIN
                    FrmLObjects.GETRECORD(RecLObject);
                    VALIDATE("Table ID", RecLObject.ID);
                END;
            end;

            trigger OnValidate()
            var
                RecLObject: Record "Object";
            begin
                IF "Table ID" <> 0 THEN
                    RecLObject.GET(RecLObject.Type::Table, '', "Table ID");
                CALCFIELDS("Table Name");
                "Xml Tag" := FctNormalizeString("Table Name");
            end;
        }
        field(9; "Table Name"; Text[80])
        {
            CalcFormula = Lookup(Object.Name WHERE(ID = FIELD("Table ID"), Type = CONST(Table)));
            Caption = 'Table Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Xml Tag"; Text[30])
        {
            Caption = 'Xml Tag';
            Editable = true;
        }
        field(11; Direction; Option)
        {
            Caption = 'Direction';
            OptionCaption = 'Import,Export';
            OptionMembers = Import,Export;
        }
        field(12; "Fill Character"; Text[1])
        {
            Caption = 'Fill Character';
        }
        field(13; "Export Date"; Date)
        {
            Caption = 'Export Date';
        }
        field(14; "Field ID"; Integer)
        {
            Caption = 'Last Date Modified Field';
            TableRelation = Field."No." WHERE(TableNo = FIELD("Table ID"));

            trigger OnLookup()
            var
                RecLField: Record "Field";
                FrmLFields: Page "Fields Lookup";
            begin
                IF RecLField.GET("Field ID", "Table ID") THEN;
                RecLField.FILTERGROUP(2);
                RecLField.SETRANGE(TableNo, "Table ID");
                RecLField.SETRANGE(RecLField.Type, RecLField.Type::Date);
                RecLField.FILTERGROUP(0);
                FrmLFields.SETRECORD(RecLField);
                FrmLFields.SETTABLEVIEW(RecLField);
                FrmLFields.LOOKUPMODE := TRUE;
                FrmLFields.EDITABLE := FALSE;
                IF FrmLFields.RUNMODAL() = ACTION::LookupOK THEN BEGIN
                    FrmLFields.GETRECORD(RecLField);
                    VALIDATE("Field ID", RecLField."No.");
                END;
            end;

            trigger OnValidate()
            var
                RecLField: Record "Field";
            begin
                IF ("Table ID" <> 0) AND ("Field ID" <> 0) THEN
                    RecLField.GET("Table ID", "Field ID");

                CALCFIELDS("Field Name");
            end;
        }
        field(15; "Field Name"; Text[30])
        {
            CalcFormula = Lookup(Field.FieldName WHERE(TableNo = FIELD("Table ID"), "No." = FIELD("Field ID")));
            Caption = 'Last Date Modified Field Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; "Master Table"; Boolean)
        {
            Caption = 'Master Table';
        }
        field(17; "Export Option"; Option)
        {
            Caption = 'Export Option';
            OptionCaption = 'Total,Partial';
            OptionMembers = Total,Partial;

            trigger OnValidate()
            begin
                //IF "Export Option" =  "Export Option"::Partial THEN
                //  TESTFIELD("Field ID");
            end;
        }
        field(18; "Auto-Post Document"; Boolean)
        {
            Caption = 'Auto-Post Document';
        }
        field(19; "Archive Path"; Text[250])
        {
            Caption = 'Archive Path';

            trigger OnLookup()
            var
                i: Integer;
                InboxDetails: Text[250];
                InboxDetails2: Text[250];
                CstLTxt001: Label 'File Location for files';
                FileName: Text;
            begin
                if "Archive Path" = '' then
                    FileName := StrSubstNo('%1.xml', Code)
                else
                    FileName := "Archive Path" + StrSubstNo('\%1.xml', Code);
            end;
        }
        field(30; "FTP Remote Path"; Text[250])
        {
            Caption = 'FTP Remote Path';
        }
        field(31; "FTP Filter File"; Text[30])
        {
            Caption = 'FTP Filter File';
        }
        field(32; "File Name value"; Text[50])
        {
            Caption = 'File Name value';
        }
        field(33; "File Name with Date"; Boolean)
        {
            Caption = 'File Name with Date';
        }
        field(34; "File Name with Time"; Boolean)
        {
            Caption = 'File Name with Time';
        }
        field(35; "File Name with Society Code"; Boolean)
        {
            Caption = 'File Name with Society Code';
        }
        field(36; "File extension"; Text[5])
        {
            Caption = 'File extension';
        }
        field(50000; "Export DateTime"; DateTime)
        {
            Caption = 'Export DateTime';
        }
    }

    keys
    {
        key(Key1; "Partner Code", "Code", Direction)
        {
            Clustered = true;
        }
        key(Key2; "Master Table")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        RecLFieldsExport: Record "PWD Fields Export Setup";
    begin
        RecLFieldsExport.RESET();
        RecLFieldsExport.SETRANGE("Partner Code", "Partner Code");
        RecLFieldsExport.SETRANGE("Message Code", Code);
        RecLFieldsExport.SETRANGE("Table ID", "Table ID");
        RecLFieldsExport.DELETEALL(TRUE);
    end;

    trigger OnModify()
    var
        RecLFieldsExport: Record "PWD Fields Export Setup";
    begin
        //>>WMS-FE10.001
        IF "Fill Character" <> xRec."Fill Character" THEN BEGIN
            RecLFieldsExport.RESET();
            RecLFieldsExport.SETRANGE("Partner Code", "Partner Code");
            RecLFieldsExport.SETRANGE("Message Code", Code);
            RecLFieldsExport.SETRANGE("Table ID", "Table ID");
            IF RecLFieldsExport.FINDSET() THEN
                REPEAT
                    RecLFieldsExport."Fill Character" := "Fill Character";
                    RecLFieldsExport.MODIFY(TRUE);
                UNTIL RecLFieldsExport.NEXT() = 0;
        END;
        IF "Function" <> xRec."Function" THEN BEGIN
            RecLFieldsExport.RESET();
            RecLFieldsExport.SETRANGE("Partner Code", "Partner Code");
            RecLFieldsExport.SETRANGE("Message Code", Code);
            RecLFieldsExport.SETRANGE("Table ID", "Table ID");
            IF RecLFieldsExport.FINDSET() THEN
                REPEAT
                    RecLFieldsExport."Function" := "Function";
                    RecLFieldsExport.MODIFY(TRUE);
                UNTIL RecLFieldsExport.NEXT() = 0;
        END;

        //<<WMS-FE10.001
    end;


    procedure FctNormalizeString(TxtPStringToNormalize: Text[30]): Text[30]
    var
        IntLI: Integer;
        ChrLChar: Char;
    begin
        FOR IntLI := 0 TO 48 DO BEGIN
            ChrLChar := IntLI;
            TxtPStringToNormalize := DELCHR(TxtPStringToNormalize, '=', FORMAT(ChrLChar));
        END;
        FOR IntLI := 123 TO 255 DO BEGIN
            ChrLChar := IntLI;
            TxtPStringToNormalize := DELCHR(TxtPStringToNormalize, '=', FORMAT(ChrLChar));
        END;
        EXIT('T_' + TxtPStringToNormalize)
    end;
}

