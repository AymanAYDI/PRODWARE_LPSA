page 50012 "PWD Possible Items List"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise                                                                                      |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.06
    // FE_LAPRIERRETTE_GP0004.001 :GR  16/05/13 Create
    // 
    // +----------------------------------------------------------------------------------------------------------------+

    Caption = 'Possible Items List';
    DelayedInsert = true;
    PageType = List;
    PopulateAllFields = true;
    SourceTable = "PWD Possible Items";
    UsageCategory = none;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item Code"; Rec."Item Code")
                {
                    ApplicationArea = All;
                }
                field("Work Center Code"; Rec."Work Center Code")
                {
                    ApplicationArea = All;
                }
                field("Item Description 1"; Rec."Item Description 1")
                {
                    ApplicationArea = All;
                }
                field("Item Description 2"; Rec."Item Description 2")
                {
                    ApplicationArea = All;
                }
                field("Possible Item Code"; Rec."Possible Item Code")
                {
                    ApplicationArea = All;
                }
                field("Possible Item Description"; Rec."Possible Item Description")
                {
                    Caption = '<Designation article Intermediaire>';
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1100267009; Links)
            {
                Visible = false;
                ApplicationArea = All;
            }
            systempart(Control1100267008; Notes)
            {
                Visible = false;
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}

