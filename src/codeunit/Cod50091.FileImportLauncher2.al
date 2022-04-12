codeunit 50091 "PWD File Import Launcher2"
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


    trigger OnRun()
    begin
        //**********************************************************************************************************//
        //                                  Launch File Import connectors                                           //
        //**********************************************************************************************************//

        RecLPartnerConnector.Reset;
        RecLPartnerConnector.SetRange(Blocked, false);
        RecLPartnerConnector.SetRange("Communication Mode", RecLPartnerConnector."Communication Mode"::File);
        if not RecLPartnerConnector.IsEmpty then begin
            RecLPartnerConnector.FindSet;
            repeat

                Commit;
                if not CduLFileImport.Run(RecLPartnerConnector) then;
            until RecLPartnerConnector.Next = 0;
        end;
    end;

    var
        RecLPartnerConnector: Record "PWD Partner Connector";
        CduLFileImport: Codeunit "File Import";
}

