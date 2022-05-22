report 50055 "MAJ Description LPSA PIERRE"
{
    // +----------------------------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                                         |
    // | www.prodware.fr                                                                                                                  |
    // +----------------------------------------------------------------------------------------------------------------------------------+
    // 
    // //>>NDBI
    // P27818_002 : LALE.PA : 02/03/2021 : cf. demande mail client TI528225
    //                   - New Report
    // 
    // +----------------------------------------------------------------------------------------------------------------------------------+

    ProcessingOnly = true;
    UsageCategory = None;
    dataset
    {
        dataitem("PWD Item Configurator"; "PWD Item Configurator")
        {
            DataItemTableView = SORTING("Item Code") WHERE("Product Type" = FILTER(STONE));

            trigger OnAfterGetRecord()
            var
                RecLItem: Record Item;
                CduLItemConfigurator: Codeunit "PWD Item Configurator";
            begin
                CduLItemConfigurator.FctConfigDescStone("PWD Item Configurator");
                "PWD Item Configurator".Modify();

                if RecLItem.Get("PWD Item Configurator"."Item Code") then begin
                    RecLItem."PWD LPSA Description 1" := "PWD Item Configurator"."LPSA Description 1";
                    RecLItem."PWD LPSA Description 2" := "PWD Item Configurator"."LPSA Description 2";
                    RecLItem."PWD Quartis Description" := "PWD Item Configurator"."Quartis Description";
                    RecLItem.Validate(Description, CopyStr("PWD Item Configurator"."LPSA Description 1", 1, 50));
                    RecLItem.Validate("Description 2", CopyStr("PWD Item Configurator"."LPSA Description 2", 1, 50));
                    if RecLItem."Search Description" = '' then
                        RecLItem.Validate("Search Description", CopyStr("PWD Item Configurator"."Quartis Description", 1, 30));
                    ;
                    RecLItem.Modify();
                end;
                IntGCounter -= 1;
                Bdialog.Update(1, IntGCounter);
            end;

            trigger OnPostDataItem()
            begin
                Bdialog.Close();
            end;

            trigger OnPreDataItem()
            begin
                IntGCounter := Count;
                Bdialog.Open(CstG001);
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
        Bdialog: Dialog;
        IntGCounter: Integer;
        CstG001: Label 'MAJ de la désignation LPSA 1 pour les PIERRES.\\\Enregistrements restants #1##############';
}

