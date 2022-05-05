page 50008 "PWD Item Config. Setup List"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_ART01.001: TO 07/12/2011:  Configurateur article
    //                                           - Create Page
    // 
    // ------------------------------------------------------------------------------------------------------------------

    Caption = 'Editable Fields';
    PageType = ListPart;
    SourceTable = "PWD Piece Type";
    UsageCategory = none;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Option Piece Type"; Rec."Option Piece Type")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Hole; Rec.Hole)
                {
                    Editable = StoneEditable;
                    Visible = StoneEditable;
                    ApplicationArea = All;
                }
                field("Ext. Hole"; Rec."Ext. Hole")
                {
                    Editable = StoneEditable;
                    Visible = StoneEditable;
                    ApplicationArea = All;
                }
                field(Thickness; Rec.Thickness)
                {
                    Editable = StoneEditable;
                    Visible = StoneEditable;
                    ApplicationArea = All;
                }
                field("Recess Diam."; Rec."Recess Diam.")
                {
                    Editable = StoneEditable;
                    Visible = StoneEditable;
                    ApplicationArea = All;
                }
                field("Hole Lg."; Rec."Hole Lg.")
                {
                    Editable = StoneEditable;
                    Visible = StoneEditable;
                    ApplicationArea = All;
                }
                field("Height Band"; Rec."Height Band")
                {
                    Editable = StoneEditable;
                    Visible = StoneEditable;
                    ApplicationArea = All;
                }
                field("Height Cambered"; Rec."Height Cambered")
                {
                    Editable = StoneEditable;
                    Visible = StoneEditable;
                    ApplicationArea = All;
                }
                field("Height Half Glazed"; Rec."Height Half Glazed")
                {
                    Editable = StoneEditable;
                    Visible = StoneEditable;
                    ApplicationArea = All;
                }
                field(Piercing; Rec.Piercing)
                {
                    Editable = PreparageEditable;
                    Visible = PreparageEditable;
                    ApplicationArea = All;
                }
                field(Note; Rec.Note)
                {
                    Editable = PreparageEditable;
                    Visible = PreparageEditable;
                    ApplicationArea = All;
                }
                field(Diameter; Rec.Diameter)
                {
                    Editable = PreparageEditable;
                    Visible = PreparageEditable;
                    ApplicationArea = All;
                }
                field(Thick; Rec.Thick)
                {
                    Editable = PreparageEditable;
                    Visible = PreparageEditable;
                    ApplicationArea = All;
                }
                field(Width; Rec.Width)
                {
                    Editable = PreparageEditable;
                    Visible = PreparageEditable;
                    ApplicationArea = All;
                }
                field(Height; Rec.Height)
                {
                    Editable = PreparageEditable;
                    Visible = PreparageEditable;
                    ApplicationArea = All;
                }
                field("Width / Depth"; Rec."Width / Depth")
                {
                    Editable = PreparageEditable;
                    Visible = PreparageEditable;
                    ApplicationArea = All;
                }
                field(Angle; Rec.Angle)
                {
                    Editable = LiftedEditable;
                    Visible = LiftedEditable;
                    ApplicationArea = All;
                }
                field("Height Tol"; Rec."Height Tol")
                {
                    Editable = LiftedEditable;
                    Visible = LiftedEditable;
                    ApplicationArea = All;
                }
                field("Thick Tol"; Rec."Thick Tol")
                {
                    Editable = LiftedEditable;
                    Visible = LiftedEditable;
                    ApplicationArea = All;
                }
                field("Lg Tol"; Rec."Lg Tol")
                {
                    Editable = LiftedEditable;
                    Visible = LiftedEditable;
                    ApplicationArea = All;
                }
                field("Diameter Tol"; Rec."Diameter Tol")
                {
                    Editable = LiftedEditable;
                    Visible = LiftedEditable;
                    ApplicationArea = All;
                }
                field("R / Arc"; Rec."R / Arc")
                {
                    Editable = LiftedEditable;
                    Visible = LiftedEditable;
                    ApplicationArea = All;
                }
                field("R / Corde"; Rec."R / Corde")
                {
                    Editable = LiftedEditable;
                    Visible = LiftedEditable;
                    ApplicationArea = All;
                }
                field("Hole Tol"; Rec."Hole Tol")
                {
                    Editable = SFEditable;
                    Visible = SFEditable;
                    ApplicationArea = All;
                }
                field("Ext. Diam. Tol"; Rec."Ext. Diam. Tol")
                {
                    Editable = SFEditable;
                    Visible = SFEditable;
                    ApplicationArea = All;
                }
                field(D; Rec.D)
                {
                    Editable = SFEditable;
                    Visible = SFEditable;
                    ApplicationArea = All;
                }
                field(Ep; Rec.Ep)
                {
                    Editable = SFEditable;
                    Visible = SFEditable;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        FctEditableFields();
    end;

    trigger OnInit()
    begin
        FctEditableFields();
    end;

    trigger OnOpenPage()
    begin
        FctEditableFields();
    end;

    var
        [InDataSet]
        LiftedEditable: Boolean;
        [InDataSet]
        PreparageEditable: Boolean;
        [InDataSet]
        SFEditable: Boolean;
        [InDataSet]
        StoneEditable: Boolean;


    procedure FctEditableFields()
    begin
        StoneEditable := FALSE;
        PreparageEditable := FALSE;
        LiftedEditable := FALSE;
        SFEditable := FALSE;
        CASE Rec."Option Piece Type" OF
            Rec."Option Piece Type"::Stone:
                StoneEditable := TRUE;
            Rec."Option Piece Type"::Preparage:
                PreparageEditable := TRUE;
            Rec."Option Piece Type"::"Lifted and ellipses":
                LiftedEditable := TRUE;
            Rec."Option Piece Type"::"Semi-finished":
                SFEditable := TRUE;
        END;
    end;
}

