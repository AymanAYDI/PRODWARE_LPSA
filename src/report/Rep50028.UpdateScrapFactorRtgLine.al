report 50028 "Update Scrap Factor Rtg Line"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 17/10/2017 : DEMANDES DIVERSES
    //                   - New report

    Caption = 'Update routing lines';
    ProcessingOnly = true;
    UseSystemPrinter = false;

    dataset
    {
        dataitem(ItemMem; Item)
        {
            DataItemTableView = SORTING("No.") WHERE("Location Code" = FILTER('PIE'));

            trigger OnAfterGetRecord()
            var
                DateTime: DateTime;
                RecLProductionOrder: Record "Production Order";
                RecLProdOrderLine: Record "Prod. Order Line";
                RecLProdOrderComponent: Record "Prod. Order Component";
                RepLRefreshProdOrder: Report "Refresh Production Order";
                ______: Integer;
                Item: Record Item;
                ProdOrderLine: Record "Prod. Order Line";
                ProdOrderRtngLine: Record "Prod. Order Routing Line";
                ProdOrderComp: Record "Prod. Order Component";
                Family: Record Family;
                ProdOrderStatusMgt: Codeunit "Prod. Order Status Management";
                RoutingNo: Code[20];
                CreateProdOrderLines: Codeunit "Create Prod. Order Lines";
                CalcProdOrder: Codeunit "Calculate Prod. Order";
                RecLRoutingHeader: Record "Routing Header";
            begin
                Bdialog.Update(1, IntGCounter);

                IntGCounter -= 1;

                ItemMem."Component Initial Qty" := 0;
                ItemMem.Modify(false);

                if ItemMem.Blocked then
                    CurrReport.Skip;

                if CopyStr(ItemMem."No.", 1, 4) = '9911' then
                    CurrReport.Skip;

                if CopyStr(ItemMem."No.", 1, 4) = '9912' then
                    CurrReport.Skip;

                if CopyStr(ItemMem."No.", 1, 4) = '9915' then
                    CurrReport.Skip;

                if ItemMem."Order Multiple" = 0 then
                    CurrReport.Skip;

                if ItemMem."Inventory Posting Group" = '' then
                    CurrReport.Skip;

                if not RecLRoutingHeader.Get(ItemMem."Routing No.") then
                    CurrReport.Skip;

                if RecLRoutingHeader.Status <> RecLRoutingHeader.Status::Certified then begin
                    ItemMem."Component Initial Qty" := 0;
                    ItemMem.Modify(false);
                    CurrReport.Skip;
                end;

                RecLProductionOrder.Init;
                RecLProductionOrder.Validate(Status, RecLProductionOrder.Status::Simulated);
                RecLProductionOrder.Validate("No.", 'OF_TEMPO_FOR_TPL');
                RecLProductionOrder.Insert(true);
                RecLProductionOrder.Validate("Source No.", ItemMem."No.");
                RecLProductionOrder.Validate(Quantity, ItemMem."Order Multiple");
                RecLProductionOrder.Modify(true);

                Commit;

                //>>>>>>>>>>>> ACTUALISATION >>>>>>>>>>>>>>>>>>>
                RecGProductionOrder.Get(RecLProductionOrder.Status::Simulated, 'OF_TEMPO_FOR_TPL');

                Direction := Direction::Backward;
                CalcLines := true;
                CalcRoutings := true;
                CalcComponents := true;

                Item.Get(RecGProductionOrder."Source No.");
                RoutingNo := Item."Routing No.";
                if RoutingNo <> RecGProductionOrder."Routing No." then begin
                    RecGProductionOrder."Routing No." := RoutingNo;
                    RecGProductionOrder.Modify;
                end;

                ProdOrderLine.LockTable;

                CreateProdOrderLines.Copy(RecGProductionOrder, Direction, '');

                if (Direction = Direction::Backward) and
                   (RecGProductionOrder."Source Type" = RecGProductionOrder."Source Type"::Family)
                then begin
                    RecGProductionOrder.SetUpdateEndDate;
                    RecGProductionOrder.Validate("Due Date", RecGProductionOrder."Due Date");
                end;

                //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                Commit;

                RecLProdOrderLine.SetRange(Status, RecLProdOrderLine.Status::Simulated);
                RecLProdOrderLine.SetRange("Prod. Order No.", 'OF_TEMPO_FOR_TPL');
                if RecLProdOrderLine.FindFirst then begin
                    RecLProdOrderComponent.SetRange(Status, RecLProdOrderComponent.Status::Simulated);
                    RecLProdOrderComponent.SetRange("Prod. Order No.", 'OF_TEMPO_FOR_TPL');
                    RecLProdOrderComponent.SetRange("Prod. Order Line No.", RecLProdOrderLine."Line No.");
                    if RecLProdOrderComponent.FindFirst then begin
                        ItemMem."Component Initial Qty" := RecLProdOrderComponent."Expected Quantity";
                        ItemMem.Modify(false);
                    end;
                end;
                Commit;

                RecLProductionOrder.Get(RecLProductionOrder.Status::Simulated, 'OF_TEMPO_FOR_TPL');
                RecLProductionOrder.Delete(true);
                Commit;
            end;

            trigger OnPostDataItem()
            begin
                if OptGStep = OptGStep::"Step1: Mémorisation qté composant" then begin
                    Bdialog.Close;
                    Message(TxtG004);
                end;
            end;

            trigger OnPreDataItem()
            var
                RecLProductionOrder: Record "Production Order";
            begin
                if OptGStep <> OptGStep::"Step1: Mémorisation qté composant" then
                    CurrReport.Break;

                Bdialog.Open('Step1: Mémorisation qté composant\' +
                             'Enregistrements restants #1########################');
                IntGCounter := ItemMem.Count;

                if RecLProductionOrder.Get(RecLProductionOrder.Status::Simulated, 'OF_TEMPO_FOR_TPL') then
                    RecLProductionOrder.Delete(true);
                Commit;
            end;
        }
        dataitem(RL_Reference; "Routing Line")
        {
            DataItemTableView = SORTING(Type, "No.");
            dataitem(RL_Others; "Routing Line")
            {
                DataItemLink = Type = FIELD(Type), "No." = FIELD("No.");
                DataItemTableView = SORTING(Type, "No.") WHERE("Version Code" = FILTER(''));

                trigger OnAfterGetRecord()
                var
                    RecLItem: Record Item;
                begin
                    Bdialog.Update(1, IntGCounter);
                    Bdialog.Update(2, RL_Reference."Operation No.");

                    IntGCounter -= 1;

                    RecLItem.Reset;
                    RecLItem.SetRange("Routing No.", RL_Others."Routing No.");
                    RecLItem.SetFilter("No.", '9911*');
                    if RecLItem.FindFirst then
                        CurrReport.Skip;

                    RecLItem.SetFilter("No.", '9912*');
                    if RecLItem.FindFirst then
                        CurrReport.Skip;

                    RecLItem.SetFilter("No.", '9915*');
                    if RecLItem.FindFirst then
                        CurrReport.Skip;

                    if not ((RL_Others."Routing No." = RL_Reference."Routing No.") and
                           (RL_Others."Operation No." = RL_Reference."Operation No.")) then begin
                        RecGRoutingHeader.Get(RL_Others."Routing No.");

                        if RecGRoutingHeader.PlanningGroup <> 'PIERRES' then
                            CurrReport.Skip;

                        if RecGRoutingHeader.Status <> RecGRoutingHeader.Status::Closed then begin
                            Stat := RecGRoutingHeader.Status;

                            if (Stat <> Stat::"Under Development") and (Stat <> Stat::Closed) then begin
                                RecGRoutingHeader.Validate(Status, RecGRoutingHeader.Status::"Under Development");
                                RecGRoutingHeader.Modify(true);
                            end;
                            Validate("Scrap Factor %", RL_Reference."Scrap Factor %");

                            RL_Others.Modify(true);
                            if (Stat <> Stat::"Under Development") and (Stat <> Stat::Closed) then begin
                                RecGRoutingHeader.Validate(Status, Stat);
                                RecGRoutingHeader.Modify(true);
                            end;

                        end;
                    end;
                end;

                trigger OnPostDataItem()
                begin
                    if OptGStep = OptGStep::"Step2: MAJ % perte sur Gamme" then begin
                        Bdialog.Close;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    Bdialog.Open('Step2: MAJ % perte sur Gamme pour opération #2#############\Enregistrements restants #1########################');
                    IntGCounter := RL_Others.Count;
                end;
            }
            dataitem(RL_OthersVersion; "Routing Line")
            {
                DataItemLink = Type = FIELD(Type), "No." = FIELD("No.");
                DataItemTableView = SORTING(Type, "No.") WHERE("Version Code" = FILTER(<> ''));

                trigger OnAfterGetRecord()
                var
                    RecLItem: Record Item;
                begin
                    Bdialog.Update(1, IntGCounter);
                    Bdialog.Update(2, RL_Reference."Operation No.");

                    IntGCounter -= 1;

                    RecLItem.Reset;
                    RecLItem.SetRange("Routing No.", RL_OthersVersion."Routing No.");
                    RecLItem.SetFilter("No.", '9911*');
                    if RecLItem.FindFirst then
                        CurrReport.Skip;

                    RecLItem.SetFilter("No.", '9912*');
                    if RecLItem.FindFirst then
                        CurrReport.Skip;

                    RecLItem.SetFilter("No.", '9915*');
                    if RecLItem.FindFirst then
                        CurrReport.Skip;

                    if not ((RL_OthersVersion."Routing No." = RL_Reference."Routing No.") and
                           (RL_OthersVersion."Operation No." = RL_Reference."Operation No.")) then begin
                        RecGRoutingVersion.Get(RL_OthersVersion."Routing No.", RL_OthersVersion."Version Code");

                        RecGRoutingHeader.Get(RL_Others."Routing No.");

                        if RecGRoutingHeader.PlanningGroup <> 'PIERRES' then
                            CurrReport.Skip;

                        if RecGRoutingVersion.Status <> RecGRoutingHeader.Status::Closed then begin
                            Stat := RecGRoutingVersion.Status;

                            if (Stat <> Stat::"Under Development") and (Stat <> Stat::Closed) then begin
                                RecGRoutingVersion.Validate(Status, RecGRoutingVersion.Status::"Under Development");
                                RecGRoutingVersion.Modify(true);
                            end;
                            Validate("Scrap Factor %", RL_Reference."Scrap Factor %");

                            RL_OthersVersion.Modify(true);
                            if (Stat <> Stat::"Under Development") and (Stat <> Stat::Closed) then begin
                                RecGRoutingVersion.Validate(Status, Stat);
                                RecGRoutingVersion.Modify(true);
                            end;

                        end;
                    end;
                end;

                trigger OnPostDataItem()
                begin
                    if OptGStep = OptGStep::"Step2: MAJ % perte sur Gamme" then begin
                        Bdialog.Close;
                        Message(TxtG002);
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    Bdialog.Open('Step2: MAJ % perte sur version Gamme pour opération #2#############\' +
                                 'Enregistrements restants #1########################');
                    IntGCounter := RL_Others.Count;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if CodGPrevCode = "No." then
                    CurrReport.Skip;
                CodGPrevCode := "No.";
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Routing No.", CodGRoutingHeader);
                SetFilter("Operation No.", CodGOperationNo);

                if (OptGStep <> OptGStep::"Step2: MAJ % perte sur Gamme") then
                    CurrReport.Break;
                CodGPrevCode := '';
            end;
        }
        dataitem(ItemMAJ; Item)
        {
            DataItemTableView = SORTING("No.") WHERE("Location Code" = FILTER('PIE'));

            trigger OnAfterGetRecord()
            var
                RecLProdOrderLine: Record "Prod. Order Line";
                RecLProdOrder: Record "Production Order";
                RepLReplanProductionOrder: Report "Replan Production Order";
                RecLRoutingLine: Record "Routing Line";
                Direction: Option Forward,Backward;
                CalcMethod: Option "No Levels","One level","All levels";
                DecLNewQtyGet: Decimal;
            begin
                Bdialog.Update(1, IntGCounter);

                IntGCounter -= 1;

                if ItemMAJ."Component Initial Qty" = 0 then
                    CurrReport.Skip;

                if ItemMem.Blocked then
                    CurrReport.Skip;

                if CopyStr(ItemMAJ."No.", 1, 4) = '9911' then
                    CurrReport.Skip;

                if CopyStr(ItemMem."No.", 1, 4) = '9912' then
                    CurrReport.Skip;

                if CopyStr(ItemMem."No.", 1, 4) = '9915' then
                    CurrReport.Skip;

                if ItemMAJ."Order Multiple" = 0 then
                    CurrReport.Skip;

                if ItemMAJ."Inventory Posting Group" = '' then
                    CurrReport.Skip;

                DecLNewQtyGet := ItemMAJ."Component Initial Qty";

                if ItemMAJ."Scrap %" <> 0 then
                    DecLNewQtyGet := DecLNewQtyGet / (1 + ItemMAJ."Scrap %" / 100);

                RecLRoutingLine.Reset;
                RecLRoutingLine.SetRange("Routing No.", ItemMAJ."Routing No.");
                RecLRoutingLine.SetRange("Version Code", '');
                RecLRoutingLine.SetFilter("Scrap Factor %", '<>%1', 0);
                if RecLRoutingLine.FindFirst then
                    repeat
                        DecLNewQtyGet := DecLNewQtyGet / (1 + RecLRoutingLine."Scrap Factor %" / 100);
                    until RecLRoutingLine.Next = 0;


                DecLNewQtyGet := Round(DecLNewQtyGet, 1);

                ItemMAJ.Validate("Lot Size", DecLNewQtyGet);
                ItemMAJ.Validate("Maximum Order Quantity", DecLNewQtyGet);
                ItemMAJ.Validate("Order Multiple", DecLNewQtyGet);
                ItemMAJ.Modify(true);
            end;

            trigger OnPostDataItem()
            begin
                if OptGStep = OptGStep::"Step3: Calcul de la quantité obtenue" then begin
                    Bdialog.Close;
                    Message(TxtG005);
                end;
            end;

            trigger OnPreDataItem()
            begin
                if OptGStep <> OptGStep::"Step3: Calcul de la quantité obtenue" then
                    CurrReport.Break;

                Bdialog.Open('Step3: Calcul de la quantité obtenue\Enregistrements restants #1########################');
                IntGCounter := ItemMAJ.Count;
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
                    Caption = 'Reference';
                    ShowCaption = false;
                    field(CodGRoutingHeader; CodGRoutingHeader)
                    {
                        Caption = 'Reference Routing No.';
                        ShowCaption = false;
                        TableRelation = "Routing Header"."No.";
                        ApplicationArea = All;

                        trigger OnValidate()
                        var
                            RecLRouting: Record "Routing Header";
                        begin
                            if CodGRoutingHeader <> 'TT_OPE_PIE' then
                                if Confirm(CstL001) then
                                    RecLRouting.Get(CodGRoutingHeader)
                                else
                                    CodGRoutingHeader := 'TT_OPE_PIE';
                        end;
                    }
                    field(CodGOperationNo; CodGOperationNo)
                    {
                        Caption = 'Operation No.';
                        OptionCaption = 'Operations No.';
                        ShowCaption = false;
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            RecLRoutingLines: Record "Routing Line";
                            PagLRoutingLines: Page "Routing Lines choice";
                        begin
                            RecLRoutingLines.SetRange("Routing No.", CodGRoutingHeader);
                            PagLRoutingLines.SetTableView(RecLRoutingLines);
                            PagLRoutingLines.LookupMode(true);
                            if not (PagLRoutingLines.RunModal = ACTION::LookupOK) then begin
                                exit(false);
                            end else begin
                                Text := PagLRoutingLines.GetSelectionFilter;
                                exit(true);
                            end;
                        end;
                    }
                }
                group(Control1000000002)
                {
                    Caption = 'Options';
                    ShowCaption = false;
                    group(Control1100267001)
                    {
                        Caption = 'Ce traitement concerne les gammes qui ont groupe de planification = PIE et qui sont associées à des articles ne commencant pas par 9911,9912 ou 9915';
                        field(OptGStep; OptGStep)
                        {
                            Caption = 'Etape';
                            ApplicationArea = All;
                        }
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            CodGRoutingHeader := 'TT_OPE_PIE';
        end;
    }

    labels
    {
    }

    var
        Stat: Option New,Certified,"Under Development",Closed;
        RecGRoutingHeader: Record "Routing Header";
        TxtG001: Label 'Warning, you are about to update all routings and production orders related to %1 %2 and operation no. %3.';
        TxtG002: Label 'Updated finished.';
        RecGRoutingVersion: Record "Routing Version";
        CodGRoutingHeader: Code[20];
        CodGOperationNo: Code[150];
        CstL001: Label 'The reference routing is not ''TT_OPE_PIE'', do you want to continue ?';
        TxtG004: Label 'Sauvegarde terminée.';
        CodGPrevCode: Code[20];
        TxtG005: Label 'Calcul de la quantité obtenue terminée.';
        OptGStep: Option "Step1: Mémorisation qté composant","Step2: MAJ % perte sur Gamme","Step3: Calcul de la quantité obtenue";
        Bdialog: Dialog;
        IntGCounter: Integer;
        "-------": Integer;
        Direction: Option Forward,Backward;
        CalcLines: Boolean;
        CalcRoutings: Boolean;
        CalcComponents: Boolean;
        CreateInbRqst: Boolean;
        RecGProductionOrder: Record "Production Order";
}

