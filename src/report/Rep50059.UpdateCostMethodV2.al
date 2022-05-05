report 50059 "PWD Update Cost Method V2"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>NDBI
    // LALE.PA : 13/04/2021 : P27818_001/P27818_002 DEMANDES DIVERSES suite TI525814
    //                   - New report
    // 
    // LALE.PA : 30/11/2021 : cf REQ-11440-P3S2V7
    //                   - Add C/AL Code in triggers PurchasedItem - OnAfterGetRecord()
    //                                               ManufacturedItem - OnAfterGetRecord()

    Caption = 'Update Cost Method';
    ProcessingOnly = true;

    dataset
    {
        dataitem(PurchasedItem; Item)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Item purchased';

            trigger OnAfterGetRecord()
            begin
                if PurchasedItem."Replenishment System" <> PurchasedItem."Replenishment System"::Purchase then
                    CurrReport.Skip();

                if OptCostMethForPurchasedItem.AsInteger() = "Costing Method"::Specific.AsInteger() then begin
                    PurchasedItem.TestField("Item Tracking Code");

                    RecGItemTrackingCode.Get(PurchasedItem."Item Tracking Code");
                    if not RecGItemTrackingCode."SN Specific Tracking" then
                        Error(
                          CstG010,
                          PurchasedItem."No.");
                end;

                PurchasedItem."Costing Method" := OptCostMethForPurchasedItem;
                PurchasedItem.Modify();

                ItemCostMgt.UpdateUnitCost(PurchasedItem, '', '', 0, 0, false, false, true, FieldNo("Costing Method"));
                PurchasedItem.Modify();

                //>>NDBI
                // MAJ Configurateur
                RecGItemConfigurator.Reset();
                RecGItemConfigurator.SetCurrentKey("Item Code");
                RecGItemConfigurator.SetRange("Item Code", PurchasedItem."No.");
                if RecGItemConfigurator.FindFirst() then
                    repeat
                        RecGItemConfigurator."Costing Method" := PurchasedItem."Costing Method";
                        RecGItemConfigurator.Modify();
                    until RecGItemConfigurator.Next() = 0;
                //<<NDBI
            end;

            trigger OnPreDataItem()
            begin
                if (OptGReplenishmentSystem = OptGReplenishmentSystem::Manufactured) then
                    CurrReport.Break();

                PurchasedItem.SetRange("Replenishment System", PurchasedItem."Replenishment System"::Purchase);
            end;
        }
        dataitem(ManufacturedItem; Item)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Manufactured item';

            trigger OnAfterGetRecord()
            begin
                if ManufacturedItem."Replenishment System" <> ManufacturedItem."Replenishment System"::"Prod. Order" then
                    CurrReport.Skip();

                if OptCostMethForManufacturedItem.AsInteger() = "Costing Method"::Specific.AsInteger() then begin
                    ManufacturedItem.TestField("Item Tracking Code");

                    RecGItemTrackingCode.Get(ManufacturedItem."Item Tracking Code");
                    if not RecGItemTrackingCode."SN Specific Tracking" then
                        Error(
                          CstG010,
                          ManufacturedItem."No.");
                end;

                ManufacturedItem."Costing Method" := OptCostMethForManufacturedItem;
                ManufacturedItem.Modify();

                ItemCostMgt.UpdateUnitCost(ManufacturedItem, '', '', 0, 0, false, false, true, FieldNo("Costing Method"));
                ManufacturedItem.Modify();

                //>>NDBI
                // MAJ Configurateur
                RecGItemConfigurator.Reset();
                RecGItemConfigurator.SetCurrentKey("Item Code");
                RecGItemConfigurator.SetRange("Item Code", ManufacturedItem."No.");
                if RecGItemConfigurator.FindFirst() then
                    repeat
                        RecGItemConfigurator."Costing Method" := ManufacturedItem."Costing Method";
                        RecGItemConfigurator.Modify();
                    until RecGItemConfigurator.Next() = 0;
                //<<NDBI
            end;

            trigger OnPreDataItem()
            begin
                if (OptGReplenishmentSystem = OptGReplenishmentSystem::Purchased) then
                    CurrReport.Break();

                ManufacturedItem.SetRange("Replenishment System", ManufacturedItem."Replenishment System"::Purchase);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Control1000000000)
                {
                    Caption = 'Item type';
                    ShowCaption = false;
                    field(OptGReplenishmentSystem; OptGReplenishmentSystem)
                    {
                        Caption = 'Item type';
                        OptionCaption = 'Purchase,Prod. Order, Purchase and Prod. Order';
                        ShowCaption = false;
                        ApplicationArea = All;
                    }
                    field(OptCostMethForPurchasedItem; OptCostMethForPurchasedItem)
                    {
                        Caption = 'Costing method to be forced for purchased items';
                        OptionCaption = 'FIFO,LIFO,Specific,Average,Standard';
                        ShowCaption = false;
                        ApplicationArea = All;
                        Editable = (OptGReplenishmentSystem = OptGReplenishmentSystem::Purchased) OR (OptGReplenishmentSystem = OptGReplenishmentSystem::Both);
                    }
                    field(OptCostMethForManufacturedItem; OptCostMethForManufacturedItem)
                    {
                        Caption = 'Costing method to be forced for manufactured items';
                        OptionCaption = 'FIFO,LIFO,Specific,Average,Standard';
                        ShowCaption = false;
                        ApplicationArea = All;
                        Editable = (OptGReplenishmentSystem = OptGReplenishmentSystem::Manufactured) OR (OptGReplenishmentSystem = OptGReplenishmentSystem::Both);
                    }
                    field(CstG011; CstG011)
                    {
                        ApplicationArea = All;
                        ShowCaption = false;
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
        Message(CstG009);
    end;

    trigger OnPreReport()
    var
        RecLItem: Record Item;
    begin
        // Controle sur stock à 0, controle sur filtrage et demande de confirmation avant exécution du traitement
        case OptGReplenishmentSystem of
            OptGReplenishmentSystem::Purchased:
                begin
                    if PurchasedItem.GetFilters = '' then
                        Error(CstG005);

                    if not Confirm(CstG001, false, PurchasedItem.GetFilters, OptCostMethForPurchasedItem) then
                        Error(CstG004);

                    RecLItem.Reset();
                    RecLItem.CopyFilters(PurchasedItem);
                    RecLItem.SetFilter(Inventory, '<>%1', 0);
                    if not RecLItem.IsEmpty then
                        Error(CstG008);
                end;
            OptGReplenishmentSystem::Manufactured:
                begin
                    if ManufacturedItem.GetFilters = '' then
                        Error(CstG006);

                    if not Confirm(CstG002, false, ManufacturedItem.GetFilters, OptCostMethForManufacturedItem) then
                        Error(CstG004);

                    RecLItem.Reset();
                    RecLItem.CopyFilters(ManufacturedItem);
                    RecLItem.SetFilter(Inventory, '<>%1', 0);
                    if not RecLItem.IsEmpty then
                        Error(CstG008);

                end;
            OptGReplenishmentSystem::Both:
                begin
                    if (PurchasedItem.GetFilters = '') or (ManufacturedItem.GetFilters = '') then
                        Error(CstG007);

                    if not Confirm(CstG003, false, PurchasedItem.GetFilters, OptCostMethForPurchasedItem,
                                            ManufacturedItem.GetFilters, OptCostMethForManufacturedItem) then
                        Error(CstG004);

                    RecLItem.Reset();
                    RecLItem.CopyFilters(PurchasedItem);
                    RecLItem.SetFilter(Inventory, '<>%1', 0);
                    if not RecLItem.IsEmpty then
                        Error(CstG008);

                    RecLItem.Reset();
                    RecLItem.CopyFilters(ManufacturedItem);
                    RecLItem.SetFilter(Inventory, '<>%1', 0);
                    if not RecLItem.IsEmpty then
                        Error(CstG008);

                end;
        end;
    end;

    var
        RecGItemTrackingCode: Record "Item Tracking Code";
        RecGItemConfigurator: Record "PWD Item Configurator";
        ItemCostMgt: Codeunit ItemCostManagement;
        CstG001: Label 'Pour les articles acheté (filtrage %1), voulez vous forcer le mode évaluation de stock à %2 ?';
        CstG002: Label 'Pour les articles fabriqué (filtrage %1), voulez vous forcer le mode évaluation de stock à %2 ?';
        CstG003: Label 'Pour les articles acheté (filtrage %1), voulez vous forcer le mode évaluation de stock à %2 et pour les articles fabriqué (filtrage %3), voulez vous forcer le mode évaluation de stock à %4?';
        CstG004: Label 'Traitement annulé !';
        CstG005: Label 'Merci de saisir un filtrage article pour les articles achetés';
        CstG006: Label 'Merci de saisir un filtrage article pour les articles fabriqués';
        CstG007: Label 'Merci de saisir un filtrage article pour les articles achetés et fabriqués';
        CstG008: Label 'Attention le stock n''est pas à 0 pour au moins un des articles à traiter.\Traitement annulé !';
        CstG009: Label 'Traitement terminé !';
        CstG010: Label 'L''article %1 doit être avec un code traçabilté série pour passer en mode évaluation de stock spécifique.';
        CstG011: Label 'Please note that the specific costing method should only apply to items using serial numbers.';
        OptCostMethForManufacturedItem: Enum "Costing Method";
        OptCostMethForPurchasedItem: Enum "Costing Method";
        OptGReplenishmentSystem: Option Purchased,Manufactured,Both;
}

