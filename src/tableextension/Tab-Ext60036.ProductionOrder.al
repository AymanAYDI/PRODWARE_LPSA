tableextension 60036 "PWD ProductionOrder" extends "Production Order"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_PROD01.001: TO 13/12/2011:  No Commande vente identique OF-LOT
    //                                           - Add field 50000 50002
    // //PLAW11.0
    // FE_Merge: TO 23/01/2012:  Merge of pbjects Planner One
    //                                           - Add C/AL on triggers
    //                                              Starting Time - OnValidate
    //                                              Ending Time - OnValidate
    //                                              Due Date - OnValidate
    // 
    // //>>LAP2.06
    // FE_LAPRIERRETTE_GP0003 : APA 29/08/2013 : Add Field 50003
    // 
    // //>>LAP.TDL. NICO
    // 07/04/2014 : Add fields 50004, 50005
    // 07/04/2014 : Add function ResendProdOrdertoQuartis
    // 09/10/2014 : Add indicator (to know the component status) and Delay (between P1 ending date and NAV Ending Date)
    //               - Add fields 50006 and 50007
    //               - Add function CheckComponentAvailabilty
    // 19/11/2014 : Add field 50008 et 50009
    // 19/11/2014 : Add Key "Due Date" / "Source No."
    // 19/01/2015 : Search Description From the item Card
    // 19/02/2015 : Add "Consumption Date"
    // 
    // TDL.LPSA.002  Add Field "Component No."
    //               Add Key "Compononen No."
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 12/09/2017 : DEMANDES DIVERSES
    //                   - Add Field 50020 - Source Material Vendor No. - Option
    // 
    // //>>REGIE
    // P24578_005 : LALE.RO : 24/10/2018 Demande par Mail
    //                - Add Function FctPrintPDF
    // 
    // //>>REGIE
    // P24578_009 : LALE.RO : 10/10/2019 Demande par Mail
    //                - Add Option MIXTE  for Field 50020
    // 
    // ------------------------------------------------------------------------------------------------------------------
    fields
    {
        field(50000; "PWD Transmitted Order No."; Boolean)
        {
            Caption = 'Transmitted Order No.';
            Description = 'LAP1.00';
        }
        field(50001; "PWD Original Source No."; Code[20])
        {
            Caption = 'Original Source No.';
            Description = 'LAP1.00';
        }
        field(50002; "PWD Original Source Position"; Integer)
        {
            Caption = 'Original Source Position';
            Description = 'LAP1.00';
        }
        field(50003; "PWD Selection"; Boolean)
        {
        }
        //TODO        // field(50004; "PWD Prod. Starting Date-Time"; DateTime)
        // {
        //     CalcFormula = Min("Prod. Order Line"."PWD Prod. Starting Date-Time" WHERE(Status = FIELD(Status), "Prod. Order No." = FIELD("No.")));
        //     Caption = 'Prod. Starting Date-Time';
        //     Description = 'Starting Date-Time of the first operation as planned in PlannerOne.';
        //     FieldClass = FlowField;
        // }
        // field(50005; "PWD Prod. Ending Date-Time"; DateTime)
        // {
        //     CalcFormula = Max("Prod. Order Line"."PWD Prod. Ending Date-Time" WHERE(Status = FIELD(Status), "Prod. Order No." = FIELD("No.")));
        //     Caption = 'Prod. Ending Date-Time';
        //     Description = 'Ending Date-Time of the last operation as planned in PlannerOne.';
        //     FieldClass = FlowField;
        // }
        field(50006; "PWD Indicator"; BLOB)
        {
            Caption = 'Component availability';
            SubType = Bitmap;
        }
        field(50007; "PWD Delay"; Integer)
        {
            CalcFormula = Max("Prod. Order Line"."PWD Delay" WHERE(Status = FIELD(Status), "Prod. Order No." = FIELD("No.")));
            Caption = 'Delay';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50008; "PWD Order Multiple"; Decimal)
        {
            CalcFormula = Lookup(Item."Order Multiple" WHERE("No." = FIELD("Source No.")));
            Caption = 'Order Multiple';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
            MinValue = 0;
        }
        field(50009; "PWD Component Quantity"; Decimal)
        {
            CalcFormula = Max("Prod. Order Component"."Expected Quantity" WHERE(Status = FIELD(Status), "Prod. Order No." = FIELD("No.")));
            Caption = 'Component Quantity';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50010; "PWD Consumption Date"; Date)
        {
            CalcFormula = Min("Item Ledger Entry"."Posting Date" WHERE("Prod. Order No." = FIELD("No.")));
            Caption = 'Consumption Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50011; "PWD Component No."; Code[20])
        {
            Caption = 'Component Quantity';
            Editable = false;
        }
        field(50020; "PWD Source Material Vendor"; Option)
        {
            Caption = 'Source Material Vendor';
            Description = 'LAP2.12';
            OptionCaption = ' ,DJEVA,RSA,MIXTE';
            OptionMembers = " ",DJEVA,RSA,MIXTE;
        }
    }
}

