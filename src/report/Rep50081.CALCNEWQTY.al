report 50081 "PWD CALC NEW QTY"
{
    ProcessingOnly = true;
    UsageCategory = none;
    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = WHERE("Order Multiple" = FILTER(<> 0), "Routing No." = FILTER(<> ''), Blocked = CONST(false), "Production BOM No." = FILTER(<> ''));
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            var
                RecLProdOrderComInit: Record "Prod. Order Component";
                RecLProdOrderComNew: Record "Prod. Order Component";
                RecLBOM: Record "Production BOM Header";
                RecLProdOrderInit: Record "Production Order";
                RecLProdOrderNew: Record "Production Order";
                //RecLOrderBY: Record "PWD New Order By";
                RecLRoutringInit: Record "Routing Header";
                RecLRoutringNew: Record "Routing Header";
                RecLRoutingLineInit: Record "Routing Line";
                RecLRoutingLineNew: Record "Routing Line";
                RecLroutingTTE: Record "Routing Line";
                RepUpdate: Report "Refresh Production Order";
                CodRouting: Code[20];
                DecLInitQty: Decimal;
                DecLNewQty: Decimal;
            begin
                DecLInitQty := 0;
                DecLNewQty := 0;
                // if RecLBOM.Get("Production BOM No.") then begin
                //     if RecLBOM.Status <> RecLBOM.Status::Certified then begin
                //         RecLOrderBY.Init();
                //         RecLOrderBY."Item No." := "No.";
                //         RecLOrderBY."Quantity Comp. Init" := 0;
                //         RecLOrderBY."Quantity Comp. New" := 0;
                //         RecLOrderBY."Qty Order By Init" := Item."Order Multiple";
                //         RecLOrderBY."Qty Order By New" := 0;
                //         RecLOrderBY.Insert();
                //         CurrReport.Skip();
                //     end;
                // end else begin
                //     RecLOrderBY.Init();
                //     RecLOrderBY."Item No." := "No.";
                //     RecLOrderBY."Quantity Comp. Init" := 0;
                //     RecLOrderBY."Quantity Comp. New" := 0;
                //     RecLOrderBY."Qty Order By Init" := Item."Order Multiple";
                //     RecLOrderBY."Qty Order By New" := 0;
                //     RecLOrderBY.Insert();
                //     CurrReport.Skip();
                // end;
                //Calcul Quantité Composant Initiale
                if RecLProdOrderInit.Get(RecLProdOrderInit.Status::Simulated, 'INIT') then
                    RecLProdOrderInit.Delete(true);

                RecLProdOrderInit.Init();
                RecLProdOrderInit.Validate(Status, RecLProdOrderInit.Status::Simulated);
                RecLProdOrderInit.Validate("No.", 'INIT');
                RecLProdOrderInit.Validate("Source Type", RecLProdOrderInit."Source Type"::Item);
                RecLProdOrderInit.Validate("Source No.", "No.");
                RecLProdOrderInit.Validate(Quantity, Item."Order Multiple");
                RecLProdOrderInit.Insert(true);
                Commit();
                Clear(RepUpdate);
                RecLProdOrderInit.SetRange(Status, RecLProdOrderInit.Status::Simulated);
                RecLProdOrderInit.SetRange("No.", 'INIT');
                RepUpdate.SetTableView(RecLProdOrderInit);
                RepUpdate.UseRequestPage(false);
                RepUpdate.RunModal();
                //REPORT.RUNMODAL(REPORT::"Refresh Production Order",FALSE,FALSE,RecLProdOrderInit);
                if RecLProdOrderComInit.Get(RecLProdOrderInit.Status, RecLProdOrderInit."No.", 10000, 10000) then
                    DecLInitQty := RecLProdOrderComInit."Expected Quantity";

                //Calcul Quantité Composant Nouvelle
                CodRouting := "Routing No.";
                if RecLProdOrderInit.Get(RecLProdOrderInit.Status::Simulated, 'NEW') then
                    RecLProdOrderInit.Delete(true);

                RecLRoutringInit.Get("Routing No.");

                if RecLRoutringNew.Get('NEW') then begin
                    RecLRoutringNew.Validate(Status, RecLRoutringNew.Status::"Under Development");
                    RecLRoutringNew.Delete(true);
                end;
                RecLRoutringNew.Init();
                RecLRoutringNew.Validate("No.", 'NEW');
                RecLRoutringNew.Insert(true);
                RecLRoutringNew.Validate(Type, RecLRoutringInit.Type);
                RecLRoutringNew.Validate(Status, RecLRoutringNew.Status::"Under Development");
                RecLRoutringNew.Modify();

                RecLRoutingLineInit.SetRange("Routing No.", RecLRoutringInit."No.");
                if RecLRoutingLineInit.FindSet() then
                    repeat
                        RecLRoutingLineNew := RecLRoutingLineInit;
                        RecLRoutingLineNew.Validate("Routing No.", 'NEW');
                        RecLRoutingLineNew.Insert();
                        RecLroutingTTE.SetRange("Routing No.", 'TT_OPE_PIE');
                        RecLroutingTTE.SetRange(Type, RecLRoutingLineInit.Type);
                        RecLroutingTTE.SetRange("No.", RecLRoutingLineInit."No.");
                        if RecLroutingTTE.FindFirst() then begin
                            RecLRoutingLineNew.Validate("Scrap Factor %", RecLroutingTTE."Scrap Factor %");
                            RecLRoutingLineNew.Modify();
                        end;
                    until RecLRoutingLineInit.Next() = 0;
                RecLRoutringNew.Validate(Status, RecLRoutringNew.Status::Certified);
                RecLRoutringNew.Modify();

                Validate("Routing No.", 'NEW');

                RecLProdOrderNew.Init();
                RecLProdOrderNew.Validate(Status, RecLProdOrderNew.Status::Simulated);
                RecLProdOrderNew.Validate("No.", 'NEW');
                RecLProdOrderNew.Validate("Source Type", RecLProdOrderNew."Source Type"::Item);
                RecLProdOrderNew.Validate("Source No.", "No.");
                RecLProdOrderNew.Validate("Routing No.", 'NEW');
                RecLProdOrderNew.Validate(Quantity, Item."Order Multiple");
                RecLProdOrderNew.Insert(true);

                Clear(RepUpdate);
                RecLProdOrderNew.SetRange(Status, RecLProdOrderNew.Status::Simulated);
                RecLProdOrderNew.SetRange("No.", 'NEW');
                RepUpdate.SetTableView(RecLProdOrderNew);
                RepUpdate.UseRequestPage(false);
                RepUpdate.RunModal();
                if RecLProdOrderComNew.Get(RecLProdOrderNew.Status, RecLProdOrderNew."No.", 10000, 10000) then
                    DecLNewQty := RecLProdOrderComNew."Expected Quantity";

                Validate("Routing No.", CodRouting);
                Modify();

                // RecLOrderBY.Init();
                // RecLOrderBY."Item No." := "No.";
                // RecLOrderBY."Quantity Comp. Init" := DecLInitQty;
                // RecLOrderBY."Quantity Comp. New" := DecLNewQty;
                // RecLOrderBY."Qty Order By Init" := Item."Order Multiple";
                // if DecLNewQty <> 0 then
                //     RecLOrderBY."Qty Order By New" := Round((DecLInitQty / DecLNewQty) * Item."Order Multiple", 1)
                // else
                //     RecLOrderBY."Qty Order By New" := 0;
                // RecLOrderBY.Insert();
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
}

