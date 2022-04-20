pageextension 50070 pageextension50070 extends "Posted Transfer Shpt. Subform"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_ART02.001: NI 23/11/2011:  Désignation article 120 caracteres
    //                                           - Display field 50004..50005
    // 
    // -----------------------------------------------------------------------------------------------------------------
    layout
    {
        addafter("Control 10")
        {
            field("LPSA Description 1"; "LPSA Description 1")
            {
                ApplicationArea = All;
            }
            field("LPSA Description 2"; "LPSA Description 2")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter("Action 1900545004")
        {
            action("<Action1100267002>")
            {
                Caption = 'Commentaires';
                Image = ViewComments;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.ShowLineComments;
                end;
            }
        }
    }
}

