pageextension 60019 "PWD PurchaseOrderSubform" extends "Purchase Order Subform"
{
    // #1..10
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.5
    // WMS-FE04.001:GR  01/07/2011   Connector integration
    //                              - Add fields:  "WMS_Status"
    //                              - Add FctSendLineToWMS function
    //                              - Add Page Action "Send Line To WMS" in Lines
    //                              - Add field WMS_Item Not Visible
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_ART02.001: NI 23/11/2011:  Désignation article 120 caracteres
    //                                           - Display field 50004..50005
    // 
    // //>>TDL.001
    // TDL.001: ONSITE 29/06/2012:  Modifications
    //                                           - Add Field "Gen. Prod. Posting Group"
    //                                           - Add Field 50006
    // 
    // TDL.LPSA: ONSITE 13/10/2014: Modification
    //                                           - Add Field 50007
    // 
    // ------------------------------------------------------------------------------------------------------------------
    layout
    {
        addafter("No.")
        {
            field("PWD Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                Editable = true;
                ApplicationArea = All;
            }
            field("PWD Gen. Account No."; Rec."PWD Gen. Account No.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Description")
        {
            field("PWD LPSA Description 1"; Rec."PWD LPSA Description 1")
            {
                ApplicationArea = All;
            }
            field("PWD LPSA Description 2"; Rec."PWD LPSA Description 2")
            {
                ApplicationArea = All;
            }
        }
        addafter("Appl.-to Item Entry")
        {
            field("PWD Unit Volume"; Rec."Unit Volume")
            {
                Caption = 'Unit Volume';
                ApplicationArea = All;
            }
            field("PWD WMS_Status"; Rec."PWD WMS_Status")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("PWD WMS_Item"; Rec."PWD WMS_Item")
            {
                Visible = false;
                ApplicationArea = All;
            }
        }
        addafter(ShortcutDimCode8)
        {
            field("PWD Budgeted"; Rec."PWD Budgeted")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addlast("Item Availability by")
        {
            action("PWD Action1100294001")
            {
                Caption = 'Send Line To WMS';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    FctSendLineToWMS();
                end;
            }
        }
    }
    procedure FctSendLineToWMS()
    var
        CduLConnectorWMS: Codeunit "PWD Connector WMS Parse Data";
    begin
        CduLConnectorWMS.FctChangePurchOrderStatus(Rec);
    end;
}

