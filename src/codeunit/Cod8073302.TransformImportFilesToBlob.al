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
        RecLPartnerConnector: Record "PWD Partner Connector";
        CduLBufferMgt: Codeunit "PWD Buffer Management";
        CduLFileManagement: Codeunit "PWD File Management";
        BooLNotSkip: Boolean;
        IntLSequenceNo: Integer;
        TxtLFilePathName: Text[250];
        TxtLFileFound: Text[1024];
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

