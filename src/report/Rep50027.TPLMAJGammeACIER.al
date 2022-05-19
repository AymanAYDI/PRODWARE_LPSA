report 50027 "PWD TPL MAJ Gamme ACIER"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 28/06/2017 : cf. FED-Modification des gammes Aciers-22052107-V1
    //                   - New report

    ProcessingOnly = true;
    UsageCategory = none;
    dataset
    {
        dataitem("Routing Header"; "Routing Header")
        {
            //field 'PlanningGroup' in table 'Routing Header' does not exist
            //DataItemTableView = SORTING("No.") WHERE(PlanningGroup = FILTER('ACIERS'));
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin
                BDialog.Update(1, IntGCounter);
                IntGCounter -= 1;

                if "Routing Header".Status <> "Routing Header".Status::"Under Development" then begin
                    "Routing Header".Validate(Status, "Routing Header".Status::"Under Development");
                    "Routing Header".Modify(true);
                end;

                RecGRoutingLine.Reset();
                RecGRoutingLine.SetRange("Routing No.", "Routing Header"."No.");
                RecGRoutingLine.SetRange(Type, RecGRoutingLine.Type::"Work Center");
                if RecGRoutingLine.FindFirst() then
                    repeat
                        RecGWorkCenter.Get(RecGRoutingLine."No.");
                        if RecGWorkCenter."Subcontractor No." = '' then
                            RecGRoutingLine.Delete();
                    until RecGRoutingLine.Next() = 0;


                RecGRoutingLine.SetRange(Type, RecGRoutingLine.Type::"Machine Center");
                RecGRoutingLine.SetFilter(Description, 'ACI_MO_*');
                RecGRoutingLine.DeleteAll();

                if "Routing Header".Type <> "Routing Header".Type::Serial then begin
                    "Routing Header".Validate(Type, "Routing Header".Type::Serial);
                    "Routing Header".Modify(true);
                end;

                "Routing Header".Validate(Status, "Routing Header".Status::Certified);
                "Routing Header".Modify(true);
            end;

            trigger OnPostDataItem()
            begin
                BDialog.Close();
                Message('Traitement terminé');
            end;

            trigger OnPreDataItem()
            begin
                BDialog.Open('MAJ Gamme ACIER\\Enregistrements restants #1##############');
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
        RecGWorkCenter: Record "Work Center";
        BDialog: Dialog;
        IntGCounter: Integer;
}

