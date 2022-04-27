pageextension 50020 pageextension50020 extends "Prod. Order Components"
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
        addafter("Control 4")
        {
            field("Lot Determining"; "Lot Determining")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Insertion (RunPageLink) on "Action 59".


        //Unsupported feature: Property Insertion (RunPageLink) on "Action 30".


        //Unsupported feature: Property Insertion (RunPageView) on "Action 75".


        //Unsupported feature: Property Insertion (RunPageLink) on "Action 75".


        //Unsupported feature: Property Deletion (RunFormLink) on "Action 59".


        //Unsupported feature: Property Deletion (RunFormLink) on "Action 30".


        //Unsupported feature: Property Deletion (RunFormView) on "Action 75".


        //Unsupported feature: Property Deletion (RunFormLink) on "Action 75".

        addafter("Action 80")
        {
            action("<Action1100267001>")
            {
                Caption = 'Select Phantom Item Substitution';
                Image = SelectItemSubstitution;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    // >> FE_LAPRIERRETTE_GP0003 : APA 16/05/13
                    CurrPage.SAVERECORD;

                    ShowItemSubPhantom;

                    CurrPage.UPDATE(TRUE);

                    UpdateReserveItemPhantom;

                    // << FE_LAPRIERRETTE_GP0003 : APA 16/05/13
                end;
            }
        }
    }
}

