codeunit 50010 "PWD File Export Launcherge"
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
    // />>ProdConnect1.6
    // OSYS-Int001.001:GR 20/10/2011   Connector integration
    //                                  - C\AL in :  OnRun
    // +----------------------------------------------------------------------------------------------------------------+


    trigger OnRun()
    var
        RecLPartnerConnector: Record "PWD Partner Connector";
        CduLFileExport: Codeunit "File Export";
        IntLPostion: Integer;
        TxtLPameter: Text[250];
    begin
        //**********************************************************************************************************//
        //                                  Launch File Export connectors                                           //
        //**********************************************************************************************************//

        RecLPartnerConnector.Reset;
        RecLPartnerConnector.SetRange(Blocked, false);
        RecLPartnerConnector.SetRange("Communication Mode", RecLPartnerConnector."Communication Mode"::File);

        //>>OSYS-Int001.001
        RecLPartnerConnector.SetFilter(Code, 'OSYS');
        //<<OSYS-Int001.001

        if not RecLPartnerConnector.IsEmpty then begin
            RecLPartnerConnector.FindSet;
            repeat
                Commit;

                //>>OSYS-Int001.001
                //CduLFileExport.FctInitJobQueueEntry(Rec);
                //<<OSYS-Int001.001

                if not CduLFileExport.Run(RecLPartnerConnector) then;
            until RecLPartnerConnector.Next = 0;
        end;
    end;
}

