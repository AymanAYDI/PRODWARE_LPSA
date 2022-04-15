xmlport 50000 "PWD Possible Items Export"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise                                                                                      |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.06
    // FE_LAPRIERRETTE_GP0004.001 :GR  23/05/13 Create
    // 
    // +----------------------------------------------------------------------------------------------------------------+

    Encoding = UTF8;

    schema
    {
        textelement(OSYS)
        {
            tableelement(recgpossibleitems; "PWD Possible Items")
            {
                XmlName = 'PossibleItems';
                fieldelement(Item; RecGPossibleItems."Item Code")
                {
                }
                fieldelement(WorkCenter; RecGPossibleItems."Work Center Code")
                {
                }
                fieldelement(PossibleItem; RecGPossibleItems."Possible Item Code")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if not BooGExportAll and not FctCanExportPossibleItems(RecGPossibleItems."Item Code", RecGMessage."Export DateTime") then
                        currXMLport.Skip();
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

    var
        RecGMessage: Record "PWD Connector Messages";
        BooGExportAll: Boolean;


    procedure FctDefineMessage(RecPMessage: Record "PWD Connector Messages")
    begin
        RecGMessage := RecPMessage;
    end;


    procedure FctCanExportPossibleItems(CodPItemCode: Code[20]; DatPLastExportDate: DateTime): Boolean
    var
        RecLPossibleItems: Record "PWD Possible Items";
    begin
        RecLPossibleItems.SetCurrentKey("Item Code", "Last Modified Date");
        RecLPossibleItems.SetFilter("Item Code", CodPItemCode);
        if RecGMessage."Export Option" = RecGMessage."Export Option"::Partial then
            RecLPossibleItems.SetFilter("Last Modified Date", '>%1', DatPLastExportDate);
        exit(not RecLPossibleItems.IsEmpty);
    end;


    procedure FctExportAll(BooPExportAll: Boolean)
    begin
        BooGExportAll := BooPExportAll;
    end;
}

