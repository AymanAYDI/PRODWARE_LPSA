table 8073288 "PWD WMS Setup"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // //>>ProdConnect1.05
    // WMS-FE10.001:GR 29/06/2011   Connector integration
    //                              - Create Object
    // 
    // //>>ProdConnect1.6
    // OSYS-Int001.001:GR 18/10/2011   Connector integration
    //                                 - Add Field :  Partner Code
    // +----------------------------------------------------------------------------------------------------------------+

    Caption = 'WMS Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[20])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(2; WMS; Boolean)
        {
            Caption = 'WMS';
            DataClassification = CustomerContent;
        }
        field(3; "WMS Company Code"; Code[2])
        {
            Caption = 'WMS Company Code';
            Numeric = true;
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                IntLWMSCompany: Integer;
            begin
                if ("WMS Company Code" <> '') and (StrLen("WMS Company Code") < 2) then begin
                    Evaluate(IntLWMSCompany, "WMS Company Code");
                    if IntLWMSCompany < 10 then
                        "WMS Company Code" := '0' + "WMS Company Code";
                end;
            end;
        }
        field(4; "Location Mandatory"; Boolean)
        {
            Caption = 'Location Mandatory';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                RecLInventorySetup: Record "Inventory Setup";
            begin
                RecLInventorySetup.Get();
                RecLInventorySetup."Location Mandatory" := "Location Mandatory";
                RecLInventorySetup.Modify();
            end;
        }
        field(5; "WMS Delivery"; Code[10])
        {
            Caption = 'WMS Delivery Code';
            DataClassification = CustomerContent;
        }
        field(6; "WMS Shipment"; Code[10])
        {
            Caption = 'WMS Shipment Code';
            DataClassification = CustomerContent;
        }
        field(7; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Item Journal Template";
            DataClassification = CustomerContent;
        }
        field(8; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Item Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Template Name"));
            DataClassification = CustomerContent;
        }
        field(9; "Partner Code"; Code[20])
        {
            Caption = 'Partner Code';
            TableRelation = "PWD Partner Connector".Code;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

