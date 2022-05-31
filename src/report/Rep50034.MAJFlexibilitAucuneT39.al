report 50034 "PWD MAJ Flexibilité=Aucune T39"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 12/09/2017 : DEMANDES DIVERSES
    //                   - New report

    ProcessingOnly = true;
    UsageCategory = None;
    Caption = 'MAJ Flexibilité=Aucune T39';
    dataset
    {
        dataitem("Purchase Line"; "Purchase Line")
        {

            trigger OnAfterGetRecord()
            begin
                Bdialog.Update(1, IntGCounter);
                IntGCounter -= 1;

                "Purchase Line"."Planning Flexibility" := "Purchase Line"."Planning Flexibility"::None;
                "Purchase Line".Modify();
            end;

            trigger OnPostDataItem()
            begin
                Bdialog.Close();
            end;

            trigger OnPreDataItem()
            begin
                Bdialog.Open('Enregistrements restants #1#######################');
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
        Bdialog: Dialog;
        IntGCounter: Integer;
}

