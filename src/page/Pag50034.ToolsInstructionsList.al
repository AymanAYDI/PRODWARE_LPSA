page 50034 "PWD Tools Instructions List"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 27/06/2017 : FICHE SUIVEUSE - PP 1
    //                   - new Page

    Caption = 'Tools Instructions List';
    Editable = false;
    PageType = List;
    UsageCategory = None;
    SourceTable = "PWD Tools Instructions";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
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

