tableextension 60028 "PWD TrackingSpecification" extends "Tracking Specification"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_PROD01.001:GR 14/02/2012:  Order No, OF and LOT
    //                               -Add fields 50000 to 50002
    // 
    // //>>LAP2.05
    // FE_LAPIERRETTE_PRO12.001: GR 09/10/2012: Non Conformite
    //                                          - Add Field
    //                                            NC
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    fields
    {
        field(50000; "PWD Lot Number"; Code[20])
        {
            Caption = 'Lot Number';
            Description = '#803/01:A3013-1/2.10';

            trigger OnValidate()
            begin
                IF "PWD Lot Number" = '' THEN
                    "PWD Trading Unit Number" := '';
            end;
        }
        field(50001; "PWD Trading Unit Number"; Code[20])
        {
            Caption = 'Trading Unit Number';
            Description = '#803/01:A3013-1/2.10';

            trigger OnValidate()
            begin
                TESTFIELD("PWD Lot Number");
                IF "PWD Trading Unit Number" <> '' THEN
                    VALIDATE("PWD No. of Units", 1);
            end;
        }
        field(50002; "PWD No. of Units"; Integer)
        {
            Caption = 'No. of Units';
            Description = '#NAV20100:A1017 20.08.07 TECTURA.SE';
            InitValue = 1;
        }
        field(50003; "PWD NC"; Boolean)
        {
            caption = 'NC';
            Description = 'LAP2.05';
            Editable = false;
        }
    }
}

