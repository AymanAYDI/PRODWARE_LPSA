xmlport 8073321 "PWD Import OT Sabatier"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // //>>ProdConnect1.5
    // FE_ProdConnect.001:GR 22/03/2011  Connector integration
    //                                   - Create Object
    // 
    // +----------------------------------------------------------------------------------------------------------------+

    Encoding = UTF8;

    schema
    {
        textelement(Retour)
        {
            tableelement("<sabatier ot import>"; "PWD Sabatier OT Import")
            {
                XmlName = 'OT';
                fieldattribute(IDOT; "<Sabatier OT Import>".IDOT)
                {
                }
                fieldattribute(IDMission; "<Sabatier OT Import>".IDMission)
                {
                }
                fieldattribute(RefOT; "<Sabatier OT Import>".RefOT)
                {
                }
                fieldattribute(RefMission; "<Sabatier OT Import>".RefMission)
                {
                }
                fieldattribute(IDEtatOT; "<Sabatier OT Import>".IDEtatOT)
                {
                }
                fieldattribute(DateHeureDebut; "<Sabatier OT Import>".DateHeureDebut)
                {
                }
                fieldattribute(Commentaire; "<Sabatier OT Import>".Commentaire)
                {
                }
                fieldattribute(Latitude; "<Sabatier OT Import>".Latitude)
                {
                }
                fieldattribute(Longitude; "<Sabatier OT Import>".Longitude)
                {
                }
                fieldattribute(Fix; "<Sabatier OT Import>".Fix)
                {
                }
                fieldattribute(NbSat; "<Sabatier OT Import>".NbSat)
                {
                }
                fieldattribute(Vitesse; "<Sabatier OT Import>".Vitesse)
                {
                }
                fieldattribute(Cap; "<Sabatier OT Import>".Cap)
                {
                }
                fieldattribute(Contact; "<Sabatier OT Import>".Contact)
                {
                }
                fieldattribute(Tor; "<Sabatier OT Import>".TOR)
                {
                }
                fieldattribute(Ana1; "<Sabatier OT Import>".ANA1)
                {
                }
                fieldattribute(Ana2; "<Sabatier OT Import>".ANA2)
                {
                }
                fieldattribute(Ana3; "<Sabatier OT Import>".ANA3)
                {
                }
                fieldattribute(Ana4; "<Sabatier OT Import>".ANA4)
                {
                }
                fieldattribute(CodeChauffeur; "<Sabatier OT Import>".CodeChauffeur)
                {
                }

                trigger OnAfterInitRecord()
                var
                    RefLRecordRef: RecordRef;
                begin
                    RefLRecordRef.GetTable("<Sabatier OT Import>");
                    CduGBufferManagement.FctNewBufferLine2(RefLRecordRef, RecGConnectorValues, 0);
                    RefLRecordRef.SetTable("<Sabatier OT Import>");
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
        RecGConnectorValues: Record "PWD Connector Values";
        CduGBufferManagement: Codeunit "PWD Buffer Management";


    procedure FctInitXmlPort(RecPConnectorValues: Record "PWD Connector Values")
    begin
        RecGConnectorValues := RecPConnectorValues;
    end;
}

