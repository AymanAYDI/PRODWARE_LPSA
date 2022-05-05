tableextension 60036 "PWD ProductionOrder" extends "Production Order"
{
    //TODO: 1- suppression une instruction standard dans le champ Description, 
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                 |
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
        // field(50004; "PWD Prod. Starting Date-Time"; DateTime)
        // {
        //     //TODO le champ "Prod. Starting Date-Time" n'existe pas dans la table extension de "Prod. Order Line"    
        //     // CalcFormula = Min("Prod. Order Line"."PWD Prod. Starting Date-Time" WHERE(Status = FIELD(Status), "Prod. Order No." = FIELD("No.")));
        //     Caption = 'Prod. Starting Date-Time';
        //     Description = 'Starting Date-Time of the first operation as planned in PlannerOne.';
        //     FieldClass = FlowField;
        // }
        // field(50005; "PWD Prod. Ending Date-Time"; DateTime)
        // {
        //     //TODO  le champ "Prod. Starting Date-Time" n'existe pas dans la table extension de "Prod. Order Line"      
        //     //CalcFormula = Max("Prod. Order Line"."PWD Prod. Ending Date-Time" WHERE(Status = FIELD(Status), "Prod. Order No." = FIELD("No.")));
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
            CalcFormula = Min("Item Ledger Entry"."Posting Date" WHERE("Order No." = FIELD("No.")));
            Caption = 'Consumption Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50011; "PWD Component No."; Code[20])
        {
            Caption = 'Component Quantity';
            Editable = false;
        }
        field(50020; "PWD Source Material Vendor"; Enum "PWD Source Material Vendor")
        {
            Caption = 'Source Material Vendor';
            Description = 'LAP2.12';
        }
    }
    keys
    {
        key(Key50000; "Due Date", "Source No.") { }
        key(Key50001; "PWD Component No.") { }
        //TODO: "Starting Date" is marked for removal
        //key(Key50002; "Starting Date") { }
    }
    procedure ResendProdOrdertoQuartis()
    var
        ProdOrderLine: Record "Prod. Order Line";
    begin
        if (Status = Status::Released) then begin
            ProdOrderLine.SETRANGE(Status, Status);
            ProdOrderLine.SETRANGE("Prod. Order No.", "No.");
            if ProdOrderLine.FINDFIRST() then
                REPEAT
                    //TODO la table extension de "Prod. Order Line" n'existe pas      
                    ProdOrderLine.ResendProdOrdertoQuartis();
                UNTIL ProdOrderLine.NEXT() = 0;
        end;
    end;

    PROCEDURE CheckComponentAvailabilty() IsNotAvailable: Boolean;
    VAR
        ProdOrderLine: Record "Prod. Order Line";
        BooLIsNotAvailable: Boolean;
    BEGIN
        BooLIsNotAvailable := FALSE;
        ProdOrderLine.RESET();
        ProdOrderLine.SETRANGE(Status, Status);
        ProdOrderLine.SETRANGE("Prod. Order No.", "No.");
        IF ProdOrderLine.FINDFIRST() THEN
            REPEAT
                //TODO la table extension de "Prod. Order Line" n'existe pas      
                BooLIsNotAvailable := ProdOrderLine.CheckComponentAvailabilty();
            UNTIL (BooLIsNotAvailable) OR (ProdOrderLine.NEXT() = 0);
        EXIT(BooLIsNotAvailable);
    END;

    PROCEDURE ComponentInv() Qty: Decimal;
    VAR
        RecLItem: Record Item;
        RecLProdOrderComponent: Record "Prod. Order Component";
        DecLInv: Decimal;
    BEGIN
        DecLInv := 0;
        RecLProdOrderComponent.RESET();
        RecLProdOrderComponent.SETRANGE(Status, Status);
        RecLProdOrderComponent.SETRANGE("Prod. Order No.", "No.");
        IF RecLProdOrderComponent.FINDFIRST() THEN
            REPEAT
                RecLItem.GET(RecLProdOrderComponent."Item No.");
                RecLItem.SETFILTER("Location Filter", '=%1', RecLProdOrderComponent."Location Code");
                RecLItem.CALCFIELDS(Inventory);
                DecLInv += RecLItem.Inventory;
            UNTIL RecLProdOrderComponent.NEXT() = 0;
        EXIT(DecLInv);
    END;

    PROCEDURE FctPrintPDF();
    VAR
        //TODO: Automation
        // WshShell: Automation "{F935DC20-1CF0-11D0-ADB9-00C04FD58A0B} 1.0:{72C24DD5-D70A-438B-8A42-98424B88AFB8}:'Windows Script Host Object Model'.WshShell";
        ManufacturingSetup: Record "Manufacturing Setup";
        RecordLink: Record "Record Link";
        RecordIDLink: RecordID;
    BEGIN
        IF "Source Type" = "Source Type"::Item THEN BEGIN
            ManufacturingSetup.GET();
            //TODO: "PDF Exe Path" champ spécifique dans la table "Manufacturing Setup"
            //ManufacturingSetup.TESTFIELD("PDF Exe Path");
            EVALUATE(RecordIDLink, 'Item: ' + "Source No.");
            RecordLink.RESET();
            RecordLink.SETRANGE("Record ID", RecordIDLink);
            RecordLink.SETRANGE(Type, RecordLink.Type::Link);
            RecordLink.SETFILTER(Description, "Source No." + '*');
            //TODO
            // CREATE(WshShell, FALSE, TRUE);
            // IF RecordLink.FINDFIRST THEN
            //     REPEAT
            //         // On vérifie que le fichier est bien un PDF
            //         IF UPPERCASE(COPYSTR(RecordLink.Description, STRLEN(RecordLink.Description) - 3, 4)) = '.PDF' THEN
            //             WshShell.Run('"' + ManufacturingSetup."PDF Exe Path" + '" /t "' + RecordLink.URL1 + '"');
            //     //MEssage('"%1" /t "%2"',RecLManufacturingSetup."PDF Exe Path",RecLRecordLink.URL1);
            //     UNTIL RecordLink.NEXT = 0;
        END;
    END;
}
