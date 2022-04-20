pageextension 50098 pageextension50098 extends "Whse. Shipment Subform"
{
    // TDL.LPSA : add function to delete binding links
    actions
    {
        addafter("Action 1900295504")
        {
            action("Delete reservations.")
            {
                Caption = 'Delete reservations.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    DeleteResEntriesForOrderLine;
                end;
            }
        }
    }

    procedure "--- TDL.LPSA ---"()
    begin
    end;

    procedure DeleteResEntriesForOrderLine()
    var
        RecLSalesLine: Record "37";
        cTxtL001: Label 'You can delete reservation entries only for sales order lines.';
        cTxtL002: Label 'La ligne %1 de la commande %2 n''a pas été trouvée. La suppression n''a pas été réalisée.';
        RecLResEntry: Record "337";
        RecLResEntrytoDel: Record "337";
        cTxtL003: Label 'Operation terminated. The deletion has been realized.';
        i: Integer;
        cTxtL004: Label 'Operation terminated. No deletion has been realized.';
    begin
        IF "Source Type" <> 37 THEN
            ERROR(cTxtL001);


        IF NOT RecLSalesLine.GET(RecLSalesLine."Document Type"::Order, "Source No.", "Source Line No.") THEN
            ERROR(cTxtL002, "Source No.", "Source Line No.");

        i := 0;

        RecLResEntry.RESET;
        RecLResEntry.SETRANGE("Source Type", 37);
        RecLResEntry.SETRANGE("Source ID", RecLSalesLine."Document No.");
        RecLResEntry.SETRANGE("Source Subtype", 1);
        RecLResEntry.SETRANGE("Source Ref. No.", RecLSalesLine."Line No.");
        RecLResEntry.SETRANGE(Binding, RecLResEntry.Binding::"Order-to-Order");
        IF RecLResEntry.FINDFIRST THEN
            REPEAT
                RecLResEntrytoDel.RESET;
                RecLResEntrytoDel.SETRANGE("Entry No.", RecLResEntry."Entry No.");
                RecLResEntrytoDel.DELETEALL;
                i += 1;
            UNTIL RecLResEntry.NEXT = 0;

        IF i <> 0 THEN
            MESSAGE(cTxtL003)
        ELSE
            MESSAGE(cTxtL004);
    end;
}

