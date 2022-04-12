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
    SourceTable = "Possible Items";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item Code"; "Item Code")
                {
                }
                field("Work Center Code"; "Work Center Code")
                {
                }
                field("Item Description 1"; "Item Description 1")
                {
                }
                field("Item Description 2"; "Item Description 2")
                {
                }
                field("Possible Item Code"; "Possible Item Code")
                {
                }
                field("Possible Item Description"; "Possible Item Description")
                {
                    Caption = '<Designation article Intermediaire>';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1100267009; Links)
            {
                Visible = false;
            }
            systempart(Control1100267008; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }
}

