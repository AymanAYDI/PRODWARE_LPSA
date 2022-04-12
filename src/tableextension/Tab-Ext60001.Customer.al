tableextension 60001 "PWD Customer" extends Customer
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_VTE01.001: TO 07/12/2011:  Export Role
    //                                           - Add field 50000 "Rolex Bienne"
    // 
    // ------------------------------------------------------------------------------------------------------------------
    //     PLAW1 -----------------------------------------------------------------------------
    // PLAW1-5.0              PO-3447: Customer geolocalisation
    // PLAW1 -----------------------------------------------------------------------------

    fields
    {
        field(50000; "PWD Rolex Bienne"; Boolean)
        {
            Caption = 'Rolex Bienne';
        }
        field(8076603; "PWD PlannerOneLatitude"; Decimal)
        {
            BlankZero = true;
            Caption = 'Latitude';
            DecimalPlaces = 0 : 10;
            MaxValue = 90;
            MinValue = -90;
        }
        field(8076604; "PWD PlannerOneLongitude"; Decimal)
        {
            BlankZero = true;
            Caption = 'Longitude';
            DecimalPlaces = 0 : 10;
            MaxValue = 180;
            MinValue = -180;
        }
    }
}

