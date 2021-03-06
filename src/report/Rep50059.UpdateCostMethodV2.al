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
    UsageCategory = None;
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
                    field(OptGReplenishmentSystemF; OptGReplenishmentSystem)
                    {
                        Caption = 'Item type';
                        OptionCaption = 'Purchase,Prod. Order, Purchase and Prod. Order';
                        ApplicationArea = All;
                    }
                    field(OptCostMethForPurchasedItemF; OptCostMethForPurchasedItem)
                    {
                        Caption = 'Costing method to be forced for purchased items';
                        OptionCaption = 'FIFO,LIFO,Specific,Average,Standard';
                        ApplicationArea = All;
                        Editable = (OptGReplenishmentSystem = OptGReplenishmentSystem::Purchased) OR (OptGReplenishmentSystem = OptGReplenishmentSystem::Both);
                    }
                    field(OptCostMethForManufacturedItemF; OptCostMethForManufacturedItem)
                    {
                        Caption = 'Costing method to be forced for manufactured items';
                        OptionCaption = 'FIFO,LIFO,Specific,Average,Standard';
                        ApplicationArea = All;
                        Editable = (OptGReplenishmentSystem = OptGReplenishmentSystem::Manufactured) OR (OptGReplenishmentSystem = OptGReplenishmentSystem::Both);
                    }
                    field(CstG011F; CstG011)
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
        // Controle sur stock ?? 0, controle sur filtrage et demande de confirmation avant ex??cution du traitement
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
        OptCostMethForManufacturedItem: Enum "Costing Method";
        OptCostMethForPurchasedItem: Enum "Costing Method";
        CstG001: Label 'Pour les articles achet?? (filtrage %1), voulez vous forcer le mode ??valuation de stock ?? %2 ?';
        CstG002: Label 'Pour les articles fabriqu?? (filtrage %1), voulez vous forcer le mode ??valuation de stock ?? %2 ?';
        CstG003: Label 'Pour les articles achet?? (filtrage %1), voulez vous forcer le mode ??valuation de stock ?? %2 et pour les articles fabriqu?? (filtrage %3), voulez vous forcer le mode ??valuation de stock ?? %4?';
        CstG004: Label 'Traitement annul?? !';
        CstG005: Label 'Merci de saisir un filtrage article pour les articles achet??s';
        CstG006: Label 'Merci de saisir un filtrage article pour les articles fabriqu??s';
        CstG007: Label 'Merci de saisir un filtrage article pour les articles achet??s et fabriqu??s';
        CstG008: Label 'Attention le stock n''est pas ?? 0 pour au moins un des articles ?? traiter.\Traitement annul?? !';
        CstG009: Label 'Traitement termin?? !';
        CstG010: Label 'L''article %1 doit ??tre avec un code tra??abilt?? s??rie pour passer en mode ??valuation de stock sp??cifique.';
        CstG011: Label 'Please note that the specific costing method should only apply to items using serial numbers.';
        OptGReplenishmentSystem: Option Purchased,Manufactured,Both;
}

