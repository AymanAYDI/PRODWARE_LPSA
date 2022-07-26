table 8073289 "PWD OSYS Setup"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // //>>ProdConnect1.6
    // OSYS-Int001.001:GR 18/10/2011   Connector integration
    //                              - Create Object
    // 
    // //>>ProdConnect1.07.02.02
    // OSYS-Int001.002:GR 07/02/2012   Connector integration
    //                                 Add field :PlannerOne
    // 
    // //>>LAP2.06
    // FE_LAPRIERRETTE_GP0004.001 :GR  23/05/13  : - Add Field :  Possible Items Message
    // 
    // //>>LAP2.06.01
    // FE_LAPRIERRETTE_GP0004.002 :GR  15/07/13  : - Add Fields :  Journal Templ Name Prod 1
    //                                                             Journal Batch Name Prod 1
    // 
    // //>>LAP2.22
    // P24578_009: RO : 12/12/2019 : cf Demande par mail
    //                   - Add Fields 50003 to 50006
    // 
    // +----------------------------------------------------------------------------------------------------------------+

    Caption = 'OSYS Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[20])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(2; OSYS; Boolean)
        {
            Caption = 'OSYS';
            DataClassification = CustomerContent;
        }
        field(3; "Journal Templ Name Prod"; Code[10])
        {
            Caption = 'Steel Journal Template Name Prod';
            TableRelation = "Item Journal Template";
            DataClassification = CustomerContent;
        }
        field(4; "Journal Batch Name Prod"; Code[10])
        {
            Caption = 'Steel Journal Batch Name Prod';
            TableRelation = "Item Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Templ Name Prod"));
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                FrmGItemJournalBatches: Page "Item Journal Batches";
            begin
                CLEAR(FrmGItemJournalBatches);
                RecGItemJnlBatch.RESET();
                RecGItemJnlBatch.SETRANGE("Journal Template Name", "Journal Templ Name Prod");
                FrmGItemJournalBatches.LOOKUPMODE := TRUE;
                FrmGItemJournalBatches.SETRECORD(RecGItemJnlBatch);
                FrmGItemJournalBatches.SETTABLEVIEW(RecGItemJnlBatch);
                IF (FrmGItemJournalBatches.RUNMODAL() = ACTION::LookupOK) THEN BEGIN
                    FrmGItemJournalBatches.GETRECORD(RecGItemJnlBatch);
                    VALIDATE("Journal Batch Name Prod", RecGItemJnlBatch.Name);
                END;
            end;
        }
        field(5; "Separator Character"; Code[1])
        {
            Caption = 'Separator Character';
            DataClassification = CustomerContent;
        }
        field(6; "Packaging Unit"; Code[10])
        {
            Caption = 'Packaging Unit';
            TableRelation = "Unit of Measure".Code;
            DataClassification = CustomerContent;
        }
        field(7; "Pallet  Unit"; Code[10])
        {
            Caption = 'Pallet  Unit';
            TableRelation = "Unit of Measure".Code;
            DataClassification = CustomerContent;
        }
        field(8; "Journal Templ Name Cons"; Code[10])
        {
            Caption = 'Journal Template Name Cons';
            TableRelation = "Item Journal Template";
            DataClassification = CustomerContent;
        }
        field(9; "Journal Batch Name Cons"; Code[10])
        {
            Caption = 'Journal Batch Name Cons';
            TableRelation = "Item Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Templ Name Cons"));
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                FrmGItemJournalBatches: Page "Item Journal Batches";
            begin
                CLEAR(FrmGItemJournalBatches);
                RecGItemJnlBatch.RESET();
                RecGItemJnlBatch.SETRANGE("Journal Template Name", "Journal Templ Name Cons");
                FrmGItemJournalBatches.LOOKUPMODE := TRUE;
                FrmGItemJournalBatches.SETRECORD(RecGItemJnlBatch);
                FrmGItemJournalBatches.SETTABLEVIEW(RecGItemJnlBatch);
                IF (FrmGItemJournalBatches.RUNMODAL() = ACTION::LookupOK) THEN BEGIN
                    FrmGItemJournalBatches.GETRECORD(RecGItemJnlBatch);
                    VALIDATE("Journal Batch Name Cons", RecGItemJnlBatch.Name);
                END;
            end;
        }
        field(10; "Partner Code"; Code[20])
        {
            Caption = 'Partner Code';
            TableRelation = "PWD Partner Connector".Code;
            DataClassification = CustomerContent;
        }
        field(11; PlannerOne; Boolean)
        {
            Caption = 'PlannerOne';
            DataClassification = CustomerContent;
        }
        field(50000; "Possible Items Message"; Code[20])
        {
            Caption = 'Possible Items Message';
            TableRelation = "PWD Connector Messages".Code WHERE("Partner Code" = FIELD("Partner Code"), Direction = CONST(Export));
            DataClassification = CustomerContent;
        }
        field(50001; "Journal Templ Name Prod 1"; Code[10])
        {
            Caption = 'Other Journal Template Name Prod';
            TableRelation = "Item Journal Template";
            DataClassification = CustomerContent;
        }
        field(50002; "Journal Batch Name Prod 1"; Code[10])
        {
            Caption = 'Other Journal Batch Name Prod';
            TableRelation = "Item Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Templ Name Prod 1"));
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                FrmGItemJournalBatches: Page "Item Journal Batches";
            begin
                //>>FE_LAPRIERRETTE_GP0004.002
                CLEAR(FrmGItemJournalBatches);
                RecGItemJnlBatch.RESET();
                RecGItemJnlBatch.SETRANGE("Journal Template Name", "Journal Templ Name Prod 1");
                FrmGItemJournalBatches.LOOKUPMODE := TRUE;
                FrmGItemJournalBatches.SETRECORD(RecGItemJnlBatch);
                FrmGItemJournalBatches.SETTABLEVIEW(RecGItemJnlBatch);
                IF (FrmGItemJournalBatches.RUNMODAL() = ACTION::LookupOK) THEN BEGIN
                    FrmGItemJournalBatches.GETRECORD(RecGItemJnlBatch);
                    VALIDATE("Journal Batch Name Prod 1", RecGItemJnlBatch.Name);
                END;
                //<<FE_LAPRIERRETTE_GP0004.002
            end;
        }
        field(50003; "Journal Templ Name Stock MVT"; Code[10])
        {
            Caption = 'Journal Templ Name Stock MVT';
            Description = 'LAP2.22';
            TableRelation = "Item Journal Template";
            DataClassification = CustomerContent;
        }
        field(50004; "Journal Batch Name Stock MVT"; Code[10])
        {
            Caption = 'Journal Batch Name Stock MVT';
            Description = 'LAP2.22';
            TableRelation = "Item Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Templ Name Stock MVT"));
            DataClassification = CustomerContent;
        }
        field(50005; "Journal Templ Name Stock TRF"; Code[10])
        {
            Caption = 'Journal Templ Name Stock TRF';
            Description = 'LAP2.22';
            TableRelation = "Item Journal Template";
            DataClassification = CustomerContent;
        }
        field(50006; "Journal Batch Name Stock TRF"; Code[10])
        {
            Caption = 'Journal Batch Name  Stock TRF';
            Description = 'LAP2.22';
            TableRelation = "Item Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Templ Name Stock TRF"));
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        RecGItemJnlBatch: Record "Item Journal Batch";

    procedure FctUnitOfMeasureModify(RecPXIUOM: Record "Item Unit of Measure"; RecPIUOM: Record "Item Unit of Measure")
    var
        RecLItem: Record Item;
        RecLOSYSSetup: Record "PWD OSYS Setup";
    begin
        RecLOSYSSetup.GET();
        IF (RecPXIUOM."Qty. per Unit of Measure" <> RecPIUOM."Qty. per Unit of Measure") AND
           ((RecPXIUOM.Code = RecLOSYSSetup."Packaging Unit") OR (RecPXIUOM.Code = RecLOSYSSetup."Pallet  Unit")) THEN BEGIN
            RecLItem.GET(RecPIUOM."Item No.");
            RecLItem."Last Date Modified" := TODAY;
            RecLItem.MODIFY();
        END;
    end;
}

