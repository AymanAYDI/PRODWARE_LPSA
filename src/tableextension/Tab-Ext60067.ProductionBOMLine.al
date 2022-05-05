tableextension 60067 "PWD ProductionBOMLine" extends "Production BOM Line"
{
    // <changelog>
    //   <add id="CH1390" dev="SRYSER" request="CH-START-370" date="2004-02-25" area="SWS39"
    //   releaseversion="CH3.70A">Field 12 Size 30 -> 50</add>
    // </changelog>
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.5
    // WMS-FE03.001:GR  01/07/2011   Connector integration : Kit
    //                              - Add field:  "WMS_Quantity_Per(Base)"
    //                                            "WMS_Item"
    //                                            "WMS_Status"
    // 
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_PROD01.001: TO 13/12/2011:  No Commande vente identique OF-LOT
    //                                           - Add field 50000
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    fields
    {
        field(50000; "PWD Lot Determining"; Boolean)
        {
            Caption = 'Lot Determining';
            Description = 'LAP1.00';

            trigger OnValidate()
            var
                Item2: Record Item;
                LotDeterminingBOMLine: Record "Production BOM Line";
                LotInheritanceMgt: Codeunit "PWD Lot Inheritance Mgt.PW";
                NeededHits: Integer;
                CstG001: label 'Item %1 at Production BOM %2, Version %3 is already Lot Determining.';

            begin
                TestStatus();
                IF "PWD Lot Determining" THEN BEGIN
                    TESTFIELD(Type, Type::Item);
                    Item2.GET("No.");
                    Item2.IsLotItem(/*piForceError=*/ TRUE);
                    //  TESTFIELD("From the same Lot", TRUE);

                    LotDeterminingBOMLine := Rec;
                    NeededHits := 0;
                    //ProdBOMVersion.GET("Production BOM No.", "Version Code");

                    IF LotInheritanceMgt.CheckBOMDetermining(LotDeterminingBOMLine, NeededHits) THEN
                        ERROR(
                          CstG001, LotDeterminingBOMLine."No.", LotDeterminingBOMLine."Production BOM No.",
                          LotDeterminingBOMLine."Version Code");
                END;

            end;
        }
        field(8073282; "PWD WMS_Quantity_Per(Base)"; Decimal)
        {
            Caption = 'WMS Quantity Per (Base)';
            Description = 'ProdConnect1.5';
        }
        field(8073283; "PWD WMS_Item"; Boolean)
        {
            CalcFormula = Lookup(Item."PWD WMS_Item" WHERE("No." = FIELD("No.")));
            Caption = 'WMS_Item';
            Description = 'ProdConnect1.5';
            FieldClass = FlowField;
        }
        field(8073284; "PWD WMS_Status"; Enum "BOM Status")
        {
            CalcFormula = Lookup("Production BOM Header".Status WHERE("No." = FIELD("Production BOM No."),
                                                                       "Version Nos." = FIELD("Version Code")));
            Caption = 'Status';
            FieldClass = FlowField;
        }

    }
}
