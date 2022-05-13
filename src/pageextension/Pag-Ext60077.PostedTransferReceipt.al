pageextension 60077 "PWD PostedTransferReceipt" extends "Posted Transfer Receipt"
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
        addafter("Shortcut Dimension 2 Code")
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
                RunObject = Page "Inventory Comment Sheet";
                RunPageLink = "Document Type" = CONST("Posted Transfer Receipt"),
                                  "No." = FIELD("No."), "PWD Document Line No." = CONST(0);

            }
        }

    }
}

