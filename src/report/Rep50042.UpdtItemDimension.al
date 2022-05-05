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
    UsageCategory = none;
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
                //"Product Group Code" := CodGGroupCode;
                Modify();

                // RecGProductGroup.Get(RecGItemCategory.Code, CodGGroupCode);  //TODO: La table Product Group n'existe plus pour la nouvelle version

                CduGClosingMgt.UpdateDimValue(DATABASE::"Item Category", RecGItemCategory.Code, RecGItemCategory.Description);
                // CduGClosingMgt.UpdateDimValue(DATABASE::"Product Group", RecGProductGroup.Code, RecGProductGroup.Description); //TODO: La table Product Group n'exist pas dans la nouvelle version

                CduGClosingMgt.UpdtItemDimValue(DATABASE::"Item Category", "No.", "Item Category Code");
                // CduGClosingMgt.UpdtItemDimValue(DATABASE::"Product Group", "No.", "Product Group Code");//TODO: La table Product Group n'exist pas dans la nouvelle version

                // Mise à jour Sales Line
                RecLSalesLine.SetRange(Type, RecLSalesLine.Type::Item);
                RecLSalesLine.SetRange("No.", "No.");
                if RecLSalesLine.Find('-') then
                    repeat
                        DiagWindows.Update(1, DATABASE::"Sales Line");
                        DiagWindows.Update(2, RecLSalesLine."No.");

                        RecLSalesLine."Item Category Code" := Item."Item Category Code";
                        //RecLSalesLine."Product Group Code" := Item."Product Group Code";
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
                        //RecLPurchLine."Product Group Code" := Item."Product Group Code";
                        RecLPurchLine.Modify();
                    until RecLPurchLine.Next() = 0;

                // Mise à jour feuille article
                RecLItemJnlLine.SetRange("Item No.", "No.");
                if RecLItemJnlLine.Find('-') then
                    repeat
                        DiagWindows.Update(1, DATABASE::"Item Journal Line");
                        DiagWindows.Update(2, "No.");

                        RecLItemJnlLine."Item Category Code" := Item."Item Category Code";
                        //RecLItemJnlLine."Product Group Code" := Item."Product Group Code";
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
                        //RecLRequisitionLine."Product Group Code" := Item."Product Group Code";
                        RecLRequisitionLine.Modify();
                    until RecLRequisitionLine.Next() = 0;

                // Mise à jour Transfer Line
                RecLTransferLine.SetRange("Item No.", "No.");
                if RecLTransferLine.Find('-') then
                    repeat
                        DiagWindows.Update(1, DATABASE::"Transfer Line");
                        DiagWindows.Update(2, RecLTransferLine."Document No.");

                        RecLTransferLine."Item Category Code" := Item."Item Category Code";
                        //RecLTransferLine."Product Group Code" := Item."Product Group Code";
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
                        //RecLItemConfiguration."Product Group Code" := Item."Product Group Code";
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
                    ShowCaption = false;
                    field(RecGItemCategory;
                    RecGItemCategory.Code)
                    {
                        Caption = 'Nouveau code catégorie';
                        ShowCaption = false;
                        ApplicationArea = All;
                        TableRelation = "Item Category";
                    }
                    field(CodGGroupCode; CodGGroupCode)
                    {
                        Caption = 'Nouveau code catégorie';
                        ShowCaption = false;
                        ApplicationArea = All;
                        trigger OnLookup(var Text: Text): Boolean
                        begin

                            // CLEAR(FrmProductGroup);   //TODO: La Page Product Group n'existe plus pour la nouvelle version

                            // Text := '';
                            // RecGProductGroup.SETRANGE("Item Category Code", RecGItemCategory.Code); //TODO: La table Product Group n'existe plus pour la nouvelle version
                            // FrmProductGroup.SETTABLEVIEW(RecGProductGroup); //TODO: La Page Product Group n'existe plus pour la nouvelle version
                            // FrmProductGroup.LOOKUPMODE(TRUE); //TODO: La Page Product Group n'existe plus pour la nouvelle version
                            // IF FrmProductGroup.RUNMODAL = ACTION::LookupOK THEN //TODO: La Page Product Group n'existe plus pour la nouvelle version
                            //     Text := FrmProductGroup.GetSelectionFilter; //TODO: La Page Product Group n'existe plus pour la nouvelle version

                            EXIT(TRUE);
                        end;
                    }
                    field(CstG0003; CstG0003)
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
        // RecGProductGroup: Record "Product Group"; //TODO: La table Product Group n'existe plus pour la nouvelle version
        CduGClosingMgt: Codeunit "PWD Closing Management";
        // FrmProductGroup: Page "Product Groups"; //TODO: La Oage Product Group n'existe plus pour la nouvelle version
        CodGGroupCode: Code[10];
        DiagWindows: Dialog;
        CstG0000: Label 'Mise à jour #1################ #2#################';
        CstG0001: Label 'Code catégorie et code groupe produit sont obligatoires.';
        CstG0002: Label 'Mise à jour articles terminée.';
        CstG0003: Label 'ATTENTION, PENSEZ A POSITIONNER LES FILTRES ADEQUATS DANS L''ONGLET ARTICLE. ';
}

