codeunit 8073305 "PWD FTP Management"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.5.1
    // FTP.001:GR 20/11/2011 :  Connector integration
    //                          - Create Object
    // 
    // //>>ProdConnect1.07.02.01
    // FTP.002:GR 01/02/2012 :  Connector integration
    //                          - add Function   Fct_sGetFileNameByIndex
    // +----------------------------------------------------------------------------------------------------------------+


    trigger OnRun()
    begin
    end;

    var
        AutGNavFTP: DotNet "PWD CFtp";

    procedure Fct_InitFTPMembers(TxtHostNameIP: Text[80]; IntPortNo: Integer; TxtLogin: Text[80]; TxtPassword: Text[30]; BooBinaryMode: Boolean; BooPassiveMode: Boolean; TxtLocalPath: Text[1024]; TxtRemotePath: Text[1024])
    begin
        if IsNull(AutGNavFTP) then
            AutGNavFTP := AutGNavFTP.CFtp();

        AutGNavFTP.sHostNameIP := TxtHostNameIP;
        AutGNavFTP.iPortNo := IntPortNo;
        AutGNavFTP.sLogin := TxtLogin;
        AutGNavFTP.sPassword := TxtPassword;
        AutGNavFTP.bBinaryMode := BooBinaryMode;
        AutGNavFTP.bPassiveMode := BooPassiveMode;

        AutGNavFTP.sLocalPath := TxtLocalPath;
        AutGNavFTP.sRemotePath := TxtRemotePath;
    end;


    procedure Fct_sLogon(): Text[1024]
    begin
        EXIT(AutGNavFTP.sLogon());
    end;


    procedure Fct_sGetFiles(TxtFileFilter: Text[30]): Text[1024]
    begin
        EXIT(AutGNavFTP.sGetFiles(TxtFileFilter));
    end;

    procedure Fct_sGetFile(TxtLocalFileName: Text[300]; TxtRemoteFileName: Text[300]): Text[1024]
    begin
        EXIT(AutGNavFTP.sGetFile(TxtLocalFileName, TxtRemoteFileName));
    end;

    procedure Fct_iLoadRemoteFiles(TxtFileFilter: Text[30]): Integer
    begin
        EXIT(AutGNavFTP.iLoadRemoteFiles(TxtFileFilter));
    end;

    procedure Fct_sPutFiles(TxtFileFilter: Text[30]): Text[1024]
    begin
        EXIT(AutGNavFTP.sPutFiles(TxtFileFilter));
    end;

    procedure Fct_sPutFile(TxtLocalFileName: Text[300]; TxtRemoteFileName: Text[300]): Text[1024]
    begin
        EXIT(AutGNavFTP.sPutFile(TxtLocalFileName, TxtRemoteFileName));
    end;

    procedure Fct_sDeleteFile(TxtRemoteFileName: Text[300]): Text[1024]
    begin
        EXIT(AutGNavFTP.sDeleteFile(TxtRemoteFileName));
    end;

    procedure Fct_sDeleteFiles(): Text[1024]
    begin
        EXIT((AutGNavFTP.sDeleteFiles()));
    end;

    procedure Fct_sGetFileNameByIndex(IntLFileIndex: Integer): Text[300]
    begin
        EXIT(AutGNavFTP.sGetFileNameByIndex(IntLFileIndex));
    end;
}

