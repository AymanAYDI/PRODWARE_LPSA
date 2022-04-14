page 50006 "PWD Manufacturing cycles Setup"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_PROD04.001: NI 13/12/2011:  FRAPPES - Temps de cycle incompressible
    //                                           - Create Page
    // ------------------------------------------------------------------------------------------------------------------

    Caption = 'Manufacturing cycles Setup';
    PageType = Card;
    SourceTable = "PWD Manufacturing cycles Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Item Code"; Rec."Item Code")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                }
                field("Setup Time"; Rec."Setup Time")
                {
                    ApplicationArea = All;
                }
                field("Setup Time Unit of Meas. Code"; Rec."Setup Time Unit of Meas. Code")
                {
                    ApplicationArea = All;
                }
                field("Run Time"; Rec."Run Time")
                {
                    ApplicationArea = All;
                }
                field("Run Time Unit of Meas. Code"; Rec."Run Time Unit of Meas. Code")
                {
                    ApplicationArea = All;
                }
                field("Maximun Quantity by cycle"; Rec."Maximun Quantity by cycle")
                {
                    ApplicationArea = All;
                }
                field("Qty - Units of Measure"; Rec."Qty - Units of Measure")
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

