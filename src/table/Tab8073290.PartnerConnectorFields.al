table 8073290 "PWD Partner Connector Fields"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.06
    // OSYS-Int001.001:GR 18/10/2011   Connector integration
    //                                   - Create Object
    // 
    // +----------------------------------------------------------------------------------------------------------------+

    Caption = 'Partner Connector Fields';

    fields
    {
        field(1; "Partner Code"; Code[20])
        {
            Caption = 'Partner Code';
            TableRelation = "PWD Partner Connector".Code;
        }
        field(2; "Table ID"; Integer)
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
                IF FrmLObjects.RUNMODAL = ACTION::LookupOK THEN BEGIN
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
        field(3; "Field ID"; Integer)
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
                IF FrmLFields.RUNMODAL = ACTION::LookupOK THEN BEGIN
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

                "Field Type" := FORMAT(RecLField.Type);
                "Field Lenght" := RecLField.Len;
            end;
        }
        field(10; "Table Name"; Text[80])
        {
            CalcFormula = Lookup(Object.Name WHERE(ID = FIELD("Table ID"), Type = CONST(Table)));
            Caption = 'Table Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Field Name"; Text[80])
        {
            CalcFormula = Lookup(Field.FieldName WHERE(TableNo = FIELD("Table ID"), "No." = FIELD("Field ID")));
            Caption = 'Field Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Field Type"; Code[20])
        {
            Caption = 'Field Type';
            Editable = false;
        }
        field(13; "Field Lenght"; Integer)
        {
            Caption = 'Field Lenght';
            Editable = false;
        }
        field(14; "Max Lenght Error"; Option)
        {
            Caption = 'Action when max lenght';
            OptionCaption = 'Error log,Truncate';
            OptionMembers = Error,Truncate;
        }
        field(15; "Max Lenght"; Integer)
        {
            Caption = 'Max Lenght';
        }
    }

    keys
    {
        key(Key1; "Partner Code", "Table ID", "Field ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

