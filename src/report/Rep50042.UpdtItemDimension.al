report 50042 "PWD Updt Item - Dimension"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.19
    // P24578_008.001 : LY 12/08/2019 : Export contrôle de gestion
    //                                  TOOLS

    Caption = 'Updt Item - Dimension (COFFEE)';
    Permissions = TableData "Sales Line" = rm,
                  TableData "Purchase Line" = rm,
                  TableData "Item Journal Line" = rm,
                  TableData "Requisition Line" = rm,
                  TableData "Transfer Line" = rm,
                  TableData "PWD Manufacturing cycles Setup" = rm;
    ProcessingOnly = true;
    UsageCategory = None;
    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", Description, "Search Description", "PWD LPSA Description 1";

            trigger OnAfterGetRecord()
            var
                RecLItemJnlLine: Record "Item Journal Line";
                RecLPurchLine: Record "Purchase Line";
                RecLItemConfiguration: Record "PWD Item Configurator";
                RecLManufacturingCycles: Record "PWD Manufacturing cycles Setup";
                RecLRequisitionLine: Record "Requisition Line";
                RecLSalesLine: Record "Sales Line";
                RecLTransferLine: Record "Transfer Line";
            begin
                DiagWindows.Update(1, DATABASE::Item);
                DiagWindows.Update(2, "No.");

                "Item Category Code" := RecGItemCategory.Code;
                "PWD Product Group Code" := CodGGroupCode;
                Modify();

                RecGProductGroup.Get(RecGItemCategory.Code, CodGGroupCode);

                CduGClosingMgt.UpdateDimValue(DATABASE::"Item Category", RecGItemCategory.Code, RecGItemCategory.Description);
                CduGClosingMgt.UpdateDimValue(DATABASE::"PWD Product Group", RecGProductGroup.Code, RecGProductGroup.Description);

                CduGClosingMgt.UpdtItemDimValue(DATABASE::"Item Category", "No.", "Item Category Code");
                CduGClosingMgt.UpdtItemDimValue(DATABASE::"PWD Product Group", "No.", "PWD Product Group Code");

                // Mise à jour Sales Line
                RecLSalesLine.SetRange(Type, RecLSalesLine.Type::Item);
                RecLSalesLine.SetRange("No.", "No.");
                if RecLSalesLine.Find('-') then
                    repeat
                        DiagWindows.Update(1, DATABASE::"Sales Line");
                        DiagWindows.Update(2, RecLSalesLine."No.");

                        RecLSalesLine."Item Category Code" := Item."Item Category Code";
                        RecLSalesLine."PWD Product Group Code" := Item."PWD Product Group Code";
                        RecLSalesLine.Modify();
                    until RecLSalesLine.Next() = 0;

                // Mise à jour Purchase Line
                RecLPurchLine.SetRange(Type, RecLPurchLine.Type::Item);
                RecLPurchLine.SetRange("No.", "No.");
                if RecLPurchLine.Find('-') then
                    repeat
                        DiagWindows.Update(1, DATABASE::"Purchase Line");
                        DiagWindows.Update(2, RecLPurchLine."Document No.");

                        RecLPurchLine."Item Category Code" := Item."Item Category Code";
                        RecLPurchLine."PWD Product Group Code" := Item."PWD Product Group Code";
                        RecLPurchLine.Modify();
                    until RecLPurchLine.Next() = 0;

                // Mise à jour feuille article
                RecLItemJnlLine.SetRange("Item No.", "No.");
                if RecLItemJnlLine.Find('-') then
                    repeat
                        DiagWindows.Update(1, DATABASE::"Item Journal Line");
                        DiagWindows.Update(2, "No.");

                        RecLItemJnlLine."Item Category Code" := Item."Item Category Code";
                        RecLItemJnlLine."PWD Product Group Code" := Item."PWD Product Group Code";
                        RecLItemJnlLine.Modify();
                    until RecLItemJnlLine.Next() = 0;

                // Mise à jour feuille achat
                RecLRequisitionLine.SetRange(Type, RecLRequisitionLine.Type::Item);
                RecLRequisitionLine.SetRange("No.", "No.");
                if RecLRequisitionLine.Find('-') then
                    repeat
                        DiagWindows.Update(1, DATABASE::"Requisition Line");
                        DiagWindows.Update(2, "No.");

                        RecLRequisitionLine."Item Category Code" := Item."Item Category Code";
                        RecLRequisitionLine."PWD Product Group Code" := Item."PWD Product Group Code";
                        RecLRequisitionLine.Modify();
                    until RecLRequisitionLine.Next() = 0;

                // Mise à jour Transfer Line
                RecLTransferLine.SetRange("Item No.", "No.");
                if RecLTransferLine.Find('-') then
                    repeat
                        DiagWindows.Update(1, DATABASE::"Transfer Line");
                        DiagWindows.Update(2, RecLTransferLine."Document No.");

                        RecLTransferLine."Item Category Code" := Item."Item Category Code";
                        RecLTransferLine."PWD Product Group Code" := Item."PWD Product Group Code";
                        RecLTransferLine.Modify();
                    until RecLTransferLine.Next() = 0;

                //
                RecLManufacturingCycles.SetRange("Item Code", "No.");
                if RecLManufacturingCycles.Find('-') then
                    repeat
                        DiagWindows.Update(1, DATABASE::"PWD Manufacturing cycles Setup");
                        DiagWindows.Update(2, RecLManufacturingCycles."No.");

                        RecLManufacturingCycles."Item Category Code" := Item."Item Category Code";
                        RecLManufacturingCycles.Modify();
                    until RecLManufacturingCycles.Next() = 0;


                //50001
                RecLItemConfiguration.SetRange("Item Code", "No.");
                if RecLItemConfiguration.Find('-') then
                    repeat
                        DiagWindows.Update(1, DATABASE::"PWD Item Configurator");
                        DiagWindows.Update(2, "No.");

                        RecLItemConfiguration."Item Category Code" := Item."Item Category Code";
                        RecLItemConfiguration."Product Group Code" := Item."PWD Product Group Code";
                        RecLItemConfiguration.Modify();
                    until RecLManufacturingCycles.Next() = 0;
            end;

            trigger OnPostDataItem()
            begin
                DiagWindows.Close();
            end;

            trigger OnPreDataItem()
            begin
                DiagWindows.Open(CstG0000);
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
                    field(RecGItemCategoryF; RecGItemCategory.Code)
                    {
                        Caption = 'Nouveau code catégorie';
                        ApplicationArea = All;
                        TableRelation = "Item Category";
                    }
                    field(CodGGroupCodeF; CodGGroupCode)
                    {
                        Caption = 'Nouveau code catégorie';
                        ApplicationArea = All;
                        trigger OnLookup(var Text: Text): Boolean
                        begin

                            CLEAR(PagProductGroup);

                            Text := '';
                            RecGProductGroup.SETRANGE("Item Category Code", RecGItemCategory.Code);
                            PagProductGroup.SETTABLEVIEW(RecGProductGroup);
                            PagProductGroup.LOOKUPMODE(TRUE);
                            IF PagProductGroup.RUNMODAL() = ACTION::LookupOK THEN
                                Text := PagProductGroup.GetSelectionFilter();

                            EXIT(TRUE);
                        end;
                    }
                    field(CstG0003F; CstG0003)
                    {
                        ShowCaption = false;
                        ApplicationArea = All;
                        Editable = false;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        Message(CstG0002);
    end;

    trigger OnPreReport()
    begin
        if (CodGGroupCode = '') or (RecGItemCategory.Code = '') then
            Error(CstG0001);
    end;

    var
        RecGItemCategory: Record "Item Category";
        RecGProductGroup: Record "PWD Product Group";
        CduGClosingMgt: Codeunit "PWD Closing Management";
        PagProductGroup: Page "PWD Product Groups";
        CodGGroupCode: Code[10];
        DiagWindows: Dialog;
        CstG0000: Label 'Mise à jour #1################ #2#################';
        CstG0001: Label 'Code catégorie et code groupe produit sont obligatoires.';
        CstG0002: Label 'Mise à jour articles terminée.';
        CstG0003: Label 'ATTENTION, PENSEZ A POSITIONNER LES FILTRES ADEQUATS DANS L''ONGLET ARTICLE. ';
}

