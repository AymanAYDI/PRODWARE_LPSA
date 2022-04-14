report 50049 "PWD Import Stock Test"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.22
    // P24578_009: RO : 12/12/2019 : cf Demande par mail
    //                   - New Report
    // 
    // ------------------------------------------------------------------------------------------------------------------

    Caption = 'Import Stock Test';
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                label(Control1100267000)
                {
                    Caption = 'ATTENTION pour les tests manuels l''étape d''export doit être lancée impérativement en RTC et l''étape d''import doit être lancée impérativement en Classique';
                    ApplicationArea = All;
                }
                label(Control1100267001)
                {
                    ShowCaption = false;
                    ApplicationArea = All;
                }
                field(OptGTreatment; OptGTreatment)
                {
                    Caption = 'Traitement à lancer';
                    ApplicationArea = All;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        case OptGTreatment of
            OptGTreatment::Import:
                CduGFileImportLauncher.Run(RecGJobQueueEntry);
            OptGTreatment::Buffer:
                CduGBuffersProcessBatchLaunche.Run(RecGJobQueueEntry);
            OptGTreatment::Validation:
                CduGValidationBatch.Run(RecGJobQueueEntry);
        end;
        Message('Traitement terminé');
    end;

    var
        OptGTreatment: Option " ",Import,Buffer,Validation;
        RecGJobQueueEntry: Record "Job Queue Entry";
        CduGFileExportLauncher: Codeunit "File Export Launcher";
        CduGFileImportLauncher: Codeunit "File Import Launcher";
        CduGValidationBatch: Codeunit "Connectors Validation Batch";
        CduGBuffersProcessBatchLaunche: Codeunit "Buffers Process Batch Launcher";
}

