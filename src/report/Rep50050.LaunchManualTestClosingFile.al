report 50050 "Launch Manual TestClosing File"
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

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING (Number) WHERE (Number = CONST (1));
            MaxIteration = 1;

            trigger OnAfterGetRecord()
            begin
                CduGClosingManagement.SetDataExport(BooGItem, BooGInventory, BooGProdOrder, BooGFinishedPO, DatGReferenceDate, true);
                CduGClosingManagement.Run;
            end;

            trigger OnPostDataItem()
            begin
                Message(CstG000);
            end;

            trigger OnPreDataItem()
            begin
                RecGInventorySetup.Get;
                RecGInventorySetup.TestField("Closing Export DateFormula");
                RecGInventorySetup.TestField("Period for Inventory Cover");
                RecGInventorySetup.TestField("Path for Closing Export");
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
                    }
                    field(BooGInventory; BooGInventory)
                    {
                        Caption = 'Inventory Export';
                        ShowCaption = false;
                    }
                    field(BooGProdOrder; BooGProdOrder)
                    {
                        Caption = 'Export En-cours';
                    }
                    field(BooGFinishedPO; BooGFinishedPO)
                    {
                        Caption = 'Finished PO Export (month)';
                        ShowCaption = false;
                    }
                    field(DatGReferenceDate; DatGReferenceDate)
                    {
                        Caption = 'Date pivot';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            DatGReferenceDate := WorkDate;
        end;
    }

    labels
    {
    }

    var
        CduGClosingManagement: Codeunit "Test Closing Management";
        RecGInventorySetup: Record "Inventory Setup";
        BooGItem: Boolean;
        BooGInventory: Boolean;
        BooGProdOrder: Boolean;
        BooGFinishedPO: Boolean;
        DatGReferenceDate: Date;
        CstG000: Label 'Process finished.';
}

