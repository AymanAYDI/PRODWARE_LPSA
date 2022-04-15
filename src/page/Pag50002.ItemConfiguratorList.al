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
                field("Family Code"; Rec."Family Code")
                {
                    ApplicationArea = All;
                }
                field("Subfamily Code"; Rec."Subfamily Code")
                {
                    ApplicationArea = All;
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                }
                field("Item Code"; Rec."Item Code")
                {
                    ApplicationArea = All;
                }
                field("PWD LPSA Description 1"; Rec."PWD LPSA Description 1")
                {
                    ApplicationArea = All;
                }
                field("PWD LPSA Description 2"; Rec."PWD LPSA Description 2")
                {
                    ApplicationArea = All;
                }
                field("PWD Quartis Description"; Rec."PWD Quartis Description")
                {
                    ApplicationArea = All;
                }
                field("Quartis Desc TEST"; Rec."Quartis Desc TEST")
                {
                    ApplicationArea = All;
                }
                field("Create From Item"; Rec."Create From Item")
                {
                    ApplicationArea = All;
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
                    ApplicationArea = All;

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
                            RecLItemConfigurator.FINDLAST();
                            PagGItemConfigurator.SETRECORD(RecLItemConfigurator);
                            PagGItemConfigurator.RUN();
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

