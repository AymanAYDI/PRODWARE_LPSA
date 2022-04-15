codeunit 8073283 "PWD MSMQ Handler Launcher"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect.1.00
    // FE_ProdConnect.001:GR 22/03/2011  Connector integration
    //                                   - Create Object
    // 
    // +----------------------------------------------------------------------------------------------------------------+

    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        RecLPartnerConnector: Record "PWD Partner Connector";
    begin
        //**********************************************************************************************************//
        //                                  Launch Codeunits MSMQ connectors                                        //
        //**********************************************************************************************************//

        RecLPartnerConnector.Reset();
        RecLPartnerConnector.SetRange(Blocked, false);
        RecLPartnerConnector.SetRange("Communication Mode", RecLPartnerConnector."Communication Mode"::MSMQ);
        if not RecLPartnerConnector.IsEmpty then begin
            RecLPartnerConnector.FindSet();
            repeat
                Commit();
                CODEUNIT.Run(RecLPartnerConnector."Object ID to Run", RecLPartnerConnector);
            until RecLPartnerConnector.Next() = 0;
        end;
    end;
}

