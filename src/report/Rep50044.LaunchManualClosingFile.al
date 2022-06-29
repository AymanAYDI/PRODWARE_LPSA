report 50044 "PWD Launch Manual Closing File"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.19
    // P24578_008.001 : LY 12/08/2019 : Export contrôle de gestion

    Caption = 'Launch Manual Export Closing File';
    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = Tasks;
    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            MaxIteration = 1;

            trigger OnAfterGetRecord()
            begin
                CduGClosingManagement.SetDataExport(BooGItem, BooGInventory, BooGProdOrder, BooGFinishedPO, DatGReferenceDate, true);
                CduGClosingManagement.Run();
            end;

            trigger OnPostDataItem()
            begin
                Message(CstG000);
            end;

            trigger OnPreDataItem()
            begin
                RecGInventorySetup.Get();
                RecGInventorySetup.TestField("PWD Closing Export DateFormula");
                RecGInventorySetup.TestField("PWD Period for Inventory Cover");
                RecGInventorySetup.TestField("PWD Path for Closing Export");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Control1100267000)
                {
                    Caption = 'Options';
                    field(BooGItemF; BooGItem)
                    {
                        Caption = 'Item Export';
                        ApplicationArea = All;
                    }
                    field(BooGInventoryF; BooGInventory)
                    {
                        Caption = 'Inventory Export';
                        ApplicationArea = All;
                    }
                    field(BooGProdOrderF; BooGProdOrder)
                    {
                        Caption = 'Export En-cours';
                        ApplicationArea = All;
                    }
                    field(BooGFinishedPOF; BooGFinishedPO)
                    {
                        Caption = 'Finished PO Export (month)';
                        ApplicationArea = All;
                    }
                    field(DatGReferenceDateF; DatGReferenceDate)
                    {
                        Caption = 'Date pivot';
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            DatGReferenceDate := WorkDate();
        end;
    }

    labels
    {
    }

    var
        RecGInventorySetup: Record "Inventory Setup";
        CduGClosingManagement: Codeunit "PWD Closing Management";
        BooGFinishedPO: Boolean;
        BooGInventory: Boolean;
        BooGItem: Boolean;
        BooGProdOrder: Boolean;
        DatGReferenceDate: Date;
        CstG000: Label 'Process finished.';
}

