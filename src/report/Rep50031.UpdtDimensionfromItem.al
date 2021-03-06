report 50031 "PWD Updt Dimension from Item"
{
    // -----------------------------------------------------------------------------------------------
    //  Prodware - www.prodware.fr
    // -----------------------------------------------------------------------------------------------
    // 
    // //>>LAP2.19
    // TDL18112020.001 : LY 18/11/2020

    Caption = 'Updt Dimension from Item';
    ProcessingOnly = true;
    UsageCategory = None;
    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "Location Code";

            trigger OnAfterGetRecord()
            begin
                DiaGWindow.Update(1, "No.");

                CduGClosingMgt.UpdtItemDimValue(DATABASE::"Item Category", "No.", "Item Category Code");
                Clear(CduGClosingMgt);
                CduGClosingMgt.UpdtItemDimValue(DATABASE::"PWD Product Group", "No.", "PWD Product Group Code");
                Clear(CduGClosingMgt);
            end;

            trigger OnPostDataItem()
            begin
                DiaGWindow.Close();
                Message('Traitement terminé');
            end;

            trigger OnPreDataItem()
            begin
                DiaGWindow.Open('MAJ axe analytique article #1##############');
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
        CduGClosingMgt: Codeunit "PWD Closing Management";
        DiaGWindow: Dialog;
}

