report 8073282 "PWD Delete Connector Error Log"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect.1.00
    // 
    // FE_ProdConnect.001:GR 22/03/2011  Connector integration
    //                                   - Create Object
    // +----------------------------------------------------------------------------------------------------------------+

    Caption = 'Connector Error Log';
    ProcessingOnly = true;
    UsageCategory = None;
    dataset
    {
        dataitem("PWD Connector Error log"; "PWD Connector Error Log")
        {
            DataItemTableView = SORTING("Entry No.");
            RequestFilterFields = Date;

            trigger OnAfterGetRecord()
            begin
                Delete(true);
            end;

            trigger OnPostDataItem()
            begin
                FrmGDialog.Close()
            end;

            trigger OnPreDataItem()
            begin
                if not Confirm(CstG001) then
                    CurrReport.Quit();

                FrmGDialog.Open(CstG002);
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
        FrmGDialog: Dialog;
        CstG001: Label 'Are you sure you want to delete Connector error log ?';
        CstG002: Label 'Deletion in process...';
}

