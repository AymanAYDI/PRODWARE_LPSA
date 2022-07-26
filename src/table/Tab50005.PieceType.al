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
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Option Piece Type"; Option)
        {
            Caption = 'Option';
            OptionCaption = 'Stone,Preparage,Lifted and ellipses,Semi-finished';
            OptionMembers = Stone,Preparage,"Lifted and ellipses","Semi-finished";
            DataClassification = CustomerContent;
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(4; Hole; Boolean)
        {
            Caption = 'Hole';
            DataClassification = CustomerContent;
        }
        field(5; "Ext. Hole"; Boolean)
        {
            Caption = 'Ext. Hole';
            DataClassification = CustomerContent;
        }
        field(6; Thickness; Boolean)
        {
            Caption = 'Thickness';
            DataClassification = CustomerContent;
        }
        field(7; "Recess Diam."; Boolean)
        {
            Caption = 'Recess Diam.';
            DataClassification = CustomerContent;
        }
        field(8; "Hole Lg."; Boolean)
        {
            Caption = 'Hole Lg.';
            DataClassification = CustomerContent;
        }
        field(9; "Height Band"; Boolean)
        {
            Caption = 'Height Band';
            DataClassification = CustomerContent;
        }
        field(10; "Height Cambered"; Boolean)
        {
            Caption = 'Height Cambered';
            DataClassification = CustomerContent;
        }
        field(11; "Height Half Glazed"; Boolean)
        {
            Caption = 'Height Half Glazed';
            DataClassification = CustomerContent;
        }
        field(12; Piercing; Boolean)
        {
            Caption = 'Piercing';
            DataClassification = CustomerContent;
        }
        field(13; Note; Boolean)
        {
            Caption = 'Note';
            DataClassification = CustomerContent;
        }
        field(14; Diameter; Boolean)
        {
            Caption = 'Diameter';
            DataClassification = CustomerContent;
        }
        field(15; Thick; Boolean)
        {
            Caption = 'Thick';
            DataClassification = CustomerContent;
        }
        field(16; Width; Boolean)
        {
            Caption = 'Width';
            DataClassification = CustomerContent;
        }
        field(17; Height; Boolean)
        {
            Caption = 'Height';
            DataClassification = CustomerContent;
        }
        field(18; "Width / Depth"; Boolean)
        {
            Caption = 'Width / Depth';
            DataClassification = CustomerContent;
        }
        field(19; Angle; Boolean)
        {
            Caption = 'Angle';
            DataClassification = CustomerContent;
        }
        field(20; "Height Tol"; Boolean)
        {
            Caption = 'Height Tol';
            DataClassification = CustomerContent;
        }
        field(21; "Thick Tol"; Boolean)
        {
            Caption = 'Thickness Tol';
            DataClassification = CustomerContent;
        }
        field(22; "Lg Tol"; Boolean)
        {
            Caption = 'Width Tol';
            DataClassification = CustomerContent;
        }
        field(23; "Diameter Tol"; Boolean)
        {
            Caption = 'Diameter Tol';
            DataClassification = CustomerContent;
        }
        field(24; "R / Arc"; Boolean)
        {
            Caption = 'R / Arc';
            DataClassification = CustomerContent;
        }
        field(25; "R / Corde"; Boolean)
        {
            Caption = 'R / Corde';
            DataClassification = CustomerContent;
        }
        field(26; "Hole Tol"; Boolean)
        {
            Caption = 'Hole Tol';
            DataClassification = CustomerContent;
        }
        field(27; "Ext. Diam. Tol"; Boolean)
        {
            Caption = 'External Diameter Tol';
            DataClassification = CustomerContent;
        }
        field(28; D; Boolean)
        {
            Caption = 'D';
            DataClassification = CustomerContent;
        }
        field(29; Ep; Boolean)
        {
            Caption = 'Ep';
            DataClassification = CustomerContent;
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

