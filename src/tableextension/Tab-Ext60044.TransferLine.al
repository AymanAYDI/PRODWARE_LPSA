tableextension 60044 "PWD TransferLine" extends "Transfer Line"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_ART02.001: NI 23/11/2011:  Désignation article 120 caracteres
    //                                           - Add field 50004..50005
    //                                           - Add C/AL in trigger "Description - OnValidate"
    //                                                                 "Description 2 - OnValidate"
    //                                                                 "LPSA Description 1 - OnValidate"
    //                                                                 "LPSA Description 2 - OnValidate"
    // 
    // ------------------------------------------------------------------------------------------------------------------
    fields
    {
        field(50004; "PWD LPSA Description 1"; Text[120])
        {
            Caption = 'LPSA Description 1';
            Description = 'LAP1.00';

            trigger OnValidate()
            begin
                //>>FE_LAPIERRETTE_ART02.001
                IF STRLEN("PWD LPSA Description 1") > 50 THEN
                    Description := PADSTR("PWD LPSA Description 1", 50)
                ELSE
                    Description := "PWD LPSA Description 1";
                //<<FE_LAPIERRETTE_ART02.001
            end;
        }
        field(50005; "PWD LPSA Description 2"; Text[120])
        {
            Caption = 'LPSA Description 2';
            Description = 'LAP1.00';

            trigger OnValidate()
            begin
                //>>FE_LAPIERRETTE_ART02.001
                IF STRLEN("PWD LPSA Description 2") > 50 THEN
                    "Description 2" := PADSTR("PWD LPSA Description 2", 50)
                ELSE
                    "Description 2" := "PWD LPSA Description 2";
                //<<FE_LAPIERRETTE_ART02.001
            end;
        }
        field(50006; "PWD Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "PWD Product Group".Code WHERE("Item Category Code" = FIELD("Item Category Code"));
        }
    }

    procedure ShowLineComments()
    var
        InvtCommentLine: Record "Inventory Comment Line";
        InvtCommentSheet: Page "Inventory Comment Sheet";
    begin
        TESTFIELD("Document No.");
        TESTFIELD("Line No.");
        InvtCommentLine.SETRANGE("Document Type", InvtCommentLine."Document Type"::"Transfer Order");
        InvtCommentLine.SETRANGE("No.", "Document No.");
        InvtCommentLine.SETRANGE("PWD Document Line No.", "Line No.");
        InvtCommentSheet.SETTABLEVIEW(InvtCommentLine);
        InvtCommentSheet.RUNMODAL();
    end;

}

