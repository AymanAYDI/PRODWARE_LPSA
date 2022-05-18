pageextension 60103 "PWD WhseShipmentSubform" extends "Whse. Shipment Subform"
{
    // TDL.LPSA : add function to delete binding links
    actions
    {
        addafter(ItemTrackingLines)
        {
            action("PWD Delete reservations.")
            {
                Caption = 'Delete reservations.';
                ApplicationArea = All;
                Image = Delete;
                trigger OnAction()
                begin
                    DeleteResEntriesForOrderLine();
                end;
            }
        }
    }

    procedure DeleteResEntriesForOrderLine()
    var
        RecLResEntry: Record "Reservation Entry";
        RecLResEntrytoDel: Record "Reservation Entry";
        RecLSalesLine: Record "Sales Line";
        i: Integer;
        cTxtL001: Label 'You can delete reservation entries only for sales order lines.';
        cTxtL002: Label 'La ligne %1 de la commande %2 n''a pas été trouvée. La suppression n''a pas été réalisée.';
        cTxtL003: Label 'Operation terminated. The deletion has been realized.';
        cTxtL004: Label 'Operation terminated. No deletion has been realized.';
    begin
        IF Rec."Source Type" <> 37 THEN
            ERROR(cTxtL001);


        IF NOT RecLSalesLine.GET(RecLSalesLine."Document Type"::Order, Rec."Source No.", Rec."Source Line No.") THEN
            ERROR(cTxtL002, Rec."Source No.", Rec."Source Line No.");

        i := 0;

        RecLResEntry.RESET();
        RecLResEntry.SETRANGE("Source Type", 37);
        RecLResEntry.SETRANGE("Source ID", RecLSalesLine."Document No.");
        RecLResEntry.SETRANGE("Source Subtype", 1);
        RecLResEntry.SETRANGE("Source Ref. No.", RecLSalesLine."Line No.");
        RecLResEntry.SETRANGE(Binding, RecLResEntry.Binding::"Order-to-Order");
        IF RecLResEntry.FindSet() THEN
            REPEAT
                RecLResEntrytoDel.RESET();
                RecLResEntrytoDel.SETRANGE("Entry No.", RecLResEntry."Entry No.");
                RecLResEntrytoDel.DELETEALL();
                i += 1;
            UNTIL RecLResEntry.NEXT() = 0;

        IF i <> 0 THEN
            MESSAGE(cTxtL003)
        ELSE
            MESSAGE(cTxtL004);
    end;
}

