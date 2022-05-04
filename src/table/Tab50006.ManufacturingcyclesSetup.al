table 50006 "PWD Manufacturing cycles Setup"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_PROD04.001: NI 13/12/2011:  FRAPPES - Temps de cycle incompressible
    //                                           - Create Table
    // ------------------------------------------------------------------------------------------------------------------

    Caption = 'Manufacturig cycles Setup';
    LookupPageID = "PWD Manuf. cycles Setup - List";

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Work Center,Machine Center';
            OptionMembers = "Work Center","Machine Center";

            trigger OnValidate()
            begin
                case Type of
                    Type::"Work Center":
                        if RecGWorkCenter.Get("No.") then begin
                            Name := RecGWorkCenter.Name;
                            "Setup Time Unit of Meas. Code" := RecGWorkCenter."Unit of Measure Code";
                            "Run Time Unit of Meas. Code" := RecGWorkCenter."Unit of Measure Code";
                        end else begin
                            Name := '';
                            "Setup Time Unit of Meas. Code" := '';
                            "Run Time Unit of Meas. Code" := '';
                        end;
                    Type::"Machine Center":

                        if RecGMachineCenter.Get("No.") then begin
                            Name := RecGMachineCenter.Name;
                            if RecGWorkCenter.Get(RecGMachineCenter."Work Center No.") then begin
                                "Setup Time Unit of Meas. Code" := RecGWorkCenter."Unit of Measure Code";
                                "Run Time Unit of Meas. Code" := RecGWorkCenter."Unit of Measure Code";
                            end
                            else begin
                                "Setup Time Unit of Meas. Code" := '';
                                "Run Time Unit of Meas. Code" := '';
                            end;
                        end else begin
                            Name := '';
                            "Setup Time Unit of Meas. Code" := '';
                            "Run Time Unit of Meas. Code" := '';
                        end;
                end;
            end;
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type = CONST("Work Center")) "Work Center"
            ELSE
            IF (Type = CONST("Machine Center")) "Machine Center";

            trigger OnValidate()
            begin
                case Type of
                    Type::"Work Center":

                        if RecGWorkCenter.Get("No.") then begin
                            Name := RecGWorkCenter.Name;
                            "Setup Time Unit of Meas. Code" := RecGWorkCenter."Unit of Measure Code";
                            "Run Time Unit of Meas. Code" := RecGWorkCenter."Unit of Measure Code";
                        end else begin
                            Name := '';
                            "Setup Time Unit of Meas. Code" := '';
                            "Run Time Unit of Meas. Code" := '';
                        end;
                    Type::"Machine Center":

                        if RecGMachineCenter.Get("No.") then begin
                            Name := RecGMachineCenter.Name;
                            if RecGWorkCenter.Get(RecGMachineCenter."Work Center No.") then begin
                                "Setup Time Unit of Meas. Code" := RecGWorkCenter."Unit of Measure Code";
                                "Run Time Unit of Meas. Code" := RecGWorkCenter."Unit of Measure Code";
                            end
                            else begin
                                "Setup Time Unit of Meas. Code" := '';
                                "Run Time Unit of Meas. Code" := '';
                            end;
                        end else begin
                            Name := '';
                            "Setup Time Unit of Meas. Code" := '';
                            "Run Time Unit of Meas. Code" := '';
                        end;
                end;
            end;
        }
        field(3; "Item Code"; Code[20])
        {
            Caption = 'Item Code';
            TableRelation = Item;
        }
        field(4; Name; Text[30])
        {
            Caption = 'Name';
            Editable = false;
            FieldClass = Normal;
        }
        field(5; "Item Category Code"; Code[10])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(12; "Setup Time"; Decimal)
        {
            Caption = 'Setup Time';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(13; "Run Time"; Decimal)
        {
            Caption = 'Run Time';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(19; "Setup Time Unit of Meas. Code"; Code[10])
        {
            Caption = 'Setup Time Unit of Meas. Code';
            Editable = false;
            TableRelation = "Capacity Unit of Measure";
        }
        field(20; "Run Time Unit of Meas. Code"; Code[10])
        {
            Caption = 'Run Time Unit of Meas. Code';
            Editable = false;
            TableRelation = "Capacity Unit of Measure";
        }
        field(21; "Maximun Quantity by cycle"; Decimal)
        {
            Caption = 'Maximun Quantity by cycle';

            trigger OnValidate()
            begin
                if ("Maximun Quantity by cycle" <> 0) and ("Qty - Units of Measure" <> '') then
                    FctCalcQtyBase()
                else
                    "Maximun Qty by cycle (Base)" := 0;
            end;
        }
        field(22; "Qty - Units of Measure"; Code[10])
        {
            Caption = 'Units of Measure';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item Code"));

            trigger OnValidate()
            begin
                if ("Maximun Quantity by cycle" <> 0) and ("Qty - Units of Measure" <> '') then
                    FctCalcQtyBase()
                else
                    "Maximun Qty by cycle (Base)" := 0;
            end;
        }
        field(24; "Maximun Qty by cycle (Base)"; Decimal)
        {
            Caption = 'Maximun Qty by cycle (Base)';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; Type, "No.", "Item Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        RecGMachineCenter: Record "Machine Center";
        RecGWorkCenter: Record "Work Center";

    procedure FctCalcQtyBase()
    var
        RecLItemUnitOfMeasure: Record "Item Unit of Measure";
    begin
        if RecLItemUnitOfMeasure.Get("Item Code", "Qty - Units of Measure") then
            "Maximun Qty by cycle (Base)" := Round("Maximun Quantity by cycle" * RecLItemUnitOfMeasure."Qty. per Unit of Measure", 0.00001);
    end;
}

