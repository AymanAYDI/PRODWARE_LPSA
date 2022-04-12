page 50013 "PWD Phantom subs. Items List"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.06
    // FE_LAPRIERRETTE_GP0003 : APA 16/05/13 Create
    // 
    // +----------------------------------------------------------------------------------------------------------------+

    Caption = 'Phantom substitution Items';
    PageType = List;
    SourceTable = "Phantom substitution Items";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; "Item No.")
                {
                }
                field(Priority; Priority)
                {
                }
                field(Inventory; Inventory)
                {
                }
                field(Description; Description)
                {
                }
                field("Description 2"; "Description 2")
                {
                }
            }
        }
    }

    actions
    {
    }
}

