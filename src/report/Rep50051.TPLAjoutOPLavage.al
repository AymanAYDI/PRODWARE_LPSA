report 50051 "PWD TPL Ajout OP Lavage"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>NDBI
    // P27818_001 : LALE.PA : 06/10/2020 : cf. demande mail client du 17/09 (Modification des gammes de découpe laser.pdf)
    //                   - New report

    ProcessingOnly = true;

    dataset
    {
        dataitem("Routing Header"; "Routing Header")
        {
            DataItemTableView = SORTING("No.") WHERE("No." = FILTER('PIE_DL_9915*'));
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            var
                RecLRoutingLine: Record "Routing Line";
            begin
                BDialog.Update(1, IntGCounter);
                IntGCounter -= 1;

                OptGStatus := "Routing Header".Status;

                if OptGStatus = OptGStatus::Closed then
                    CurrReport.Skip();

                if OptGStatus = OptGStatus::Certified then begin
                    "Routing Header".Validate(Status, "Routing Header".Status::"Under Development");
                    "Routing Header".Modify(true);
                end;

                RecGRoutingLine.Reset();
                RecGRoutingLine.SetRange("Routing No.", "Routing Header"."No.");
                if RecGRoutingLine.FindFirst() then
                    repeat
                        if (RecGRoutingLine.Type = RecGRoutingLine.Type::"Machine Center") and
                           (RecGRoutingLine."No." = 'OP11810') then begin
                            RecLRoutingLine.Init();
                            RecLRoutingLine.Validate("Routing No.", "Routing Header"."No.");
                            RecLRoutingLine.Validate("Operation No.", IncStr(RecGRoutingLine."Operation No."));
                            RecLRoutingLine.Validate(Type, RecLRoutingLine.Type::"Machine Center");
                            RecLRoutingLine.Validate("No.", 'OP11760');
                            RecLRoutingLine.Validate("Setup Time", 15);
                            RecLRoutingLine.Validate("Run Time", 0);
                            RecLRoutingLine.Validate("Wait Time", 0);
                            RecLRoutingLine.Validate("Move Time", 240);
                            RecLRoutingLine.Insert(true);
                        end;
                    until RecGRoutingLine.Next() = 0;


                if OptGStatus = OptGStatus::Certified then begin
                    "Routing Header".Validate(Status, "Routing Header".Status::Certified);
                    "Routing Header".Modify(true);
                end;
            end;

            trigger OnPostDataItem()
            begin
                BDialog.Close();
            end;

            trigger OnPreDataItem()
            begin
                BDialog.Open('MAJ Ligne Gamme\\Enregistrements restants #1##############');
                IntGCounter := "Routing Header".Count;
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
        RecGRoutingLine: Record "Routing Line";
        BDialog: Dialog;
        IntGCounter: Integer;
        OptGStatus: Option New,Certified,"Under Development",Closed;
}

