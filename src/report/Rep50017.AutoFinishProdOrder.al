report 50017 "PWD Auto. Finish Prod. Order"
{
    // //>>LAP2.23
    // TDL100220.001 : Modification propriété DataItemTableView
    //                Old : SORTING(Status,No.) WHERE(Status=CONST(Released),Location Code=FILTER(<>ACI))
    //                New : SORTING(Status,No.) WHERE(Status=CONST(Released))

    ProcessingOnly = true;

    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            DataItemTableView = SORTING(Status, "No.") WHERE(Status = CONST(Released));

            trigger OnAfterGetRecord()
            begin
                if FctCloseProdOrder("Production Order") then begin
                    BooGAlterCons := false;
                    CheckBeforeFinishProdOrder("Production Order", BooGAlterCons);
                    DeleteReqLine("Production Order");
                    if not BooGAlterCons then begin
                        LPSAFunctionsMgt.SetNoFinishCOntrol(true);
                        CduProdOrderStatusMgt.ChangeStatusOnProdOrder("Production Order",
                          "Production Order".Status::Finished,
                          WorkDate(),
                          true);
                    end;
                end;
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
        CduProdOrderStatusMgt: Codeunit "Prod. Order Status Management";
        LPSAFunctionsMgt: codeunit "PWD LPSA Functions Mgt.";
        BooGAlterCons: Boolean;


    procedure FctCloseProdOrder(RecPProdOrder: Record "Production Order") TobeClosed: Boolean
    var
        RecLIJ: Record "Item Journal Line";
        RecLProdOrderRoutingLine: Record "Prod. Order Routing Line";
        RecLIJLB: Record "PWD Item Jounal Line Buffer";
    begin
        RecLProdOrderRoutingLine.Reset();
        RecLProdOrderRoutingLine.SetRange(Status, RecPProdOrder.Status);
        RecLProdOrderRoutingLine.SetRange("Prod. Order No.", RecPProdOrder."No.");
        RecLProdOrderRoutingLine.SetRange(Type, RecLProdOrderRoutingLine.Type::"Machine Center");
        RecLProdOrderRoutingLine.SetRange("No.", 'M99999');
        if RecLProdOrderRoutingLine.FindFirst() then begin
            RecLProdOrderRoutingLine.SetRange("Routing Status", RecLProdOrderRoutingLine."Routing Status"::Finished);
            if RecLProdOrderRoutingLine.FindFirst() then
                exit(true)
            else begin
                //>>TMP - Vérification dans le log QUARTIS
                RecLIJLB.SetRange("Prod. Order No.", RecPProdOrder."No.");
                RecLIJLB.SetRange(Status, RecLIJLB.Status::Inserted);
                RecLIJLB.SetRange(Type, RecLIJLB.Type::"Machine Center");
                RecLIJLB.SetRange("No.", 'M99999');
                RecLIJLB.SetRange(Finished, true);
                if RecLIJLB.FindFirst() then begin
                    RecLIJ.SetRange("Order No.", RecPProdOrder."No.");
                    if RecLIJ.IsEmpty then
                        exit(true)
                    else
                        exit(false);
                end else
                    exit(false);
            end;
            //<<TMP - Vérification dans le log QUARTIS
        end
        else
            exit(false);
    end;


    procedure CheckBeforeFinishProdOrder(ProdOrder: Record "Production Order"; var AlterCons: Boolean) TobeClosed: Boolean
    var
        ProdOrderComp: Record "Prod. Order Component";
        PurchLine: Record "Purchase Line";
    begin
        with PurchLine do begin
            SetCurrentKey("Document Type", Type, "Prod. Order No.", "Prod. Order Line No.", "Routing No.", "Operation No.");
            SetRange("Document Type", "Document Type"::Order);
            SetRange(Type, Type::Item);
            SetRange("Prod. Order No.", ProdOrder."No.");
            SetFilter("Outstanding Quantity", '<>%1', 0);
            if FindFirst() then
                exit(false);
        end;

        /*
        //It is normal that some output are missing, so the control is not done
        WITH ProdOrderLine DO BEGIN
          SETRANGE(Status,ProdOrder.Status);
          SETRANGE("Prod. Order No.",ProdOrder."No.");
          SETFILTER("Remaining Quantity",'<>0');
          IF NOT ISEMPTY THEN BEGIN
            ProdOrderRtngLine.SETRANGE(Status,ProdOrder.Status);
            ProdOrderRtngLine.SETRANGE("Prod. Order No.",ProdOrder."No.");
            ProdOrderRtngLine.SETRANGE("Next Operation No.",'');
            IF NOT ProdOrderRtngLine.ISEMPTY THEN BEGIN
              ProdOrderRtngLine.SETFILTER("Flushing Method",'<>%1',ProdOrderRtngLine."Flushing Method"::Backward);
              ShowWarning := NOT ProdOrderRtngLine.ISEMPTY;
            END ELSE
              ShowWarning := TRUE;
        
            IF ShowWarning THEN BEGIN
              EXIT(FALSE);
            END;
          END;
        END;
        */

        with ProdOrderComp do begin
            SetRange(Status, ProdOrder.Status);
            SetRange("Prod. Order No.", ProdOrder."No.");
            SetFilter("Remaining Quantity", '<>0');
            if FindSet() then
                repeat
                    if (("Flushing Method" <> "Flushing Method"::Backward) and
                        ("Flushing Method" <> "Flushing Method"::"Pick + Backward") and
                        ("Routing Link Code" = '')) or
                       (("Routing Link Code" <> '') and not RtngWillFlushComp(ProdOrderComp))
                    then begin
                        exit(true);
                        AlterCons := true;
                    end;
                until Next() = 0;
        end;
        exit(true);

    end;

    local procedure RtngWillFlushComp(ProdOrderComp: Record "Prod. Order Component"): Boolean
    var
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderRtngLine: Record "Prod. Order Routing Line";
    begin
        if ProdOrderComp."Routing Link Code" = '' then
            exit;

        with ProdOrderComp do
            ProdOrderLine.Get(Status, "Prod. Order No.", "Prod. Order Line No.");

        with ProdOrderRtngLine do begin
            SetCurrentKey("Prod. Order No.", Status, "Flushing Method");
            SetRange("Flushing Method", "Flushing Method"::Backward);
            SetRange(Status, Status::Released);
            SetRange("Prod. Order No.", ProdOrderComp."Prod. Order No.");
            SetRange("Routing Link Code", ProdOrderComp."Routing Link Code");
            SetRange("Routing No.", ProdOrderLine."Routing No.");
            SetRange("Routing Reference No.", ProdOrderLine."Routing Reference No.");
            exit(FindFirst());
        end;
    end;


    procedure DeleteReqLine(RecPProdOrder: Record "Production Order")
    var
        RecLReqLine: Record "Requisition Line";
    begin
        RecLReqLine.Reset();
        RecLReqLine.SetRange("Ref. Order No.", RecPProdOrder."No.");
        if RecLReqLine.FindFirst() then
            repeat
                RecLReqLine.Delete(true);
            until RecLReqLine.Next() = 0;
    end;
}

