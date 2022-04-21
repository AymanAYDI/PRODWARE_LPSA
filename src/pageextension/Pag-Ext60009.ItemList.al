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
                    RecLRtngVersion: Record 99000786;
                begin
                    //>>LAP2.12
                    RecLRtngVersion.SETRANGE("Routing No.", "Routing No.");
                    RecLRtngVersion.SETRANGE("Version Code", CodGActiveVersionCode);
                    Page.RUNMODAL(Page::"Routing Version", RecLRtngVersion);
                    CodGActiveVersionCode := CduGVersionMgt.GetRtngVersion("Routing No.", WORKDATE, TRUE);
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
            field("PWD Customer Plan Description"; "Customer Plan Description")
            {
                ApplicationArea = All;

            }

            field("PWD LPSA Plan No."; "LPSA Plan No.")
            {
                ApplicationArea = All;

            }
            field("PWD Inventory"; Inventory)
            {
                ApplicationArea = All;

            }
            field("PWD Barcode"; Barcode)
            {
                ApplicationArea = All;

            }
            field("PWD Phantom Item"; "Phantom Item")
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
            field("PWD Configurator Exists"; "Configurator Exists")
            {
                editable = false;
                ApplicationArea = All;
            }
            field("PWD Plate Number"; "Plate Number")
            {
                ApplicationArea = All;

            }
            field("PWD Part Number By Plate"; "Part Number By Plate")
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
    trigger OnAfterGetRecord()
    begin
        //>>LAP2.12
        CodGActiveVersionCode := CduGVersionMgt.GetRtngVersion("Routing No.", WORKDATE, TRUE);
        //<<LAP2.12   
    end;

    var
        CduGVersionMgt: Codeunit 99000756;
        CodGActiveVersionCode: Code[20];

}
