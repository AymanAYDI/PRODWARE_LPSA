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
    SourceTable = "PWD Item Configurator";
    SourceTableView = WHERE(Item Code=FILTER(<>''));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item Code"; "Item Code")
                {
                }
                field("Entry No."; "Entry No.")
                {
                }
                field("Family Code"; "Family Code")
                {
                }
                field("Subfamily Code"; "Subfamily Code")
                {
                }
                field("Product Type"; "Product Type")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Item Category Code"; "Item Category Code")
                {
                }
                field("Product Group Code"; "Product Group Code")
                {
                }
                field("PWD LPSA Description 1"; "PWD LPSA Description 1")
                {
                }
                field("PWD LPSA Description 2"; "PWD LPSA Description 2")
                {
                }
                field("Search Description"; "Search Description")
                {
                }
                field("Create From Item"; "Create From Item")
                {
                }
                field("Piece Type Stone"; "Piece Type Stone")
                {
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
                }
                field("Hole Min."; "Hole Min.")
                {
                }
                field("Hole Max."; "Hole Max.")
                {
                }
                field("External Diameter"; "External Diameter")
                {
                }
                field("External Diameter Min."; "External Diameter Min.")
                {
                }
                field("External Diameter Max."; "External Diameter Max.")
                {
                }
                field(Thickness; Thickness)
                {
                }
                field("Thickness Min."; "Thickness Min.")
                {
                }
                field("Thickness Max."; "Thickness Max.")
                {
                }
                field("Recess Diametre"; "Recess Diametre")
                {
                }
                field("Recess Diametre Min."; "Recess Diametre Min.")
                {
                }
                field("Recess Diametre Max."; "Recess Diametre Max.")
                {
                }
                field("Hole Length"; "Hole Length")
                {
                }
                field("Hole Length Min."; "Hole Length Min.")
                {
                }
                field("Hole Length Max."; "Hole Length Max.")
                {
                }
                field("Height Band"; "Height Band")
                {
                }
                field("Height Band Min."; "Height Band Min.")
                {
                }
                field("Height Band Max."; "Height Band Max.")
                {
                }
                field("Height Cambered"; "Height Cambered")
                {
                }
                field("Height Cambered Min."; "Height Cambered Min.")
                {
                }
                field("Height Cambered Max."; "Height Cambered Max.")
                {
                }
                field("Height Half Glazed"; "Height Half Glazed")
                {
                }
                field("Height Half Glazed Min."; "Height Half Glazed Min.")
                {
                }
                field("Height Half Glazed Max."; "Height Half Glazed Max.")
                {
                }
                field("Piece Type Preparage"; "Piece Type Preparage")
                {
                }
                field("Matter Preparage"; "Matter Preparage")
                {
                }
                field(Control1100267145; Number)
                {
                }
                field(Control1100267144; Orientation)
                {
                }
                field("Piercing Min."; "Piercing Min.")
                {
                }
                field("Piercing Max."; "Piercing Max.")
                {
                }
                field(Note; Note)
                {
                }
                field("Diameter Min."; "Diameter Min.")
                {
                }
                field("Diameter Max."; "Diameter Max.")
                {
                }
                field("Thick Min."; "Thick Min.")
                {
                }
                field("Thick Max."; "Thick Max.")
                {
                }
                field("Width Min."; "Width Min.")
                {
                }
                field("Width Max."; "Width Max.")
                {
                }
                field("Height Min."; "Height Min.")
                {
                }
                field("Height Max."; "Height Max.")
                {
                }
                field("Width / Depth Min."; "Width / Depth Min.")
                {
                }
                field("Width / Depth Max."; "Width / Depth Max.")
                {
                }
                field("Piece Type Lifted&Ellipses"; "Piece Type Lifted&Ellipses")
                {
                }
                field("Matter Lifted&Ellipses"; "Matter Lifted&Ellipses")
                {
                }
                field(Control1100267127; Number)
                {
                }
                field(Control1100267126; Orientation)
                {
                }
                field(Angle; Angle)
                {
                }
                field("Angle Min."; "Angle Min.")
                {
                }
                field("Angle Max."; "Angle Max.")
                {
                }
                field("Height Tol"; "Height Tol")
                {
                }
                field("Height Min. Tol"; "Height Min. Tol")
                {
                }
                field("Height Max. Tol"; "Height Max. Tol")
                {
                }
                field("Thick Tol"; "Thick Tol")
                {
                }
                field("Thick Min. Tol"; "Thick Min. Tol")
                {
                }
                field("Thick Max. Tol"; "Thick Max. Tol")
                {
                }
                field("Lg Tol"; "Lg Tol")
                {
                }
                field("Lg Tol Min."; "Lg Tol Min.")
                {
                }
                field("Lg Tol Max."; "Lg Tol Max.")
                {
                }
                field("Diameter Tol"; "Diameter Tol")
                {
                }
                field("Diameter Tol Min."; "Diameter Tol Min.")
                {
                }
                field("Diameter Tol Max."; "Diameter Tol Max.")
                {
                }
                field("R / Arc"; "R / Arc")
                {
                }
                field("R / Corde"; "R / Corde")
                {
                }
                field("Piece Type Semi-finished"; "Piece Type Semi-finished")
                {
                }
                field("Matter Semi-finished"; "Matter Semi-finished")
                {
                }
                field(Control1100267105; Number)
                {
                }
                field(Control1100267104; Orientation)
                {
                }
                field("Hole Tol"; "Hole Tol")
                {
                }
                field("Hole Tol Min."; "Hole Tol Min.")
                {
                }
                field("Hole Tol Max."; "Hole Tol Max.")
                {
                }
                field("External Diameter Tol"; "External Diameter Tol")
                {
                }
                field("External Diameter Tol Min."; "External Diameter Tol Min.")
                {
                }
                field("External Diameter Tol Max."; "External Diameter Tol Max.")
                {
                }
                field("D Min."; "D Min.")
                {
                }
                field("D Max."; "D Max.")
                {
                }
                field("Ep Min."; "Ep Min.")
                {
                }
                field("Ep Max."; "Ep Max.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

