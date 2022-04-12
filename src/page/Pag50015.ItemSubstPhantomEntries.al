page 50015 "Item Subst. Phantom Entries"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.06
    // FE_LAPRIERRETTE_GP0003 : APA 16/05/13 Create
    // 
    // +----------------------------------------------------------------------------------------------------------------+

    Caption = 'Item Subst. Phantom Entries';
    DataCaptionFields = "Phantom Item No.";
    DelayedInsert = true;
    PageType = Worksheet;
    SourceTable = "Phantom substitution Items";

    layout
    {
        area(content)
        {
            group(Control10)
            {
                Caption = 'General';
                Editable = false;
                ShowCaption = false;
                field("Phantom Item No."; "Phantom Item No.")
                {
                }
                field("Expected Quantity"; "Expected Quantity")
                {
                }
                field(DecGQtyRequested; DecGQtyRequested)
                {
                    Caption = 'Quantity Requested';
                    DecimalPlaces = 0 : 5;
                }
                field(DecGQtyRemaining; DecGQtyRemaining)
                {
                    Caption = 'Remaining Quantity';
                    DecimalPlaces = 0 : 5;
                }
            }
            repeater(Control1)
            {
                ShowCaption = false;
                field("Item No."; "Item No.")
                {
                    Editable = false;
                }
                field("Lot No."; "Lot No.")
                {
                    Editable = false;
                }
                field(Description; Description)
                {
                    Editable = false;
                }
                field(Priority; Priority)
                {
                    Editable = false;
                }
                field(Inventory; Inventory)
                {
                    Editable = false;
                }
                field("Total Available Quantity"; "Total Available Quantity")
                {
                }
                field("Quantity Requested"; "Quantity Requested")
                {

                    trigger OnValidate()
                    begin
                        DecGQtyRequested := DecGQtyRequested - xRec."Quantity Requested" + "Quantity Requested";
                        DecGQtyRemaining := "Expected Quantity" - DecGQtyRequested;
                        CurrPage.UPDATE(TRUE);
                    end;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
        }
    }

    trigger OnOpenPage()
    begin
        DecGQtyRequested := 0;
        DecGQtyRemaining := "Expected Quantity";
    end;

    var
        DecGQtyRequested: Decimal;
        DecGQtyRemaining: Decimal;
}

