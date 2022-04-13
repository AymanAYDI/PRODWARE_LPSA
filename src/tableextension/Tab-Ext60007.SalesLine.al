tableextension 60007 "PWD SalesLine" extends "Sales Line"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.5
    // WMS-FE05.001:GR  01/07/2011   Connector integration
    //                              - Add fields:  "WMS_Status", "WMS_Item", "WMS_Location", "WMS_Status_Header", "WMS_Cust_Bloked"
    //                              - If WMS Location is default quantity
    //                              - If WMS Status isn't empty, the line is lock
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_VTE03.001: NI 23/11/2011:  Prix de vente forfaitaire
    //                                           - Add field 50000
    //                                           - Add C/AL in function UpdateUnitPrice()
    // 
    // FE_LAPIERRETTE_ART02.001: NI 23/11/2011:  Désignation article 120 caracteres
    //                                           - Add field 50004..50005
    //                                           - Add C/AL in trigger "No. - OnValidate"
    //                                                                 "Description - OnValidate"
    //                                                                 "Description 2 - OnValidate"
    //                                                                 "LPSA Description 1 - OnValidate"
    //                                                                 "LPSA Description 2 - OnValidate"
    // 
    // TDL.LPSA.001 : NI 19/01/2014       Add "Initial Shipment Date"
    //                                           - Add field 50006
    // 
    // TDL.LPSA.20.04.15:APA 20/04/15: Add Field Cust Promised Delivery Date
    //                                 Add C/AL in trigger "No. - OnValidate"
    // 
    // TDL.LPSA.17.05.15:NBO 17/05/15: Removed date auto. updates
    // 
    // TDL.LPSA.29.07.15:NBO 29/07/15: Keep Position No.
    //                                 Add C/AL in trigger "No. - OnValidate"
    // 
    // TDL.LPSA.13.11.15:NBO 13/11/15: Do not allow recalculation of unit price when sales order is confirmed.
    // 
    // //>>MODIF HL
    // TI297099 DO.GEPO 16/10/2015 : add field 50010 and new key Document Type,Sell-to Customer No.,Cust Promised Delivery Date
    // 
    // //>>TDL.216
    // TDL.LPSA.216:CSC 04/12/15 : add new key "Document Type,Type,No.,Cust Promised Delivery Date"
    // 
    // //>>MODIF HL
    // TI317966 DO.GEPO 08/03/2016 : add field 50050
    // 
    // //>>MODIF HL
    // TI516919 DO.GEPO 25/11/2020 : add COMMIT in CheckItemAvailable because error C/AL runmodal
    // 
    // ------------------------------------------------------------------------------------------------------------------
    fields
    {
        field(50000; "PWD Fixed Price"; Boolean)
        {
            Caption = 'Fixed Price';
            Description = 'LAP1.00';
            Editable = false;
        }
        field(50004; "PWD LPSA Description 1"; Text[120])
        {
            Caption = 'LPSA Description 1';
            Description = 'LAP1.00';

            trigger OnValidate()
            begin
                //>>FE_LAPIERRETTE_ART02.001
                IF STRLEN("PWD LPSA Description 1") > 50 THEN
                    Description := PADSTR("PWD LPSA Description 1", 50)
                ELSE
                    Description := "PWD LPSA Description 1";
                //<<FE_LAPIERRETTE_ART02.001
            end;
        }
        field(50005; "PWD LPSA Description 2"; Text[120])
        {
            Caption = 'LPSA Description 2';
            Description = 'LAP1.00';

            trigger OnValidate()
            begin
                //>>FE_LAPIERRETTE_ART02.001
                IF STRLEN("PWD LPSA Description 2") > 50 THEN
                    "Description 2" := PADSTR("PWD LPSA Description 2", 50)
                ELSE
                    "Description 2" := "PWD LPSA Description 2";
                //<<FE_LAPIERRETTE_ART02.001
            end;
        }
        field(50006; "PWD Scrap Quantity"; Decimal)
        {
            Caption = 'Scrap Quantity';
        }
        field(50007; "PWD Initial Shipment Date"; Date)
        {
            Caption = 'Initial Shipment Date';
        }
        field(50008; "PWD Cust Promised Delivery Date"; Date)
        {
            Caption = 'Customer Promised Delivery Date';
            Description = 'TDL.LPSA';

            trigger OnValidate()
            begin
                TestStatusOpen;
            end;
        }
        field(50010; "PWD Name of Sell-to Customer No."; Text[100])
        {
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Sell-to Customer No.")));
            Caption = 'Name of Sell-to Customer No.';
            Description = 'SU TI297099';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50050; "PWD Order Date"; Date)
        {
            CalcFormula = Lookup("Sales Header"."Order Date" WHERE("No." = FIELD("Document No."), "Document Type" = FIELD("Document Type")));
            Caption = 'Order Date';
            Description = 'SU';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8073282; "PWD WMS_Status"; Enum "PWD Status")
        {
            Caption = 'WMS_Status';
            Description = 'ProdConnect1.5';
        }
        field(8073283; "PWD WMS_Status_Header"; Enum "Sales Document Status")
        {
            CalcFormula = Lookup("Sales Header".Status WHERE("Document Type" = FIELD("Document Type"), "No." = FIELD("Document No.")));
            Caption = 'Status';
            Description = 'ProdConnect1.5';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8073284; "PWD WMS_Item"; Boolean)
        {
            CalcFormula = Lookup(Item."PWD WMS_Item" WHERE("No." = FIELD("No.")));
            Caption = 'WMS_Item';
            Description = 'ProdConnect1.5';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8073285; "PWD WMS_Location"; Boolean)
        {
            CalcFormula = Lookup(Location."PWD WMS_Location" WHERE(Code = FIELD("Location Code")));
            Description = 'ProdConnect1.5';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8073286; "PWD WMS_Cust_Blocked"; Enum "Customer Blocked")
        {
            CalcFormula = Lookup(Customer.Blocked WHERE("No." = FIELD("Sell-to Customer No.")));
            Description = 'ProdConnect1.5';
            Editable = false;
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(Key50000; "Shipment Date")
        {
        }
        //TODO
        // key(Key50001; "Document Type", "Sell-to Customer No.", "PWD Cust Promised Delivery Date")
        // {
        // }
        // key(Key50002; "Document Type", Type, "No.", "PWD Cust Promised Delivery Date")
        // {
        //     SumIndexFields = "Outstanding Qty. (Base)";
        // }
    }
    procedure FctDefaultQuantityIfWMS();
    var
        RecLLocation: Record Location;
    begin
        if RecLLocation.GET("Location Code") AND RecLLocation."PWD WMS_Location" then begin
            if ("Document Type" = "Document Type"::Order) OR ("Document Type" = "Document Type"::Quote) then begin
                "Qty. to Ship" := 0;
                "Qty. to Ship (Base)" := 0;
                "Qty. to Invoice" := 0;
                "Qty. to Invoice (Base)" := 0;
            end;
            if "Document Type" = "Document Type"::"Return Order" then begin
                "Return Qty. to Receive" := 0;
                "Return Qty. to Receive (Base)" := 0;
                "Qty. to Invoice" := 0;
                "Qty. to Invoice (Base)" := 0;
            end;
        end;
    end;

    procedure FctFromImport(BooPFromImport: Boolean)
    var
        BooGFromImport: Boolean;
    begin
        BooGFromImport := BooPFromImport;
    end;
}

