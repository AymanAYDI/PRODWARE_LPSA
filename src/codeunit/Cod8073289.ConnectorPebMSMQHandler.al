codeunit 8073289 "PWD Connector Peb MSMQ Handler"
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

    SingleInstance = true;
    TableNo = "PWD Partner Connector";

    trigger OnRun()
    begin
        // IF NOT BooGLaunched THEN BEGIN
        //     BooGLaunched := TRUE;
        //     CREATE(AutGMsQBusAdp);//TODO: Type Automation n'existe pas dans la nouvelle version
        //     CREATE(AutGNavComComp); //TODO: Type Automation n'existe pas dans la nouvelle version
        //     CREATE(AutGXMLDom); //TODO: Type Automation n'existe pas dans la nouvelle version

        //     //Init communication component for MSMQ
        //     AutGMsQBusAdp.RemoveWhenCommit(TRUE);
        //     AutGNavComComp.AddBusAdapter(AutGMsQBusAdp, 1);

        //     //Init MSQM Receive and Reply
        //     RecGPrtCon := Rec;
        //     FctInit("Receive Queue", "Reply Queue");
        //     AutGMsQBusAdp.OpenReceiveQueue("Receive Queue", 0, 0);
        //     AutGMsQBusAdp.OpenReplyQueue("Reply Queue", 0, 0);
        // END;
    end;

    var
        // AutGMsQBusAdp: Automation; //TODO: Type Automation n'existe pas dans la nouvelle version
        // [WithEvents]
        // AutGNavComComp: Automation; //TODO: Type Automation n'existe pas dans la nouvelle version
        // AutGXMLDom: Automation; //TODO: Type Automation n'existe pas dans la nouvelle version
        // AutGXMLNode: Automation; //TODO: Type Automation n'existe pas dans la nouvelle version
        CodGRequest: Code[30];
        CodGPartnerID: Code[20];
        TxtGSendQueue: Text[250];
        TxtGReceiveQueue: Text[250];
        RecGPrtCon: Record "PWD Partner Connector";
        BooGLaunched: Boolean;

    procedure FctInit(TxtPSendQueue: Text[250]; TxtPReceiveQueue: Text[250])
    begin
        //**********************************************************************************************************//
        //                                  Init MSMQ Prameters from Nas Handler                                    //
        //**********************************************************************************************************//

        TxtGSendQueue := TxtPSendQueue;
        TxtGReceiveQueue := TxtPReceiveQueue;
    end;

    procedure FctParseRequest()
    begin
        //**********************************************************************************************************//
        //                                  Getting   Request  function                                             //
        //**********************************************************************************************************//

        // CLEAR(CodGRequest); //TODO: Type Automation n'existe pas dans la nouvelle version
        // AutGXMLNode := AutGXMLDom.selectSingleNode('/IDXMLSerial/NavFunctionToCall');
        // IF STRLEN(AutGXMLNode.text) > 0 THEN
        //     CodGRequest := COPYSTR(AutGXMLNode.text, 1, 30);
    end;


    procedure FctParsePartner()
    begin
        //**********************************************************************************************************//
        //                                  Getting   Partner ID                                                    //
        //**********************************************************************************************************//

        // CLEAR(CodGPartnerID); //TODO: Type Automation n'existe pas dans la nouvelle version
        // AutGXMLNode := AutGXMLDom.selectSingleNode('/IDXMLSerial/PartnerID');
        // IF STRLEN(AutGXMLNode.text) > 0 THEN
        //     CodGPartnerID := COPYSTR(AutGXMLNode.text, 1, 20);
    end;


    procedure FctReplyErrorMSMQ(TxtPMsg: Text[250]; var OusPStream: OutStream)
    // var
    //     AutLXMLDom: Automation; //TODO: Type Automation n'existe pas dans la nouvelle version
    //     AutLXMLDomElement: Automation; //TODO: Type Automation n'existe pas dans la nouvelle version
    //     AutLXMLDomElement2: Automation; //TODO: Type Automation n'existe pas dans la nouvelle version
    //     AutLXMLDomProcInst: Automation; //TODO: Type Automation n'existe pas dans la nouvelle version
    //     AutLXMLDomNodeTxt: Automation; //TODO: Type Automation n'existe pas dans la nouvelle version
    begin
        // **********************************************************************************************************//
        //                                  Send string message  to MSMQ                                            //
        // **********************************************************************************************************//

        // CREATE(AutLXMLDom); //TODO: Type Automation n'existe pas dans la nouvelle version
        // AutLXMLDom.loadXML('<msgbody/>');
        // AutLXMLDomProcInst := AutLXMLDom.createProcessingInstruction('xml', 'version="1.0" encoding="UTF-8" standalone="no"');
        // AutLXMLDomElement := AutLXMLDom.documentElement;
        // AutLXMLDom.insertBefore(AutLXMLDomProcInst, AutLXMLDomElement);
        // AutLXMLDomElement2 := AutLXMLDom.createElement('error');
        // AutLXMLDomNodeTxt := AutLXMLDom.createTextNode(TxtPMsg);
        // AutLXMLDomElement2.appendChild(AutLXMLDomNodeTxt);
        // AutLXMLDomElement.appendChild(AutLXMLDomElement2);
        // AutLXMLDom.save(OusPStream);
    end;
}

