tableextension 60011 "PWD ItemJournalLine" extends "Item Journal Line"
{
    //TODO: modification dans procedure OpenItemTrackingLines à faire
    // +----------------------------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                                         |
    // | www.prodware.fr                                                                                                                  |
    // +----------------------------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_PROD02.001: NI 28/11/2011:  Commentaire sur feuille production
    //                                           - Add field 50000
    // 
    // FE_LAPIERRETTE_PROD03.001: NI 07/12/2011:  Conformité qualité cloture OF
    //                                           - Add field 50001
    //                                           - C/AL Added in trigger Conform quality control - OnValidate()
    //                                                                   No. - OnValidate()
    //                                           - Add function FctGetLocationCode
    //                                                          FctGetProdOrderLine
    // 
    // FE_LAPIERRETTE_PROD03.002:GR 22/03/2012: Conformité qualité cloture OF
    //                                          - Modify  No. - OnValidate()
    // 
    // FE_LAPIERRETTE_PROD01.001: TO 13/12/2011:  No Commande vente identique OF-LOT
    //                                           - C/AL Added in function item
    // 
    // //>>LAP2.05
    // FE_LAPIERRETTE_PRO12.001: GR 09/10/2012: Non Conformite
    //                                          Deactivate code on Non Conformity Location Code
    //                                          Keep "Conform quality control" by Default to True
    // 
    // //>>LAP2.06
    // FE_LAPRIERRETTE_GP0003 : APA 16/05/13 Add Field "Phantom Item"
    //                                           - Modify No. - OnValidate()
    // 
    // +----------------------------------------------------------------------------------------------------------------------------------+
    fields
    {
        field(50000; "PWD Quartis Comment"; Code[5])
        {
            Caption = 'Quartis Comment';
            Description = 'LAP1.00';
            TableRelation = "PWD Quartis Comment".Code;
        }
        field(50001; "PWD Conform quality control"; Boolean)
        {
            Caption = 'Conform quality control';
            Description = 'LAP1.00';
            InitValue = true;
        }
        field(50100; "PWD LPSA description 1"; Text[120])
        {
            CalcFormula = Lookup(Item."PWD LPSA Description 1" WHERE("No." = FIELD("Item No.")));
            Caption = 'LPSA Description 1';
            Description = 'SU';
            FieldClass = FlowField;
        }
    }

    procedure FctGetLocationCode(CodPProdOrderNo: Code[20]; IntPProdOrderLine: Integer; BooPConformQuality: Boolean): Code[10]
    var
        ManufacturingSetup: Record "Manufacturing Setup";
        ProdOrderLine: Record "Prod. Order Line";
    begin
        IF BooPConformQuality THEN
            IF ProdOrderLine.GET(ProdOrderLine.Status::Released, CodPProdOrderNo, IntPProdOrderLine) THEN
                EXIT(ProdOrderLine."Location Code")
            ELSE
                EXIT('')
        ELSE
            IF ManufacturingSetup.GET() THEN BEGIN
                ManufacturingSetup.TESTFIELD("PWD Non conformity Prod. Loca.");
                EXIT(ManufacturingSetup."PWD Non conformity Prod. Loca.");
            end ELSE
                EXIT('');
    end;

    procedure FctGetProdOrderLine(CodPProdOrderNo: Code[20]; IntPProdOrderLine: Integer): Code[10]
    var
        ProdOrderLine: Record "Prod. Order Line";
    begin
        IF ProdOrderLine.GET(ProdOrderLine.Status::Released, CodPProdOrderNo, IntPProdOrderLine) THEN
            EXIT(ProdOrderLine."Location Code")
    end;

    procedure FctSetFromOsys()
    var
        FromOsys: Boolean;
    begin
        FromOsys := TRUE;
    end;
}

