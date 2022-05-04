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
    SourceTable = "PWD Phantom substitution Items";

    layout
    {
        area(content)
        {
            group(Control10)
            {
                Caption = 'General';
                Editable = false;
                ShowCaption = false;
                field("Phantom Item No."; Rec."Phantom Item No.")
                {
                    ApplicationArea = All;
                }
                field("Expected Quantity"; Rec."Expected Quantity")
                {
                    ApplicationArea = All;
                }
                field(DecGQtyRequested; DecGQtyRequested)
                {
                    Caption = 'Quantity Requested';
                    DecimalPlaces = 0 : 5;
                    ApplicationArea = All;
                }
                field(DecGQtyRemaining; DecGQtyRemaining)
                {
                    Caption = 'Remaining Quantity';
                    DecimalPlaces = 0 : 5;
                    ApplicationArea = All;
                }
            }
            repeater(Control1)
            {
                ShowCaption = false;
                field("Item No."; Rec."Item No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Priority; Rec.Priority)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Inventory; Rec.Inventory)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Total Available Quantity"; Rec."Total Available Quantity")
                {
                    ApplicationArea = All;
                }
                field("Quantity Requested"; Rec."Quantity Requested")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        DecGQtyRequested := DecGQtyRequested - xRec."Quantity Requested" + Rec."Quantity Requested";
                        DecGQtyRemaining := Rec."Expected Quantity" - DecGQtyRequested;
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
                ApplicationArea = All;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
                ApplicationArea = All;
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
        DecGQtyRemaining := Rec."Expected Quantity";
    end;

    var
        DecGQtyRemaining: Decimal;
        DecGQtyRequested: Decimal;
}

