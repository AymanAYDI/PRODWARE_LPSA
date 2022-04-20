pageextension 60015 "PWD SalesOrderSubform" extends "Sales Order Subform"
{
    // #1..32
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.5
    // WMS-FE04.001:GR  12/08/2011   Connector integration
    //                              - Add fields:  "WMS_Status"
    //                              - Add field WMS_Item Not Visible
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_ART02.001: NI 23/11/2011:  Désignation article 120 caracteres
    //                                           - Display field 50004..50005
    // 
    // TDL.LPSA.001 : NI 19/01/2014       Add "Initial Shipment Date"
    //                                           - Add field 50006
    // 
    // TDL.LPSA.20.04.15:APA 20/04/15: - Display Field "Cust Promised Delivery Date" on Tab [GENERAL]
    // 
    // ------------------------------------------------------------------------------------------------------------------
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
        addafter(Quantity)
        {
            field("PWD Scrap Quantity"; "PWD Scrap Quantity")
            {
                ApplicationArea = All;
            }
        }
        addafter("Promised Delivery Date")
        {
            field("PWD Cust Promised Delivery Date"; "PWD Cust Promised Delivery Date")
            {
                ApplicationArea = All;
            }
        }
        addafter("Shipment Date")
        {
            field("PWD Initial Shipment Date"; "PWD Initial Shipment Date")
            {
                ApplicationArea = All;
            }
        }
        addafter("Appl.-to Item Entry")
        {
            field("PWD WMS_Status"; "PWD WMS_Status")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("PWD WMS_Item"; "PWD WMS_Item")
            {
                Visible = false;
                ApplicationArea = All;
            }
        }
    }
}

