codeunit 50021 "PWD LPSA Functions Mgt."
{
    procedure Fct_OnValidateNoOnBeforeUpdateDates_SalesLine(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    begin
        SalesLine."Promised Delivery Date" := SalesHeader."Promised Delivery Date";
        SalesLine."Requested Delivery Date" := SalesHeader."Requested Delivery Date";
        SalesLine."Promised Delivery Date" := SalesHeader."Requested Delivery Date";
        SalesLine."Planned Delivery Date" := SalesHeader."Requested Delivery Date";
        SalesLine."Planned Shipment Date" := SalesHeader."Requested Delivery Date";
        SalesLine."PWD Initial Shipment Date" := SalesHeader."Requested Delivery Date";
        IF SalesHeader."Requested Delivery Date" <> 0D THEN
            SalesLine."Shipment Date" := SalesHeader."Requested Delivery Date";

        IF SalesHeader."PWD Cust Promised Delivery Date" <> 0D THEN
            SalesLine."PWD Cust Promised Delivery Date" := SalesHeader."PWD Cust Promised Delivery Date"
        ELSE
            SalesLine."PWD Cust Promised Delivery Date" := SalesHeader."Requested Delivery Date";

    end;

    procedure RunPageCommentSheet(var SalesHeader: Record "Sales Header")
    var
        RecLComment: Record 97;
        PageLCommentSheet: Page 124;
    begin
        //>>TDL.LPSA.20.04.15
        RecLComment.RESET;
        RecLComment.SETRANGE("Table Name", RecLComment."Table Name"::Customer);
        RecLComment.SETRANGE("No.", SalesHeader."Bill-to Customer No.");
        IF RecLComment.FINDFIRST THEN BEGIN
            CLEAR(PageLCommentSheet);
            PageLCommentSheet.SETTABLEVIEW(RecLComment);
            PageLCommentSheet.RUNMODAL;
        END;
        //<<TDL.LPSA.20.04.15
    end;
}
