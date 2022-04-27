pageextension 60124 "PWD RoutingList" extends "Routing List"
{
    layout
    {
        addafter(Description)
        {
            field("PWD Search Description"; "Search Description")
            {
                ApplicationArea = All;
            }
        }
        addafter("Last Date Modified")
        {
            field("PWD ActiveVersionCode"; ActiveVersionCode)
            {
                Caption = 'Active Version';
                Editable = false;
                ApplicationArea = All;

                trigger OnLookup(var Text: Text): Boolean
                var
                    RtngVersion: Record "Routing Version";
                begin
                    RtngVersion.SETRANGE("Routing No.", "No.");
                    RtngVersion.SETRANGE("Version Code", ActiveVersionCode);
                    PAGE.RUNMODAL(PAGE::"Routing Version", RtngVersion);
                    ActiveVersionCode := VersionMgt.GetRtngVersion("No.", WORKDATE, TRUE);
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        ActiveVersionCode := VersionMgt.GetRtngVersion("No.", WORKDATE, TRUE);
    end;

    var
        VersionMgt: Codeunit VersionManagement;
        ActiveVersionCode: Code[20];

}

