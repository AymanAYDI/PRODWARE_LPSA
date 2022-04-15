report 60039 "TPL Ajout opération sur gamme"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>REGIE
    // P24578_006 : LALE.RO : 02/04/2019 Demande par Mail
    //                 - New report One Shot
    // WHERE(Description=FILTER(*½ g*))

    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", Description;

            trigger OnAfterGetRecord()
            var
                RecLRoutingLine: Record "Routing Line";
                BooLToUpdate: Boolean;
                OptLOldStatus: Integer;
                RecLNextRoutingLine: Record "Routing Line";
                RecLNewRoutingLine: Record "Routing Line";
            begin
                BDialog.Update(1, IntGCounter);
                IntGCounter -= 1;

                Clear(CodGActiveVersionCode);
                CodGActiveVersionCode := CduGVersionMgt.GetRtngVersion("Routing No.", Today, true);

                BooGVersion := false;
                BooLToUpdate := false;

                Clear(OptLOldStatus);

                if CodGActiveVersionCode = '' then begin
                    RecGRoutingHeader.SetRange("No.", "Routing No.");
                    RecGRoutingHeader.SetFilter(Status, '<>%1', RecGRoutingHeader.Status::Closed);
                    if RecGRoutingHeader.FindFirst() then begin
                        if (RecGRoutingHeader.Status <> RecGRoutingHeader.Status::"Under Development") then begin
                            OptLOldStatus := RecGRoutingHeader.Status;
                            RecGRoutingHeader.Validate(Status, RecGRoutingHeader.Status::"Under Development");
                            RecGRoutingHeader.Modify(true);
                        end;
                        BooLToUpdate := true;
                    end;
                end else begin
                    BooGVersion := true;
                    RecGRoutingVersion.SetRange("Routing No.", "Routing No.");
                    RecGRoutingVersion.SetRange("Version Code", CodGActiveVersionCode);
                    RecGRoutingVersion.SetFilter(Status, '<>%1', RecGRoutingVersion.Status::"Under Development");
                    if RecGRoutingVersion.FindFirst() then begin
                        if (RecGRoutingVersion.Status <> RecGRoutingVersion.Status::"Under Development") then begin
                            OptLOldStatus := RecGRoutingVersion.Status;
                            RecGRoutingVersion.Validate(Status, RecGRoutingVersion.Status::"Under Development");
                            RecGRoutingVersion.Modify(true);
                        end;
                        BooLToUpdate := true;
                    end;
                end;

                if BooLToUpdate then begin

                    RecLRoutingLine.SetRange("Routing No.", "Routing No.");
                    RecLRoutingLine.SetRange("Version Code", CodGActiveVersionCode);
                    RecLRoutingLine.SetRange("No.", CodGBetweenOP);
                    if not RecLRoutingLine.IsEmpty then begin
                        RecLRoutingLine.FindFirst();
                        RecLNextRoutingLine.Get(RecLRoutingLine."Routing No.", RecLRoutingLine."Version Code", RecLRoutingLine."Next Operation No.");
                        if RecLNextRoutingLine."No." <> CodGNewOP then begin

                            Evaluate(IntGOperation, RecLRoutingLine."Operation No.");
                            Evaluate(IntGNextOperation, RecLRoutingLine."Next Operation No.");
                            CodGNewOperation := Format(IntGOperation + (IntGNextOperation - IntGOperation) div 2);
                            if StrLen(CodGNewOperation) < 5 then
                                for i := 1 to (5 - StrLen(CodGNewOperation)) do
                                    CodGNewOperation := '0' + CodGNewOperation;

                            RecLNewRoutingLine.Init();
                            RecLNewRoutingLine.Validate("Routing No.", RecLRoutingLine."Routing No.");
                            RecLNewRoutingLine.Validate("Version Code", RecLRoutingLine."Version Code");
                            RecLNewRoutingLine."Operation No." := CodGNewOperation;
                            RecLNewRoutingLine."Next Operation No." := RecLRoutingLine."Next Operation No.";
                            RecLNewRoutingLine."Previous Operation No." := RecLRoutingLine."Operation No.";
                            RecLNewRoutingLine.Validate(Type, RecLNewRoutingLine.Type::"Machine Center");
                            RecLNewRoutingLine.Validate("No.", CodGNewOP);
                            RecLNewRoutingLine.Insert();
                        end;
                    end;

                    if BooGVersion then begin
                        RecGRoutingVersion.Validate(Status, OptLOldStatus);
                        RecGRoutingVersion.Modify(true);
                    end else begin
                        RecGRoutingHeader.Validate(Status, OptLOldStatus);
                        RecGRoutingHeader.Modify(true);
                    end;
                end;
            end;

            trigger OnPostDataItem()
            begin
                BDialog.Close();
                Message('Mise à jour terminée.');
            end;

            trigger OnPreDataItem()
            begin

                if CodGNewOP = '' then
                    Error('Le nouveau poste est obligatoire.');

                if CodGBetweenOP = '' then
                    Error('Le poste de l''opération précédente est obligatoire.');

                BDialog.Open('Article\Enregistrements restants #1##############\\MAJ Ligne Gamme\Enregistrements restants #2##############');
                IntGCounter := Count;
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

    var
        BDialog: Dialog;
        IntGCounter: Integer;
        IntGOperation: Integer;
        IntGNextOperation: Integer;
        CodGNewOperation: Code[10];
        i: Integer;
        CodGActiveVersionCode: Code[20];
        CduGVersionMgt: Codeunit VersionManagement;
        RecGRoutingHeader: Record "Routing Header";
        RecGRoutingVersion: Record "Routing Version";
        BooGVersion: Boolean;
        CodGNewOP: Code[20];
        CodGBetweenOP: Code[20];
}

