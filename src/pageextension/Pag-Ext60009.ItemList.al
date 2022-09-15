pageextension 60009 "PWD ItemList" extends "Item List"
{
    layout
    {
        addafter(Description)
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
        addafter("Routing No.")
        {
            field("PWD CodGActiveVersionCode"; CodGActiveVersionCode)
            {
                caption = 'Routing Active Version';
                editable = false;
                ApplicationArea = All;
                trigger OnLookup(var text: text): boolean
                var
                    RecLRtngVersion: Record "Routing Version";
                begin
                    //>>LAP2.12
                    RecLRtngVersion.SETRANGE("Routing No.", Rec."Routing No.");
                    RecLRtngVersion.SETRANGE("Version Code", CodGActiveVersionCode);
                    Page.RUNMODAL(Page::"Routing Version", RecLRtngVersion);
                    CodGActiveVersionCode := CduGVersionMgt.GetRtngVersion(Rec."Routing No.", WORKDATE(), TRUE);
                    //<<LAP2.12
                end;
            }
        }
        addafter("Item Category Code")
        {
            field("PWD Product Group Code"; Rec."PWD Product Group Code")
            {
                caption = 'Product Group Code';
                visible = false;
                ApplicationArea = All;
            }
        }
        addafter("Base Unit of Measure")
        {
            field("PWD Location Code"; Rec."Location Code")
            {
                ApplicationArea = All;

            }
        }
        addafter("Unit Price")
        {
            field("PWD Reordering Policy"; Rec."Reordering Policy")
            {
                ApplicationArea = All;

            }
        }
        addafter("Indirect Cost %")
        {
            field("PWD Minimum Order Quantity"; Rec."Minimum Order Quantity")
            {
                ApplicationArea = All;

            }
            field("PWD Maximum Order Quantity"; Rec."Maximum Order Quantity")
            {
                ApplicationArea = All;

            }

        }
        addafter(Blocked)
        {
            field("PWD Phantom Item"; Rec."PWD Phantom Item")
            {
                ApplicationArea = All;
            }
        }
        addafter("Item Tracking Code")
        {
            field("PWD Customer Plan No."; Rec."PWD Customer Plan No.")
            {
                ApplicationArea = All;

            }
            field("PWD Customer Plan Description"; Rec."PWD Customer Plan Description")
            {
                ApplicationArea = All;

            }

            field("PWD LPSA Plan No."; Rec."PWD LPSA Plan No.")
            {
                ApplicationArea = All;

            }
            field("PWD Barcode"; Rec."PWD Barcode")
            {
                ApplicationArea = All;

            }
            field("PWD Phantom Item2"; Rec."PWD Phantom Item")
            {
                ApplicationArea = All;

            }

            field("PWD Order Multiple"; Rec."Order Multiple")
            {
                ApplicationArea = All;

            }
            field("PWD Safety Stock Quantity"; Rec."Safety Stock Quantity")
            {
                ApplicationArea = All;

            }
            field("PWD Lot Size"; Rec."Lot Size")
            {
                ApplicationArea = All;

            }
            field("PWD Configurator Exists"; Rec."PWD Configurator Exists")
            {
                editable = false;
                ApplicationArea = All;
            }
            field("PWD Plate Number"; Rec."PWD Plate Number")
            {
                ApplicationArea = All;

            }
            field("PWD Part Number By Plate"; Rec."PWD Part Number By Plate")
            {
                ApplicationArea = All;

            }
            field("PWD Reorder Point"; Rec."Reorder Point")
            {
                ApplicationArea = All;

            }
            field("PWD Reorder Quantity"; Rec."Reorder Quantity")
            {
                ApplicationArea = All;

            }
            field("PWD Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = All;

            }
            field("PWD Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = All;

            }
            field("PWD Reserve"; Rec.Reserve)
            {
                ApplicationArea = All;

            }
            field("PWD Safety Lead Time"; Rec."Safety Lead Time")
            {
                ApplicationArea = All;

            }

        }
        addbefore(Control1901314507)
        {
            part(PWDLink; "PWD Link")
            {
                ApplicationArea = All;
                SubPageLink = "Item No." = FIELD("No.");
            }
        }
        modify("Shelf No.")
        {
            visible = true;
            editable = false;
        }
        modify(Control1900383207)
        {
            Visible = false;
        }

    }
    actions
    {
        addlast(Item)
        {
            action("PWD PossibleItems")
            {
                Caption = 'Possible Items';
                RunObject = Page "PWD Possible Items List";
                RunPageLink = "Item Code" = FIELD("No.");
                Promoted = True;
                Image = SplitChecks;
                ApplicationArea = all;
            }
            action("PWD PossibleItemsExport")
            {
                caption = 'Possible Items Export';
                Promoted = true;
                Image = Export;
                PromotedCategory = Process;
                ApplicationArea = all;
                trigger OnAction()
                VAR
                    CduLConnectorOSYSParseData: Codeunit "PWD Connector OSYS Parse Data";
                BEGIN
                    //>>FE_LAPRIERRETTE_GP0004.001
                    CLEAR(CduLConnectorOSYSParseData);
                    CduLConnectorOSYSParseData.FctExportItemsPossibleManual(Rec."No.");
                    //<<FE_LAPRIERRETTE_GP0004.001
                END;

            }
            action("PWD PhantomsItems")
            {
                caption = 'Phantoms Items';
                RunObject = Page "PWD Phantom subs. Items List";
                RunPageLink = "Phantom Item No." = FIELD("No.");
                Promoted = true;
                Image = SplitChecks;
                PromotedCategory = Process;
                ApplicationArea = all;
            }

        }
    }
    trigger OnAfterGetRecord()
    begin
        //>>LAP2.12
        CodGActiveVersionCode := CduGVersionMgt.GetRtngVersion(Rec."Routing No.", WORKDATE(), TRUE);
        //<<LAP2.12   
    end;

    var
        CduGVersionMgt: Codeunit VersionManagement;
        CodGActiveVersionCode: Code[20];

}
