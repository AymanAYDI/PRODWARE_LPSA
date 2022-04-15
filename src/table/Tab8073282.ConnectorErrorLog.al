table 8073282 "PWD Connector Error Log"
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
    // +----------------------------------------------------------------------------------------------------------------+

    Caption = 'Connector Error Log';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Date"; Date)
        {
            Caption = 'Date';
        }
        field(3; Hour; Time)
        {
            Caption = 'Hour';
        }
        field(4; ErrorType; Option)
        {
            Caption = 'ErrorType';
            OptionCaption = 'Information ,Warning,Blocking';
            OptionMembers = " ",Warning,Blocking;
        }
        field(5; "Connector Partner"; Code[20])
        {
            Caption = 'Connector Partner';
        }
        field(6; "Flow Type"; Option)
        {
            Caption = 'Flow Type';
            OptionCaption = ',Import Connector,Export Connector';
            OptionMembers = " ","Import Connector","Export Connector";
        }
        field(8; "Buffer Message No."; Integer)
        {
            Caption = 'Buffer Message No.';
        }
        field(10; "Message"; Text[250])
        {
            Caption = 'Message';
        }
        field(11; "User ID"; Code[20])
        {
            Caption = 'User ID';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; Date)
        {
        }
        key(Key3; "Buffer Message No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        RecLICError: Record "PWD Connector Error Log";
    begin
        if RecLICError.FindLast() then
            "Entry No." := RecLICError."Entry No." + 1
        else
            "Entry No." := 1;

        Date := Today;
        Hour := Time;
        "User ID" := UserId;
    end;
}

