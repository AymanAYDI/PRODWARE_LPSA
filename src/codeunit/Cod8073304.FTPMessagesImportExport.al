codeunit 8073304 "PWD FTP Messages Import/Export"
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
    //                          - C\AL in OnRun
    // +----------------------------------------------------------------------------------------------------------------+

    TableNo = "PWD Connector Messages";

    trigger OnRun()
    var
        CduLFileManagement: Codeunit "PWD File Management";
        CduLFTPMgt: Codeunit "PWD FTP Management";
    begin
        RecGPartner.Get("Partner Code");
        if not RecGPartner."FTP Active" then
            exit;
        Clear(CduLFTPMgt);
        Clear(CduLFileManagement);
        TestField(Path);
        TestField("FTP Remote Path");
        CduLFTPMgt.FctAutomationSetProperties(false, true);
        CduLFTPMgt.Fct_InitFTPMembers(RecGPartner."FTP HostName/IP", RecGPartner."FTP Port No.", RecGPartner."FTP Login",
                                      RecGPartner."FTP Password", RecGPartner."FTP Binary Mode", RecGPartner."FTP Passive Mode",
                                      Path, "FTP Remote Path");

        case Direction of
            Direction::Export:
                begin
                    TxtGErrorMessage := CduLFTPMgt.Fct_sPutFiles("FTP Filter File");
                    if TxtGErrorMessage <> '' then
                        Error(TxtGErrorMessage);
                    CduLFileManagement.FctDeleteFiles(Rec, OptGFlowType)
                end;
            Direction::Import:
                begin
                    TxtGErrorMessage := CduLFTPMgt.Fct_sGetFiles("FTP Filter File");

                    //>>FTP.002
                    if TxtGErrorMessage <> '' then
                        Error(TxtGErrorMessage);
                    //<<FTP.002

                    CduLFTPMgt.Fct_sDeleteFiles();
                end;
        end;
    end;

    var
        RecGPartner: Record "PWD Partner Connector";
        OptGFlowType: Option " ","Import Connector","Export Connector";
        TxtGErrorMessage: Text[1024];
}

