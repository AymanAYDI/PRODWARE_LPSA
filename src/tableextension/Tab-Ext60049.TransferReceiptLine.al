tableextension 60049 "PWD TransferReceiptLine" extends "Transfer Receipt Line"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_ART02.001: NI 23/11/2011:  Désignation article 120 caracteres
    //                                           - Add field 50004..50005
    // 
    // -----------------------------------------------------------------------------------------------------------------
    fields
    {
        field(50004; "PWD LPSA Description 1"; Text[120])
        {
            Caption = 'LPSA Description 1';
            Description = 'LAP1.00';
            DataClassification = CustomerContent;
        }
        field(50005; "PWD LPSA Description 2"; Text[120])
        {
            Caption = 'LPSA Description 2';
            Description = 'LAP1.00';
            DataClassification = CustomerContent;
        }
        field(50009; "PWD Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "PWD Product Group".Code WHERE("Item Category Code" = FIELD("Item Category Code"));
            DataClassification = CustomerContent;
        }
    }
    procedure ShowLineComments()
    var
        InvtCommentLine: Record "PWD Inventory Comment Line";
        InvtCommentSheet: Page "Inventory Comment Sheet";
    begin
        InvtCommentLine.SETRANGE("Document Type", InvtCommentLine."Document Type"::"Posted Transfer Receipt");
        InvtCommentLine.SETRANGE("No.", "Document No.");
        InvtCommentLine.SETRANGE("Document Line No.", "Line No.");
        InvtCommentSheet.SETTABLEVIEW(InvtCommentLine);
        InvtCommentSheet.RUNMODAL();
    end;
}

