codeunit 50005 "PWD Job Queue Calculate Plan"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.05
    // FE_LAPIERRETTE_NDT01.001: LY 17/04/2013:  New Demand
    //                                           Create
    // 
    // ------------------------------------------------------------------------------------------------------------------

    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        // Setup
        RecGManufacturingSetup.Get();
        if (not RecGManufacturingSetup."PWD MPS") and (not RecGManufacturingSetup."PWD MRP") then
            Error(CstGTxt000, RecGManufacturingSetup.TableCaption);

        BooGNetChange := RecGManufacturingSetup."PWD Calc. Type" = RecGManufacturingSetup."PWD Calc. Type"::"Net Change";

        if RecGLocation.IsEmpty then
            Error(CstGTxt002);

        DatGFromDate := CalcDate(RecGManufacturingSetup."PWD Starting Date Calc.", Today);
        DatGToDate := CalcDate(RecGManufacturingSetup."PWD Ending Date Calc.", Today);

        RecGItem.SetCurrentKey("Low-Level Code");

        // Each Location
        RecGLocation.FindSet();
        repeat
            if RecGLocation."PWD Req. Wksh. Name" <> '' then begin
                RecGItem.SetRange("Location Code", RecGLocation.Code);

                Clear(CduGCalcItemPlan);
                CduGCalcItemPlan.SetTemplAndWorksheet(RecGLocation."PWD Req. Wksh. Template", RecGLocation."PWD Req. Wksh. Name", BooGNetChange);
                CduGCalcItemPlan.SetParm(RecGManufacturingSetup."PWD Use Forecast", RecGManufacturingSetup."PWD Exclude Before", RecGItem);
                CduGCalcItemPlan.Initialize(DatGFromDate, DatGToDate, RecGManufacturingSetup."PWD MPS", RecGManufacturingSetup."PWD MRP", false);

                BooGSetAtStartPosition := true;

                RecGReqLine.SetRange("Worksheet Template Name", RecGLocation."PWD Req. Wksh. Template");
                RecGReqLine.SetRange("Journal Batch Name", RecGLocation."PWD Req. Wksh. Name");
                RecGPlanningErrorLog.SetRange("Worksheet Template Name", RecGLocation."PWD Req. Wksh. Template");
                RecGPlanningErrorLog.SetRange("Journal Batch Name", RecGLocation."PWD Req. Wksh. Name");

                RecGPlanningErrorLog.DeleteAll();
                ClearLastError();
                Commit();

                if not RecGItem.IsEmpty then begin
                    RecGItem.FindSet();
                    repeat
                        if not BooGSetAtStartPosition then begin
                            BooGSetAtStartPosition := true;
                            RecGItem.Get(RecGPlanningErrorLog."Item No.");
                            RecGItem.Find('=<>');
                        end;

                        CduGCalcItemPlan.SetResiliencyOn();
                        if CduGCalcItemPlan.Run(RecGItem) then
                            IntGCounterOK += 1
                        else
                            if not CduGCalcItemPlan.GetResiliencyError(RecGPlanningErrorLog) then begin
                                TxtGErrorText := CopyStr(GetLastErrorText, 1, MaxStrLen(TxtGErrorText));
                                if TxtGErrorText = '' then
                                    TxtGErrorText := CstGTxt001
                                else
                                    ClearLastError();
                                RecGPlanningErrorLog.SetJnlBatch(RecGLocation."PWD Req. Wksh. Template", RecGLocation."PWD Req. Wksh. Name", RecGItem."No.");
                                RecGPlanningErrorLog.SetError(
                                  StrSubstNo(TxtGErrorText, RecGItem.TableCaption, RecGItem."No."), 0, RecGItem.GetPosition());
                            end;

                        Commit();

                    until RecGItem.Next() = 0;
                    CduGCalcItemPlan.Finalize();
                end;

            end;
        until RecGLocation.Next() = 0;
    end;

    var
        RecGLocation: Record Location;
        RecGItem: Record Item;
        RecGManufacturingSetup: Record "Manufacturing Setup";
        CstGTxt000: Label 'MPS or MRP must be flag on %1.';
        RecGPlanningErrorLog: Record "Planning Error Log";
        RecGReqLine: Record "Requisition Line";
        CduGCalcItemPlan: Codeunit "Calc. Item Plan - Plan Wksh.";
        BooGNetChange: Boolean;
        BooGSetAtStartPosition: Boolean;
        IntGCounterOK: Integer;
        TxtGErrorText: Text[1000];
        CstGTxt001: Label 'An unidentified error occurred while planning %1 %2. Recalculate the plan with the option "Stop and Show Error".';
        CstGTxt002: Label 'Planning Wkhs. must be define on Location.';
        DatGFromDate: Date;
        DatGToDate: Date;
}

