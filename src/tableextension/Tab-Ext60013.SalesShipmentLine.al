tableextension 60013 "PWD SalesShipmentLine" extends "Sales Shipment Line"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.5
    // WMS-FE05.001:GR  01/07/2011   Connector integration
    //                              - Add fields:  "WMS_Status", "WMS_Item", "WMS_Location", "WMS_Status_Header", "WMS_Cust_Bloked"
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_ART02.001: NI 23/11/2011:  Désignation article 120 caracteres
    //                                           - Add field 50004..50005
    //                                           - C/AL Added in function InsertInvLineFromShptLine()
    // 
    // TDL.LPSA.001 : NI 19/01/2014       Add "Initial Shipment Date"
    //                                           - Add field 50006
    // 
    // TDL.LPSA.20.04.15:APA 20/04/15: Add Field Cust Promised Delivery Date
    // +----------------------------------------------------------------------------------------------------------------+
    fields
    {
        field(50004; "PWD LPSA Description 1"; Text[120])
        {
            Caption = 'LPSA Description 1';
            Description = 'LAP1.00';
        }
        field(50005; "PWD LPSA Description 2"; Text[120])
        {
            Caption = 'LPSA Description 2';
            Description = 'LAP1.00';
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
        }
        field(8073283; "PWD WMS_Status_Header"; Enum "PWD WMS_Status_Header") 
        {
            Caption = 'Status';
            Description = 'ProdConnect1.5';
            Editable = false;
        }
        field(8073284; "PWD WMS_Item"; Boolean)
        {
            CalcFormula = Lookup(Item."PWD WMS_Item" WHERE("No." = FIELD("No.")));
            Caption = 'WMS_Item';
            Description = 'ProdConnect1.5';
            FieldClass = FlowField;
        }
        field(8073285; "PWD WMS_Location"; Boolean)
        {
            CalcFormula = Lookup(Location."PWD WMS_Location" WHERE(Code = FIELD("Location Code")));
            Description = 'ProdConnect1.5';
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
}

