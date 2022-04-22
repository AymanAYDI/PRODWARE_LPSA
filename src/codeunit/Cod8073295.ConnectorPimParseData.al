codeunit 8073295 "PWD Connector Pim Parse Data"
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
    // 
    // //>>ProdConnect1.5
    // WMS-FEMOT.001:GR 04/07/2001 :  Connector integration
    //                                   - C\AL in :  FctGetCustomerWithSep
    // 
    // +----------------------------------------------------------------------------------------------------------------+

    TableNo = "PWD Connector Values";

    trigger OnRun()
    var
    //TODO: Table 'TempBlob' is removed
        RecLTempBlob: Record TempBlob temporary;
        RecLPartnerConnector: Record "PWD Partner Connector";
        RecLConnectorValues: Record "PWD Connector Values";
        BigTLToReturn: BigText;
        //TODO: Codeunit 'Buffer Management' is missing
        CduLBufferMgt: Codeunit "Buffer Management";
        InLStream: InStream;
        CduLFileManagement: Codeunit "File Management";
        TxtLFile: Text[1024];
        BooLResult: Boolean;
        RecLConnectorMessages: Record "PWD Connector Messages";
    begin
        Clear(BigTLToReturn);
        Clear(IntGSequenceNo);
        RecLPartnerConnector.Get("Partner Code");
        RecLConnectorMessages.Get("Partner Code", "Message Code", Direction);
        RecLConnectorMessages.TestField(Path);

        case "Function" of
            'GETCUSTOMER':
                begin
                    FctGetCustomerWithSep('', RecLConnectorMessages, RecLTempBlob);
                    RecLPartnerConnector."Data Format" := RecLPartnerConnector."Data Format"::"with separator";
                end;
            else
                case RecLPartnerConnector."Data Format" of
                    RecLPartnerConnector."Data Format"::Xml:
                        CduGConBufMgtExport.FctCreateXml('', RecLConnectorMessages, RecLTempBlob, true);
                    RecLPartnerConnector."Data Format"::"with separator":
                        CduGConBufMgtExport.FctCreateSeparator('', RecLConnectorMessages, RecLTempBlob);
                end;

        end;

        RecLTempBlob.CalcFields(Blob);
        if RecLTempBlob.Blob.HasValue then begin
            RecLTempBlob.Blob.CreateInStream(InLStream);
            IntGSequenceNo := CduLBufferMgt.FctCreateBufferValues(InLStream, "Partner Code", '',
                                                                  RecLConnectorMessages.Code, RecLPartnerConnector."Data Format",
                                                                  RecLPartnerConnector.Separator, 1, "Entry No.", RecLConnectorMessages.Code);
            TxtLFile := CduGConBufMgtExport.FctMakeFileName(
                                          RecLConnectorMessages.Path,
                                          RecLConnectorMessages."Partner Code",
                                          IntGSequenceNo, RecLPartnerConnector,
                                          //>>WMS-FEMOT.002
                                          RecLConnectorMessages."File Name value",
                                          RecLConnectorMessages."File Name with Society Code",
                                          RecLConnectorMessages."File Name with Date",
                                          RecLConnectorMessages."File Name with Time",
                                          //>>WMS-EBL1-003.001
                                          RecLConnectorMessages."File extension"
                                          //<<WMS-EBL1-003.001
                                          );
            //<<WMS-FEMOT.002


            Clear(InLStream);
            RecLConnectorValues.Get(IntGSequenceNo);
            RecLConnectorValues."File Name" := CopyStr(TxtLFile, 1, 250);
            RecLConnectorValues.Modify();
            RecLConnectorValues.CalcFields(Blob);
            RecLConnectorValues.Blob.CreateInStream(InLStream);
            BooLResult := CduLFileManagement.FctbTransformBlobToFile(TxtLFile, InLStream, "Partner Code",
                                                                     IntGSequenceNo, OptGFlowType::"Export Connector");
            CduLBufferMgt.FctArchiveBufferValues(RecLConnectorValues, BooLResult);
        end;
    end;

    var
        CduGConBufMgtExport: Codeunit "Connector Buffer Mgt Export";
        OptGFlowType: Option " ","Import Connector","Export Connector";
        IntGSequenceNo: Integer;


    procedure FctGetCustomerWithSep(TxtPFilters: Text[1024]; RecPSendingMessage: Record "PWD Connector Messages"; var RecPTempBlob: Record TempBlob temporary)
    var
        RecLPartnerConnector: Record "PWD Partner Connector";
        ChrL10: Char;
        ChrL13: Char;
        BigTLBigTextToReturn: BigText;
        OusLStream: OutStream;
        RecLCustomer: Record Customer;
        RecLBillToCust: Record Customer;
        RecLShiptoAddress: Record "Ship-to Address";
        IntLShipNber: Integer;
        RecLRef: RecordRef;
    begin
        //**********************************************************************************************************//
        //                                  Create Customer file with Separator in blob field                       //
        //**********************************************************************************************************//


        RecLCustomer.Reset();
        ChrL10 := 10;
        ChrL13 := 13;
        if RecLPartnerConnector.Get(RecPSendingMessage."Partner Code") then begin
            if TxtPFilters <> '' then
                RecLCustomer.SetView(TxtPFilters);


            //>>WMS-FEMOT.001
            if RecPSendingMessage."Export Option" = RecPSendingMessage."Export Option"::Partial then begin
                Clear(RecLRef);
                RecLRef.Open(RecPSendingMessage."Table ID");
                CduGConBufMgtExport.FctSetExportDateFilter(RecPSendingMessage, RecLRef);
                if RecLRef.GetView() <> '' then
                    RecLCustomer.SetView(RecLRef.GetView());
                RecLRef.Close();
            end;
            //<<WMS-FEMOT.001

            RecLPartnerConnector.TestField(Separator);
            if not RecLCustomer.IsEmpty then begin
                RecLCustomer.FindSet();
                repeat
                    //adresse du client
                    BigTLBigTextToReturn.AddText(Format(RecLCustomer."No."));
                    BigTLBigTextToReturn.AddText(Format(RecLPartnerConnector.Separator));
                    BigTLBigTextToReturn.AddText('C');
                    BigTLBigTextToReturn.AddText(Format(RecLPartnerConnector.Separator));
                    BigTLBigTextToReturn.AddText(Format(RecLCustomer.Name));
                    BigTLBigTextToReturn.AddText(Format(RecLPartnerConnector.Separator));
                    BigTLBigTextToReturn.AddText(Format(RecLCustomer."Name 2"));
                    BigTLBigTextToReturn.AddText(Format(RecLPartnerConnector.Separator));
                    BigTLBigTextToReturn.AddText(Format(RecLCustomer."E-Mail"));
                    BigTLBigTextToReturn.AddText(Format(RecLPartnerConnector.Separator));
                    BigTLBigTextToReturn.AddText(Format(RecLCustomer."Phone No."));
                    BigTLBigTextToReturn.AddText(Format(RecLPartnerConnector.Separator));
                    BigTLBigTextToReturn.AddText(Format(RecLCustomer.Address));
                    BigTLBigTextToReturn.AddText(Format(RecLPartnerConnector.Separator));
                    BigTLBigTextToReturn.AddText(Format(RecLCustomer."Address 2"));
                    BigTLBigTextToReturn.AddText(Format(RecLPartnerConnector.Separator));
                    BigTLBigTextToReturn.AddText(Format(RecLCustomer."Post Code"));
                    BigTLBigTextToReturn.AddText(Format(RecLPartnerConnector.Separator));
                    BigTLBigTextToReturn.AddText(Format(RecLCustomer.City));
                    BigTLBigTextToReturn.AddText(Format(RecLPartnerConnector.Separator));
                    BigTLBigTextToReturn.AddText(Format(RecLCustomer."Country/Region Code"));
                    BigTLBigTextToReturn.AddText(Format(RecLPartnerConnector.Separator));
                    BigTLBigTextToReturn.AddText(Format(ChrL13) + Format(ChrL10));

                    //adresse de livraison
                    RecLShiptoAddress.Reset();
                    RecLShiptoAddress.SetRange("Customer No.", RecLCustomer."No.");
                    IntLShipNber := 1;
                    if RecLShiptoAddress.FindFirst() then
                        repeat
                            BigTLBigTextToReturn.AddText(Format(RecLCustomer."No."));
                            BigTLBigTextToReturn.AddText(Format(RecLPartnerConnector.Separator));
                            BigTLBigTextToReturn.AddText('L' + Format(IntLShipNber));
                            BigTLBigTextToReturn.AddText(Format(RecLPartnerConnector.Separator));
                            BigTLBigTextToReturn.AddText(Format(RecLShiptoAddress.Name));
                            BigTLBigTextToReturn.AddText(Format(RecLPartnerConnector.Separator));
                            BigTLBigTextToReturn.AddText(Format(RecLShiptoAddress."Name 2"));
                            BigTLBigTextToReturn.AddText(Format(RecLPartnerConnector.Separator));
                            BigTLBigTextToReturn.AddText(Format(RecLShiptoAddress."E-Mail"));
                            BigTLBigTextToReturn.AddText(Format(RecLPartnerConnector.Separator));
                            BigTLBigTextToReturn.AddText(Format(RecLShiptoAddress."Phone No."));
                            BigTLBigTextToReturn.AddText(Format(RecLPartnerConnector.Separator));
                            BigTLBigTextToReturn.AddText(Format(RecLShiptoAddress.Address));
                            BigTLBigTextToReturn.AddText(Format(RecLPartnerConnector.Separator));
                            BigTLBigTextToReturn.AddText(Format(RecLShiptoAddress."Address 2"));
                            BigTLBigTextToReturn.AddText(Format(RecLPartnerConnector.Separator));
                            BigTLBigTextToReturn.AddText(Format(RecLShiptoAddress."Post Code"));
                            BigTLBigTextToReturn.AddText(Format(RecLPartnerConnector.Separator));
                            BigTLBigTextToReturn.AddText(Format(RecLShiptoAddress.City));
                            BigTLBigTextToReturn.AddText(Format(RecLPartnerConnector.Separator));
                            BigTLBigTextToReturn.AddText(Format(RecLShiptoAddress."Country/Region Code"));
                            BigTLBigTextToReturn.AddText(Format(RecLPartnerConnector.Separator));
                            BigTLBigTextToReturn.AddText(Format(ChrL13) + Format(ChrL10));
                            IntLShipNber += 1;
                        until RecLShiptoAddress.Next() = 0;

                    //adresse du client facturé
                    if RecLCustomer."Bill-to Customer No." <> '' then
                        if RecLBillToCust.Get(RecLCustomer."Bill-to Customer No.") then begin
                            BigTLBigTextToReturn.AddText(Format(RecLCustomer."No."));
                            BigTLBigTextToReturn.AddText(Format(RecLPartnerConnector.Separator));
                            BigTLBigTextToReturn.AddText('F');
                            BigTLBigTextToReturn.AddText(Format(RecLPartnerConnector.Separator));
                            BigTLBigTextToReturn.AddText(Format(RecLBillToCust.Name));
                            BigTLBigTextToReturn.AddText(Format(RecLPartnerConnector.Separator));
                            BigTLBigTextToReturn.AddText(Format(RecLBillToCust."Name 2"));
                            BigTLBigTextToReturn.AddText(Format(RecLPartnerConnector.Separator));
                            BigTLBigTextToReturn.AddText(Format(RecLBillToCust."E-Mail"));
                            BigTLBigTextToReturn.AddText(Format(RecLPartnerConnector.Separator));
                            BigTLBigTextToReturn.AddText(Format(RecLBillToCust."Phone No."));
                            BigTLBigTextToReturn.AddText(Format(RecLPartnerConnector.Separator));
                            BigTLBigTextToReturn.AddText(Format(RecLBillToCust.Address));
                            BigTLBigTextToReturn.AddText(Format(RecLPartnerConnector.Separator));
                            BigTLBigTextToReturn.AddText(Format(RecLBillToCust."Address 2"));
                            BigTLBigTextToReturn.AddText(Format(RecLPartnerConnector.Separator));
                            BigTLBigTextToReturn.AddText(Format(RecLBillToCust."Post Code"));
                            BigTLBigTextToReturn.AddText(Format(RecLPartnerConnector.Separator));
                            BigTLBigTextToReturn.AddText(Format(RecLBillToCust.City));
                            BigTLBigTextToReturn.AddText(Format(RecLPartnerConnector.Separator));
                            BigTLBigTextToReturn.AddText(Format(RecLBillToCust."Country/Region Code"));
                            BigTLBigTextToReturn.AddText(Format(RecLPartnerConnector.Separator));
                            BigTLBigTextToReturn.AddText(Format(RecLBillToCust."No."));
                            BigTLBigTextToReturn.AddText(Format(ChrL13) + Format(ChrL10));
                        end;
                until RecLCustomer.Next() = 0;
            end;
        end;

        RecPTempBlob.Blob.CreateOutStream(OusLStream);
        BigTLBigTextToReturn.Write(OusLStream);
    end;
}

