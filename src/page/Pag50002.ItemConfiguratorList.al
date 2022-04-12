page 50002 "PWD Item Configurator List"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_ART01.001: TO 07/12/2011:  Configurateur article
    //                                           - Create Page
    // 
    // //>>LAP2.05
    // FE_LAPIERRETTE_NDT01.001: LY 17/04/2013:  New Demand
    //                                           Add Page Action "Copy From Item"
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 20/06/2017 :  CONFIGURATEUR ARTICLES
    //                - Add Field Create From Item
    // 
    // ------------------------------------------------------------------------------------------------------------------

    CardPageID = "PWD Item Configurator";
    Editable = false;
    PageType = List;
    SourceTable = "PWD Item Configurator";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Family Code"; "Family Code")
                {
                }
                field("Subfamily Code"; "Subfamily Code")
                {
                }
                field("Product Type"; "Product Type")
                {
                }
                field("Item Code"; "Item Code")
                {
                }
                field("PWD LPSA Description 1"; "PWD LPSA Description 1")
                {
                }
                field("PWD LPSA Description 2"; "PWD LPSA Description 2")
                {
                }
                field("PWD Quartis Description"; "PWD Quartis Description")
                {
                }
                field("Quartis Desc TEST"; "Quartis Desc TEST")
                {
                }
                field("Create From Item"; "Create From Item")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("<Action110>")
            {
                Caption = 'F&unctions';
                action(Action1100267010)
                {
                    Caption = 'Copy from Item';
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        RecLItemConfigurator: Record "PWD Item Configurator";
                    begin
                        //>>FE_LAPIERRETTE_NDT01.001
                        RepGCopyItem.SetFromConfiguration;
                        RepGCopyItem.RUNMODAL;

                        // Open Configuration Card
                        IF RepGCopyItem.ItemReturn(RecGNewItem) THEN BEGIN
                            // Open Card
                            RecLItemConfigurator.SETCURRENTKEY("Item Code");
                            RecLItemConfigurator.SETRANGE("Item Code", RecGNewItem."No.");
                            RecLItemConfigurator.FINDLAST;
                            PagGItemConfigurator.SETRECORD(RecLItemConfigurator);
                            PagGItemConfigurator.RUN;
                        END;
                        //<<FE_LAPIERRETTE_NDT01.001
                    end;
                }
            }
        }
    }

    var
        RepGCopyItem: Report "PWD Item Copy";
        RecGNewItem: Record Item;
        PagGItemConfigurator: Page "PWD Item Configurator";
}

