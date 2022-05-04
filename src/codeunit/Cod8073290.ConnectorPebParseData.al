codeunit 8073290 "PWD Connector Peb Parse Data"
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
    // 
    // //>>ProdConnect1.5
    // WMS-FEMOT.001:GR 29/06/2011  Connector management
    //                              - Add Buffer management
    //                              - C\AL in : FctGetItemXml
    // 
    // WMS-FE007_15.001:GR 05/07/2011 Receipt
    //                              - Add function FctUpdateReceiptLine
    // 
    // WMS-FE008_15.001:GR 19/07/2011 Shipment
    //                              - Add function FctUpdateShipmentLine
    // 
    // FE_ProdConnect.002:GR 14/09/2011  Connector integration
    //                                   - Add new functions :
    //                                     FctGetHeaderArchiveXml
    //                                     FctGetLineArchiveXml
    //                                   - C\AL in : FctGetOrderXml
    //                                               FctGetCustOrdersXml
    // +----------------------------------------------------------------------------------------------------------------+

    TableNo = "PWD Connector Values";

    trigger OnRun()
    begin
        //**********************************************************************************************************//
        //                                  Get Requested DATA                                                      //
        //**********************************************************************************************************//

        CASE "Function" OF
            //>>WMS-FEMOT.001
            'ADDORDER':

                //FctAddOrderXml(Rec);
                FctAddOrder(Rec);

            'CREATECUSTOMER':

                FctCreateCustomer(Rec);
            //>>WMS-FEMOT.001

            'GETITEMPRICE':
                CASE "File format" OF
                    "File format"::Xml:
                        FctGetItemXml(Rec);
                    "File format"::"with separator":
                        FctGetItemWithSep(Rec);
                    "File format"::"File Position":
                        FctGetItemFilePos(Rec);
                END;
            'GETITEMSTOCK':
                CASE "File format" OF
                    "File format"::Xml:
                        FctGetItemStockXml(Rec);
                    "File format"::"with separator":
                        FctGetItemStockWithSep(Rec);
                    "File format"::"File Position":
                        FctGetItemStockFilePos(Rec);
                END;
            'GETITEMPRICEBYPACKING':
                CASE "File format" OF
                    "File format"::Xml:
                        FctGetItemPByPackingXml(Rec);
                    "File format"::"with separator":
                        FctGetItemPByPackingWithSep(Rec);
                    "File format"::"File Position":
                        FctGetItemPByPackingFilePos(Rec);
                END;
            'GETORDER':
                CASE "File format" OF
                    "File format"::Xml:
                        FctGetOrderXml(Rec);
                    "File format"::"with separator":
                        FctGetOrderWithSep(Rec);
                    "File format"::"File Position":
                        FctGetOrderFilePos(Rec);
                END;
            'GETSHIPMENTSTATUS':
                CASE "File format" OF
                    "File format"::Xml:
                        FctGetShipmentStatusXml(Rec);
                    "File format"::"with separator":
                        FctGetShipmentStatusWithSep(Rec);
                    "File format"::"File Position":
                        FctGetShipmentStatusFilePos(Rec);
                END;
            'GETSHIPMENTCOST':
                CASE "File format" OF
                    "File format"::Xml:
                        FctGetShipmentCostXml(Rec);
                    "File format"::"with separator":
                        FctGetShipmentCostWithSep(Rec);
                    "File format"::"File Position":
                        FctGetShipmentCostFilePos(Rec);
                END;

            //>>WMS-FEMOT.001
            /*
            'CREATECUSTOMER':
              CASE "File format" OF
                "File format"::Xml                   :
                  FctCreateCustomerXml(Rec);
                "File format"::"with separator"      :
                  FctCreateCustomerWithSep(Rec);
                "File format"::"File Position"       :
                  FctCreateCustomerFilePos(Rec);
              END;

            'ADDORDER'      :
              CASE "File format" OF
                "File format"::Xml                   :
                  FctAddOrderXml(Rec);
                "File format"::"with separator"      :
                  FctAddOrderWithSep(Rec);
                "File format"::"File Position"       :
                  FctAddOrderFilePos(Rec);
              END;
              */
            //<<WMS-FEMOT.001

            'GETCUSTOMERORDERS':
                CASE "File format" OF
                    "File format"::Xml:
                        FctGetCustOrdersXml(Rec);
                    "File format"::"with separator":
                        FctGetCustOrdersWithSep(Rec);
                    "File format"::"File Position":
                        FctGetCustOrdersFilePos(Rec);
                END;
        END;

    end;

    var
        CduGConnectBufMgtExport: Codeunit "Connector Buffer Mgt Export";
        CduGFileManagement: Codeunit "File Management";
        CduGBufferManagement: Codeunit "PWD Buffer Management";
        // AutGXMLDom: Automation; //TODO: Variable de type Automation
        CstGDecValue: Label 'La valeur décimal %1 n''est pas correcte';
        TxtGError: Label 'Data not available';
        TxtGFields: array[100] of Text[50];
        TxtGData: array[100] of Text[250];
        TxtGFilters: array[100] of Text[1024];


    procedure FctParseData()
    var
        // AutLXMLNodeData: Automation; //TODO: Variable de type Automation
        // AutLXMLNodeDataList: Automation; //TODO: Variable de type Automation
        IntLIndex: Integer;
    begin
        //**********************************************************************************************************//
        //                                  Parse Request Data                                                      //
        //**********************************************************************************************************//

        IntLIndex := 1;
        CLEAR(TxtGData);
        // AutLXMLNodeData := AutGXMLDom.selectSingleNode('/IDXMLSerial/Data'); //TODO: Variable de type Automation
        // IF NOT ISCLEAR(AutLXMLNodeData) THEN BEGIN  //TODO: Variable de type Automation
        //     AutLXMLNodeDataList := AutLXMLNodeData.selectNodes('/IDXMLSerial/Data');  //TODO: Variable de type Automation
        //     AutLXMLNodeData := AutLXMLNodeDataList.nextNode();  //TODO: Variable de type Automation
        // END;
        // WHILE NOT ISCLEAR(AutLXMLNodeData) DO BEGIN  //TODO: Variable de type Automation
        //     TxtGData[IntLIndex] := COPYSTR(AutLXMLNodeData.text, 1, 250);  //TODO: Variable de type Automation
        //     AutLXMLNodeData := AutLXMLNodeDataList.nextNode();  //TODO: Variable de type Automation
        //     IntLIndex += 1;
        // END;
    end;


    procedure FctParseFilters()
    var
        // AutLXMLNodeFileds: Automation;  //TODO: Variable de type Automation
        // AutLXMLNodeFiledsList: Automation;  //TODO: Variable de type Automation
        // AutLXMLNodeFilters: Automation;  //TODO: Variable de type Automation
        // AutLXMLNodeFiltersList: Automation;  //TODO: Variable de type Automation
        IntLIndex: Integer;
    begin
        //**********************************************************************************************************//
        //                                 Parse Request filters                                                    //
        //**********************************************************************************************************//

        // IntLIndex := 1;  //TODO: Variable de type Automation
        // AutLXMLNodeFilters := AutGXMLDom.selectSingleNode('/IDXMLSerial/Filters');  //TODO: Variable de type Automation
        // AutLXMLNodeFileds := AutGXMLDom.selectSingleNode('/IDXMLSerial/Fields'); //TODO: Variable de type Automation
        // IF NOT ISCLEAR(AutLXMLNodeFilters) THEN BEGIN //TODO: Variable de type Automation
        //     AutLXMLNodeFiltersList := AutLXMLNodeFilters.selectNodes('/IDXMLSerial/Filters'); //TODO: Variable de type Automation
        //     AutLXMLNodeFilters := AutLXMLNodeFiltersList.nextNode(); //TODO: Variable de type Automation
        // END;
        // IF NOT ISCLEAR(AutLXMLNodeFileds) THEN BEGIN //TODO: Variable de type Automation
        //     AutLXMLNodeFiledsList := AutLXMLNodeFileds.selectNodes('/IDXMLSerial/Fields'); //TODO: Variable de type Automation
        //     AutLXMLNodeFileds := AutLXMLNodeFiledsList.nextNode(); //TODO: Variable de type Automation
        // END;

        // WHILE NOT ISCLEAR(AutLXMLNodeFileds) DO BEGIN //TODO: Variable de type Automation
        //     TxtGFilters[IntLIndex] := COPYSTR(AutLXMLNodeFilters.text, 1, 1024); //TODO: Variable de type Automation
        //     TxtGFields[IntLIndex] := COPYSTR(AutLXMLNodeFileds.text, 1, 50); //TODO: Variable de type Automation
        //     AutLXMLNodeFilters := AutLXMLNodeFiltersList.nextNode(); //TODO: Variable de type Automation
        //     AutLXMLNodeFileds := AutLXMLNodeFiledsList.nextNode(); //TODO: Variable de type Automation
        //     IntLIndex += 1;
        // END;
    end;


    procedure FctGetView(IntPTableID: Integer): Text[1000]
    var
        RecRefLTableToFilter: RecordRef;
        FieldRefLFieldToFilter: FieldRef;
        BooLFindFilter: Boolean;
        IntLFieldNo: Integer;
        IntLIndex: Integer;
    begin
        //**********************************************************************************************************//
        //                                  Get filters                                                             //
        //**********************************************************************************************************//

        CLEAR(BooLFindFilter);
        FctParseFilters();
        RecRefLTableToFilter.OPEN(IntPTableID);
        FOR IntLIndex := 1 TO ARRAYLEN(TxtGFields) DO
            IF EVALUATE(IntLFieldNo, TxtGFields[IntLIndex]) AND (IntLFieldNo <> 0) THEN BEGIN
                FieldRefLFieldToFilter := RecRefLTableToFilter.FIELD(IntLFieldNo);
                IF TxtGFilters[IntLIndex] <> '' THEN BEGIN
                    FieldRefLFieldToFilter.SETFILTER(TxtGFilters[IntLIndex]);
                    BooLFindFilter := TRUE;
                END;
            END;

        IF BooLFindFilter THEN
            EXIT(RecRefLTableToFilter.GETVIEW())
        ELSE
            EXIT('');
    end;


    procedure FctGetItemXml(RecPConnectorVal: Record "PWD Connector Values")
    var
        RecLGeneralLedgerSetup: Record "General Ledger Setup";
        RecLItem: Record Item;
        RecLSendingMessage: Record "PWD Connector Messages";
        RecLSalesPrice: Record "Sales Price";
        RecLSalesPrice2: Record "Sales Price";
        // RecLTempBlob: Codeunit "Temp Blob"; //TODO: probleme Codeunit "Temp Blob" 
        RecLRef: RecordRef;
        BooLTreatmentOK: Boolean;
        DecLQty: Decimal;
        InsLStream: InStream;
        OusLStream: OutStream;
        TxtLQtyWithoutSpace: Text[250];
    begin
        //**********************************************************************************************************//
        //                             Return Unit Price for an Item, by using Xml Management.                      //
        //                                                                                                          //
        // Parameters:                                                                                              //
        // TxtGData[1]: Customer No.                                                                                //
        // TxtGData[2]: Item No.                                                                                    //
        // TxtGData[3]: Quantity                                                                                    //
        // TxtGData[4]: Currency Code                                                                               //
        //**********************************************************************************************************//

        RecPConnectorVal.CALCFIELDS(Blob);
        RecPConnectorVal.Blob.CREATEOUTSTREAM(OusLStream);
        // CREATE(AutGXMLDom);  //TODO: Variable de type Automation
        // AutGXMLDom.load(OusLStream);  //TODO: Variable de type Automation

        FctParseData();

        RecLItem.GET(TxtGData[2]);
        RecLSalesPrice.RESET();
        RecLSalesPrice.SETRANGE("Item No.", TxtGData[2]);
        IF TxtGData[1] <> '' THEN BEGIN
            RecLSalesPrice.SETRANGE("Sales Type", RecLSalesPrice."Sales Type"::Customer);
            RecLSalesPrice.SETRANGE("Sales Code", TxtGData[1]);
            IF RecLSalesPrice.ISEMPTY THEN BEGIN
                RecLSalesPrice.RESET();
                RecLSalesPrice.SETRANGE("Item No.", TxtGData[2]);
                RecLSalesPrice.SETRANGE("Sales Type", RecLSalesPrice."Sales Type"::"All Customers");
            END;
        END
        ELSE
            RecLSalesPrice.SETRANGE("Sales Type", RecLSalesPrice."Sales Type"::"All Customers");


        TxtLQtyWithoutSpace := DELCHR(TxtGData[3], '=', ' ');
        // IF NOT CduGFileManagement.FctEvaluateDecimal(TxtLQtyWithoutSpace, DecLQty) THEN  //TODO: Variable de type Automation
        //     ERROR(STRSUBSTNO(CstGDecValue, TxtLQtyWithoutSpace));

        RecLSalesPrice.SETFILTER("Minimum Quantity", '<=%1', DecLQty);

        IF RecLGeneralLedgerSetup.GET() THEN
            IF RecLGeneralLedgerSetup."LCY Code" = TxtGData[4] THEN
                RecLSalesPrice.SETRANGE("Currency Code", '')
            ELSE
                RecLSalesPrice.SETRANGE("Currency Code", TxtGData[4]);

        BooLTreatmentOK := FALSE;

        IF RecLSalesPrice.FINDLAST() THEN BEGIN
            RecLSalesPrice2.RESET();
            RecLSalesPrice2.COPYFILTERS(RecLSalesPrice);
            RecLSalesPrice2.SETRANGE("Minimum Quantity", RecLSalesPrice."Minimum Quantity");
            IF RecLSalesPrice2.FINDLAST() THEN BEGIN
                RecLSendingMessage.RESET();
                RecLSendingMessage.SETRANGE("Partner Code", RecPConnectorVal."Partner Code");
                RecLSendingMessage.SETRANGE("Function", RecPConnectorVal."Function");
                RecLSendingMessage.FINDFIRST();

                //>>WMS-FEMOT.001
                IF RecLSendingMessage."Export Option" = RecLSendingMessage."Export Option"::Partial THEN BEGIN
                    CLEAR(RecLRef);
                    RecLRef.GETTABLE(RecLSalesPrice2);
                    CduGConnectBufMgtExport.FctSetExportDateFilter(RecLSendingMessage, RecLRef);
                END;
                //<<WMS-FEMOT.001

                // CduGConnectBufMgtExport.FctCreateXml(RecLSalesPrice2.GETVIEW(), RecLSendingMessage, RecLTempBlob, TRUE); //TODO: probleme Codeunit "Temp Blob"
                //TODO: 'Codeunit "Temp Blob"' does not contain a definition for 'CALCFIELDS'
                //RecLTempBlob.CALCFIELDS(Blob);
                // IF RecLTempBlob.HASVALUE() THEN BEGIN //TODO: probleme Codeunit "Temp Blob" begin
                //     RecLTempBlob.CREATEINSTREAM(InsLStream);
                //     CduGBufferManagement.FctCreateBufferValues(InsLStream, RecPConnectorVal."Partner Code", RecPConnectorVal."File Name",
                //                                                RecPConnectorVal."Function", RecPConnectorVal."File format",
                //                                                RecPConnectorVal.Separator,
                //                                                RecPConnectorVal.Direction::Export, RecPConnectorVal."Entry No.",
                //                                                RecPConnectorVal."Message Code");
                //     BooLTreatmentOK := TRUE;
                // END;  //TODO: probleme Codeunit "Temp Blob" end
            END;
        END;
        IF NOT BooLTreatmentOK THEN
            ERROR(TxtGError);
    end;


    procedure FctGetItemXml_File(RecPConnectorVal: Record "PWD Connector Values")
    begin
        //**********************************************************************************************************//
        //                            Return Unit Price for an Item, by using File Management.                      //
        //                                                                                                          //
        // Parameters:                                                                                              //
        // TxtGData[1]: Customer No.                                                                                //
        // TxtGData[2]: Item No.                                                                                    //
        // TxtGData[3]: Quantity                                                                                    //
        // TxtGData[4]: Currency Code                                                                               //
        //**********************************************************************************************************//


        //*******************************************
        //Code not used actually, written for example
        //*******************************************


        /*
        //Récupération de la ligne d'info.
        RecPConnectorVal.Blob.CREATEINSTREAM(StrLStreamIn);
        
        CREATE(AutLXMLDom);
        AutLXMLDom.load(StrLStreamIn);
        AutLXMLNodeTable := AutLXMLDom.selectSingleNode('/' + RecPConnectorVal."Partner Code");
          AutLXMLNodeTableList :=  AutLXMLNodeTable.childNodes;
          AutLXMLNodeTable := AutLXMLNodeTableList.nextNode();
        
        WHILE NOT ISCLEAR(AutLXMLNodeTable ) DO
        BEGIN
          //******************************************  Debut Import  *************************************************
          AutLXMLNodeTableList2 := AutLXMLNodeTable.childNodes;
          AutLXMLNodeTable2 := AutLXMLNodeTableList2.nextNode();
          WHILE NOT ISCLEAR(AutLXMLNodeTable2 ) DO
          BEGIN
          //******************************************  Function  ***************************************************
            AutLXMLNodeTable2 := AutLXMLNodeTableList2.nextNode();
            AutLXMLNodeTableFieldList := AutLXMLNodeTable2.childNodes();
            AutLXMLNodeTableField := AutLXMLNodeTableFieldList.nextNode();
            WHILE NOT ISCLEAR(AutLXMLNodeTableField ) DO
            BEGIN
            //******************************************  Table Field   ********************************************
              {
              //Traitement des champs
              IF STRLEN(AutLXMLNodeTableField.text) > 0 THEN
                TxtLaInserer := COPYSTR(AutLXMLNodeTableField.text,1,250);
              EVALUATE(RecIDG,TxtLaInserer);
              COMMIT;
              }
              AutLXMLNodeTableField := AutLXMLNodeTableFieldList.nextNode();
            END;
            //tableField
            AutLXMLNodeTable2 := AutLXMLNodeTableList2.nextNode();
          END;
          //function
          AutLXMLNodeTable := AutLXMLNodeTableList.nextNode();
        END;
        //Import
        */

    end;


    procedure FctGetItemWithSep(RecPConnectorVal: Record "PWD Connector Values")
    begin
        //**********************************************************************************************************//
        //                       Return Unit Price for an Item, by using Separator File Management.                 //
        //                                                                                                          //
        // Parameters:                                                                                              //
        // TxtGData[1]: Customer No.                                                                                //
        // TxtGData[2]: Item No.                                                                                    //
        // TxtGData[3]: Quantity                                                                                    //
        // TxtGData[4]: Currency Code                                                                               //
        //**********************************************************************************************************//


        //*******************************************
        //Code not used actually, written for example
        //*******************************************

        /*
        //Récupération de la ligne d'info.
        RecPConnectorVal.Blob.CREATEINSTREAM(StrLStreamIn);
        
        WHILE NOT (StrLStreamIn.EOS()) DO
        BEGIN
          StrLStreamIn.READTEXT(TxtLReadBlob);
          TxtLTextLine := TxtLReadBlob;
        
          //Précision des positions du séparateur
          FOR IntLMeter := 1 TO 2 DO
          BEGIN
            IntLPositions[IntLMeter] := STRPOS(TxtLTextLine,RecPConnectorVal.Separator);
            TxtLTextLine := COPYSTR(TxtLTextLine,STRPOS(TxtLTextLine,RecPConnectorVal.Separator) + 1,STRLEN(TxtLTextLine));
          END;
        
          {
          //Récupération des info. (dispatchés)
          TxtGPostingDate := COPYSTR(TxtLReadBlob,1,IntLPositions[1] - 1);
          EVALUATE(DatLPostingDate,TxtGPostingDate);
          TxtLReadBlob := COPYSTR(TxtLReadBlob,STRPOS(TxtLReadBlob,';') + 1,STRLEN(TxtLReadBlob));
          TxtGExternalDoc := COPYSTR(TxtLReadBlob,1,IntLPositions[2] - 1);
          TxtGItemNo := COPYSTR(TxtLReadBlob,1,IntLPositions[3] - 1);
          }
        END;
        */

    end;


    procedure FctGetItemFilePos(RecPConnectorVal: Record "PWD Connector Values")
    begin
        //**********************************************************************************************************//
        //                       Return Unit Price for an Item, by using File Position Management.                  //
        //                                                                                                          //
        // Parameters:                                                                                              //
        // TxtGData[1]: Customer No.                                                                                //
        // TxtGData[2]: Item No.                                                                                    //
        // TxtGData[3]: Quantity                                                                                    //
        // TxtGData[4]: Currency Code                                                                               //
        //**********************************************************************************************************//


        //*******************************************
        //Code not used actually, written for example
        //*******************************************

        /*
        //Longueur de la ligne d'infos.
        IntLLengthOfLine:= 10;
        
        //Récupération de la ligne d'info.
        RecPConnectorVal.Blob.CREATEINSTREAM(StrLStreamIn);
        
        WHILE NOT (StrLStreamIn.EOS()) DO
        BEGIN
          StrLStreamIn.READTEXT(TxtLReadBlob,IntLLengthOfLine);
        
          {
          //Récupération des info. (dispatchés)
          TxtGPostingDate := COPYSTR(TxtGReadFile,1,10);
          EVALUATE(DatLPostingDate,TxtGPostingDate);
          TxtGExternalDoc := COPYSTR(TxtGReadFile,11,20);
          EVALUATE(CdeLExternalDoc,TxtGExternalDoc);
          }
        
        END;
        */

    end;


    procedure FctGetItemStockXml(RecPConnectorVal: Record "PWD Connector Values")
    var
        RecLItem: Record Item;
        RecLSendingMessage: Record "PWD Connector Messages";
        // RecLTempBlob: Codeunit "Temp Blob"; //TODO: probleme Codeunit "Temp Blob" 
        InsLStream: InStream;
        OusLStream: OutStream;
    begin
        //**********************************************************************************************************//
        //                             Return Inventory for an Item, by using Xml Management.                      //
        //                                                                                                          //
        // Parameters:                                                                                              //
        // TxtGData[1]: Item No.                                                                                    //
        //**********************************************************************************************************//

        RecPConnectorVal.CALCFIELDS(Blob);
        RecPConnectorVal.Blob.CREATEOUTSTREAM(OusLStream);
        // CLEAR(AutGXMLDom);  //TODO: Variable de type Automation
        // CREATE(AutGXMLDom);  //TODO: Variable de type Automation
        // AutGXMLDom.load(OusLStream);  //TODO: Variable de type Automation

        FctParseData();

        RecLItem.GET(TxtGData[1]);

        RecLItem.SETRANGE("No.", TxtGData[1]);
        IF RecLItem.FINDFIRST() THEN BEGIN
            RecLSendingMessage.RESET();
            RecLSendingMessage.SETRANGE("Partner Code", RecPConnectorVal."Partner Code");
            RecLSendingMessage.SETRANGE("Function", RecPConnectorVal."Function");
            RecLSendingMessage.FINDFIRST();
            // CduGConnectBufMgtExport.FctCreateXml(RecLItem.GETVIEW(), RecLSendingMessage, RecLTempBlob, TRUE);  //TODO: probleme Codeunit "Temp Blob"
            //TODO:'Codeunit "Temp Blob"' does not contain a definition for 'CALCFIELDS'
            //RecLTempBlob.CALCFIELDS(Blob);
            // IF RecLTempBlob.HASVALUE() THEN BEGIN   //TODO: probleme Codeunit "Temp Blob" begin
            //     RecLTempBlob.CREATEINSTREAM(InsLStream);
            //     CduGBufferManagement.FctCreateBufferValues(InsLStream, RecPConnectorVal."Partner Code", RecPConnectorVal."File Name",
            //                                               RecPConnectorVal."Function", RecPConnectorVal."File format",
            //                                               RecPConnectorVal.Separator,
            //                                               RecPConnectorVal.Direction::Export, RecPConnectorVal."Entry No.",
            //                                               RecPConnectorVal."Message Code");
            // END
            // ELSE
            //     ERROR(TxtGError); //TODO: probleme Codeunit "Temp Blob" end
        END
        ELSE
            ERROR(TxtGError);
    end;


    procedure FctGetItemStockWithSep(RecPConnectorVal: Record "PWD Connector Values")
    begin
    end;


    procedure FctGetItemStockFilePos(RecPConnectorVal: Record "PWD Connector Values")
    begin
    end;


    procedure FctGetItemPByPackingXml(RecPConnectorVal: Record "PWD Connector Values")
    begin
    end;


    procedure FctGetItemPByPackingWithSep(RecPConnectorVal: Record "PWD Connector Values")
    begin
    end;


    procedure FctGetItemPByPackingFilePos(RecPConnectorVal: Record "PWD Connector Values")
    begin
    end;


    procedure FctAddOrderXml(RecPConnectorVal: Record "PWD Connector Values")
    var
        RecLSendingMessage: Record "PWD Connector Messages";
        RecLSalesSetup: Record "Sales & Receivables Setup";
        RecLSalesCommentLine: Record "Sales Comment Line";
        RecLSalesHeader: Record "Sales Header";
        RecLSalesHeader2: Record "Sales Header";
        RecLSalesLine: Record "Sales Line";
        RecLTempVATAmountLine0: Record "VAT Amount Line" temporary;
        RecLTempVATAmountLine1: Record "VAT Amount Line" temporary;
        // RecLTempBlob: Codeunit "Temp Blob"; //TODO: probleme Codeunit "Temp Blob" 
        // AutLXMLNode: Automation;  //TODO: Variable de type Automation
        // AutLXMLNodeList: Automation; //TODO: Variable de type Automation
        // AutLXMLNodeList1: Automation; //TODO: Variable de type Automation
        // AutLXMLNodeList3: Automation; //TODO: Variable de type Automation
        BooLOrderInserted: Boolean;
        CodLCustomer: Code[20];
        CodLExternalDocNo: Code[20];
        CodLItemNo: Code[20];
        CodLOrderNo: Code[20];
        DatLStartingDate: Date;
        DecLItemPrice: Decimal;
        DecLLineAmount: Decimal;
        InsLStream: InStream;
        i: Integer;
        IntLDay: Integer;
        IntLMonth: Integer;
        IntLQtty: Integer;
        IntLYear: Integer;
        CstLOrderExist: Label 'Cette commande existe déjà';
        OusLStream: OutStream;
        TxtLCommentHeaderPartial: Text[80];
        TxtLCommentlinePartial: Text[80];
        TxtLCommentHeader: Text[1024];
        TxtLCommentline: Text[1024];
    begin
        //**********************************************************************************************************//
        //                             Add order, by using Xml Management.                                          //
        //**********************************************************************************************************//

        RecPConnectorVal.CALCFIELDS(Blob);
        RecPConnectorVal.Blob.CREATEOUTSTREAM(OusLStream);
        // CLEAR(AutGXMLDom);  //TODO: Variable de type Automation
        // CREATE(AutGXMLDom); //TODO: Variable de type Automation
        // AutGXMLDom.load(OusLStream); //TODO: Variable de type Automation
        CLEAR(BooLOrderInserted);
        CLEAR(DatLStartingDate);
        CLEAR(CodLOrderNo);
        CLEAR(CodLCustomer);
        CLEAR(CodLExternalDocNo);
        // AutLXMLNodeList := AutGXMLDom.selectNodes('/IDXMLSerial/Orders');  //TODO: Variable de type Automation begin
        // AutLXMLNode := AutLXMLNodeList.nextNode();
        // WHILE NOT ISCLEAR(AutLXMLNode) DO   // Orders Loop
        // BEGIN
        //     AutLXMLNodeList1 := AutLXMLNode.childNodes();
        //     AutLXMLNode := AutLXMLNodeList1.nextNode();
        //     WHILE NOT ISCLEAR(AutLXMLNode) DO   // Orders Detail Loop
        //     BEGIN
        //         CASE AutLXMLNode.nodeName OF
        //             'OrderNo':
        //                 BEGIN
        //                     IF AutLXMLNode.text <> '' THEN
        //                         CodLOrderNo := COPYSTR(AutLXMLNode.text, 1, 20);
        //                     RecLSalesHeader2.RESET();
        //                     RecLSalesHeader2.SETRANGE("PWD Order No. From Partner", CodLOrderNo);
        //                     IF RecLSalesHeader2.FINDFIRST() THEN
        //                         ERROR(CstLOrderExist);
        //                 END;
        //             'CustomerNo':
        //                 IF AutLXMLNode.text <> '' THEN
        //                     CodLCustomer := COPYSTR(AutLXMLNode.text, 1, 20);
        //             'Reference':
        //                 IF AutLXMLNode.text <> '' THEN
        //                     CodLExternalDocNo := COPYSTR(AutLXMLNode.text, 1, 20);
        //             'Comment':
        //                 IF AutLXMLNode.text <> '' THEN
        //                     TxtLCommentHeader := COPYSTR(AutLXMLNode.text, 1, 1024); // A mettre ds les commentaires de la comman
        //             'Date':
        //                 BEGIN
        //                     CLEAR(IntLYear);
        //                     CLEAR(IntLDay);
        //                     CLEAR(IntLMonth);
        //                     AutLXMLNodeList3 := AutLXMLNode.childNodes();
        //                     AutLXMLNode := AutLXMLNodeList3.nextNode();
        //                     WHILE NOT ISCLEAR(AutLXMLNode) DO BEGIN
        //                         CASE AutLXMLNode.nodeName OF
        //                             'Day':
        //                                 EVALUATE(IntLDay, AutLXMLNode.text);
        //                             'Month':
        //                                 EVALUATE(IntLMonth, AutLXMLNode.text);
        //                             'Year':
        //                                 EVALUATE(IntLYear, AutLXMLNode.text);
        //                         END;
        //                         AutLXMLNode := AutLXMLNodeList3.nextNode();
        //                     END;
        //                 END; //TODO: Variable de type Automation end

        // 'OrderLines':
        //     BEGIN //TODO: Variable de type Automation end
        IF NOT BooLOrderInserted THEN BEGIN
            BooLOrderInserted := TRUE;
            RecLSalesHeader.INIT();
            RecLSalesHeader."Document Type" := RecLSalesHeader."Document Type"::Order;
            RecLSalesHeader."No." := '';
            RecLSalesHeader.INSERT(TRUE);
            RecLSalesHeader.VALIDATE("Sell-to Customer No.", CodLCustomer);
            RecLSalesHeader.VALIDATE("Posting Date", DMY2DATE(IntLDay, IntLMonth, IntLYear));
            RecLSalesHeader."External Document No." := CodLExternalDocNo;
            RecLSalesHeader."PWD Order No. From Partner" := CodLOrderNo;
            RecLSalesHeader.MODIFY();
            i := 1;
            TxtLCommentHeaderPartial := TxtLCommentHeader;
            TxtLCommentHeaderPartial := COPYSTR(TxtLCommentHeader, 1, 80);
            IF TxtLCommentHeaderPartial <> '' THEN
                REPEAT
                    RecLSalesCommentLine.INIT();
                    RecLSalesCommentLine."Document Type" := RecLSalesCommentLine."Document Type"::Order;
                    RecLSalesCommentLine."No." := RecLSalesHeader."No.";
                    RecLSalesCommentLine."Line No." := i * 10000;
                    RecLSalesCommentLine."Document Line No." := 0;
                    RecLSalesCommentLine.Date := DatLStartingDate;
                    RecLSalesCommentLine.Comment := TxtLCommentHeaderPartial;
                    RecLSalesCommentLine.INSERT();
                    TxtLCommentHeaderPartial := COPYSTR(TxtLCommentHeader, (1 + i * 80), 80);
                    i += 1;
                UNTIL TxtLCommentHeaderPartial = '';
        END;
        // AutLXMLNodeList3 := AutLXMLNode.childNodes(); //TODO: Variable de type Automation begin
        // AutLXMLNode := AutLXMLNodeList3.nextNode();
        // WHILE NOT ISCLEAR(AutLXMLNode) DO BEGIN
        //     CASE AutLXMLNode.nodeName OF
        //         'ItemNo':
        //             EVALUATE(CodLItemNo, AutLXMLNode.text);
        //         'ItemPrice':
        //             IF NOT CduGFileManagement.FctEvaluateDecimal(AutLXMLNode.text, DecLItemPrice) THEN
        //                 ERROR(STRSUBSTNO(CstGDecValue, AutLXMLNode.text));
        //         //EVALUATE(DecLItemPrice, AutLXMLNode.text);
        //         'Comment':
        //             IF AutLXMLNode.text <> '' THEN
        //                 TxtLCommentline := COPYSTR(AutLXMLNode.text, 1, 1024);
        //         'Quatity':
        //             EVALUATE(IntLQtty, AutLXMLNode.text);
        //         'LineAmount':
        //             IF NOT CduGFileManagement.FctEvaluateDecimal(AutLXMLNode.text, DecLLineAmount) THEN
        //                 ERROR(STRSUBSTNO(CstGDecValue, AutLXMLNode.text));
        //     //EVALUATE(DecLLineAmount, AutLXMLNode.text);
        //     END;
        //     AutLXMLNode := AutLXMLNodeList3.nextNode(); //TODO: Variable de type Automation end
        // END;
        IF RecLSalesHeader."No." <> '' THEN BEGIN
            RecLSalesLine.INIT();
            RecLSalesLine.VALIDATE("Document Type", RecLSalesLine."Document Type"::Order);
            RecLSalesLine.VALIDATE("Document No.", RecLSalesHeader."No.");
            RecLSalesLine."Line No." := FctNextLineNo(RecLSalesHeader."No.");
            RecLSalesLine.INSERT(TRUE);
            RecLSalesLine.Type := RecLSalesLine.Type::Item;
            RecLSalesLine.VALIDATE("No.", CodLItemNo);
            RecLSalesLine.VALIDATE("Unit Price", DecLItemPrice);
            RecLSalesLine.VALIDATE(Quantity, IntLQtty);
            IF DecLItemPrice <> 0 THEN
                RecLSalesLine.VALIDATE("Line Amount", DecLLineAmount);
            RecLSalesLine.MODIFY();
        END;
        i := 1;
        TxtLCommentlinePartial := COPYSTR(TxtLCommentline, 1, 80);
        IF TxtLCommentlinePartial <> '' THEN
            REPEAT
                RecLSalesCommentLine.INIT();
                RecLSalesCommentLine."Document Type" := RecLSalesCommentLine."Document Type"::Order;
                RecLSalesCommentLine."No." := RecLSalesHeader."No.";
                RecLSalesCommentLine."Line No." := i * 10000;
                RecLSalesCommentLine."Document Line No." := RecLSalesLine."Line No.";
                RecLSalesCommentLine.Date := DatLStartingDate;
                RecLSalesCommentLine.Comment := TxtLCommentlinePartial;
                RecLSalesCommentLine.INSERT();
                TxtLCommentlinePartial := COPYSTR(TxtLCommentline, (1 + i * 80), 80);
                i += 1;
            UNTIL TxtLCommentlinePartial = '';
        //END;
        // END; AutLXMLNodeList1.nextNode(); //TODO: Variable de type Automation 
        // AutLXMLNode := AutLXMLNodeList1.nextNode(); //TODO: Variable de type Automation 
        // END;  //End Detail Loop AutLXMLNodeList1.nextNode(); //TODO: Variable de type Automation 
        // AutLXMLNode := AutLXMLNodeList.nextNode(); //TODO: Variable de type Automation 
        // END;  //End Orders Loop



        //Calc SalesHeaderAmount
        RecLSalesHeader.GET(RecLSalesHeader."Document Type", RecLSalesHeader."No.");
        RecLSalesLine.RESET();
        RecLSalesSetup.GET();
        IF RecLSalesSetup."Calc. Inv. Discount" THEN BEGIN
            CODEUNIT.RUN(CODEUNIT::"Sales-Calc. Discount", RecLSalesLine);
            RecLSalesHeader.GET(RecLSalesHeader."Document Type", RecLSalesHeader."No.");
        END;
        RecLSalesLine.SetSalesHeader(RecLSalesHeader);
        RecLSalesLine.CalcVATAmountLines(0, RecLSalesHeader, RecLSalesLine, RecLTempVATAmountLine0);
        RecLSalesLine.CalcVATAmountLines(1, RecLSalesHeader, RecLSalesLine, RecLTempVATAmountLine1);
        RecLSalesLine.UpdateVATOnLines(0, RecLSalesHeader, RecLSalesLine, RecLTempVATAmountLine0);
        RecLSalesLine.UpdateVATOnLines(1, RecLSalesHeader, RecLSalesLine, RecLTempVATAmountLine1);
        RecLSalesHeader.MODIFY(TRUE);

        CLEAR(OusLStream);
        RecLSalesHeader.SETRANGE("Document Type", RecLSalesHeader."Document Type");
        RecLSalesHeader.SETRANGE("No.", RecLSalesHeader."No.");
        RecLSendingMessage.RESET();
        RecLSendingMessage.SETRANGE("Partner Code", RecPConnectorVal."Partner Code");
        RecLSendingMessage.SETRANGE("Function", RecPConnectorVal."Function");
        RecLSendingMessage.FINDFIRST();
        // CduGConnectBufMgtExport.FctCreateXml(RecLSalesHeader.GETVIEW(), RecLSendingMessage, RecLTempBlob, TRUE);  //TODO: probleme Codeunit "Temp Blob"
        //TODO: 'Codeunit "Temp Blob"' does not contain a definition for 'CALCFIELDS'
        //RecLTempBlob.CALCFIELDS(Blob);
        // IF RecLTempBlob.HASVALUE() THEN BEGIN  //TODO: probleme Codeunit "Temp Blob"
        //     RecLTempBlob.CREATEINSTREAM(InsLStream);
        //     CduGBufferManagement.FctCreateBufferValues(InsLStream, RecPConnectorVal."Partner Code", RecPConnectorVal."File Name",
        //                                                RecPConnectorVal."Function", RecPConnectorVal."File format",
        //                                                RecPConnectorVal.Separator,
        //                                                RecPConnectorVal.Direction::Export, RecPConnectorVal."Entry No.",
        //                                                RecPConnectorVal."Message Code")
        // END
        // ELSE
        //     ERROR(TxtGError);  //TODO: probleme Codeunit "Temp Blob"
    end;


    procedure FctAddOrderFilePos(RecPConnectorVal: Record "PWD Connector Values")
    begin
    end;


    procedure FctAddOrderWithSep(RecPConnectorVal: Record "PWD Connector Values")
    begin
    end;


    procedure FctNextLineNo(CodPDocNo: Code[20]): Integer
    var
        RecLSalesLine: Record "Sales Line";
    begin
        //**********************************************************************************************************//
        //                                    Find the next line No. for an order                                   //
        //**********************************************************************************************************//

        RecLSalesLine.RESET();
        RecLSalesLine.SETRANGE("Document Type", RecLSalesLine."Document Type"::Order);
        RecLSalesLine.SETRANGE("Document No.", CodPDocNo);
        IF RecLSalesLine.FINDLAST() THEN
            EXIT(RecLSalesLine."Line No." + 10000)
        ELSE
            EXIT(10000);
    end;


    procedure FctGetOrderXml(RecPConnectorVal: Record "PWD Connector Values")
    var
        RecLSalesHeader: Record "Sales Header";
        //  CduLStreamMgt: Codeunit "PWD File Management"; //TODO: probleme Codeunit "PWD File Management" 
        // RecLTempBlob: Codeunit "Temp Blob"; //TODO: Probleme Codeunit "Temp Blob"
        // RecLTempBlob1: Codeunit "Temp Blob"; //TODO: Probleme Codeunit "Temp Blob"
        // RecLTempBlob2: Codeunit "Temp Blob"; //TODO: Probleme Codeunit "Temp Blob"
        InsLStream: InStream;
        InsLStream1: InStream;
        InsLStream2: InStream;
        OusLStream: OutStream;
    begin
        //**********************************************************************************************************//
        //                             Return Order information, by using Xml Management.                           //
        //                                                                                                          //
        // Parameters:                                                                                              //
        // TxtGData[1]: Order No.                                                                                   //
        //**********************************************************************************************************//

        RecPConnectorVal.CALCFIELDS(Blob);
        RecPConnectorVal.Blob.CREATEOUTSTREAM(OusLStream);
        // CLEAR(AutGXMLDom); //TODO: Probleme type automation
        // CREATE(AutGXMLDom); //TODO: Probleme type automation
        // AutGXMLDom.load(OusLStream); //TODO: Probleme type automation

        FctParseData();

        //>>FE_ProdConnect.002
        IF NOT RecLSalesHeader.GET(RecLSalesHeader."Document Type"::Order, TxtGData[1]) THEN BEGIN
            // FctGetHeaderArchiveXml(RecPConnectorVal, TxtGData[1], RecLTempBlob1);  //TODO: probleme Codeunit "Temp Blob"
            //TODO:'Codeunit "Temp Blob"' does not contain a definition for 'CALCFIELDS'
            //RecLTempBlob1.CALCFIELDS(Blob);
            // RecLTempBlob1.CREATEINSTREAM(InsLStream1);  //TODO: probleme Codeunit "Temp Blob"

            // FctGetLineArchiveXml(RecPConnectorVal, TxtGData[1], RecLTempBlob2);  //TODO: probleme Codeunit "Temp Blob"
            //TODO:'Codeunit "Temp Blob"' does not contain a definition for 'CALCFIELDS'
            //RecLTempBlob2.CALCFIELDS(Blob);
            // RecLTempBlob2.CREATEINSTREAM(InsLStream2);  //TODO: probleme Codeunit "Temp Blob"
        END
        ELSE BEGIN
            //<<FE_ProdConnect.002

            // FctGetHeaderOrderXml(RecPConnectorVal, TxtGData[1], RecLTempBlob1);  //TODO: probleme Codeunit "Temp Blob"
            //TODO:'Codeunit "Temp Blob"' does not contain a definition for 'CALCFIELDS'
            //RecLTempBlob1.CALCFIELDS(Blob);
            // RecLTempBlob1.CREATEINSTREAM(InsLStream1);   //TODO: probleme Codeunit "Temp Blob"

            // FctGetLineOrderXml(RecPConnectorVal, TxtGData[1], RecLTempBlob2);  //TODO: probleme Codeunit "Temp Blob"
            //TODO:'Codeunit "Temp Blob"' does not contain a definition for 'CALCFIELDS'
            //RecLTempBlob2.CALCFIELDS(Blob);
            // RecLTempBlob2.CREATEINSTREAM(InsLStream2);  //TODO: probleme Codeunit "Temp Blob"

            //>>FE_ProdConnect.002
        END;
        //<<FE_ProdConnect.002

        // CduLStreamMgt.FctMergeStream(InsLStream1, InsLStream2, RecLTempBlob, RecPConnectorVal."Partner Code");  //TODO: probleme Codeunit "Temp Blob"
        //TODO:'Codeunit "Temp Blob"' does not contain a definition for 'CALCFIELDS'
        //RecLTempBlob.CALCFIELDS(Blob);
        // IF RecLTempBlob.HASVALUE() THEN BEGIN  //TODO: probleme Codeunit "Temp Blob" begin
        //     RecLTempBlob.CREATEINSTREAM(InsLStream);
        //     CduGBufferManagement.FctCreateBufferValues(InsLStream, RecPConnectorVal."Partner Code", RecPConnectorVal."File Name",
        //                                               RecPConnectorVal."Function", RecPConnectorVal."File format",
        //                                               RecPConnectorVal.Separator,
        //                                               RecPConnectorVal.Direction::Export, RecPConnectorVal."Entry No.",
        //                                               RecPConnectorVal."Message Code")
        // END
        // ELSE
        //     ERROR(TxtGError);  //TODO: probleme Codeunit "Temp Blob" end
    end;


    // procedure FctGetHeaderOrderXml(RecPConnectorVal: Record "PWD Connector Values"; TxtPValue: Text[250]; var RecLTempBlob: Codeunit "Temp Blob") //TODO: probleme Codeunit "Temp Blob"  begin
    // var
    //     RecLSendingMessage: Record "PWD Connector Messages";
    //     RecLSalesHeader: Record "Sales Header";
    // begin
    //     //**********************************************************************************************************//
    //     //                                           Return Order Header                                            //
    //     //                                                                                                          //
    //     // Parameters:                                                                                              //
    //     // RecPconnectorValue: buffer Table                                                                         //
    //     // TxtPValue: Order No.                                                                                     //
    //     // RecLTempBlob: Blob used temporary                                                                        //
    //     //**********************************************************************************************************//

    //     RecLSalesHeader.GET(RecLSalesHeader."Document Type"::Order, TxtPValue);
    //     RecLSalesHeader.SETRANGE("Document Type", RecLSalesHeader."Document Type"::Order);
    //     RecLSalesHeader.SETRANGE("No.", TxtPValue);
    //     IF RecLSalesHeader.FINDFIRST() THEN BEGIN
    //         RecLSendingMessage.RESET();
    //         RecLSendingMessage.SETRANGE("Partner Code", RecPConnectorVal."Partner Code");
    //         RecLSendingMessage.SETRANGE("Function", RecPConnectorVal."Function");
    //         RecLSendingMessage.SETRANGE("Table ID", DATABASE::"Sales Header");
    //         RecLSendingMessage.FINDFIRST();
    //         CduGConnectBufMgtExport.FctCreateXml(RecLSalesHeader.GETVIEW(), RecLSendingMessage, RecLTempBlob, TRUE);
    //     END
    //     ELSE
    //         ERROR(TxtGError);
    // end; //TODO: probleme Codeunit "Temp Blob"  end


    // procedure FctGetLineOrderXml(RecPConnectorVal: Record "PWD Connector Values"; TxtPValue: Text[250]; var RecLTempBlob: Codeunit "Temp Blob")  //TODO: probleme Codeunit "Temp Blob" begin
    // var
    //     RecLSendingMessage: Record "PWD Connector Messages";
    //     RecLSalesLine: Record "Sales Line";
    // begin
    //     //**********************************************************************************************************//
    //     //                                           Return Order Header                                            //
    //     //                                                                                                          //
    //     // Parameters:                                                                                              //
    //     // RecPconnectorValue: buffer Table                                                                         //
    //     // TxtPValue: Order No.                                                                                     //
    //     // RecLTempBlob: Blob used temporary                                                                        //
    //     //**********************************************************************************************************//

    //     RecLSalesLine.SETRANGE("Document Type", RecLSalesLine."Document Type"::Order);
    //     RecLSalesLine.SETRANGE("Document No.", TxtPValue);
    //     IF RecLSalesLine.FINDFIRST() THEN BEGIN
    //         RecLSendingMessage.RESET();
    //         RecLSendingMessage.SETRANGE("Partner Code", RecPConnectorVal."Partner Code");
    //         RecLSendingMessage.SETRANGE("Function", RecPConnectorVal."Function");
    //         RecLSendingMessage.SETRANGE("Table ID", DATABASE::"Sales Line");
    //         RecLSendingMessage.FINDFIRST();
    //         CduGConnectBufMgtExport.FctCreateXml(RecLSalesLine.GETVIEW(), RecLSendingMessage, RecLTempBlob, FALSE);
    //     END;
    //     //>>FE_ProdConnect.002
    //     //ELSE
    //     //  ERROR(TxtGError);
    //     //<<FE_ProdConnect.002
    // end; //TODO: probleme Codeunit "Temp Blob"  end


    procedure FctGetOrderWithSep(RecPConnectorVal: Record "PWD Connector Values")
    begin
    end;


    procedure FctGetOrderFilePos(RecPConnectorVal: Record "PWD Connector Values")
    begin
    end;


    procedure FctGetOrdersWithSep(RecPConnectorVal: Record "PWD Connector Values")
    begin
    end;


    procedure FctGetOrdersFilePos(RecPConnectorVal: Record "PWD Connector Values")
    begin
    end;


    procedure FctGetShipmentStatusXml(RecPConnectorVal: Record "PWD Connector Values")
    var
        RecLSendingMessage: Record "PWD Connector Messages";
        RecLSalesShipmentHeader: Record "Sales Shipment Header";
        // RecLTempBlob: Codeunit "Temp Blob"; //TODO: Probleme Codeunit "Temp Blob"
        InsLStream: InStream;
        StrLStreamOut: OutStream;
    begin
        //**********************************************************************************************************//
        //                         Return Sales Shipment information, by using Xml management.                      //
        //                                                                                                          //
        // Parameters:                                                                                              //
        // TxtGData[1]: Order No.                                                                                   //
        //**********************************************************************************************************//

        RecPConnectorVal.CALCFIELDS(Blob);
        RecPConnectorVal.Blob.CREATEOUTSTREAM(StrLStreamOut);
        // CLEAR(AutGXMLDom); //TODO: probleme type automation
        // CREATE(AutGXMLDom);  //TODO: probleme type automation
        // AutGXMLDom.load(StrLStreamOut);  //TODO: probleme type automation

        FctParseData();

        RecLSalesShipmentHeader.SETRANGE("Order No.", TxtGData[1]);
        IF RecLSalesShipmentHeader.FINDFIRST() THEN BEGIN
            RecLSendingMessage.RESET();
            RecLSendingMessage.SETRANGE("Partner Code", RecPConnectorVal."Partner Code");
            RecLSendingMessage.SETRANGE("Function", RecPConnectorVal."Function");
            RecLSendingMessage.FINDFIRST();
            // CduGConnectBufMgtExport.FctCreateXml(RecLSalesShipmentHeader.GETVIEW(), RecLSendingMessage, RecLTempBlob, TRUE); //TODO: probleme Codeunit "Temp Blob" 
            //TODO:'Codeunit "Temp Blob"' does not contain a definition for 'CALCFIELDS'
            // RecLTempBlob.CALCFIELDS(Blob); 
            // IF RecLTempBlob.HASVALUE() THEN BEGIN  //TODO: Probleme Codeunit "Temp Blob" begin
            //     RecLTempBlob.CREATEINSTREAM(InsLStream);
            //     CduGBufferManagement.FctCreateBufferValues(InsLStream, RecPConnectorVal."Partner Code", RecPConnectorVal."File Name",
            //                                               RecPConnectorVal."Function", RecPConnectorVal."File format",
            //                                               RecPConnectorVal.Separator,
            //                                               RecPConnectorVal.Direction::Export, RecPConnectorVal."Entry No.",
            //                                               RecPConnectorVal."Message Code");
            // END
            // ELSE
            //     ERROR(TxtGError); //TODO: Probleme Codeunit "Temp Blob" end
        END
        ELSE
            ERROR(TxtGError);
    end;


    procedure FctGetShipmentStatusWithSep(RecPConnectorVal: Record "PWD Connector Values")
    begin
    end;


    procedure FctGetShipmentStatusFilePos(RecPConnectorVal: Record "PWD Connector Values")
    begin
    end;


    procedure FctCreateCustomerXml(RecPConnectorVal: Record "PWD Connector Values")
    var
        RecLCustomer: Record Customer;
        RecLCustomer2: Record Customer;
        RecLSendingMessage: Record "PWD Connector Messages";
        // RecLTempBlob: Codeunit "Temp Blob"; //TODO: probleme Codeunit "Temp Blob" 
        InsLStream: InStream;
        StrLStreamOut: OutStream;
    begin
        //**********************************************************************************************************//
        //                             Create a customer, by using Xml Management.                                  //
        //                                                                                                          //
        // Parameters:                                                                                              //
        // TxtGData[1]: Name                                                                                        //
        // TxtGData[2]: Search Name                                                                                 //
        // TxtGData[3]: Address                                                                                     //
        // TxtGData[4]: City                                                                                        //
        // TxtGData[5]: E-mail                                                                                      //
        // TxtGData[6]: Phone No.                                                                                   //
        // TxtGData[7]: Address 2                                                                                   //
        // TxtGData[8]: Post Code                                                                                   //
        // TxtGData[9]: Country/Region Code                                                                         //
        //**********************************************************************************************************//

        RecPConnectorVal.CALCFIELDS(Blob);
        RecPConnectorVal.Blob.CREATEOUTSTREAM(StrLStreamOut);
        // CLEAR(AutGXMLDom); //TODO:probleme type automation
        // CREATE(AutGXMLDom);//TODO:probleme type automation
        // AutGXMLDom.load(StrLStreamOut);//TODO:probleme type automation

        FctParseData();

        RecLSendingMessage.RESET();
        RecLSendingMessage.SETRANGE("Partner Code", RecPConnectorVal."Partner Code");
        RecLSendingMessage.SETRANGE("Function", RecPConnectorVal."Function");
        RecLSendingMessage.FINDFIRST();

        RecLCustomer.INIT();
        RecLCustomer.VALIDATE(Name, TxtGData[1]);
        RecLCustomer.INSERT(TRUE);
        RecLCustomer.VALIDATE("Search Name", TxtGData[2]);
        RecLCustomer.VALIDATE(Address, TxtGData[3]);
        RecLCustomer.VALIDATE("Address 2", TxtGData[7]);
        RecLCustomer."Post Code" := TxtGData[8];
        RecLCustomer.VALIDATE(City, TxtGData[4]);
        RecLCustomer.VALIDATE(RecLCustomer."Country/Region Code", TxtGData[9]);
        RecLCustomer.VALIDATE("E-Mail", TxtGData[5]);
        RecLCustomer.VALIDATE("Phone No.", TxtGData[6]);
        RecLCustomer.MODIFY(TRUE);
        RecLCustomer2.GET(RecLCustomer."No.");
        RecLCustomer2.RESET();
        RecLCustomer2.SETRANGE("No.", RecLCustomer."No.");
        IF RecLCustomer2.FINDFIRST() THEN BEGIN
            // CduGConnectBufMgtExport.FctCreateXml(RecLCustomer2.GETVIEW(), RecLSendingMessage, RecLTempBlob, TRUE); //TODO: probleme Codeunit "Temp Blob" 
            //TODO:'Codeunit "Temp Blob"' does not contain a definition for 'CALCFIELDS'
            //RecLTempBlob.CALCFIELDS(Blob);
            // IF RecLTempBlob.HASVALUE() THEN BEGIN  //TODO: probleme Codeunit "Temp Blob" 
            //     RecLTempBlob.CREATEINSTREAM(InsLStream);
            //     CduGBufferManagement.FctCreateBufferValues(InsLStream, RecPConnectorVal."Partner Code", RecPConnectorVal."File Name",
            //                                               RecPConnectorVal."Function", RecPConnectorVal."File format",
            //                                               RecPConnectorVal.Separator,
            //                                               RecPConnectorVal.Direction::Export, RecPConnectorVal."Entry No.",
            //                                               RecPConnectorVal."Message Code");
            // END
            // ELSE
            ERROR(TxtGError);
        END
        ELSE
            ERROR(TxtGError);
    end;


    procedure FctCreateCustomerWithSep(RecPConnectorVal: Record "PWD Connector Values")
    begin
    end;


    procedure FctCreateCustomerFilePos(RecPConnectorVal: Record "PWD Connector Values")
    begin
    end;


    procedure FctGetShipmentCostXml(RecPConnectorVal: Record "PWD Connector Values")
    begin
    end;


    procedure FctGetShipmentCostWithSep(RecPConnectorVal: Record "PWD Connector Values")
    begin
    end;


    procedure FctGetShipmentCostFilePos(RecPConnectorVal: Record "PWD Connector Values")
    begin
    end;


    procedure FctGetCustOrdersXml(RecPConnectorVal: Record "PWD Connector Values")
    var
        RecLSendingMessage: Record "PWD Connector Messages";
        RecLSalesHeader: Record "Sales Header";
        RecLSalesHeaderArchive: Record "Sales Header Archive";
        // CduLStreamMgt: Codeunit "PWD File Management"; //TODO: probleme Codeunit "PWD File Management";
        // RecLTempBlob: Codeunit "Temp Blob"; //TODO: probleme Codeunit "Temp Blob" 
        // RecLTempBlob1: Codeunit "Temp Blob"; //TODO: probleme Codeunit "Temp Blob" 
        // RecLTempBlob2: Codeunit "Temp Blob"; //TODO: probleme Codeunit "Temp Blob" 
        DatLDate1: Date;
        DatLDate2: Date;
        InsLStream: InStream;
        InsLStream1: InStream;
        InsLStream2: InStream;
        IntLDay1: Integer;
        IntLDay2: Integer;
        IntLMonth1: Integer;
        IntLMonth2: Integer;
        IntLYear1: Integer;
        IntLYear2: Integer;
        OusLStream: OutStream;
    begin
        //**********************************************************************************************************//
        //                             Return Sales Order, by using Xml Management.                                 //
        //                                                                                                          //
        // Parameters:                                                                                              //
        // TxtGData[1]: Sell-to Customer No.                                                                        //
        // TxtGData[2]: Day1                                                                                        //
        // TxtGData[3]: Month1                                                                                      //
        // TxtGData[4]: year1                                                                                       //
        // TxtGData[5]: Day2                                                                                        //
        // TxtGData[6]: Month2                                                                                      //
        // TxtGData[7]: Year2                                                                                       //
        //**********************************************************************************************************//

        RecPConnectorVal.CALCFIELDS(Blob);
        RecPConnectorVal.Blob.CREATEOUTSTREAM(OusLStream);
        // CLEAR(AutGXMLDom);  //TODO:probleme type automation
        // CREATE(AutGXMLDom);  //TODO:probleme type automation
        // AutGXMLDom.load(OusLStream);  //TODO:probleme type automation

        FctParseData();

        RecLSalesHeader.RESET();
        RecLSalesHeader.SETRANGE("Document Type", RecLSalesHeader."Document Type"::Order);
        RecLSalesHeader.SETRANGE("Sell-to Customer No.", TxtGData[1]);

        IF TxtGData[2] <> '' THEN
            EVALUATE(IntLDay1, TxtGData[2]);
        IF TxtGData[3] <> '' THEN
            EVALUATE(IntLMonth1, TxtGData[3]);
        IF TxtGData[4] <> '' THEN
            EVALUATE(IntLYear1, TxtGData[4]);
        IF TxtGData[5] <> '' THEN
            EVALUATE(IntLDay2, TxtGData[5]);
        IF TxtGData[6] <> '' THEN
            EVALUATE(IntLMonth2, TxtGData[6]);
        IF TxtGData[7] <> '' THEN
            EVALUATE(IntLYear2, TxtGData[7]);

        IF (IntLDay1 <> 0) AND (IntLMonth1 <> 0) AND (IntLYear1 <> 0) THEN
            DatLDate1 := DMY2DATE(IntLDay1, IntLMonth1, IntLYear1);
        IF (IntLDay2 <> 0) AND (IntLMonth2 <> 0) AND (IntLYear2 <> 0) THEN
            DatLDate2 := DMY2DATE(IntLDay2, IntLMonth2, IntLYear2);
        IF (DatLDate1 <> 0D) AND (DatLDate2 <> 0D) THEN
            RecLSalesHeader.SETRANGE("Order Date", DatLDate1, DatLDate2);

        //>>FE_ProdConnect.002
        /*OLD :
            IF RecLSalesHeader.FINDFIRST THEN
            BEGIN
              RecLSendingMessage.RESET;
              RecLSendingMessage.SETRANGE("Partner Code",RecPConnectorVal."Partner Code");
              RecLSendingMessage.SETRANGE("Function",RecPConnectorVal."Function");
              RecLSendingMessage.FINDFIRST;
              CduGConnectBufMgtExport.FctCreateXml(RecLSalesHeader.GETVIEW,RecLSendingMessage,RecLTempBlob,TRUE);
              RecLTempBlob.CALCFIELDS(Blob);
              IF RecLTempBlob.Blob.HASVALUE THEN
              BEGIN
                RecLTempBlob.Blob.CREATEINSTREAM(InsLStream);
                CduGBufferManagement.FctCreateBufferValues(InsLStream,RecPConnectorVal."Partner Code",RecPConnectorVal."File Name",
                                                          RecPConnectorVal."Function",RecPConnectorVal."File format",
                                                          RecPConnectorVal.Separator,
                                                          RecPConnectorVal.Direction::Export,RecPConnectorVal."Entry No.",
                                                          RecPConnectorVal."Message Code");
              END
              ELSE
                ERROR(TxtGError);
            END
            ELSE
              ERROR(TxtGError);
        */

        RecLSalesHeaderArchive.RESET();
        RecLSalesHeaderArchive.SETRANGE("Document Type", RecLSalesHeaderArchive."Document Type"::Order);
        RecLSalesHeaderArchive.SETRANGE("Sell-to Customer No.", TxtGData[1]);
        IF (DatLDate1 <> 0D) AND (DatLDate2 <> 0D) THEN
            RecLSalesHeaderArchive.SETRANGE("Order Date", DatLDate1, DatLDate2);

        IF NOT RecLSalesHeader.ISEMPTY THEN BEGIN
            RecLSendingMessage.RESET();
            RecLSendingMessage.SETRANGE("Partner Code", RecPConnectorVal."Partner Code");
            RecLSendingMessage.SETRANGE("Function", RecPConnectorVal."Function");
            RecLSendingMessage.SETRANGE("Table ID", DATABASE::"Sales Header");
            RecLSendingMessage.FINDFIRST();
            // CduGConnectBufMgtExport.FctCreateXml(RecLSalesHeader.GETVIEW(), RecLSendingMessage, RecLTempBlob1, TRUE); //TODO: probleme Codeunit "Temp Blob" 
            //TODO:'Codeunit "Temp Blob"' does not contain a definition for 'CALCFIELDS'
            //RecLTempBlob1.CALCFIELDS(Blob);
            // RecLTempBlob1.CREATEINSTREAM(InsLStream1); //TODO: probleme Codeunit "Temp Blob" 
        END;

        IF NOT RecLSalesHeaderArchive.ISEMPTY THEN BEGIN
            RecLSendingMessage.RESET();
            RecLSendingMessage.SETRANGE("Partner Code", RecPConnectorVal."Partner Code");
            RecLSendingMessage.SETRANGE("Function", RecPConnectorVal."Function");
            RecLSendingMessage.SETRANGE("Table ID", DATABASE::"Sales Header Archive");
            RecLSendingMessage.FINDFIRST();
            // CduGConnectBufMgtExport.FctCreateXml(RecLSalesHeaderArchive.GETVIEW(), RecLSendingMessage, RecLTempBlob2, FALSE); //TODO: probleme Codeunit "Temp Blob" 
            //TODO:'Codeunit "Temp Blob"' does not contain a definition for 'CALCFIELDS'
            //RecLTempBlob2.CALCFIELDS(Blob);
            // RecLTempBlob2.CREATEINSTREAM(InsLStream2); //TODO: probleme Codeunit "Temp Blob" 
        END;


        // IF (NOT RecLTempBlob1.HASVALUE()) AND (NOT RecLTempBlob2.HASVALUE()) THEN //TODO: probleme Codeunit "Temp Blob" 
        //     ERROR(TxtGError);//TODO: probleme Codeunit "Temp Blob" 

        // IF (RecLTempBlob1.HASVALUE()) AND (RecLTempBlob2.HASVALUE()) THEN BEGIN  //TODO: probleme Codeunit "Temp Blob"  begin
        //     CduLStreamMgt.FctMergeStream(InsLStream1, InsLStream2, RecLTempBlob, RecPConnectorVal."Partner Code");
        //     //TODO: 'Codeunit "Temp Blob"' does not contain a definition for 'CALCFIELDS'
        //     //RecLTempBlob.CALCFIELDS(Blob);
        //     RecLTempBlob.CREATEINSTREAM(InsLStream);
        //     CduGBufferManagement.FctCreateBufferValues(InsLStream, RecPConnectorVal."Partner Code", RecPConnectorVal."File Name",
        //                                                RecPConnectorVal."Function", RecPConnectorVal."File format",
        //                                                RecPConnectorVal.Separator,
        //                                                RecPConnectorVal.Direction::Export, RecPConnectorVal."Entry No.",
        //                                                RecPConnectorVal."Message Code");
        // END
        // ELSE
        //     IF (RecLTempBlob1.HASVALUE()) THEN
        //         CduGBufferManagement.FctCreateBufferValues(InsLStream1, RecPConnectorVal."Partner Code", RecPConnectorVal."File Name",
        //                                                    RecPConnectorVal."Function", RecPConnectorVal."File format",
        //                                                    RecPConnectorVal.Separator,
        //                                                    RecPConnectorVal.Direction::Export, RecPConnectorVal."Entry No.",
        //                                                    RecPConnectorVal."Message Code")
        //     ELSE
        //         CduGBufferManagement.FctCreateBufferValues(InsLStream2, RecPConnectorVal."Partner Code", RecPConnectorVal."File Name",
        //                                                    RecPConnectorVal."Function", RecPConnectorVal."File format",
        //                                                    RecPConnectorVal.Separator,
        //                                                    RecPConnectorVal.Direction::Export, RecPConnectorVal."Entry No.",
        //                                                    RecPConnectorVal."Message Code"); //TODO: probleme Codeunit "Temp Blob"  end
        //<<FE_ProdConnect.002

    end;


    procedure FctGetCustOrdersWithSep(RecPConnectorVal: Record "PWD Connector Values")
    begin
    end;


    procedure FctGetCustOrdersFilePos(RecPConnectorVal: Record "PWD Connector Values")
    begin
    end;

    procedure FctAddOrder(var RecPConnectorVal: Record "PWD Connector Values")
    var
        RecLSendingMessage: Record "PWD Connector Messages";
        RecLPEBSalesCommentLineBuffer: Record "PWD PEB Sales Comm Line Buffer";
        RecLPEBSalesHeaderBuffer: Record "PWD PEB Sales Header Buffer";
        RecLPEBSalesLineBuffer: Record "PWD PEB Sales Line Buffer";
        RecLSalesCommentLineBuffer: Record "PWD Sales Comment Line Buffer";
        RecLSalesHeaderBuffer: Record "PWD Sales Header Buffer";
        RecLSalesLineBuffer: Record "PWD Sales Line Buffer";
        RecLSalesHeader: Record "Sales Header";
        // RecLTempBlob: Codeunit "Temp Blob"; //TODO: probleme Codeunit "Temp Blob"
        RecordRef: RecordRef;
        // AutLXMLNode: Automation;  //TODO:probleme type automation
        // AutLXMLNodeList: Automation;  //TODO:probleme type automation
        // AutLXMLNodeList1: Automation;  //TODO:probleme type automation
        // AutLXMLNodeList3: Automation;  //TODO:probleme type automation
        BooLOrderInserted: Boolean;
        CodLCustomer: Code[20];
        CodLExternalDocNo: Code[20];
        CodLOrderNo: Code[20];
        DatLStartingDate: Date;
        InsLStream: InStream;
        i: Integer;
        IntLDay: Integer;
        IntLMonth: Integer;
        IntLYear: Integer;
        CstLOrderExist: Label 'Cette commande existe déjà';
        OusLStream: OutStream;
        TxtLItemPrice: Text[15];
        TxtLLineAmount: Text[15];
        TxtLQtty: Text[15];
        TxtLItemNo: Text[30];
        TxtLCommentHeaderPartial: Text[80];
        TxtLCommentlinePartial: Text[80];
        TxtLCommentHeader: Text[1024];
        TxtLCommentline: Text[1024];
    begin
        //>>WMS-FEMOT.001

        //**********************************************************************************************************//
        //                             Add order, by using Xml Management.                                          //
        //**********************************************************************************************************//
        RecPConnectorVal.CALCFIELDS(Blob);
        RecPConnectorVal.Blob.CREATEOUTSTREAM(OusLStream);
        // CLEAR(AutGXMLDom); //TODO:probleme type automation
        // CREATE(AutGXMLDom); //TODO:probleme type automation
        // AutGXMLDom.load(OusLStream); //TODO:probleme type automation
        CLEAR(BooLOrderInserted);
        CLEAR(DatLStartingDate);
        CLEAR(CodLOrderNo);
        CLEAR(CodLCustomer);
        CLEAR(CodLExternalDocNo);
        // AutLXMLNodeList := AutGXMLDom.selectNodes('/IDXMLSerial/Orders'); //TODO:probleme type automation begin
        // AutLXMLNode := AutLXMLNodeList.nextNode();
        // WHILE NOT ISCLEAR(AutLXMLNode) DO BEGIN // Orders Loop
        //     AutLXMLNodeList1 := AutLXMLNode.childNodes();
        //     AutLXMLNode := AutLXMLNodeList1.nextNode();
        //     WHILE NOT ISCLEAR(AutLXMLNode) DO BEGIN  // Orders Detail Loop
        //         CASE AutLXMLNode.nodeName OF
        //             'OrderNo':
        //                 BEGIN
        //                     IF AutLXMLNode.text <> '' THEN
        //                         CodLOrderNo := COPYSTR(AutLXMLNode.text, 1, 20);
        //                     RecLSalesHeaderBuffer.RESET();
        //                     RecLSalesHeaderBuffer.SETCURRENTKEY("Document Type", "Document No.");
        //                     RecLSalesHeaderBuffer.SETRANGE("Document Type", RecLSalesHeaderBuffer."Document Type"::Order);
        //                     RecLSalesHeaderBuffer.SETRANGE("Document No.", CodLOrderNo);
        //                     IF RecLSalesHeaderBuffer.FINDFIRST() THEN
        //                         ERROR(CstLOrderExist);
        //                 END;
        //             'CustomerNo':
        //                 IF AutLXMLNode.text <> '' THEN
        //                     CodLCustomer := COPYSTR(AutLXMLNode.text, 1, 20);
        //             'Reference':
        //                 IF AutLXMLNode.text <> '' THEN
        //                     CodLExternalDocNo := COPYSTR(AutLXMLNode.text, 1, 20);
        //             'Comment':
        //                 IF AutLXMLNode.text <> '' THEN
        //                     TxtLCommentHeader := COPYSTR(AutLXMLNode.text, 1, 750); // A mettre ds les commentaires de la comman
        //             'Date':
        //                 BEGIN
        //                     CLEAR(IntLYear);
        //                     CLEAR(IntLDay);
        //                     CLEAR(IntLMonth);
        //                     AutLXMLNodeList3 := AutLXMLNode.childNodes();
        //                     AutLXMLNode := AutLXMLNodeList3.nextNode();
        //                     WHILE NOT ISCLEAR(AutLXMLNode) DO BEGIN
        //                         CASE AutLXMLNode.nodeName OF
        //                             'Day':
        //                                 EVALUATE(IntLDay, AutLXMLNode.text);
        //                             'Month':
        //                                 EVALUATE(IntLMonth, AutLXMLNode.text);
        //                             'Year':
        //                                 EVALUATE(IntLYear, AutLXMLNode.text);
        //                         END;
        //                         AutLXMLNode := AutLXMLNodeList3.nextNode();
        //                     END;
        //                 END;

        //             'OrderLines':
        //                 BEGIN
        //                     IF NOT BooLOrderInserted THEN BEGIN
        //                         BooLOrderInserted := TRUE;
        //                         RecLSalesHeaderBuffer.GET(
        //                                        CduGBufferManagement.FctNewBufferLine(DATABASE::"PWD Sales Header Buffer", RecPConnectorVal, 1));
        //                         RecLSalesHeaderBuffer."Document Type" := RecLSalesHeaderBuffer."Document Type"::Order;
        //                         RecLSalesHeaderBuffer."Document No." := CodLOrderNo;
        //                         RecLSalesHeaderBuffer."Sell-to Customer No." := CodLCustomer;
        //                         RecLSalesHeaderBuffer."Posting Date" := FORMAT(DMY2DATE(IntLDay, IntLMonth, IntLYear));
        //                         RecLSalesHeaderBuffer."External Document No." := CodLExternalDocNo;
        //                         RecLSalesHeaderBuffer.MODIFY();

        //                         CLEAR(RecordRef);
        //                         RecordRef.GETTABLE(RecLSalesHeaderBuffer);
        //                         RecLPEBSalesHeaderBuffer.GET(CduGBufferManagement.FctDuplicateBuffer(
        //                                                DATABASE::"PWD PEB Sales Header Buffer", RecordRef));
        //                         //Placer les champs spécifiques PEB
        //                         RecLPEBSalesHeaderBuffer.MODIFY();

        //                         i := 1;
        //                         TxtLCommentHeaderPartial := COPYSTR(TxtLCommentHeader, 1, 80);
        //                         IF TxtLCommentHeaderPartial <> '' THEN
        //                             REPEAT
        //                                 RecLSalesCommentLineBuffer.GET(
        //                                           CduGBufferManagement.FctNewBufferLine(DATABASE::"PWD Sales Comment Line Buffer",
        //                                                                   RecPConnectorVal, 1));
        //                                 RecLSalesCommentLineBuffer."Document Type" := RecLSalesHeaderBuffer."Document Type";
        //                                 RecLSalesCommentLineBuffer."Document No." := RecLSalesHeaderBuffer."Document No.";
        //                                 RecLSalesCommentLineBuffer."Document Line No." := 0;
        //                                 RecLSalesCommentLineBuffer.Date := FORMAT(DMY2DATE(IntLDay, IntLMonth, IntLYear));
        //                                 RecLSalesCommentLineBuffer.Comment := TxtLCommentHeaderPartial;
        //                                 RecLSalesCommentLineBuffer.MODIFY();

        //                                 CLEAR(RecordRef);
        //                                 RecordRef.GETTABLE(RecLSalesCommentLineBuffer);
        //                                 RecLPEBSalesCommentLineBuffer.GET(CduGBufferManagement.FctDuplicateBuffer(
        //                                                        DATABASE::"PWD PEB Sales Comm Line Buffer", RecordRef));
        //                                 //Placer les champs spécifiques PEB
        //                                 RecLPEBSalesCommentLineBuffer.MODIFY();

        //                                 TxtLCommentHeaderPartial := COPYSTR(TxtLCommentHeader, (1 + i * 80), 80);
        //                                 i += 1;
        //                             UNTIL TxtLCommentHeaderPartial = '';
        //                     END;
        //                     AutLXMLNodeList3 := AutLXMLNode.childNodes();
        //                     AutLXMLNode := AutLXMLNodeList3.nextNode();
        //                     WHILE NOT ISCLEAR(AutLXMLNode) DO BEGIN
        //                         CASE AutLXMLNode.nodeName OF
        //                             'ItemNo':
        //                                 TxtLItemNo := AutLXMLNode.text;
        //                             'ItemPrice':
        //                                 TxtLItemPrice := AutLXMLNode.text;
        //                             'Comment':
        //                                 IF AutLXMLNode.text <> '' THEN
        //                                     TxtLCommentline := COPYSTR(AutLXMLNode.text, 1, 750);
        //                             'Quatity':
        //                                 TxtLQtty := AutLXMLNode.text;
        //                             'LineAmount':
        //                                 TxtLLineAmount := AutLXMLNode.text;
        //                         END;
        //                         AutLXMLNode := AutLXMLNodeList3.nextNode();
        //                     END;

        //                     RecLSalesLineBuffer.GET(
        //                             CduGBufferManagement.FctNewBufferLine(DATABASE::"PWD Sales Line Buffer", RecPConnectorVal
        //                                                                                  , 1));
        //                     RecLSalesLineBuffer."Document Type" := RecLSalesLineBuffer."Document Type"::Order;
        //                     RecLSalesLineBuffer."Document No." := RecLSalesHeaderBuffer."Document No.";
        //                     RecLSalesLineBuffer.Type := RecLSalesLineBuffer.Type::Item;
        //                     RecLSalesLineBuffer."No." := TxtLItemNo;
        //                     RecLSalesLineBuffer."Unit Price" := TxtLItemPrice;
        //                     RecLSalesLineBuffer.Quantity := TxtLQtty;
        //                     IF TxtLLineAmount <> '0.0000' THEN
        //                         RecLSalesLineBuffer."Line Amount" := TxtLLineAmount;
        //                     RecLSalesLineBuffer.MODIFY();

        //                     CLEAR(RecordRef);
        //                     RecordRef.GETTABLE(RecLSalesLineBuffer);
        //                     RecLPEBSalesLineBuffer.GET(CduGBufferManagement.FctDuplicateBuffer(
        //                                            DATABASE::"PWD PEB Sales Line Buffer", RecordRef));
        //                     //Placer les champs spécifiques PEB
        //                     RecLPEBSalesLineBuffer.MODIFY();

        //                     i := 1;
        //                     TxtLCommentlinePartial := COPYSTR(TxtLCommentline, 1, 80);
        //                     IF TxtLCommentlinePartial <> '' THEN
        //                         REPEAT
        //                             RecLSalesCommentLineBuffer.GET(
        //                                     CduGBufferManagement.FctNewBufferLine(DATABASE::"PWD Sales Comment Line Buffer", RecPConnectorVal
        //                                                                            , 1));
        //                             RecLSalesCommentLineBuffer."Document Type" := RecLSalesLineBuffer."Document Type";
        //                             RecLSalesCommentLineBuffer."Document No." := RecLSalesLineBuffer."Document No.";
        //                             RecLSalesCommentLineBuffer."Document Line No." := RecLSalesLineBuffer."Entry No.";
        //                             RecLSalesCommentLineBuffer.Date := FORMAT(DMY2DATE(IntLDay, IntLMonth, IntLYear));
        //                             RecLSalesCommentLineBuffer.Comment := TxtLCommentlinePartial;
        //                             RecLSalesCommentLineBuffer.MODIFY();

        //                             CLEAR(RecordRef);
        //                             RecordRef.GETTABLE(RecLSalesCommentLineBuffer);
        //                             RecLPEBSalesCommentLineBuffer.GET(CduGBufferManagement.FctDuplicateBuffer(
        //                                                    DATABASE::"PWD PEB Sales Comm Line Buffer", RecordRef));
        //                             //Placer les champs spécifiques PEB
        //                             RecLPEBSalesCommentLineBuffer.MODIFY();

        //                             TxtLCommentlinePartial := COPYSTR(TxtLCommentline, (1 + i * 80), 80);
        //                             i += 1;
        //                         UNTIL TxtLCommentlinePartial = '';
        //                 END;
        //         END;
        //         AutLXMLNode := AutLXMLNodeList1.nextNode();
        //     END;  //End Detail Loop
        //     AutLXMLNode := AutLXMLNodeList.nextNode(); //TODO:probleme type automation end
        // END;  //End Orders Loop

        IF RecLSalesHeaderBuffer."Entry No." <> 0 THEN BEGIN

            CduGBufferManagement.FctCreateSalesOrder(RecLSalesHeaderBuffer);

            CLEAR(RecordRef);
            RecordRef.OPEN(DATABASE::"Sales Header", FALSE, COMPANYNAME);
            RecordRef.GET(RecLSalesHeaderBuffer."RecordID Created");
            RecordRef.SETTABLE(RecLSalesHeader);
            RecLSalesHeader.SETRECFILTER();

            CLEAR(OusLStream);
            RecLSendingMessage.RESET();
            RecLSendingMessage.SETRANGE("Partner Code", RecPConnectorVal."Partner Code");
            RecLSendingMessage.SETRANGE("Function", RecPConnectorVal."Function");
            RecLSendingMessage.FINDFIRST();
            // CduGConnectBufMgtExport.FctCreateXml(RecLSalesHeader.GETVIEW(), RecLSendingMessage, RecLTempBlob, TRUE); //TODO: probleme Codeunit "Temp Blob"
            //TODO:'Codeunit "Temp Blob"' does not contain a definition for 'CALCFIELDS'
            //RecLTempBlob.CALCFIELDS(Blob);
            // IF RecLTempBlob.HASVALUE() THEN BEGIN  //TODO: probleme Codeunit "Temp Blob" begin
            //     RecLTempBlob.CREATEINSTREAM(InsLStream);
            //     CduGBufferManagement.FctCreateBufferValues(InsLStream, RecPConnectorVal."Partner Code", RecPConnectorVal."File Name",
            //                                                RecPConnectorVal."Function", RecPConnectorVal."File format",
            //                                                RecPConnectorVal.Separator,
            //                                                RecPConnectorVal.Direction::Export, RecPConnectorVal."Entry No.",
            //                                                RecPConnectorVal."Message Code")
            // END
            // ELSE
            //     ERROR(TxtGError); //TODO: probleme Codeunit "Temp Blob" end
        END;
        //<<WMS-FEMOT.001
    end;


    procedure FctUpdateSalesHeader(var RecPSalesHeader: Record "Sales Header"; var IntPEntryBufferNo: Integer)
    var
        RecLPEBSalesHeaderBuffer: Record "PWD PEB Sales Header Buffer";
    begin
        //>>WMS-FEMOT.001
        IF RecLPEBSalesHeaderBuffer.GET(IntPEntryBufferNo) THEN;
        //Placer les champs spécifiques PEB
        //<<WMS-FEMOT.001
    end;


    procedure FctUpdateSalesLine(var RecPSalesLine: Record "Sales Line"; var IntPEntryBufferNo: Integer)
    var
        RecLPEBSalesLineBuffer: Record "PWD PEB Sales Line Buffer";
    begin
        //>>WMS-FEMOT.001
        IF RecLPEBSalesLineBuffer.GET(IntPEntryBufferNo) THEN
            ;
        //Placer les champs spécifiques PEB
        //<<WMS-FEMOT.001
    end;


    procedure FctUpdateSalesCommentLine(var RecPSalesCommentLine: Record "Sales Comment Line"; var IntPEntryBufferNo: Integer)
    var
        RecLPEBSalesCommentLineBuffer: Record "PWD PEB Sales Comm Line Buffer";
    begin
        //>>WMS-FEMOT.001
        IF RecLPEBSalesCommentLineBuffer.GET(IntPEntryBufferNo) THEN
            ;
        //Placer les champs spécifiques PEB
        //<<WMS-FEMOT.001
    end;


    procedure FctCreateCustomer(var RecPConnectorVal: Record "PWD Connector Values")
    var
        RecLCustomer: Record Customer;
        RecLSendingMessage: Record "PWD Connector Messages";
        RecLCustomerBuffer: Record "PWD Customer Buffer";
        RecLPEBCustomerBuffer: Record "PWD PEB Customer Buffer";
        // RecLTempBlob: Codeunit "Temp Blob"; //TODO: probleme Codeunit "Temp Blob"
        RecordRef: RecordRef;
        InsLStream: InStream;
        StrLStreamOut: OutStream;
    begin
        //>>WMS-FEMOT.001
        //**********************************************************************************************************//
        //                             Create a customer, by using Xml Management.                                  //
        //                                                                                                          //
        // Parameters:                                                                                              //
        // TxtGData[1]: Name                                                                                        //
        // TxtGData[2]: Name 2                                                                                      //
        // TxtGData[3]: Address                                                                                     //
        // TxtGData[4]: City                                                                                        //
        // TxtGData[5]: E-mail                                                                                      //
        // TxtGData[6]: Phone No.                                                                                   //
        // TxtGData[7]: Address 2                                                                                   //
        // TxtGData[8]: Post Code                                                                                   //
        // TxtGData[9]: Country/Region Code                                                                         //
        //**********************************************************************************************************//

        RecPConnectorVal.CALCFIELDS(Blob);
        RecPConnectorVal.Blob.CREATEOUTSTREAM(StrLStreamOut);
        // CLEAR(AutGXMLDom);  //TODO: probleme type automation
        // CREATE(AutGXMLDom);//TODO: probleme type automation
        // AutGXMLDom.load(StrLStreamOut);//TODO: probleme type automation

        FctParseData();

        RecLSendingMessage.RESET();
        RecLSendingMessage.SETRANGE("Partner Code", RecPConnectorVal."Partner Code");
        RecLSendingMessage.SETRANGE("Function", RecPConnectorVal."Function");
        RecLSendingMessage.FINDFIRST();

        RecLCustomerBuffer.GET(
                       CduGBufferManagement.FctNewBufferLine(DATABASE::"PWD Customer Buffer", RecPConnectorVal, 1));
        RecLCustomerBuffer.Name := TxtGData[1];
        RecLCustomerBuffer."Name 2" := TxtGData[2];
        RecLCustomerBuffer.Address := TxtGData[3];
        RecLCustomerBuffer."Address 2" := TxtGData[7];
        RecLCustomerBuffer."Post Code" := TxtGData[8];
        RecLCustomerBuffer.City := TxtGData[4];
        RecLCustomerBuffer."Country/Region Code" := TxtGData[9];
        RecLCustomerBuffer."E-Mail" := TxtGData[5];
        RecLCustomerBuffer."Phone No." := TxtGData[6];
        RecLCustomerBuffer.MODIFY();

        CLEAR(RecordRef);
        RecordRef.GETTABLE(RecLCustomerBuffer);
        RecLPEBCustomerBuffer.GET(CduGBufferManagement.FctDuplicateBuffer(DATABASE::"PWD PEB Customer Buffer", RecordRef));
        //Placer les champs spécifiques PEB
        RecLPEBCustomerBuffer.MODIFY();

        IF RecLCustomerBuffer."Entry No." <> 0 THEN BEGIN
            CduGBufferManagement.FctCreateCustomer(RecLCustomerBuffer);

            CLEAR(RecordRef);
            RecordRef.OPEN(DATABASE::Customer, FALSE, COMPANYNAME);
            RecordRef.GET(RecLCustomerBuffer."RecordID Created");
            RecordRef.SETTABLE(RecLCustomer);
            RecLCustomer.SETRECFILTER();

            IF RecLCustomer.FINDFIRST() THEN BEGIN
                // CduGConnectBufMgtExport.FctCreateXml(RecLCustomer.GETVIEW(), RecLSendingMessage, RecLTempBlob, TRUE); //TODO: probleme Codeunit "Temp Blob"
                //TODO:'Codeunit "Temp Blob"' does not contain a definition for 'CALCFIELDS'
                //RecLTempBlob.CALCFIELDS(Blob);
                // IF RecLTempBlob.HASVALUE() THEN BEGIN //TODO: probleme Codeunit "Temp Blob" begin
                //     RecLTempBlob.CREATEINSTREAM(InsLStream);
                //     CduGBufferManagement.FctCreateBufferValues(InsLStream, RecPConnectorVal."Partner Code", RecPConnectorVal."File Name",
                //                                               RecPConnectorVal."Function", RecPConnectorVal."File format",
                //                                               RecPConnectorVal.Separator,
                //                                               RecPConnectorVal.Direction::Export, RecPConnectorVal."Entry No.",
                //                                               RecPConnectorVal."Message Code");
                // END
                // ELSE
                //     ERROR(TxtGError); //TODO: probleme Codeunit "Temp Blob" end
            END
            ELSE
                ERROR(TxtGError);
        END;
        //<<WMS-FEMOT.001
    end;


    procedure FctUpdateCustomer(var RecPCustomer: Record Customer; var IntPEntryBufferNo: Integer)
    var
        RecLPEBCustomerBuffer: Record "PWD PEB Customer Buffer";
    begin
        //>>WMS-FEMOT.001
        IF RecLPEBCustomerBuffer.GET(IntPEntryBufferNo) THEN
            ;
        //Placer les champs spécifiques PEB
        //<<WMS-FEMOT.001
    end;


    procedure FctUpdateReceiptLine(var RecPPurchaseLine: Record "Purchase Line"; var IntPEntryBufferNo: Integer)
    var
        RecLPEBReceiptLineBuffer: Record "PWD PEB Receipt Line Buffer";
    begin
        //>>WMS-FE007_15.001
        IF RecLPEBReceiptLineBuffer.GET(IntPEntryBufferNo) THEN
            ;
        //Placer les champs spécifiques PEB
        //<<WMS-FE007_15.001
    end;


    procedure FctUpdateShipmentLine(var RecPSalesLine: Record "Sales Line"; var IntPEntryBufferNo: Integer)
    var
        RecLPEBSalesLineBuffer: Record "PWD PEB Sales Line Buffer";
    begin
        //>>WMS-FE008_15.001
        IF RecLPEBSalesLineBuffer.GET(IntPEntryBufferNo) THEN
            ;
        //Placer les champs spécifiques PEB
        //<<WMS-FE008_15.001
    end;

    // procedure FctGetHeaderArchiveXml(RecPConnectorVal: Record "PWD Connector Values"; TxtPValue: Text[250]; var RecLTempBlob: Codeunit "Temp Blob") //TODO: probleme Codeunit "Temp Blob" begin
    // var
    //     RecLSendingMessage: Record "PWD Connector Messages";
    //     RecLSalesHeaderArchive: Record "Sales Header Archive";
    // begin
    //     //**********************************************************************************************************//
    //     //                                           Return Invoice Header                                          //
    //     //                                                                                                          //
    //     // Parameters:                                                                                              //
    //     // RecPconnectorValue: buffer Table                                                                         //
    //     // TxtPValue: Order No.                                                                                     //
    //     // RecLTempBlob: Blob used temporary                                                                        //
    //     //**********************************************************************************************************//

    //     //>>FE_ProdConnect.002
    //     RecLSalesHeaderArchive.SETCURRENTKEY("Document Type", "No.", "Doc. No. Occurrence", "Version No.");
    //     RecLSalesHeaderArchive.SETRANGE("Document Type", RecLSalesHeaderArchive."Document Type"::Order);
    //     RecLSalesHeaderArchive.SETRANGE("No.", TxtPValue);
    //     IF NOT RecLSalesHeaderArchive.ISEMPTY THEN BEGIN
    //         RecLSalesHeaderArchive.FINDLAST();
    //         RecLSalesHeaderArchive.SETRANGE("Doc. No. Occurrence", RecLSalesHeaderArchive."Doc. No. Occurrence");
    //         RecLSalesHeaderArchive.SETRANGE("Version No.", RecLSalesHeaderArchive."Version No.");
    //         RecLSendingMessage.RESET();
    //         RecLSendingMessage.SETRANGE("Partner Code", RecPConnectorVal."Partner Code");
    //         RecLSendingMessage.SETRANGE("Function", RecPConnectorVal."Function");
    //         RecLSendingMessage.SETRANGE("Table ID", DATABASE::"Sales Header Archive");
    //         RecLSendingMessage.FINDFIRST();
    //         CduGConnectBufMgtExport.FctCreateXml(RecLSalesHeaderArchive.GETVIEW(), RecLSendingMessage, RecLTempBlob, TRUE);
    //     END
    //     ELSE
    //         ERROR(TxtGError);  //TODO: probleme Codeunit "Temp Blob" end
    //     //<<FE_ProdConnect.002
    // end;


    // procedure FctGetLineArchiveXml(RecPConnectorVal: Record "PWD Connector Values"; TxtPValue: Text[250]; var RecLTempBlob: Codeunit "Temp Blob") //TODO: probleme Codeunit "Temp Blob" begin
    // var
    //     RecLSendingMessage: Record "PWD Connector Messages";
    //     RecLSalesHeaderArchive: Record "Sales Header Archive";
    //     RecLSalesLineArchive: Record "Sales Line Archive";
    // begin
    //     //**********************************************************************************************************//
    //     //                                           Return Invoice Lines                                           //
    //     //                                                                                                          //
    //     // Parameters:                                                                                              //
    //     // RecPconnectorValue: buffer Table                                                                         //
    //     // TxtPValue: Order No.                                                                                     //
    //     // RecLTempBlob: Blob used temporary                                                                        //
    //     //**********************************************************************************************************//

    //     //>>FE_ProdConnect.002
    //     RecLSalesHeaderArchive.SETCURRENTKEY("Document Type", "No.", "Doc. No. Occurrence", "Version No.");
    //     RecLSalesHeaderArchive.SETRANGE("Document Type", RecLSalesHeaderArchive."Document Type"::Order);
    //     RecLSalesHeaderArchive.SETRANGE("No.", TxtPValue);
    //     IF NOT RecLSalesHeaderArchive.ISEMPTY THEN BEGIN
    //         RecLSalesHeaderArchive.FINDLAST();
    //         RecLSalesLineArchive.SETRANGE("Document Type", RecLSalesLineArchive."Document Type"::Order);
    //         RecLSalesLineArchive.SETRANGE("Document No.", RecLSalesHeaderArchive."No.");
    //         RecLSalesLineArchive.SETRANGE("Doc. No. Occurrence", RecLSalesHeaderArchive."Doc. No. Occurrence");
    //         RecLSalesLineArchive.SETRANGE("Version No.", RecLSalesHeaderArchive."Version No.");
    //         IF NOT RecLSalesLineArchive.ISEMPTY THEN BEGIN
    //             RecLSendingMessage.RESET();
    //             RecLSendingMessage.SETRANGE("Partner Code", RecPConnectorVal."Partner Code");
    //             RecLSendingMessage.SETRANGE("Function", RecPConnectorVal."Function");
    //             RecLSendingMessage.SETRANGE("Table ID", DATABASE::"Sales Line Archive");
    //             RecLSendingMessage.FINDFIRST();
    //             CduGConnectBufMgtExport.FctCreateXml(RecLSalesLineArchive.GETVIEW(), RecLSendingMessage, RecLTempBlob, FALSE);
    //         END;
    //     END; 
    //<<FE_ProdConnect.002
    // end; //TODO: probleme Codeunit "Temp Blob" end
}

