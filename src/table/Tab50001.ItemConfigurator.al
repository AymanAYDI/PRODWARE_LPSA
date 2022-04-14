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

    fields
    {
        field(1; "Entry No."; BigInteger)
        {
            Caption = 'Entry No.';
        }
        field(2; "Family Code"; Code[2])
        {
            Caption = 'Family Code';
            TableRelation = "PWD Family LPSA".Code;
        }
        field(3; "Subfamily Code"; Code[3])
        {
            Caption = 'Subfamily Code';
            TableRelation = "PWD SubFamily LPSA".Code WHERE("Family Code" = FIELD("Family Code"));
        }
        field(4; "Phantom Item"; Boolean)
        {
            Caption = 'Phantom Item';
        }
        field(5; "Item Template Code"; Code[10])
        {
            Caption = 'Item Template Code';
            TableRelation = "Config. Template Header".Code WHERE("Table ID" = CONST(27));
        }
        field(6; "Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(7; "Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(8; "Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Dimension 3 Code';

            trigger OnLookup()
            var
                RecLGeneralLedgerSetup: Record "General Ledger Setup";
                PgeLDimensionValueList: Page "Dimension Value List";
                RecLDimensionValue: Record "Dimension Value";
            begin
                RecLGeneralLedgerSetup.Get;
                Clear(PgeLDimensionValueList);
                PgeLDimensionValueList.LookupMode(true);
                RecLDimensionValue.Reset;
                RecLDimensionValue.SetRange("Dimension Code", RecLGeneralLedgerSetup."Shortcut Dimension 3 Code");
                PgeLDimensionValueList.SetTableView(RecLDimensionValue);
                if PAGE.RunModal(560, RecLDimensionValue) = ACTION::LookupOK then
                    "Dimension 3 Code" := RecLDimensionValue.Code;
            end;

            trigger OnValidate()
            var
                RecLDimensionValue: Record "Dimension Value";
                RecLGeneralLedgerSetup: Record "General Ledger Setup";
            begin
                RecLGeneralLedgerSetup.Get;
                RecLDimensionValue.Get(RecLGeneralLedgerSetup."Shortcut Dimension 3 Code", "Dimension 3 Code");
            end;
        }
        field(9; "Product Type"; Option)
        {
            Caption = 'Product Type';
            OptionCaption = ',STONE,PREPARAGE,LIFTED AND ELLIPSES,SEMI-FINISHED';
            OptionMembers = ,STONE,PREPARAGE,"LIFTED AND ELLIPSES","SEMI-FINISHED";
        }
        field(10; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location.Code;
        }
        field(11; "Bin Code"; Text[10])
        {
            Caption = 'Bin Code';
            TableRelation = Location;
        }
        field(12; "Item Category Code"; Code[10])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category".Code;

            trigger OnValidate()
            var
                RecLItemCat: Record "Item Category";
            begin
                if RecLItemCat.Get("Item Category Code") then begin
                    case RecLItemCat."Def. Costing Method" of    //TODO: Les champs Standard du table "Item Category" sont mofifiées
                        RecLItemCat."Def. Costing Method"::Standard:
                            Validate("Replenishment System", "Replenishment System"::"Prod. Order");
                        RecLItemCat."Def. Costing Method"::Average:
                            Validate("Replenishment System", "Replenishment System"::Purchase);
                    end;
                end;
            end;
        }
        field(13; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "Product Group".Code WHERE("Item Category Code" = FIELD("Item Category Code"));
        }
        field(14; "Item Code"; Code[20])
        {
            Caption = 'Item Code';
        }
        field(15; "PWD LPSA Description 1"; Text[120])
        {
            Caption = 'LPSA Description 1';
        }
        field(16; "PWD LPSA Description 2"; Text[120])
        {
            Caption = 'LPSA Description 2';
        }
        field(17; "PWD Quartis Description"; Text[40])
        {
            Caption = 'Quartis Description';
        }
        field(20; Hole; Decimal)
        {
            Caption = 'Hole';
        }
        field(21; "Hole Min."; Decimal)
        {
            Caption = 'Hole Min.';
        }
        field(22; "Hole Max."; Decimal)
        {
            Caption = 'Hole Max.';
        }
        field(23; "External Diameter"; Decimal)
        {
            Caption = 'External Diameter';
        }
        field(24; "External Diameter Min."; Decimal)
        {
            Caption = 'External Diameter Min.';
        }
        field(25; "External Diameter Max."; Decimal)
        {
            Caption = 'External Diameter Max.';
        }
        field(26; Thickness; Decimal)
        {
            Caption = 'Thickness';
        }
        field(27; "Thickness Min."; Decimal)
        {
            Caption = 'Thickness Min.';
        }
        field(28; "Thickness Max."; Decimal)
        {
            Caption = 'Thickness Max.';
        }
        field(29; "Recess Diametre"; Decimal)
        {
            Caption = 'Recess Diametre';
        }
        field(30; "Recess Diametre Min."; Decimal)
        {
            Caption = 'Recess Diametre Min.';
        }
        field(31; "Recess Diametre Max."; Decimal)
        {
            Caption = 'Recess Diametre Max.';
        }
        field(32; "Hole Length"; Decimal)
        {
            Caption = 'Hole Length';
        }
        field(33; "Hole Length Min."; Decimal)
        {
            Caption = 'Hole Length Min.';
        }
        field(34; "Hole Length Max."; Decimal)
        {
            Caption = 'Hole Length Max.';
        }
        field(35; "Height Band"; Decimal)
        {
            Caption = 'Height Band';
        }
        field(36; "Height Band Min."; Decimal)
        {
            Caption = 'Height Band Min.';
        }
        field(37; "Height Band Max."; Decimal)
        {
            Caption = 'Height Band Min.';
        }
        field(38; "Height Cambered"; Decimal)
        {
            Caption = 'Height Cambered';
        }
        field(39; "Height Cambered Min."; Decimal)
        {
            Caption = 'Height Cambered Min.';
        }
        field(40; "Height Cambered Max."; Decimal)
        {
            Caption = 'Height Cambered Max.';
        }
        field(41; "Height Half Glazed"; Decimal)
        {
            Caption = 'Height Half Glazed';
        }
        field(42; "Height Half Glazed Min."; Decimal)
        {
            Caption = 'Height Half Glazed Min.';
        }
        field(43; "Height Half Glazed Max."; Decimal)
        {
            Caption = 'Height Half Glazed Max.';
        }
        field(44; "Piece Type Stone"; Code[20])
        {
            Caption = 'Piece Type Stone';
            TableRelation = "PWD Piece Type".Code WHERE("Option Piece Type" = CONST(Stone));
        }
        field(45; "Matter Stone"; Code[20])
        {
            Caption = 'Matter Stone';
            TableRelation = "PWD Matter".Code WHERE("Option Matter" = CONST(Stone));
        }
        field(46; Number; Text[10])
        {
            Caption = 'Number';
        }
        field(47; Orientation; Text[50])
        {
            Caption = 'Orientation';
        }
        field(48; Piercing; Decimal)
        {
            Caption = 'Piercing';
        }
        field(49; "Piercing Min."; Decimal)
        {
            Caption = 'Piercing Min.';
        }
        field(50; "Piercing Max."; Decimal)
        {
            Caption = 'Piercing Max.';
        }
        field(51; Note; Decimal)
        {
            Caption = 'Note';
        }
        field(54; Diameter; Decimal)
        {
            Caption = 'Diameter';
        }
        field(55; "Diameter Min."; Decimal)
        {
            Caption = 'Diameter Min.';
        }
        field(56; "Diameter Max."; Decimal)
        {
            Caption = 'Diameter Max.';
        }
        field(57; Thick; Decimal)
        {
            Caption = 'Thickness';
        }
        field(58; "Thick Min."; Decimal)
        {
            Caption = 'Thickness Min.';
        }
        field(59; "Thick Max."; Decimal)
        {
            Caption = 'Thickness Max.';
        }
        field(60; Width; Decimal)
        {
            Caption = 'Width';
        }
        field(61; "Width Min."; Decimal)
        {
            Caption = 'Width Min.';
        }
        field(62; "Width Max."; Decimal)
        {
            Caption = 'Width Max.';
        }
        field(63; Height; Decimal)
        {
            Caption = 'Height';
        }
        field(64; "Height Min."; Decimal)
        {
            Caption = 'Height Min.';
        }
        field(65; "Height Max."; Decimal)
        {
            Caption = 'Height Min.';
        }
        field(66; "Width / Depth"; Decimal)
        {
            Caption = 'Width / Depth';
        }
        field(67; "Width / Depth Min."; Decimal)
        {
            Caption = 'Width / Depth Min.';
        }
        field(68; "Width / Depth Max."; Decimal)
        {
            Caption = 'Width / Depth Max.';
        }
        field(69; "Piece Type Preparage"; Code[20])
        {
            Caption = 'Piece Type Stone';
            TableRelation = "PWD Piece Type".Code WHERE("Option Piece Type" = CONST(Preparage));
        }
        field(70; "Matter Preparage"; Code[20])
        {
            Caption = 'Matter Stone';
            TableRelation = "PWD Matter".Code WHERE("Option Matter" = CONST(Preparage));
        }
        field(71; Angle; Decimal)
        {
            Caption = 'Angle';
        }
        field(72; "Angle Min."; Decimal)
        {
            Caption = 'Angle Min.';
        }
        field(73; "Angle Max."; Decimal)
        {
            Caption = 'Angle Max.';
        }
        field(74; "Height Tol"; Decimal)
        {
            Caption = 'Height';
        }
        field(75; "Height Min. Tol"; Decimal)
        {
            Caption = 'Height Min.';
        }
        field(76; "Height Max. Tol"; Decimal)
        {
            Caption = 'Height Min.';
        }
        field(77; "Thick Tol"; Decimal)
        {
            Caption = 'Thickness';
        }
        field(78; "Thick Min. Tol"; Decimal)
        {
            Caption = 'Thickness Min.';
        }
        field(79; "Thick Max. Tol"; Decimal)
        {
            Caption = 'Thickness Max.';
        }
        field(80; "Lg Tol"; Decimal)
        {
            Caption = 'Length';
        }
        field(81; "Lg Tol Min."; Decimal)
        {
            Caption = 'Length Min.';
        }
        field(82; "Lg Tol Max."; Decimal)
        {
            Caption = 'Length Max.';
        }
        field(83; "Diameter Tol"; Decimal)
        {
            Caption = 'Diameter Tol';
        }
        field(84; "Diameter Tol Min."; Decimal)
        {
            Caption = 'DiameterTol Min.';
        }
        field(85; "Diameter Tol Max."; Decimal)
        {
            Caption = 'Diameter Tol Max.';
        }
        field(86; "R / Arc"; Decimal)
        {
            Caption = 'R / Arc';
        }
        field(87; "R / Corde"; Decimal)
        {
            Caption = 'R / Corde';
        }
        field(88; "Piece Type Lifted&Ellipses"; Code[20])
        {
            Caption = 'Piece Type Lifted and Ellipses';
            TableRelation = "PWD Piece Type".Code WHERE("Option Piece Type" = CONST("Lifted and ellipses"));
        }
        field(89; "Matter Lifted&Ellipses"; Code[20])
        {
            Caption = 'Matter Lifted and Ellipses';
            TableRelation = "PWD Matter".Code WHERE("Option Matter" = CONST("Lifted and ellipses"));
        }
        field(90; "Hole Tol"; Decimal)
        {
            Caption = 'Hole Tol';
        }
        field(91; "Hole Tol Min."; Decimal)
        {
            Caption = 'Hole Tol Min.';
        }
        field(92; "Hole Tol Max."; Decimal)
        {
            Caption = 'Hole Tol  Max.';
        }
        field(93; "External Diameter Tol"; Decimal)
        {
            Caption = 'External Diameter Tol';
        }
        field(94; "External Diameter Tol Min."; Decimal)
        {
            Caption = 'External Diameter Tol Min.';
        }
        field(95; "External Diameter Tol Max."; Decimal)
        {
            Caption = 'External Diameter Tol Max.';
        }
        field(96; D; Decimal)
        {
            Caption = 'D';
        }
        field(97; "D Min."; Decimal)
        {
            Caption = 'D Min.';
        }
        field(98; "D Max."; Decimal)
        {
            Caption = 'D Max.';
        }
        field(99; Ep; Decimal)
        {
            Caption = 'Ep';
        }
        field(100; "Ep Min."; Decimal)
        {
            Caption = 'Ep Min.';
        }
        field(101; "Ep Max."; Decimal)
        {
            Caption = 'Ep Max.';
        }
        field(102; "Piece Type Semi-finished"; Code[20])
        {
            Caption = 'Piece Type Semi-finished';
            TableRelation = "PWD Piece Type".Code WHERE("Option Piece Type" = CONST("Semi-finished"));
        }
        field(103; "Matter Semi-finished"; Code[20])
        {
            Caption = 'Matter Semi-finished';
            TableRelation = "PWD Matter".Code WHERE("Option Matter" = CONST("Semi-finished"));
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
        }
        field(50002; "Replenishment System"; Option)
        {
            Caption = 'Replenishment System';
            OptionCaption = 'Purchase,Prod. Order, ';
            OptionMembers = Purchase,"Prod. Order"," ";

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
        }
        field(50004; "Create From Item"; Boolean)
        {
            Caption = 'Créé à partir de l''article par TPL';
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
        RecGItemConfigurator.Reset;
        if RecGItemConfigurator.FindLast then
            "Entry No." := RecGItemConfigurator."Entry No." + 10000
        else
            "Entry No." := 10000;
    end;

    var
        RecGItemConfigurator: Record "PWD Item Configurator";
}

