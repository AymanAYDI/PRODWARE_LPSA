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

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                }
                field("Date"; Date)
                {
                }
                field(Hour; Hour)
                {
                }
                field(ErrorType; ErrorType)
                {
                }
                field("Connector Partner"; "Connector Partner")
                {
                }
                field("Flow Type"; "Flow Type")
                {
                }
                field("Buffer Message No."; "Buffer Message No.")
                {
                }
                field("Message"; Message)
                {
                }
                field("User ID"; "User ID")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1100294010; Links)
            {
                Visible = false;
            }
            systempart(Control1100294009; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        group(Action1100294011)
        {
            action(Action1100294013)
            {
                Caption = 'Purge';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    REPORT.RUNMODAL(REPORT::"Delete Connector Error Log");
                    CurrPage.UPDATE(FALSE);
                end;
            }
        }
    }
}

