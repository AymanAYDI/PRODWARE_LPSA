tableextension 60006 "PWD SalesHeader" extends "Sales Header"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect.1.00
    // FE_ProdConnect.001:GR 22/03/2011  Connector integration
    //                                   - Add field 8073282 "Order No. From Partner"
    // 
    // //>>ProdConnect.1.5
    // WMS-FE05.001:GR 04/07/2001 :  Connector integration
    //                                   - Add Field 8073283 "WMS_Status"
    //                                   - Add Control on OnModify trigger
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_VTE06.001: NI 23/11/2011:  Statut Commande vente
    //                                           - Add field 50000..50001
    // 
    // FE_LAPIERRETTE_VTE01.001: TO 07/12/2011:  Export Role
    //                                           - Add field 50002 "Rolex Bienne"
    //                                           - Add C/AL in Trigger Sell-to Customer No. - OnValidate()
    // 
    // 
    // TDL.LPSA.20.04.15:APA 20/04/15: Geston commentaire client
    //                                 - Add C/AL in Trigger Sell-to customer No. - OnValidate()
    //                                 - Add C/AL in Trigger Bill-to customer No. - OnValidate()
    // 
    // TDL.LPSA.20.04.15:APA 20/04/15: Add Field Cust Promised Delivery Date
    //                                 Add C/AL in Function UpdateSalesLine
    // 
    // TDL.LPSA.17.05.15:NBO 17/05/15: Removed date auto. updates
    // 
    // TDL.LPSA.01.06.15:APA 01/06/15: Add Field Print confirmation Date
    // 
    // TDL.LPSA.05.10.15:NBO 05/10/15: Add Field 50005
    // 
    // ------------------------------------------------------------------------------------------------------------------
    fields
    {
        field(50000; "PWD ConfirmedLPSA"; Boolean)
        {
            Caption = 'Confirmed';
            Description = 'LAP1.00';
        }
        field(50001; "PWD Planned"; Boolean)
        {
            Caption = 'Planned';
            Description = 'LAP1.00';
        }
        field(50002; "PWD Rolex Bienne"; Boolean)
        {
            Caption = 'Rolex Bienne';
            Description = 'LAP1.00';
            Editable = false;
        }
        field(50003; "PWD Cust Promised Delivery Date"; Date)
        {
            Caption = 'Customer Promised Delivery Date';
            Description = 'TDL.LPSA';

            trigger OnValidate()
            begin
                //>>TDL.LPSA.20.04.15
                TESTFIELD(Status, Status::Open);
                IF "PWD Cust Promised Delivery Date" <> xRec."PWD Cust Promised Delivery Date" THEN
                    UpdateSalesLines(FIELDCAPTION("PWD Cust Promised Delivery Date"), CurrFieldNo <> 0);
                //<<TDL.LPSA.20.04.15
            end;
        }
        field(50004; "PWD Print confirmation Date"; Date)
        {
            Caption = 'Print confirmation Date';
            Description = 'TDL.LPSA';
            Editable = false;
        }
        field(50005; "PWD Validity Quote Date"; Date)
        {
            Caption = 'Validity Quote Date';
            Description = 'TDL.LPSA';
        }
        field(8073282; "PWD Order No. From Partner"; Code[20])
        {
            Caption = 'Order No. From Partner';
        }
        field(8073283; "PWD WMS_Status"; Enum "PWD WMS_Status")
        {
            Caption = 'WMS_Status';
            Description = 'ProdConnect1.5';
        }
    }
    PROCEDURE FctIsImport(BooPDontExecuteIfImport: Boolean);
    var
        DontExecuteIfImport: Boolean;
    BEGIN
        //>>WMS-FE05.001
        DontExecuteIfImport := BooPDontExecuteIfImport;
        //<<WMS-FE05.001
    END;



}

