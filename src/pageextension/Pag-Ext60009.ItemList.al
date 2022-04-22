pageextension 60009 "PWD ItemList" extends "Item List"
{
    layout
    {
        addafter(Description)
        {
            field("PWD LPSA Description 1"; "PWD LPSA Description 1")
            {
                ApplicationArea = All;

            }
            field("PWD LPSA Description 2"; "PWD LPSA Description 2")
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
                    RecLRtngVersion.SETRANGE("Routing No.", "Routing No.");
                    RecLRtngVersion.SETRANGE("Version Code", CodGActiveVersionCode);
                    Page.RUNMODAL(Page::"Routing Version", RecLRtngVersion);
                    CodGActiveVersionCode := CduGVersionMgt.GetRtngVersion("Routing No.", WORKDATE(), TRUE);
                    //<<LAP2.12
                end;
            }
        }
        addafter("Base Unit of Measure")
        {
            field("PWD Location Code"; "Location Code")
            {
                ApplicationArea = All;

            }
        }
        addafter("Unit Price")
        {
            field("PWD Reordering Policy"; "Reordering Policy")
            {
                ApplicationArea = All;

            }
        }
        addafter("Indirect Cost %")
        {
            field("PWD Minimum Order Quantity"; "Minimum Order Quantity")
            {
                ApplicationArea = All;

            }
            field("PWD Maximum Order Quantity"; "Maximum Order Quantity")
            {
                ApplicationArea = All;

            }

        }
        addafter(Blocked)
        {
            field("PWD Phantom Item"; "PWD Phantom Item")
            {
                ApplicationArea = All;
            }
        }
        addafter("Item Tracking Code")
        {
            field("PWD Customer Plan No."; "PWD Customer Plan No.")
            {
                ApplicationArea = All;

            }
            field("PWD Customer Plan Description"; "PWD Customer Plan Description")
            {
                ApplicationArea = All;

            }

            field("PWD LPSA Plan No."; "PWD LPSA Plan No.")
            {
                ApplicationArea = All;

            }
            field("PWD Inventory"; Inventory)
            {
                ApplicationArea = All;

            }
            field("PWD Barcode"; "PWD Barcode")
            {
                ApplicationArea = All;

            }
            field("PWD Phantom Item2"; "PWD Phantom Item")
            {
                ApplicationArea = All;

            }

            field("PWD Order Multiple"; "Order Multiple")
            {
                ApplicationArea = All;

            }
            field("PWD Safety Stock Quantity"; "Safety Stock Quantity")
            {
                ApplicationArea = All;

            }
            field("PWD Lot Size"; "Lot Size")
            {
                ApplicationArea = All;

            }
            field("PWD Configurator Exists"; "PWD Configurator Exists")
            {
                editable = false;
                ApplicationArea = All;
            }
            field("PWD Plate Number"; "PWD Plate Number")
            {
                ApplicationArea = All;

            }
            field("PWD Part Number By Plate"; "PWD Part Number By Plate")
            {
                ApplicationArea = All;

            }
            field("PWD Reorder Point"; "Reorder Point")
            {
                ApplicationArea = All;

            }
            field("PWD Reorder Quantity"; "Reorder Quantity")
            {
                ApplicationArea = All;

            }
            field("PWD Global Dimension 1 Code"; "Global Dimension 1 Code")
            {
                ApplicationArea = All;

            }
            field("PWD Global Dimension 2 Code"; "Global Dimension 2 Code")
            {
                ApplicationArea = All;

            }
            field("PWD Reserve"; Reserve)
            {
                ApplicationArea = All;

            }
            field("PWD Safety Lead Time"; "Safety Lead Time")
            {
                ApplicationArea = All;

            }

        }
        modify("Shelf No.")
        {
            visible = true;
            editable = false;
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
                    CduLConnectorOSYSParseData.FctExportItemsPossibleManual("No.");
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
        CodGActiveVersionCode := CduGVersionMgt.GetRtngVersion("Routing No.", WORKDATE(), TRUE);
        //<<LAP2.12   
    end;

    var
        CduGVersionMgt: Codeunit VersionManagement;
        CodGActiveVersionCode: Code[20];

}
