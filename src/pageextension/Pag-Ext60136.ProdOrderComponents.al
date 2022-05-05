pageextension 60136 "PWD ProdOrderComponents" extends "Prod. Order Components"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.06
    // FE_LAPRIERRETTE_GP0003 : APA 16/05/13 Add Button Sélection article remplacant fantôme
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    layout
    {
        addafter(Description)
        {
            field("PWD Lot Determining"; Rec."PWD Lot Determining")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {


        addafter(SelectItemSubstitution)
        {
            action("PWD Action1100267001")
            {
                Caption = 'Select Phantom Item Substitution';
                Image = SelectItemSubstitution;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    // >> FE_LAPRIERRETTE_GP0003 : APA 16/05/13
                    CurrPage.SAVERECORD();

                    Rec.ShowItemSubPhantom();

                    CurrPage.UPDATE(TRUE);

                    Rec.UpdateReserveItemPhantom();

                    // << FE_LAPRIERRETTE_GP0003 : APA 16/05/13
                end;
            }
        }
    }
}

