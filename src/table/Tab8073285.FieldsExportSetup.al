table 8073285 "PWD Fields Export Setup"
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
    // WMS-FE10.001:GR 01/07/2011:   Connector integration
    //                               - Add new fields : Direction
    //                                  Type
    //                                  Format
    //                                  Precision
    //                                  Function
    //                                  "Fill up"
    //                                  "Fill Character"
    //                                  "Rounding Direction"
    //                                  "Fct For Replace"
    //                                  "Constant Value"
    //                                  "Field Type"
    // 
    //                               - Add field Direction to primary key
    //                               - C\AL in function SetUpNewLine
    //                               - C\AL in function FctInsertAllFields
    //                               - C\AL in Field ID - OnValidate()
    // +----------------------------------------------------------------------------------------------------------------+

    Caption = 'Paramètres export champs';

    fields
    {
        field(1; "Partner Code"; Code[20])
        {
            Caption = 'Partner Code';
            TableRelation = "PWD Partner Connector".Code;
        }
        field(2; "Message Code"; Code[20])
        {
            Caption = 'Message Code';
            TableRelation = "PWD Connector Messages".Code;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Table ID"; Integer)
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
            end;
        }
        field(5; "Table Name"; Text[80])
        {
            CalcFormula = Lookup(Object.Name WHERE(ID = FIELD("Table ID"), Type = CONST(Table)));
            Caption = 'Table Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Field ID"; Integer)
        {
            Caption = 'Field ID';
            TableRelation = Field."No." WHERE(TableNo = FIELD("Table ID"));

            trigger OnLookup()
            var
                RecLField: Record "Field";
                FrmLFields: Page "Fields Lookup";
            begin
                IF RecLField.GET("Field ID", "Table ID") THEN;
                RecLField.FILTERGROUP(2);
                RecLField.SETRANGE(TableNo, "Table ID");
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

                //>>WMS-FE10.001
                Type := FORMAT(RecLField.Type);
                //<<WMS-FE10.001

                "Xml Tag" := FctNormalizeString("Field Name");
            end;
        }
        field(7; "Field Name"; Text[80])
        {
            CalcFormula = Lookup(Field.FieldName WHERE(TableNo = FIELD("Table ID"), "No." = FIELD("Field ID")));
            Caption = 'Field Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Xml Tag"; Text[30])
        {
            Caption = 'Xml Tag';
            Editable = true;
        }
        field(9; "File Position"; Integer)
        {
            Caption = 'File Position';
        }
        field(10; "File Length"; Integer)
        {
            Caption = 'File Length';
        }
        field(11; Direction; Option)
        {
            Caption = 'Direction';
            OptionCaption = 'Import,Export';
            OptionMembers = Import,Export;
        }
        field(12; Type; Code[20])
        {
            FieldClass = Normal;
        }
        field(13; FormatStr; Text[100])
        {
            Caption = 'Format';
        }
        field(14; Precision; Decimal)
        {
            Caption = 'Precision';
        }
        field(15; "Rounding Direction"; Option)
        {
            Caption = 'Rounding Direction';
            OptionCaption = '=,<,>';
            OptionMembers = "=","<",">";
        }
        field(16; "Fill up"; Option)
        {
            Caption = 'Fill up';
            OptionCaption = 'Left,Right';
            OptionMembers = Left,Right;
        }
        field(17; "Fill Character"; Text[1])
        {
            Caption = 'Fill Character';
            Editable = false;
        }
        field(18; "Fct For Replace"; Text[30])
        {
            Caption = 'Fonction For Replacement';
        }
        field(19; Function; Code[30])
        {
            Caption = 'Function';
            Editable = false;
        }
        field(20; "Field Type"; Option)
        {
            Caption = 'Field Type';
            OptionCaption = 'Field,Constant';
            OptionMembers = Champ,Constante;
        }
        field(21; "Constant Value"; Text[30])
        {
            Caption = 'Constant Value';
        }
    }

    keys
    {
        key(Key1; "Partner Code", "Message Code", Direction, "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "File Position")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
    end;


    procedure SetUpNewLine(RecPFieldsExportSetup: Record "PWD Fields Export Setup")
    var
        RecLSendingMessage: Record "PWD Connector Messages";
    begin
        //>>WMS-FE10.001
        IF RecLSendingMessage.GET("Partner Code", "Message Code", Direction) THEN BEGIN
            VALIDATE("Fill Character", RecLSendingMessage."Fill Character");
            VALIDATE("Function", RecLSendingMessage."Function");
        END;
        //<<WMS-FE10.001

        IF RecPFieldsExportSetup."Table ID" <> 0 THEN
            VALIDATE("Table ID", RecPFieldsExportSetup."Table ID")
        ELSE
            VALIDATE("Table ID", RecLSendingMessage."Table ID");
    end;


    procedure FctNormalizeString(TxtPStringToNormalize: Text[30]): Text[30]
    var
        ChrLChar: Char;
        IntLI: Integer;
    begin
        FOR IntLI := 0 TO 48 DO BEGIN
            ChrLChar := IntLI;
            TxtPStringToNormalize := DELCHR(TxtPStringToNormalize, '=', FORMAT(ChrLChar));
        END;
        FOR IntLI := 123 TO 255 DO BEGIN
            ChrLChar := IntLI;
            TxtPStringToNormalize := DELCHR(TxtPStringToNormalize, '=', FORMAT(ChrLChar));
        END;
        EXIT('F_' + TxtPStringToNormalize)
    end;


    procedure FctInsertAllFields()
    var
        RecLFields: Record "Field";
        RecLFieldsExportSetup: Record "PWD Fields Export Setup";
        IntLLineNo: Integer;
        CstL000: Label 'Import';
    begin
        RecLFieldsExportSetup.COPYFILTERS(Rec);
        RecLFieldsExportSetup.DELETEALL();
        RecLFields.RESET();
        RecLFields.SETRANGE(TableNo, "Table ID");
        RecLFields.FINDSET();
        REPEAT
            IntLLineNo += 10000;
            RecLFieldsExportSetup."Line No." := IntLLineNo;


            RecLFieldsExportSetup."Partner Code" := GETFILTER("Partner Code");
            RecLFieldsExportSetup."Message Code" := GETFILTER("Message Code");

            //>>WMS-FE10.001
            IF (GETFILTER(Direction) = CstL000) THEN
                RecLFieldsExportSetup.Direction := Direction::Import
            ELSE
                RecLFieldsExportSetup.Direction := Direction::Export;
            //<<WMS-FE10.001

            RecLFieldsExportSetup.VALIDATE("Table ID", "Table ID");
            RecLFieldsExportSetup.VALIDATE("Field ID", RecLFields."No.");
            RecLFieldsExportSetup.INSERT();
        UNTIL RecLFields.NEXT() = 0;
    end;


    procedure FctVerifyPosition(RecPFieldsExportSetup: Record "PWD Fields Export Setup")
    var
        RecLFieldsExportSetup: Record "PWD Fields Export Setup";
        RecLFieldsExportSetupOther: Record "PWD Fields Export Setup";
        BooLVerifOK: Boolean;
        IntLCurrentPosition: Integer;
        CstLBadPosition: Label 'Field %1 with position %2 has a position already reserved. ';
        CstLBadPosOtherPart: Label 'For information, Message Code %1 has a field defined in position %2,wich is in conflict with the current position %3. ';
        CstLOK: Label 'No error detetected';
    begin
        BooLVerifOK := TRUE;

        RecLFieldsExportSetup.RESET();
        RecLFieldsExportSetup.SETCURRENTKEY("File Position");
        RecLFieldsExportSetup.SETRANGE("Partner Code", RecPFieldsExportSetup."Partner Code");
        RecLFieldsExportSetup.SETRANGE("Function", RecPFieldsExportSetup."Function");
        RecLFieldsExportSetup.SETRANGE("Message Code", RecPFieldsExportSetup."Message Code");
        IntLCurrentPosition := 0;
        IF RecLFieldsExportSetup.FINDFIRST() THEN
            REPEAT
                IF RecLFieldsExportSetup."File Position" <= IntLCurrentPosition THEN
                    ERROR(STRSUBSTNO(CstLBadPosition, RecLFieldsExportSetup."Field ID", RecLFieldsExportSetup."File Position"))
                ELSE
                    IntLCurrentPosition += RecLFieldsExportSetup."File Length";
            UNTIL RecLFieldsExportSetup.NEXT() = 0;


        RecLFieldsExportSetup.RESET();
        RecLFieldsExportSetup.SETCURRENTKEY("File Position");
        RecLFieldsExportSetup.SETRANGE("Partner Code", RecPFieldsExportSetup."Partner Code");
        RecLFieldsExportSetup.SETRANGE("Function", RecPFieldsExportSetup."Function");
        RecLFieldsExportSetup.SETRANGE("Message Code", RecPFieldsExportSetup."Message Code");
        IF RecLFieldsExportSetup.FINDFIRST() THEN
            REPEAT
                RecLFieldsExportSetupOther.RESET();
                RecLFieldsExportSetupOther.SETCURRENTKEY("File Position");
                RecLFieldsExportSetupOther.SETRANGE("Partner Code", RecLFieldsExportSetup."Partner Code");
                RecLFieldsExportSetupOther.SETRANGE("Function", RecLFieldsExportSetup."Function");
                RecLFieldsExportSetupOther.SETFILTER("Message Code", '<>%1', RecLFieldsExportSetup."Message Code");
                IF RecLFieldsExportSetupOther.FINDFIRST() THEN
                    REPEAT
                        IF ((((RecLFieldsExportSetupOther."File Position" + RecLFieldsExportSetupOther."File Length") >
                          RecLFieldsExportSetup."File Position") AND
                          (RecLFieldsExportSetupOther."File Position" < RecLFieldsExportSetup."File Position"))
                          OR
                          ((((RecLFieldsExportSetupOther."File Position" + RecLFieldsExportSetupOther."File Length") <
                          (RecLFieldsExportSetup."File Position" + RecLFieldsExportSetup."File Length")) AND
                          (RecLFieldsExportSetupOther."File Position" > RecLFieldsExportSetup."File Position") AND
                          (RecLFieldsExportSetupOther."File Position" <
                          (RecLFieldsExportSetup."File Position" + RecLFieldsExportSetup."File Length")))))
                          OR
                          ((RecLFieldsExportSetupOther."File Position" > RecLFieldsExportSetup."File Position") AND
                          ((RecLFieldsExportSetupOther."File Position" + RecLFieldsExportSetupOther."File Length") <
                            (RecLFieldsExportSetup."File Position" + RecLFieldsExportSetup."File Length")))
                        THEN BEGIN
                            MESSAGE(STRSUBSTNO(CstLBadPosOtherPart, RecLFieldsExportSetupOther."Message Code", RecLFieldsExportSetupOther."File Position",
                                               RecLFieldsExportSetup."File Position"));
                            BooLVerifOK := FALSE;
                        END;
                    UNTIL RecLFieldsExportSetupOther.NEXT() = 0;
            UNTIL RecLFieldsExportSetup.NEXT() = 0;

        IF BooLVerifOK THEN
            MESSAGE(CstLOK);
    end;
}

