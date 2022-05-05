pageextension 60040 "PWD ReasonCodes" extends "Reason Codes"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.5
    // WMS-FE009.001:GR  05/07/2011   Connector management
    //                                   - Add Field  : "WMS Code"
    // +----------------------------------------------------------------------------------------------------------------+
    layout
    {
        addafter(Description)
        {
            field("PWD WMS Code"; Rec."PWD WMS Code")
            {
                ApplicationArea = All;
            }
        }
    }
}

