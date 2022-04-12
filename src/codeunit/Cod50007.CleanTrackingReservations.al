codeunit 50007 "Clean Tracking Reservations"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.23
    // TDL100220.001 : Suppression des réservations isolées

    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        RecLReservEntry: Record "Reservation Entry";
        RecLReservEntry2: Record "Reservation Entry";
        DiaLWindow: Dialog;
        IntLCount: Integer;
        UpdtReservationEntry: Label 'Vérification de la traçabilité #1###############';
    begin
        // Supprime les réservations de type Suivi qui ne vont pas par paire
        RecLReservEntry.SetRange("Reservation Status", RecLReservEntry."Reservation Status"::Tracking);
        if GuiAllowed then
            DiaLWindow.Open(UpdtReservationEntry);

        if RecLReservEntry.FindSet(true, true) then
            repeat
                if GuiAllowed then
                    DiaLWindow.Update(1, RecLReservEntry."Entry No.");

                if not RecLReservEntry2.Get(RecLReservEntry."Entry No.", not RecLReservEntry.Positive) then begin
                    if RecLReservEntry2.Get(RecLReservEntry."Entry No.", RecLReservEntry.Positive) then
                        RecLReservEntry2.Delete;
                end;


            until RecLReservEntry.Next = 0;

        // Supprime les écritures de type Excédent
        RecLReservEntry.Reset;
        RecLReservEntry.SetRange("Reservation Status", RecLReservEntry."Reservation Status"::Surplus);
        RecLReservEntry.SetRange("Source Type", 32);

        if RecLReservEntry.FindSet then
            repeat
                if GuiAllowed then
                    DiaLWindow.Update(1, RecLReservEntry."Entry No.");

                RecLReservEntry2.Get(RecLReservEntry."Entry No.", RecLReservEntry.Positive);
                RecLReservEntry2.Delete;

            until RecLReservEntry.Next = 0;

        // Supprime les réservations de type Origine 83 et avec état de la réservation Prospect antèrieurs au jour de travail
        RecLReservEntry.SetRange("Reservation Status", RecLReservEntry."Reservation Status"::Prospect);
        RecLReservEntry.SetRange("Source Type", 83);
        RecLReservEntry.SetFilter("Creation Date", '<%1', WorkDate);

        if RecLReservEntry.FindSet then
            repeat
                if GuiAllowed then
                    DiaLWindow.Update(1, RecLReservEntry."Entry No.");

                RecLReservEntry2.Get(RecLReservEntry."Entry No.", RecLReservEntry.Positive);
                RecLReservEntry2.Delete;

            until RecLReservEntry.Next = 0;


        if GuiAllowed then
            DiaLWindow.Close;
    end;
}

