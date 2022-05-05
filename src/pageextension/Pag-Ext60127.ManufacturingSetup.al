pageextension 60127 "PWD ManufacturingSetup" extends "Manufacturing Setup"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_PROD03.001: NI 07/12/2011:  Conformité qualité cloture OF
    //                                           - Design fields 50000, 50001 on Tab [Planning]
    // 
    // //>>LAP2.05
    // FE_LAPIERRETTE_PRO12.001: GR 09/10/2012: Non Conformite
    //                                          Remove Field
    //                                           "Non conformity Prod. Location"
    // 
    // FE_LAPIERRETTE_NDT01.001: LY 17/04/2013:  New Demand
    //                                           Add Group "Job Queue"
    // 
    // //>>REGIE
    // P24578_005 : LALE.RO : 24/10/2018 Demande par Mail
    //                - Add Tab Impression
    // 
    // 
    // ------------------------------------------------------------------------------------------------------------------
    layout
    {
        addafter("Default Dampener %")
        {
            field("PWD Mach. center - Inventory input"; Rec."PWD Mach. center - Inventory input")
            {
                ApplicationArea = All;
            }
            group("PWD Job Queue")
            {
                Caption = 'Job Queue';
                field("PWD Calc. Type"; Rec."PWD Calc. Type")
                {
                    ApplicationArea = All;
                }
                field("PWD Starting Date Calc."; Rec."PWD Starting Date Calc.")
                {
                    ApplicationArea = All;
                }
                field("PWD Ending Date Calc."; Rec."PWD Ending Date Calc.")
                {
                    ApplicationArea = All;
                }
                field("PWD MPS"; Rec."PWD MPS")
                {
                    ApplicationArea = All;
                }
                field("PWD MRP"; Rec."PWD MRP")
                {
                    ApplicationArea = All;
                }
                field("PWD Use Forecast"; Rec."PWD Use Forecast")
                {
                    ApplicationArea = All;
                }
                field("PWD Exclude Before"; Rec."PWD Exclude Before")
                {
                    ApplicationArea = All;
                }
            }
            group("PWD Impression")
            {
                Caption = 'Impression';
                field("PWD PDF Exe Path"; Rec."PWD PDF Exe Path")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}

