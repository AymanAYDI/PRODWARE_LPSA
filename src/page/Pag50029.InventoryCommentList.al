page 50029 "PWD Inventory Comment List"
{
    Caption = 'Comment List';
    DataCaptionFields = "Document Type", "No.";
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "PWD Inventory Comment Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = Comments;
                }
                field("Date"; Rec.Date)
                {
                    ApplicationArea = Comments;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Comments;
                }
            }
        }
    }

    actions
    {
    }
}

