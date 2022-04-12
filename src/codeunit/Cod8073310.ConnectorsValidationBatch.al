codeunit 8073310 "Connectors Validation Batch"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.07.01
    // WMS-EBL1-003.001.001:GR 05/01/2012   Connector integration
    //                                      - Create Object
    // 
    // +----------------------------------------------------------------------------------------------------------------+

    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        if not CduGConnectJrnlValidBatch.Run then
            CduGConnectorErrorlog.InsertLogEntry(2, 1, '', CopyStr(GetLastErrorText, 1, 250), 0);
    end;

    var
        CduGConnectJrnlValidBatch: Codeunit "Connectors Journal Valid Batch";
        CduGConnectorErrorlog: Codeunit "PWD Connector Error log";
}

