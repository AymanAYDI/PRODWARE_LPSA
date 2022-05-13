pageextension 60072 "PWD TransferOrder" extends "Transfer Order"
{
    // ------------------------------------------------------------------------------------------------------------------------------------
    // Prodware : www.prodware.fr
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 
    // //>>LAP2.00
    //       -Add Field "Sales Order No."
    // 
    // ------------------------------------------------------------------------------------------------------------------------------------
    layout
    {
        addafter(Status)
        {
            field("PWD Sales Order No."; Rec."PWD Sales Order No.")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        modify("Co&mments")
        {
            Visible = false;
        }
        addafter("Co&mments")
        {
            action("PWD Co&mments")
            {
                ApplicationArea = Comments;
                Caption = 'Co&mments';
                Image = ViewComments;
                Promoted = true;
                PromotedCategory = Category6;
                RunObject = Page "Inventory Comment Sheet";
                RunPageLink = "Document Type" = CONST("Transfer Order"),
                                  "No." = FIELD("No."), "PWD Document Line No." = CONST(0);
            }
        }
    }
}

