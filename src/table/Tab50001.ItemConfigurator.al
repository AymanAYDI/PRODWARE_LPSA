table 50001 "PWD Item Configurator"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_ART01.001: TO 07/12/2011:  Configurateur article
    //                                           - Create Table
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 20/06/2017 :  CONFIGURATEUR ARTICLES
    //                - Add Field 50004 - Create From Item - Boolean
    // 
    // ------------------------------------------------------------------------------------------------------------------

    Caption = 'Item Configurator';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; BigInteger)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(2; "Family Code"; Code[2])
        {
            Caption = 'Family Code';
            TableRelation = "PWD Family LPSA".Code;
            DataClassification = CustomerContent;
        }
        field(3; "Subfamily Code"; Code[3])
        {
            Caption = 'Subfamily Code';
            TableRelation = "PWD SubFamily LPSA".Code WHERE("Family Code" = FIELD("Family Code"));
            DataClassification = CustomerContent;
        }
        field(4; "Phantom Item"; Boolean)
        {
            Caption = 'Phantom Item';
            DataClassification = CustomerContent;
        }
        field(5; "Item Template Code"; Code[10])
        {
            Caption = 'Item Template Code';
            TableRelation = "Config. Template Header".Code WHERE("Table ID" = CONST(27));
            DataClassification = CustomerContent;
        }
        field(6; "Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(7; "Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        }
        field(8; "Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Dimension 3 Code';
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                RecLDimensionValue: Record "Dimension Value";
                RecLGeneralLedgerSetup: Record "General Ledger Setup";
                PgeLDimensionValueList: Page "Dimension Value List";
            begin
                RecLGeneralLedgerSetup.Get();
                Clear(PgeLDimensionValueList);
                PgeLDimensionValueList.LookupMode(true);
                RecLDimensionValue.Reset();
                RecLDimensionValue.SetRange("Dimension Code", RecLGeneralLedgerSetup."Shortcut Dimension 3 Code");
                PgeLDimensionValueList.SetTableView(RecLDimensionValue);
                if PAGE.RunModal(Page::"Dimension Value List", RecLDimensionValue) = ACTION::LookupOK then
                    "Dimension 3 Code" := RecLDimensionValue.Code;
            end;

            trigger OnValidate()
            var
                RecLDimensionValue: Record "Dimension Value";
                RecLGeneralLedgerSetup: Record "General Ledger Setup";
            begin
                RecLGeneralLedgerSetup.Get();
                RecLDimensionValue.Get(RecLGeneralLedgerSetup."Shortcut Dimension 3 Code", "Dimension 3 Code");
            end;
        }
        field(9; "Product Type"; Option)
        {
            Caption = 'Product Type';
            OptionCaption = ',STONE,PREPARAGE,LIFTED AND ELLIPSES,SEMI-FINISHED';
            OptionMembers = ,STONE,PREPARAGE,"LIFTED AND ELLIPSES","SEMI-FINISHED";
            DataClassification = CustomerContent;
        }
        field(10; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location.Code;
            DataClassification = CustomerContent;
        }
        field(11; "Bin Code"; Text[10])
        {
            Caption = 'Bin Code';
            TableRelation = Location;
            DataClassification = CustomerContent;
        }
        field(12; "Item Category Code"; Code[10])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category".Code;
            DataClassification = CustomerContent;

            trigger OnValidate()
            // var
            //     RecLItemCat: Record "Item Category";
            begin
                // if RecLItemCat.Get("Item Category Code") then
                case "Costing Method" of
                    "Costing Method"::Standard:
                        Validate("Replenishment System", "Replenishment System"::"Prod. Order");
                    "Costing Method"::Average:
                        Validate("Replenishment System", "Replenishment System"::Purchase);
                end;
            end;
        }
        field(13; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "PWD Product Group".Code WHERE("Item Category Code" = FIELD("Item Category Code"));
            DataClassification = CustomerContent;
        }
        field(14; "Item Code"; Code[20])
        {
            Caption = 'Item Code';
            DataClassification = CustomerContent;
        }
        field(15; "LPSA Description 1"; Text[120])
        {
            Caption = 'LPSA Description 1';
            DataClassification = CustomerContent;
        }
        field(16; "LPSA Description 2"; Text[120])
        {
            Caption = 'LPSA Description 2';
            DataClassification = CustomerContent;
        }
        field(17; "Quartis Description"; Text[40])
        {
            Caption = 'Quartis Description';
            DataClassification = CustomerContent;
        }
        field(20; Hole; Decimal)
        {
            Caption = 'Hole';
            DataClassification = CustomerContent;
        }
        field(21; "Hole Min."; Decimal)
        {
            Caption = 'Hole Min.';
            DataClassification = CustomerContent;
        }
        field(22; "Hole Max."; Decimal)
        {
            Caption = 'Hole Max.';
            DataClassification = CustomerContent;
        }
        field(23; "External Diameter"; Decimal)
        {
            Caption = 'External Diameter';
            DataClassification = CustomerContent;
        }
        field(24; "External Diameter Min."; Decimal)
        {
            Caption = 'External Diameter Min.';
            DataClassification = CustomerContent;
        }
        field(25; "External Diameter Max."; Decimal)
        {
            Caption = 'External Diameter Max.';
            DataClassification = CustomerContent;
        }
        field(26; Thickness; Decimal)
        {
            Caption = 'Thickness';
            DataClassification = CustomerContent;
        }
        field(27; "Thickness Min."; Decimal)
        {
            Caption = 'Thickness Min.';
            DataClassification = CustomerContent;
        }
        field(28; "Thickness Max."; Decimal)
        {
            Caption = 'Thickness Max.';
            DataClassification = CustomerContent;
        }
        field(29; "Recess Diametre"; Decimal)
        {
            Caption = 'Recess Diametre';
            DataClassification = CustomerContent;
        }
        field(30; "Recess Diametre Min."; Decimal)
        {
            Caption = 'Recess Diametre Min.';
            DataClassification = CustomerContent;
        }
        field(31; "Recess Diametre Max."; Decimal)
        {
            Caption = 'Recess Diametre Max.';
            DataClassification = CustomerContent;
        }
        field(32; "Hole Length"; Decimal)
        {
            Caption = 'Hole Length';
            DataClassification = CustomerContent;
        }
        field(33; "Hole Length Min."; Decimal)
        {
            Caption = 'Hole Length Min.';
            DataClassification = CustomerContent;
        }
        field(34; "Hole Length Max."; Decimal)
        {
            Caption = 'Hole Length Max.';
            DataClassification = CustomerContent;
        }
        field(35; "Height Band"; Decimal)
        {
            Caption = 'Height Band';
            DataClassification = CustomerContent;
        }
        field(36; "Height Band Min."; Decimal)
        {
            Caption = 'Height Band Min.';
            DataClassification = CustomerContent;
        }
        field(37; "Height Band Max."; Decimal)
        {
            Caption = 'Height Band Min.';
            DataClassification = CustomerContent;
        }
        field(38; "Height Cambered"; Decimal)
        {
            Caption = 'Height Cambered';
            DataClassification = CustomerContent;
        }
        field(39; "Height Cambered Min."; Decimal)
        {
            Caption = 'Height Cambered Min.';
            DataClassification = CustomerContent;
        }
        field(40; "Height Cambered Max."; Decimal)
        {
            Caption = 'Height Cambered Max.';
            DataClassification = CustomerContent;
        }
        field(41; "Height Half Glazed"; Decimal)
        {
            Caption = 'Height Half Glazed';
            DataClassification = CustomerContent;
        }
        field(42; "Height Half Glazed Min."; Decimal)
        {
            Caption = 'Height Half Glazed Min.';
            DataClassification = CustomerContent;
        }
        field(43; "Height Half Glazed Max."; Decimal)
        {
            Caption = 'Height Half Glazed Max.';
            DataClassification = CustomerContent;
        }
        field(44; "Piece Type Stone"; Code[20])
        {
            Caption = 'Piece Type Stone';
            TableRelation = "PWD Piece Type".Code WHERE("Option Piece Type" = CONST(Stone));
            DataClassification = CustomerContent;
        }
        field(45; "Matter Stone"; Code[20])
        {
            Caption = 'Matter Stone';
            TableRelation = "PWD Matter".Code WHERE("Option Matter" = CONST(Stone));
            DataClassification = CustomerContent;
        }
        field(46; Number; Text[10])
        {
            Caption = 'Number';
            DataClassification = CustomerContent;
        }
        field(47; Orientation; Text[50])
        {
            Caption = 'Orientation';
            DataClassification = CustomerContent;
        }
        field(48; Piercing; Decimal)
        {
            Caption = 'Piercing';
            DataClassification = CustomerContent;
        }
        field(49; "Piercing Min."; Decimal)
        {
            Caption = 'Piercing Min.';
            DataClassification = CustomerContent;
        }
        field(50; "Piercing Max."; Decimal)
        {
            Caption = 'Piercing Max.';
            DataClassification = CustomerContent;
        }
        field(51; Note; Decimal)
        {
            Caption = 'Note';
            DataClassification = CustomerContent;
        }
        field(54; Diameter; Decimal)
        {
            Caption = 'Diameter';
            DataClassification = CustomerContent;
        }
        field(55; "Diameter Min."; Decimal)
        {
            Caption = 'Diameter Min.';
            DataClassification = CustomerContent;
        }
        field(56; "Diameter Max."; Decimal)
        {
            Caption = 'Diameter Max.';
            DataClassification = CustomerContent;
        }
        field(57; Thick; Decimal)
        {
            Caption = 'Thickness';
            DataClassification = CustomerContent;
        }
        field(58; "Thick Min."; Decimal)
        {
            Caption = 'Thickness Min.';
            DataClassification = CustomerContent;
        }
        field(59; "Thick Max."; Decimal)
        {
            Caption = 'Thickness Max.';
            DataClassification = CustomerContent;
        }
        field(60; Width; Decimal)
        {
            Caption = 'Width';
            DataClassification = CustomerContent;
        }
        field(61; "Width Min."; Decimal)
        {
            Caption = 'Width Min.';
            DataClassification = CustomerContent;
        }
        field(62; "Width Max."; Decimal)
        {
            Caption = 'Width Max.';
            DataClassification = CustomerContent;
        }
        field(63; Height; Decimal)
        {
            Caption = 'Height';
            DataClassification = CustomerContent;
        }
        field(64; "Height Min."; Decimal)
        {
            Caption = 'Height Min.';
            DataClassification = CustomerContent;
        }
        field(65; "Height Max."; Decimal)
        {
            Caption = 'Height Max.';
            DataClassification = CustomerContent;
        }
        field(66; "Width / Depth"; Decimal)
        {
            Caption = 'Width / Depth';
            DataClassification = CustomerContent;
        }
        field(67; "Width / Depth Min."; Decimal)
        {
            Caption = 'Width / Depth Min.';
            DataClassification = CustomerContent;
        }
        field(68; "Width / Depth Max."; Decimal)
        {
            Caption = 'Width / Depth Max.';
            DataClassification = CustomerContent;
        }
        field(69; "Piece Type Preparage"; Code[20])
        {
            Caption = 'Piece Type Stone';
            TableRelation = "PWD Piece Type".Code WHERE("Option Piece Type" = CONST(Preparage));
            DataClassification = CustomerContent;
        }
        field(70; "Matter Preparage"; Code[20])
        {
            Caption = 'Matter Stone';
            TableRelation = "PWD Matter".Code WHERE("Option Matter" = CONST(Preparage));
            DataClassification = CustomerContent;
        }
        field(71; Angle; Decimal)
        {
            Caption = 'Angle';
            DataClassification = CustomerContent;
        }
        field(72; "Angle Min."; Decimal)
        {
            Caption = 'Angle Min.';
            DataClassification = CustomerContent;
        }
        field(73; "Angle Max."; Decimal)
        {
            Caption = 'Angle Max.';
            DataClassification = CustomerContent;
        }
        field(74; "Height Tol"; Decimal)
        {
            Caption = 'Height';
            DataClassification = CustomerContent;
        }
        field(75; "Height Min. Tol"; Decimal)
        {
            Caption = 'Height Min.';
            DataClassification = CustomerContent;
        }
        field(76; "Height Max. Tol"; Decimal)
        {
            Caption = 'Height Max.';
            DataClassification = CustomerContent;
        }
        field(77; "Thick Tol"; Decimal)
        {
            Caption = 'Thickness';
            DataClassification = CustomerContent;
        }
        field(78; "Thick Min. Tol"; Decimal)
        {
            Caption = 'Thickness Min.';
            DataClassification = CustomerContent;
        }
        field(79; "Thick Max. Tol"; Decimal)
        {
            Caption = 'Thickness Max.';
            DataClassification = CustomerContent;
        }
        field(80; "Lg Tol"; Decimal)
        {
            Caption = 'Length';
            DataClassification = CustomerContent;
        }
        field(81; "Lg Tol Min."; Decimal)
        {
            Caption = 'Length Min.';
            DataClassification = CustomerContent;
        }
        field(82; "Lg Tol Max."; Decimal)
        {
            Caption = 'Length Max.';
            DataClassification = CustomerContent;
        }
        field(83; "Diameter Tol"; Decimal)
        {
            Caption = 'Diameter Tol';
            DataClassification = CustomerContent;
        }
        field(84; "Diameter Tol Min."; Decimal)
        {
            Caption = 'DiameterTol Min.';
            DataClassification = CustomerContent;
        }
        field(85; "Diameter Tol Max."; Decimal)
        {
            Caption = 'Diameter Tol Max.';
            DataClassification = CustomerContent;
        }
        field(86; "R / Arc"; Decimal)
        {
            Caption = 'R / Arc';
            DataClassification = CustomerContent;
        }
        field(87; "R / Corde"; Decimal)
        {
            Caption = 'R / Corde';
            DataClassification = CustomerContent;
        }
        field(88; "Piece Type Lifted&Ellipses"; Code[20])
        {
            Caption = 'Piece Type Lifted and Ellipses';
            TableRelation = "PWD Piece Type".Code WHERE("Option Piece Type" = CONST("Lifted and ellipses"));
            DataClassification = CustomerContent;
        }
        field(89; "Matter Lifted&Ellipses"; Code[20])
        {
            Caption = 'Matter Lifted and Ellipses';
            TableRelation = "PWD Matter".Code WHERE("Option Matter" = CONST("Lifted and ellipses"));
            DataClassification = CustomerContent;
        }
        field(90; "Hole Tol"; Decimal)
        {
            Caption = 'Hole Tol';
            DataClassification = CustomerContent;
        }
        field(91; "Hole Tol Min."; Decimal)
        {
            Caption = 'Hole Tol Min.';
            DataClassification = CustomerContent;
        }
        field(92; "Hole Tol Max."; Decimal)
        {
            Caption = 'Hole Tol  Max.';
            DataClassification = CustomerContent;
        }
        field(93; "External Diameter Tol"; Decimal)
        {
            Caption = 'External Diameter Tol';
            DataClassification = CustomerContent;
        }
        field(94; "External Diameter Tol Min."; Decimal)
        {
            Caption = 'External Diameter Tol Min.';
            DataClassification = CustomerContent;
        }
        field(95; "External Diameter Tol Max."; Decimal)
        {
            Caption = 'External Diameter Tol Max.';
            DataClassification = CustomerContent;
        }
        field(96; D; Decimal)
        {
            Caption = 'D';
            DataClassification = CustomerContent;
        }
        field(97; "D Min."; Decimal)
        {
            Caption = 'D Min.';
            DataClassification = CustomerContent;
        }
        field(98; "D Max."; Decimal)
        {
            Caption = 'D Max.';
            DataClassification = CustomerContent;
        }
        field(99; Ep; Decimal)
        {
            Caption = 'Ep';
            DataClassification = CustomerContent;
        }
        field(100; "Ep Min."; Decimal)
        {
            Caption = 'Ep Min.';
            DataClassification = CustomerContent;
        }
        field(101; "Ep Max."; Decimal)
        {
            Caption = 'Ep Max.';
            DataClassification = CustomerContent;
        }
        field(102; "Piece Type Semi-finished"; Code[20])
        {
            Caption = 'Piece Type Semi-finished';
            TableRelation = "PWD Piece Type".Code WHERE("Option Piece Type" = CONST("Semi-finished"));
            DataClassification = CustomerContent;
        }
        field(103; "Matter Semi-finished"; Code[20])
        {
            Caption = 'Matter Semi-finished';
            TableRelation = "PWD Matter".Code WHERE("Option Matter" = CONST("Semi-finished"));
            DataClassification = CustomerContent;
        }
        field(50000; "Search Description"; Code[100])
        {
            CalcFormula = Lookup(Item."Search Description" WHERE("No." = FIELD("Item Code")));
            Caption = 'Désignation de recherche';
            FieldClass = FlowField;
        }
        field(50001; "Costing Method"; Enum "Costing Method")
        {
            Caption = 'Costing Method';
            InitValue = "Average";
            DataClassification = CustomerContent;
        }
        field(50002; "Replenishment System"; Enum "Replenishment System")
        {
            Caption = 'Replenishment System';
            DataClassification = CustomerContent;
            // OptionCaption = 'Purchase,Prod. Order, ';
            // OptionMembers = Purchase,"Prod. Order"," ";

            trigger OnValidate()
            begin
                //>>TDL.12/08/2015
                if "Replenishment System" = "Replenishment System"::Purchase then
                    Validate("Costing Method", "Costing Method"::Average)
                else
                    Validate("Costing Method", "Costing Method"::Standard);
                //<<TDL.12/08/2015
            end;
        }
        field(50003; "Quartis Desc TEST"; Text[40])
        {
            Caption = 'Désign. Quartis TEST';
            Description = 'CSC';
            DataClassification = CustomerContent;
        }
        field(50004; "Create From Item"; Boolean)
        {
            Caption = 'Créé à partir de l''article par TPL';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Item Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        RecGItemConfigurator.Reset();
        if RecGItemConfigurator.FindLast() then
            "Entry No." := RecGItemConfigurator."Entry No." + 10000
        else
            "Entry No." := 10000;
    end;

    var
        RecGItemConfigurator: Record "PWD Item Configurator";
}

