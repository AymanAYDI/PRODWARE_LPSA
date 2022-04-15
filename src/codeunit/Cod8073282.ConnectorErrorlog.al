codeunit 8073282 "PWD Connector Error log"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect.1.00
    // 
    // FE_ProdConnect.001:GR 22/03/2011  Connector integration
    //                                   - Create Object
    // +----------------------------------------------------------------------------------------------------------------+


    trigger OnRun()
    begin
    end;

    procedure InsertLogEntry(OptErrorLevel: Option " ",Warning,Blocking; OptFlowType: Option ,"Import Connector","Export Connector"; CodConnectorPartner: Code[20]; TxtPMessage: Text[250]; IntPTransction: Integer)
    var
        RecLICError: Record "PWD Connector Error Log";
    begin
        //**********************************************************************************************************//
        //                                  Insert Error Log                                                        //
        //**********************************************************************************************************//

        with RecLICError do begin
            Init();
            RecLICError.ErrorType := OptErrorLevel;
            RecLICError."Flow Type" := OptFlowType;
            RecLICError."Connector Partner" := CodConnectorPartner;
            RecLICError."Buffer Message No." := IntPTransction;
            RecLICError.Message := TxtPMessage;
            Insert(true);
        end;
    end;
}

