report 50046 "PWD TPL Supp Centre de charge"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.20
    // P24578_007 : RO 03/09/2019 : New report
    // 
    // ------------------------------------------------------------------------------------------------------------------

    ProcessingOnly = true;

    dataset
    {
        dataitem("Work Center"; "Work Center")
        {
            DataItemTableView = SORTING("No.") WHERE("No." = FILTER('CPERSON'));

            trigger OnAfterGetRecord()
            begin
                if "Work Center"."No." = 'CPERSON' then begin

                    RecGCalendarEntry.SetCurrentKey("Capacity Type", "No.");
                    RecGCalendarEntry.SetRange("Capacity Type", RecGCalendarEntry."Capacity Type"::"Work Center");
                    RecGCalendarEntry.SetRange("No.", "Work Center"."No.");
                    RecGCalendarEntry.DeleteAll();

                    RecGCalAbsentEntry.SetCurrentKey("Capacity Type", "No.");
                    RecGCalAbsentEntry.SetRange("Capacity Type", RecGCalendarEntry."Capacity Type"::"Work Center");
                    RecGCalAbsentEntry.SetRange("No.", "Work Center"."No.");
                    RecGCalAbsentEntry.DeleteAll();

                    RecGMfgCommentLine.SetRange("Table Name", RecGMfgCommentLine."Table Name"::"Work Center");
                    RecGMfgCommentLine.SetRange("No.", "Work Center"."No.");
                    RecGMfgCommentLine.DeleteAll();

                    // if CduGApplicationManagement.CheckPlannerOneLicence then begin  //TODO: CodeUnit 1 n'existe pas dans la nouvelle version
                    //     RecGPlannerOneParameters.SetRange(Type, RecGPlannerOneParameters.Type::"Work Center");  //TODO: Numero de Table 8076517 
                    //     RecGPlannerOneParameters.SetRange("No.", "Work Center"."No.");  //TODO: Numero de Table 8076517 
                    //     RecGPlannerOneParameters.DeleteAll;  //TODO: Numero de Table 8076517 
                    // end;

                    "Work Center".Delete();
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Control1000000000)
                {
                    Caption = 'Import';
                    ShowCaption = false;
                    field(TxtGFile; TxtGFile)
                    {
                        Caption = 'Fichier à importer';
                        ShowCaption = false;
                        ApplicationArea = All;
                        trigger OnLookup(var Text: Text): Boolean
                        var
                        // CduLCommonDialogMgt: CodeUnit "Common Dialog Management";//TODO: Codeunit n'existe pas(code standard dans la version 2009)
                        begin
                            // TxtGFile := CduLCommonDialogMgt.OpenFile('Fichier à importer', TxtGFile, 1, 'Filter', 0);//TODO: Codeunit n'existe pas(code standard dans la version 2009)
                        end;
                    }
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

    trigger OnPostReport()
    begin
        Message('traitement terminé');
    end;

    trigger OnPreReport()
    begin
        FilGFileToImport.TextMode(false);
        FilGFileToImport.Open(TxtGFile);
        FilGFileToImport.CreateInStream(InsGDataFileInstream);
        BDialog.Open('Centre de charge #1###############');
        while not (InsGDataFileInstream.EOS) do begin
            InsGDataFileInstream.ReadText(TxtGReadLine);

            BDialog.Update(1, TxtGReadLine);

            if RecGMachineCenter.Get(TxtGReadLine) then begin

                RecGCalendarEntry.SetCurrentKey("Capacity Type", "No.");
                RecGCalendarEntry.SetRange("Capacity Type", RecGCalendarEntry."Capacity Type"::"Machine Center");
                RecGCalendarEntry.SetRange("No.", RecGMachineCenter."No.");
                RecGCalendarEntry.DeleteAll();

                RecGCalAbsentEntry.SetCurrentKey("Capacity Type", "No.");
                RecGCalAbsentEntry.SetRange("Capacity Type", RecGCalendarEntry."Capacity Type"::"Machine Center");
                RecGCalAbsentEntry.SetRange("No.", RecGMachineCenter."No.");
                RecGCalAbsentEntry.DeleteAll();

                RecGMfgCommentLine.SetRange("Table Name", RecGMfgCommentLine."Table Name"::"Machine Center");
                RecGMfgCommentLine.SetRange("No.", RecGMachineCenter."No.");
                RecGMfgCommentLine.DeleteAll();

                // if CduGApplicationManagement.CheckPlannerOneLicence then begin  //TODO: CodeUnit 1 n'existe pas dans la nouvelle version
                //     RecGPlannerOneParameters.SetRange(Type, RecGPlannerOneParameters.Type::"Machine Center");//TODO: Numero de Table 8076517 
                //     RecGPlannerOneParameters.SetRange("No.", RecGMachineCenter."No.");//TODO: Numero de Table 8076517 
                //     RecGPlannerOneParameters.DeleteAll;//TODO: Numero de Table 8076517 
                // end;

                RecGMachineCenter.Delete();
            end;
        end;
        BDialog.Close();
    end;

    var
        RecGCalAbsentEntry: Record "Calendar Absence Entry";
        RecGCalendarEntry: Record "Calendar Entry";
        RecGMachineCenter: Record "Machine Center";
        RecGMfgCommentLine: Record "Manufacturing Comment Line";
        // RecGPlannerOneParameters: Record PlannerOneMachineSetupParam; //TODO: Numero de Table 8076517 
        // CduGApplicationManagement: Codeunit ApplicationManagement; //TODO: CodeUnit 1 n'existe pas dans la nouvelle version
        BDialog: Dialog;
        FilGFileToImport: File;
        InsGDataFileInstream: InStream;
        TxtGReadLine: Text[30];
        TxtGFile: Text[255];
}

