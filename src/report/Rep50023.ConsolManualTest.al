report 50023 "PWD Consol Manual Test"
{
    Caption = 'Consol Manual Test';
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
            OptGTreatment::Export:
                CduGFileExportLauncher.Run(RecGJobQueueEntry);
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
        OptGTreatment: Option Export,Import,Buffer,Validation;
        RecGJobQueueEntry: Record "Job Queue Entry";
        CduGFileExportLauncher: Codeunit "File Export Launcher";
        CduGFileImportLauncher: Codeunit "File Import Launcher";
        CduGValidationBatch: Codeunit "Connectors Validation Batch";
        CduGBuffersProcessBatchLaunche: Codeunit "Buffers Process Batch Launcher";
}

