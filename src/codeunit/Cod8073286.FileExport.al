codeunit 8073286 "PWD File Export"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.00
    // 
    // FE_ProdConnect.001:GR 22/03/2011  Connector integration
    //                                   - Create Object
    // 
    // //>>ProdConnect1.5
    // WMS-FE10.001:GR 01/07/2011  :   Connector integratioin
    //                                 - C\AL IN : OnRun
    // 
    // //>>ProdConnect1.6
    // OSYS-Int001.001:GR 20/10/2011   Connector integration
    //                                 - Add new function :   FctInitJobQueueEntry
    //                                 - C\AL in :  OnRun
    // 
    // //>>LAP2.06
    // FE_LAPRIERRETTE_GP0004.001 :GR  23/05/13  : - C\AL in : OnRun
    // 
    // 
    // +----------------------------------------------------------------------------------------------------------------+

    TableNo = "PWD Partner Connector";

    trigger OnRun()
    var
        RecLSendingMessage: Record "PWD Connector Messages";
        RecLConnectiorValues: Record "PWD Connector Values";
        CduLConnectorErrorlog: Codeunit "PWD Connector Error log";
        IntLPostion: Integer;
        TxtLPameter: Text[250];
    begin
        RecLSendingMessage.Reset();
        RecLSendingMessage.SetRange("Partner Code", Code);
        RecLSendingMessage.SetRange(Blocked, false);

        //>>WMS-FE10.001
        RecLSendingMessage.SetRange(Direction, RecLSendingMessage.Direction::Export);
        RecLSendingMessage.SetRange("Master Table", true);
        //<<WMS-FE10.001

        //>>OSYS-Int001.001
        if RecGJobQueueEntry."Parameter String" <> '' then begin
            IntLPostion := StrPos(RecGJobQueueEntry."Parameter String", ';');
            if IntLPostion <> 0 then begin
                TxtLPameter := CopyStr(RecGJobQueueEntry."Parameter String", IntLPostion);
                RecLSendingMessage.SetFilter(Code, TxtLPameter);
            end;
        end;
        //<<OSYS-Int001.001

        if not RecLSendingMessage.IsEmpty then begin
            RecLSendingMessage.FindSet();
            repeat
                ClearLastError();
                Commit();
                //<<WMS-FE10.001
                FctInitConnectorBuffer(RecLConnectiorValues, RecLSendingMessage);
                //OLD : IF NOT CduLFileMessagesExport.RUN(RecLSendingMessage) THEN
                //IF NOT CODEUNIT.RUN("Functions CodeUnit ID",RecLSendingMessage) THEN

                if not CODEUNIT.Run("Functions CodeUnit ID", RecLConnectiorValues) then
                    CduLConnectorErrorlog.InsertLogEntry(2, 2, Code, GetLastErrorText, 0)

                else begin
                    RecLSendingMessage."Export Date" := Today;

                    //>>FE_LAPRIERRETTE_GP0004.001
                    RecLSendingMessage."Export DateTime" := CurrentDateTime;
                    //<<FE_LAPRIERRETTE_GP0004.001

                    RecLSendingMessage.Modify();
                end;
            //<<WMS-FE10.001

            until RecLSendingMessage.Next() = 0;
        end;
    end;

    var
        RecGJobQueueEntry: Record "Job Queue Entry";

    procedure FctInitConnectorBuffer(var RecPConnectiorValues: Record "PWD Connector Values"; RecPSendingMessage: Record "PWD Connector Messages")
    begin
        RecPConnectiorValues.Init();
        RecPConnectiorValues."Partner Code" := RecPSendingMessage."Partner Code";
        RecPConnectiorValues."Function" := RecPSendingMessage."Function";
        RecPConnectiorValues.Direction := RecPSendingMessage.Direction;
        RecPConnectiorValues."Message Code" := RecPSendingMessage.Code;
    end;

    procedure FctInitJobQueueEntry(RecPJobQueueEntry: Record "Job Queue Entry")
    begin
        RecGJobQueueEntry := RecPJobQueueEntry;
    end;
}

