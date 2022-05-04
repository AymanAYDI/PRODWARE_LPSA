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
        SourceCodeSetup: Record "Source Code Setup";
        ACYMgt: Codeunit "Additional-Currency Management";
        DimMgt: Codeunit DimensionManagement;
        InvtAdjmt: Codeunit "Inventory Adjustment";
        ReserveProdOrderComp: Codeunit "Prod. Order Comp.-Reserve";
        ReserveProdOrderLine: Codeunit "Prod. Order Line-Reserve";
        ReservMgt: Codeunit "Reservation Management";
        CalendarMgt: Codeunit "Shop Calendar Management";
        UpdateProdOrderCost: Codeunit "Update Prod. Order Cost";
        WhseOutputProdRelease: Codeunit "Whse.-Output Prod. Release";
        WhseProdRelease: Codeunit "Whse.-Production Release";
        BooGAvoidControl: Boolean;
        HasGLSetup: Boolean;
        NewUpdateUnitCost: Boolean;
        SourceCodeSetupRead: Boolean;
        NewPostingDate: Date;
        Text000: Label '%2 %3  with status %1 has been changed to %5 %6 with status %4.';
        Text002: Label 'Posting Automatic consumption...\\';
        Text003: Label 'Posting lines         #1###### @2@@@@@@@@@@@@@';
        Text004: Label '%1 %2 has not been finished. Some output is still missing. Do you still want to finish the order?';
        Text005: Label 'The update has been interrupted to respect the warning.';
        Text006: Label '%1 %2 has not been finished. Some consumption is still missing. Do you still want to finish the order?';
        Text007: Label 'The status of order %1 cannot be changed as it is related to planning line %2 in worksheet %3 %4.';
        Text008: Label '%1 %2 cannot be finished as the associated subcontract order %3 has not been fully delivered.';
        Text009: Label 'You cannot finish line %1 on %2 %3. It has consumption or capacity posted with no output.';
        Text010: Label 'You must specify a %1 in %2 %3 %4.';
        Txt50000: Label 'There is a phantom item for Line no. %1';
        NewStatus: Option Quote,Planned,"Firm Planned",Released,Finished;


    procedure ChangeStatusOnProdOrder(ProdOrder: Record "Production Order"; NewStatus: Option Quote,Planned,"Firm Planned",Released,Finished; NewPostingDate: Date; NewUpdateUnitCost: Boolean)
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
        WITH FromProdOrder DO BEGIN
            ToProdOrderLine.LOCKTABLE();

            ToProdOrder := FromProdOrder;
            ToProdOrder.Status := NewStatus;

            CASE Status OF
                Status::Simulated:
                    ToProdOrder."Simulated Order No." := "No.";
                Status::Planned:
                    ToProdOrder."Planned Order No." := "No.";
                Status::"Firm Planned":
                    ToProdOrder."Firm Planned Order No." := "No.";
                Status::Released:
                    ToProdOrder."Finished Date" := NewPostingDate;
            END;


            //>>FE_LAPIERRETTE_PROD01.001: TO 13/12/2011
            //ToProdOrder.TestNoSeries;
            //IF (ToProdOrder.GetNoSeriesCode <> GetNoSeriesCode) AND
            //   (ToProdOrder.Status <> ToProdOrder.Status::Finished)
            //THEN
            //  ToProdOrder."No." := '';

            IF "PWD Transmitted Order No." THEN BEGIN
                ToProdOrder."No." := "No.";
                ToProdOrder."PWD Transmitted Order No." := TRUE;
                ToProdOrder."PWD Original Source No." := "PWD Original Source No.";
                ToProdOrder."PWD Original Source Position" := "PWD Original Source Position";
            END ELSE BEGIN
                ToProdOrder.TestNoSeries();
                IF (ToProdOrder.GetNoSeriesCode() <> GetNoSeriesCode()) AND
                   (ToProdOrder.Status <> ToProdOrder.Status::Finished)
                THEN
                    ToProdOrder."No." := '';
            END;
            //<<FE_LAPIERRETTE_PROD01.001: TO 13/12/2011


            ToProdOrder.INSERT(TRUE);
            ToProdOrder."Starting Time" := "Starting Time";
            ToProdOrder."Starting Date" := "Starting Date";
            ToProdOrder."Ending Time" := "Ending Time";
            ToProdOrder."Ending Date" := "Ending Date";
            ToProdOrder."Due Date" := "Due Date";
            ToProdOrder.VALIDATE("Shortcut Dimension 1 Code", '');
            ToProdOrder.VALIDATE("Shortcut Dimension 2 Code", '');
            ToProdOrder."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
            ToProdOrder."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";

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
            TransProdOrderDocDim(FromProdOrder);
            TransProdOrderCapNeed(FromProdOrder);
            //PLAW1 2.1 transport prod order links
            // TransProdOrderLink(FromProdOrder);
            //PLAW1 2.1 END
            DELETE();
            FromProdOrder := ToProdOrder;
        END;
    end;

    local procedure TransProdOrderLine(FromProdOrder: Record "Production Order")
    var
        FromProdOrderLine: Record "Prod. Order Line";
        ToProdOrderLine: Record "Prod. Order Line";
    begin
        WITH FromProdOrderLine DO BEGIN
            SETRANGE(Status, FromProdOrder.Status);
            SETRANGE("Prod. Order No.", FromProdOrder."No.");
            LOCKTABLE();
            IF FINDSET() THEN BEGIN
                REPEAT
                    //>>FE_LAPRIERRETTE_GP0003 : APA 16/05/2013
                    IF (ExistPhantomItem() <> '') AND (NewStatus = NewStatus::Released) THEN
                        ERROR(Txt50000, "Line No.");
                    //<<FE_LAPRIERRETTE_GP0003 : APA 16/05/2013
                    ToProdOrderLine := FromProdOrderLine;
                    ToProdOrderLine.Status := ToProdOrder.Status;
                    ToProdOrderLine."Prod. Order No." := ToProdOrder."No.";
                    ToProdOrderLine.INSERT();
                    IF NewStatus = NewStatus::Finished THEN BEGIN
                        //ToProdOrderLine."Cost is Adjusted" := FALSE; //TODO: Le champs n'existe pas dans les champs standards pour cette version
                        IF NewUpdateUnitCost THEN
                            UpdateProdOrderCost.UpdateUnitCostOnProdOrder(FromProdOrderLine, TRUE, TRUE);
                        ToProdOrderLine."Unit Cost (ACY)" :=
                          ACYMgt.CalcACYAmt(ToProdOrderLine."Unit Cost", NewPostingDate, TRUE);
                        ToProdOrderLine."Cost Amount (ACY)" :=
                          ACYMgt.CalcACYAmt(ToProdOrderLine."Cost Amount", NewPostingDate, FALSE);
                        ReservMgt.SetReservSource(FromProdOrderLine);
                        ReservMgt.DeleteReservEntries(TRUE, 0);
                    END ELSE BEGIN
                        IF Item.GET("Item No.") THEN
                            IF (Item."Costing Method" <> Item."Costing Method"::Standard) AND NewUpdateUnitCost THEN
                                UpdateProdOrderCost.UpdateUnitCostOnProdOrder(FromProdOrderLine, FALSE, TRUE);
                        ToProdOrderLine.BlockDynamicTracking(TRUE);
                        ToProdOrderLine.VALIDATE(Quantity);
                        ReserveProdOrderLine.TransferPOLineToPOLine(FromProdOrderLine, ToProdOrderLine, 0, TRUE);
                    END;
                    ToProdOrderLine.VALIDATE("Unit Cost", "Unit Cost");
                    ToProdOrderLine.MODIFY();
                UNTIL NEXT() = 0;
                DELETEALL();
            END;
        END;
    end;

    local procedure TransProdOrderRtngLine(FromProdOrder: Record "Production Order")
    var
        FromProdOrderRtngLine: Record "Prod. Order Routing Line";
        ToProdOrderRtngLine: Record "Prod. Order Routing Line";
    begin
        WITH FromProdOrderRtngLine DO BEGIN
            SETRANGE(Status, FromProdOrder.Status);
            SETRANGE("Prod. Order No.", FromProdOrder."No.");
            LOCKTABLE();
            IF FINDSET() THEN BEGIN
                REPEAT
                    ToProdOrderRtngLine := FromProdOrderRtngLine;
                    ToProdOrderRtngLine.Status := ToProdOrder.Status;
                    ToProdOrderRtngLine."Prod. Order No." := ToProdOrder."No.";
                    IF ToProdOrder.Status = ToProdOrder.Status::Released THEN
                        ToProdOrderRtngLine."Routing Status" := "Routing Status"::Planned;
                    ToProdOrderRtngLine.INSERT();
                UNTIL NEXT() = 0;
                DELETEALL();
            END;
        END;
    end;

    local procedure TransProdOrderComp(FromProdOrder: Record "Production Order")
    var
        Location: Record Location;
        FromProdOrderComp: Record "Prod. Order Component";
        ToProdOrderComp: Record "Prod. Order Component";
    begin
        WITH FromProdOrderComp DO BEGIN
            SETRANGE(Status, FromProdOrder.Status);
            SETRANGE("Prod. Order No.", FromProdOrder."No.");
            LOCKTABLE();
            IF FINDSET() THEN BEGIN
                REPEAT
                    IF Location.GET("Location Code") AND
                       Location."Bin Mandatory" AND
                       NOT Location."Directed Put-away and Pick" AND
                       (Status = Status::"Firm Planned") AND
                       (ToProdOrder.Status = ToProdOrder.Status::Released) AND
                       ("Flushing Method" IN ["Flushing Method"::Forward, "Flushing Method"::"Pick + Forward"]) AND
                       ("Routing Link Code" = '') AND
                       ("Bin Code" = '')
                    THEN
                        ERROR(
                          Text010,
                          FIELDCAPTION("Bin Code"),
                          TABLECAPTION,
                          FIELDCAPTION("Line No."),
                          "Line No.");
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
                UNTIL NEXT() = 0;
                DELETEALL();
            END;
        END;
    end;

    local procedure TransProdOrderRtngTool(FromProdOrder: Record "Production Order")
    var
        FromProdOrderRtngTool: Record "Prod. Order Routing Tool";
        ToProdOrderRoutTool: Record "Prod. Order Routing Tool";
    begin
        WITH FromProdOrderRtngTool DO BEGIN
            SETRANGE(Status, FromProdOrder.Status);
            SETRANGE("Prod. Order No.", FromProdOrder."No.");
            LOCKTABLE();
            IF FINDSET() THEN BEGIN
                REPEAT
                    ToProdOrderRoutTool := FromProdOrderRtngTool;
                    ToProdOrderRoutTool.Status := ToProdOrder.Status;
                    ToProdOrderRoutTool."Prod. Order No." := ToProdOrder."No.";
                    ToProdOrderRoutTool.INSERT();
                UNTIL NEXT() = 0;
                DELETEALL();
            END;
        END;
    end;

    // local procedure TransProdOrderRtngLineAlt(FromProdOrder: Record "Production Order")
    // var
    //     FromProdOrderRtngLineAlt: Record "PlannerOneProdOrdRoutLineAlt";
    //     ToProdOrderRoutLineAlt: Record PlannerOneProdOrdRoutLineAlt;
    // begin
    //     // PLAW1 2.1
    //     // PLAW12.2 Check LICENSE
    //     IF NOT ApplicationManagement.CheckPlannerOneLicence THEN EXIT;
    //     WITH FromProdOrderRtngLineAlt DO BEGIN
    //         SETRANGE(Status, FromProdOrder.Status);
    //         SETRANGE("Prod. Order No.", FromProdOrder."No.");
    //         LOCKTABLE;
    //         IF FINDSET THEN BEGIN
    //             REPEAT
    //                 ToProdOrderRoutLineAlt := FromProdOrderRtngLineAlt;
    //                 ToProdOrderRoutLineAlt.Status := ToProdOrder.Status;
    //                 ToProdOrderRoutLineAlt."Prod. Order No." := ToProdOrder."No.";
    //                 ToProdOrderRoutLineAlt.INSERT;
    //             UNTIL NEXT = 0;
    //             DELETEALL;
    //         END;
    //     END;
    //     // PLAW1 2.1 END
    // end;

    local procedure TransProdOrderRtngPersnl(FromProdOrder: Record "Production Order")
    var
        FromProdOrderRtngPersonnel: Record "Prod. Order Routing Personnel";
        ToProdOrderRtngPersonnel: Record "Prod. Order Routing Personnel";
    begin
        WITH FromProdOrderRtngPersonnel DO BEGIN
            SETRANGE(Status, FromProdOrder.Status);
            SETRANGE("Prod. Order No.", FromProdOrder."No.");
            LOCKTABLE();
            IF FINDSET() THEN BEGIN
                REPEAT
                    ToProdOrderRtngPersonnel := FromProdOrderRtngPersonnel;
                    ToProdOrderRtngPersonnel.Status := ToProdOrder.Status;
                    ToProdOrderRtngPersonnel."Prod. Order No." := ToProdOrder."No.";
                    ToProdOrderRtngPersonnel.INSERT();
                UNTIL NEXT() = 0;
                DELETEALL();
            END;
        END;
    end;

    local procedure TransProdOrdRtngQltyMeas(FromProdOrder: Record "Production Order")
    var
        FromProdOrderRtngQltyMeas: Record "Prod. Order Rtng Qlty Meas.";
        ToProdOrderRtngQltyMeas: Record "Prod. Order Rtng Qlty Meas.";
    begin
        WITH FromProdOrderRtngQltyMeas DO BEGIN
            SETRANGE(Status, FromProdOrder.Status);
            SETRANGE("Prod. Order No.", FromProdOrder."No.");
            LOCKTABLE();
            IF FINDSET() THEN BEGIN
                REPEAT
                    ToProdOrderRtngQltyMeas := FromProdOrderRtngQltyMeas;
                    ToProdOrderRtngQltyMeas.Status := ToProdOrder.Status;
                    ToProdOrderRtngQltyMeas."Prod. Order No." := ToProdOrder."No.";
                    ToProdOrderRtngQltyMeas.INSERT();
                UNTIL NEXT() = 0;
                DELETEALL();
            END;
        END;
    end;

    local procedure TransProdOrderCmtLine(FromProdOrder: Record "Production Order")
    var
        FromProdOrderCommentLine: Record "Prod. Order Comment Line";
        ToProdOrderCommentLine: Record "Prod. Order Comment Line";
    begin
        WITH FromProdOrderCommentLine DO BEGIN
            SETRANGE(Status, FromProdOrder.Status);
            SETRANGE("Prod. Order No.", FromProdOrder."No.");
            LOCKTABLE();
            IF FINDSET() THEN BEGIN
                REPEAT
                    ToProdOrderCommentLine := FromProdOrderCommentLine;
                    ToProdOrderCommentLine.Status := ToProdOrder.Status;
                    ToProdOrderCommentLine."Prod. Order No." := ToProdOrder."No.";
                    ToProdOrderCommentLine.INSERT();
                UNTIL NEXT() = 0;
                DELETEALL();
            END;
        END;
        ToProdOrder.COPYLINKS(FromProdOrder);
    end;

    local procedure TransProdOrderRtngCmtLn(FromProdOrder: Record "Production Order")
    var
        FromProdOrderRtngComment: Record "Prod. Order Rtng Comment Line";
        ToProdOrderRtngComment: Record "Prod. Order Rtng Comment Line";
    begin
        WITH FromProdOrderRtngComment DO BEGIN
            SETRANGE(Status, FromProdOrder.Status);
            SETRANGE("Prod. Order No.", FromProdOrder."No.");
            LOCKTABLE();
            IF FINDSET() THEN BEGIN
                REPEAT
                    ToProdOrderRtngComment := FromProdOrderRtngComment;
                    ToProdOrderRtngComment.Status := ToProdOrder.Status;
                    ToProdOrderRtngComment."Prod. Order No." := ToProdOrder."No.";
                    ToProdOrderRtngComment.INSERT();
                UNTIL NEXT() = 0;
                DELETEALL();
            END;
        END;
    end;

    local procedure TransProdOrderBOMCmtLine(FromProdOrder: Record "Production Order")
    var
        FromProdOrderBOMComment: Record "Prod. Order Comp. Cmt Line";
        ToProdOrderBOMComment: Record "Prod. Order Comp. Cmt Line";
    begin
        WITH FromProdOrderBOMComment DO BEGIN
            SETRANGE(Status, FromProdOrder.Status);
            SETRANGE("Prod. Order No.", FromProdOrder."No.");
            LOCKTABLE();
            IF FINDSET() THEN BEGIN
                REPEAT
                    ToProdOrderBOMComment := FromProdOrderBOMComment;
                    ToProdOrderBOMComment.Status := ToProdOrder.Status;
                    ToProdOrderBOMComment."Prod. Order No." := ToProdOrder."No.";
                    ToProdOrderBOMComment.INSERT();
                UNTIL NEXT() = 0;
                DELETEALL();
            END;
        END;
    end;

    local procedure TransProdOrderDocDim(FromProdOrder: Record "Production Order")
    var
        FromProdDocDim: Record "Dimension Set Entry";//TODO: Table n'est plus disponible
    begin
        WITH FromProdDocDim DO

            ;
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
    end;

    local procedure TransProdOrderCapNeed(FromProdOrder: Record "Production Order")
    var
        FromProdOrderCapNeed: Record "Prod. Order Capacity Need";
        ToProdOrderCapNeed: Record "Prod. Order Capacity Need";
    begin
        WITH FromProdOrderCapNeed DO BEGIN
            SETRANGE(Status, FromProdOrder.Status);
            SETRANGE("Prod. Order No.", FromProdOrder."No.");
            SETRANGE("Requested Only", FALSE);
            IF NewStatus = NewStatus::Finished THEN
                DELETEALL()
            ELSE BEGIN
                LOCKTABLE();
                IF FINDSET() THEN BEGIN
                    REPEAT
                        ToProdOrderCapNeed := FromProdOrderCapNeed;
                        ToProdOrderCapNeed.Status := ToProdOrder.Status;
                        ToProdOrderCapNeed."Prod. Order No." := ToProdOrder."No.";
                        ToProdOrderCapNeed."Allocated Time" := ToProdOrderCapNeed."Needed Time";
                        ToProdOrderCapNeed.INSERT();
                    UNTIL NEXT() = 0;
                    DELETEALL();
                END;
            END;
        END;
    end;

    // local procedure TransProdOrderLink(FromProdOrder: Record "Production Order")
    // var
    //     FromProdOrderLink: Record PlannerOneProdOrderLink;
    //     ToProdOrderLink: Record PlannerOneProdOrderLink;
    // begin
    //     //PLAW1 2.1
    //     // PLAW12.2 Check LICENSE
    //     IF NOT ApplicationManagement.CheckPlannerOneLicence THEN EXIT;
    //     WITH FromProdOrderLink DO BEGIN
    //         SETRANGE(Status, FromProdOrder.Status);
    //         SETRANGE("Prod. Order No.", FromProdOrder."No.");
    //         IF NewStatus = NewStatus::Finished THEN
    //             DELETEALL
    //         ELSE BEGIN
    //             LOCKTABLE;
    //             IF FINDSET THEN BEGIN
    //                 REPEAT
    //                     ToProdOrderLink := FromProdOrderLink;
    //                     ToProdOrderLink.Status := ToProdOrder.Status;
    //                     ToProdOrderLink."Prod. Order No." := ToProdOrder."No.";
    //                     ToProdOrderLink.INSERT;
    //                 UNTIL NEXT = 0;
    //                 DELETEALL;
    //             END;
    //         END;

    //         RESET;
    //         SETRANGE("Next Status", FromProdOrder.Status);
    //         SETRANGE("Next Prod. Order No.", FromProdOrder."No.");
    //         IF NewStatus = NewStatus::Finished THEN
    //             DELETEALL
    //         ELSE BEGIN
    //             LOCKTABLE;
    //             IF FINDSET THEN BEGIN
    //                 REPEAT
    //                     ToProdOrderLink := FromProdOrderLink;
    //                     ToProdOrderLink."Next Status" := ToProdOrder.Status;
    //                     ToProdOrderLink."Next Prod. Order No." := ToProdOrder."No.";
    //                     ToProdOrderLink.INSERT;
    //                 UNTIL NEXT = 0;
    //                 DELETEALL;
    //             END;
    //         END;
    //     END;
    //     //PLAW1 2.1 END
    // end;


    procedure FlushProdOrder(ProdOrder: Record "Production Order"; NewStatus: Option Simulated,Planned,"Firm Planned",Released,Finished; PostingDate: Date)
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
        WITH PurchLine DO BEGIN
            SETCURRENTKEY("Document Type", Type, "Prod. Order No.", "Prod. Order Line No.", "Routing No.", "Operation No.");
            SETRANGE("Document Type", "Document Type"::Order);
            SETRANGE(Type, Type::Item);
            SETRANGE("Prod. Order No.", ProdOrder."No.");
            SETFILTER("Outstanding Quantity", '<>%1', 0);
            IF FINDFIRST() THEN
                ERROR(Text008, ProdOrder.TABLECAPTION, ProdOrder."No.", "Document No.");
        END;

        WITH ProdOrderLine DO BEGIN
            SETRANGE(Status, ProdOrder.Status);
            SETRANGE("Prod. Order No.", ProdOrder."No.");
            SETFILTER("Remaining Quantity", '<>0');
            IF NOT ISEMPTY THEN BEGIN
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
        END;

        WITH ProdOrderComp DO BEGIN
            SETRANGE(Status, ProdOrder.Status);
            SETRANGE("Prod. Order No.", ProdOrder."No.");
            SETFILTER("Remaining Quantity", '<>0');
            IF FINDSET() THEN
                REPEAT
                    IF (("Flushing Method" <> "Flushing Method"::Backward) AND
                        ("Flushing Method" <> "Flushing Method"::"Pick + Backward") AND
                        ("Routing Link Code" = '')) OR
                       (("Routing Link Code" <> '') AND NOT RtngWillFlushComp(ProdOrderComp))
                    THEN BEGIN
                        IF CONFIRM(STRSUBSTNO(Text006, ProdOrder.TABLECAPTION, ProdOrder."No.")) THEN
                            EXIT;
                        ERROR(Text005);
                    END;
                UNTIL NEXT() = 0;
        END;
    end;

    local procedure RtngWillFlushComp(ProdOrderComp: Record "Prod. Order Component"): Boolean
    var
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderRtngLine: Record "Prod. Order Routing Line";
    begin
        IF ProdOrderComp."Routing Link Code" = '' THEN
            EXIT;

        WITH ProdOrderComp DO
            ProdOrderLine.GET(Status, "Prod. Order No.", "Prod. Order Line No.");

        WITH ProdOrderRtngLine DO BEGIN
            SETCURRENTKEY("Prod. Order No.", Status, "Flushing Method");
            SETRANGE("Flushing Method", "Flushing Method"::Backward);
            SETRANGE(Status, Status::Released);
            SETRANGE("Prod. Order No.", ProdOrderComp."Prod. Order No.");
            SETRANGE("Routing Link Code", ProdOrderComp."Routing Link Code");
            SETRANGE("Routing No.", ProdOrderLine."Routing No.");
            SETRANGE("Routing Reference No.", ProdOrderLine."Routing Reference No.");
            EXIT(FINDFIRST());
        END;
    end;

    local procedure GetSourceCodeSetup()
    begin
        IF NOT SourceCodeSetupRead THEN
            SourceCodeSetup.GET();
        SourceCodeSetupRead := TRUE;
    end;


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


    procedure SetPostingInfo(Status: Option Quote,Planned,"Firm Planned",Released,Finished; PostingDate: Date; UpdateUnitCost: Boolean)
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
        IF ItemLedgEntry.FINDFIRST() THEN
            EXIT(TRUE);

        CapLedgEntry.SETCURRENTKEY("Order No.", "Order Line No.", "Routing No.", "Routing Reference No.");
        CapLedgEntry.SETRANGE("Order No.", ProdOrderLine."Prod. Order No.");
        CapLedgEntry.SETRANGE("Routing No.", ProdOrderLine."Routing No.");
        CapLedgEntry.SETRANGE("Routing Reference No.", ProdOrderLine."Routing Reference No.");
        EXIT(CapLedgEntry.FINDFIRST());
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

