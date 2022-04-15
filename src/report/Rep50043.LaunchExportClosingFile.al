report 50043 "PWD Launch Export Closing File"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.19
    // P24578_008.001 : LY 12/08/2019 : Export contrôle de gestion

    Caption = 'Launch Export Closing File';
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            MaxIteration = 1;

            trigger OnAfterGetRecord()
            begin
                RecGInventorySetup.Get();
                RecGInventorySetup.TestField("Closing Export DateFormula");
                RecGInventorySetup.TestField("Period for Inventory Cover");
                RecGInventorySetup.TestField("Path for Closing Export");
                if CalcDate(RecGInventorySetup."Closing Export DateFormula", Today) = Today then begin

                    CduGClosingManagement.SetDataExport(true, true, true, true, Today, false);
                    CduGClosingManagement.Run;

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

    var
        CduGClosingManagement: Codeunit "Closing Management";
        RecGInventorySetup: Record "Inventory Setup";
}

