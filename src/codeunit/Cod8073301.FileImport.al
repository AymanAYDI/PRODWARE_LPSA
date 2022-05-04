codeunit 8073301 "PWD File Import"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.5
    // WMS-FEMOT.001.001:GR 05/07/2011  Connector management
    //                                - Create Object
    // 
    // +----------------------------------------------------------------------------------------------------------------+

    TableNo = "PWD Partner Connector";

    trigger OnRun()
    var
        RecLRecevingMessage: Record "PWD Connector Messages";
        RecLConnectorValues: Record "PWD Connector Values";
        CduLConnectorErrorlog: Codeunit "PWD Connector Error log";
        CduLFileMessagesImport: Codeunit "Transform Import Files To Blob";
    begin
        RecLRecevingMessage.Reset();
        RecLRecevingMessage.SetRange("Partner Code", Code);
        RecLRecevingMessage.SetRange(Blocked, false);
        RecLRecevingMessage.SetRange(Direction, RecLRecevingMessage.Direction::Import);
        if not RecLRecevingMessage.IsEmpty then begin
            RecLRecevingMessage.FindSet();
            repeat
                ClearLastError();
                Commit();
                if not CduLFileMessagesImport.Run(RecLRecevingMessage) then
                    CduLConnectorErrorlog.InsertLogEntry(2, 1, Code, GetLastErrorText, 0);
            until RecLRecevingMessage.Next() = 0;
        end;

        RecLConnectorValues.Reset();
        RecLConnectorValues.SetRange(Direction, RecLConnectorValues.Direction::Import);
        if not RecLConnectorValues.IsEmpty then begin
            RecLConnectorValues.FindSet();
            repeat
                ClearLastError();
                Commit();
                if not CODEUNIT.Run("Functions CodeUnit ID", RecLConnectorValues) then
                    CduLConnectorErrorlog.InsertLogEntry(2, 1, Code, GetLastErrorText, RecLConnectorValues."Entry No.")
            until RecLConnectorValues.Next() = 0;
        end;
    end;
}

