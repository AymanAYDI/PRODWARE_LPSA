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

                    if CduGApplicationManagement.CheckPlannerOneLicence then begin
                        RecGPlannerOneParameters.SetRange(Type, RecGPlannerOneParameters.Type::"Work Center");
                        RecGPlannerOneParameters.SetRange("No.", "Work Center"."No.");
                        RecGPlannerOneParameters.DeleteAll;
                    end;

                    "Work Center".Delete();
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
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

                if CduGApplicationManagement.CheckPlannerOneLicence then begin
                    RecGPlannerOneParameters.SetRange(Type, RecGPlannerOneParameters.Type::"Machine Center");
                    RecGPlannerOneParameters.SetRange("No.", RecGMachineCenter."No.");
                    RecGPlannerOneParameters.DeleteAll;
                end;

                RecGMachineCenter.Delete();
            end;
        end;
        BDialog.Close();
    end;

    var
        TxtGFile: Text[255];
        RecGMachineCenter: Record "Machine Center";
        RecGCalendarEntry: Record "Calendar Entry";
        RecGCalAbsentEntry: Record "Calendar Absence Entry";
        RecGMfgCommentLine: Record "Manufacturing Comment Line";
        RecGPlannerOneParameters: Record PlannerOneMachineSetupParam;
        FilGFileToImport: File;
        InsGDataFileInstream: InStream;
        TxtGReadLine: Text[30];
        CduGApplicationManagement: Codeunit ApplicationManagement;
        BDialog: Dialog;
}

