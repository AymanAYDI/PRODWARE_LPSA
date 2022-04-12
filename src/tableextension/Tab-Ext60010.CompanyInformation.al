tableextension 60010 "PWD CompanyInformation" extends "Company Information"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // TDL.LPSA.001 : 09/10/2014 : add indicator picture on released prod. order
    //         - Add field 50000 and 50001
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    fields
    {
        field(50000; "PWD Picture_Positive"; Blob)
        {
            Caption = 'Positive Indicator';
            Subtype = Bitmap;
        }
        field(50001; "PWD Picture_Negative"; Blob)
        {
            Caption = 'Negative Indicator';
            Subtype = Bitmap;
        }
    }
}

