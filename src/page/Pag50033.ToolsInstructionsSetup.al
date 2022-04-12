page 50033 "PWD Tools Instructions Setup"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 27/06/2017 : FICHE SUIVEUSE - PP 1
    //                   - new Page

    Caption = 'Tools Instructions';
    PageType = List;
    SourceTable = "Tools Instructions";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field(Criteria; Criteria)
                {
                }
            }
        }
    }

    actions
    {
    }
}

