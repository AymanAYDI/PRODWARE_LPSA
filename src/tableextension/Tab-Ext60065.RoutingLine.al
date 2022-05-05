tableextension 60065 "PWD RoutingLine" extends "Routing Line"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_PROD04.001: NI 13/12/2011:  FRAPPES - Temps de cycle incompressible
    //                                           - Add field 50000
    // ------------------------------------------------------------------------------------------------------------------
    // PLAW1 -----------------------------------------------------------------------------
    // PLAW1-4.0   2014-02-06 PO-3706: add SetupAggregationRule
    // PLAW1 -----------------------------------------------------------------------------
    // 
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 20/06/2017 :  DEMANDES DIVERSES
    //                - Add Field 50001 - Flushing Method - Option
    //                - Add C/AL Code in triggers WorkCenterTransferfields()
    //                                            MachineCtrTransferfields()
    fields
    {
        field(50000; "PWD Fixed-step Prod. Rate time"; Boolean)
        {
            Caption = 'Fixed-step Prod. Rate time';
            Description = 'LAP1.00';
        }
        field(50001; "PWD Flushing Method"; Enum "Flushing Method Routing")
        {
            Caption = 'Flushing Method';
            Description = 'LAP2.12';
            Editable = false;
            InitValue = Manual;
        }

    }
}
