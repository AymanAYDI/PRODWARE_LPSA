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
    ApplicationArea = all;
    UsageCategory = Lists;

    SourceTable = "PWD Tools Instructions";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Criteria; Rec.Criteria)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

