xmlport 8073320 "PWD Export Contact Sabatier"
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


    schema
    {
        textelement(Commandes)
        {
            textattribute(Idclient)
            {

                trigger OnBeforePassVariable()
                begin
                    Idclient := '100';
                end;
            }
            tableelement("Ship-to Address"; "Ship-to Address")
            {
                XmlName = 'Commande';
                textattribute(Id)
                {
                }
                textattribute(Nom)
                {
                }
                textelement(Param)
                {
                    textelement(Contact)
                    {
                        fieldattribute(RefContact; "Ship-to Address".Code)
                        {
                        }
                        textattribute(TypeContact)
                        {

                            trigger OnBeforePassVariable()
                            begin
                                TypeContact := 'CLIENT';
                            end;
                        }
                        fieldattribute(Adresse; "Ship-to Address".Address)
                        {
                        }
                    }
                }
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
}

