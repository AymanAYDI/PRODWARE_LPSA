page 50018 "PWD Item Configurator Details"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 12/09/2017 : DEMANDES DIVERSES
    //                       Add Field "Create From Item"

    Caption = 'Item Configurator Details';
    Editable = false;
    PageType = List;
    ApplicationArea = all;
    UsageCategory = Lists;
    SourceTable = "PWD Item Configurator";
    SourceTableView = WHERE("Item Code" = FILTER(<> ''));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item Code"; Rec."Item Code")
                {
                    ApplicationArea = All;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Family Code"; Rec."Family Code")
                {
                    ApplicationArea = All;
                }
                field("Subfamily Code"; Rec."Subfamily Code")
                {
                    ApplicationArea = All;
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
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
                field("PWD LPSA Description 1"; Rec."PWD LPSA Description 1")
                {
                    ApplicationArea = All;
                }
                field("PWD LPSA Description 2"; Rec."PWD LPSA Description 2")
                {
                    ApplicationArea = All;
                }
                field("Search Description"; Rec."Search Description")
                {
                    ApplicationArea = All;
                }
                field("Create From Item"; Rec."Create From Item")
                {
                    ApplicationArea = All;
                }
                field("Piece Type Stone"; Rec."Piece Type Stone")
                {
                    ApplicationArea = All;
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
                    ApplicationArea = All;
                }
                field("Hole Min."; Rec."Hole Min.")
                {
                    ApplicationArea = All;
                }
                field("Hole Max."; Rec."Hole Max.")
                {
                    ApplicationArea = All;
                }
                field("External Diameter"; Rec."External Diameter")
                {
                    ApplicationArea = All;
                }
                field("External Diameter Min."; Rec."External Diameter Min.")
                {
                    ApplicationArea = All;
                }
                field("External Diameter Max."; Rec."External Diameter Max.")
                {
                    ApplicationArea = All;
                }
                field(Thickness; Rec.Thickness)
                {
                    ApplicationArea = All;
                }
                field("Thickness Min."; Rec."Thickness Min.")
                {
                    ApplicationArea = All;
                }
                field("Thickness Max."; Rec."Thickness Max.")
                {
                    ApplicationArea = All;
                }
                field("Recess Diametre"; Rec."Recess Diametre")
                {
                    ApplicationArea = All;
                }
                field("Recess Diametre Min."; Rec."Recess Diametre Min.")
                {
                    ApplicationArea = All;
                }
                field("Recess Diametre Max."; Rec."Recess Diametre Max.")
                {
                    ApplicationArea = All;
                }
                field("Hole Length"; Rec."Hole Length")
                {
                    ApplicationArea = All;
                }
                field("Hole Length Min."; Rec."Hole Length Min.")
                {
                    ApplicationArea = All;
                }
                field("Hole Length Max."; Rec."Hole Length Max.")
                {
                    ApplicationArea = All;
                }
                field("Height Band"; Rec."Height Band")
                {
                    ApplicationArea = All;
                }
                field("Height Band Min."; Rec."Height Band Min.")
                {
                    ApplicationArea = All;
                }
                field("Height Band Max."; Rec."Height Band Max.")
                {
                    ApplicationArea = All;
                }
                field("Height Cambered"; Rec."Height Cambered")
                {
                    ApplicationArea = All;
                }
                field("Height Cambered Min."; Rec."Height Cambered Min.")
                {
                    ApplicationArea = All;
                }
                field("Height Cambered Max."; Rec."Height Cambered Max.")
                {
                    ApplicationArea = All;
                }
                field("Height Half Glazed"; Rec."Height Half Glazed")
                {
                    ApplicationArea = All;
                }
                field("Height Half Glazed Min."; Rec."Height Half Glazed Min.")
                {
                    ApplicationArea = All;
                }
                field("Height Half Glazed Max."; Rec."Height Half Glazed Max.")
                {
                    ApplicationArea = All;
                }
                field("Piece Type Preparage"; Rec."Piece Type Preparage")
                {
                    ApplicationArea = All;
                }
                field("Matter Preparage"; Rec."Matter Preparage")
                {
                    ApplicationArea = All;
                }
                field(Control1100267145; Rec.Number)
                {
                    ApplicationArea = All;
                }
                field(Control1100267144; Rec.Orientation)
                {
                    ApplicationArea = All;
                }
                field("Piercing Min."; Rec."Piercing Min.")
                {
                    ApplicationArea = All;
                }
                field("Piercing Max."; Rec."Piercing Max.")
                {
                    ApplicationArea = All;
                }
                field(Note; Note)
                {
                    ApplicationArea = All;
                }
                field("Diameter Min."; Rec."Diameter Min.")
                {
                    ApplicationArea = All;
                }
                field("Diameter Max."; Rec."Diameter Max.")
                {
                    ApplicationArea = All;
                }
                field("Thick Min."; Rec."Thick Min.")
                {
                    ApplicationArea = All;
                }
                field("Thick Max."; Rec."Thick Max.")
                {
                    ApplicationArea = All;
                }
                field("Width Min."; Rec."Width Min.")
                {
                    ApplicationArea = All;
                }
                field("Width Max."; Rec."Width Max.")
                {
                    ApplicationArea = All;
                }
                field("Height Min."; Rec."Height Min.")
                {
                    ApplicationArea = All;
                }
                field("Height Max."; Rec."Height Max.")
                {
                    ApplicationArea = All;
                }
                field("Width / Depth Min."; Rec."Width / Depth Min.")
                {
                    ApplicationArea = All;
                }
                field("Width / Depth Max."; Rec."Width / Depth Max.")
                {
                    ApplicationArea = All;
                }
                field("Piece Type Lifted&Ellipses"; Rec."Piece Type Lifted&Ellipses")
                {
                    ApplicationArea = All;
                }
                field("Matter Lifted&Ellipses"; Rec."Matter Lifted&Ellipses")
                {
                    ApplicationArea = All;
                }
                field(Control1100267127; Rec.Number)
                {
                    ApplicationArea = All;
                }
                field(Control1100267126; Rec.Orientation)
                {
                    ApplicationArea = All;
                }
                field(Angle; Rec.Angle)
                {
                    ApplicationArea = All;
                }
                field("Angle Min."; Rec."Angle Min.")
                {
                    ApplicationArea = All;
                }
                field("Angle Max."; Rec."Angle Max.")
                {
                    ApplicationArea = All;
                }
                field("Height Tol"; Rec."Height Tol")
                {
                    ApplicationArea = All;
                }
                field("Height Min. Tol"; Rec."Height Min. Tol")
                {
                    ApplicationArea = All;
                }
                field("Height Max. Tol"; Rec."Height Max. Tol")
                {
                    ApplicationArea = All;
                }
                field("Thick Tol"; Rec."Thick Tol")
                {
                    ApplicationArea = All;
                }
                field("Thick Min. Tol"; Rec."Thick Min. Tol")
                {
                    ApplicationArea = All;
                }
                field("Thick Max. Tol"; Rec."Thick Max. Tol")
                {
                    ApplicationArea = All;
                }
                field("Lg Tol"; Rec."Lg Tol")
                {
                    ApplicationArea = All;
                }
                field("Lg Tol Min."; Rec."Lg Tol Min.")
                {
                    ApplicationArea = All;
                }
                field("Lg Tol Max."; Rec."Lg Tol Max.")
                {
                    ApplicationArea = All;
                }
                field("Diameter Tol"; Rec."Diameter Tol")
                {
                    ApplicationArea = All;
                }
                field("Diameter Tol Min."; Rec."Diameter Tol Min.")
                {
                    ApplicationArea = All;
                }
                field("Diameter Tol Max."; Rec."Diameter Tol Max.")
                {
                    ApplicationArea = All;
                }
                field("R / Arc"; Rec."R / Arc")
                {
                    ApplicationArea = All;
                }
                field("R / Corde"; Rec."R / Corde")
                {
                    ApplicationArea = All;
                }
                field("Piece Type Semi-finished"; Rec."Piece Type Semi-finished")
                {
                    ApplicationArea = All;
                }
                field("Matter Semi-finished"; Rec."Matter Semi-finished")
                {
                    ApplicationArea = All;
                }
                field(Control1100267105; Rec.Number)
                {
                    ApplicationArea = All;
                }
                field(Control1100267104; Rec.Orientation)
                {
                    ApplicationArea = All;
                }
                field("Hole Tol"; Rec."Hole Tol")
                {
                    ApplicationArea = All;
                }
                field("Hole Tol Min."; Rec."Hole Tol Min.")
                {
                    ApplicationArea = All;
                }
                field("Hole Tol Max."; Rec."Hole Tol Max.")
                {
                    ApplicationArea = All;
                }
                field("External Diameter Tol"; Rec."External Diameter Tol")
                {
                    ApplicationArea = All;
                }
                field("External Diameter Tol Min."; Rec."External Diameter Tol Min.")
                {
                    ApplicationArea = All;
                }
                field("External Diameter Tol Max."; Rec."External Diameter Tol Max.")
                {
                    ApplicationArea = All;
                }
                field("D Min."; Rec."D Min.")
                {
                    ApplicationArea = All;
                }
                field("D Max."; Rec."D Max.")
                {
                    ApplicationArea = All;
                }
                field("Ep Min."; Rec."Ep Min.")
                {
                    ApplicationArea = All;
                }
                field("Ep Max."; Rec."Ep Max.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

