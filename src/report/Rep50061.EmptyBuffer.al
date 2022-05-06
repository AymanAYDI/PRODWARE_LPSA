report 50061 "PWD Empty Buffer"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>NDBI
    // LALE.PA : 13/04/2021 : P27818_001/P27818_002 DEMANDES DIVERSES suite TI525814
    //                   - New report

    Caption = 'Empty Buffer';
    ProcessingOnly = true;
    UsageCategory = none;
    dataset
    {
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

    trigger OnPreReport()
    begin
        if Confirm(CstG001, false) then begin
            RecGItemJnlLineBuffer.Reset();
            RecGItemJnlLineBuffer.DeleteAll();
            RecGItemLedgerEntryBuffer.Reset();
            RecGItemLedgerEntryBuffer.DeleteAll();
            Message(CstG002);
        end else
            Error(CstG003);
    end;

    var
        RecGItemJnlLineBuffer: Record "PWD Item Jnl Line Buffer";
        RecGItemLedgerEntryBuffer: Record "PWD Item Ledger Entry Buffer";
        CstG001: Label 'Voulez-vous vider les tables Buffer du traitement de modification en masse du mode évaluation de stock ?';
        CstG002: Label 'Les tables Buffer ont été vidées !';
        CstG003: Label 'Traitement annulé !';
}

