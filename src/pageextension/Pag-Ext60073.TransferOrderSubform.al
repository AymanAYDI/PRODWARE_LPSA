pageextension 60073 "PWD TransferOrderSubform" extends "Transfer Order Subform"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_ART02.001: NI 23/11/2011:  Désignation article 120 caracteres
    //                                           - Display field 50004..50005
    // ------------------------------------------------------------------------------------------------------------------
    layout
    {
        addafter(Description)
        {
            field("PWD LPSA Description 1"; Rec."PWD LPSA Description 1")
            {
                ApplicationArea = All;
            }
            field("PWD LPSA Description 2"; Rec."PWD LPSA Description 2")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter(Dimensions)
        {
            action("PWD Action1100267002")
            {
                Caption = 'Commentaires';
                Image = ViewComments;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.ShowLineComments();
                end;
            }
        }
    }
}

