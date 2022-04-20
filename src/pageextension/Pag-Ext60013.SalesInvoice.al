pageextension 60013 "PWD SalesInvoice" extends "Sales Invoice"
{
    // #1..4
    // 
    // TDL.LPSA.20.04.15:APA 20/04/15: - Display Field "Customer Comment" on Tab [GENERAL]
    layout
    {
        addafter("External Document No.")
        {
            field("PWD Your Reference"; "Your Reference")
            {
                ApplicationArea = All;
            }
        }
        addafter(Status)
        {
            field("PWD BooGComment"; BooGComment)
            {
                Caption = 'Customer Comment';
                Editable = false;
                ApplicationArea = All;
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        RecLComment: Record "Comment Line";
    begin
        RecLComment.RESET;
        RecLComment.SETRANGE("Table Name", RecLComment."Table Name"::Customer);
        RecLComment.SETFILTER("No.", '%1|%2', "Sell-to Customer No.", "Bill-to Customer No.");
        BooGComment := RecLComment.FINDFIRST;
    end;

    var
        BooGComment: Boolean;
}

