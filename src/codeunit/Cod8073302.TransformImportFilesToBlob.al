codeunit 8073302 "Transform Import Files To Blob"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.5
    // WMS-FEMOT.001.001:GR 05/07/2011  Connector management
    //                                - Create Object
    // +----------------------------------------------------------------------------------------------------------------+

    TableNo = "PWD Connector Messages";

    trigger OnRun()
    var
        CduLFileManagement: Codeunit "File Management";
        TxtLFileFound: Text[1024];
        CduLBufferMgt: Codeunit "Buffer Management";
        IntLSequenceNo: Integer;
        TxtLFilePathName: Text[250];
        RecLPartnerConnector: Record "PWD Partner Connector";
        BooLNotSkip: Boolean;
    begin
        TestField(Path);
        TestField("Archive Path");
        BooLNotSkip := true;
        if RecLPartnerConnector.Get("Partner Code") then;
        while (CduLFileManagement.FctScanDirectoryFiles(Path, TxtLFileFound, "Partner Code", 0, OptGFlowType::"Import Connector") and
                                                       BooLNotSkip) do begin
            if CopyStr(Path, StrLen(Path), 1) <> '\' then
                TxtLFilePathName := Path + '\'
            else
                TxtLFilePathName := Path;
            TxtLFilePathName := TxtLFilePathName + TxtLFileFound;
            IntLSequenceNo := CduLBufferMgt.FctCreateBufferValues2("Partner Code", CopyStr(TxtLFilePathName, 1, 250), "Function",
                                                                   RecLPartnerConnector."Data Format",
                                                                   RecLPartnerConnector.Separator, 0, 0, Code, TxtLFilePathName);

            BooLNotSkip := CduLFileManagement.FctMoveFile(TxtLFileFound, Path, "Archive Path",
                                                          "Partner Code", IntLSequenceNo, OptGFlowType::"Import Connector");
        end;
    end;

    var
        OptGFlowType: Option " ","Import Connector","Export Connector";
}

