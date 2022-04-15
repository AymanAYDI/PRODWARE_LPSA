codeunit 8073311 "Connectors Journal Valid Batch"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.07.01
    // WMS-EBL1-003.001.001:GR 05/01/2012   Connector integration
    //                                      - Create Object
    // 
    // 
    // //>>LAP2.06.01
    // FE_LAPRIERRETTE_GP0004.002 :GR  15/07/13  : - Add C\AL in  OnRun()
    // 
    // //>>LAP2.22
    // P24578_009: RO : 12/12/2019 : cf Demande par mail
    //                   -Add C\AL Code in trigger OnRun()
    // 
    // 
    // +----------------------------------------------------------------------------------------------------------------+


    trigger OnRun()
    begin
        if RecGOsysSetup.Get() then
            if RecGOsysSetup.OSYS then begin
                if ((RecGOsysSetup."Journal Templ Name Prod" <> '') and (RecGOsysSetup."Journal Batch Name Prod" <> '')) then
                    CduGBufferManagment.FctValidateItemJournaLineBatch(RecGOsysSetup."Journal Templ Name Prod",
                                              RecGOsysSetup."Journal Batch Name Prod");

                if ((RecGOsysSetup."Journal Templ Name Cons" <> '') and (RecGOsysSetup."Journal Batch Name Cons" <> '')) then
                    CduGBufferManagment.FctValidateItemJournaLineBatch(RecGOsysSetup."Journal Templ Name Cons",
                                              RecGOsysSetup."Journal Batch Name Cons");

                //>>FE_LAPRIERRETTE_GP0004.002
                if ((RecGOsysSetup."Journal Templ Name Prod 1" <> '') and (RecGOsysSetup."Journal Batch Name Prod 1" <> '')) then
                    CduGBufferManagment.FctValidateItemJournaLineBatch(RecGOsysSetup."Journal Templ Name Prod 1",
                                              RecGOsysSetup."Journal Batch Name Prod 1");

                //<<FE_LAPRIERRETTE_GP0004.002

                //>>LAP2.22
                if ((RecGOsysSetup."Journal Templ Name Stock MVT" <> '') and (RecGOsysSetup."Journal Batch Name Stock MVT" <> '')) then
                    CduGBufferManagment.FctValidateItemJournaLineBatch(RecGOsysSetup."Journal Templ Name Stock MVT",
                                              RecGOsysSetup."Journal Batch Name Stock MVT");
                if ((RecGOsysSetup."Journal Templ Name Stock TRF" <> '') and (RecGOsysSetup."Journal Batch Name Stock TRF" <> '')) then
                    CduGBufferManagment.FctValidateItemJournaLineBatch(RecGOsysSetup."Journal Templ Name Stock TRF",
                                              RecGOsysSetup."Journal Batch Name Stock TRF");
                //<<LAP2.22

            end;
        /*
        IF RecGWmsSetup.GET THEN
          IF RecGWmsSetup.WMS THEN
          BEGIN
            //Item Journal
        
            IF ((RecGWmsSetup."Journal Template Name" <> '') AND (RecGWmsSetup."Journal Batch Name" <> '')) THEN
              CduGBufferManagment.FctValidateItemJournaLineBatch(RecGWmsSetup."Journal Template Name" ,
                                        RecGWmsSetup."Journal Batch Name");
            COMMIT;
        
            //Purchase
            RepGBatchPostPurchOrders.USEREQUESTFORM(FALSE);
            RepGBatchPostPurchOrders.FctFromConnector();
            RepGBatchPostPurchOrders.FctSetWMSFilter();
            RepGBatchPostPurchOrders.RUN ;
            COMMIT;
        
            //Sale
            RepGBatchPostSalesOrders.USEREQUESTFORM(FALSE);
            RepGBatchPostPurchOrders.FctFromConnector();
            RepGBatchPostSalesOrders.FctSetFilterWMS();
            RepGBatchPostSalesOrders.RUN;
            COMMIT;
        
          END;
         */

    end;

    var
        RecGOsysSetup: Record "PWD OSYS Setup";
        CduGBufferManagment: Codeunit "Buffer Management";
}

