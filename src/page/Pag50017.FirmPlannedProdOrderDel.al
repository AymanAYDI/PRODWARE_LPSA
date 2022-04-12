page 50017 "Firm Planned Prod. Order Del."
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 24/10/2017 : DEMANDES DIVERSES
    //                   - Add Field Source Material Vendor

    Caption = 'Firm Planned Prod. Order';
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Production Order";
    SourceTableView = WHERE (Status = CONST (Firm Planned));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Status; Status)
                {
                }
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Search Description"; "Search Description")
                {
                }
                field("Description 2"; "Description 2")
                {
                }
                field("Source No."; "Source No.")
                {
                }
                field("Due Date"; "Due Date")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Source Material Vendor"; "Source Material Vendor")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        //SETRANGE(Status,Status::"Firm Planned");
    end;
}

