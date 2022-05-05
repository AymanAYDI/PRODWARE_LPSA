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
                    ShowCaption = false;
                    field(BooGItem; BooGItem)
                    {
                        Caption = 'Item Export';
                        ShowCaption = false;
                        ApplicationArea = All;
                    }
                    field(BooGInventory; BooGInventory)
                    {
                        Caption = 'Inventory Export';
                        ShowCaption = false;
                        ApplicationArea = All;
                    }
                    field(BooGProdOrder; BooGProdOrder)
                    {
                        Caption = 'Export En-cours';
                        ApplicationArea = All;
                    }
                    field(BooGFinishedPO; BooGFinishedPO)
                    {
                        Caption = 'Finished PO Export (month)';
                        ShowCaption = false;
                        ApplicationArea = All;
                    }
                    field(DatGReferenceDate; DatGReferenceDate)
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

