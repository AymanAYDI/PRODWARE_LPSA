tableextension 60011 "PWD ItemJournalLine" extends "Item Journal Line"
{
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

            trigger OnValidate()
            var
                RecLProdOrderLine: Record "Prod. Order Line";
                RecLManufSetup: Record "Manufacturing Setup";
                RecLProductionOrder: Record "Production Order";
            begin
                //>>FE_LAPIERRETTE_PRO12.001
                /*
                //>>FE_LAPIERRETTE_PROD03.002
                //>>FE_LAPIERRETTE_PROD03.001
                TESTFIELD("Entry Type","Entry Type"::Output);
                IF "Conform quality control" THEN
                BEGIN
                  IF RecLProductionOrder.GET(RecLProductionOrder.Status::Released,"Prod. Order No.") THEN
                  BEGIN
                    IF RecLProdOrderLine.GET(RecLProdOrderLine.Status::Released,
                    "Prod. Order No.","Prod. Order Line No.") THEN
                    BEGIN
                
                      RecLProdOrderLine.VALIDATE("Location Code",RecLProductionOrder."Location Code");
                      RecLProdOrderLine.MODIFY(TRUE);
                      "Location Code" := RecLProductionOrder."Location Code";
                      //<<FE_LAPIERRETTE_PRO12.001
                    END;
                  END;
                END
                ELSE
                BEGIN
                  IF NOT(BooGFromOsys) THEN
                    "Location Code" := FctGetLocationCode("Prod. Order No.","Prod. Order Line No.","Conform quality control");
                END;
                //<<FE_LAPIERRETTE_PROD03.001
                //<<FE_LAPIERRETTE_PROD03.002
                */
                //>>FE_LAPIERRETTE_PRO12.001

            end;
        }
        field(50100; "PWD LPSA description 1"; Text[120])
        {
            CalcFormula = Lookup(Item."PWD LPSA Description 1" WHERE("No." = FIELD("Item No.")));
            Caption = 'LPSA Description 1';
            Description = 'SU';
            FieldClass = FlowField;
        }
    }
}

