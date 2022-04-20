tableextension 60066 "PWD ManufacturingSetup" extends "Manufacturing Setup"
{
    // +----------------------------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                                         |
    // | www.prodware.fr                                                                                                                  |
    // +----------------------------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_PROD03.001: NI 07/12/2011:  Conformité qualité cloture OF
    //                                           - Add fields 50000,50001
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_PROD03.002: GR 01/03/2012:  Conformité qualité cloture OF
    //                                            Modify Field 50001
    //                                             Work center - Inventory input become Mach. center - Inventory input
    //                                             Table Relation To Machine center
    // 
    // //>>LAP2.05
    // FE_LAPIERRETTE_PRO12.001: GR 09/10/2012: Non Conformite
    //                                          Deactivate Field
    //                                           "Non conformity Prod. Location"
    // 
    // FE_LAPIERRETTE_NDT01.001: LY 17/04/2013:  New Demand
    //                                           Add fields 50002..50008
    // 
    // 
    // //>>REGIE
    // P24578_005 : LALE.RO : 24/10/2018 Demande par Mail
    //                - Add Field 50009 - PDF Exe Path - Text250
    // 
    // 
    // +----------------------------------------------------------------------------------------------------------------------------------+
    fields
    {
        field(50000; "PWD Non conformity Prod. Location"; Code[10])
        {
            Caption = 'Non conformity Prod. Location';
            Description = 'LAP1.00//LAP2.05';
            Enabled = false;
            TableRelation = Location.Code;
        }
        field(50001; "PWD Mach. center - Inventory input"; Code[10])
        {
            Caption = 'Machine center - Inventory input';
            Description = 'LAP2.01';
            TableRelation = "Machine Center"."No.";
        }
        field(50002; "PWD Calc. Type"; Option)
        {
            Caption = 'Calculation Type';
            Description = 'LAP2.05';
            InitValue = "Net Change";
            OptionCaption = 'Net Change,Regenerative';
            OptionMembers = "Net Change",Regenerative;
        }
        field(50003; "PWD Starting Date Calc."; DateFormula)
        {
            Caption = 'Starting Date Calculation';
            Description = 'LAP2.05';
        }
        field(50004; "PWD Ending Date Calc."; DateFormula)
        {
            Caption = 'Ending Date Calculation';
            Description = 'LAP2.05';
        }
        field(50005; "PWD MPS"; Boolean)
        {
            Caption = 'MPS';
            Description = 'LAP2.05';
        }
        field(50006; "PWD MRP"; Boolean)
        {
            Caption = 'MRP';
            Description = 'LAP2.05';
        }
        field(50007; "PWD Use Forecast"; Code[10])
        {
            Caption = 'Use Forecast';
            Description = 'LAP2.05';
            TableRelation = "Production Forecast Name".Name;
        }
        field(50008; "PWD Exclude Before"; Date)
        {
            Caption = 'Exclude Forecast Before';
            Description = 'LAP2.05';
        }
        field(50009; "PWD PDF Exe Path"; Text[250])
        {
            Caption = 'Chemin de l''éxécutable PDF';
        }

    }
}
