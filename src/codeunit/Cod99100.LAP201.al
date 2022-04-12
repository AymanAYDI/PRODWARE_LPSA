codeunit 99100 "PWD LAP2.01"
{
    // +----------------------------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                                                |
    // | www.prodware.fr                                                                                                                  |
    // +----------------------------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.01
    // 
    // 1  27        Item                                       NAVW16.00.01,NAVCH6.00.01,LAP2.01,ProdConnect1.5,PLAW11.0
    // 1  5407      Prod. Order Component                      NAVW16.00.01,NAVCH3.70.01,LAP2.01
    // 1  50008     Lot Size                                   LAP2.01
    // 1  50009     Lot Size Standard Cost                     LAP2.01
    // 1  8073320   Item Jounal Line Buffer                    ProdConnect1.6,LAP2.01
    // 1  99000765  Manufacturing Setup                        NAVW16.00,LAP2.01
    // 
    // 2  5510      Production Journal                         NAVW16.00.01,LAP2.01
    // 2  50010     Lot Size List                              LAP2.01
    // 2  50011     Lot Size Std. Cost List                    LAP2.01
    // 2  8073320   Item Journal Line Buffer                   ProdConnect1.6,LAP2.01
    // 2  99000823  Output Journal                             NAVW16.00,LAP2.01
    // 
    // 3  50000     Export Invoicing Data (Excel)              LAP2.01
    // 3  50003     Purchase - Return Shipment LAP             LAP2.01
    // 3  50004     Purchase - Quote LAP                       LAP2.01
    // 3  50005     Order LAP                                  LAP2.01
    // 3  50006     Proforma invoice                           LAP2.01
    // 3  50007     Production Balance                         LAP2.01
    // 3  50008     Sales Quote                                LAP2.01
    // 3  50009     Sales Order Confirmation                   LAP2.01
    // 3  50010     Real Std Comparison Routing                LAP2.01
    // 3  50011     Soumission                                 LAP2.01
    // 3  50012     Shipment Advice                            LAP2.01
    // 3  50013     Credit Note                                LAP2.01
    // 3  50014     Invoice                                    LAP2.01
    // 
    // 5  5812      Calculate Standard Cost                    NAVW16.00.01,LAP2.01
    // 5  6500      Item Tracking Management                   NAVW16.00.01,ProdConnect1.5,LAP2.01
    // 5  50002     Lot Inheritance Mgt.PW                     LAP2.01
    // 5  50003     Trading Unit Mgt.PW                        LAP2.01
    // 5  99100     LAP2.01                                    LAP2.01
    // 5  8073291   Buffer Management                          ProdConnect1.6,LAP2.01
    // 5  99000773  Calculate Prod. Order                      NAVW14.00.01,LAP2.01
    // 5  99000809  Planning Line Management                   NAVW16.00.01,LAP2.01
    // 5  99000813  Carry Out Action                           NAVW16.00.01,LAP2.01,PLAW11.0
    // 5  99000835  Item Jnl. Line-Reserve                     NAVW16.00.01,LAP2.01
    // 5  99000837  Prod. Order Line-Reserve                   NAVW16.00.01,LAP2.01
    // 5  99000838  Prod. Order Comp.-Reserve                  NAVW16.00.01,LAP2.01
    // 5  99000840  Plng. Component-Reserve                    NAVW16.00.01,LAP2.01
    // 
    // 6  8073322   Import Prod OSYS                           ProdConnect1.6,LAP2.01
    // 
    // 7  1080      Dept - Partner                             LAP2.01
    // 
    // 8  30        Item Card                                  NAVW16.00.01,NAVDACH4.00,NAVCH6.00.01,LAP2.01,ProdConnect1.5,PLAW11.0
    // 8  6510      Item Tracking Lines                        NAVW16.00.01,LAP2.01
    // 8  9305      Sales Order List                           NAVW16.00.01,LAP2.01
    // 8  50007     Manuf. cycles Setup - List                 LAP2.01
    // 8  50010     Lot Size List                              LAP2.01
    // 8  50011     Lot Size Std. Cost List                    LAP2.01
    // 8  8073320   Item Journal Line Buffer                   ProdConnect1.6,LAP2.01
    // 8  99000818  Prod. Order Components                     NAVW16.00.01,LAP2.01
    // 
    // +----------------------------------------------------------------------------------------------------------------------------------+


    trigger OnRun()
    begin
    end;
}

