tableextension 60023 "PWD RequisitionLine" extends "Requisition Line"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_PROD01.001: TO 13/12/2011:  No Commande vente identique OF-LOT
    //                                           - Add fields 50000..50004
    // 
    // //>>LPSA.TDL
    // 14/04/2014 : Add Field 50009 : Add Field 50005
    // 15/10/2014 : Add new key : Worksheet Template Name,Journal Batch Name,Starting Date,No.,Location Code
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 12/09/2017 : DEMANDES DIVERSES
    //                                           - Change property InitValue = None for field 99000756
    // 
    // ------------------------------------------------------------------------------------------------------------------
    fields
    {
        field(50000; "PWD Original Source Id"; Integer)
        {
            Caption = 'Original Source Id';
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
        field(50003; "PWD Original Counter"; Integer)
        {
            Caption = 'Original Counter';
            Description = 'LAP1.00';
        }
        field(50004; "PWD Transmitted Order No."; Boolean)
        {
            Caption = 'Transmitted Order No.';
            Description = 'LAP1.00';
        }
        field(50005; "PWD Order Multiple"; Decimal)
        {
            CalcFormula = Lookup(Item."Order Multiple" WHERE("No." = FIELD("No.")));
            Caption = 'Order Multiple';
            DecimalPlaces = 0 : 5;
            FieldClass = FlowField;
            MinValue = 0;
        }
    }
}

