tableextension 60022 "PWD ReasonCode" extends "Reason Code"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.5.1
    // WMS-FE009.001:GR  20/11/2011   Connector management
    //                                - Add Field  : "WMS Code"
    // +----------------------------------------------------------------------------------------------------------------+
    fields
    {
        field(8073282; "PWD WMS Code"; Code[2])
        {
            Caption = 'WMS Code';
            Description = 'ProdConnect1.5';
            Numeric = true;
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                IntLWMSCompany: Integer;
            begin
                if ("PWD WMS Code" <> '') and (StrLen("PWD WMS Code") < 2) then begin
                    Evaluate(IntLWMSCompany, "PWD WMS Code");
                    if IntLWMSCompany < 10 then
                        "PWD WMS Code" := '0' + "PWD WMS Code";
                end;
            end;
        }
    }
}

