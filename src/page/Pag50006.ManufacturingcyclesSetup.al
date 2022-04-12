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
    SourceTable = "Manufacturing cycles Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                }
                field("Item Code"; "Item Code")
                {
                }
                field(Name; Name)
                {
                }
                field("Item Category Code"; "Item Category Code")
                {
                }
                field("Setup Time"; "Setup Time")
                {
                }
                field("Setup Time Unit of Meas. Code"; "Setup Time Unit of Meas. Code")
                {
                }
                field("Run Time"; "Run Time")
                {
                }
                field("Run Time Unit of Meas. Code"; "Run Time Unit of Meas. Code")
                {
                }
                field("Maximun Quantity by cycle"; "Maximun Quantity by cycle")
                {
                }
                field("Qty - Units of Measure"; "Qty - Units of Measure")
                {
                }
            }
        }
    }

    actions
    {
    }
}

