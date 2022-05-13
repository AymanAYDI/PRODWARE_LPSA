page 50028 "PWD Product Groups"
{
    Caption = 'Product Groups';
    DataCaptionFields = "Item Category Code";
    PageType = List;
    SourceTable = "PWD Product Group";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Item Category Code"; "Item Category Code")
                {
                    Visible = false;
                }
                field("Code"; Code)
                {
                }
                field("Warehouse Class Code"; "Warehouse Class Code")
                {
                    Visible = false;
                }
                field(Description; Description)
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links)
            {
                Visible = false;
            }
            systempart(Notes; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }
}

