pageextension 60048 "PWD SalesLines" extends "Sales Lines"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP.TDL.09/10/2014 :
    // 09/10/2014 : Add Planned Delivery Date
    // 
    // //>>MODIF HL
    // TI297099 DO.GEPO 16/10/2015 : add field Name of Sell to customer no
    // 
    // //>>TDL.216
    // TDL.LPSA.216:CSC 04/12/15 : add key "Document Type,Type,No.,Cust Promised Delivery Date" in SourceTableView
    // 
    // //>>MODIF HL
    // TI317966 DO.GEPO 08/03/2016 : add field Order Date

    // TODO:SourceTableView
    //SourceTableView=SORTING("Document Type",Type,"No.","Cust Promised Delivery Date");

    layout
    {
        addafter("Sell-to Customer No.")
        {
            field("PWD Name of Sell-to Customer No."; Rec."PWD Name of Sell-to Customer No.")
            {
                ApplicationArea = All;
            }
        }
        addafter(Quantity)
        {
            field("PWD Unit Price"; Rec."Unit Price")
            {
                ApplicationArea = All;
            }
            field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
            {
                ApplicationArea = All;
            }
        }
        addafter("Outstanding Quantity")
        {
            field("PWD Cust Promised Delivery Date"; Rec."PWD Cust Promised Delivery Date")
            {
                Caption = 'Date livraison confirmée client';
                Editable = false;
                ApplicationArea = All;
            }
            field("PWD Planned Delivery Date"; Rec."Planned Delivery Date")
            {
                ApplicationArea = All;
            }
            field("PWD Order Date"; Rec."PWD Order Date")
            {
                ApplicationArea = All;
            }
            field("PWD Scrap Quantity"; Rec."PWD Scrap Quantity")
            {
                ApplicationArea = All;
            }
            field("PWD Planned Delivery Date2"; Rec."Planned Delivery Date")
            {
                ApplicationArea = All;
            }
            field("PWD Cross-Reference No."; xRec."Cross-Reference No.")
            {
                ApplicationArea = All;
            }
        }
    }
}

