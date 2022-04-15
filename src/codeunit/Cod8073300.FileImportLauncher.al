codeunit 8073300 "PWD File Import Launcher"
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

    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        //**********************************************************************************************************//
        //                                  Launch File Export connectors                                           //
        //**********************************************************************************************************//

        RecLPartnerConnector.Reset();
        RecLPartnerConnector.SetRange(Blocked, false);
        RecLPartnerConnector.SetRange("Communication Mode", RecLPartnerConnector."Communication Mode"::File);
        if not RecLPartnerConnector.IsEmpty then begin
            RecLPartnerConnector.FindSet();
            repeat
                Commit();
                if not CduLFileImport.Run(RecLPartnerConnector) then;
            until RecLPartnerConnector.Next() = 0;
        end;
    end;

    var
        RecLPartnerConnector: Record "PWD Partner Connector";
        CduLFileImport: Codeunit "PWD File Import";
}

