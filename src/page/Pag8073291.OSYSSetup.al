page 8073291 "PWD OSYS Setup"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // //>>ProdConnect1.06
    // OSYS-Int001.001:GR 18/10/2011   Connector integration
    //                              - Create Object
    // 
    // //>>ProdConnect1.07.02.02
    // OSYS-Int001.002:GR 07/02/2012   Connector integration
    //                                 Add field :PlannerOne
    // 
    // //>>LAP2.06
    // FE_LAPRIERRETTE_GP0004.001 :GR  23/05/13  : - Add Field :  Possible Items Message
    // 
    // 
    // //>>LAP2.06.01
    // FE_LAPRIERRETTE_GP0004.002 :GR  15/07/13  : - Add Fields :  Journal Templ Name Prod 1
    //                                                             Journal Batch Name Prod 1
    // 
    // //>>LAP2.22
    // P24578_009: RO : 12/12/2019 : cf Demande par mail
    //                   - Add Fields  Journal Templ Name Stock MVT
    //                                 Journal Batch Name Stock MVT
    //                                 Journal Templ Name Stock TRF
    //                                 Journal Batch Name  Stock TRF
    // 
    // 
    // +----------------------------------------------------------------------------------------------------------------+

    Caption = 'OSYS Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    UsageCategory = None;
    SourceTable = "PWD OSYS Setup";

    layout
    {
        area(content)
        {
            group("Général")
            {
                Caption = 'General';
                field(OSYS; Rec.OSYS)
                {
                    ApplicationArea = All;
                }
                field("Journal Templ Name Prod"; Rec."Journal Templ Name Prod")
                {
                    ApplicationArea = All;
                }
                field("Journal Batch Name Prod"; Rec."Journal Batch Name Prod")
                {
                    ApplicationArea = All;
                }
                field("Journal Templ Name Prod 1"; Rec."Journal Templ Name Prod 1")
                {
                    ApplicationArea = All;
                }
                field("Journal Batch Name Prod 1"; Rec."Journal Batch Name Prod 1")
                {
                    ApplicationArea = All;
                }
                field("Journal Templ Name Stock MVT"; Rec."Journal Templ Name Stock MVT")
                {
                    ApplicationArea = All;
                }
                field("Journal Batch Name Stock MVT"; Rec."Journal Batch Name Stock MVT")
                {
                    ApplicationArea = All;
                }
                field("Journal Templ Name Stock TRF"; Rec."Journal Templ Name Stock TRF")
                {
                    ApplicationArea = All;
                }
                field("Journal Batch Name Stock TRF"; Rec."Journal Batch Name Stock TRF")
                {
                    ApplicationArea = All;
                }
                field("Packaging Unit"; Rec."Packaging Unit")
                {
                    ApplicationArea = All;
                }
                field("Pallet  Unit"; Rec."Pallet  Unit")
                {
                    ApplicationArea = All;
                }
                field("Separator Character"; Rec."Separator Character")
                {
                    ApplicationArea = All;
                }
                field("Partner Code"; Rec."Partner Code")
                {
                    ApplicationArea = All;
                }
                field("Possible Items Message"; Rec."Possible Items Message")
                {
                    ApplicationArea = All;
                }
                field(PlannerOne; Rec.PlannerOne)
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1100294004; Links)
            {
                Visible = false;
                ApplicationArea = All;
            }
            systempart(Control1100294003; Notes)
            {
                Visible = false;
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.RESET();
        IF NOT Rec.GET() THEN BEGIN
            Rec.INIT();
            Rec.INSERT();
        END;
    end;
}

