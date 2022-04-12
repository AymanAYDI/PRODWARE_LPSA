table 50005 "PWD Piece Type"
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
    // ------------------------------------------------------------------------------------------------------------------

    Caption = 'Piece Type';

    fields
    {
        field(1; "Option Piece Type"; Option)
        {
            Caption = 'Option';
            OptionCaption = 'Stone,Preparage,Lifted and ellipses,Semi-finished';
            OptionMembers = Stone,Preparage,"Lifted and ellipses","Semi-finished";
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(4; Hole; Boolean)
        {
            Caption = 'Hole';
        }
        field(5; "Ext. Hole"; Boolean)
        {
            Caption = 'Ext. Hole';
        }
        field(6; Thickness; Boolean)
        {
            Caption = 'Thickness';
        }
        field(7; "Recess Diam."; Boolean)
        {
            Caption = 'Recess Diam.';
        }
        field(8; "Hole Lg."; Boolean)
        {
            Caption = 'Hole Lg.';
        }
        field(9; "Height Band"; Boolean)
        {
            Caption = 'Height Band';
        }
        field(10; "Height Cambered"; Boolean)
        {
            Caption = 'Height Cambered';
        }
        field(11; "Height Half Glazed"; Boolean)
        {
            Caption = 'Height Half Glazed';
        }
        field(12; Piercing; Boolean)
        {
            Caption = 'Piercing';
        }
        field(13; Note; Boolean)
        {
            Caption = 'Note';
        }
        field(14; Diameter; Boolean)
        {
            Caption = 'Diameter';
        }
        field(15; Thick; Boolean)
        {
            Caption = 'Thick';
        }
        field(16; Width; Boolean)
        {
            Caption = 'Width';
        }
        field(17; Height; Boolean)
        {
            Caption = 'Height';
        }
        field(18; "Width / Depth"; Boolean)
        {
            Caption = 'Width / Depth';
        }
        field(19; Angle; Boolean)
        {
            Caption = 'Angle';
        }
        field(20; "Height Tol"; Boolean)
        {
            Caption = 'Height Tol';
        }
        field(21; "Thick Tol"; Boolean)
        {
            Caption = 'Thickness Tol';
        }
        field(22; "Lg Tol"; Boolean)
        {
            Caption = 'Width Tol';
        }
        field(23; "Diameter Tol"; Boolean)
        {
            Caption = 'Diameter Tol';
        }
        field(24; "R / Arc"; Boolean)
        {
            Caption = 'R / Arc';
        }
        field(25; "R / Corde"; Boolean)
        {
            Caption = 'R / Corde';
        }
        field(26; "Hole Tol"; Boolean)
        {
            Caption = 'Hole Tol';
        }
        field(27; "Ext. Diam. Tol"; Boolean)
        {
            Caption = 'External Diameter Tol';
        }
        field(28; D; Boolean)
        {
            Caption = 'D';
        }
        field(29; Ep; Boolean)
        {
            Caption = 'Ep';
        }
    }

    keys
    {
        key(Key1; "Option Piece Type", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

