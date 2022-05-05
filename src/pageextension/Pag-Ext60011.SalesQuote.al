pageextension 60011 "PWD SalesQuote" extends "Sales Quote"
{
    // #1..22
    // 
    // ðððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððð
    // www.prodware.fr
    // ðððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððð
    // 
    // //>>MODIF HL
    // TI188333 DO.GEPO 30/10/2013 : add field External Document
    // 
    // TDL.LPSA.05.10.15:NBO 05/10/15: Add Field 50005
    layout
    {
        addafter("Requested Delivery Date")
        {
            field("PWD Validity Quote Date"; Rec."PWD Validity Quote Date")
            {
                ApplicationArea = All;
            }
        }
        addafter(Status)
        {
            field("PWD External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
            }
        }
    }
}

