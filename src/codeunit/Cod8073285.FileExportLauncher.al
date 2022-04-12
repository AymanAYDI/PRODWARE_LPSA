codeunit 8073285 "PWD File Export Launcher"
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

    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        RecLPartnerConnector: Record "PWD Partner Connector";
        CduLFileExport: Codeunit "PWD File Export";
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
        if "Parameter String" <> '' then begin
            IntLPostion := StrPos("Parameter String", ';');
            if IntLPostion > 1 then begin
                TxtLPameter := CopyStr("Parameter String", 1, IntLPostion - 1);
                RecLPartnerConnector.SetFilter(Code, TxtLPameter);
            end;
        end;
        //<<OSYS-Int001.001

        if not RecLPartnerConnector.IsEmpty then begin
            RecLPartnerConnector.FindSet;
            repeat
                Commit;

                //>>OSYS-Int001.001
                CduLFileExport.FctInitJobQueueEntry(Rec);
                //<<OSYS-Int001.001

                if not CduLFileExport.Run(RecLPartnerConnector) then;
            until RecLPartnerConnector.Next = 0;
        end;
    end;
}

