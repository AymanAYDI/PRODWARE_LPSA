pageextension 60004 "PWD CustomerCard" extends "Customer Card"
{
    // #1..45
    // 
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_VTE01.001: TO 07/12/2011:  Export Role
    //                                           - Add field 50000 "Rolex Bienne"
    //                                           - Design field "Our Account No." on tab Invoicing
    // ------------------------------------------------------------------------------------------------------------------
    //     PLAW1 -----------------------------------------------------------------------------
    // PLAW1-5.0   2014-11-07 PO-3447: Location (Latitude/Longitude)
    // PLAW1 -----------------------------------------------------------------------------
    layout
    {
        addafter(Name)
        {
            field("PWD Name 2"; Rec."Name 2")
            {
                ApplicationArea = All;
            }
        }
        addafter("VAT Bus. Posting Group")
        {
            field("PWD Rolex Bienne"; Rec."PWD Rolex Bienne")
            {
                ApplicationArea = All;
            }
        }
        addafter(Invoicing)
        {
            field("PWD Our Account No."; Rec."Our Account No.")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addlast(Action82)
        {
            action("PWD Lignes devis")
            {
                Caption = 'Lignes devis';
                RunObject = Page "Sales Lines";
                RunPageView = SORTING("Document Type", "Document No.", "Line No.")
                              ORDER(Ascending)
                              WHERE("Document Type" = FILTER(Quote));
                RunPageLink = "Sell-to Customer No." = FIELD("No.");
                ApplicationArea = All;
                Image = AllLines;
            }
        }
    }
}

