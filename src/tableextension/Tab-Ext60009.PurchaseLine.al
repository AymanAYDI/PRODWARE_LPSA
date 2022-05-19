tableextension 60009 "PWD PurchaseLine" extends "Purchase Line"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.5
    // WMS-FE04.001:GR  01/07/2011   Connector integration
    //                              - Add fields:  "WMS_Status", "WMS_Item", "WMS_Location", "WMS_Status_Header"
    //                              - Add Control on OnModify
    // 
    // //>>ProdConnect1.5
    // WMS-FE007_15.001:GR 05/07/2011 Receipt
    //                              - If WMS Location is default quantity
    //                              - If WMS Status isn't empty, the line is lock
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_ART02.001: NI 23/11/2011:  Désignation article 120 caracteres
    //                                           - Add field 50004..50005
    //                                           - Add C/AL in trigger "No. - OnValidate"
    //                                                                 "Description - OnValidate"
    //                                                                 "Description 2 - OnValidate"
    //                                                                 "LPSA Description 1 - OnValidate"
    //                                                                 "LPSA Description 2 - OnValidate"
    // 
    // //>>TDL.001
    // TDL.001: ONSITE 29/06/2012:  Modifications
    //                                           - Add Field 50006
    // 
    // TDL.LPSA: ONSITE 13/10/2014: Modification
    //                                           - Add Field 50007
    // 
    // TDL.LPSA.09.02.2015: ONSITE 09/02/2015: Modification
    //                                           - Remove status control on date modifications
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 27/06/2017 : DEMANDES DIVERSES
    //                                           - Change property InitValue = None for field 99000757
    // +----------------------------------------------------------------------------------------------------------------+
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
                    Description := PADSTR("PWD LPSA Description 2", 50)
                ELSE
                    Description := "PWD LPSA Description 2";
                //<<FE_LAPIERRETTE_ART02.001
            end;
        }
        field(50006; "PWD Gen. Account No."; Code[20])
        {
            CalcFormula = Lookup("General Posting Setup"."Purch. Account" WHERE("Gen. Bus. Posting Group" = FIELD("Gen. Bus. Posting Group"), "Gen. Prod. Posting Group" = FIELD("Gen. Prod. Posting Group")));
            Caption = 'Gen. Account No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50007; "PWD Budgeted"; Boolean)
        {
            Caption = 'Budgeted';
            Description = 'TDL.LPSA';
        }
        field(50008; "PWD Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "PWD Product Group".Code WHERE("Item Category Code" = FIELD("Item Category Code"));
        }
        field(8073282; "PWD WMS_Status"; Enum "PWD WMS_Status")
        {
            Caption = 'WMS_Status';
            Description = 'ProdConnect1.5';
        }
        field(8073283; "PWD WMS_Status_Header"; Enum "Purchase Document Status")
        {
            CalcFormula = Lookup("Purchase Header".Status WHERE("Document Type" = FIELD("Document Type"), "No." = FIELD("Document No.")));
            Caption = 'WMS_Status entête';
            Description = 'ProdConnect1.5';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8073284; "PWD WMS_Item"; Boolean)
        {
            CalcFormula = Lookup(Item."PWD WMS_Item" WHERE("No." = FIELD("No.")));
            Caption = 'WMS_Item';
            Description = 'ProdConnect1.5';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8073285; "PWD WMS_Location"; Boolean)
        {
            CalcFormula = Lookup(Location."PWD WMS_Location" WHERE(Code = FIELD("Location Code")));
            Caption = 'WMS_Location';
            Description = 'ProdConnect1.5';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8073286; "PWD WMS_Qty receipt error Base"; Decimal)
        {
            Caption = 'WMS_Quantity on Receipt Error (Base)';
            Description = 'ProdConnect1.5';
            Editable = false;
        }
        field(8073287; "PWD WMS_Reason Code Rece. Err"; Code[2])
        {
            Caption = 'WMS_Reason Code Receipt Error';
            Description = 'ProdConnect1.5';
            Editable = false;
        }
    }
    trigger OnInsert()
    begin
        "Planning Flexibility" := "Planning Flexibility"::None;
    end;


    PROCEDURE FctFromImport(BooPFromImport: Boolean);
    var
        "PWDLPSASet/GetFunctions": Codeunit "PWD LPSA Set/Get Functions.";
        BooGFromImport: Boolean;
    BEGIN
        //>>WMS-FE05.001
        BooGFromImport := BooPFromImport;
        //<<WMS-FE05.001
        "PWDLPSASet/GetFunctions".SetFctFromImport(BooGFromImport);
    END;

    PROCEDURE FctDefaultQuantityIfWMS();
    VAR
        RecLLocation: Record Location;
    BEGIN
        //>>WMS-FE05.001
        IF RecLLocation.GET("Location Code") AND RecLLocation."PWD WMS_Location" THEN BEGIN
            IF ("Document Type" = "Document Type"::Order) OR ("Document Type" = "Document Type"::Quote) THEN BEGIN
                "Qty. to Receive" := 0;
                "Qty. to Receive (Base)" := 0;
                "Qty. to Invoice" := 0;
                "Qty. to Invoice (Base)" := 0;
            END;
            IF "Document Type" = "Document Type"::"Return Order" THEN BEGIN
                "Return Qty. to Ship" := 0;
                "Return Qty. to Ship (Base)" := 0;
                "Qty. to Invoice" := 0;
                "Qty. to Invoice (Base)" := 0;
            END;
        END;
        //<<WMS-FE05.001
    END;
}

