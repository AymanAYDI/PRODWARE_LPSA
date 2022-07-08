page 8073282 "PWD Connector Error log"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect.1.00
    // 
    // FE_ProdConnect.001:GR 22/03/2011  Connector integration
    //                                   - Create Object
    // +----------------------------------------------------------------------------------------------------------------+

    Caption = 'Connector Error log';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "PWD Connector Error log";
    UsageCategory = History;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Date"; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field(Hour; Rec.Hour)
                {
                    ApplicationArea = All;
                }
                field(ErrorType; Rec.ErrorType)
                {
                    ApplicationArea = All;
                }
                field("Connector Partner"; Rec."Connector Partner")
                {
                    ApplicationArea = All;
                }
                field("Flow Type"; Rec."Flow Type")
                {
                    ApplicationArea = All;
                }
                field("Buffer Message No."; Rec."Buffer Message No.")
                {
                    ApplicationArea = All;
                }
                field("Message"; Rec.Message)
                {
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1100294010; Links)
            {
                Visible = false;
                ApplicationArea = All;
            }
            systempart(Control1100294009; Notes)
            {
                Visible = false;
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Action1100294011)
            {
                action(Action1100294013)
                {
                    Caption = 'Purge';
                    Image = Delete;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        REPORT.RUNMODAL(REPORT::"PWD Delete Connector Error Log");
                        CurrPage.UPDATE(FALSE);
                    end;
                }
            }
        }
    }
}

