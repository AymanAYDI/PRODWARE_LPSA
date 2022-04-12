page 50023 "Purchase Order Archive Lines"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // //>>LAP1.00
    // FE_LAPIERRETTE_ART02.001: NI 23/11/2011:  Désignation article 120 caracteres
    //                                           - Add field 50004..50005
    // ------------------------------------------------------------------------------------------------------------------

    Caption = 'Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Purchase Line Archive";
    SourceTableView = WHERE(Document Type=CONST(Order));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Cross-Reference No."; "Cross-Reference No.")
                {
                    Visible = false;
                }
                field("Variant Code"; "Variant Code")
                {
                    Visible = false;
                }
                field(Nonstock; Nonstock)
                {
                    Visible = false;
                }
                field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
                {
                    Visible = false;
                }
                field(Description; Description)
                {
                }
                field("PWD LPSA Description 1"; "PWD LPSA Description 1")
                {
                }
                field("PWD LPSA Description 2"; "PWD LPSA Description 2")
                {
                }
                field("Drop Shipment"; "Drop Shipment")
                {
                    Visible = false;
                }
                field("Return Reason Code"; "Return Reason Code")
                {
                    Visible = false;
                }
                field("Location Code"; "Location Code")
                {
                }
                field(Quantity; Quantity)
                {
                    BlankZero = true;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    Visible = false;
                }
                field("Direct Unit Cost"; "Direct Unit Cost")
                {
                    BlankZero = true;
                }
                field("Indirect Cost %"; "Indirect Cost %")
                {
                    Visible = false;
                }
                field("Unit Cost (LCY)"; "Unit Cost (LCY)")
                {
                    Visible = false;
                }
                field("Unit Price (LCY)"; "Unit Price (LCY)")
                {
                    Visible = false;
                }
                field("Line Amount"; "Line Amount")
                {
                    BlankZero = true;
                }
                field("Line Discount %"; "Line Discount %")
                {
                    BlankZero = true;
                }
                field("Line Discount Amount"; "Line Discount Amount")
                {
                    Visible = false;
                }
                field("Allow Invoice Disc."; "Allow Invoice Disc.")
                {
                    Visible = false;
                }
                field("Inv. Discount Amount"; "Inv. Discount Amount")
                {
                    Visible = false;
                }
                field("Qty. to Receive"; "Qty. to Receive")
                {
                    BlankZero = true;
                }
                field("Quantity Received"; "Quantity Received")
                {
                    BlankZero = true;
                }
                field("Qty. to Invoice"; "Qty. to Invoice")
                {
                    BlankZero = true;
                }
                field("Quantity Invoiced"; "Quantity Invoiced")
                {
                    BlankZero = true;
                }
                field("Allow Item Charge Assignment"; "Allow Item Charge Assignment")
                {
                    Visible = false;
                }
                field("Requested Receipt Date"; "Requested Receipt Date")
                {
                    Visible = false;
                }
                field("Promised Receipt Date"; "Promised Receipt Date")
                {
                    Visible = false;
                }
                field("Planned Receipt Date"; "Planned Receipt Date")
                {
                }
                field("Expected Receipt Date"; "Expected Receipt Date")
                {
                }
                field("Order Date"; "Order Date")
                {
                }
                field("Lead Time Calculation"; "Lead Time Calculation")
                {
                    Visible = false;
                }
                field("Job No."; "Job No.")
                {
                    Visible = false;
                }
                field("Planning Flexibility"; "Planning Flexibility")
                {
                    Visible = false;
                }
                field("Prod. Order Line No."; "Prod. Order Line No.")
                {
                    Visible = false;
                }
                field("Prod. Order No."; "Prod. Order No.")
                {
                    Visible = false;
                }
                field("Operation No."; "Operation No.")
                {
                    Visible = false;
                }
                field("Work Center No."; "Work Center No.")
                {
                    Visible = false;
                }
                field(Finished; Finished)
                {
                    Visible = false;
                }
                field("Inbound Whse. Handling Time"; "Inbound Whse. Handling Time")
                {
                    Visible = false;
                }
                field("Blanket Order No."; "Blanket Order No.")
                {
                    Visible = false;
                }
                field("Blanket Order Line No."; "Blanket Order Line No.")
                {
                    Visible = false;
                }
                field("Appl.-to Item Entry"; "Appl.-to Item Entry")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Action1907935204)
            {
                Caption = '&Line';
                action(Action1906874004)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #5167. Unsupported part was commented. Please check it.
                        /*CurrPage.PurchLinesArchive.FORM.*/
                        _ShowDimensions;

                    end;
                }
                action(Action1907838004)
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #5167. Unsupported part was commented. Please check it.
                        /*CurrPage.PurchLinesArchive.FORM.*/
                        _ShowLineComments;

                    end;
                }
                action(Action1905483604)
                {
                    Caption = 'Document &LineTracking';

                    trigger OnAction()
                    begin
                        // dach0001.begin
                        //This functionality was copied from page #5167. Unsupported part was commented. Please check it.
                        /*CurrPage.PurchLinesArchive.FORM.*/
                        ShowDocumentLineTracking;
                        // dach0001.end

                    end;
                }
            }
        }
    }


    procedure _ShowDimensions()
    begin
        Rec.ShowDimensions;
    end;


    procedure ShowDimensions()
    begin
        Rec.ShowDimensions;
    end;


    procedure _ShowLineComments()
    begin
        Rec.ShowLineComments;
    end;


    procedure ShowLineComments()
    begin
        Rec.ShowLineComments;
    end;


    procedure ShowDocumentLineTracking()
    begin
        // dach0001.begin
        CLEAR(DocumentLineTracking);
        DocumentLineTracking.SetDoc(1, "Document No.", "Line No.", "Blanket Order No.", "Blanket Order Line No.", '', 0);
        DocumentLineTracking.RUNMODAL;
        // dach0001.end
    end;
}

