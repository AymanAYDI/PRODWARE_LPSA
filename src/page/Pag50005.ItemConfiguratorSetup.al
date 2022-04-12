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

    layout
    {
        area(content)
        {
            group(Stone)
            {
                Caption = 'Stone';
                part(Control1100294002; "PWD Item Configurator Setup List")
                {
                    SubPageView = SORTING("Option Piece Type", Code) WHERE("Option Piece Type" = CONST(Stone));
                }
            }
            group(Preparage)
            {
                Caption = 'Preparage';
                part(Control1100294003; "PWD Item Configurator Setup List")
                {
                    SubPageView = SORTING("Option Piece Type", Code) WHERE("Option Piece Type" = CONST(Preparage));
                }
            }
            group("Lifted & Eliipses")
            {
                Caption = 'Lifted & Eliipses';
                part(Control1100294004; "PWD Item Config. Setup List")
                {
                    SubPageView = SORTING(Option Piece Type, Code) WHERE(Option Piece Type=CONST(Lifted and ellipses));
                }
            }
            group("Semi-finished")
            {
                Caption = 'Semi-finished';
                part(Control1100294005; "PWD Item Config. Setup List")
                {
                    SubPageView = SORTING(Option Piece Type, Code) WHERE(Option Piece Type=CONST(Semi-finished));
                }
            }
        }
    }

    actions
    {
    }
}

