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

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Option Piece Type"; "Option Piece Type")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Code"; Code)
                {
                }
                field(Description; Description)
                {
                }
                field(Hole; Hole)
                {
                    Editable = StoneEditable;
                    Visible = StoneEditable;
                }
                field("Ext. Hole"; "Ext. Hole")
                {
                    Editable = StoneEditable;
                    Visible = StoneEditable;
                }
                field(Thickness; Thickness)
                {
                    Editable = StoneEditable;
                    Visible = StoneEditable;
                }
                field("Recess Diam."; "Recess Diam.")
                {
                    Editable = StoneEditable;
                    Visible = StoneEditable;
                }
                field("Hole Lg."; "Hole Lg.")
                {
                    Editable = StoneEditable;
                    Visible = StoneEditable;
                }
                field("Height Band"; "Height Band")
                {
                    Editable = StoneEditable;
                    Visible = StoneEditable;
                }
                field("Height Cambered"; "Height Cambered")
                {
                    Editable = StoneEditable;
                    Visible = StoneEditable;
                }
                field("Height Half Glazed"; "Height Half Glazed")
                {
                    Editable = StoneEditable;
                    Visible = StoneEditable;
                }
                field(Piercing; Piercing)
                {
                    Editable = PreparageEditable;
                    Visible = PreparageEditable;
                }
                field(Note; Note)
                {
                    Editable = PreparageEditable;
                    Visible = PreparageEditable;
                }
                field(Diameter; Diameter)
                {
                    Editable = PreparageEditable;
                    Visible = PreparageEditable;
                }
                field(Thick; Thick)
                {
                    Editable = PreparageEditable;
                    Visible = PreparageEditable;
                }
                field(Width; Width)
                {
                    Editable = PreparageEditable;
                    Visible = PreparageEditable;
                }
                field(Height; Height)
                {
                    Editable = PreparageEditable;
                    Visible = PreparageEditable;
                }
                field("Width / Depth"; "Width / Depth")
                {
                    Editable = PreparageEditable;
                    Visible = PreparageEditable;
                }
                field(Angle; Angle)
                {
                    Editable = LiftedEditable;
                    Visible = LiftedEditable;
                }
                field("Height Tol"; "Height Tol")
                {
                    Editable = LiftedEditable;
                    Visible = LiftedEditable;
                }
                field("Thick Tol"; "Thick Tol")
                {
                    Editable = LiftedEditable;
                    Visible = LiftedEditable;
                }
                field("Lg Tol"; "Lg Tol")
                {
                    Editable = LiftedEditable;
                    Visible = LiftedEditable;
                }
                field("Diameter Tol"; "Diameter Tol")
                {
                    Editable = LiftedEditable;
                    Visible = LiftedEditable;
                }
                field("R / Arc"; "R / Arc")
                {
                    Editable = LiftedEditable;
                    Visible = LiftedEditable;
                }
                field("R / Corde"; "R / Corde")
                {
                    Editable = LiftedEditable;
                    Visible = LiftedEditable;
                }
                field("Hole Tol"; "Hole Tol")
                {
                    Editable = SFEditable;
                    Visible = SFEditable;
                }
                field("Ext. Diam. Tol"; "Ext. Diam. Tol")
                {
                    Editable = SFEditable;
                    Visible = SFEditable;
                }
                field(D; D)
                {
                    Editable = SFEditable;
                    Visible = SFEditable;
                }
                field(Ep; Ep)
                {
                    Editable = SFEditable;
                    Visible = SFEditable;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        FctEditableFields;
    end;

    trigger OnInit()
    begin
        FctEditableFields;
    end;

    trigger OnOpenPage()
    begin
        FctEditableFields;
    end;

    var
        [InDataSet]
        StoneEditable: Boolean;
        [InDataSet]
        PreparageEditable: Boolean;
        [InDataSet]
        LiftedEditable: Boolean;
        [InDataSet]
        SFEditable: Boolean;


    procedure FctEditableFields()
    begin
        StoneEditable := FALSE;
        PreparageEditable := FALSE;
        LiftedEditable := FALSE;
        SFEditable := FALSE;
        CASE "Option Piece Type" OF
            "Option Piece Type"::Stone:
                StoneEditable := TRUE;
            "Option Piece Type"::Preparage:
                PreparageEditable := TRUE;
            "Option Piece Type"::"Lifted and ellipses":
                LiftedEditable := TRUE;
            "Option Piece Type"::"Semi-finished":
                SFEditable := TRUE;
        END;
    end;
}

