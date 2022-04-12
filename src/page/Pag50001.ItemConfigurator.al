page 50001 "PWD Item Configurator"
{
    // +----------------------------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                                         |
    // | www.prodware.fr                                                                                                                  |
    // +----------------------------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_ART01.001: TO 07/12/2011:  Configurateur article
    //                                           - Create Page
    // 
    // //>>LAP2.02
    // FE_LAPIERRETTE_ART01.002: GR 21/05/2012:  Configurateur article  (PT TDL 34)
    //                                           Add C/AL Code in Function FctUpdateItem
    // 
    // //>>LAP2.06
    // FE_LAPRIERRETTE_GP0003: APA 16/05/2013 : Add C/AL Code in Function FctUpdateItem
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 12/09/2017 :  CONFIGURATEUR ARTICLE
    //                - Add Field Create From Item
    //                - Add C/AL Local and C/AL Code in triggers Apply - OnAction()
    //                                                           FctUpdateItem()
    // 
    // TDL21072020.001 : 21/07/2020 : Modification création des axes
    // 
    // +----------------------------------------------------------------------------------------------------------------------------------+

    Caption = 'Item Configurator';
    SourceTable = "PWD Item Configurator";

    layout
    {
        area(content)
        {
            group(Control1100294001)
            {
                Caption = 'General';
                ShowCaption = false;
                field("Family Code"; "Family Code")
                {
                    Editable = FamilyEditable;
                }
                field("Subfamily Code"; "Subfamily Code")
                {
                    Editable = SubFamilyEditable;
                }
                field("Item Template Code"; "Item Template Code")
                {
                    Editable = TemplateEditable;
                }
                field("Dimension 1 Code"; "Dimension 1 Code")
                {
                }
                field("Dimension 2 Code"; "Dimension 2 Code")
                {
                }
                field("Dimension 3 Code"; "Dimension 3 Code")
                {
                }
                field("Phantom Item"; "Phantom Item")
                {
                    Editable = PhantomEditable;
                }
                field("Product Type"; "Product Type")
                {

                    trigger OnValidate()
                    begin
                        FctEnableFields;
                    end;
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Bin Code"; "Bin Code")
                {
                }
                field("Item Category Code"; "Item Category Code")
                {
                }
                field("Product Group Code"; "Product Group Code")
                {
                }
                field("Replenishment System"; "Replenishment System")
                {
                }
                field("Costing Method"; "Costing Method")
                {
                }
            }
            group(Control1100294020)
            {
                Caption = 'Description';
                ShowCaption = false;
                field("Item Code"; "Item Code")
                {
                }
                field("PWD LPSA Description 1"; "PWD LPSA Description 1")
                {
                }
                field("PWD LPSA Description 2"; "PWD LPSA Description 2")
                {
                }
                field("PWD Quartis Description"; "PWD Quartis Description")
                {
                }
                field("Quartis Desc TEST"; "Quartis Desc TEST")
                {
                }
                field("Create From Item"; "Create From Item")
                {
                }
            }
            group(STONEGP)
            {
                Caption = 'Stone';
                Editable = StoneEnable;
                field("Piece Type Stone"; "Piece Type Stone")
                {

                    trigger OnValidate()
                    begin
                        FctEditableFieldsStone;
                    end;
                }
                field("Matter Stone"; "Matter Stone")
                {
                }
                field(Number; Number)
                {
                }
                field(Orientation; Orientation)
                {
                }
                field(Hole; Hole)
                {
                    Editable = HoleEditable;
                }
                field("Hole Min."; "Hole Min.")
                {
                    Editable = HoleEditable;
                }
                field("Hole Max."; "Hole Max.")
                {
                    Editable = HoleEditable;
                }
                field("External Diameter"; "External Diameter")
                {
                    Editable = ExtDiamEditable;
                }
                field("External Diameter Min."; "External Diameter Min.")
                {
                    Editable = ExtDiamEditable;
                }
                field("External Diameter Max."; "External Diameter Max.")
                {
                    Editable = ExtDiamEditable;
                }
                field(Thickness; Thickness)
                {
                    Editable = ThickEditable;
                }
                field("Thickness Min."; "Thickness Min.")
                {
                    Editable = ThickEditable;
                }
                field("Thickness Max."; "Thickness Max.")
                {
                    Editable = ThickEditable;
                }
                field("Recess Diametre"; "Recess Diametre")
                {
                    Editable = RecDiamEditable;
                }
                field("Recess Diametre Min."; "Recess Diametre Min.")
                {
                    Editable = RecDiamEditable;
                }
                field("Recess Diametre Max."; "Recess Diametre Max.")
                {
                    Editable = RecDiamEditable;
                }
                field("Hole Length"; "Hole Length")
                {
                    Editable = HoleLengthEditable;
                }
                field("Hole Length Min."; "Hole Length Min.")
                {
                    Editable = HoleLengthEditable;
                }
                field("Hole Length Max."; "Hole Length Max.")
                {
                    Editable = HoleLengthEditable;
                }
                field("Height Band"; "Height Band")
                {
                    Editable = HeightBandEditable;
                }
                field("Height Band Min."; "Height Band Min.")
                {
                    Editable = HeightBandEditable;
                }
                field("Height Band Max."; "Height Band Max.")
                {
                    Editable = HeightBandEditable;
                }
                field("Height Cambered"; "Height Cambered")
                {
                    Editable = HeightCamberedEditable;
                }
                field("Height Cambered Min."; "Height Cambered Min.")
                {
                    Editable = HeightCamberedEditable;
                }
                field("Height Cambered Max."; "Height Cambered Max.")
                {
                    Editable = HeightCamberedEditable;
                }
                field("Height Half Glazed"; "Height Half Glazed")
                {
                    Editable = HHGlazedEditable;
                }
                field("Height Half Glazed Min."; "Height Half Glazed Min.")
                {
                    Editable = HHGlazedEditable;
                }
                field("Height Half Glazed Max."; "Height Half Glazed Max.")
                {
                    Editable = HHGlazedEditable;
                }
            }
            group(PREPGP)
            {
                Caption = 'Preparage';
                Editable = PrepEnable;
                field("Piece Type Preparage"; "Piece Type Preparage")
                {

                    trigger OnValidate()
                    begin
                        FctEditableFieldsPreparage;
                    end;
                }
                field("Matter Preparage"; "Matter Preparage")
                {
                }
                field(Control1100294067; Number)
                {
                }
                field(Control1100294068; Orientation)
                {
                }
                field("Piercing Min."; "Piercing Min.")
                {
                    Editable = PiercingEditable;
                }
                field("Piercing Max."; "Piercing Max.")
                {
                    Editable = PiercingEditable;
                }
                field(Note; Note)
                {
                    Editable = NoteEditable;
                }
                field("Diameter Min."; "Diameter Min.")
                {
                    Editable = DiamEditable;
                }
                field("Diameter Max."; "Diameter Max.")
                {
                    Editable = DiamEditable;
                }
                field("Thick Min."; "Thick Min.")
                {
                    Editable = ThickPEditable;
                }
                field("Thick Max."; "Thick Max.")
                {
                    Editable = ThickPEditable;
                }
                field("Width Min."; "Width Min.")
                {
                    Editable = WidthEditable;
                }
                field("Width Max."; "Width Max.")
                {
                    Editable = WidthEditable;
                }
                field("Height Min."; "Height Min.")
                {
                    Editable = HeightEditable;
                }
                field("Height Max."; "Height Max.")
                {
                    Editable = HeightEditable;
                }
                field("Width / Depth Min."; "Width / Depth Min.")
                {
                    Editable = WidthDepthEditable;
                }
                field("Width / Depth Max."; "Width / Depth Max.")
                {
                    Editable = WidthDepthEditable;
                }
            }
            group(LAEGP)
            {
                Caption = 'Lifted and ellipses';
                Editable = LiftedAndEllipsesEnable;
                field("Piece Type Lifted&Ellipses"; "Piece Type Lifted&Ellipses")
                {

                    trigger OnValidate()
                    begin
                        FctEditableFieldsLAndE;
                    end;
                }
                field("Matter Lifted&Ellipses"; "Matter Lifted&Ellipses")
                {
                }
                field(Control1100294073; Number)
                {
                }
                field(Control1100294072; Orientation)
                {
                }
                field(Angle; Angle)
                {
                    Editable = AngleEditable;
                }
                field("Angle Min."; "Angle Min.")
                {
                    Editable = AngleEditable;
                }
                field("Angle Max."; "Angle Max.")
                {
                    Editable = AngleEditable;
                }
                field("Height Tol"; "Height Tol")
                {
                    Caption = 'Height';
                    Editable = HeightTolEditable;
                }
                field("Height Min. Tol"; "Height Min. Tol")
                {
                    Caption = 'Height Min.';
                    Editable = HeightTolEditable;
                }
                field("Height Max. Tol"; "Height Max. Tol")
                {
                    Caption = 'Height Min.';
                    Editable = HeightTolEditable;
                }
                field("Thick Tol"; "Thick Tol")
                {
                    Caption = 'Thickness';
                    Editable = WidthTolEditable;
                }
                field("Thick Min. Tol"; "Thick Min. Tol")
                {
                    Caption = 'Thickness Min.';
                    Editable = WidthTolEditable;
                }
                field("Thick Max. Tol"; "Thick Max. Tol")
                {
                    Caption = 'Thickness Max.';
                    Editable = WidthTolEditable;
                }
                field("Lg Tol"; "Lg Tol")
                {
                    Caption = 'Length';
                    Editable = LgTolEditable;
                }
                field("Lg Tol Min."; "Lg Tol Min.")
                {
                    Editable = LgTolEditable;
                }
                field("Lg Tol Max."; "Lg Tol Max.")
                {
                    Editable = LgTolEditable;
                }
                field("Diameter Tol"; "Diameter Tol")
                {
                    Editable = DiamTolEditable;
                }
                field("Diameter Tol Min."; "Diameter Tol Min.")
                {
                    Editable = DiamTolEditable;
                }
                field("Diameter Tol Max."; "Diameter Tol Max.")
                {
                    Editable = DiamTolEditable;
                }
                field("R / Arc"; "R / Arc")
                {
                    Editable = RArcEditable;
                }
                field("R / Corde"; "R / Corde")
                {
                    Editable = RCordeEditable;
                }
            }
            group(SFGP)
            {
                Caption = 'Semi-finished';
                Editable = SemiFinishedEnable;
                field("Piece Type Semi-finished"; "Piece Type Semi-finished")
                {

                    trigger OnValidate()
                    begin
                        FctEditableFieldsSF;
                    end;
                }
                field("Matter Semi-finished"; "Matter Semi-finished")
                {
                }
                field(Control1100294105; Number)
                {
                }
                field(Control1100294104; Orientation)
                {
                }
                field("Hole Tol"; "Hole Tol")
                {
                    Editable = TolHoleEditable;
                }
                field("Hole Tol Min."; "Hole Tol Min.")
                {
                    Editable = TolHoleEditable;
                }
                field("Hole Tol Max."; "Hole Tol Max.")
                {
                    Editable = TolHoleEditable;
                }
                field("External Diameter Tol"; "External Diameter Tol")
                {
                    Editable = TolExtDiamEditable;
                }
                field("External Diameter Tol Min."; "External Diameter Tol Min.")
                {
                    Editable = TolExtDiamEditable;
                }
                field("External Diameter Tol Max."; "External Diameter Tol Max.")
                {
                    Editable = TolExtDiamEditable;
                }
                field("D Min."; "D Min.")
                {
                    Editable = DEditable;
                }
                field("D Max."; "D Max.")
                {
                    Editable = DEditable;
                }
                field("Ep Min."; "Ep Min.")
                {
                    Editable = EpEditable;
                }
                field("Ep Max."; "Ep Max.")
                {
                    Editable = EpEditable;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Apply)
            {
                Caption = 'Apply';
                Image = ApplyTemplate;
                InFooterBar = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    RecLDataTemplateHeader: Record "Data Template Header";
                    RecRef: RecordRef;
                    RecLDefaultDimension: Record "Default Dimension";
                    RecLGeneralLedgerSetup: Record "General Ledger Setup";
                    BooLInsertItem: Boolean;
                    "---- LAP2.12 ----": Integer;
                    RecLInventorySetup: Record "Inventory Setup";
                    RecLItemCrossReference: Record "Item Cross Reference";
                    BooLCreateItemCrossRef: Boolean;
                    CodLFilter: Code[250];
                    IntLPipePosition: Integer;
                    IntLStringLenght: Integer;
                    CodLFilterToCompare: Code[20];
                    IntLLoop: Integer;
                begin
                    TESTFIELD("Item Code");
                    RecGItemConfigurator.RESET;
                    RecGItemConfigurator.SETCURRENTKEY("Item Code");
                    RecGItemConfigurator.SETRANGE("Item Code", "Item Code");
                    RecGItemConfigurator.SETFILTER("Entry No.", '<>%1', "Entry No.");
                    IF RecGItemConfigurator.FINDSET THEN
                        ERROR(CstGT001, "Item Code");
                    RecGItem.RESET;
                    RecGItem.SETRANGE("No.", "Item Code");
                    IF RecGItem.FINDSET(TRUE) THEN BEGIN
                        IF BooGNotEditable2 THEN
                            ERROR(CstGT002, "Item Code");
                        FctUpdateItem;
                        BooLInsertItem := FALSE;
                        RecGItem.MODIFY(TRUE);
                    END ELSE BEGIN
                        RecGItem.INIT;
                        RecGItem."No." := "Item Code";
                        BooLInsertItem := TRUE;
                        RecGItem.INSERT(TRUE);
                        COMMIT;
                        FctUpdateItem;
                        RecGItem.MODIFY(TRUE);
                        IF "Item Template Code" <> '' THEN BEGIN
                            COMMIT;
                            RecGItem.GET("Item Code");
                            RecGItem.FILTERGROUP(2);
                            RecRef.GETTABLE(RecGItem);
                            RecLDataTemplateHeader.GET("Item Template Code");
                            CduGTemplateManagement.UpdateRecord(RecLDataTemplateHeader, RecRef);
                        END;
                    END;

                    IF "Dimension 3 Code" <> '' THEN BEGIN
                        RecLGeneralLedgerSetup.GET;
                        IF RecLDefaultDimension.GET(DATABASE::Item, "Item Code", RecLGeneralLedgerSetup."Shortcut Dimension 3 Code") THEN BEGIN
                            RecLDefaultDimension."Dimension Value Code" := "Dimension 3 Code";
                            RecLDefaultDimension.MODIFY;
                        END ELSE BEGIN
                            RecLDefaultDimension."Table ID" := DATABASE::Item;
                            RecLDefaultDimension."No." := "Item Code";
                            RecLDefaultDimension."Dimension Code" := RecLGeneralLedgerSetup."Shortcut Dimension 3 Code";
                            RecLDefaultDimension."Dimension Value Code" := "Dimension 3 Code";
                            RecLDefaultDimension.INSERT;
                        END;
                    END;

                    //>>LAP2.12
                    RecLInventorySetup.GET;
                    RecLInventorySetup.TESTFIELD("Product Group Code  Dimension");

                    IF "Product Group Code" <> '' THEN BEGIN
                        IF RecLDefaultDimension.GET(DATABASE::Item, "Item Code", RecLInventorySetup."Product Group Code  Dimension") THEN BEGIN
                            //>>TDL21072020.001
                            //RecLDefaultDimension."Dimension Value Code" := "Item Category Code"+'_'+"Product Group Code";
                            RecLDefaultDimension."Dimension Value Code" := "Product Group Code";
                            //<<TDL21072020.001
                            RecLDefaultDimension.MODIFY;
                        END ELSE BEGIN
                            RecLDefaultDimension."Table ID" := DATABASE::Item;
                            RecLDefaultDimension."No." := "Item Code";
                            RecLDefaultDimension."Dimension Code" := RecLInventorySetup."Product Group Code  Dimension";
                            //>>TDL21072020.001
                            //RecLDefaultDimension."Dimension Value Code" := "Item Category Code"+'_'+"Product Group Code";
                            RecLDefaultDimension."Dimension Value Code" := "Product Group Code";
                            //<<TDL21072020.001
                            RecLDefaultDimension.INSERT;
                        END;
                    END;

                    BooLCreateItemCrossRef := FALSE;

                    RecLInventorySetup.TESTFIELD("Item Filter For Extern Ref");
                    RecLInventorySetup.TESTFIELD("LPSA Customer No.");
                    //RecLInventorySetup.TESTFIELD("STRATEGY Customer No.");

                    CodLFilter := RecLInventorySetup."Item Filter For Extern Ref";
                    IntLLoop := 0;

                    REPEAT
                        IntLLoop += 1;
                        IntLPipePosition := STRPOS(CodLFilter, '|');
                        IF IntLPipePosition <> 0 THEN
                            CodLFilterToCompare := COPYSTR(CodLFilter, 1, IntLPipePosition - 1)
                        ELSE
                            CodLFilterToCompare := CodLFilter;

                        CodLFilterToCompare := DELCHR(CodLFilterToCompare, '<>', '*');
                        IntLStringLenght := STRLEN(CodLFilterToCompare);

                        IF CodLFilterToCompare = COPYSTR(RecGItem."No.", 1, IntLStringLenght) THEN
                            BooLCreateItemCrossRef := TRUE;

                        CodLFilter := COPYSTR(CodLFilter, IntLPipePosition + 1);

                    UNTIL (IntLPipePosition = 0) OR (BooLCreateItemCrossRef) OR (IntLLoop > 200);

                    IF BooLCreateItemCrossRef THEN BEGIN
                        IF RecLInventorySetup."STRATEGY Customer No." <> '' THEN BEGIN
                            IF NOT RecLItemCrossReference.GET(RecGItem."No.",
                                                              '',
                                                              RecGItem."Base Unit of Measure",
                                                              RecLItemCrossReference."Cross-Reference Type"::Customer,
                                                              RecLInventorySetup."STRATEGY Customer No.",
                                                              'NC') THEN BEGIN
                                RecLItemCrossReference.INIT;
                                RecLItemCrossReference.VALIDATE("Item No.", RecGItem."No.");
                                RecLItemCrossReference.VALIDATE("Unit of Measure", RecGItem."Base Unit of Measure");
                                RecLItemCrossReference.VALIDATE("Cross-Reference Type", RecLItemCrossReference."Cross-Reference Type"::Customer);
                                RecLItemCrossReference.VALIDATE("Cross-Reference Type No.", RecLInventorySetup."STRATEGY Customer No.");
                                RecLItemCrossReference.VALIDATE("Cross-Reference No.", 'NC');
                                RecLItemCrossReference.INSERT;
                            END;
                        END;
                        IF NOT RecLItemCrossReference.GET(RecGItem."No.",
                                                          '',
                                                          RecGItem."Base Unit of Measure",
                                                          RecLItemCrossReference."Cross-Reference Type"::Customer,
                                                          RecLInventorySetup."LPSA Customer No.",
                                                          'NC') THEN BEGIN
                            RecLItemCrossReference.INIT;
                            RecLItemCrossReference.VALIDATE("Item No.", RecGItem."No.");
                            RecLItemCrossReference.VALIDATE("Unit of Measure", RecGItem."Base Unit of Measure");
                            RecLItemCrossReference.VALIDATE("Cross-Reference Type", RecLItemCrossReference."Cross-Reference Type"::Customer);
                            RecLItemCrossReference.VALIDATE("Cross-Reference Type No.", RecLInventorySetup."LPSA Customer No.");
                            RecLItemCrossReference.VALIDATE("Cross-Reference No.", 'NC');
                            RecLItemCrossReference.INSERT;
                        END;
                    END;
                    //<<LAP2.12

                    IF BooLInsertItem THEN BEGIN
                        RecGSubFamily.GET("Family Code", "Subfamily Code");
                        IF "Phantom Item" THEN
                            RecGSubFamily.NumberF := RecGSubFamily.NumberF + 1
                        ELSE
                            RecGSubFamily.Number := RecGSubFamily.Number + 1;
                        RecGSubFamily.MODIFY;
                    END;

                    COMMIT;

                    CLEAR(PgeGItemCard);
                    RecGItem.RESET;
                    RecGItem.GET("Item Code");
                    PgeGItemCard.SETTABLEVIEW(RecGItem);
                    PAGE.RUNMODAL(30, RecGItem);
                end;
            }
            action(Configure)
            {
                Caption = 'Configure';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    IF FamilyEditable THEN
                        BooGNotEditable2 := TRUE
                    ELSE
                        BooGNotEditable2 := FALSE;
                    IF NOT BooGNotEditable THEN
                        FctConfigItemCode;
                    FctConfigDes;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        FctEnableFields;
        FctEditableFields;
    end;

    trigger OnInit()
    begin
        FctEnableFields;
        FctEditableFields;
    end;

    trigger OnOpenPage()
    begin
        FctEnableFields;
        FctEditableFields;
    end;

    var
        [InDataSet]
        StoneEnable: Boolean;
        [InDataSet]
        PrepEnable: Boolean;
        [InDataSet]
        LiftedAndEllipsesEnable: Boolean;
        [InDataSet]
        SemiFinishedEnable: Boolean;
        [InDataSet]
        FamilyEditable: Boolean;
        [InDataSet]
        SubFamilyEditable: Boolean;
        [InDataSet]
        PhantomEditable: Boolean;
        [InDataSet]
        TemplateEditable: Boolean;
        [InDataSet]
        HoleEditable: Boolean;
        [InDataSet]
        ExtDiamEditable: Boolean;
        [InDataSet]
        ThickEditable: Boolean;
        [InDataSet]
        RecDiamEditable: Boolean;
        [InDataSet]
        HoleLengthEditable: Boolean;
        [InDataSet]
        HeightBandEditable: Boolean;
        [InDataSet]
        HeightCamberedEditable: Boolean;
        [InDataSet]
        HHGlazedEditable: Boolean;
        [InDataSet]
        PTStoneEditable: Boolean;
        [InDataSet]
        MatterStoneEditable: Boolean;
        [InDataSet]
        NumberEditable: Boolean;
        [InDataSet]
        OrientationEditable: Boolean;
        [InDataSet]
        PiercingEditable: Boolean;
        [InDataSet]
        NoteEditable: Boolean;
        [InDataSet]
        DiamEditable: Boolean;
        [InDataSet]
        ThickPEditable: Boolean;
        [InDataSet]
        WidthEditable: Boolean;
        [InDataSet]
        HeightEditable: Boolean;
        [InDataSet]
        WidthDepthEditable: Boolean;
        [InDataSet]
        AngleEditable: Boolean;
        [InDataSet]
        HeightTolEditable: Boolean;
        [InDataSet]
        WidthTolEditable: Boolean;
        [InDataSet]
        LgTolEditable: Boolean;
        [InDataSet]
        DiamTolEditable: Boolean;
        [InDataSet]
        RArcEditable: Boolean;
        [InDataSet]
        RCordeEditable: Boolean;
        [InDataSet]
        TolHoleEditable: Boolean;
        [InDataSet]
        TolExtDiamEditable: Boolean;
        [InDataSet]
        DEditable: Boolean;
        [InDataSet]
        EpEditable: Boolean;
        BooGNotEditable: Boolean;
        RecGPieceType: Record "Piece Type";
        RecGItem: Record Item;
        RecGSubFamily: Record "SubFamily LPSA";
        RecGItemConfigurator: Record "PWD Item Configurator";
        CstGT001: Label 'Item %1 already exist.';
        PgeGItemCard: Page "Item Card";
        CdUGItemConfigurator: Codeunit "PWD Item Configurator";
        CduGTemplateManagement: Codeunit "Template Management";
        RecGItem2: Record Item;
        CstGT002: Label 'Item %1 was created manually. Complete the item code to create a new item.';
        BooGNotEditable2: Boolean;


    procedure FctEnableFields()
    begin
        StoneEnable := FALSE;
        PrepEnable := FALSE;
        LiftedAndEllipsesEnable := FALSE;
        SemiFinishedEnable := FALSE;
        CASE "Product Type" OF
            "Product Type"::STONE:
                BEGIN
                    StoneEnable := TRUE;
                    FctEditableFieldsStone;
                END;
            "Product Type"::PREPARAGE:
                BEGIN
                    PrepEnable := TRUE;
                    FctEditableFieldsPreparage;
                END;
            "Product Type"::"LIFTED AND ELLIPSES":
                BEGIN
                    LiftedAndEllipsesEnable := TRUE;
                    FctEditableFieldsLAndE;
                END;
            "Product Type"::"SEMI-FINISHED":
                BEGIN
                    SemiFinishedEnable := TRUE;
                    FctEditableFieldsSF;
                END;
        END;
    end;


    procedure FctEditableFields()
    begin
        IF RecGItem2.GET("Item Code") THEN
            BooGNotEditable := TRUE
        ELSE
            BooGNotEditable := FALSE;
        FamilyEditable := TRUE;
        SubFamilyEditable := TRUE;
        PhantomEditable := TRUE;
        TemplateEditable := TRUE;
        IF BooGNotEditable THEN BEGIN
            FamilyEditable := FALSE;
            SubFamilyEditable := FALSE;
            PhantomEditable := FALSE;
            TemplateEditable := FALSE;
        END;
    end;


    procedure FctNotEditable(BooPNotEditable: Boolean)
    begin
        BooGNotEditable := BooPNotEditable;
    end;


    procedure FctConfigItemCode()
    var
        TxtLNumber: Text[5];
    begin
        TESTFIELD("Family Code");
        TESTFIELD("Subfamily Code");
        RecGSubFamily.GET("Family Code", "Subfamily Code");
        "Item Code" := "Family Code" + "Subfamily Code";
        IF "Phantom Item" THEN BEGIN
            "Item Code" := "Item Code" + 'F';
            TxtLNumber := FORMAT(RecGSubFamily.NumberF + 1);
            "Item Code" := PADSTR("Item Code", 8 - STRLEN(TxtLNumber), '0');
            "Item Code" := "Item Code" + TxtLNumber;
        END ELSE BEGIN
            TxtLNumber := FORMAT(RecGSubFamily.Number + 1);
            "Item Code" := PADSTR("Item Code", 8 - STRLEN(TxtLNumber), '0');
            "Item Code" := "Item Code" + TxtLNumber;
        END;
    end;


    procedure FctConfigDes()
    begin
        CASE "Product Type" OF
            "Product Type"::STONE:
                BEGIN
                    CdUGItemConfigurator.FctConfigDescStone(Rec);
                END;
            "Product Type"::PREPARAGE:
                CdUGItemConfigurator.FctConfigDescPrepa(Rec);
            "Product Type"::"LIFTED AND ELLIPSES":
                CdUGItemConfigurator.FctConfigDescLifted(Rec);
            "Product Type"::"SEMI-FINISHED":
                CdUGItemConfigurator.FctConfigDescSemiFinish(Rec);
        END;
    end;


    procedure FctEditableFieldsStone()
    begin
        HoleEditable := TRUE;
        ExtDiamEditable := TRUE;
        ThickEditable := TRUE;
        RecDiamEditable := TRUE;
        HoleLengthEditable := TRUE;
        HeightBandEditable := TRUE;
        HeightCamberedEditable := TRUE;
        HHGlazedEditable := TRUE;
        IF RecGPieceType.GET(RecGPieceType."Option Piece Type"::Stone, "Piece Type Stone") THEN BEGIN
            HoleEditable := RecGPieceType.Hole;
            ExtDiamEditable := RecGPieceType."Ext. Hole";
            ThickEditable := RecGPieceType.Thickness;
            RecDiamEditable := RecGPieceType."Recess Diam.";
            HoleLengthEditable := RecGPieceType."Hole Lg.";
            HeightBandEditable := RecGPieceType."Height Band";
            HeightCamberedEditable := RecGPieceType."Height Cambered";
            HHGlazedEditable := RecGPieceType."Height Half Glazed";
        END;
        IF NOT HoleEditable THEN BEGIN
            Hole := 0;
            "Hole Min." := 0;
            "Hole Max." := 0;
        END;
        IF NOT ExtDiamEditable THEN BEGIN
            "External Diameter" := 0;
            "External Diameter Min." := 0;
            "External Diameter Max." := 0;
        END;
        IF NOT ThickEditable THEN BEGIN
            Thickness := 0;
            "Thickness Min." := 0;
            "Thickness Max." := 0;
        END;
        IF NOT RecDiamEditable THEN BEGIN
            "Recess Diametre" := 0;
            "Recess Diametre Min." := 0;
            "Recess Diametre Max." := 0;
        END;
        IF NOT HoleLengthEditable THEN BEGIN
            "Hole Length" := 0;
            "Hole Length Min." := 0;
            "Hole Length Max." := 0;
        END;
        IF NOT HeightBandEditable THEN BEGIN
            "Height Band" := 0;
            "Height Band Min." := 0;
            "Height Band Max." := 0;
        END;
        IF NOT HeightCamberedEditable THEN BEGIN
            "Height Cambered" := 0;
            "Height Cambered Min." := 0;
            "Height Cambered Max." := 0;
        END;
        IF NOT HHGlazedEditable THEN BEGIN
            "Height Half Glazed" := 0;
            "Height Half Glazed Min." := 0;
            "Height Half Glazed Max." := 0;
        END;
    end;


    procedure FctEditableFieldsPreparage()
    begin
        PiercingEditable := TRUE;
        NoteEditable := TRUE;
        ThickPEditable := TRUE;
        DiamEditable := TRUE;
        WidthEditable := TRUE;
        HeightEditable := TRUE;
        WidthDepthEditable := TRUE;
        IF RecGPieceType.GET(RecGPieceType."Option Piece Type"::Preparage, "Piece Type Preparage") THEN BEGIN
            PiercingEditable := RecGPieceType.Piercing;
            NoteEditable := RecGPieceType.Note;
            ThickPEditable := RecGPieceType.Thick;
            DiamEditable := RecGPieceType.Diameter;
            WidthEditable := RecGPieceType.Width;
            HeightEditable := RecGPieceType.Height;
            WidthDepthEditable := RecGPieceType."Width / Depth";
        END;
        IF NOT PiercingEditable THEN BEGIN
            "Piercing Min." := 0;
            "Piercing Max." := 0;
        END;
        IF NOT NoteEditable THEN
            Note := 0;
        IF NOT ThickPEditable THEN BEGIN
            "Thick Min." := 0;
            "Thick Max." := 0;
        END;
        IF NOT DiamEditable THEN BEGIN
            "Diameter Min." := 0;
            "Diameter Max." := 0;
        END;
        IF NOT WidthEditable THEN BEGIN
            "Width Min." := 0;
            "Width Max." := 0;
        END;
        IF NOT HeightEditable THEN BEGIN
            "Height Min." := 0;
            "Height Max." := 0;
        END;
        IF NOT WidthDepthEditable THEN BEGIN
            "Width / Depth Min." := 0;
            "Width / Depth Max." := 0;
        END;
    end;


    procedure FctEditableFieldsLAndE()
    begin
        AngleEditable := TRUE;
        HeightTolEditable := TRUE;
        WidthTolEditable := TRUE;
        LgTolEditable := TRUE;
        DiamTolEditable := TRUE;
        RArcEditable := TRUE;
        RCordeEditable := TRUE;
        IF RecGPieceType.GET(RecGPieceType."Option Piece Type"::"Lifted and ellipses", "Piece Type Lifted&Ellipses") THEN BEGIN
            AngleEditable := RecGPieceType.Angle;
            HeightTolEditable := RecGPieceType."Height Tol";
            WidthTolEditable := RecGPieceType."Thick Tol";
            LgTolEditable := RecGPieceType."Lg Tol";
            DiamTolEditable := RecGPieceType."Diameter Tol";
            RArcEditable := RecGPieceType."R / Arc";
            RCordeEditable := RecGPieceType."R / Corde";
        END;
        IF NOT AngleEditable THEN BEGIN
            Angle := 0;
            "Angle Min." := 0;
            "Angle Max." := 0;
        END;
        IF NOT HeightTolEditable THEN BEGIN
            "Height Tol" := 0;
            "Height Min. Tol" := 0;
            "Height Max. Tol" := 0;
        END;
        IF NOT WidthTolEditable THEN BEGIN
            "Thick Tol" := 0;
            "Thick Min. Tol" := 0;
            "Thick Max. Tol" := 0;
        END;
        IF NOT LgTolEditable THEN BEGIN
            "Lg Tol" := 0;
            "Lg Tol Min." := 0;
            "Lg Tol Max." := 0;
        END;
        IF NOT DiamTolEditable THEN BEGIN
            "Diameter Tol" := 0;
            "Diameter Tol Min." := 0;
            "Diameter Tol Max." := 0;
        END;
        IF NOT RArcEditable THEN
            "R / Arc" := 0;
        IF NOT RCordeEditable THEN
            "R / Corde" := 0;
    end;


    procedure FctEditableFieldsSF()
    begin
        TolHoleEditable := TRUE;
        TolExtDiamEditable := TRUE;
        DEditable := TRUE;
        EpEditable := TRUE;
        IF RecGPieceType.GET(RecGPieceType."Option Piece Type"::"Semi-finished", "Piece Type Semi-finished") THEN BEGIN
            TolHoleEditable := RecGPieceType."Hole Tol";
            TolExtDiamEditable := RecGPieceType."Ext. Diam. Tol";
            DEditable := RecGPieceType.D;
            EpEditable := RecGPieceType.Ep;
        END;
        IF NOT TolHoleEditable THEN BEGIN
            "Hole Tol" := 0;
            "Hole Tol Min." := 0;
            "Hole Tol Max." := 0;
        END;
        IF NOT TolExtDiamEditable THEN BEGIN
            "External Diameter Tol" := 0;
            "External Diameter Tol Min." := 0;
            "External Diameter Tol Max." := 0;
        END;
        IF NOT DEditable THEN BEGIN
            "D Min." := 0;
            "D Max." := 0;
        END;
        IF NOT EpEditable THEN BEGIN
            "Ep Min." := 0;
            "Ep Max." := 0;
        END;
    end;


    procedure FctUpdateItem()
    begin
        RecGItem."PWD LPSA Description 1" := "PWD LPSA Description 1";
        RecGItem."PWD LPSA Description 2" := "PWD LPSA Description 2";
        RecGItem."PWD Quartis Description" := "PWD Quartis Description";

        //>>FE_LAPIERRETTE_ART01.003
        /*
        //>>FE_LAPIERRETTE_ART01.002
        RecGItem.VALIDATE(Description,"PWD Quartis Description");
        //<<FE_LAPIERRETTE_ART01.002
        */
        RecGItem.VALIDATE(Description, COPYSTR("PWD LPSA Description 1", 1, 50));
        RecGItem.VALIDATE("Description 2", COPYSTR("PWD LPSA Description 2", 1, 50));
        //>>LAP2.12
        IF RecGItem."Search Description" = '' THEN
            //<<LAP2.12
            RecGItem.VALIDATE("Search Description", COPYSTR("PWD Quartis Description", 1, 30));
        ;
        //<<FE_LAPIERRETTE_ART01.003

        RecGItem.VALIDATE("Location Code", "Location Code");
        RecGItem.VALIDATE("Shelf No.", "Bin Code");
        RecGItem.VALIDATE("Item Category Code", "Item Category Code");
        RecGItem.VALIDATE("Product Group Code", "Product Group Code");
        RecGItem.VALIDATE("Global Dimension 1 Code", "Dimension 1 Code");
        RecGItem.VALIDATE("Global Dimension 2 Code", "Dimension 2 Code");

        //>>FE_LAPRIERRETTE_GP0003
        RecGItem.VALIDATE("Phantom Item", "Phantom Item");
        //<<FE_LAPIERRETTE_GP0003

        RecGItem.VALIDATE("Replenishment System", "Replenishment System");
        IF RecGItem.TestNoEntriesExist_Cost THEN
            RecGItem.VALIDATE("Costing Method", "Costing Method");

    end;
}

