page 50005 "PWD Item Configurator Setup"
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
    // ------------------------------------------------------------------------------------------------------------------

    Caption = 'Item Configurator Setup';
    PageType = Card;
    SourceTable = "PWD Piece Type";
    ApplicationArea = all;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Stone)
            {
                Caption = 'Stone';
                part(Control1; "PWD Item Config. Setup List")
                {
                    SubPageView = SORTING("Option Piece Type", Code) WHERE("Option Piece Type" = CONST(Stone));
                    ApplicationArea = All;
                }
            }
            group(Preparage)
            {
                Caption = 'Preparage';
                part(Control2; "PWD Item Config. Setup List")
                {
                    SubPageView = SORTING("Option Piece Type", Code) WHERE("Option Piece Type" = CONST(Preparage));
                    ApplicationArea = All;
                }
            }
            group("Lifted & Eliipses")
            {
                Caption = 'Lifted & Eliipses';
                part(Control3; "PWD Item Config. Setup List")
                {
                    SubPageView = SORTING("Option Piece Type", Code) WHERE("Option Piece Type" = CONST("Lifted and ellipses"));
                    ApplicationArea = All;
                }
            }
            group("Semi-finished")
            {
                Caption = 'Semi-finished';
                part(Control5; "PWD Item Config. Setup List")
                {
                    SubPageView = SORTING("Option Piece Type", Code) WHERE("Option Piece Type" = CONST("Semi-finished"));
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

