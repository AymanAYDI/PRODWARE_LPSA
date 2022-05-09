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
    UsageCategory = none;

    layout
    {
        area(content)
        {
            group(Control1100294001)
            {
                Caption = 'General';
                ShowCaption = false;
                field("Family Code"; Rec."Family Code")
                {
                    Editable = FamilyEditable;
                    ApplicationArea = All;
                }
                field("Subfamily Code"; Rec."Subfamily Code")
                {
                    Editable = SubFamilyEditable;
                    ApplicationArea = All;
                }
                field("Item Template Code"; Rec."Item Template Code")
                {
                    Editable = TemplateEditable;
                    ApplicationArea = All;
                }
                field("Dimension 1 Code"; Rec."Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Dimension 2 Code"; Rec."Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Dimension 3 Code"; Rec."Dimension 3 Code")
                {
                    ApplicationArea = All;
                }
                field("Phantom Item"; Rec."Phantom Item")
                {
                    Editable = PhantomEditable;
                    ApplicationArea = All;
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        FctEnableFields();
                    end;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = All;
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                }
                field("Product Group Code"; Rec."Product Group Code")
                {
                    ApplicationArea = All;
                }
                field("Replenishment System"; Rec."Replenishment System")
                {
                    ApplicationArea = All;
                }
                field("Costing Method"; Rec."Costing Method")
                {
                    ApplicationArea = All;
                }
            }
            group(Control1100294020)
            {
                Caption = 'Description';
                ShowCaption = false;
                field("Item Code"; Rec."Item Code")
                {
                    ApplicationArea = All;
                }
                field("PWD LPSA Description 1"; Rec."PWD LPSA Description 1")
                {
                    ApplicationArea = All;
                }
                field("PWD LPSA Description 2"; Rec."PWD LPSA Description 2")
                {
                    ApplicationArea = All;
                }
                field("PWD Quartis Description"; Rec."PWD Quartis Description")
                {
                    ApplicationArea = All;
                }
                field("Quartis Desc TEST"; Rec."Quartis Desc TEST")
                {
                    ApplicationArea = All;
                }
                field("Create From Item"; Rec."Create From Item")
                {
                    ApplicationArea = All;
                }
            }
            group(STONEGP)
            {
                Caption = 'Stone';
                Editable = StoneEnable;
                field("Piece Type Stone"; Rec."Piece Type Stone")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        FctEditableFieldsStone();
                    end;
                }
                field("Matter Stone"; Rec."Matter Stone")
                {
                    ApplicationArea = All;
                }
                field(Number; Rec.Number)
                {
                    ApplicationArea = All;
                }
                field(Orientation; Rec.Orientation)
                {
                    ApplicationArea = All;
                }
                field(Hole; Rec.Hole)
                {
                    Editable = HoleEditable;
                    ApplicationArea = All;
                }
                field("Hole Min."; Rec."Hole Min.")
                {
                    Editable = HoleEditable;
                    ApplicationArea = All;
                }
                field("Hole Max."; Rec."Hole Max.")
                {
                    Editable = HoleEditable;
                    ApplicationArea = All;
                }
                field("External Diameter"; Rec."External Diameter")
                {
                    Editable = ExtDiamEditable;
                    ApplicationArea = All;
                }
                field("External Diameter Min."; Rec."External Diameter Min.")
                {
                    Editable = ExtDiamEditable;
                    ApplicationArea = All;
                }
                field("External Diameter Max."; Rec."External Diameter Max.")
                {
                    Editable = ExtDiamEditable;
                    ApplicationArea = All;
                }
                field(Thickness; Rec.Thickness)
                {
                    Editable = ThickEditable;
                    ApplicationArea = All;
                }
                field("Thickness Min."; Rec."Thickness Min.")
                {
                    Editable = ThickEditable;
                    ApplicationArea = All;
                }
                field("Thickness Max."; Rec."Thickness Max.")
                {
                    Editable = ThickEditable;
                    ApplicationArea = All;
                }
                field("Recess Diametre"; Rec."Recess Diametre")
                {
                    Editable = RecDiamEditable;
                    ApplicationArea = All;
                }
                field("Recess Diametre Min."; Rec."Recess Diametre Min.")
                {
                    Editable = RecDiamEditable;
                    ApplicationArea = All;
                }
                field("Recess Diametre Max."; Rec."Recess Diametre Max.")
                {
                    Editable = RecDiamEditable;
                    ApplicationArea = All;
                }
                field("Hole Length"; Rec."Hole Length")
                {
                    Editable = HoleLengthEditable;
                    ApplicationArea = All;
                }
                field("Hole Length Min."; Rec."Hole Length Min.")
                {
                    Editable = HoleLengthEditable;
                    ApplicationArea = All;
                }
                field("Hole Length Max."; Rec."Hole Length Max.")
                {
                    Editable = HoleLengthEditable;
                    ApplicationArea = All;
                }
                field("Height Band"; Rec."Height Band")
                {
                    Editable = HeightBandEditable;
                    ApplicationArea = All;
                }
                field("Height Band Min."; Rec."Height Band Min.")
                {
                    Editable = HeightBandEditable;
                    ApplicationArea = All;
                }
                field("Height Band Max."; Rec."Height Band Max.")
                {
                    Editable = HeightBandEditable;
                    ApplicationArea = All;
                }
                field("Height Cambered"; Rec."Height Cambered")
                {
                    Editable = HeightCamberedEditable;
                    ApplicationArea = All;
                }
                field("Height Cambered Min."; Rec."Height Cambered Min.")
                {
                    Editable = HeightCamberedEditable;
                    ApplicationArea = All;
                }
                field("Height Cambered Max."; Rec."Height Cambered Max.")
                {
                    Editable = HeightCamberedEditable;
                    ApplicationArea = All;
                }
                field("Height Half Glazed"; Rec."Height Half Glazed")
                {
                    Editable = HHGlazedEditable;
                    ApplicationArea = All;
                }
                field("Height Half Glazed Min."; Rec."Height Half Glazed Min.")
                {
                    Editable = HHGlazedEditable;
                    ApplicationArea = All;
                }
                field("Height Half Glazed Max."; Rec."Height Half Glazed Max.")
                {
                    Editable = HHGlazedEditable;
                    ApplicationArea = All;
                }
            }
            group(PREPGP)
            {
                Caption = 'Preparage';
                Editable = PrepEnable;
                field("Piece Type Preparage"; Rec."Piece Type Preparage")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        FctEditableFieldsPreparage();
                    end;
                }
                field("Matter Preparage"; Rec."Matter Preparage")
                {
                    ApplicationArea = All;
                }
                field(Control1100294067; Rec.Number)
                {
                    ApplicationArea = All;
                }
                field(Control1100294068; Rec.Orientation)
                {
                    ApplicationArea = All;
                }
                field("Piercing Min."; Rec."Piercing Min.")
                {
                    Editable = PiercingEditable;
                    ApplicationArea = All;
                }
                field("Piercing Max."; Rec."Piercing Max.")
                {
                    Editable = PiercingEditable;
                    ApplicationArea = All;
                }
                field(Note; Rec.Note)
                {
                    Editable = NoteEditable;
                    ApplicationArea = All;
                }
                field("Diameter Min."; Rec."Diameter Min.")
                {
                    Editable = DiamEditable;
                    ApplicationArea = All;
                }
                field("Diameter Max."; Rec."Diameter Max.")
                {
                    Editable = DiamEditable;
                    ApplicationArea = All;
                }
                field("Thick Min."; Rec."Thick Min.")
                {
                    Editable = ThickPEditable;
                    ApplicationArea = All;
                }
                field("Thick Max."; Rec."Thick Max.")
                {
                    Editable = ThickPEditable;
                    ApplicationArea = All;
                }
                field("Width Min."; Rec."Width Min.")
                {
                    Editable = WidthEditable;
                    ApplicationArea = All;
                }
                field("Width Max."; Rec."Width Max.")
                {
                    Editable = WidthEditable;
                    ApplicationArea = All;
                }
                field("Height Min."; Rec."Height Min.")
                {
                    Editable = HeightEditable;
                    ApplicationArea = All;
                }
                field("Height Max."; Rec."Height Max.")
                {
                    Editable = HeightEditable;
                    ApplicationArea = All;
                }
                field("Width / Depth Min."; Rec."Width / Depth Min.")
                {
                    Editable = WidthDepthEditable;
                    ApplicationArea = All;
                }
                field("Width / Depth Max."; Rec."Width / Depth Max.")
                {
                    Editable = WidthDepthEditable;
                    ApplicationArea = All;
                }
            }
            group(LAEGP)
            {
                Caption = 'Lifted and ellipses';
                Editable = LiftedAndEllipsesEnable;
                field("Piece Type Lifted&Ellipses"; Rec."Piece Type Lifted&Ellipses")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        FctEditableFieldsLAndE();
                    end;
                }
                field("Matter Lifted&Ellipses"; Rec."Matter Lifted&Ellipses")
                {
                    ApplicationArea = All;
                }
                field(Control1100294073; Rec.Number)
                {
                    ApplicationArea = All;
                }
                field(Control1100294072; Rec.Orientation)
                {
                    ApplicationArea = All;
                }
                field(Angle; Rec.Angle)
                {
                    Editable = AngleEditable;
                    ApplicationArea = All;
                }
                field("Angle Min."; Rec."Angle Min.")
                {
                    Editable = AngleEditable;
                    ApplicationArea = All;
                }
                field("Angle Max."; Rec."Angle Max.")
                {
                    Editable = AngleEditable;
                    ApplicationArea = All;
                }
                field("Height Tol"; Rec."Height Tol")
                {
                    Caption = 'Height';
                    Editable = HeightTolEditable;
                    ApplicationArea = All;
                }
                field("Height Min. Tol"; Rec."Height Min. Tol")
                {
                    Caption = 'Height Min.';
                    Editable = HeightTolEditable;
                    ApplicationArea = All;
                }
                field("Height Max. Tol"; Rec."Height Max. Tol")
                {
                    Caption = 'Height Min.';
                    Editable = HeightTolEditable;
                    ApplicationArea = All;
                }
                field("Thick Tol"; Rec."Thick Tol")
                {
                    Caption = 'Thickness';
                    Editable = WidthTolEditable;
                    ApplicationArea = All;
                }
                field("Thick Min. Tol"; Rec."Thick Min. Tol")
                {
                    Caption = 'Thickness Min.';
                    Editable = WidthTolEditable;
                    ApplicationArea = All;
                }
                field("Thick Max. Tol"; Rec."Thick Max. Tol")
                {
                    Caption = 'Thickness Max.';
                    Editable = WidthTolEditable;
                    ApplicationArea = All;
                }
                field("Lg Tol"; Rec."Lg Tol")
                {
                    Caption = 'Length';
                    Editable = LgTolEditable;
                    ApplicationArea = All;
                }
                field("Lg Tol Min."; Rec."Lg Tol Min.")
                {
                    Editable = LgTolEditable;
                    ApplicationArea = All;
                }
                field("Lg Tol Max."; Rec."Lg Tol Max.")
                {
                    Editable = LgTolEditable;
                    ApplicationArea = All;
                }
                field("Diameter Tol"; Rec."Diameter Tol")
                {
                    Editable = DiamTolEditable;
                    ApplicationArea = All;
                }
                field("Diameter Tol Min."; Rec."Diameter Tol Min.")
                {
                    Editable = DiamTolEditable;
                    ApplicationArea = All;
                }
                field("Diameter Tol Max."; Rec."Diameter Tol Max.")
                {
                    Editable = DiamTolEditable;
                    ApplicationArea = All;
                }
                field("R / Arc"; Rec."R / Arc")
                {
                    Editable = RArcEditable;
                    ApplicationArea = All;
                }
                field("R / Corde"; Rec."R / Corde")
                {
                    Editable = RCordeEditable;
                    ApplicationArea = All;
                }
            }
            group(SFGP)
            {
                Caption = 'Semi-finished';
                Editable = SemiFinishedEnable;
                field("Piece Type Semi-finished"; Rec."Piece Type Semi-finished")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        FctEditableFieldsSF();
                    end;
                }
                field("Matter Semi-finished"; Rec."Matter Semi-finished")
                {
                    ApplicationArea = All;
                }
                field(Control1100294105; Rec.Number)
                {
                    ApplicationArea = All;
                }
                field(Control1100294104; Rec.Orientation)
                {
                    ApplicationArea = All;
                }
                field("Hole Tol"; Rec."Hole Tol")
                {
                    Editable = TolHoleEditable;
                    ApplicationArea = All;
                }
                field("Hole Tol Min."; Rec."Hole Tol Min.")
                {
                    Editable = TolHoleEditable;
                    ApplicationArea = All;
                }
                field("Hole Tol Max."; Rec."Hole Tol Max.")
                {
                    Editable = TolHoleEditable;
                    ApplicationArea = All;
                }
                field("External Diameter Tol"; Rec."External Diameter Tol")
                {
                    Editable = TolExtDiamEditable;
                    ApplicationArea = All;
                }
                field("External Diameter Tol Min."; Rec."External Diameter Tol Min.")
                {
                    Editable = TolExtDiamEditable;
                    ApplicationArea = All;
                }
                field("External Diameter Tol Max."; Rec."External Diameter Tol Max.")
                {
                    Editable = TolExtDiamEditable;
                    ApplicationArea = All;
                }
                field("D Min."; Rec."D Min.")
                {
                    Editable = DEditable;
                    ApplicationArea = All;
                }
                field("D Max."; Rec."D Max.")
                {
                    Editable = DEditable;
                    ApplicationArea = All;
                }
                field("Ep Min."; Rec."Ep Min.")
                {
                    Editable = EpEditable;
                    ApplicationArea = All;
                }
                field("Ep Max."; Rec."Ep Max.")
                {
                    Editable = EpEditable;
                    ApplicationArea = All;
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
                PromotedOnly= true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                    RecLDataTemplateHeader: Record "Config. Template Header";
                    RecLDefaultDimension: Record "Default Dimension";
                    RecLGeneralLedgerSetup: Record "General Ledger Setup";
                    RecLInventorySetup: Record "Inventory Setup";
                    RecLItemCrossReference: Record "Item Reference";
                    RecRef: RecordRef;
                    BooLCreateItemCrossRef: Boolean;
                    BooLInsertItem: Boolean;
                    CodLFilterToCompare: Code[20];
                    CodLFilter: Code[250];
                    IntLLoop: Integer;
                    IntLPipePosition: Integer;
                    IntLStringLenght: Integer;
                begin
                    Rec.TESTFIELD("Item Code");
                    RecGItemConfigurator.RESET();
                    RecGItemConfigurator.SETCURRENTKEY("Item Code");
                    RecGItemConfigurator.SETRANGE("Item Code", Rec."Item Code");
                    RecGItemConfigurator.SETFILTER("Entry No.", '<>%1', Rec."Entry No.");
                    IF RecGItemConfigurator.FINDSET() THEN
                        ERROR(CstGT001, Rec."Item Code");
                    RecGItem.RESET();
                    RecGItem.SETRANGE("No.", Rec."Item Code");
                    IF RecGItem.FINDSET(TRUE) THEN BEGIN
                        IF BooGNotEditable2 THEN
                            ERROR(CstGT002, Rec."Item Code");
                        FctUpdateItem();
                        BooLInsertItem := FALSE;
                        RecGItem.MODIFY(TRUE);
                    END ELSE BEGIN
                        RecGItem.INIT();
                        RecGItem."No." := Rec."Item Code";
                        BooLInsertItem := TRUE;
                        RecGItem.INSERT(TRUE);
                        COMMIT();
                        FctUpdateItem();
                        RecGItem.MODIFY(TRUE);
                        IF Rec."Item Template Code" <> '' THEN BEGIN
                            COMMIT();
                            RecGItem.GET(Rec."Item Code");
                            RecGItem.FILTERGROUP(2);
                            RecRef.GETTABLE(RecGItem);
                            RecLDataTemplateHeader.GET(Rec."Item Template Code");
                            CduGTemplateManagement.UpdateRecord(RecLDataTemplateHeader, RecRef);
                        END;
                    END;

                    IF Rec."Dimension 3 Code" <> '' THEN BEGIN
                        RecLGeneralLedgerSetup.GET();
                        IF RecLDefaultDimension.GET(DATABASE::Item, Rec."Item Code", RecLGeneralLedgerSetup."Shortcut Dimension 3 Code") THEN BEGIN
                            RecLDefaultDimension."Dimension Value Code" := Rec."Dimension 3 Code";
                            RecLDefaultDimension.MODIFY();
                        END ELSE BEGIN
                            RecLDefaultDimension."Table ID" := DATABASE::Item;
                            RecLDefaultDimension."No." := Rec."Item Code";
                            RecLDefaultDimension."Dimension Code" := RecLGeneralLedgerSetup."Shortcut Dimension 3 Code";
                            RecLDefaultDimension."Dimension Value Code" := Rec."Dimension 3 Code";
                            RecLDefaultDimension.INSERT();
                        END;
                    END;

                    //>>LAP2.12
                    RecLInventorySetup.GET();
                    RecLInventorySetup.TESTFIELD("PWD Product Group Code Dim");

                    IF Rec."Product Group Code" <> '' THEN
                        IF RecLDefaultDimension.GET(DATABASE::Item, Rec."Item Code", RecLInventorySetup."PWD Product Group Code Dim") THEN BEGIN
                            //>>TDL21072020.001
                            //RecLDefaultDimension."Dimension Value Code" := "Item Category Code"+'_'+"Product Group Code";
                            RecLDefaultDimension."Dimension Value Code" := Rec."Product Group Code";
                            //<<TDL21072020.001
                            RecLDefaultDimension.MODIFY();
                        END ELSE BEGIN
                            RecLDefaultDimension."Table ID" := DATABASE::Item;
                            RecLDefaultDimension."No." := Rec."Item Code";
                            RecLDefaultDimension."Dimension Code" := RecLInventorySetup."PWD Product Group Code Dim";
                            //>>TDL21072020.001
                            //RecLDefaultDimension."Dimension Value Code" := "Item Category Code"+'_'+"Product Group Code";
                            RecLDefaultDimension."Dimension Value Code" := Rec."Product Group Code";
                            //<<TDL21072020.001
                            RecLDefaultDimension.INSERT();
                        END;

                    BooLCreateItemCrossRef := FALSE;

                    RecLInventorySetup.TESTFIELD("PWD Item Filter For Extern Ref");
                    RecLInventorySetup.TESTFIELD("PWD LPSA Customer No.");
                    //RecLInventorySetup.TESTFIELD("STRATEGY Customer No.");

                    CodLFilter := RecLInventorySetup."PWD Item Filter For Extern Ref";
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
                        IF RecLInventorySetup."PWD STRATEGY Customer No." <> '' THEN
                            IF NOT RecLItemCrossReference.GET(RecGItem."No.",
                                                              '',
                                                              RecGItem."Base Unit of Measure",
                                                              RecLItemCrossReference."Reference Type"::Customer,
                                                              RecLInventorySetup."PWD STRATEGY Customer No.",
                                                              'NC') THEN BEGIN
                                RecLItemCrossReference.INIT();
                                RecLItemCrossReference.VALIDATE("Item No.", RecGItem."No.");
                                RecLItemCrossReference.VALIDATE("Unit of Measure", RecGItem."Base Unit of Measure");
                                RecLItemCrossReference.VALIDATE("Reference Type", RecLItemCrossReference."Reference Type"::Customer);
                                RecLItemCrossReference.VALIDATE("Reference Type No.", RecLInventorySetup."PWD STRATEGY Customer No.");
                                RecLItemCrossReference.VALIDATE("Reference No.", 'NC');
                                RecLItemCrossReference.INSERT();
                            END;
                        IF NOT RecLItemCrossReference.GET(RecGItem."No.",
                                                          '',
                                                          RecGItem."Base Unit of Measure",
                                                          RecLItemCrossReference."Reference Type"::Customer,
                                                          RecLInventorySetup."PWD LPSA Customer No.",
                                                          'NC') THEN BEGIN
                            RecLItemCrossReference.INIT();
                            RecLItemCrossReference.VALIDATE("Item No.", RecGItem."No.");
                            RecLItemCrossReference.VALIDATE("Unit of Measure", RecGItem."Base Unit of Measure");
                            RecLItemCrossReference.VALIDATE("Reference Type", RecLItemCrossReference."Reference Type"::Customer);
                            RecLItemCrossReference.VALIDATE("Reference Type No.", RecLInventorySetup."PWD LPSA Customer No.");
                            RecLItemCrossReference.VALIDATE("Reference No.", 'NC');
                            RecLItemCrossReference.INSERT();
                        END;
                    END;
                    //<<LAP2.12

                    IF BooLInsertItem THEN BEGIN
                        RecGSubFamily.GET(Rec."Family Code", Rec."Subfamily Code");
                        IF Rec."Phantom Item" THEN
                            RecGSubFamily.NumberF := RecGSubFamily.NumberF + 1
                        ELSE
                            RecGSubFamily.Number := RecGSubFamily.Number + 1;
                        RecGSubFamily.MODIFY();
                    END;

                    COMMIT();

                    CLEAR(PgeGItemCard);
                    RecGItem.RESET();
                    RecGItem.GET(Rec."Item Code");
                    PgeGItemCard.SETTABLEVIEW(RecGItem);
                    PAGE.RUNMODAL(30, RecGItem);
                end;
            }
            action(Configure)
            {
                Caption = 'Configure';
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                Image = Setup;
                trigger OnAction()
                begin
                    IF FamilyEditable THEN
                        BooGNotEditable2 := TRUE
                    ELSE
                        BooGNotEditable2 := FALSE;
                    IF NOT BooGNotEditable THEN
                        FctConfigItemCode();
                    FctConfigDes();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        FctEnableFields();
        FctEditableFields();
    end;

    trigger OnInit()
    begin
        FctEnableFields();
        FctEditableFields();
    end;

    trigger OnOpenPage()
    begin
        FctEnableFields();
        FctEditableFields();
    end;

    var
        RecGItem: Record Item;
        RecGItem2: Record Item;
        RecGItemConfigurator: Record "PWD Item Configurator";
        RecGPieceType: Record "PWD Piece Type";
        RecGSubFamily: Record "PWD SubFamily LPSA";
        CduGTemplateManagement: Codeunit "Config. Template Management";
        CdUGItemConfigurator: Codeunit "PWD Item Configurator";
        PgeGItemCard: Page "Item Card";
        [InDataSet]
        AngleEditable: Boolean;
        BooGNotEditable: Boolean;
        BooGNotEditable2: Boolean;
        [InDataSet]
        DEditable: Boolean;
        [InDataSet]
        DiamEditable: Boolean;
        [InDataSet]
        DiamTolEditable: Boolean;
        [InDataSet]
        EpEditable: Boolean;
        [InDataSet]
        ExtDiamEditable: Boolean;
        [InDataSet]
        FamilyEditable: Boolean;
        [InDataSet]
        HeightBandEditable: Boolean;
        [InDataSet]
        HeightCamberedEditable: Boolean;
        [InDataSet]
        HeightEditable: Boolean;
        [InDataSet]
        HeightTolEditable: Boolean;
        [InDataSet]
        HHGlazedEditable: Boolean;
        [InDataSet]
        HoleEditable: Boolean;
        [InDataSet]
        HoleLengthEditable: Boolean;
        [InDataSet]
        LgTolEditable: Boolean;
        [InDataSet]
        LiftedAndEllipsesEnable: Boolean;
        [InDataSet]
        NoteEditable: Boolean;
        [InDataSet]
        PhantomEditable: Boolean;
        [InDataSet]
        PiercingEditable: Boolean;
        [InDataSet]
        PrepEnable: Boolean;
        [InDataSet]
        RArcEditable: Boolean;
        [InDataSet]
        RCordeEditable: Boolean;
        [InDataSet]
        RecDiamEditable: Boolean;
        [InDataSet]
        SemiFinishedEnable: Boolean;
        [InDataSet]
        StoneEnable: Boolean;
        [InDataSet]
        SubFamilyEditable: Boolean;
        [InDataSet]
        TemplateEditable: Boolean;
        [InDataSet]
        ThickEditable: Boolean;
        [InDataSet]
        ThickPEditable: Boolean;
        [InDataSet]
        TolExtDiamEditable: Boolean;
        [InDataSet]
        TolHoleEditable: Boolean;
        [InDataSet]
        WidthDepthEditable: Boolean;
        [InDataSet]
        WidthEditable: Boolean;
        [InDataSet]
        WidthTolEditable: Boolean;
        CstGT001: Label 'Item %1 already exist.';
        CstGT002: Label 'Item %1 was created manually. Complete the item code to create a new item.';


    procedure FctEnableFields()
    begin
        StoneEnable := FALSE;
        PrepEnable := FALSE;
        LiftedAndEllipsesEnable := FALSE;
        SemiFinishedEnable := FALSE;
        CASE Rec."Product Type" OF
            Rec."Product Type"::STONE:
                BEGIN
                    StoneEnable := TRUE;
                    FctEditableFieldsStone();
                END;
            Rec."Product Type"::PREPARAGE:
                BEGIN
                    PrepEnable := TRUE;
                    FctEditableFieldsPreparage();
                END;
            Rec."Product Type"::"LIFTED AND ELLIPSES":
                BEGIN
                    LiftedAndEllipsesEnable := TRUE;
                    FctEditableFieldsLAndE();
                END;
            Rec."Product Type"::"SEMI-FINISHED":
                BEGIN
                    SemiFinishedEnable := TRUE;
                    FctEditableFieldsSF();
                END;
        END;
    end;


    procedure FctEditableFields()
    begin
        IF RecGItem2.GET(Rec."Item Code") THEN
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
        Rec.TESTFIELD("Family Code");
        Rec.TESTFIELD("Subfamily Code");
        RecGSubFamily.GET(Rec."Family Code", Rec."Subfamily Code");
        Rec."Item Code" := Rec."Family Code" + Rec."Subfamily Code";
        IF Rec."Phantom Item" THEN BEGIN
            Rec."Item Code" := Rec."Item Code" + 'F';
            TxtLNumber := FORMAT(RecGSubFamily.NumberF + 1);
            Rec."Item Code" := PADSTR(Rec."Item Code", 8 - STRLEN(TxtLNumber), '0');
            Rec."Item Code" := Rec."Item Code" + TxtLNumber;
        END ELSE BEGIN
            TxtLNumber := FORMAT(RecGSubFamily.Number + 1);
            Rec."Item Code" := PADSTR(Rec."Item Code", 8 - STRLEN(TxtLNumber), '0');
            Rec."Item Code" := Rec."Item Code" + TxtLNumber;
        END;
    end;


    procedure FctConfigDes()
    begin
        CASE Rec."Product Type" OF
            Rec."Product Type"::STONE:

                CdUGItemConfigurator.FctConfigDescStone(Rec);
            Rec."Product Type"::PREPARAGE:
                CdUGItemConfigurator.FctConfigDescPrepa(Rec);
            Rec."Product Type"::"LIFTED AND ELLIPSES":
                CdUGItemConfigurator.FctConfigDescLifted(Rec);
            Rec."Product Type"::"SEMI-FINISHED":
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
        IF RecGPieceType.GET(RecGPieceType."Option Piece Type"::Stone, Rec."Piece Type Stone") THEN BEGIN
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
            Rec.Hole := 0;
            Rec."Hole Min." := 0;
            Rec."Hole Max." := 0;
        END;
        IF NOT ExtDiamEditable THEN BEGIN
            Rec."External Diameter" := 0;
            Rec."External Diameter Min." := 0;
            Rec."External Diameter Max." := 0;
        END;
        IF NOT ThickEditable THEN BEGIN
            Rec.Thickness := 0;
            Rec."Thickness Min." := 0;
            Rec."Thickness Max." := 0;
        END;
        IF NOT RecDiamEditable THEN BEGIN
            Rec."Recess Diametre" := 0;
            Rec."Recess Diametre Min." := 0;
            Rec."Recess Diametre Max." := 0;
        END;
        IF NOT HoleLengthEditable THEN BEGIN
            Rec."Hole Length" := 0;
            Rec."Hole Length Min." := 0;
            Rec."Hole Length Max." := 0;
        END;
        IF NOT HeightBandEditable THEN BEGIN
            Rec."Height Band" := 0;
            Rec."Height Band Min." := 0;
            Rec."Height Band Max." := 0;
        END;
        IF NOT HeightCamberedEditable THEN BEGIN
            Rec."Height Cambered" := 0;
            Rec."Height Cambered Min." := 0;
            Rec."Height Cambered Max." := 0;
        END;
        IF NOT HHGlazedEditable THEN BEGIN
            Rec."Height Half Glazed" := 0;
            Rec."Height Half Glazed Min." := 0;
            Rec."Height Half Glazed Max." := 0;
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
        IF RecGPieceType.GET(RecGPieceType."Option Piece Type"::Preparage, Rec."Piece Type Preparage") THEN BEGIN
            PiercingEditable := RecGPieceType.Piercing;
            NoteEditable := RecGPieceType.Note;
            ThickPEditable := RecGPieceType.Thick;
            DiamEditable := RecGPieceType.Diameter;
            WidthEditable := RecGPieceType.Width;
            HeightEditable := RecGPieceType.Height;
            WidthDepthEditable := RecGPieceType."Width / Depth";
        END;
        IF NOT PiercingEditable THEN BEGIN
            Rec."Piercing Min." := 0;
            Rec."Piercing Max." := 0;
        END;
        IF NOT NoteEditable THEN
            Rec.Note := 0;
        IF NOT ThickPEditable THEN BEGIN
            Rec."Thick Min." := 0;
            Rec."Thick Max." := 0;
        END;
        IF NOT DiamEditable THEN BEGIN
            Rec."Diameter Min." := 0;
            Rec."Diameter Max." := 0;
        END;
        IF NOT WidthEditable THEN BEGIN
            Rec."Width Min." := 0;
            Rec."Width Max." := 0;
        END;
        IF NOT HeightEditable THEN BEGIN
            Rec."Height Min." := 0;
            Rec."Height Max." := 0;
        END;
        IF NOT WidthDepthEditable THEN BEGIN
            Rec."Width / Depth Min." := 0;
            Rec."Width / Depth Max." := 0;
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
        IF RecGPieceType.GET(RecGPieceType."Option Piece Type"::"Lifted and ellipses", Rec."Piece Type Lifted&Ellipses") THEN BEGIN
            AngleEditable := RecGPieceType.Angle;
            HeightTolEditable := RecGPieceType."Height Tol";
            WidthTolEditable := RecGPieceType."Thick Tol";
            LgTolEditable := RecGPieceType."Lg Tol";
            DiamTolEditable := RecGPieceType."Diameter Tol";
            RArcEditable := RecGPieceType."R / Arc";
            RCordeEditable := RecGPieceType."R / Corde";
        END;
        IF NOT AngleEditable THEN BEGIN
            Rec.Angle := 0;
            Rec."Angle Min." := 0;
            Rec."Angle Max." := 0;
        END;
        IF NOT HeightTolEditable THEN BEGIN
            Rec."Height Tol" := 0;
            Rec."Height Min. Tol" := 0;
            Rec."Height Max. Tol" := 0;
        END;
        IF NOT WidthTolEditable THEN BEGIN
            Rec."Thick Tol" := 0;
            Rec."Thick Min. Tol" := 0;
            Rec."Thick Max. Tol" := 0;
        END;
        IF NOT LgTolEditable THEN BEGIN
            Rec."Lg Tol" := 0;
            Rec."Lg Tol Min." := 0;
            Rec."Lg Tol Max." := 0;
        END;
        IF NOT DiamTolEditable THEN BEGIN
            Rec."Diameter Tol" := 0;
            Rec."Diameter Tol Min." := 0;
            Rec."Diameter Tol Max." := 0;
        END;
        IF NOT RArcEditable THEN
            Rec."R / Arc" := 0;
        IF NOT RCordeEditable THEN
            Rec."R / Corde" := 0;
    end;


    procedure FctEditableFieldsSF()
    begin
        TolHoleEditable := TRUE;
        TolExtDiamEditable := TRUE;
        DEditable := TRUE;
        EpEditable := TRUE;
        IF RecGPieceType.GET(RecGPieceType."Option Piece Type"::"Semi-finished", Rec."Piece Type Semi-finished") THEN BEGIN
            TolHoleEditable := RecGPieceType."Hole Tol";
            TolExtDiamEditable := RecGPieceType."Ext. Diam. Tol";
            DEditable := RecGPieceType.D;
            EpEditable := RecGPieceType.Ep;
        END;
        IF NOT TolHoleEditable THEN BEGIN
            Rec."Hole Tol" := 0;
            Rec."Hole Tol Min." := 0;
            Rec."Hole Tol Max." := 0;
        END;
        IF NOT TolExtDiamEditable THEN BEGIN
            Rec."External Diameter Tol" := 0;
            Rec."External Diameter Tol Min." := 0;
            Rec."External Diameter Tol Max." := 0;
        END;
        IF NOT DEditable THEN BEGIN
            Rec."D Min." := 0;
            Rec."D Max." := 0;
        END;
        IF NOT EpEditable THEN BEGIN
            Rec."Ep Min." := 0;
            Rec."Ep Max." := 0;
        END;
    end;


    procedure FctUpdateItem()
    begin
        RecGItem."PWD LPSA Description 1" := Rec."PWD LPSA Description 1";
        RecGItem."PWD LPSA Description 2" := Rec."PWD LPSA Description 2";
        RecGItem."PWD Quartis Description" := Rec."PWD Quartis Description";

        //>>FE_LAPIERRETTE_ART01.003
        /*
        //>>FE_LAPIERRETTE_ART01.002
        RecGItem.VALIDATE(Description,"PWD Quartis Description");
        //<<FE_LAPIERRETTE_ART01.002
        */
        RecGItem.VALIDATE(Description, COPYSTR(Rec."PWD LPSA Description 1", 1, 50));
        RecGItem.VALIDATE("Description 2", COPYSTR(Rec."PWD LPSA Description 2", 1, 50));
        //>>LAP2.12
        IF RecGItem."Search Description" = '' THEN
            //<<LAP2.12
            RecGItem.VALIDATE("Search Description", COPYSTR(Rec."PWD Quartis Description", 1, 30));
        ;
        //<<FE_LAPIERRETTE_ART01.003

        RecGItem.VALIDATE("Location Code", Rec."Location Code");
        RecGItem.VALIDATE("Shelf No.", Rec."Bin Code");
        RecGItem.VALIDATE("Item Category Code", Rec."Item Category Code");
        //TODO
        //RecGItem.VALIDATE("Product Group Code", Rec."Product Group Code");
        RecGItem.VALIDATE("Global Dimension 1 Code", Rec."Dimension 1 Code");
        RecGItem.VALIDATE("Global Dimension 2 Code", Rec."Dimension 2 Code");

        //>>FE_LAPRIERRETTE_GP0003
        RecGItem.VALIDATE("PWD Phantom Item", Rec."Phantom Item");
        //<<FE_LAPIERRETTE_GP0003

        RecGItem.VALIDATE("Replenishment System", Rec."Replenishment System");
        IF RecGItem.TestNoEntriesExist_Cost() THEN
            RecGItem.VALIDATE("Costing Method", Rec."Costing Method");
    end;
}

