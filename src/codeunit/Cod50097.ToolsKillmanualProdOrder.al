codeunit 50097 "Tools Kill manual Prod Order"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+

    Permissions = TableData "Source Code Setup" = r,
                  TableData "Production Order" = rimd,
                  TableData "Prod. Order Capacity Need" = rid;
    TableNo = "Production Order";

    trigger OnRun()
    var
        RecLProductionOrder: Record "Production Order";
        ChangeStatusForm: Page "Change Status on Prod. Order";
    begin
        RecLProductionOrder.GET(RecLProductionOrder.Status::Released, Rec."No.");

        ChangeStatusForm.Set(RecLProductionOrder);
        IF ChangeStatusForm.RUNMODAL() = ACTION::Yes THEN BEGIN
            ChangeStatusForm.ReturnPostingInfo(NewStatus, NewPostingDate, NewUpdateUnitCost);
            ChangeStatusOnProdOrder(RecLProductionOrder, NewStatus, NewPostingDate, NewUpdateUnitCost);
            COMMIT();
            MESSAGE(Text000, RecLProductionOrder.Status, RecLProductionOrder.TABLECAPTION,
            RecLProductionOrder."No.", ToProdOrder.Status, ToProdOrder.TABLECAPTION, ToProdOrder."No.")
        END;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        Item: Record Item;
        ToProdOrder: Record "Production Order";
        // SourceCodeSetup: Record "Source Code Setup";
        ACYMgt: Codeunit "Additional-Currency Management";
        InvtAdjmt: Codeunit "Inventory Adjustment";
        ReserveProdOrderComp: Codeunit "Prod. Order Comp.-Reserve";
        ReserveProdOrderLine: Codeunit "Prod. Order Line-Reserve";
        ReservMgt: Codeunit "Reservation Management";
        UpdateProdOrderCost: Codeunit "Update Prod. Order Cost";
        WhseOutputProdRelease: Codeunit "Whse.-Output Prod. Release";
        WhseProdRelease: Codeunit "Whse.-Production Release";
        BooGAvoidControl: Boolean;
        HasGLSetup: Boolean;
        NewUpdateUnitCost: Boolean;
        // SourceCodeSetupRead: Boolean;
        NewPostingDate: Date;
        Text000: Label '%2 %3  with status %1 has been changed to %5 %6 with status %4.';
        Text004: Label '%1 %2 has not been finished. Some output is still missing. Do you still want to finish the order?';
        Text005: Label 'The update has been interrupted to respect the warning.';
        Text006: Label '%1 %2 has not been finished. Some consumption is still missing. Do you still want to finish the order?';
        Text007: Label 'The status of order %1 cannot be changed as it is related to planning line %2 in worksheet %3 %4.';
        Text008: Label '%1 %2 cannot be finished as the associated subcontract order %3 has not been fully delivered.';
        Text009: Label 'You cannot finish line %1 on %2 %3. It has consumption or capacity posted with no output.';
        Text010: Label 'You must specify a %1 in %2 %3 %4.';
        Txt50000: Label 'There is a phantom item for Line no. %1';
        NewStatus: Enum "Production Order Status";


    procedure ChangeStatusOnProdOrder(ProdOrder: Record "Production Order"; NewStatus: Enum "Production Order Status"; NewPostingDate: Date; NewUpdateUnitCost: Boolean)
    begin
        SetPostingInfo(NewStatus, NewPostingDate, NewUpdateUnitCost);
        ErrorIfInPlanningWksh(ProdOrder);
        IF NewStatus = NewStatus::Finished THEN BEGIN
            //>>DEVTDL10/01/2014
            IF NOT BooGAvoidControl THEN
                //<<DEVTDL10/01/2014
                CheckBeforeFinishProdOrder(ProdOrder);
            FlushProdOrder(ProdOrder, NewStatus, NewPostingDate);
            //ErrorIfUnableToClearWIP(ProdOrder);
            TransProdOrder(ProdOrder);

            WhseProdRelease.FinishedDelete(ProdOrder);
            WhseOutputProdRelease.FinishedDelete(ProdOrder);
        END ELSE BEGIN
            TransProdOrder(ProdOrder);
            FlushProdOrder(ProdOrder, NewStatus, NewPostingDate);
            WhseProdRelease.Release(ProdOrder);
        END;
        COMMIT();

        CLEAR(InvtAdjmt);
    end;

    local procedure TransProdOrder(var FromProdOrder: Record "Production Order")
    var
        ToProdOrderLine: Record "Prod. Order Line";
    begin
        ToProdOrderLine.LOCKTABLE();

        ToProdOrder := FromProdOrder;
        ToProdOrder.Status := NewStatus;

        CASE FromProdOrder.Status OF
            FromProdOrder.Status::Simulated:
                ToProdOrder."Simulated Order No." := FromProdOrder."No.";
            FromProdOrder.Status::Planned:
                ToProdOrder."Planned Order No." := FromProdOrder."No.";
            FromProdOrder.Status::"Firm Planned":
                ToProdOrder."Firm Planned Order No." := FromProdOrder."No.";
            FromProdOrder.Status::Released:
                ToProdOrder."Finished Date" := NewPostingDate;
        END;


        //>>FE_LAPIERRETTE_PROD01.001: TO 13/12/2011
        //ToProdOrder.TestNoSeries;
        //IF (ToProdOrder.GetNoSeriesCode <> GetNoSeriesCode) AND
        //   (ToProdOrder.Status <> ToProdOrder.Status::Finished)
        //THEN
        //  ToProdOrder."No." := '';

        IF FromProdOrder."PWD Transmitted Order No." THEN BEGIN
            ToProdOrder."No." := FromProdOrder."No.";
            ToProdOrder."PWD Transmitted Order No." := TRUE;
            ToProdOrder."PWD Original Source No." := FromProdOrder."PWD Original Source No.";
            ToProdOrder."PWD Original Source Position" := FromProdOrder."PWD Original Source Position";
        END ELSE BEGIN
            ToProdOrder.TestNoSeries();
            IF (ToProdOrder.GetNoSeriesCode() <> FromProdOrder.GetNoSeriesCode()) AND
               (ToProdOrder.Status <> ToProdOrder.Status::Finished)
            THEN
                ToProdOrder."No." := '';
        END;
        //<<FE_LAPIERRETTE_PROD01.001: TO 13/12/2011
        // ToProdOrder.INSERT(TRUE);
        // ToProdOrder."Starting Date-Time" := FromProdOrder."Starting Date-Time";
        // ToProdOrder."Ending Date-Time" := FromProdOrder."Ending Date-Time";
        // ToProdOrder."Due Date" := FromProdOrder."Due Date";
        // ToProdOrder.VALIDATE("Shortcut Dimension 1 Code", '');
        // ToProdOrder.VALIDATE("Shortcut Dimension 2 Code", '');
        // ToProdOrder."Shortcut Dimension 1 Code" := FromProdOrder."Shortcut Dimension 1 Code";
        // ToProdOrder."Shortcut Dimension 2 Code" := FromProdOrder."Shortcut Dimension 2 Code";
        ToProdOrder.Insert(true);
        ToProdOrder."Starting Date-Time" := FromProdOrder."Starting Date-Time";
        ToProdOrder."Ending Date-Time" := FromProdOrder."Ending Date-Time";
        ToProdOrder.UpdateDatetime();
        ToProdOrder."Due Date" := FromProdOrder."Due Date";
        ToProdOrder."Shortcut Dimension 1 Code" := FromProdOrder."Shortcut Dimension 1 Code";
        ToProdOrder."Shortcut Dimension 2 Code" := FromProdOrder."Shortcut Dimension 2 Code";
        ToProdOrder."Dimension Set ID" := FromProdOrder."Dimension Set ID";

        //>>LPSA2.06
        ToProdOrder."PWD Selection" := FALSE;
        //<<LPSA2.06

        ToProdOrder.MODIFY();

        TransProdOrderLine(FromProdOrder);
        TransProdOrderRtngLine(FromProdOrder);
        TransProdOrderComp(FromProdOrder);
        TransProdOrderRtngTool(FromProdOrder);
        // PLAW1 2.1
        // TransProdOrderRtngLineAlt(FromProdOrder);
        // PLAW1 2.1 END
        TransProdOrderRtngPersnl(FromProdOrder);
        TransProdOrdRtngQltyMeas(FromProdOrder);
        TransProdOrderCmtLine(FromProdOrder);
        TransProdOrderRtngCmtLn(FromProdOrder);
        TransProdOrderBOMCmtLine(FromProdOrder);
        // TransProdOrderDocDim(FromProdOrder);
        TransProdOrderCapNeed(FromProdOrder);
        //PLAW1 2.1 transport prod order links
        // TransProdOrderLink(FromProdOrder);
        //PLAW1 2.1 END
        FromProdOrder.DELETE();
        FromProdOrder := ToProdOrder;
    end;

    local procedure TransProdOrderLine(FromProdOrder: Record "Production Order")
    var
        FromProdOrderLine: Record "Prod. Order Line";
        ToProdOrderLine: Record "Prod. Order Line";
        InvtAdjmtEntryOrder: Record "Inventory Adjmt. Entry (Order)";
    begin
        FromProdOrderLine.SETRANGE(Status, FromProdOrder.Status);
        FromProdOrderLine.SETRANGE("Prod. Order No.", FromProdOrder."No.");
        FromProdOrderLine.LOCKTABLE();
        IF FromProdOrderLine.FINDSET() THEN BEGIN
            REPEAT
                //>>FE_LAPRIERRETTE_GP0003 : APA 16/05/2013
                IF (FromProdOrderLine.ExistPhantomItem() <> '') AND (NewStatus = NewStatus::Released) THEN
                    ERROR(Txt50000, FromProdOrderLine."Line No.");
                //<<FE_LAPRIERRETTE_GP0003 : APA 16/05/2013
                ToProdOrderLine := FromProdOrderLine;
                ToProdOrderLine.Status := ToProdOrder.Status;
                ToProdOrderLine."Prod. Order No." := ToProdOrder."No.";
                ToProdOrderLine.INSERT();
                IF NewStatus = NewStatus::Finished THEN BEGIN
                    if InvtAdjmtEntryOrder.Get(InvtAdjmtEntryOrder."Order Type"::Production, ToProdOrderLine."Prod. Order No.", ToProdOrderLine."Line No.") then begin
                        InvtAdjmtEntryOrder."Routing No." := ToProdOrderLine."Routing No.";
                        InvtAdjmtEntryOrder.Modify();
                    end else
                        InvtAdjmtEntryOrder.SetProdOrderLine(FromProdOrderLine);
                    InvtAdjmtEntryOrder."Cost is Adjusted" := false;
                    InvtAdjmtEntryOrder."Is Finished" := true;
                    InvtAdjmtEntryOrder.Modify();
                    IF NewUpdateUnitCost THEN
                        UpdateProdOrderCost.UpdateUnitCostOnProdOrder(FromProdOrderLine, TRUE, TRUE);
                    ToProdOrderLine."Unit Cost (ACY)" :=
                      ACYMgt.CalcACYAmt(ToProdOrderLine."Unit Cost", NewPostingDate, TRUE);
                    ToProdOrderLine."Cost Amount (ACY)" :=
                      ACYMgt.CalcACYAmt(ToProdOrderLine."Cost Amount", NewPostingDate, FALSE);
                    ReservMgt.SetReservSource(FromProdOrderLine);
                    ReservMgt.DeleteReservEntries(TRUE, 0);
                END ELSE BEGIN
                    IF Item.GET(FromProdOrderLine."Item No.") THEN
                        IF (Item."Costing Method" <> Item."Costing Method"::Standard) AND NewUpdateUnitCost THEN
                            UpdateProdOrderCost.UpdateUnitCostOnProdOrder(FromProdOrderLine, FALSE, TRUE);
                    ToProdOrderLine.BlockDynamicTracking(TRUE);
                    ToProdOrderLine.VALIDATE(Quantity);
                    ReserveProdOrderLine.TransferPOLineToPOLine(FromProdOrderLine, ToProdOrderLine, 0, TRUE);
                END;
                ToProdOrderLine.VALIDATE("Unit Cost", FromProdOrderLine."Unit Cost");
                ToProdOrderLine.MODIFY();
            UNTIL FromProdOrderLine.NEXT() = 0;
            FromProdOrderLine.DELETEALL();
        END;
    end;

    local procedure TransProdOrderRtngLine(FromProdOrder: Record "Production Order")
    var
        FromProdOrderRtngLine: Record "Prod. Order Routing Line";
        ToProdOrderRtngLine: Record "Prod. Order Routing Line";
    begin
        FromProdOrderRtngLine.SETRANGE(Status, FromProdOrder.Status);
        FromProdOrderRtngLine.SETRANGE("Prod. Order No.", FromProdOrder."No.");
        FromProdOrderRtngLine.LOCKTABLE();
        IF FromProdOrderRtngLine.FINDSET() THEN BEGIN
            REPEAT
                ToProdOrderRtngLine := FromProdOrderRtngLine;
                ToProdOrderRtngLine.Status := ToProdOrder.Status;
                ToProdOrderRtngLine."Prod. Order No." := ToProdOrder."No.";
                IF ToProdOrder.Status = ToProdOrder.Status::Released THEN
                    ToProdOrderRtngLine."Routing Status" := FromProdOrderRtngLine."Routing Status"::Planned;
                ToProdOrderRtngLine.INSERT();
            UNTIL FromProdOrderRtngLine.NEXT() = 0;
            FromProdOrderRtngLine.DELETEALL();
        END;
    end;

    local procedure TransProdOrderComp(FromProdOrder: Record "Production Order")
    var
        Location: Record Location;
        FromProdOrderComp: Record "Prod. Order Component";
        ToProdOrderComp: Record "Prod. Order Component";
    begin
        FromProdOrderComp.SETRANGE(Status, FromProdOrder.Status);
        FromProdOrderComp.SETRANGE("Prod. Order No.", FromProdOrder."No.");
        FromProdOrderComp.LOCKTABLE();
        IF FromProdOrderComp.FINDSET() THEN BEGIN
            REPEAT
                IF Location.GET(FromProdOrderComp."Location Code") AND
                   Location."Bin Mandatory" AND
                   NOT Location."Directed Put-away and Pick" AND
                   (FromProdOrderComp.Status = FromProdOrderComp.Status::"Firm Planned") AND
                   (ToProdOrder.Status = ToProdOrder.Status::Released) AND
                   (FromProdOrderComp."Flushing Method" IN [FromProdOrderComp."Flushing Method"::Forward, FromProdOrderComp."Flushing Method"::"Pick + Forward"]) AND
                   (FromProdOrderComp."Routing Link Code" = '') AND
                   (FromProdOrderComp."Bin Code" = '')
                THEN
                    ERROR(
                      Text010,
                      FromProdOrderComp.FIELDCAPTION("Bin Code"),
                      FromProdOrderComp.TABLECAPTION,
                      FromProdOrderComp.FIELDCAPTION("Line No."),
                      FromProdOrderComp."Line No.");
                ToProdOrderComp := FromProdOrderComp;
                ToProdOrderComp.Status := ToProdOrder.Status;
                ToProdOrderComp."Prod. Order No." := ToProdOrder."No.";
                ToProdOrderComp.INSERT();
                IF NewStatus = NewStatus::Finished THEN BEGIN
                    ReservMgt.SetReservSource(FromProdOrderComp);
                    ReservMgt.DeleteReservEntries(TRUE, 0);
                END ELSE BEGIN
                    ToProdOrderComp.BlockDynamicTracking(TRUE);
                    ToProdOrderComp.VALIDATE("Expected Quantity");
                    ReserveProdOrderComp.TransferPOCompToPOComp(FromProdOrderComp, ToProdOrderComp, 0, TRUE);
                    IF ToProdOrderComp.Status IN [ToProdOrderComp.Status::"Firm Planned", ToProdOrderComp.Status::Released] THEN
                        ToProdOrderComp.AutoReserve();
                END;
                ToProdOrderComp.MODIFY();
            UNTIL FromProdOrderComp.NEXT() = 0;
            FromProdOrderComp.DELETEALL();
        END;
    end;

    local procedure TransProdOrderRtngTool(FromProdOrder: Record "Production Order")
    var
        FromProdOrderRtngTool: Record "Prod. Order Routing Tool";
        ToProdOrderRoutTool: Record "Prod. Order Routing Tool";
    begin
        FromProdOrderRtngTool.SETRANGE(Status, FromProdOrder.Status);
        FromProdOrderRtngTool.SETRANGE("Prod. Order No.", FromProdOrder."No.");
        FromProdOrderRtngTool.LOCKTABLE();
        IF FromProdOrderRtngTool.FINDSET() THEN BEGIN
            REPEAT
                ToProdOrderRoutTool := FromProdOrderRtngTool;
                ToProdOrderRoutTool.Status := ToProdOrder.Status;
                ToProdOrderRoutTool."Prod. Order No." := ToProdOrder."No.";
                ToProdOrderRoutTool.INSERT();
            UNTIL FromProdOrderRtngTool.NEXT() = 0;
            FromProdOrderRtngTool.DELETEALL();
        END;
    end;

    local procedure TransProdOrderRtngPersnl(FromProdOrder: Record "Production Order")
    var
        FromProdOrderRtngPersonnel: Record "Prod. Order Routing Personnel";
        ToProdOrderRtngPersonnel: Record "Prod. Order Routing Personnel";
    begin
        FromProdOrderRtngPersonnel.SETRANGE(Status, FromProdOrder.Status);
        FromProdOrderRtngPersonnel.SETRANGE("Prod. Order No.", FromProdOrder."No.");
        FromProdOrderRtngPersonnel.LOCKTABLE();
        IF FromProdOrderRtngPersonnel.FINDSET() THEN BEGIN
            REPEAT
                ToProdOrderRtngPersonnel := FromProdOrderRtngPersonnel;
                ToProdOrderRtngPersonnel.Status := ToProdOrder.Status;
                ToProdOrderRtngPersonnel."Prod. Order No." := ToProdOrder."No.";
                ToProdOrderRtngPersonnel.INSERT();
            UNTIL FromProdOrderRtngPersonnel.NEXT() = 0;
            FromProdOrderRtngPersonnel.DELETEALL();
        END;
    end;

    local procedure TransProdOrdRtngQltyMeas(FromProdOrder: Record "Production Order")
    var
        FromProdOrderRtngQltyMeas: Record "Prod. Order Rtng Qlty Meas.";
        ToProdOrderRtngQltyMeas: Record "Prod. Order Rtng Qlty Meas.";
    begin
        FromProdOrderRtngQltyMeas.SETRANGE(Status, FromProdOrder.Status);
        FromProdOrderRtngQltyMeas.SETRANGE("Prod. Order No.", FromProdOrder."No.");
        FromProdOrderRtngQltyMeas.LOCKTABLE();
        IF FromProdOrderRtngQltyMeas.FINDSET() THEN BEGIN
            REPEAT
                ToProdOrderRtngQltyMeas := FromProdOrderRtngQltyMeas;
                ToProdOrderRtngQltyMeas.Status := ToProdOrder.Status;
                ToProdOrderRtngQltyMeas."Prod. Order No." := ToProdOrder."No.";
                ToProdOrderRtngQltyMeas.INSERT();
            UNTIL FromProdOrderRtngQltyMeas.NEXT() = 0;
            FromProdOrderRtngQltyMeas.DELETEALL();
        END;
    end;

    local procedure TransProdOrderCmtLine(FromProdOrder: Record "Production Order")
    var
        FromProdOrderCommentLine: Record "Prod. Order Comment Line";
        ToProdOrderCommentLine: Record "Prod. Order Comment Line";
    begin
        FromProdOrderCommentLine.SETRANGE(Status, FromProdOrder.Status);
        FromProdOrderCommentLine.SETRANGE("Prod. Order No.", FromProdOrder."No.");
        FromProdOrderCommentLine.LOCKTABLE();
        IF FromProdOrderCommentLine.FINDSET() THEN BEGIN
            REPEAT
                ToProdOrderCommentLine := FromProdOrderCommentLine;
                ToProdOrderCommentLine.Status := ToProdOrder.Status;
                ToProdOrderCommentLine."Prod. Order No." := ToProdOrder."No.";
                ToProdOrderCommentLine.INSERT();
            UNTIL FromProdOrderCommentLine.NEXT() = 0;
            FromProdOrderCommentLine.DELETEALL();
        END;
        ToProdOrder.COPYLINKS(FromProdOrder);
    end;

    local procedure TransProdOrderRtngCmtLn(FromProdOrder: Record "Production Order")
    var
        FromProdOrderRtngComment: Record "Prod. Order Rtng Comment Line";
        ToProdOrderRtngComment: Record "Prod. Order Rtng Comment Line";
    begin
        FromProdOrderRtngComment.SETRANGE(Status, FromProdOrder.Status);
        FromProdOrderRtngComment.SETRANGE("Prod. Order No.", FromProdOrder."No.");
        FromProdOrderRtngComment.LOCKTABLE();
        IF FromProdOrderRtngComment.FINDSET() THEN BEGIN
            REPEAT
                ToProdOrderRtngComment := FromProdOrderRtngComment;
                ToProdOrderRtngComment.Status := ToProdOrder.Status;
                ToProdOrderRtngComment."Prod. Order No." := ToProdOrder."No.";
                ToProdOrderRtngComment.INSERT();
            UNTIL FromProdOrderRtngComment.NEXT() = 0;
            FromProdOrderRtngComment.DELETEALL();
        END;
    end;

    local procedure TransProdOrderBOMCmtLine(FromProdOrder: Record "Production Order")
    var
        FromProdOrderBOMComment: Record "Prod. Order Comp. Cmt Line";
        ToProdOrderBOMComment: Record "Prod. Order Comp. Cmt Line";
    begin
        FromProdOrderBOMComment.SETRANGE(Status, FromProdOrder.Status);
        FromProdOrderBOMComment.SETRANGE("Prod. Order No.", FromProdOrder."No.");
        FromProdOrderBOMComment.LOCKTABLE();
        IF FromProdOrderBOMComment.FINDSET() THEN BEGIN
            REPEAT
                ToProdOrderBOMComment := FromProdOrderBOMComment;
                ToProdOrderBOMComment.Status := ToProdOrder.Status;
                ToProdOrderBOMComment."Prod. Order No." := ToProdOrder."No.";
                ToProdOrderBOMComment.INSERT();
            UNTIL FromProdOrderBOMComment.NEXT() = 0;
            FromProdOrderBOMComment.DELETEALL();
        END;
    end;

    // local procedure TransProdOrderDocDim(FromProdOrder: Record "Production Order")
    // var
    // FromProdDocDim : Record "Production Document Dimension";
    // begin
    // WITH FromProdDocDim DO BEGIN
    //     SETRANGE("Table ID", DATABASE::"Production Order");
    //     SETRANGE("Document Status", FromProdOrder.Status);
    //     SETRANGE("Document No.", FromProdOrder."No.");
    //     DimMgt.MoveProdDocDimToProdDocDim(
    //       FromProdDocDim, DATABASE::"Production Order", ToProdOrder.Status, ToProdOrder."No.");
    //     DELETEALL;
    //     SETRANGE("Table ID", DATABASE::"Prod. Order Line");
    //     DimMgt.MoveProdDocDimToProdDocDim(
    //       FromProdDocDim, DATABASE::"Prod. Order Line", ToProdOrder.Status, ToProdOrder."No.");
    //     DELETEALL;
    //     SETRANGE("Table ID", DATABASE::"Prod. Order Component");
    //     DimMgt.MoveProdDocDimToProdDocDim(
    //       FromProdDocDim, DATABASE::"Prod. Order Component", ToProdOrder.Status, ToProdOrder."No.");
    //     DELETEALL;
    // end;
    // end;

    local procedure TransProdOrderCapNeed(FromProdOrder: Record "Production Order")
    var
        FromProdOrderCapNeed: Record "Prod. Order Capacity Need";
        ToProdOrderCapNeed: Record "Prod. Order Capacity Need";
    begin
        FromProdOrderCapNeed.SETRANGE(Status, FromProdOrder.Status);
        FromProdOrderCapNeed.SETRANGE("Prod. Order No.", FromProdOrder."No.");
        FromProdOrderCapNeed.SETRANGE("Requested Only", FALSE);
        IF NewStatus = NewStatus::Finished THEN
            FromProdOrderCapNeed.DELETEALL()
        ELSE BEGIN
            FromProdOrderCapNeed.LOCKTABLE();
            IF FromProdOrderCapNeed.FINDSET() THEN BEGIN
                REPEAT
                    ToProdOrderCapNeed := FromProdOrderCapNeed;
                    ToProdOrderCapNeed.Status := ToProdOrder.Status;
                    ToProdOrderCapNeed."Prod. Order No." := ToProdOrder."No.";
                    ToProdOrderCapNeed."Allocated Time" := ToProdOrderCapNeed."Needed Time";
                    ToProdOrderCapNeed.INSERT();
                UNTIL FromProdOrderCapNeed.NEXT() = 0;
                FromProdOrderCapNeed.DELETEALL();
            END;
        END;
    end;


    procedure FlushProdOrder(ProdOrder: Record "Production Order"; NewStatus: Enum "Production Order Status"; PostingDate: Date)
    var
        ProdOrderStatusManagement: codeunit "Prod. Order Status Management";
    begin
        ProdOrderStatusManagement.FlushProdOrder(ProdOrder, NewStatus, PostingDate);

    end;


    procedure CheckBeforeFinishProdOrder(ProdOrder: Record "Production Order")
    var
        ProdOrderComp: Record "Prod. Order Component";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderRtngLine: Record "Prod. Order Routing Line";
        PurchLine: Record "Purchase Line";
        ShowWarning: Boolean;
    begin
        PurchLine.SETCURRENTKEY("Document Type", Type, "Prod. Order No.", "Prod. Order Line No.", "Routing No.", "Operation No.");
        PurchLine.SETRANGE("Document Type", PurchLine."Document Type"::Order);
        PurchLine.SETRANGE(Type, PurchLine.Type::Item);
        PurchLine.SETRANGE("Prod. Order No.", ProdOrder."No.");
        PurchLine.SETFILTER("Outstanding Quantity", '<>%1', 0);
        IF PurchLine.FINDFIRST() THEN
            ERROR(Text008, ProdOrder.TABLECAPTION, ProdOrder."No.", PurchLine."Document No.");

        ProdOrderLine.SETRANGE(Status, ProdOrder.Status);
        ProdOrderLine.SETRANGE("Prod. Order No.", ProdOrder."No.");
        ProdOrderLine.SETFILTER("Remaining Quantity", '<>0');
        IF NOT ProdOrderLine.ISEMPTY THEN BEGIN
            ProdOrderRtngLine.SETRANGE(Status, ProdOrder.Status);
            ProdOrderRtngLine.SETRANGE("Prod. Order No.", ProdOrder."No.");
            ProdOrderRtngLine.SETRANGE("Next Operation No.", '');
            IF NOT ProdOrderRtngLine.ISEMPTY THEN BEGIN
                ProdOrderRtngLine.SETFILTER("Flushing Method", '<>%1', ProdOrderRtngLine."Flushing Method"::Backward);
                ShowWarning := NOT ProdOrderRtngLine.ISEMPTY;
            END ELSE
                ShowWarning := TRUE;

            IF ShowWarning THEN BEGIN
                ;
                IF CONFIRM(STRSUBSTNO(Text004, ProdOrder.TABLECAPTION, ProdOrder."No.")) THEN
                    EXIT;
                ERROR(Text005);
            END;
        END;

        ProdOrderComp.SETRANGE(Status, ProdOrder.Status);
        ProdOrderComp.SETRANGE("Prod. Order No.", ProdOrder."No.");
        ProdOrderComp.SETFILTER("Remaining Quantity", '<>0');
        IF ProdOrderComp.FINDSET() THEN
            REPEAT
                IF ((ProdOrderComp."Flushing Method" <> ProdOrderComp."Flushing Method"::Backward) AND
                    (ProdOrderComp."Flushing Method" <> ProdOrderComp."Flushing Method"::"Pick + Backward") AND
                    (ProdOrderComp."Routing Link Code" = '')) OR
                   ((ProdOrderComp."Routing Link Code" <> '') AND NOT RtngWillFlushComp(ProdOrderComp))
                THEN BEGIN
                    IF CONFIRM(STRSUBSTNO(Text006, ProdOrder.TABLECAPTION, ProdOrder."No.")) THEN
                        EXIT;
                    ERROR(Text005);
                END;
            UNTIL ProdOrderComp.NEXT() = 0;
    end;

    local procedure RtngWillFlushComp(ProdOrderComp: Record "Prod. Order Component"): Boolean
    var
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderRtngLine: Record "Prod. Order Routing Line";
    begin
        IF ProdOrderComp."Routing Link Code" = '' THEN
            EXIT;

        ProdOrderLine.GET(ProdOrderComp.Status, ProdOrderComp."Prod. Order No.", ProdOrderComp."Prod. Order Line No.");

        ProdOrderRtngLine.SETCURRENTKEY("Prod. Order No.", Status, "Flushing Method");
        ProdOrderRtngLine.SETRANGE("Flushing Method", ProdOrderRtngLine."Flushing Method"::Backward);
        ProdOrderRtngLine.SETRANGE(Status, ProdOrderRtngLine.Status::Released);
        ProdOrderRtngLine.SETRANGE("Prod. Order No.", ProdOrderComp."Prod. Order No.");
        ProdOrderRtngLine.SETRANGE("Routing Link Code", ProdOrderComp."Routing Link Code");
        ProdOrderRtngLine.SETRANGE("Routing No.", ProdOrderLine."Routing No.");
        ProdOrderRtngLine.SETRANGE("Routing Reference No.", ProdOrderLine."Routing Reference No.");
        EXIT(Not ProdOrderRtngLine.IsEmpty);
    end;

    // local procedure GetSourceCodeSetup()
    // begin
    //     IF NOT SourceCodeSetupRead THEN
    //         SourceCodeSetup.GET();
    //     SourceCodeSetupRead := TRUE;
    // end;


    procedure ErrorIfInPlanningWksh(var ProdOrder: Record "Production Order")
    var
        ReqLine: Record "Requisition Line";
    begin
        ReqLine.SETCURRENTKEY("Ref. Order Type", "Ref. Order Status", "Ref. Order No.", "Ref. Line No.");
        ReqLine.SETRANGE("Ref. Order Type", ReqLine."Ref. Order Type"::"Prod. Order");
        ReqLine.SETRANGE("Ref. Order Status", ProdOrder.Status);
        ReqLine.SETRANGE("Ref. Order No.", ProdOrder."No.");
        IF ReqLine.FINDFIRST() THEN
            ERROR(Text007,
              ProdOrder."No.", ReqLine."Line No.", ReqLine."Worksheet Template Name", ReqLine."Journal Batch Name");
    end;


    procedure SetPostingInfo(Status: Enum "Production Order Status"; PostingDate: Date; UpdateUnitCost: Boolean)
    begin
        NewStatus := Status;
        NewPostingDate := PostingDate;
        NewUpdateUnitCost := UpdateUnitCost;
    end;


    procedure ErrorIfUnableToClearWIP(ProdOrder: Record "Production Order")
    var
        ProdOrderLine: Record "Prod. Order Line";
    begin
        ProdOrderLine.SETRANGE(Status, ProdOrder.Status);
        ProdOrderLine.SETRANGE("Prod. Order No.", ProdOrder."No.");
        IF ProdOrderLine.FINDSET() THEN
            REPEAT
                IF NOT OutputExists(ProdOrderLine) THEN
                    IF MatrOrCapConsumpExists(ProdOrderLine) THEN
                        ERROR(Text009, ProdOrderLine."Line No.", ToProdOrder.TABLECAPTION, ProdOrderLine."Prod. Order No.");
            UNTIL ProdOrderLine.NEXT() = 0;
    end;


    procedure OutputExists(ProdOrderLine: Record "Prod. Order Line"): Boolean
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        ItemLedgEntry.SETCURRENTKEY("Order No.", "Order Line No.");
        ItemLedgEntry.SETRANGE("Order No.", ProdOrderLine."Prod. Order No.");
        ItemLedgEntry.SETRANGE("Order Line No.", ProdOrderLine."Line No.");
        ItemLedgEntry.SETRANGE("Entry Type", ItemLedgEntry."Entry Type"::Output);
        IF ItemLedgEntry.FINDSET() THEN BEGIN
            ItemLedgEntry.CALCSUMS(Quantity);
            IF ItemLedgEntry.Quantity <> 0 THEN
                EXIT(TRUE)
        END;
        EXIT(FALSE);
    end;


    procedure MatrOrCapConsumpExists(ProdOrderLine: Record "Prod. Order Line"): Boolean
    var
        CapLedgEntry: Record "Capacity Ledger Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        ItemLedgEntry.SETCURRENTKEY("Order No.", "Order Line No.");
        ItemLedgEntry.SETRANGE("Order No.", ProdOrderLine."Prod. Order No.");
        ItemLedgEntry.SETRANGE("Order Line No.", ProdOrderLine."Line No.");
        ItemLedgEntry.SETRANGE("Entry Type", ItemLedgEntry."Entry Type"::Consumption);
        IF Not ItemLedgEntry.IsEmpty THEN
            EXIT(TRUE);

        CapLedgEntry.SETCURRENTKEY("Order No.", "Order Line No.", "Routing No.", "Routing Reference No.");
        CapLedgEntry.SETRANGE("Order No.", ProdOrderLine."Prod. Order No.");
        CapLedgEntry.SETRANGE("Routing No.", ProdOrderLine."Routing No.");
        CapLedgEntry.SETRANGE("Routing Reference No.", ProdOrderLine."Routing Reference No.");
        EXIT(Not CapLedgEntry.IsEmpty);
    end;


    procedure FillDimensions(var ItemJnlLine: Record "Item Journal Line"; var TempJnlLineDim: Record "Dim. Value per Account" temporary)
    begin
        IF NOT HasGLSetup THEN BEGIN
            HasGLSetup := TRUE;
            GLSetup.GET();
        END;
        IF TempJnlLineDim.FINDSET() THEN
            REPEAT
                IF GLSetup."Shortcut Dimension 1 Code" = TempJnlLineDim."Dimension Code" THEN
                    ItemJnlLine."Shortcut Dimension 1 Code" := TempJnlLineDim."Dimension Value Code";
                IF GLSetup."Shortcut Dimension 2 Code" = TempJnlLineDim."Dimension Code" THEN
                    ItemJnlLine."Shortcut Dimension 2 Code" := TempJnlLineDim."Dimension Value Code";
            UNTIL TempJnlLineDim.NEXT() = 0;
    end;

    procedure SetNoFinishCOntrol(BooPAvoidControl: Boolean)
    begin
        BooGAvoidControl := BooPAvoidControl;
    end;
}

