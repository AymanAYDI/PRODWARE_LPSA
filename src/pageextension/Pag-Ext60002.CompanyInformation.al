pageextension 60002 "PWD CompanyInformation" extends "Company Information"
{
    // #1..47
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // TDL.LPSA.001 : 09/10/2014 : add indicator picture on released prod. order
    //         - Add field Picture_Positive and Picture_Negative
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    layout
    {
        addafter("System Indicator Text")
        {
            field("PWD Picture_Positive"; Rec."PWD Picture_Positive")
            {
                ApplicationArea = All;
            }
            field("PWD Picture_Negative"; Rec."PWD Picture_Negative")
            {
                ApplicationArea = All;
            }
        }
    }
}

