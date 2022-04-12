table 50097 "PWD Routing Header BKP"
{
    Caption = 'Routing Header';
    DataCaptionFields = "No.", Description;
    DrillDownPageID = "Routing List";
    LookupPageID = "Routing List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(3; "Description 2"; Text[30])
        {
            Caption = 'Description 2';
        }
        field(4; "Search Description"; Code[50])
        {
            Caption = 'Search Description';
        }
        field(10; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(12; Comment; Boolean)
        {
            CalcFormula = Exist("Manufacturing Comment Line" WHERE("Table Name" = CONST("Routing Header"),
                                                                    "No." = FIELD("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'New,Certified,Under Development,Closed';
            OptionMembers = New,Certified,"Under Development",Closed;
        }
        field(21; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Serial,Parallel';
            OptionMembers = Serial,Parallel;
        }
        field(50; "Version Nos."; Code[10])
        {
            Caption = 'Version Nos.';
            TableRelation = "No. Series";
        }
        field(51; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Search Description")
        {
        }
        key(Key3; Description)
        {
        }
        key(Key4; Status)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Description, Status)
        {
        }
    }

    trigger OnDelete()
    var
        Item: Record Item;
        RtngLine: Record "Routing Line";
        MfgComment: Record "Manufacturing Comment Line";
    begin
    end;

    var
        Text000: Label 'This Routing is being used on Items.';
        Text001: Label 'All versions attached to the routing will be closed. Close routing?';
        MfgSetup: Record "Manufacturing Setup";
        RoutingHeader: Record "Routing Header";
        RtngVersion: Record "Routing Version";
        CheckRouting: Codeunit "Check Routing Lines";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Text002: Label 'You cannot rename the %1 when %2 is %3.';


    procedure AssistEdit(OldRtngHeader: Record "Routing Header"): Boolean
    begin
    end;
}

