xmlport 8073327 "PWD Delete Prod. Order Line"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.06
    // OSYS-Int001.001:GR 18/10/2011   Connector integration
    //                                   - Create Object
    // 
    // +----------------------------------------------------------------------------------------------------------------+


    schema
    {
        textelement(OSYS)
        {
            MinOccurs = Zero;
            tableelement("PWD Deleted Prod. Order Line"; "PWD Deleted Prod. Order Line")
            {
                MinOccurs = Zero;
                XmlName = 'T_DeletedProdOrderLine';
                UseTemporary = true;
                textelement(F_Prod_Order_No)
                {

                    trigger OnBeforePassVariable()
                    begin
                        F_Prod_Order_No := "PWD Deleted Prod. Order Line"."Prod. Order No." + RecGOSYSSetup."Separator Character" +
                                            Format("PWD Deleted Prod. Order Line"."Line No.");
                    end;
                }
                textelement(F_Item_No)
                {

                    trigger OnBeforePassVariable()
                    begin
                        if "PWD Deleted Prod. Order Line"."Variant Code" <> '' then
                            F_Item_No := "PWD Deleted Prod. Order Line"."Item No." + RecGOSYSSetup."Separator Character" +
                            "PWD Deleted Prod. Order Line"."Variant Code"
                        else
                            F_Item_No := "PWD Deleted Prod. Order Line"."Item No.";
                    end;
                }
                textelement(F_Description)
                {

                    trigger OnBeforePassVariable()
                    begin
                        F_Description := "PWD Deleted Prod. Order Line".Description;
                    end;
                }
                textelement(F_Status)
                {

                    trigger OnBeforePassVariable()
                    begin
                        IntGTempField := 5;
                        F_Status := Format(IntGTempField);
                    end;
                }
                textelement(F_Quantity)
                {

                    trigger OnBeforePassVariable()
                    begin
                        F_Quantity := Format("PWD Deleted Prod. Order Line".Quantity, 0, 2);
                    end;
                }
                textelement(F_UnitofMeasure)
                {

                    trigger OnBeforePassVariable()
                    begin
                        F_UnitofMeasure := "PWD Deleted Prod. Order Line"."Unit of Measure Code";
                    end;
                }
                textelement(F_Delai)
                {

                    trigger OnBeforePassVariable()
                    begin
                        F_Delai := Format("PWD Deleted Prod. Order Line"."Due Date");
                    end;
                }
                textelement(F_ProductionBOMNo)
                {

                    trigger OnBeforePassVariable()
                    begin
                        F_ProductionBOMNo := "PWD Deleted Prod. Order Line"."Production BOM No.";
                    end;
                }
                textelement(F_ProductionBOMVersionCode)
                {

                    trigger OnBeforePassVariable()
                    begin
                        F_ProductionBOMVersionCode := "PWD Deleted Prod. Order Line"."Production BOM Version Code";
                    end;
                }
                textelement(F_RoutingNo)
                {

                    trigger OnBeforePassVariable()
                    begin
                        F_RoutingNo := "PWD Deleted Prod. Order Line"."Routing No.";
                    end;
                }
                textelement(F_RoutingVersionCode)
                {

                    trigger OnBeforePassVariable()
                    begin
                        F_RoutingVersionCode := "PWD Deleted Prod. Order Line"."Routing Version Code";
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    RecLDeletedProdOrderLine: Record "PWD Deleted Prod. Order Line";
                begin
                    RecLDeletedProdOrderLine.Get("PWD Deleted Prod. Order Line".Status,
                                        "PWD Deleted Prod. Order Line"."Prod. Order No.", "PWD Deleted Prod. Order Line"."Line No.");
                    RecLDeletedProdOrderLine."Send to OSYS (Deleted)" := true;
                    RecLDeletedProdOrderLine.Modify;
                end;

                trigger OnPreXmlItem()
                begin
                    FctProdOrderLine("PWD Deleted Prod. Order Line");
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPreXmlPort()
    begin
        RecGOSYSSetup.Get();

        FctInitXML();
    end;

    var
        RecGOSYSSetup: Record "PWD OSYS Setup";
        CodGConnectorPartner: Code[20];
        CduGConnectorBufferMgtExport: Codeunit "Connector Buffer Mgt Export";
        IntGTempField: Integer;


    procedure FctDefinePartner(var RecPConnectorMes: Record "PWD Connector Messages")
    begin
        CodGConnectorPartner := RecPConnectorMes."Partner Code";
    end;


    procedure FctCheckValues(var RecPDeletedProdOrderLine: Record "PWD Deleted Prod. Order Line"; BooPInsertValue: Boolean): Boolean
    var
        RecordRef: RecordRef;
        RecordRefTemp: RecordRef;
        BooLError: Boolean;
    begin
        BooLError := false;

        RecordRef.GetTable(RecPDeletedProdOrderLine);

        if CduGConnectorBufferMgtExport.FctCheckFields(RecordRef) then
            BooLError := true;

        if BooPInsertValue then begin
            RecordRefTemp.GetTable("PWD Deleted Prod. Order Line");
            RecordRefTemp.Init;
            CduGConnectorBufferMgtExport.FctTransferFields(RecordRef, RecordRefTemp);
            RecordRefTemp.Insert;
        end;

        exit(BooLError);
    end;


    procedure FctInitXML(): Boolean
    var
        RecLDeletedProdOrderLine: Record "PWD Deleted Prod. Order Line";
    begin
        "PWD Deleted Prod. Order Line".DeleteAll;

        CduGConnectorBufferMgtExport.FctInitValidateField(CodGConnectorPartner, 0);

        FctProdOrderLine(RecLDeletedProdOrderLine);
        //>>DEBUT Parcours des OF
        if not RecLDeletedProdOrderLine.IsEmpty then begin
            RecLDeletedProdOrderLine.FindSet;
            repeat
                if not FctCheckValues(RecLDeletedProdOrderLine, false) then
                    FctCheckValues(RecLDeletedProdOrderLine, true);
            until RecLDeletedProdOrderLine.Next = 0;
        end;
        //<<FIN Parcours des OF

        exit(not "PWD Deleted Prod. Order Line".IsEmpty);
    end;


    procedure FctProdOrderLine(var RecPDeletedProdOrderLine: Record "PWD Deleted Prod. Order Line")
    begin
        //Filtre Ligne Projet
        RecPDeletedProdOrderLine.SetCurrentKey(Status, "Send to OSYS (Released)", "Send to OSYS (Deleted)");
        RecPDeletedProdOrderLine.SetRange(Status, RecPDeletedProdOrderLine.Status::Released);
        RecPDeletedProdOrderLine.SetRange("Send to OSYS (Released)", true);
        RecPDeletedProdOrderLine.SetRange("Send to OSYS (Finished)", false);
        RecPDeletedProdOrderLine.SetRange("Send to OSYS (Deleted)", false);
    end;
}

