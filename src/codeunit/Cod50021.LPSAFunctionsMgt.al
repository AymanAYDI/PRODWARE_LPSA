codeunit 50021 "PWD LPSA Functions Mgt."
{

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
